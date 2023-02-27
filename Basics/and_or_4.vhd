library ieee;
use ieee.std_logic_1164.all;

-- AND or OR for 4-bit vectors (structural)

entity and_or_4 is
    generic (  
        N : integer := 4
        );
    port (
        x : in std_logic_vector (N-1 downto 0);
        function_select : in std_logic;
        y : out std_logic
        );
end entity and_or_4;

architecture struct of and_or_4 is	
    signal or_output : std_logic;
    signal and_output : std_logic;
begin  
    
    andN : entity work.andN (rtl)
    generic map (  
        N => N
        )
    port map (
        x => x,
        y => and_output
        );
    
    orN : entity work.orN (rtl)
    generic map (  
        N => N
        )
    port map (
        x => x,
        y => or_output
        );
        
    y <= and_output when function_select else or_output;
end struct;