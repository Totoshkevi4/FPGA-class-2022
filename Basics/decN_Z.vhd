library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N-to-2**N decoder with Tri-State

entity decN_Z is 
    generic (  
        N       : integer := 5;
        out_num : integer := 2 ** N
        );
    port (	
        in_signal  : in std_logic_vector (N-1 downto 0);
        enable     : in std_logic;
        out_signal : out std_logic_vector (out_num-1 downto 0)
        );
end entity decN_Z;

architecture rtl of decN_Z is  
    signal one : unsigned (out_num-1 downto 0) := (others => '0');	
begin
    one <= one(one'high downto 1) & '1';
    out_signal <=  std_logic_vector(one sll to_integer(unsigned(in_signal))) when (enable = '1') else (others => 'Z');
end rtl;