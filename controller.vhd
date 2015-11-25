library IEEE;
use IEEE.std_logic_1164.all;

entity controller is
    port (
    	clk, reset:			in  STD_LOGIC;
    	mem_enD, mem_rw: 		out STD_LOGIC;
    	pc_enA, pc_ld, pc_inc: 		out STD_LOGIC;

    	ir_enA, ir_enD, ir_ld: 		out STD_LOGIC;
    	ir_load, ir_store, ir_copy: 	in STD_LOGIC;
    	ir_add, ir_sub, ir_negate: 	in STD_LOGIC;
      ir_shiftL, ir_shiftR: 		in STD_LOGIC;
      ir_halt, ir_brZero, ir_brLess:	in STD_LOGIC;
      ir_brGtr, ir_branch:		in STD_LOGIC;
      ir_treg, ir_areg:		in STD_LOGIC_VECTOR(1 downto 0);
      ir_breg, ir_amode: 		in STD_LOGIC_VECTOR(1 downto 0);

    	iar_enA, iar_ld: 		out STD_LOGIC;

    	rf_enD, rf_ld, rf_selALU: 	out STD_LOGIC;
      rf_target, rf_srcA: 		out STD_LOGIC_VECTOR(1 downto 0);
      rf_srcB, rf_srcD: 		out STD_LOGIC_VECTOR(1 downto 0);

    	alu_regZ, alu_regLZ: 		in  STD_LOGIC;
    	alu_op: 			out STD_LOGIC_VECTOR(2 downto 0)
    );
end controller;

architecture controllerArch of controller is
type state_type is (	reset_state,
			fetch0, fetch1,
			load0, load1, load2, load3,
			store0, store1, store2, store3,
			copy0, copy1,
			add0, add1,
			sub0, sub1,
			negate0, negate1,
			shiftL0, shiftL1,
			shiftR0, shiftR1,
			halt,
			brZero0, brZero1,
			brLess0, brLess1,
			brGtr0, brGtr1,
			branch0, branch1
			);
signal state: state_type;

