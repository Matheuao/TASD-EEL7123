Library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all;


entity test_sintesys_FPGA is
	port ( SW: in std_logic_vector(17 downto 0);
			clock: in std_logic;
		LEDR: out std_logic_vector(17 downto 0)
	);
	
end test_sintesys_FPGA;
architecture behavior of test_sintesys_FPGA is
signal reg1_out:std_logic_vector(17 downto 0);
signal reg2_in:std_logic_vector(17 downto 0);

component conpression_and_sum_top is

generic (n : natural := 4;
			version: natural:=1); -- version = 0 -> optimize version
		 						-- version = 1 -> non optimize version(BASE LINE)
port (SW: in std_logic_vector(17 downto 0);
LEDR: out std_logic_vector(17 downto 0)
); 

end component;

component reg is
generic(W1: integer);
	port ( signal reg_in :in  std_logic_vector(W1-1 downto 0):=(others=>'0') ;
			signal load: in std_logic;
			signal reset: in std_logic;
			signal clk: in std_logic;
			signal reg_out: out std_logic_vector(W1-1 downto 0)
	 );
end component;


begin

reg1: reg generic map(W1=>17+1) port map(reg_in=>SW, load=>'1', reset=>'0',clk=>clock,reg_out=>reg1_out);
reg2: reg generic map(W1=>17+1) port map(reg_in=>reg2_in, load=>'1', reset=>'0',clk=>clock,reg_out=>LEDR);

top: conpression_and_sum_top generic map(n=>4, version=>1) port map(SW=> reg1_out, LEDR=>reg2_in);

end behavior;