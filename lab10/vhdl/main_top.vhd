library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity main_top is
	port(SW    : in STD_LOGIC_VECTOR(17 downto 0);
		  LEDR : out STD_LOGIC_VECTOR(17 downto 0)
		);
end main_top;
  
architecture Structural of main_top is
component main is 
generic(w:integer:=16);
	port( X    : in STD_LOGIC_VECTOR(w-1 downto 0);
		  SEL:   in STD_LOGIC_VECTOR(1 downto 0);
		  Y : out STD_LOGIC_VECTOR(w-1 downto 0)
		  );
end component;
begin

inst: main generic map(w=>16)
		   port map(X=>SW(15 downto 0),
		   			SEL=>SW(17 downto 16),
					Y=>LEDR(15 downto 0));	
		
end Structural;