library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RNStoBin_traditional is
	generic (n : natural := 4);
	port (
		R1 : in STD_LOGIC_VECTOR(2*n -1 downto 0);
		R2 : in STD_LOGIC_VECTOR(n-1 downto 0);
		R3 : in STD_LOGIC_VECTOR(n downto 0);
		bin: out std_logic_vector(4 * n -1 downto 0)
	);
end RNStoBin_traditional;
 
architecture Structural of RNStoBin_traditional is

	component CSA_EAC is
		generic (w : natural := 8);
		port (
			I0 : in STD_LOGIC_VECTOR((w - 1) downto 0);
			I1 : in STD_LOGIC_VECTOR((w - 1) downto 0);
			I2 : in STD_LOGIC_VECTOR((w - 1) downto 0);
			S : out STD_LOGIC_VECTOR((w - 1) downto 0);
			C : out STD_LOGIC_VECTOR((w - 1) downto 0)
		);
	end component;
 
	component CPA_mod255 is
		generic (w : natural := 8);
		port (
			s1 : in STD_LOGIC_VECTOR((w - 1) downto 0);
			c1 : in STD_LOGIC_VECTOR((w - 1) downto 0);
			f : out STD_LOGIC_VECTOR((w - 1) downto 0)
		);
	end component;

	signal A, B, C, D : std_logic_vector(2 * n - 1 downto 0);
	signal s0, c0,s1,c1 : std_logic_vector(2 * n - 1 downto 0);
 
begin
 
	A(2 * n - 1 downto 0) <= not(R1(2 * n - 1 downto 0));
	B(2 * n - 1 downto 0) <= R2(0) & R2(3) & R2(2 downto 0) & R2(3 downto 1);
	C(2 * n - 1 downto 0) <= R3(0) & "000" & R3(4 downto 1);
	D(2 * n - 1 downto 0) <= not(R3(4 downto 0))	& "111";
 
	comp1 : CSA_EAC
		generic map(w => 2 * n)
	port map(
		I0 => A, 
		I1 => B, 
		I2 => C, 
		S => s0, 
		C => c0
	);
 
	comp2 : CSA_EAC
		generic map(w => 2 * n)
	port map(
		I0 => s0, 
		I1 => c0, 
		I2 => D, 
		S => s1, 
		C => c1
	);
 
	comp3 : CPA_mod255
		generic map(w => 2 * n)
	port map(
		s1 => s1, 
		c1 => c1, 
		f => bin(4 * n - 1 downto 2 * n)
	);
 
	bin(2 * n - 1 downto 0) <= R1(2 * n - 1 downto 0);
 
end Structural;