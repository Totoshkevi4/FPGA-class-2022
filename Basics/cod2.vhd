library ieee;                
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 2-to-1 Coder with Tri-State

entity cod2 is
    port (
        x0 : in std_ulogic;
        x1 : in std_ulogic;
        z : in std_ulogic;
        q  : out std_ulogic;
		q1 : out std_ulogic
    );
end cod2;

architecture rtl of cod2 is
begin  
	q1 <= x1 when ((x0 xor x1) and z) else 'Z';
	q <= (not x0) and x1 and z;
end rtl;