library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.ceil;

use std.env.finish;

use work.converters.all;

entity converters_tb is
end converters_tb;

architecture sim of converters_tb is
    constant N : integer := 4;
    constant CHR_LEN : integer := 8;

    constant clk_hz : integer := 50e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk_tb : std_logic := '1';

    signal slv : std_logic_vector(N-1 downto 0);
    signal slv_bcd : std_logic_vector(integer(ceil(0.301 * real(slv'length))) * 4-1 downto 0);
    signal sl  : std_logic := '1';
    signal int : integer range 0 to 2**N-1;
    signal chr : character;
    signal slv_chr : std_logic_vector(CHR_LEN-1 downto 0);
    signal gray_cd : std_logic_vector(N-1 downto 0);
    signal gray_dc : std_logic_vector(N-1 downto 0);
    
    type bin_bcd_t is array (natural range <>) of std_logic_vector (11 downto 0);
	constant bin_bcd : bin_bcd_t := (
	b"0000_00000000",  -- 0
	b"0001_00000001",  -- 1
	b"0010_00000010",  -- 2
	b"0011_00000011",  -- 3
	b"0100_00000100",  -- 4
	b"0101_00000101",  -- 5
	b"0110_00000110",  -- 6
	b"0111_00000111",  -- 7
	b"1000_00001000",  -- 8
	b"1001_00001001",  -- 9
	b"1010_00010000",  -- 10 A
	b"1011_00010001",  -- 11 B
	b"1100_00010010",  -- 12 C
	b"1101_00010011",  -- 13 D
	b"1110_00010100",  -- 14 E
	b"1111_00010101"   -- 15 F
	);
    
    type gray_t is array (natural range <>) of std_logic_vector (3 downto 0);
	constant gray_code : gray_t := (
	b"0000",
	b"0001",
    b"0011",
    b"0010",
    b"0110",
    b"0111",
    b"0101",
    b"0100",
    b"1100",
    b"1101",
    b"1111",
    b"1110",
    b"1010",
    b"1011",
    b"1001",
    b"1000"
	);
    
    function sum_digits(value : std_logic_vector) 
        return natural 
    is
        variable res : natural;
    begin
		for i in value'range loop
			if value(i) = '1' then
                res := res + 1;
            end if;
		end loop;
        return res;
    end function sum_digits;

begin

    clk_tb <= not clk_tb after clk_period / 2;

    SEQUENCER_PROC : process
    begin
        report "Start" severity warning;
        -------------------------------------------------------------
        -- Testing to_integer(value : std_logic_vector) -------------
        -------------------------------------------------------------
        report "Testing to_integer(value : std_logic_vector)" severity warning;
        for i in 0 to 2**N - 1 loop
            slv <= std_logic_vector(to_unsigned(i, N));
            wait for clk_period/2;
            int <= to_integer(slv);
            wait for clk_period/2;
            
            assert int = to_integer(unsigned(slv))
                report "in: " & to_string(slv) &
                    "; out: " & to_string(int) &
                    "; should be: " & to_string(to_integer(unsigned(slv)))
            severity error;
        end loop;
        slv <= (others => '0');
        
        -------------------------------------------------------------
        -- Testing to_integer(value : std_logic) --------------------
        -------------------------------------------------------------
        report "Testing to_integer(value : std_logic)" severity warning;
        for i in 0 to 2 loop
            sl <= sl xor '1';
            wait for clk_period/2;
            int <= to_integer(sl);
            wait for clk_period/2;
            
            assert int = (i mod 2)
                report "in: " & to_string(sl) &
                    "; out: " & to_string(int) &
                    "; should be: " & to_string(i mod 2)
            severity error;
        end loop;
       
        -------------------------------------------------------------
        -- Testing to_stdlogic(value : boolean) ---------------------
        -------------------------------------------------------------
        report "Testing to_stdlogic(value : boolean)" severity warning;
        sl <= to_stdlogic(True);
        wait for clk_period/2;
        assert sl = '1'
                report "in: " & to_string(True) &
                    "; out: " & to_string(sl) &
                    "; should be: 1"
            severity error;

        sl <= to_stdlogic(False);
        wait for clk_period/2;
        assert sl = '0'
            report "in: " & to_string(False) &
                "; out: " & to_string(sl) &
                "; should be: 0"
            severity error;
        
        -------------------------------------------------------------
        -- Testing to_std_logic(value : boolean) --------------------
        -------------------------------------------------------------
        report "Testing to_std_logic(value : boolean)" severity warning;
        sl <= to_std_logic(True);
        wait for clk_period/2;
        assert sl = '1'
                report "in: " & to_string(True) &
                    "; out: " & to_string(sl) &
                    "; should be: 1"
            severity error;

        sl <= to_std_logic(False);
        wait for clk_period/2;
        assert sl = '0'
            report "in: " & to_string(False) &
                "; out: " & to_string(sl) &
                "; should be: 0"
            severity error;
        
        -------------------------------------------------------------
        -- Testing to_sl(value : boolean) ---------------------------
        -------------------------------------------------------------
        report "Testing to_sl(value : boolean)" severity warning;
        sl <= to_sl(True);
        wait for clk_period/2;
        assert sl = '1'
                report "in: " & to_string(True) &
                    "; out: " & to_string(sl) &
                    "; should be: 1"
            severity error;

        sl <= to_sl(False);
        wait for clk_period/2;
        assert sl = '0'
            report "in: " & to_string(False) &
                "; out: " & to_string(sl) &
                "; should be: 0"
            severity error;
        -------------------------------------------------------------
        -- Testing to_stdlogicvector(value : integer; length : integer)
        -------------------------------------------------------------
        report "Testing to_stdlogicvector(value : integer; length : integer)" severity warning;
        for i in 0 to 2**N - 1 loop
            int <= i;
            wait for clk_period/2;
            slv <= to_std_logic_vector(int, N);
            wait for clk_period/2;
            
            assert slv = std_logic_vector(to_unsigned(int, N))
                report "in: " & to_string(int) & " " & to_string(N) &
                    "; out: " & to_string(slv) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(int, N)))
            severity error;
        end loop;
        slv <= (others => '0');

        -------------------------------------------------------------
        -- Testing to_std_logic_vector(value : integer; length : integer)
        -------------------------------------------------------------
        report "Testing to_std_logic_vector(value : integer; length : integer)" severity warning;
        for i in 0 to 2**N - 1 loop
            int <= i;
            wait for clk_period/2;
            slv <= to_std_logic_vector(int, N);
            wait for clk_period/2;
            
            assert slv = std_logic_vector(to_unsigned(int, N))
                report "in: " & to_string(int) & " " & to_string(N) &
                    "; out: " & to_string(slv) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(int, N)))
            severity error;
        end loop;
        slv <= (others => '0');
        
        -------------------------------------------------------------
        -- Testing to_slv(value : integer; length : integer) --------
        -------------------------------------------------------------
        report "Testing to_slv(value : integer; length : integer)" severity warning;
        for i in 0 to 2**N - 1 loop
            int <= i;
            wait for clk_period/2;
            slv <= to_slv(int, N);
            wait for clk_period/2;
            
            assert slv = std_logic_vector(to_unsigned(int, N))
                report "in: " & to_string(int) & " " & to_string(N) &
                    "; out: " & to_string(slv) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(int, N)))
            severity error;
        end loop;
        slv <= (others => '0');

        -------------------------------------------------------------
        -- Testing to_stdlogicvector(char : character) --------------
        -------------------------------------------------------------
        report "Testing to_stdlogicvector(char : character)" severity warning;
        for i in 0 to 2**CHR_LEN - 1 loop
            chr <= character'val(i);
            wait for clk_period/2;
            slv_chr <= to_stdlogicvector(chr);
            wait for clk_period/2;
            
            assert slv_chr = std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN))
                report "in: " & chr &
                    "; out: " & to_string(slv_chr) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN)))
            severity error;
        end loop;
        slv <= (others => '0');

        -------------------------------------------------------------
        -- Testing to_std_logic_vector(char : character) ------------
        -------------------------------------------------------------
        report "Testing to_std_logic_vector(char : character)" severity warning;
        for i in 0 to 2**CHR_LEN - 1 loop
            chr <= character'val(i);
            wait for clk_period/2;
            slv_chr <= to_std_logic_vector(chr);
            wait for clk_period/2;
            
            assert slv_chr = std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN))
                report "in: " & chr &
                    "; out: " & to_string(slv_chr) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN)))
            severity error;
        end loop;
        slv <= (others => '0');

        -------------------------------------------------------------
        -- Testing to_slv(char : character) -------------------------
        -------------------------------------------------------------
        report "Testing to_slv(char : character)" severity warning;
        for i in 0 to 2**CHR_LEN - 1 loop
            chr <= character'val(i);
            wait for clk_period/2;
            slv_chr <= to_slv(chr);
            wait for clk_period/2;
            
            assert slv_chr = std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN))
                report "in: " & chr &
                    "; out: " & to_string(slv_chr) &
                    "; should be: " & to_string(std_logic_vector(to_unsigned(character'pos(chr), CHR_LEN)))
            severity error;
        end loop;
        slv <= (others => '0');
        
        -------------------------------------------------------------
        -- Testing to_bcd(value : std_logic_vector) -----------------
        -------------------------------------------------------------
        report "Testing to_bcd(value : std_logic_vector)" severity warning;
        for i in 0 to 2**N - 1 loop
            slv <= to_slv(i, N);
            wait for clk_period/2;
            slv_bcd <= to_bcd(slv);
            wait for clk_period/2;
            
            assert slv_bcd = bin_bcd(i)(7 downto 0)
                report "in: " & to_string(slv) &
                    "; out: " & to_string(slv_bcd) &
                    "; should be: " & to_string(bin_bcd(i)(7 downto 0))
            severity error;
        end loop;
        slv     <= (others => '0');
        slv_bcd <= (others => '0');
        
        -------------------------------------------------------------
        -- Testing bcd_to_bin(value : std_logic_vector) -------------
        -------------------------------------------------------------
        report "Testing to_bcd(value : std_logic_vector)" severity warning;
        for i in 0 to 2**N - 1 loop
            slv_bcd <= bin_bcd(i)(7 downto 0);
            wait for clk_period/2;
            slv <= bcd_to_bin(slv_bcd)(3 downto 0);
            wait for clk_period/2;
            
            assert slv = to_slv(i, 4)
                report "in: " & to_string(slv_bcd) &
                    "; out: " & to_string(slv) &
                    "; should be: " & to_string(to_slv(i, 4))
            severity error;
        end loop;
        slv     <= (others => '0');
        slv_bcd <= (others => '0');

        -------------------------------------------------------------
        -- Testing gray_encode(value : std_logic_vector) ------------
        -------------------------------------------------------------
        gray_cd <= (others => '0'); 
        report "Testing gray_encode(value : std_logic_vector)" severity warning;
        for i in 1 to 2**N - 1 loop
            slv <= std_logic_vector(to_unsigned(i, N));
            wait for clk_period/2;
            gray_cd <= gray_encode(slv);
            wait for clk_period/2;
            
            assert abs(sum_digits(gray_cd) - sum_digits(gray_code(i-1))) = 1
                report "in: " & to_string(slv) &
                    "; out: " & to_string(gray_cd) &
                    "; should be: " & to_string(gray_code(i))
            severity error;
        end loop;
        slv <= (others => '0');
        gray_cd <= (others => '0'); 
        
        -------------------------------------------------------------
        -- Testing gray_decode(value : std_logic_vector) ------------
        -------------------------------------------------------------
        report "Testing gray_decode(value : std_logic_vector)" severity warning;
        for i in 0 to 2**N - 1 loop
            gray_cd <= gray_code(i);
            wait for clk_period/2;
            gray_dc <= gray_decode(gray_cd);
            wait for clk_period/2;
            
            assert gray_dc = to_slv(i, 4)
                report "in: " & to_string(gray_cd) &
                    "; out: " & to_string(gray_dc) &
                    "; should be: " & to_string(to_slv(i, 4))
            severity error;
        end loop;
        gray_cd <= (others => '0');
        gray_dc <= (others => '0');

        report "Finish" severity warning;
        finish;
    end process;

end architecture;