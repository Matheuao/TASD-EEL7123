library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.numeric_std.all;


entity Compression_and_sum is
generic (version: natural:= 0); -- version = 0 -> optimize version
		 						-- version = 1 -> non optimize version(BASE LINE)
port (A: in std_logic_vector(3 downto 0);
		B: in std_logic_vector(3 downto 0);
		C: in std_logic_vector(3 downto 0);
		D: in std_logic_vector(3 downto 0);
RESULT: out std_logic_vector(13 downto 0)
); 
end Compression_and_sum;

architecture Structural of Compression_and_sum is
 
  component CSA is
         generic (n : natural := 13);
  	 port(I0 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I1 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      I2 : in STD_LOGIC_VECTOR((n-1) downto 0);
	      S : out STD_LOGIC_VECTOR((n-1) downto 0);
	      C : out STD_LOGIC_VECTOR((n-1) downto 0));
  end component;
  
  component fulladder is
	port (A: in std_logic; 
		B: in std_logic;
		Cin: in std_logic; 
		S: out std_logic; 
		Cout: out std_logic);
   end component;

begin	

version_condition: if version = 0  generate
	signal v0, V1, V2, V3, V4, V5, V6, V7,V8: std_logic_vector(11 downto 0);
	signal sum0_n1, carry0_n1:std_logic_vector(11 downto 0);
	signal sum0_n2, carry0_n2:std_logic_vector(11 downto 0);
	signal sum0_n3, carry0_n3:std_logic_vector(11 downto 0);
	
	signal sum1_n1, carry1_n1:std_logic_vector(11 downto 0);
	signal sum1_n2, carry1_n2:std_logic_vector(11 downto 0);
	
	signal sum2_n1, carry2_n1:std_logic_vector(11 downto 0);

	signal sum3_n1, carry3_n1:std_logic_vector(11 downto 0);
	signal overflow :std_logic :='0';
	-- Vector declaration
	begin
	V0 <="0" & D(3) & D(2) & C(3) & C(2) & A(3 downto 1) &A(3 downto 0);
	V1 <="0" & "00" & D(1) & D(0) & B(3) & B(2) & B(3) & A(0) & B(2 downto 0);
	V2 <="0" & "0000" & C(3) & C(2) & B(1) & B(3) & B(1) & B(0) & C(0);
	V3 <="0" & "0000" & C(1) & C(0) & C(1) & B(2) & C(2) & C(1) & D(0);
	V4 <="0" & "0000" & D(3 downto 1) & B(0) & D(2) & D(1) & "1";
	V5 <="0" & "0000000" & C(3) & "000";
	V6 <="0" & "0000000" & C(0) & "000";
	V7 <="0" & "0000000" & D(3) & "000";
	V8 <="0" & "000000"  & D(0) & not(D(0)) & "000";


--fist interaction ----------------------------------------

	comp0_n1: CSA generic map	(n => 12)
								 port map (
								 I0 => V0,
								I1 => V1,
								I2 => v2,
								S => sum0_n1,
								C => carry0_n1); 

	comp0_n2: CSA generic map	(n => 12)
								 port map (
								 I0 => V3,
								 I1 => V4,
								 I2 => v5,
							 	 S => sum0_n2,
								 C => carry0_n2);

	comp0_n3: CSA generic map	(n => 12)
								 port map (
								 I0 => V6,
								 I1 => V7,
								 I2 => v8,
							 	 S => sum0_n3,
								 C => carry0_n3); 
-- second interaction ---------------------------------------------------
	comp1_n1: CSA generic map	(n => 12)
								 port map (
								 I0 => sum0_n1,
								 I1 => carry0_n1,
								 I2 => sum0_n2,
							 	 S => sum1_n1,
								 C => carry1_n1); 
	
	comp1_n2: CSA generic map	(n => 12)
								 port map (
								 I0 => carry0_n2,
								 I1 => sum0_n3,
								 I2 => carry0_n3,
							 	 S => sum1_n2,
								 C => carry1_n2);
	
-- third interaction -------------------------------------------------------

	comp2_n1: CSA generic map	(n => 12)
								 port map (
								 I0 => sum1_n1,
								 I1 => carry1_n1,
								 I2 => sum1_n2,
							 	 S => sum2_n1,
								 C => carry2_n1); 
-- four interaction -------------------------------------------------------------	
	
	comp3_n1: CSA generic map	(n => 12)
								 port map (
								 I0 => carry1_n2,
								 I1 => sum2_n1,
								 I2 => carry2_n1,
							 	 S => sum3_n1,
								 C => carry3_n1);

------------------------------------------------------------------------------------


		
	RESULT(13 downto 0) <= std_logic_vector(unsigned(sum3_n1) + unsigned(carry3_n1))&"00";

elsif version = 1 generate
	signal A_u, B_u, C_u, D_u  : unsigned(3 downto 0);

    -- Constantes como unsigned (mesmos bits do operando de multiplicação)
    constant K36  : unsigned(7 downto 0) := to_unsigned(36, 8);
    constant K44  : unsigned(7 downto 0) := to_unsigned(44, 8);
    constant K164 : unsigned(7 downto 0) := to_unsigned(164, 8);
    constant K548 : unsigned(9 downto 0) := to_unsigned(548, 10);

    -- Resultados das multiplicações (tamanho ajustado)
    signal mult1 : unsigned(9 downto 0);
    signal mult2 : unsigned(9 downto 0);
    signal mult3 : unsigned(11 downto 0);
    signal mult4 : unsigned(13 downto 0);

    constant const_36 : unsigned(12 downto 0) := to_unsigned(36, 13);

    signal sum13 : unsigned(13 downto 0);

begin

    A_u <= unsigned(A);
    B_u <= unsigned(B);
    C_u <= unsigned(C);
    D_u <= unsigned(D);

    mult1 <= resize(A_u * K36, 10);
    mult2 <= resize(B_u * K44, 10);
    mult3 <= resize(C_u * K164, 12);
    mult4 <= resize(D_u * K548, 14);

    sum13 <=  resize(mult1, 14) +
              resize(mult2, 14) +
              resize(mult3, 14) +
              resize(mult4, 14) +
              const_36;

    RESULT <= std_logic_vector(sum13);

	end generate;
end Structural;