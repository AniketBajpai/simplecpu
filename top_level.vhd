library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port (
        clk, reset:			in  STD_LOGIC;
        abusX: 				out STD_LOGIC_VECTOR(15 downto 0);
        dbusX: 				out STD_LOGIC_VECTOR(15 downto 0);
        mem_enDX, mem_rwX: 		out STD_LOGIC;
        pc_enAX, pc_ldX, pc_incX:	out STD_LOGIC;
        ir_enAX, ir_enDX, ir_ldX:	out STD_LOGIC;
        ir_tregX, ir_aregX, ir_bregX:	out STD_LOGIC_VECTOR(2 downto 0);
        ir_amodeX:			out STD_LOGIC_VECTOR(2 downto 0);
        ir_regX: 			out STD_LOGIC_VECTOR(15 downto 0);
        iar_enAX, iar_ldX:		out STD_LOGIC;
        rf_enDX, rf_ldX, rf_selAluX:	out STD_LOGIC;
        rf_targetX, rf_srcAX:		out STD_LOGIC_VECTOR(1 downto 0);
        rf_srcBX, rf_srcDX:		out STD_LOGIC_VECTOR(1 downto 0);
        r0, r1, r2, r3:			out STD_LOGIC_VECTOR(15 downto 0);
        alu_regZX, alu_regLZX:		out STD_LOGIC;
        alu_opX:			out STD_LOGIC_VECTOR(2 downto 0)
    );
end top_level;

architecture topArch of top_level is

