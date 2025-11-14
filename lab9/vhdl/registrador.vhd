library ieee;
use ieee.std_logic_1164.all;

entity registrador is 
generic(n:integer :=10);
port (
    CLK, RST, EN: in std_logic;
    D: in std_logic_vector(n-1 downto 0);
    Q: out std_logic_vector(n-1 downto 0)
    );
end registrador;
architecture behv of registrador is 

begin
	process (CLK, RST, EN, D)
    begin
        if RST = '0' then
            Q <= (others=>'0');
        elsif rising_edge(CLK) then
            if EN = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end behv;