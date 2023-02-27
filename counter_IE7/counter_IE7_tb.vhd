library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity counter_IE7_tb is
    generic (
        N : integer := 4 
        );
end counter_IE7_tb;

architecture sim of counter_IE7_tb is

    constant clk_hz : integer := 20e6;
    constant clk_period : time := 1 sec / clk_hz;
    signal clk_tb : std_logic := '0';

    signal rst_tb : std_logic;
    signal Sn_tb  : std_logic := '1';
    signal inc_tb : std_logic := '1';
    signal dec_tb : std_logic := '1';
    signal D_tb   : std_logic_vector(N - 1 downto 0) := "1101";

    signal Q_tb  : std_logic_vector(N - 1 downto 0);
    signal CR_tb : std_logic := '1';
    signal BR_tb : std_logic := '1';

begin

    clk_tb <= not clk_tb after clk_period / 2;

    DUT : entity work.counter_IE7(rtl)
    generic map (
        N => N
        )
    port map (
        rst => rst_tb,
        Sn  => Sn_tb,
        inc => inc_tb,
        dec => dec_tb,
        D   => D_tb,

        Q  => Q_tb,
        CR => CR_tb,
        BR => BR_tb
    );

    SEQUENCER_PROC : process
    begin
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait for 2 * clk_period;

        for i in 0 to 2 loop
            inc_tb <= '0';
            wait for clk_period/2;
            inc_tb <= '1';
            wait for clk_period/2;
        end loop;

        Sn_tb <= '0';
        wait for clk_period;
        Sn_tb <= '1';
        wait until rising_edge(clk_tb);

        for i in 0 to 3 loop
            inc_tb <= '0';
            wait for clk_period/2;
            inc_tb <= '1';
            wait for clk_period/2;
        end loop;

        for i in 0 to 3 loop
            dec_tb <= '0';
            wait for clk_period/2;
            dec_tb <= '1';
            wait for clk_period/2;
        end loop;

        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait until rising_edge(clk_tb);

        for i in 0 to 3 loop
            dec_tb <= '0';
            wait for clk_period/2;
            dec_tb <= '1';
            wait for clk_period/2;
        end loop;

        finish;
    end process;

end architecture;