component program_counter
    port (
        clk, en_A, ld, inc, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus: in STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component instruction_register
    port (
        clk, en_A, en_D, ld, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        load, store, copy, add, sub, negate: out STD_LOGIC;
        shiftL, shiftR, halt, brZero, brLess: out STD_LOGIC;
        brGtr, branch: out STD_LOGIC;
        treg, areg, breg, amode: out STD_LOGIC_VECTOR(1 downto 0);
        irRegX: out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component indirect_addr_register
    port (
        clk, en_A, ld, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus:  in STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component regFile
    port (
        clk, en_D, ld, selALU, reset: in STD_LOGIC;
        target, srcA, srcB, srcD: in STD_LOGIC_VECTOR(1 downto 0);
        ALUbusR: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0);
        ALUbusA, ALUbusB: out STD_LOGIC_VECTOR(15 downto 0);
        r0, r1, r2, r3: out STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component alu
    port (
       	op: in STD_LOGIC_VECTOR(2 downto 0);
        rf_BusA, rf_BusB: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: in STD_LOGIC_VECTOR(15 downto 0);
        rf_busR: out STD_LOGIC_VECTOR(15 downto 0);
        regZ, regLZ: out STD_LOGIC
    );
end component;

component ram
    port (
        r_w, en, reset: in STD_LOGIC;
        aBus: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0)
    );
end component;

component controller
    port (
    	clk, reset:			in  STD_LOGIC;
    	mem_enD, mem_rw: 		out STD_LOGIC;
    	pc_enA, pc_ld, pc_inc: 		out STD_LOGIC;

    	ir_enA, ir_enD, ir_ld: 		out STD_LOGIC;
    	ir_load, ir_store, ir_copy:	in STD_LOGIC;
    	ir_add, ir_sub, ir_negate: 	in STD_LOGIC;
      ir_shiftL, ir_shiftR: 		in STD_LOGIC;
      ir_halt, ir_brZero, ir_brLess:	in STD_LOGIC;
      ir_brGtr, ir_branch:		in STD_LOGIC;
      ir_treg, ir_areg: 		in STD_LOGIC_VECTOR(1 downto 0);
      ir_breg, ir_amode: 		in STD_LOGIC_VECTOR(1 downto 0);

    	iar_enA, iar_ld: 		out STD_LOGIC;

    	rf_enD, rf_ld, rf_selALU: 	out STD_LOGIC;
      rf_target, rf_srcA: 		out STD_LOGIC_VECTOR(1 downto 0);
      rf_srcB, rf_srcD: 		out STD_LOGIC_VECTOR(1 downto 0);

    	alu_regZ, alu_regLZ: 		in  STD_LOGIC;
    	alu_op: 			out STD_LOGIC_VECTOR(2 downto 0)
    );
end component;

signal	abus: 				STD_LOGIC_VECTOR(15 downto 0);
signal	dbus: 				STD_LOGIC_VECTOR(15 downto 0);
signal	mem_enD, mem_rw: 		STD_LOGIC;
signal	pc_enA, pc_ld, pc_inc:		STD_LOGIC;
signal	ir_enA, ir_enD, ir_ld:		STD_LOGIC;
signal	ir_load, ir_store, ir_copy:	STD_LOGIC;
signal	ir_add, ir_sub, ir_negate:	STD_LOGIC;
signal	ir_shiftL, ir_shiftR:		STD_LOGIC;
signal	ir_halt, ir_brZero, ir_brLess:	STD_LOGIC;
signal	ir_brGtr, ir_branch:		STD_LOGIC;
signal	ir_treg, ir_areg: 		STD_LOGIC_VECTOR(1 downto 0);
signal  ir_breg, ir_amode: 		STD_LOGIC_VECTOR(1 downto 0);
signal	iar_enA, iar_ld:		STD_LOGIC;
signal	rf_enD, rf_ld, rf_selAlu:	STD_LOGIC;
signal	rf_target, rf_srcA, rf_srcB:	STD_LOGIC_VECTOR(1 downto 0);
signal	rf_srcD:			STD_LOGIC_VECTOR(1 downto 0);
signal	rf_busA, rf_busB:		STD_LOGIC_VECTOR(15 downto 0);
signal	alu_op:				STD_LOGIC_VECTOR(2 downto 0);
signal	alu_regZ, alu_regLZ:		STD_LOGIC;
signal	alu_busR:			STD_LOGIC_VECTOR(15 downto 0);

begin

  pc: program_counter port map(clk, pc_enA, pc_ld, pc_inc, reset, abus, dbus);

  ir: instruction_register port map(clk, ir_enA, ir_enD, ir_ld, reset, abus, dbus,
  					 ir_load, ir_store, ir_copy, ir_add,
  					 ir_sub, ir_negate, ir_shiftL, ir_shiftR,
  					 ir_halt, ir_brZero, ir_brLess,
  					 ir_brGtr, ir_branch,
  					 ir_treg, ir_areg, ir_breg, ir_amode,
  					 ir_regX);

  iar: indirect_addr_register port map(clk, iar_enA, iar_ld, reset, abus, dbus);

  rf: regFile port map(clk, rf_enD, rf_ld, rf_selAlu, reset,
  			rf_target, rf_srcA, rf_srcB, rf_srcD,
  			alu_busR, dBus, rf_busA, rf_busB, r0, r1, r2, r3);

  aluu: alu port map(alu_op, rf_BusA, rf_BusB, dBus,
  			alu_BusR, alu_regZ, alu_regLZ);
  
  mem: ram port map(mem_rw, mem_enD, reset, abus, dbus);

  ctl: controller port map(clk, reset, mem_enD, mem_rw, pc_enA, pc_ld, pc_inc,
  				ir_enA, ir_enD, ir_ld,
  				ir_load, ir_store, ir_copy, ir_add,
  				ir_sub, ir_negate, ir_shiftL, ir_shiftR,
  				ir_halt, ir_brZero, ir_brLess,
  				ir_brGtr, ir_branch,
  				ir_treg, ir_areg, ir_breg, ir_amode,
  				iar_enA, iar_ld,
  				rf_enD, rf_ld, rf_selAlu,
  				rf_target, rf_srcA, rf_srcB, rf_srcD,
  				alu_regZ, alu_regLZ, alu_op);

   abusX <= abus;
   dbusX <= dbus;

   mem_enDX <= mem_enD;
   mem_rwX <= mem_rw;

   pc_enAX <= pc_enA;
   pc_ldX <= pc_ld;
   pc_incX <= pc_inc;

   ir_enAX <= ir_enA;
   ir_enDX <= ir_enD;
   ir_ldX <= ir_ld;

   iar_enAX <= iar_enA;
   iar_ldX <= iar_ld;

   rf_enDX <= rf_enD;
   rf_ldX <= rf_ld;
   rf_selAluX <= rf_selAlu;
   rf_targetX <= rf_target;
   rf_srcAX <= rf_srcA;
   rf_srcBX <= rf_srcB;
   rf_srcDX <= rf_srcD;

   alu_opX <= alu_op;
   alu_regZX <= alu_regZ;
   alu_regLZX <= alu_regLZ;
end topArch;
