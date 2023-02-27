library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multi_pulse is
    generic (
        N : natural := 5 
    );
    port (
        clk  : in std_logic;
        sig  : in std_logic;
        slct : in std_logic_vector(1 downto 0);
        len  : in std_logic_vector(N-1 downto 0);
        pls  : buffer std_logic
        );
end multi_pulse;

architecture rtl of multi_pulse is
    constant skip_ccl : natural := 50000000 * 10 / 1000;

    signal deb_sig : std_logic;
    signal q : std_logic_vector(1 downto 0);
    
    signal flag_rise  : std_logic := '0';
    signal flag_fall  : std_logic := '0';
    
    signal cnt : integer;
    
begin
    DBNC: entity work.debouncer(rtl)
    generic map (
        skipped_cycles => skip_ccl
    )
    port map (
        clk  => clk,
        sig_in  => sig,
        sig_out => deb_sig     
    );
    
    -- Trigger for posedge/negedge detector
    FLIP_FLOP : process(clk)  
    begin
        if rising_edge(clk) then
            q <= q(0) & deb_sig;
        end if;
    end process;
    
    -- posedge
    flag_rise <= (not q(1)) and q(0)    ;
    -- negedge
    flag_fall <= (not q(0)) and q(1);     

    SIG_GEN : process(clk)
        variable cnt_proc : natural := 0;
    begin
        if rising_edge(clk) then
            case slct is
                when "00" => 
                    if flag_rise = '1' then
                        cnt_proc := 2*to_integer(unsigned(len)) - 1;
                        pls <= not pls;
                    elsif cnt_proc > 0 then
                        cnt_proc := cnt - 1;
                        pls <= not pls;
                    else
                        pls <= '0';
                    end if;
                    
                when "01" =>
                    if flag_fall = '1' then
                        cnt_proc := 2*to_integer(unsigned(len)) - 1;
                        pls <= not pls;
                    elsif cnt_proc > 0 then
                        cnt_proc := cnt - 1;
                        pls <= not pls;
                    else
                        pls <= '0';
                    end if;
                    
                when "10" =>
                    if flag_rise = '1' or flag_fall = '1' then
                        cnt_proc := 2*to_integer(unsigned(len)) - 1;
                        pls <= not pls;
                    elsif cnt_proc > 0 then
                        cnt_proc := cnt - 1;
                        pls <= not pls;
                    else
                        pls <= '0';
                    end if;
                     
                    
                when others =>
                    pls <= '0';
                    cnt_proc := 0;
            end case;
            cnt <= cnt_proc;
        end if;
    end process;
    
end architecture;