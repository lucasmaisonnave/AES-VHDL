-- KeyExpansion.vhd
-- Implémentation de KeyExpansion

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansion is
    port(
        key_i : in  bit128;    -- 16 octets
        expansion_key_o : out bit128;
        Rcon_i : in column_state
    );
end entity KeyExpansion;

architecture KeyExpansion_arch of KeyExpansion is
    component SBOX is
        port(
            data_i : in bit8;
            data_o : out bit8
        );
    end component SBOX;

    signal w_i, w_o : key_state;    --type key_state is array(0 to 3) of column_state; défini dans CryptPack
    signal w_rotword, w_sbox : column_state;

begin
    --Conversion en column_state
    K1 : for col in 0 to 3 generate
        K2 : for row in 0 to 3 generate
            w_i(col)(row) <= key_i(127 - 32*col - 8*row downto 120 - 32*col - 8*row); 
        end generate;
    end generate;

    --ON décale la colonne 3
    G1 : for i in 0 to 3 generate
        w_rotword(i) <= w_i(3)((1+i) mod 4);
    end generate G1;
    --On génére les sbox sur la colonne
    G2 : for i in 0 to 3 generate
        inter : SBOX port map(
            data_i => w_rotword(i),
            data_o => w_sbox(i)
        );
    end generate G2;

    --1er XOR, xor a été défini sur les columns_state
    w_o(0) <= w_i(0) xor w_sbox xor Rcon_i;
    --XOR 2,3,4
    X2 : for j in 1 to 3 generate
        w_o(j) <= w_i(j) xor w_o(j-1);
    end generate X2;

    --Conversion en bit128
    K3 : for col in 0 to 3 generate
        K4 : for row in 0 to 3 generate
            expansion_key_o(127 - 32*col - 8*row downto 120 - 32*col - 8*row) <= w_o(col)(row); 
        end generate;
    end generate;

end architecture KeyExpansion_arch;

configuration KeyExpansion_conf of KeyExpansion is
    for KeyExpansion_arch
        for G2
            for all : SBOX
                use entity LIB_RTL.SBOX(SBOX_arch);
            end for;
        end for;
    end for;
end KeyExpansion_conf;