library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity buf4 is
    generic(
        constant N : integer := 4
    );
	port (	
		in_signal  : in std_logic_vector (N-1 downto 0);
		enable     : in std_logic;
		out_signal : out std_logic_vector (N-1 downto 0)
		);
end entity buf4;	

architecture rtl of buf4 is  
    constant SIG_Z : std_logic_vector (N-1 downto 0) := (others => 'Z');
begin
	out_signal <= in_signal when enable else SIG_Z;
	
--	with enable select out_signal <= 
--        in_signal when '1',
--		"ZZZZ" when others;
end rtl;