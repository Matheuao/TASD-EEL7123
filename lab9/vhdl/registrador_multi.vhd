library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity registrador_multi is 
generic(n:integer :=16);
port (
    CLK, RST, EN: in std_logic;
    S: in std_logic_vector(1 downto 0);
    Data_in: in std_logic_vector(n-1 downto 0);
    Data_out: out std_logic_vector(n-1 downto 0)
    );
end registrador_multi;
architecture behv of registrador_multi is 
signal Q: std_logic_vector(n-1 downto 0);
signal mux_out: std_logic_vector(n-1 downto 0);
signal i_times_Q:unsigned(n-1 downto 0);
signal Q_square:unsigned(n-1 downto 0);
signal i_times_Q_temp:unsigned(2*n-1 downto 0);
signal Q_square_temp:unsigned(2*n-1 downto 0);

component mux41 is 
    generic(n:integer:=16);
    port (  
        A: in std_logic_vector (n-1 downto 0);
        B: in std_logic_vector (n-1 downto 0);
        C: in std_logic_vector (n-1 downto 0);
        D: in std_logic_vector (n-1 downto 0);
        s: in std_logic_vector(1 downto 0);
        F: out std_logic_vector (n-1 downto 0)
    );
end component;

component registrador is
    generic(n:integer :=10);
    port (
        CLK, RST, EN: in std_logic;
        D: in std_logic_vector(n-1 downto 0);
        Q: out std_logic_vector(n-1 downto 0)
    );

end component;

begin

i_times_Q_temp <= unsigned(data_in)*unsigned(Q);
Q_square_temp <= unsigned(Q)*unsigned(Q);
i_times_Q <=i_times_Q_temp(n-1 downto 0);
Q_square <= Q_square_temp(n-1 downto 0);

mux:mux41 generic map(n=>n)
           port map(
            A=>std_logic_vector(i_times_Q),
            B=>data_in,
            C=> Q,
            D=> std_logic_vector(Q_square),
            s=>S,
            F=>mux_out
           );
reg:registrador generic map(n=>n)
                port map(
                    CLK=>CLK,
                    RST=>RST,
                    EN=> EN,
                    D=> mux_out,
                    Q=> Q
                );

    Data_out<=Q;

end behv;