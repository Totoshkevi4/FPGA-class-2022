library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  

use ieee.math_real.ceil;
use ieee.math_real.floor;
use ieee.math_real.log2;

use std.textio.all;
use std.env.finish;

entity penc_tb is
    generic(
        N : integer := 4;
        M : integer := integer(ceil(log2(real(N))))
        );
end penc_tb;

architecture sim of penc_tb is
    
    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;
    
    signal clk_tb : std_logic := '0';
    
    signal sig_in_tb  : std_logic_vector(N-1 downto 0);
    signal en_tb      : std_logic;
    signal enc_out_tb : std_logic_vector(M-1 downto 0);
    
begin
    
    clk_tb <= not clk_tb after clk_period / 2;
    
    PENC : entity work.penc(rtl)
    generic map (
        N => N,
        M => M
        )
    port map (        
        sig_in  => sig_in_tb,
        en      => en_tb,
        enc_out => enc_out_tb
        );
    
    SIM : process
        variable test_input  : std_logic_vector(N downto 0)          := (others => '0');
        variable sig_out     : std_logic_vector(M-1 downto 0);
        variable log_sig_out : integer range 2**M - 1 downto 0       := 0;
    begin
        report "Start" severity warning;
        
        for i in 0 to (2**(N + 1) - 1) loop   
            
            -- Using counter as input value
            test_input := std_logic_vector(to_unsigned(i, N + 1));
            -- MSB is enable bit, other bits are data inputs
            (en_tb, sig_in_tb) <= test_input; 
            
            wait for CLK_PERIOD;
            
            -- checking if penc is enabled or all inputs are '0'
            if to_integer(unsigned(sig_in_tb)) = 0 or en_tb = '0' then
                sig_out := (others => 'Z'); 
            else
            -- cutting away "en" bit from counter then taking log2 of rest bits
            -- and rounding it down
                log_sig_out := integer(floor(log2(real(i mod 2**N))));
                sig_out     := std_logic_vector(to_unsigned(log_sig_out, M));  
            end if; 
            
            wait for CLK_PERIOD;
            
            assert enc_out_tb = sig_out
                report "in: " & to_string(sig_in_tb) &
                    "; out: " & to_string(enc_out_tb) &
                    "; should be: " & to_string(sig_out)
            severity error;
            
        end loop;
        
        report "Finish" severity warning;
        finish;
    end process;
    
end architecture;