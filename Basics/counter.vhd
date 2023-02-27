library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- N-bit Incrementing Counter Wih Sinchronous Load

entity counter is
    generic (
        N : integer := 4 
        );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        en          : in std_logic;
        parallel_en : in std_logic;
        parallel_in : in  std_logic_vector(N-1 downto 0);
        cnt         : out std_logic_vector(N-1 downto 0)
        );
end counter;

architecture rtl of counter is
    
begin
    counter : process(en, clk)
        variable int_reg : std_logic_vector(N-1 downto 0) := (others => '0');
        variable max : std_logic_vector(N-1 downto 0) := (others => '1');
    begin
        -- Asinchronous start
        if en = '1' then
            if rising_edge(clk) then
                -- Sincronous load
                if parallel_en = '1' then
                    int_reg := parallel_in;
                end if;
                
                -- Overflow check and counter increment 
                if int_reg < max then
                    int_reg := std_logic_vector(unsigned(int_reg)+1);
                else
                    int_reg := (others => '0');
                end if;                    
                
                -- Sinchronous reset
                if rst = '1' then
                    int_reg := (others => '0');
                end if;
            end if;
            cnt <= int_reg;
        else
            cnt <= (others => 'Z');
        end if;        
    end process;
    
end architecture;