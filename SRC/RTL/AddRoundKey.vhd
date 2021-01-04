-- AddRoundKey.vhd
-- Implémentation du bloc AddRoundKey

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AddRoundKey is
    port(
        ark_data_i, key_i : in  type_state;    -- 16 octets
        ark_data_o : out type_state
    );
end entity AddRoundKey;

architecture AddRoundKey_arch of AddRoundKey is
begin

    --ON génére les 16 mots
    G1 : for i in 0 to 3 generate
        G2 : for j in 0 to 3 generate
            ark_data_o(i)(j) <= ark_data_i(i)(j) xor key_i(i)(j);
        end generate G2;
    end generate G1;

end architecture AddRoundKey_arch;