
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity main is
	generic(w:integer:=16);
	port( X    : in STD_LOGIC_VECTOR(w-1 downto 0);
		  SEL:   in STD_LOGIC_VECTOR(1 downto 0);
		  Y : out STD_LOGIC_VECTOR(w-1 downto 0)
		  );
end main;
  
architecture Structural of main is

	component traditional_BinToRNS is
		generic (n : natural := 4);
		port(  X    : in STD_LOGIC_VECTOR(4*n -1 downto 0);
				X1   : out STD_LOGIC_VECTOR(2*n -1 downto 0); --2*n bits
			X2   : out STD_LOGIC_VECTOR(n -1 downto 0); --n
			X3   : out STD_LOGIC_VECTOR(n downto 0)); -- n+1 bits
	end component;
	
	component RNStoBin_traditional is
		generic (n : natural := 4);
		port (
			R1 : in STD_LOGIC_VECTOR(2*n -1 downto 0);
			R2 : in STD_LOGIC_VECTOR(n-1 downto 0);
			R3 : in STD_LOGIC_VECTOR(n downto 0);
			bin: out std_logic_vector(4 * n -1 downto 0)
		);
	end component;
	
	component C1_mod15 is
		port (
			input: in std_logic_vector (3 downto 0);
			output: out std_logic_vector (3 downto 0)
		);
	end component;
	
	component C2_mod15 is
		port (
			input: in std_logic_vector (3 downto 0);
			output: out std_logic_vector (3 downto 0)
		);
	end component;
	
	component C3_mod15 is
		port (
			input: in std_logic_vector (3 downto 0);
			output: out std_logic_vector (3 downto 0)
		);
	end component;
	
	component C4_mod15 is
		port (
			input: in std_logic_vector (3 downto 0);
			output: out std_logic_vector (3 downto 0)
		);
	end component;
	
	component mux41 
		generic(n :positive:=4);
		port (A: in std_logic_vector (n-1 downto 0);
		B: in std_logic_vector (n-1 downto 0);
		C: in std_logic_vector (n-1 downto 0);
		D: in std_logic_vector (n-1 downto 0);
		s: in std_logic_vector(1 downto 0);
		F: out std_logic_vector (n-1 downto 0)
		);
	end component;

	signal rns_to_mod_X1: std_logic_vector(7 downto 0);
	signal rns_to_mod_X2: std_logic_vector(3 downto 0);
	signal rns_to_mod_X3: std_logic_vector(4 downto 0);
	signal out_C1_mod15, out_C2_mod15, out_C3_mod15, out_C4_mod15 : std_logic_vector(3 downto 0);
	signal mux_mod256 : std_logic_vector(7 downto 0);
	signal mux_mod15 : std_logic_vector(3 downto 0);
	signal mux_mod17 : std_logic_vector(4 downto 0);

begin

	BinToRNS : traditional_BinToRNS
		generic map(n => 4)
		port map(X => X,
			  	X1 => rns_to_mod_X1,
				X2 => rns_to_mod_X2,
				X3 => rns_to_mod_X3
			  );
				  
	C1 : C1_mod15 -- C1 -> 34817 MOD 15
		port map(
			input => rns_to_mod_X2,
			output => out_C1_mod15
		);

	C2 : C2_mod15 -- C2 -> 26113 MOD 15
		port map(
			input => rns_to_mod_X2,
			output => out_C2_mod15
		);
		
	C3 : C3_mod15 -- C3 -> 21761 MOD 15
		port map(
			input => rns_to_mod_X2,
			output => out_C3_mod15
		);

	C4 : C4_mod15 -- C4 -> 13057 MOD 15
		port map(
			input => rns_to_mod_X2,
			output => out_C4_mod15
		);
		
	mux_m15 : mux41
		generic map(n => 4)
		port map(A => out_C1_mod15,
		B => out_C2_mod15,
		C => out_C3_mod15,
		D => out_C4_mod15,
		s => SEL,
		F => mux_mod15
		);

	RNStoBin : RNStoBin_traditional
		generic map(n => 4)
		port map(R1=>rns_to_mod_X1,
				 R2=>mux_mod15,
				 R3=>rns_to_mod_X3,
				 bin=>Y
			  	);
		
end Structural;