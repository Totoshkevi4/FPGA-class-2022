library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Serial2Parallel N-bit Shift Register

entity shift is
    generic (
        N : integer := 4 
        );
    port (
        clk : in std_logic;
        
        en  : in std_logic;
        rst : in std_logic;
        
        serial_in  : in std_logic;
        parallel_out : out std_logic_vector(N-1 downto 0)
        );
end shift;

architecture rtl of shift is 
    
begin
    shift_reg : process(clk, en)  
        -- Internal register (flip-flop)
        variable int_reg : std_logic_vector(N-1 downto 0) := (others => '0');
    begin                              
        if en = '1' then 
            -- Shift register is front-triggered
            if rising_edge(clk) then
                if rst = '1' then
                    -- Sinchronous reset
                    int_reg := (others => '0');
                else 
                    -- Shifting int_reg to left and concatenating input bit
                    int_reg := int_reg(int_reg'high - 1 downto int_reg'low) & serial_in;
                end if;  
            end if;    
            
            -- Outputting internal register value
            parallel_out <= int_reg;
        else
            -- If shift register is not enabled, then 'Z' on output
            parallel_out <= (others => 'Z');   
        end if;
    end process;
    
end architecture;