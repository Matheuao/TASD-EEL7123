library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb is
end entity tb;

architecture tb_behavior of tb is
    signal n : integer := 20;
    type v is array (0 to 4) of integer;
    signal CLK      : std_logic := '0';
    signal RST      : std_logic := '1';
    signal EN       : std_logic := '0';
    signal S        : std_logic_vector(1 downto 0) := (others => '0');
    signal Data_in : std_logic_vector(n-1 downto 0):= (others => '0');
    signal Data_out : std_logic_vector(n-1 downto 0):=(others => '0');
    signal Data_out_expected_signal: std_logic_vector(n-1 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin

    uut: entity work.registrador_multi
        generic map(n=>n)
        port map (
            CLK =>CLK,
            RST =>RST,
            EN =>EN,
            S =>S,
            Data_in=>Data_in,
            Data_out=>Data_out
        );
    -- gerador de clock
    clk_gen : process
    begin
        while now < 2 ms loop
            CLK <= '0';
            wait for CLK_PERIOD/2;
            CLK <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process clk_gen;

    -- monitor: imprime estado dos sinais a cada borda de subida
    monitor_proc : process
    variable S_got: integer;
    variable Data_out_got: integer;

    begin
        wait until rising_edge(CLK);
        S_got:= to_integer(unsigned(S));
        
        Data_out_got:= to_integer(unsigned(Data_out));

        report "T = " & time'image(now)
            & " | RST=" & std_logic'image(RST)
            & " EN=" & std_logic'image(EN)
            & " S=" & integer'image(S_got)
            & " Data_out=" & integer'image(Data_out_got);
    end process monitor_proc;

    -- processo de estímulo: aplica reset e percorre a "máquina de estados"
    stim_proc: process
    variable Data  : v :=(2,4,6,(2**16)-1);
   -- variable Data_out_expected:v:=(2**19,4**19,6**19,8**19);
    variable temp_unsigned : unsigned(31 downto 0);
    begin
        --Data_out_expected:= (Data**19);
    --    temp_unsigned := to_unsigned(Data_out_expected(0), 32);  -- espaço suficiente
    --    Data_out_expected_signal <= std_logic_vector(resize(temp_unsigned, n));

        -- reset ativo por alguns ciclos
        RST <= '0';
        EN  <= '0';
        S   <= "00";
        Data_in <= std_logic_vector(to_unsigned(Data(0),n)); -- 2
        wait for 2 * CLK_PERIOD;

        -- desativa reset e habilita o componente
        RST <= '1';
        wait for CLK_PERIOD;
        EN <= '1';

        -- Sequência de 9 estados (cada atribuição de S ocorre logo após uma borda de subida,
        -- sendo efetiva no próximo ciclo dependendo da lógica do seu DUT)
        -- Estado 1: S = "01"
        wait until rising_edge(CLK);
        S <= "00";
        wait until rising_edge(CLK);
        S <= "01";

        -- Estado 2: S = "11"
        wait until rising_edge(CLK);
        S <= "11"; --A²

        -- Estado 3: S = "11"
        wait until rising_edge(CLK);
        S <= "11";-- A⁴

        -- Estado 4: S = "11"
        wait until rising_edge(CLK);
        S <= "11";--A⁸

        -- Estado 5: S = "11"
        wait until rising_edge(CLK);
        S <= "00";--A^9

        -- Estado 6: S = "00"
        wait until rising_edge(CLK);
        S <= "11";--A^18

        -- Estado 7: S = "00"
        wait until rising_edge(CLK);
        S <= "00";--A^19

        -- Estado 9: S = "10"
        wait until rising_edge(CLK);
        S <= "10";

        -- guarda alguns ciclos para observar efeitos
        wait for 1 * CLK_PERIOD;

        -- opcional: desabilita EN e aplica reset final
        EN <= '0';
        RST <= '1';
        wait for 2 * CLK_PERIOD;
        RST <= '0';

        report "End of tests";
        --assert false report "End of simulation" severity failure;
        std.env.stop;
        wait;
    end process stim_proc;

end architecture tb_behavior;
