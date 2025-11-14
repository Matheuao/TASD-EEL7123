library ieee;
use ieee.std_logic_1164.all;

entity registrador_multi_top is
port (
    SW: in std_logic_vector(17 downto 0);
    KEY: in std_logic_vector(1 downto 0);
    LEDR: out std_logic_vector(15 downto 0)
    );
end registrador_multi_top;
architecture behv of registrador_multi_top is 
signal clk_not, rst_not : std_logic;
component registrador_multi
generic(n:integer :=16);
port (
    CLK, RST, EN: in std_logic;
    S: in std_logic_vector(1 downto 0);
    Data_in: in std_logic_vector(n-1 downto 0);
    Data_out: out std_logic_vector(n-1 downto 0)
    );
end component;

begin
	clk_not<=not(KEY(1));
    rst_not<= not(KEY(0));
    comp: registrador_multi
        generic map(n=>16)
        port map(CLK=>clk_not,
                RST=>KEY(0),
                EN =>'1',
                S=>SW(17 downto 16),
                Data_in=>SW(15 downto 0),
                Data_out=>LEDR(15 downto 0)
                );

end behv;