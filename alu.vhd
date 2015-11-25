library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity alu is
    port (
        op: in STD_LOGIC_VECTOR(2 downto 0);
        rf_BusA, rf_BusB: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: in STD_LOGIC_VECTOR(15 downto 0);
        rf_BusR: out STD_LOGIC_VECTOR(15 downto 0);
        regZ, regLZ: out STD_LOGIC
    );
end alu;

architecture aluArch of alu is
signal zeros: STD_LOGIC_VECTOR(15 downto 0);
begin
  zeros <= x"0000";
  rf_BusR <= rf_BusA 				when op = "000" else
  	    (not rf_BusA) + '1'			when op = "001" else
  	    rf_BusA + rf_BusB 			when op = "010" else
  	    rf_BusA - rf_BusB 			when op = "011" else
  	    
  	    rf_BusA                               when op="100" and rf_BusB=x"0000" else
  	    rf_BusA(14 downto 0)          & "0"   when op="100" and rf_BusB=x"0001" else 
  	    rf_BusA(13 downto 0)          & "00"  when op="100" and rf_BusB=x"0002" else 
  	    rf_BusA(12 downto 0)          & "000" when op="100" and rf_BusB=x"0003" else 
  	    rf_BusA(11 downto 0) &   x"0"         when op="100" and rf_BusB=x"0004" else
  	    rf_BusA(10 downto 0) &   x"0" &   "0" when op="100" and rf_BusB=x"0005" else
  	    rf_BusA( 9 downto 0) &   x"0" &  "00" when op="100" and rf_BusB=x"0006" else
  	    rf_BusA( 8 downto 0) &   x"0" & "000" when op="100" and rf_BusB=x"0007" else
  	    rf_BusA( 7 downto 0) &  x"00"         when op="100" and rf_BusB=x"0008" else
  	    rf_BusA( 6 downto 0) &  x"00" &   "0" when op="100" and rf_BusB=x"0009" else
  	    rf_BusA( 5 downto 0) &  x"00" &  "00" when op="100" and rf_BusB=x"000a" else
  	    rf_BusA( 4 downto 0) &  x"00" & "000" when op="100" and rf_BusB=x"000b" else
  	    rf_BusA( 3 downto 0) & x"000"         when op="100" and rf_BusB=x"000c" else
  	    rf_BusA( 2 downto 0) & x"000" &   "0" when op="100" and rf_BusB=x"000d" else
  	    rf_BusA( 1 downto 0) & x"000" &  "00" when op="100" and rf_BusB=x"000e" else
  	    rf_BusA( 0 downto 0) & x"000" & "000" when op="100" and rf_BusB=x"000f" else
  	    	    
  	               "0" & rf_BusA(15 downto  1) when op="101" and rf_BusB=x"0001" else
  	              "00" & rf_BusA(15 downto  2) when op="101" and rf_BusB=x"0002" else
  	             "000" & rf_BusA(15 downto  3) when op="101" and rf_BusB=x"0003" else
  	    x"0"           & rf_BusA(15 downto  4) when op="101" and rf_BusB=x"0004" else
  	    x"0"   & "0"   & rf_BusA(15 downto  5) when op="101" and rf_BusB=x"0005" else
  	    x"0"   & "00"  & rf_BusA(15 downto  6) when op="101" and rf_BusB=x"0006" else
  	    x"0"   & "000" & rf_BusA(15 downto  7) when op="101" and rf_BusB=x"0007" else
  	    x"00"          & rf_BusA(15 downto  8) when op="101" and rf_BusB=x"0008" else
  	    x"00"  & "0"   & rf_BusA(15 downto  9) when op="101" and rf_BusB=x"0009" else
  	    x"00"  & "00"  & rf_BusA(15 downto 10) when op="101" and rf_BusB=x"000a" else
  	    x"00"  & "000" & rf_BusA(15 downto 11) when op="101" and rf_BusB=x"000b" else
  	    x"000"         & rf_BusA(15 downto 12) when op="101" and rf_BusB=x"000c" else
  	    x"000" & "0"   & rf_BusA(15 downto 13) when op="101" and rf_BusB=x"000d" else
  	    x"000" & "00"  & rf_BusA(15 downto 14) when op="101" and rf_BusB=x"000e" else
  	    x"000" & "000" & rf_BusA(15 downto 15) when op="101" and rf_BusB=x"000f" else
  	    	    
  	    x"0000";
  regZ  <= '1' when rf_BusA = x"0000" else '0';
  regLZ <= rf_BusA(15);
end aluArch;