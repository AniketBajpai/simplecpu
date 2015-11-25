library IEEE;
use IEEE.std_logic_1164.all;

entity instruction_register is
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
end instruction_register;

architecture irArch of instruction_register is
signal irReg: STD_LOGIC_VECTOR(15 downto 0);
begin
  process(clk) begin
  	if clk'event and clk = '0' then
  		if reset = '1' then
  			irReg <= x"0000";
  		elsif ld = '1' then
  			irReg <= dBus;
  		end if;
  	end if;
  end process;
  
  aBus <= "000000" & irReg(9 downto 0) when en_A = '1' else
  	  "ZZZZZZZZZZZZZZZZ";
  dBus <= "000000" & irReg(9 downto 0) when en_D = '1' else
  	  "ZZZZZZZZZZZZZZZZ";
  	  
  load    <= '1' when irReg(15 downto 14) = "00" 	else '0';
  store   <= '1' when irReg(15 downto 14) = "01" 	else '0';
  copy    <= '1' when irReg(15 downto 8)  = x"80" 	else '0';
  add     <= '1' when irReg(15 downto 8)  = x"81" 	else '0';
  sub     <= '1' when irReg(15 downto 8)  = x"82" 	else '0';
  negate  <= '1' when irReg(15 downto 8)  = x"83" 	else '0';
  shiftL  <= '1' when irReg(15 downto 8)  = x"84" 	else '0';
  shiftR  <= '1' when irReg(15 downto 8)  = x"85" 	else '0';
  halt    <= '1' when irReg(15 downto 8)  = x"8f" 	else '0';
  brZero  <= '1' when irReg(15 downto 12) = x"c" 	else '0';
  brLess  <= '1' when irReg(15 downto 12) = x"d" 	else '0';
  brGtr   <= '1' when irReg(15 downto 12) = x"e" 	else '0';
  branch  <= '1' when irReg(15 downto 12) = x"f" 	else '0';

  treg	  <= irReg(11 downto 10) when irReg(15) = '0' else
             irReg( 7 downto  6) when irReg(15 downto 12) = x"8" else
             "00";
  areg	  <= irReg( 5 downto  4) when irReg(15 downto 14) = "10" else
             irReg(11 downto 10) when irReg(15 downto 14) = "11" else
             "00";
  breg	  <= irReg( 3 downto  2) when irReg(15 downto 14) = "10" else
             "00";
  amode   <= irReg(13 downto 12); 				     
end irArch;