begin
  process(clk) begin
  	if clk'event and clk = '1' then
  		if reset = '1' then state <= reset_state;
    		else
    			case state is
    			when reset_state => state <= fetch0;
    			when fetch0 => state <= fetch1;
	  		when fetch1 =>
	  			if    ir_load    = '1' then state <= load0;
	  			elsif ir_store   = '1' then state <= store0;
	  			elsif ir_copy    = '1' then state <= copy0;
	  			elsif ir_add     = '1' then state <= add0;
	  			elsif ir_sub     = '1' then state <= sub0;
	  			elsif ir_negate  = '1' then state <= negate0;
	  			elsif ir_shiftL  = '1' then state <= shiftL0;
	  			elsif ir_shiftR  = '1' then state <= shiftR0;
	  			elsif ir_halt    = '1' then state <= halt;
	  			elsif ir_brZero  = '1' then state <= brZero0;
	  			elsif ir_brLess  = '1' then state <= brLess0;
	  			elsif ir_brGtr   = '1' then state <= brGtr0;
	  			elsif ir_branch  = '1' then state <= branch0;
	  			end if;

  			when load0 => 	state <= load1;
  			when load1 => 	if ir_amode = "10" then state <= load2;
  					else state <= fetch0;
  					end if;
  			when load2 => 	state <= load3;
	  		when load3 =>	state <= fetch0;

  			when store0 => 	state <= store1;
  			when store1 => 	if ir_amode = "10" then state <= store2;
  					else state <= fetch0;
  					end if;
  			when store2 => 	state <= store3;
	  		when store3 =>	state <= fetch0;

  			when copy0 => 	state <= copy1;
  			when copy1 => 	state <= fetch0;

  			when add0 => 	state <= add1;
  			when add1 => 	state <= fetch0;

  			when sub0 => 	state <= sub1;
  			when sub1 => 	state <= fetch0;

  			when negate0 => state <= negate1;
  			when negate1 => state <= fetch0;

  			when shiftL0 => state <= shiftL1;
  			when shiftL1 => state <= fetch0;

  			when shiftR0 => state <= shiftR1;
  			when shiftR1 => state <= fetch0;

  			when halt => 	state <= halt;

  			when brZero0 => state <= brZero1;
  			when brZero1 => state <= fetch0;

  			when brLess0 => state <= brLess1;
  			when brLess1 => state <= fetch0;

  			when brGtr0 => state <= brGtr1;
  			when brGtr1 => state <= fetch0;

  			when branch0 => state <= branch1;
  			when branch1 => state <= fetch0;

  			when others => 	state <= halt;
  			end case;
  		end if;
  	end if;
  end process;
  process(clk) begin -- special process for memory write timing
  	if clk'event and clk = '0' then
  		if (ir_amode = "01" and state = store0) or
  		    state = store2 then
  			mem_rw <= '0';
  		else
  			mem_rw <= '1';
  		end if;
  	end if;
  end process;

  mem_enD <= '1'   when state =  fetch0 or state =  fetch1 or

  			((ir_amode = "01" or ir_amode = "10") and
  			 (state =   load0 or state =   load1 or
  			  state =   load2 or state =   load3)) or

  			(ir_amode = "10" and
  			(state =  store0 or state =   store1))

  		   else '0';

  pc_enA <= '1'    when state =  fetch0 or state = fetch1
  		   else '0';

  pc_ld <= '1'	   when state = branch0 or
  			(state = brZero0 and alu_regZ = '1') or
  			(state = brLess0 and alu_regLZ = '1') or
  			(state = brGtr0  and alu_regZ = '0' and alu_regLZ = '0')
  		   else '0';

  pc_inc <= '1'	   when state = fetch1
  		   else '0';

  ir_enA <= '1'	   when ((state = load0 or state =   load1) and ir_amode /= "00") or
  			state =  store0 or state =  store1
  		   else '0';

  ir_enD <= '1'	   when state = branch0 or state = brZero0 or
  			state = brLess0 or state = brGtr0 or
  			((state = load0 or state = load1) and ir_amode = "00")
  		   else '0';

  ir_ld <= '1'	   when state = fetch1
  		   else '0';

  iar_enA <= '1'   when state = load2 or state = load3 or
  			state = store2 or state = store3
  		   else '0';

  iar_ld <= '1'	   when (state =  load1 and ir_amode = "10") or
  			(state = store1 and ir_amode = "10")
  		   else '0';

  rf_enD <= '1'  when (ir_amode = "01" and (state =  store0 or state =  store1)) or
  		      (ir_amode = "10" and (state =  store2 or state =  store3))
  		 else '0';

  rf_ld <= '1'   when (ir_amode = "00" and state =  load1) or
  		      (ir_amode = "01" and state =  load1) or
  		      (ir_amode = "10" and state =  load3) or
  	 	      state = copy1 or state = add1 or state = sub1 or
  		      state = negate1 or state = shiftL1 or state = shiftR1
  		  else '0';

  rf_selAlu <='1' when state = copy1 or state = add1 or state = sub1 or
  		       state = negate1 or state = shiftL1 or state = shiftR1
  		   else '0';

  rf_target <= ir_treg;
  rf_srcA <= ir_areg;
  rf_srcB <= ir_breg;
  rf_srcD <= ir_treg;

  alu_op <= 	"000"   when state =   copy0 or state =   copy1 else
  	    	"001"   when state = negate0 or state = negate1 else
  	 	"010"   when state =    add0 or state =    add1 else
  		"011"   when state =    sub0 or state =    sub1 else
  	 	"100"   when state = shiftL0 or state = shiftL1 else
  	  	"101"   when state = shiftR0 or state = shiftR1 else
  	    	"000";
end controllerArch;
