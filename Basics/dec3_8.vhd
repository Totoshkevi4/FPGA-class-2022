library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 3-to-8 Decoder with Tri-State

entity dec3_8 is
    port (
        in_signal  : in std_logic_vector (2 downto 0);
        enable     : in std_logic;
        out_signal : out std_logic_vector (7 downto 0)
    );
end entity dec3_8;

architecture rtl of dec3_8 is  
signal one : unsigned (7 downto 0) := 8ub"1";    
begin

-- w/o enable signal
--with in_signal select out_signal <=
--    "00000001" when "000",
--    "00000010" when "001",
--    "00000100" when "010",
--    "00001000" when "011",
--    "00010000" when "100",
--    "00100000" when "101",
--    "01000000" when "110",
--    "10000000" when "111",
--    "ZZZZZZZZ" when others;

-- out_signal <= (std_logic_vector(shift_left(one, to_integer(unsigned(in_signal))))) when (enable = '1') else (others => 'Z');
out_signal <=  std_logic_vector(one sll to_integer(unsigned(in_signal))) when (enable = '1') else (others => 'Z'); 
    
--out_signal <= (to_integer(unsigned(in_signal)) => '1', others => '0') when (enable = '1') else (others => 'Z');

--with enable select out_signal <=
--    (to_integer(unsigned(in_signal)) => '1', others => '0') when '1',
--    'Z' when '0';
    
end rtl;