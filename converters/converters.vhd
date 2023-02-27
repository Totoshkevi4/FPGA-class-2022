library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;

package converters is

    function to_integer(value : std_logic_vector) return integer;
    function to_integer(value : std_logic) return integer;
    function to_stdlogic(value : boolean) return std_logic;
    function to_stdlogicvector(value : integer; length : integer) return std_logic_vector;
    function to_stdlogicvector(char : character) return std_logic_vector;
    function to_bcd(value : integer; N : integer) return std_logic_vector;
    function to_bcd(bin : std_logic_vector) return std_logic_vector;
    function bcd_to_bin(bcd : std_logic_vector) return std_logic_vector; 
    function gray_encode(value : std_logic_vector) return std_logic_vector;
    function gray_decode(value : std_logic_vector) return std_logic_vector;

    alias to_std_logic is to_stdlogic[boolean return std_logic];
    alias to_sl is to_stdlogic[boolean return std_logic];
    alias to_std_logic_vector is to_stdlogicvector[integer, integer return std_logic_vector];
    alias to_slv is to_stdlogicvector[integer, integer return std_logic_vector];
    alias to_std_logic_vector is to_stdlogicvector[character return std_logic_vector];
    alias to_slv is to_stdlogicvector[character return std_logic_vector]; 
    
end package; 


