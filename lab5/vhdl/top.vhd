-- O objectivo deste laboratório consiste na implementação de uma unidade aritmética
-- baseada no problema resolvido pelo aluno no capitulo 5. A unidade faz a operação
-- R = 85 × A quando sinal de controle c = 0, e R = 49 × A + 1164 quando c = 1 sendo
-- a entrada A de 4 bits sem sinal e R saída de 11 bits sem sinal.
-- Usando o somador de 8-bits e o mínimo de lógica adicional implemente dito circuito
-- em VHDL. (Dica: o máximo de lógica adicional que pode ser usado, são 3 portas
-- MUX 2:1, 3 portas OR de duas entradas, 2 portas AND de duas entradas e duas portas
-- NOT.).

library IEEE;
use IEEE.Std_Logic_1164.all;

entity top is port (
		A: in std_logic_vector(3 downto 0);
		C: in std_logic;
		result: out std_logic_vector(10 downto 0)
);
end top;
  

architecture top_arc of top is

signal array_1: std_logic_vector(7 downto 0);
signal array_2: std_logic_vector(7 downto 0);
signal s_array: std_logic_vector(7 downto 0);


component mux21 is 
	port (A: in std_logic;
		B: in std_logic;
		s: in std_logic;
		F: out std_logic
	);
end component;

component adder is 
	generic(
		bits_num: integer
	);
	port (cin: in std_logic;
			V1: in std_logic_vector(bits_num-1 downto 0);
			V2: in std_logic_vector(bits_num-1 downto 0);
			S: out std_logic_vector(bits_num-1 downto 0);
			cout: out std_logic);
end component;

begin

array_1(0)<=c or A(0);
array_2(0)<=A(2);

array_1(1)<=c or A(1);
array_2(1)<=A(3);

array_1(2)<=not(c) and A(2);
array_2(2)<=A(0);

mux_1:mux21 port map(A=>A(3),B=>A(0), s=>C, F=>array_1(3));
array_2(3)<=A(1);

mux_2:mux21 port map(A=>A(0),B=>A(1), s=>C, F=>array_1(4));
array_2(4)<=A(2);

mux_3:mux21 port map(A=>A(1),B=>not(A(2)), s=>C, F=>array_1(5));
array_2(5)<=A(3);

array_1(6)<=c and A(3);
array_2(6)<=A(2);

array_1(7)<=c or A(3);
array_2(7)<=c;

custom_adder:adder generic map(8)
	port map(cin=>'0',
				V1=>array_1,
				V2=>array_2,
				S=>s_array,
				cout=>result(10));

result(9 downto 2)<=s_array;
result(1 downto 0)<=A(1 downto 0);

				

end top_arc;