library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top is
end tb_top;

architecture behavior of tb_top is
    signal A_sig      : std_logic_vector(3 downto 0) := (others => '0');
    signal C_sig      : std_logic := '0';
    signal result_sig : std_logic_vector(10 downto 0);
    signal expected_sig: std_logic_vector(10 downto 0):= (others =>'0');
begin

    uut: entity work.top
        port map (
            A      => A_sig,
            C      => C_sig,
            result => result_sig
        );

    stim_proc: process
        variable a_int    : integer;
        variable expected : integer;
        variable got      : integer;
    begin
        report "initiating testbench" severity note;

        -- uses all possibles values of A
        for a_int in 0 to 15 loop
            A_sig <= std_logic_vector(to_unsigned(a_int, 4));

            -- test C = 0 -> R = 85 * A
            C_sig <= '0';
            wait for 1 ns;

            expected := 85 * a_int;
            expected_sig<= std_logic_vector(to_unsigned(expected,11));
            got := to_integer(unsigned(result_sig));
            assert got = expected
                report "Mismatch: C=0 A=" & integer'image(a_int) & " expected=" & integer'image(expected) & " got=" & integer'image(got)
                severity failure;
            
            wait for 40 ns;
  
            -- test C = 1 -> R = 49 * A + 1164
            C_sig <= '1';
            wait for 1 ns;

            expected := 49 * a_int + 1164;
            expected_sig<= std_logic_vector(to_unsigned(expected,11));
            got := to_integer(unsigned(result_sig));

            assert got = expected
                report "Mismatch: C=1 A=" & integer'image(a_int) & " expected=" & integer'image(expected) & " got=" & integer'image(got)
                severity failure;
				
            wait for 40 ns;
        end loop;

        report "End of tests" severity note;
        wait; 
    end process stim_proc;

end architecture behavior;
