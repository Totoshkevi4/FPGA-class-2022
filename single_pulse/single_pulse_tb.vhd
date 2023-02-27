library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.uniform;

use std.textio.all;
use std.env.finish;

entity single_pulse_tb is
end single_pulse_tb;

architecture sim of single_pulse_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk_tb  : std_logic := '1';
    signal sig_tb  : std_logic := '0';
    signal slct_tb : std_logic_vector(1 downto 0);
    signal pls_tb  : std_logic;

begin

    clk_tb <= not clk_tb after clk_period / 2;

    DUT : entity work.single_pulse(rtl)
    port map (
        clk  => clk_tb,
        sig  => sig_tb,
        slct => slct_tb,

        pls  => pls_tb       
    );

    SEQUENCER_PROC : process
        variable seed1 : integer := 100;
        variable seed2 : integer := 999;

        impure function rand_real(min_val, max_val : real) return real is
            variable r : real;
        begin
            uniform(seed1, seed2, r);
            return r * (max_val - min_val) + min_val;
        end function;
    begin
        for i in 0 to 2 loop
            slct_tb <= std_logic_vector(to_unsigned(i mod 4, 2));
            wait until rising_edge(clk_tb);
            
            for i in 1 to 10 loop
                sig_tb <= '1';
                wait for rand_real(50.0, 500.0) * 1 us;
                sig_tb <= '0';
                wait for rand_real(50.0, 500.0) * 1 us;
            end loop;
            wait for 10 ms;
            
        end loop;
        finish;
    end process;

end architecture;