library ieee;
use ieee.std_logic_1164.all;

-- 4-bit Full Adder

entity sum4 is
    port (
        a         : in std_logic_vector (3 downto 0);
        b         : in std_logic_vector (3 downto 0);
        carry_in  : in std_logic;
        sum       : out std_logic_vector (3 downto 0);
        carry_out : out std_logic
        );
end entity sum4;

architecture struct of sum4 is  
    
    signal carry_1 : std_logic;
    signal carry_2 : std_logic;
    signal carry_3 : std_logic;
    
begin
    
    full_adder_0 : entity work.full_adder_1 (rtl)
    port map (
        a         => a(0),
        b         => b(0),
        carry_in  => carry_in,
        sum       => sum(0),
        carry_out => carry_1
        );
    
        full_adder_1 : entity work.full_adder_1 (rtl)
        port map (
            a         => a(1),
            b         => b(1),
            carry_in  => carry_1,
            sum       => sum(1),
            carry_out => carry_2
            );
        
        full_adder_2 : entity work.full_adder_1 (rtl)
        port map (    
            a         => a(2),
            b         => b(2),
            carry_in  => carry_2,
            sum       => sum(2),
            carry_out => carry_3
            );
        
        full_adder_3 : entity work.full_adder_1 (rtl)
        port map (
            a         => a(3),
            b         => b(3),
            carry_in  => carry_3,
            sum       => sum(3),
            carry_out => carry_out
            );
    
    
end struct;