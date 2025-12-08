library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_block_modified is
  port (
    X   : in  signed(31 downto 0);
    Y1  : out signed(31 downto 0);
    Y2  : out signed(31 downto 0);
    Y3  : out signed(31 downto 0);
    Y4  : out signed(31 downto 0);
    Y5  : out signed(31 downto 0);
    Y6  : out signed(31 downto 0);
    Y7  : out signed(31 downto 0);
    Y8  : out signed(31 downto 0);
    Y9  : out signed(31 downto 0);
    Y10 : out signed(31 downto 0)
  );
end entity multiplier_block_modified;

architecture rtl of multiplier_block_modified is

  signal w1, w8      : signed(31 downto 0);
  signal w2, w2048        : signed(31 downto 0);
  signal w3207, w2038, w1019, w1797, w4, w3, w192          : signed(31 downto 0);
  signal w1855, w768, w771, w24, w747, w48, w2095          : signed(31 downto 0);
  signal w8380, w8391, w2304, w2313, w16304, w13991        : signed(31 downto 0);
  signal w3710, w16782, w5614                               : signed(31 downto 0);
  signal w5614_neg, w747_neg, w145_neg, w291_neg           : signed(31 downto 0);
  
  type v2 is array (0 to 1) of signed(31 downto 0);
  type v4 is array (0 to 3) of signed(31 downto 0);
  
  signal w9,w144,w145,w154,w77,w290,w291 : v2; 
  signal w11, w2816, w2807,w2047, w1160:v2;

function shift_left_v2( v : v2; n : natural ) return v2 is
        variable r : v2;
    begin
        for i in 0 to 1 loop
            r(i) := v(i) sll n;
        end loop;
        return r;
    end function;

function shift_left_v4( v : v4; n : natural ) return v4 is
        variable r : v4;
    begin
        for i in 0 to 3 loop
            r(i) := v(i) sll n;
        end loop;
        return r;
    end function;

component compressor_4_2 is
generic (n : natural:=32);
  	 port(A : in signed((n-1) downto 0);
		  A_c : in signed((n-1) downto 0);
		  B : in signed((n-1) downto 0);
		  B_c : in signed((n-1) downto 0);
		  S : out signed((n-1) downto 0);
          S_c: out signed(n-1 downto 0)
     );
end component;


component compressor_4_2_neg is
generic (n : natural:=32);
  	 port(A : in signed((n-1) downto 0);
		  A_c : in signed((n-1) downto 0);
		  B : in signed((n-1) downto 0);
		  B_c : in signed((n-1) downto 0);
		  S : out signed((n-1) downto 0);
          S_c: out signed(n-1 downto 0)
     );
end component;

component compressor_3_2 is
generic (n : natural:=32);
  	 port(A : in signed((n-1) downto 0);
		  A_c : in signed((n-1) downto 0);
		  B : in signed((n-1) downto 0);
		  S : out signed((n-1) downto 0);
          S_c: out signed(n-1 downto 0)
     );
end component;


component compressor_3_2_neg is
generic (n : natural:=32);
  	 port(A : in signed((n-1) downto 0);
		  A_c : in signed((n-1) downto 0);
		  B : in signed((n-1) downto 0);
		  S : out signed((n-1) downto 0);
          S_c: out signed(n-1 downto 0)
     );
end component;


begin

  w1    <= X;
  w8    <= w1 sll 3;
  --w9 <= w1 + w8;
  w9(0)<=W1;
  w9(1)<=w8;
  --w144  <= w9 sll 4;
  w144 <= shift_left_v2(w9,4);

  --w145  <= w1 + w144;
  comp_3_2_w145: compressor_3_2 generic map(n=>32)
                               port map(A=>w144(0),
                                        A_c=>w144(1),
                                        B=>w1,
                                        S=>w145(0),
                                        S_c=>w145(1));
  --w154  <= w9 + w145;--compressor 4:2
  comp_4_2_w154: compressor_4_2 generic map(n=>32)
                                port map(A => w9(0),
                                        A_c =>w9(1),
                                        B =>w145(0),
                                        B_c =>w145(1),
                                        S => w154(0),
                                        S_c => w154(1)
                                );
