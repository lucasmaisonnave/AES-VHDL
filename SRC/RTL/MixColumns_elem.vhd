-- MixColumns_elem.vhd
-- Ce bloc permet d'appliquer le produit matriciel dans le corps de galois pour un seul colonne

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;

entity MixColumns_elem is
    port(
        mce_data_i : in  column_state;    -- 16 octets
        mce_data_o : out column_state
    );
end entity MixColumns_elem;

architecture MixColumns_elem_arch of MixColumns_elem is
    signal decal_octet, Octetx2, Octetx3 : column_state;
begin
    G1 : for i in 0 to 3 generate
        --ON mutiplie par 2
        decal_octet(i) <= mce_data_i(i)(6 downto 0)&'0';
        Octetx2(i) <= decal_octet(i) xor ("000" & mce_data_i(i)(7) & mce_data_i(i)(7) & '0' & mce_data_i(i)(7) & mce_data_i(i)(7));
        --ON mutiplie par 3
        Octetx3(i) <= Octetx2(i) xor mce_data_i(i);
    end generate G1;
        --ON applique le produit matriciel
        mce_data_o(0) <= (Octetx2(0)) xor (Octetx3(1)) xor mce_data_i(2) xor mce_data_i(3);
        mce_data_o(1) <= mce_data_i(0) xor (Octetx2(1)) xor (Octetx3(2)) xor mce_data_i(3);
        mce_data_o(2) <= mce_data_i(0) xor mce_data_i(1) xor (Octetx2(2)) xor (Octetx3(3));
        mce_data_o(3) <= (Octetx3(0)) xor mce_data_i(1) xor mce_data_i(2) xor (Octetx2(3));
    
end architecture MixColumns_elem_arch;