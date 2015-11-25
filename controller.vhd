library IEEE;
use IEEE.std_logic_1164.all;

entity controller is
    port (
    	clk, reset:			in  STD_LOGIC;
		mem_enD, mem_rw: 		out STD_LOGIC;
    	pc_enA, pc_ld, pc_inc: 		out STD_LOGIC;
		ir_enA, ir_enD, ir_ld:		in STD_LOGIC;
		ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop:		out STD_LOGIC;
	);
end controller;

architecture controllerArch of controller is
type state_type is (	reset_state,
			fetch0, fetch1,
			load0, load1, load2, load3,
			store0, store1, store2, store3,
			move0, move1,
			add0, add1,
			mul0, mul1,
			jmp0, jmp1,
			bne0, bne1,
			stop0
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
			if ir_load = '1' then state <= load0;
			elsif ir_store = '1' then state <= store0;
			elsif ir_move = '1' then state <= move0;
			elsif ir_add = '1' then state <= add0;
			elsif ir_mul = '1' then state <= mul0;
			elsif ir_jmp = '1' then state <= jmp0;
			elsif ir_bne = '1' then state <= bne0;
			elsif ir_stop = '1' then state <= stop0;
			end if;
		end if;
	end if;
  end process;
  
end controllerArch;