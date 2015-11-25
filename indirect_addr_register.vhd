library IEEE;
use IEEE.std_logic_1164.all;

entity indirect_addr_register is
    port (
        clk, en_A, ld, reset: in STD_LOGIC;
        aBus: out STD_LOGIC_VECTOR(15 downto 0);
        dBus:  in STD_LOGIC_VECTOR(15 downto 0)
    );
end indirect_addr_register;

architecture iarArch of indirect_addr_register is
signal iarReg: STD_LOGIC_VECTOR(15 downto 0);
begin
  process(clk) begin
  	if clk'event and clk = '1' then
  		if reset = '1' then
  			iarReg <= x"0000";
  		elsif ld = '1' then
  			iarReg <= dBus;
  		end if;
  	end if;
  end process;
  aBus <= iarReg when en_A = '1' else
  	  "ZZZZZZZZZZZZZZZZ";
end iarArch;