package body converters is

    -------------------------------------------------------------
    -- to_integer (value : std_logic_vector) --------------------
    -------------------------------------------------------------
    function to_integer (value : std_logic_vector) 
        return integer
    is
        variable result : integer := 0;
    begin
        for i in value'low to value'high loop
            if value(i) = '1' then
                result := result + 2 ** (i - value'low);
            end if;
        end loop;
        return result;
    end function to_integer;

    -------------------------------------------------------------
    -- to_integer (value : std_logic) ---------------------------
    -------------------------------------------------------------
    function to_integer(value : std_logic)
        return integer
    is
    begin
        if value = '1' then
            return 1;
        else
            return 0;
        end if;
    end function;

    -------------------------------------------------------------
    -- to_stdlogic(value : boolean) -----------------------------
    -------------------------------------------------------------
    function to_stdlogic(value : boolean) 
        return std_logic 
    is
    begin
        if value then
            return '1';
        else
            return '0';
        end if;
    end function;
  
    -------------------------------------------------------------
    -- to_stdlogicvector(value : integer; length : integer) -----
    -------------------------------------------------------------   
    function to_stdlogicvector(value : integer; length : integer) 
        return std_logic_vector 
    is
        variable result: std_logic_vector (length-1 downto 0);
        variable temp: integer;
    begin
        temp := value;
        for i in 0 to length-1 loop
            if (temp mod 2) = 1 then
                result(i) := '1';
            else
                result(i) := '0';
            end if;

            if temp > 0 then
                temp := temp / 2;
            else
                temp := (temp - 1) / 2;
            end if;
        end loop;
        return result;       
    end function;

    -------------------------------------------------------------
    -- to_stdlogicvector(char : character) ----------------------
    -------------------------------------------------------------
    function to_stdlogicvector(char : character) 
        return std_logic_vector
    is
        variable temp : integer := character'pos(char); 
        variable length : integer := 8;
        variable result: std_logic_vector (7 downto 0);
    begin
        for i in 0 to length - 1 loop
            if (temp mod 2) = 1 then
                result(i) := '1';
            else
                result(i) := '0';
            end if;

            if temp > 0 then
                temp := temp / 2;
            else
                temp := (temp - 1) / 2;
            end if;
        end loop;
        return result;
    end function;

    -------------------------------------------------------------
    -- to_bcd(value : integer; N : integer) ---------------------
    -------------------------------------------------------------
    function to_bcd(value : integer; N : integer) 
        return std_logic_vector 
    is
        variable temp : integer := value;
        --variable set  : std_logic_vector(3 downto 0);
        variable res  : std_logic_vector(N*4-1 downto 0);
    begin
        for i in 0 to N-1 loop
            res(4*(i+1)-1 downto 4*i) := to_slv(temp mod 10, 4);
            temp := temp / 10;
        end loop;
        return res;
    end function;

    -------------------------------------------------------------
    -- to_bcd(value : std_logic_vector) -------------------------
    -------------------------------------------------------------
    function to_bcd(bin : std_logic_vector) 
        return std_logic_vector 
    is
        -- DIGITS = ceil(bin'length * lg(2)) = ceil(bin'length * 0.301)
        -- number of digits in decimal representation
        -- or DIGITS could be n + 4*(n/3), where n = bin'length
        constant DIGITS : natural := integer(ceil(0.301 * bin'length));

        variable temp : std_logic_vector(bin'high downto 0) := bin;
        variable res  : std_logic_vector(DIGITS*4 -1 downto 0) := (others => '0');
    begin
        -- Double dabble algorithm
        for i in temp'range loop
            -- if any BCD digit >= 5 then increment it by 3 
            for j in 0 to DIGITS-1 loop
                if unsigned(res(j*4+3 downto j*4)) >= 5 then
					res(j*4+3 downto j*4) := to_stdlogicvector(to_integer(res(j*4+3 downto j*4)) + 3, 4);
				end if;
            end loop;
            -- shift left scratch-space (temp)
            res := res(res'left-1 downto 0) & temp(temp'left);
            temp := temp(temp'left-1 downto 0) & '0';
        end loop;
        return res;
    end function;

    -------------------------------------------------------------
    -- bcd_to_bin(bcd : std_logic_vector) -----------------------
    -------------------------------------------------------------
    function bcd_to_bin(bcd : std_logic_vector) 
        return std_logic_vector 
    is
        -- number of digits in decimal representation
        constant DIGITS : natural := bcd'length / 4;
        -- BITS = ceil(DIGITS * log2(10)) = ceil(bin'length * 3.322)
        -- number of digits in binary representation
        constant BITS   : natural := natural(ceil(real(DIGITS) * 3.322));

        variable temp : std_logic_vector(bcd'high downto 0) := bcd;
        variable res  : std_logic_vector(BITS -1 downto 0) := (others => '0');
    begin
        -- Reverse double dabble algorithm
		for i in res'range loop
			-- shift right scratch-space (temp)
			res := temp(0) & res(res'left downto 1);
			temp := '0' & temp(temp'high downto 1);
			
			-- if any BCD digit >= 8 then decrement it by 3 
			for d in 0 to DIGITS-1 loop
				if unsigned(temp(d*4+3 downto d*4)) >= 8 then
					temp(d*4+3 downto d*4) := to_stdlogicvector(to_integer(temp(d*4+3 downto d*4)) - 3, 4);
				end if;
			end loop;
			
		end loop;
        return res;
    end function;

    -------------------------------------------------------------
    -- gray_encode(value : std_logic_vector) --------------------
    -------------------------------------------------------------
    function gray_encode(value : std_logic_vector) 
        return std_logic_vector 
    is
        variable result : std_logic_vector(value'high + 1 downto 0) := '0' & value;
    begin
        for i in 0 to value'high loop
            result(i) := result(i) xor result(i+1);
        end loop;
        return result(value'high downto 0);
    end function;

    -------------------------------------------------------------
    -- gray_encode(value : std_logic_vector) --------------------
    -------------------------------------------------------------
    function gray_decode(value : std_logic_vector) 
        return std_logic_vector 
    is
        variable result : std_logic_vector(value'high downto 0) := (others => '0');
        variable input : std_logic_vector(value'high downto 0) := value;
        variable zeros  : std_logic_vector(value'high downto 0) := (others => '0');
    begin
        while input > zeros loop
            result := result xor input;
            input  := input srl 1;
        end loop;
        return result(value'high downto 0);
    end function;

end package body;