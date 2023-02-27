library ieee;
use ieee.std_logic_1164.all;

-- AND or OR for 4-bit vectors with Tri-State (structural) 

entity and_or_4z is
    generic (  
        N : integer := 4
        );
    port (
        x : in std_logic_vector (N-1 downto 0);
        function_select : in std_logic;
        enable : in std_logic;
        y : out std_logic
        );
end entity and_or_4z;

architecture struct of and_or_4z is	
    signal buf_input : std_logic_vector (3 downto 0);
    signal buf_output : std_logic_vector (3 downto 0);
begin  
    
    and_or_4 : entity work.and_or_4 (struct)
    generic map (  
        N => N
        )
    port map (
        x => x,
        function_select => function_select,  
        y => buf_input(0)
        );
    
    buf4 : entity work.buf4 (rtl)
    port map (
        in_signal => buf_input,
        enable => enable,
        out_signal => buf_output
        );
    
    y <= buf_output(0);
    
end struct;