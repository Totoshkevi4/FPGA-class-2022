library ieee;                
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Binary OR for 2 vectors N x 1

entity or_vect_n is	 
	generic (
		N : natural := 5
	);
    port (
        x1 : in bit_vector (N-1 downto 0);
        x2 : in bit_vector (N-1 downto 0);
        f  : out bit_vector (N-1 downto 0)
    );
end or_vect_n;

architecture rtl of or_vect_n is
begin  
	f <= x1 or x2;
end rtl;