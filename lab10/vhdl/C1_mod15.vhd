-- C1 -> 34817 MOD 15

library IEEE;
use IEEE.Std_Logic_1164.all;

entity C1_mod15 is
port (
	input: in std_logic_vector (3 downto 0);
	output: out std_logic_vector (3 downto 0)
);
end C1_mod15;
architecture arch of C1_mod15 is
begin

output <= input(2 downto 0) & input(3);

end arch;