Library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;


entity test is

	generic(W1: integer:=16);
	port ( signal x_in :in  signed(W1-1 downto 0):=(others=>'0') ;
			signal x2_in  : in signed(w1-1 downto 0):=(others=>'0') ;
			signal load: in std_logic;
			signal reset: in std_logic;
			signal clk: in std_logic;
			signal y: out signed(W1-1 downto 0)
	 );
end test;
architecture behavior of test is
signal x,x2 : signed(15 downto 0);
signal x_sum: signed(15 downto 0);
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
 begin

 entrada: reg generic map(W1=>16) port map(reg_in=>x_in,load=>'1',reset=>reset,clk=>clk,reg_out=>x);
 entrada2: reg generic map(W1=>16) port map(reg_in=>x2_in,load=>'1',reset=>reset,clk=>clk,reg_out=>x2);

 
 x_sum<= x+x2;

 saida: reg generic map(W1=>16) port map(reg_in=>x_sum,load=>'1',reset=>reset,clk=>clk,reg_out=>y);

end behavior;