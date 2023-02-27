library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

use std.textio.all;
use std.env.finish;

use work.tools.all;

entity tools_tb is
end tools_tb;

architecture sim of tools_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;
    constant INT_MAX : integer := 256;
    
    constant TEST : integer := 32;
    signal TEST_SLV : std_logic_vector (log2(TEST)-1 downto 0) := (others => '0');

    signal clk_tb : std_logic := '1';

    signal int_in  : integer range 1 to INT_MAX;
    signal int_out : integer;

begin

    clk_tb <= not clk_tb after clk_period / 2;

    SEQUENCER_PROC : process        
    begin
        report "Start" severity warning;

        for i in 1 to INT_MAX loop
            int_in  <= i; 
            wait for 1 fs;
            int_out <= log2(int_in);
            wait for clk_period/2;
            assert int_out = integer(ceil(log2(real(int_in))))
                report "in: " & to_string(int_in) &
                    "; out: " & to_string(int_out) &
                    "; should be: " & to_string(integer(ceil(log2(real(int_in)))))
                severity error;
        end loop;
        
        report "Finish" severity warning;
        finish;
    end process;

end architecture;