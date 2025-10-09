library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavior of tb is
    constant n : integer := 4;
    
    signal R1 : std_logic_vector(2*n - 1 downto 0);
    signal R2 : std_logic_vector(n-1 downto 0);
    signal R3 : std_logic_vector (n downto 0);
    signal bin: std_logic_vector(4 * n -1 downto 0);
    signal expected_sig: std_logic_vector(4 * n -1 downto 0):= (others =>'0');
begin

    uut: entity work.RNStoBin_traditional
        port map (
            R1 =>R1,
            R2 =>R2,
            R3 =>R3,
            bin => bin
        );

    stim_proc: process
        variable expected : integer;
        variable got      : integer;

        type v is array (0 to 4) of integer;

        variable R1_test: v := (0,255,252,255);
        variable R2_test: v := (0,1,0,14);
        variable R3_test: v := (0,1,0,16);
        variable bin_test_expected: v := (0, 511, 1020, 65279); 
    begin
        report "initiating testbench" severity note;

        -- uses all possibles values of A
        for j in 0 to 3 loop
            
            R1 <= std_logic_vector(to_unsigned(R1_test(j), 2*n));
            R2 <= std_logic_vector(to_unsigned(R2_test(j), n));
            R3 <= std_logic_vector(to_unsigned(R3_test(j), n+1));

            wait for 1 ns;

            expected := bin_test_expected(j);
            expected_sig <= std_logic_vector(to_unsigned(expected,4*n));

            got := to_integer(unsigned(bin));

            assert got = expected
                report "Mismatch: R1 = " & integer'image(R1_test(j)) &
                                " R2 = " & integer'image(R2_test(j)) &
                                " R3 = " & integer'image(R3_test(j)) &
                                " expected =" & integer'image(expected) & " got =" & integer'image(got)
                severity failure;
            
            wait for 40 ns;

        end loop;

        report "End of tests" severity note;
        wait; 
    end process stim_proc;

end architecture behavior;
