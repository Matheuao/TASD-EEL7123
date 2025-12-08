LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity modwt is 
	GENERIC (
					W1 : INTEGER := 16; -- Input and output bit width   
					W2 : INTEGER := 16;--32 -- coeficients width	
					num_coef: INTEGER:=10;
					n_delay:integer:=1
			);

			port(
			
			x_in : in signed(W1-1 DOWNTO 0):=(others=>'0');
			clk  : in std_logic;
			reset: in std_logic;
			output : out signed(W1-1 DOWNTO 0):=(others=>'0')
			);

end modwt;

architecture main of modwt is

type vector_coef is array (0 to num_coef-1) of signed(W2-1 downto 0);
type vector_mult is array (0 to num_coef-1) of signed((W1+W2)-1 downto 0);
type vector_sum is array (0 to (num_coef)-1) of signed((W1+W2)-1 downto 0);


constant ld:vector_coef:= (X"0E7E",X"36A7",X"418E",X"0C87",X"EA12",X"FD15",X"0705",X"FF6F",X"FEDD",X"004D");
constant hd: vector_coef:=(X"004D",X"0123",X"FF6F",X"F8FB",X"FD15",X"15EE",X"0C87",X"BE72",X"36A7",X"F182");


signal x,out_high,out_low: signed (W1-1 downto 0) :=( others=>'0');
signal a,b,conect_delay_a,conect_delay_b:vector_sum := (others=>x"00000000");
signal x_mult,k_mult:vector_mult:= (others=>x"00000000");


component shift_register
	 GENERIC (
				data_num_bits : INTEGER := 0; -- multiplication bit width (W1*2)
				DELAY_W: INTEGER :=18 --15 ate 25 fs/2			
			);

			port(
				x_in : IN signed(data_num_bits-1 DOWNTO 0);
				clock :  in std_logic;
				reset: in std_logic;
				enable: in std_logic;
				x_out : out signed(data_num_bits-1 downto 0)
			);
end component;

component reg

	generic(W1: integer:=0);
	
	port (
			signal reg_in :in  signed(W1-1 downto 0):=(others=>'0') ;
			signal load: in std_logic;
			signal reset: in std_logic;
			signal clk: in std_logic;
			signal reg_out: out signed(W1-1 downto 0)
	 );
end component;

component multiplier_block
port (
        X   : in  signed(31 downto 0);
        Y1  : out signed(31 downto 0);
        Y2  : out signed(31 downto 0);
        Y3  : out signed(31 downto 0);
        Y4  : out signed(31 downto 0);
        Y5  : out signed(31 downto 0);
        Y6  : out signed(31 downto 0);
        Y7  : out signed(31 downto 0);
        Y8  : out signed(31 downto 0);
        Y9  : out signed(31 downto 0);
        Y10 : out signed(31 downto 0)
    );
end component;



	
	begin
	

		entrada: reg generic map(W1=>16) port map(reg_in=>x_in,load=>'1',reset=>reset,clk=>clk,reg_out=>x);
		
		
	--scs2:	for i in 0 to num_coef-1 generate --multiplicando
	--			x_mult(i)<=x*ld(i);
	--			k_mult(i)<=x*hd(i);
--			end generate scs2;

	multiplier: multiplier_block port map(
		X=>"0000000000000000"&x(15 downto 0),
		Y1=>x_mult(0),
		Y2=>x_mult(1),
		Y3=>x_mult(2),
		Y4=>x_mult(3),
		Y5=>x_mult(4),
		Y6=>x_mult(5),
		Y7=>x_mult(6),
		Y8=>x_mult(7),
		Y9=>x_mult(8),
		Y10=>x_mult(9)
	);
						
			
		
		
		a(num_coef-1)<=x_mult(num_coef-1);
		
	scs3 :  for i in num_coef-1 downto 1 generate -- somando

					delay_a: shift_register generic map((W1+W2),n_delay) port map(x_in=>a(i),clock=>clk,reset=>reset,enable=>'1',x_out=>conect_delay_a(i));
						
					a(i-1)<=conect_delay_a(i)+x_mult(i-1);
						
				end generate scs3;
		
		
		saida_low: reg generic map(W1=>16) port map(reg_in=>a(0)((W1+W2)-2 downto ((W1+W2)-2) - 15),load=>'1',reset=>reset,clk=>clk,reg_out=>output);
		--saida_high: reg generic map(W1=>16) port map(reg_in=>b(0)((W1+W2)-2 downto ((W1+W2)-2) - 15),load=>'1',reset=>reset,clk=>clk,reg_out=>output_high_des);
		
		

end main;