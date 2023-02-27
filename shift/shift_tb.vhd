library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity shift_tb is
    generic(
        N : integer := 4
    );
end shift_tb;

architecture sim of shift_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic;
    signal en_tb  : std_logic;

    signal serial_in_tb    : std_logic := '0';
    signal parallel_out_tb : std_logic_vector(N-1 downto 0);

    signal test_inp : std_logic_vector (N downto 0);

begin

    clk_tb <= not clk_tb after clk_period / 2;

    SHIFT : entity work.shift(rtl)
    generic map (
        N => N
    )
    port map (
        clk => clk_tb,
        rst => rst_tb,
        en  => en_tb,
        
        serial_in    => serial_in_tb,
        parallel_out => parallel_out_tb
    );

    SIM : process
        variable test_input : std_logic_vector (N downto 0);
        variable test_output : std_logic_vector (N-1 downto 0);
    begin
        report "Start" severity warning;

        for i in 0 to 2**(N+1) - 1 loop
            -- turning off reset pin
            rst_tb <= '0';
            
            -- using couter as test input
            -- test_input = (not en) & serial_in(N-1) & serial_in(N-2) & ...
            test_input := std_logic_vector(to_unsigned(i, N+1));
            
            test_inp <=   test_input;
            en_tb  <= test_input(test_input'high);
            wait until rising_edge(clk_tb); 
            
            -- shifting serial_in(N-1) to serial_in(0)
            for j in 0 to N-1 loop
                serial_in_tb <= test_input(N-1 -j);               
                wait for CLK_PERIOD;
            end loop;
            
            -- Assigning correct output
            if not en_tb then
                test_output := (others => 'Z');
            else
                if rst_tb then
                    test_output := (others => '0');
                else
                    test_output := test_input(N-1 downto 0);
                end if;
            end if;
            
            wait until clk_tb'event;
            
            -- Checking for equality
            assert test_output = parallel_out_tb
            report "in: " & to_string(test_input(N-1 downto 0)) &
                "; out: " & to_string(parallel_out_tb) &
                "; should be: " & to_string(test_output)
            severity error;
            
            -- Resetting register
            rst_tb <= '1';
            wait for CLK_PERIOD;
        end loop;

        report "Finish" severity warning;
        finish;
    end process;

end architecture;