-- ShiftRows.vhd
-- Implémentation du bloc ShiftRows

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity ShiftRows is
    port(
        shr_data_i : in  type_state;    -- 16 octets
        shr_data_o : out type_state
    );
end entity ShiftRows;

architecture ShiftRows_arch of ShiftRows is
begin

    --ON décale les lignes
    G1 : for i in 0 to 3 generate
        G2 : for j in 0 to 3 generate
            shr_data_o(i)(j) <= shr_data_i(i)((i+j) mod 4);
        end generate G2;
    end generate G1;

end architecture ShiftRows_arch;
