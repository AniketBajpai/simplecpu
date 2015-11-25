library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ram is
    port (
        r_w, en, reset: in STD_LOGIC;
        aBus: in STD_LOGIC_VECTOR(15 downto 0);
        dBus: inout STD_LOGIC_VECTOR(15 downto 0)
    );
end ram;

architecture ramArch of ram is
type ram_typ is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal ram: ram_typ;
begin
  process(reset, r_w) begin
  	if reset = '1' then
  		ram(0) <= x"0821";
  		ram(1) <= x"5820";
  		ram(2) <= x"0001";
  		ram(3) <= x"8560";
  		ram(4) <= x"6420";
 		ram(5) <= x"84c0";
  		ram(6) <= x"81f4";
 		ram(7) <= x"82f0";
  		ram(8) <= x"8350";
  		ram(9) <= x"e40d";
  		ram(10) <= x"e80c";
  		ram(11) <= x"f00d";
  		ram(12) <= x"f008";
  		ram(13) <= x"8f00";
  	elsif r_w'event and r_w = '0' then
  		ram(conv_integer(unsigned(aBus))) <= dBus;
  	end if;
  end process;
  dBus <= ram(conv_integer(unsigned(aBus)))
  		when reset = '0' and en = '1' and r_w = '1' else
	  "ZZZZZZZZZZZZZZZZ";
end ramArch;
