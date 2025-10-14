library IEEE;
use IEEE.STD_LOGIC_1164.all;   

entity traditional_BinToRNS is
	generic (n : natural := 4);
	port(  X    : in STD_LOGIC_VECTOR(4*n -1 downto 0);
		     X1   : out STD_LOGIC_VECTOR(2*n -1 downto 0); --2*n bits
         X2   : out STD_LOGIC_VECTOR(n -1 downto 0); --n
         X3   : out STD_LOGIC_VECTOR(n downto 0)); -- n+1 bits
end traditional_BinToRNS;

architecture Structural of traditional_BinToRNS is

  component CSA_EAC is
         generic (w : natural := 4);
  	 port(I0 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      I1 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      I2 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      S : out STD_LOGIC_VECTOR((w-1) downto 0);
	      C : out STD_LOGIC_VECTOR((w-1) downto 0));
  end component;
  
  component CPA_mod15 is
    generic(n : natural :=4);
     port(
       s1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       c1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       f : out STD_LOGIC_VECTOR(n-1 downto 0)
         );
  end component;

  component CSA_IEAC is
         generic (w : natural := 4);
  	 port(I0 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      I1 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      I2 : in STD_LOGIC_VECTOR((w-1) downto 0);
	      S : out STD_LOGIC_VECTOR((w-1) downto 0);
	      C : out STD_LOGIC_VECTOR((w-1) downto 0));
  end component;
  
  component CPA_mod17 is
    generic(n : natural :=5);
     port(
       s1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       c1 : in STD_LOGIC_VECTOR (n-1 downto 0);
       f : out STD_LOGIC_VECTOR(n-1 downto 0)
         );
  end component;
  
signal zeros : std_logic_vector(n-1 downto 0);
signal sum0_2n_m1 , carry0_2n_m1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_m1 , carry1_2n_m1 : std_logic_vector(n-1 downto 0);

signal sum0_2n_p1 , carry0_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum1_2n_p1 , carry1_2n_p1 : std_logic_vector(n-1 downto 0);
signal sum2_2n_p1 , carry2_2n_p1 : std_logic_vector(n-1 downto 0);

signal sum3_2n_p1 , carry3_2n_p1 : std_logic_vector(n downto 0);

signal notX : std_logic_vector(4*n-1 downto 0);

signal cor: std_logic_vector(n-1 downto 0) :="0001";

begin
	-- enter your statements here -- 
zeros <= (others =>'0');	
notX(4*n-1 downto 0) <= not(X(4*n-1 downto 0)); -- Para obter os negativos das entradas


-- Conversão Modulo 256
X1(2*n-1 downto 0) <= X(2*n-1 downto 0);

-- Conversão Modulo 15
comp0_2n_m1: CSA_EAC generic map	(  w => n)
	             port map ( I0 => X(n-1 downto 0),
                            I1 => X(2*n-1 downto n),
                            I2 => X(3*n-1 downto 2*n), 
                            S =>sum0_2n_m1 , 
                            C =>carry0_2n_m1); 

comp1_2n_m1: CSA_EAC generic map	(  w => n)
	             port map ( I0 => sum0_2n_m1, 
                            I1 => carry0_2n_m1, 
                            I2 => X(4*n-1 downto 3*n),
                            S =>sum1_2n_m1, 
                            C =>carry1_2n_m1);

add_2n_m1: CPA_mod15 generic map	(  n => n)
                port map( s1 => sum1_2n_m1, 
                          c1 => carry1_2n_m1, 
                          f => X2);

-- Conversão Modulo 17
comp0_2n_p1: CSA_IEAC generic map	( w => n)
	              port map ( I0 => X(n-1 downto 0),
                             I1 => notX(2*n-1 downto n), 
                             I2 => X(3*n-1 downto 2*n), 
                             S =>sum0_2n_p1, 
                             C =>carry0_2n_p1); 

comp1_2n_p1: CSA_IEAC generic map	( w => n)
	            port map ( I0 => sum0_2n_p1, 
                I1 => carry0_2n_p1, 
                I2 => notX(4*n-1 downto 3*n), 
                S =>sum1_2n_p1 , 
                C =>carry1_2n_p1); 

comp2_2n_p1: CSA_IEAC generic map(  w => n)
	              port map ( I0 => cor, 
                             I1 => sum1_2n_p1, 
                             I2 => carry1_2n_p1, 
                             S =>sum2_2n_p1 , 
                             C =>carry2_2n_p1); 

sum3_2n_p1 <= '0' & sum2_2n_p1;
carry3_2n_p1 <= '0' & carry2_2n_p1;

add_2n_p1: CPA_mod17 generic map	(  n => n+1)
                      port map(s1=> sum3_2n_p1, 
                               c1 => carry3_2n_p1, 
                               f  => X3);
end Structural;

