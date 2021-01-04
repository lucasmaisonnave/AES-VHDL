-- SubBytes.vhd
-- Implémentation de SubBytes

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity SubBytes is
    port(
        sub_data_i : in  type_state;    -- 16 octets
        sub_data_o : out type_state
    );
end entity SubBytes;

architecture SubBytes_arch of SubBytes is
    component SBOX is
        port(
            data_i : in bit8;
            data_o : out bit8
        );
    end component SBOX;
begin
    --ON génére les 16 SBOX
    G1 : for i in 0 to 3 generate
        G2 : for j in 0 to 3 generate
            inter : SBOX port map(
                data_i => sub_data_i(i)(j),
                data_o => sub_data_o(i)(j)
            );
        end generate G2;
    end generate G1;

end architecture SubBytes_arch;

configuration SubBytes_conf of SubBytes is
    for SubBytes_arch
        for G1
            for G2
                for all : SBOX
                    use entity LIB_RTL.SBOX(SBOX_arch);
                end for;
            end for;
        end for;
    end for;
end SubBytes_conf;