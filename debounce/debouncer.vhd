library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic (
        -- number of waiting cycles = CLK frequency * delay (in ms) / 10000
        skipped_cycles : natural := 50000000 * 10 / 1000
    );
    port (
        clk     : in std_logic;
        sig_in  : in std_logic;
        sig_out : out std_logic := '0'
    );
end debouncer;

architecture rtl of debouncer is
    signal cnt : integer := 0; 
begin
    DEBOUNCE : process(clk)
    begin
        if rising_edge(clk) then

            if (0 < cnt) and (cnt <= skipped_cycles) then
                sig_out <= '1';
                cnt <= cnt + 1;
            else
                sig_out <= '0';
                cnt <= 0;
            end if;

            if (cnt = 0) and (sig_in = '1') then
                sig_out <= '1';
                cnt <= cnt + 1;
            end if;
            
        end if;
    end process;
end architecture;