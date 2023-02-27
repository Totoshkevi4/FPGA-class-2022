library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity ATmega16_ALU_tb is
end ATmega16_ALU_tb;

architecture sim of ATmega16_ALU_tb is

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk_tb : std_logic := '1';
    signal rst_tb : std_logic := '1';
    
    -- SREG = I_T_H_S_V_N_Z_C
    signal SREG_tb : std_logic_vector(7 downto 0);
    
    signal I_tb : std_logic := SREG_tb(7);
    signal T_tb : std_logic := SREG_tb(6);
    signal H_tb : std_logic := SREG_tb(5);
    signal S_tb : std_logic := SREG_tb(4);
    signal V_tb : std_logic := SREG_tb(3);
    signal N_tb : std_logic := SREG_tb(2);
    signal Z_tb : std_logic := SREG_tb(1);
    signal C_tb : std_logic := SREG_tb(0);

begin

    clk_tb <= not clk_tb after clk_period / 2;
    
    I_tb <= SREG_tb(7);
    T_tb <= SREG_tb(6);
    H_tb <= SREG_tb(5);
    S_tb <= SREG_tb(4);
    V_tb <= SREG_tb(3);
    N_tb <= SREG_tb(2);
    Z_tb <= SREG_tb(1);
    C_tb <= SREG_tb(0);

    DUT : entity work.ATmega16_ALU(rtl)
    port map (
        clk => clk_tb,
        rst => rst_tb,
        
        SREG => SREG_tb
    );

    SEQUENCER_PROC : process
    begin
        wait for clk_period * 2;
        rst_tb <= '0';
        wait for clk_period * 10;
        
        rst_tb <= '1';
        wait for clk_period * 2;
        rst_tb <= '0';
        wait for clk_period * 10;
        
        finish;
    end process;

end architecture;