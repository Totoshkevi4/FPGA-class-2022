library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- N-to-log2(N) Priority Encoder

entity penc is
    generic(
        --number of inputs
        N : integer := 4;
        --number of outputs is log2 of inputs
        M : integer := integer(ceil(log2(real(N))))
        );
    port (
        sig_in  : in std_logic_vector(N-1 downto 0);
        en      : in std_logic;
        enc_out : out std_logic_vector(M-1 downto 0)
        );
end penc;

architecture rtl of penc is
    
begin
    priority_enc : process(sig_in, en)
    begin
        if en = '1' then
            --checking from MSB to LSB for '1'
            for i in sig_in'high downto sig_in'low loop
                if sig_in(i) = '1' then
                    -- output code corresponds to the input with the highest priority
                    enc_out <= std_logic_vector(to_unsigned(i, M));
                    exit;
                end if;
                -- if all inputs are '0' then 'Z' on outputs
                enc_out <= (others => 'Z');
            end loop;
        else
            enc_out <= (others => 'Z');
        end if;
        
    end process;
end architecture;