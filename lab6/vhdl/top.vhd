library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is

	port(
	SW: in std_logic_vector(15 downto 0);
	LEDR: out std_logic_vector(16 downto 0)
	);
	
end top;

architecture structural of top is 

component traditional_BinToRNS is
    generic (n : natural := 4);
	port(  X    : in STD_LOGIC_VECTOR(4*n -1 downto 0);
		     X1   : out STD_LOGIC_VECTOR(2*n -1 downto 0); --2*n bits
         X2   : out STD_LOGIC_VECTOR(n -1 downto 0); --n
         X3   : out STD_LOGIC_VECTOR(n downto 0)); -- n+1 bits
end component;

begin

	RNStoBin_cmp: traditional_BinToRNS 
					generic map(n=>4)
					port map(X=>SW, -- 8 bits (2**2n)
							 X1=>LEDR(7 downto 0), -- 4 bits (2**n)
							 X2=>LEDR(11 downto 8), -- 5 bits (2**n +1)
							 X3=>LEDR(16 downto 12));

end architecture;