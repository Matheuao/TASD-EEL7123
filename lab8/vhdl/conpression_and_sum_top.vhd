library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;


entity conpression_and_sum_top is
generic (n : natural := 4;
			version: natural:=0);-- version = 0 -> optimize version
		 						-- version = 1 -> non optimize version(BASE LINE)
port (SW: in std_logic_vector(17 downto 0);
LEDR: out std_logic_vector(17 downto 0)
); 
end conpression_and_sum_top;

architecture Structural of conpression_and_sum_top is

component Compression_and_sum is 

generic (version: natural:= 0); -- version = 0 -> optimize version
		 						-- version = 1 -> non optimize version
port (A: in std_logic_vector(3 downto 0);
	  B: in std_logic_vector(3 downto 0);
	  C: in std_logic_vector(3 downto 0);
	  D: in std_logic_vector(3 downto 0);
	  RESULT: out std_logic_vector(13 downto 0)
);

end component;

begin
	
	adder_comp:Compression_and_sum  generic map(version=>version)
				port map(A=>SW(3 downto 0),
						 B=>SW(7 downto 4),
						 C=>SW(11 downto 8),
						 D=>SW(15 downto 12),
						 RESULT=>LEDR(13 downto 0)
				);	
					
  end Structural;