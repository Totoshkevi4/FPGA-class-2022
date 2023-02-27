library ieee;
use ieee.std_logic_1164.all;

-- 1-bit Full Adder

entity full_adder_1 is
    port (
        a         : in std_logic;
        b         : in std_logic;
        carry_in  : in std_logic;
        sum       : out std_logic;
        carry_out : out std_logic
        );
end entity full_adder_1;

architecture rtl of full_adder_1 is	    
begin
    sum       <= a xor b xor carry_in;
    carry_out <= (a and b) or ((a xor b) and carry_in);
end rtl;