--w77 <= w154 srl 1;
  w77(0) <= w154(0) srl 1;
  w77(1) <= w154(1) srl 1;

--  w290  <= w145 sll 1;
  w290  <= shift_left_v2(w145,1);

--  w291  <= w1 + w290;
comp_3_2_w291: compressor_3_2 generic map(n=>32)
                               port map(A=>w290(0),
                                        A_c=>w290(1),
                                        B=>w1,
                                        S=>w291(0),
                                        S_c=>w291(1));
------------------------------------------------------------------
  w2    <= w1 sll 1;
  
  --w11   <= w9 + w2;

comp_3_2_w11: compressor_3_2 generic map(n=>32)
                               port map(A=>w9(0),
                                        A_c=>w9(1),
                                        B=>w2,
                                        S=>w11(0),
                                        S_c=>w11(1));
  --w2816 <= w11 sll 8;
  w2816 <= shift_left_v2(w11,8);
  --w2807 <= w2816 - w9;
comp_4_2_w2807: compressor_4_2_neg generic map(n=>32)
                                port map(A => w2816(0),
                                        A_c =>w2816(1),
                                        B =>w9(0),
                                        B_c =>w9(1),
                                        S => w2807(0),
                                        S_c => w2807(1)
                                );


  w2048 <= w1 sll 11;
  
  --w2047 <= w2048 - w1;
  w2047(0)<= w2048;
  w2047(1)<= w1; -- prestar atensão esse aqui deve ser negativo

  --w1160 <= w145 sll 3;
  w1160 <= shift_left_v2(145,3);
  
  --w3207 <= w1160 + w2047;
comp_4_2_w3207: compressor_4_2_neg generic map(n=>32)
                                port map(A => w1160(0),
                                        A_c =>w1160(1),
                                        B =>w2047(0),
                                        B_c =>w9(1),
                                        S => w2807(0),
                                        S_c => w2807(1)
                                );

  w2038 <= w2047 - w9;
  w1019 <= '0'& w2038(31 downto 1);--w2038 sra 1;
  w1797 <= w2816 - w1019;

  w4    <= w1 sll 2;
  w3    <= w4 - w1;
  w192  <= w3 sll 6;
  w1855 <= w2047 - w192;

  w768  <= w3 sll 8;
  w771  <= w3 + w768;
  w24   <= w3 sll 3;
  w747  <= w771 - w24;

  w48   <= w3 sll 4;
  w2095 <= w2047 + w48;
  w8380 <= w2095 sll 2;
  w8391 <= w11 + w8380;

  w2304 <= w9 sll 8;
  w2313 <= w9 + w2304;
  w16304<= w1019 sll 4;
  w13991<= w16304 - w2313;

  w3710 <= w1855 sll 1;
  w16782<= w8391 sll 1;
  w5614 <= w2807 sll 1;

  ----------------------------------------------------------------------
  -- COMPLEMENTO DE DOIS EXPLÍCITO
  ----------------------------------------------------------------------
  w5614_neg <= not(w5614) + 1;
  w747_neg  <= not(w747)  + 1;
  w145_neg  <= not(w145)  + 1;
  w291_neg  <= not(w291)  + 1;

  ----------------------------------------------------------------------
  -- SAÍDAS
  ----------------------------------------------------------------------
  Y1  <= w3710;
  Y2  <= w13991;
  Y3  <= w16782;
  Y4  <= w3207;
  Y5  <= w5614_neg;
  Y6  <= w747_neg;
  Y7  <= w1797;
  Y8  <= w145_neg;
  Y9  <= w291_neg;
  Y10 <= w77;

end architecture rtl;
