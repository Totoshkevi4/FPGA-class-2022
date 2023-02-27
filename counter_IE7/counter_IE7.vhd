library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_IE7 is
    generic (
        N : integer := 4 
        );
    port (
        rst : in std_logic;
        Sn  : in std_logic;
        inc : in std_logic;
        dec : in std_logic;
        D   : in std_logic_vector(N - 1 downto 0);

        Q  : out std_logic_vector(N - 1 downto 0);
        CR : out std_logic := '1';
        BR : out std_logic := '1'
    );
end counter_IE7;

architecture rtl of counter_IE7 is
begin
    IE7 : process(rst, inc, dec, Sn)
        variable max : std_logic_vector(N-1 downto 0) := (others => '1');
        variable min : std_logic_vector(N-1 downto 0) := (others => '0');
    begin
        -- Incrementing --------------------------
        if rising_edge(inc) and dec = '1' then
            -- reset overflow flag
            CR <= '1';
            -- Overflow check and counter increment 
            if Q < max then
                Q <= std_logic_vector(unsigned(Q) + 1);
            else
                Q <= min;
            end if;
        end if;
        
        -- Setting overflow bit on falling edge
        if falling_edge(inc) and Q = max then
            CR <= '0';
        end if;
        
        -- Decrementing --------------------------
        if rising_edge(dec) and inc = '1' then
            -- reset overflow flag
            BR <= '1';
            -- Overflow check and counter decrement 
            if Q > min then
                Q <= std_logic_vector(unsigned(Q) - 1);
            else
                Q <= max;
            end if;
        end if;
        
        -- Setting overflow bit on falling edge
        if falling_edge(dec) and Q = min then
            BR <= '0';
        end if;
  
        -- Parallel load -------------------------
        if Sn = '0' then
            Q <= D;
        end if;

        -- Reset ---------------------------------
        if rst = '1' then
            Q <= (others => '0');
        end if;   

    end process;
end architecture;