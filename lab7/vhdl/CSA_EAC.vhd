library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CSA_EAC is
	generic (w : natural);
  	 port(I0 : in STD_LOGIC_VECTOR((w-1) downto 0);
			I1 : in STD_LOGIC_VECTOR((w-1) downto 0);
			I2 : in STD_LOGIC_VECTOR((w-1) downto 0);
			S : out STD_LOGIC_VECTOR((w-1) downto 0);
			C : out STD_LOGIC_VECTOR((w-1) downto 0));
end CSA_EAC;
  
architecture Structural of CSA_EAC is
 component fulladder is
 	 port(A : in STD_LOGIC;
			B : in STD_LOGIC;
			Cin : in STD_LOGIC;
			S : out STD_LOGIC;
			Cout : out STD_LOGIC);
 end component;
 
signal c_sig : STD_LOGIC_VECTOR(w downto 0);

begin
  		
	cpa_generation : for j in 0 to (w-1) generate
		cpa_j: fulladder port map ( A => I0(j), B => I1(j), Cin => I2(j), S => S(j) , Cout => c_sig(j+1));
	end generate;

	C(0) <= c_sig(w);
	C(w-1 downto 1) <= c_sig((w-1) downto 1);
  		
end Structural;