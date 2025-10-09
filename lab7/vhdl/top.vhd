library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top is

	port(
	SW: in std_logic_vector(16 downto 0);
	LEDR: out std_logic_vector(15 downto 0)
	);
	
end top;

architecture structural of top is 

component RNStoBin_traditional is
generic (n : natural := 4);
	port (
		R1 : in STD_LOGIC_VECTOR(2*n -1 downto 0);
		R2 : in STD_LOGIC_VECTOR(n-1 downto 0);
		R3 : in STD_LOGIC_VECTOR(n downto 0);
		bin: out std_logic_vector(4 * n -1 downto 0)
	);

end component;
signal LEDR_sig : std_logic_vector(15 downto 0);
begin

	RNStoBin_cmp: RNStoBin_traditional 
					generic map(n=>4)
					port map(R1=>SW(7 downto 0), -- 8 bits (2**2n)
								R2=>SW(11 downto 8), -- 4 bits (2**n)
								R3=>SW(16 downto 12), -- 5 bits (2**n +1)
								bin=>LEDR);

end architecture;