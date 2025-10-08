library IEEE;
use IEEE.Std_Logic_1164.all;

entity adder is
generic(
	bits_num: integer:= 8
);
port (cin: in std_logic;
		V1: in std_logic_vector(bits_num-1 downto 0);
		V2: in std_logic_vector(bits_num-1 downto 0);
		S: out std_logic_vector(bits_num-1 downto 0);
		cout: out std_logic);
end adder;

architecture circuit of adder is 

signal Cout_signal: std_logic_vector(bits_num-2 downto 0); 

component fulladder is
	port (A: in std_logic;
			B: in std_logic;
			Cin: in std_logic;
			S: out std_logic; Cout: out std_logic);
end component;

begin
	
	cpa_first: fulladder port map( A => V1(0), B => V2(0), Cin => cin, S =>S(0) , Cout =>Cout_signal(0));
	cpa_last: fulladder port map( A => V1(bits_num-1), B => V2(bits_num-1), Cin => Cout_signal(bits_num-2), S =>S(bits_num-1) , Cout => cout);


	cpa_1 : for j in 1 to bits_num-2 generate
		cpa_j: fulladder port map( A => V1(j), B => V2(j), Cin => Cout_signal(j-1), S =>S(j) , Cout =>Cout_signal(j));
		
	end generate cpa_1;

end circuit;