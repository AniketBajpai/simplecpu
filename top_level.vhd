library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port (
        clk, reset:			in  STD_LOGIC;
        abusX: 				out STD_LOGIC_VECTOR(15 downto 0);
        dbusX: 				out STD_LOGIC_VECTOR(15 downto 0);
        pc_enAX, pc_ldX, pc_incX:	out STD_LOGIC;
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
        load, store, move, add, mul, jmp, bne, stop : out STD_LOGIC
    );
end component;


signal	abus: 				STD_LOGIC_VECTOR(15 downto 0);
signal	dbus: 				STD_LOGIC_VECTOR(15 downto 0);
signal	pc_enA, pc_ld, pc_inc:		STD_LOGIC;
signal	ir_enA, ir_enD, ir_ld:		STD_LOGIC;
signal	ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop:	STD_LOGIC;

begin

  pc: program_counter port map(clk, pc_enA, pc_ld, pc_inc, reset, abus, dbus);
  
  ir: instruction_register port map(clk, ir_enA, ir_enD, ir_ld, reset, abus, dbus, ir_load, ir_store, ir_move, ir_add, ir_mul, ir_jmp, ir_bne, ir_stop);

   abusX <= abus;
   dbusX <= dbus;
   
   pc_enAX <= pc_enA;
   pc_ldX <= pc_ld;
   pc_incX <= pc_inc;
   
   ir_enAX <= ir_enA;
   ir_enDX <= ir_enD;
   ir_ldX <= ir_ld;

end topArch;