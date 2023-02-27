library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 8-to-1 Multiplexer with Tri-State

entity mux8 is
	port (	
		data : in std_logic_vector (7 downto 0);
		address : in std_logic_vector (2 downto 0);
		y : out std_logic
		);
end entity mux8;

architecture rtl of mux8 is
begin
	with address select y <=
		data(0) when "000",
		data(1) when "001",
		data(2) when "010",
		data(3) when "011",
		data(4) when "100",
		data(5) when "101",
		data(6) when "110",
		data(7) when "111",
		'Z' when others;
	
	--y <= data(to_integer(unsigned(address)));
end rtl;