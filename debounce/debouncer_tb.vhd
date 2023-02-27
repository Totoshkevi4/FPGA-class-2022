library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all;
use std.env.finish;

entity debouncer_tb is
end debouncer_tb;

architecture sim of debouncer_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    constant delay          : natural := 10;
    constant skipped_cycles : natural := clk_hz * delay / 1000;

    signal clk_tb  : std_logic := '0';
    signal sig_in_tb  : std_logic := '0';
    signal sig_out_tb  : std_logic;

begin

    clk_tb <= not clk_tb after clk_period / 2;

    DUT : entity work.debouncer(rtl)
    generic map(
        skipped_cycles => skipped_cycles
    )
    port map (
        clk  => clk_tb,
        sig_in  => sig_in_tb,

        sig_out  => sig_out_tb       
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
        wait for (delay/ 10) * 1 ms;
        
        for i in 1 to 10 loop
            sig_in_tb <= '1';
            wait for rand_real(50.0, 500.0) * 1 us;
            sig_in_tb <= '0';
            wait for rand_real(50.0, 500.0) * 1 us;
        end loop;
        
        wait for delay * 1 ms;
        finish;
    end process;

end architecture;