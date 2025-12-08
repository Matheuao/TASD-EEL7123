library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.ALL;

entity compressor_4_2_neg is
	generic (n : natural:=32);
  	 port(A : in signed((n-1) downto 0);
		  A_c : in signed((n-1) downto 0);
		  B : in signed((n-1) downto 0);
		  B_c : in signed((n-1) downto 0);
		  S : out signed((n-1) downto 0);
          S_c: out signed(n-1 downto 0)
     );
end compressor_4_2_neg;
  
architecture Structural of compressor_4_2_neg is

type vec_2 is array (0 to 1) of signed(n-1 downto 0);
signal S_csa,C_csa : vec_2; 
component CSA is
    generic (n : natural);
  	 port(I0 : in signed((n-1) downto 0);
			I1 : in signed((n-1) downto 0);
			I2 : in signed((n-1) downto 0);
			S : out signed((n-1) downto 0);
			C : out signed((n-1) downto 0));
 end component;
 

begin
  		
csa1:CSA generic map(n=>n) 
      port map( I0=>A,
                I1=>A_c,
                I2=>not(B),
                S=>S_csa(0),
                C=>C_csa(0));

csa2:CSA generic map(n=>n)
      port map( I0=>S_csa(0),
                I1=>C_csa(0)(30 downto 0) & '1',
                I2=>not(B_c),
                S=>S_csa(1),
                C=>C_csa(1));
    
    S<=S_csa(1);
    S_c<=C_csa(1)(30 downto 0) & '1';
  		
end Structural;