package tools is
    function log2(value : integer) return integer;
end package;

package body tools is
    function log2(value : integer) 
        return integer 
    is
        variable i : natural;
    begin
        i := 0;  
        while (2**i < value) and i < 31 loop
            i := i + 1;
        end loop;
        return i;  
    end function;
end package body;