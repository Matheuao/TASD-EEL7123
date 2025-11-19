library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavior of tb is
    constant n : integer := 4;
    constant w : integer :=16;
    
    signal X : std_logic_vector(w-1 downto 0);
    signal SEL: std_logic_vector(1 downto 0);
    signal Y: std_logic_vector(w-1 downto 0);

    signal Y_expected_sig: std_logic_vector(w-1 downto 0):= (others =>'0');
    
begin

    uut: entity work.main
    generic map(w => 16)
        port map (
            X =>X,
            SEL =>SEL,
            Y =>Y
        );

    stim_proc: process
        variable got_Y      : integer;
        variable Y_expected :integer;

        type v is array (0 to 4) of integer;
        --variable X_test: v :=(1,1,1,1);
        --variable X_test: v := (512,128,8,1);
        variable X_test: v := (1,2,2,4);
        variable SEL_test: v :=(0,1,2,3);
        
        --constantes
        variable C1: integer :=34817;
        variable C2: integer :=26113;
        variable C3: integer :=21761;
        variable C4: integer :=13057;
    begin
        report "initiating testbench" severity note;

        -- uses all possibles values of A
        for j in 0 to 3 loop
            
            X <= std_logic_vector(to_unsigned(X_test(j), w));
            SEL <= std_logic_vector(to_unsigned(SEL_test(j), 2));

            wait for 1 ns;

            if SEL_test(j) = 0 then 
                Y_expected:=X_test(j)*C1;
            
            elsif SEL_test(j) = 1 then
                Y_expected:=X_test(j)*C2;

            elsif SEL_test(j) = 2 then
                Y_expected:=X_test(j)*C3;

            elsif SEL_test(j) = 3 then
                Y_expected:=X_test(j)*C4;
            
            end if;

            Y_expected_sig <= std_logic_vector(to_unsigned(Y_expected,w));

            got_Y := to_integer(unsigned(Y));

            assert got_Y = Y_expected
                report "Mismatch: X = " & integer'image(X_test(j))&
                       "|" & " expected Y =" & integer'image(Y_expected) & " got =" & integer'image(got_Y)
                severity failure;
            
            wait for 40 ns;

        end loop;

        report "End of tests" severity note;
        wait; 
    end process stim_proc;

end architecture behavior;
