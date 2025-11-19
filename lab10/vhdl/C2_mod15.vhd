-- C2 -> 26113 MOD 15

library IEEE;
use IEEE.Std_Logic_1164.all;

entity C2_mod15 is
	port (
		input: in std_logic_vector (3 downto 0);
		output: out std_logic_vector (3 downto 0)
	);
end C2_mod15;
architecture arch of C2_mod15 is

    signal rot : std_logic_vector(3 downto 0);
	 
begin

    rot    <= input(2 downto 0) & input(3);  
    output <= not rot;     
	 
end arch;
