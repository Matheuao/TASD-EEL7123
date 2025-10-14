library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavior of tb is
    constant n : integer := 4;
    
    signal X : std_logic_vector(4*n - 1 downto 0);
    signal X1 : std_logic_vector(2*n - 1 downto 0);
    signal X2 : std_logic_vector (n-1 downto 0);
    signal X3: std_logic_vector(n downto 0);
    signal X1_expected_sig: std_logic_vector(2 * n -1 downto 0):= (others =>'0');
    signal X2_expected_sig: std_logic_vector(n -1 downto 0):= (others =>'0');
    signal X3_expected_sig: std_logic_vector(n downto 0):= (others =>'0');
begin

    uut: entity work.traditional_BinToRNS
        port map (
            X =>X,
            X1 =>X1,
            X2 =>X2,
            X3 => X3
        );

    stim_proc: process
        variable got_X1      : integer;
        variable got_X2      : integer;
        variable got_X3      : integer;

        variable X1_expected :integer;
        variable X2_expected :integer;
        variable X3_expected :integer;

        type v is array (0 to 4) of integer;
        variable X_test: v :=(0,511,1020,65279);
        variable X1_test_expected: v := (0,255,252,255);
        variable X2_test_expected: v := (0,1,0,14);
        variable X3_test_expected: v := (0,1,0,16); 
    begin
        report "initiating testbench" severity note;

        -- uses all possibles values of A
        for j in 0 to 3 loop
            
            X <= std_logic_vector(to_unsigned(X_test(j), 4*n));

            wait for 1 ns;
            -- signals to show in the gtkwave 
            X1_expected:=X1_test_expected(j);
            X2_expected:=X2_test_expected(j);
            X3_expected:=X3_test_expected(j);

            X1_expected_sig <= std_logic_vector(to_unsigned(X1_expected,2*n));
            X2_expected_sig <= std_logic_vector(to_unsigned(X2_expected,n));
            X3_expected_sig <= std_logic_vector(to_unsigned(X3_expected,n+1));

            got_X1 := to_integer(unsigned(X1));
            got_X2 := to_integer(unsigned(X2));
            got_X3 := to_integer(unsigned(X3));

            assert got_X1 = X1_expected
                report "Mismatch: X = " & integer'image(X_test(j))&
                       "|" & " expected X1 =" & integer'image(X1_expected) & " got =" & integer'image(got_X1) &
                       "|" & " expected X2 =" & integer'image(X2_expected) & " got =" & integer'image(got_X2) &
                       "|" & " expected X3 =" & integer'image(X3_expected) & " got =" & integer'image(got_X3)
                severity failure;

            assert got_X2 = X2_expected
                report "Mismatch: X = " & integer'image(X_test(j)) &
                       "|" & " expected X1 =" & integer'image(X1_expected) & " got =" & integer'image(got_X1) &
                       "|" & " expected X2 =" & integer'image(X2_expected) & " got =" & integer'image(got_X2) &
                       "|" & " expected X3 =" & integer'image(X3_expected) & " got =" & integer'image(got_X3)
                severity failure;

            assert got_X3 = X3_expected
                report "Mismatch: X = " & integer'image(X_test(j)) &
                       "|" & " expected X1 =" & integer'image(X1_expected) & " got =" & integer'image(got_X1) &
                       "|" & " expected X2 =" & integer'image(X2_expected) & " got =" & integer'image(got_X2) &
                       "|" & " expected X3 =" & integer'image(X3_expected) & " got =" & integer'image(got_X3)
                severity failure;
            
            wait for 40 ns;

        end loop;

        report "End of tests" severity note;
        wait; 
    end process stim_proc;

end architecture behavior;
