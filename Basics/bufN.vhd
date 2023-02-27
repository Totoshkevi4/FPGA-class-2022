library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N-bit Buffer with Tri-State

entity bufN is
    generic (  
        N : integer := 5
        );
    port (
        x : in std_logic_vector (N-1 downto 0);
        en     : in std_logic;
        y : out std_logic_vector (N-1 downto 0)
        );
end entity bufN;	

architecture rtl of bufN is  
constant z_vect : std_logic_vector (N-1 downto 0) := (others => 'Z');
begin
    y <= x when en else z_vect;
end rtl;