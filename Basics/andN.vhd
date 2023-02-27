library ieee;
use ieee.std_logic_1164.all;

-- AND for N-bit vector

entity andN is
    generic (  
        N : integer := 5
        );
    port (
        x : in std_logic_vector (N-1 downto 0);
        y : out std_logic
    );
end entity andN;

architecture rtl of andN is
    constant true_vect : std_logic_vector (N-1 downto 0) := (others => '1');	    
begin
    y <= '1' when (x = true_vect) else '0';
end rtl;