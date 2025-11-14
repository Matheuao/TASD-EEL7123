library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavior of tb is
    constant n : integer := 4;
    
    signal A : std_logic_vector (n - 1 downto 0);
    signal B : std_logic_vector (n-1 downto 0);
    signal C : std_logic_vector (n-1 downto 0);
    signal D : std_logic_vector (n -1 downto 0);
    signal RES: std_logic_vector(13 downto 0);

    signal expected_sig: std_logic_vector(13 downto 0):= (others =>'0');
begin

    uut: entity work.Compression_and_sum
        generic map(version=>0)-- version = 0 -> optimize version
		 						-- version = 1 -> non optimize version(BASE LINE)
        port map (
            A =>A,
            B =>B,
            C =>C,
            D =>D,
            RESULT => RES
        );

    stim_proc: process
        variable expected : integer;
        variable got      : integer;

        type v is array (0 to 4) of integer;

        variable A_test: v := (15,1,0,0,0);
        variable B_test: v := (15,0,1,0,0);
        variable C_test: v := (15,0,0,1,0);
        variable D_test: v := (15,0,0,0,1);
        
        variable bin_test_expected: v := ((36*15) + (44*15) + (164*15) + (548*15) + 36, 36+36,  44+36, 164+36, 548+36); 
    begin
        report "initiating testbench" severity note;

        -- uses all possibles values of A
        for j in 0 to 3 loop
            
            A <= std_logic_vector(to_unsigned(A_test(j), n));
            B <= std_logic_vector(to_unsigned(B_test(j), n));
            C <= std_logic_vector(to_unsigned(C_test(j), n));
            D <= std_logic_vector(to_unsigned(D_test(j), n));

            wait for 1 ns;

            expected := bin_test_expected(j);
            expected_sig <= std_logic_vector(to_unsigned(expected,14));

            got := to_integer(unsigned(RES));

            assert got = expected
                report "Mismatch: A = " & integer'image(A_test(j)) &
                                " B = " & integer'image(B_test(j)) &
                                " C = " & integer'image(C_test(j)) &
                                " D = " & integer'image(D_test(j)) &
                                " expected =" & integer'image(expected) & " got =" & integer'image(got)
                severity failure;
            
            wait for 40 ns;

        end loop;

        report "End of tests" severity note;
        wait; 
    end process stim_proc;

end architecture behavior;
