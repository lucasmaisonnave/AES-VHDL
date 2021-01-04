-- MixColumns.vhd
-- Implémentation du bloc MixColumns

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity MixColumns is
    port(
        mc_data_i : in  type_state;    -- 16 octets
        enable_i  : in  std_logic;
        mc_data_o : out type_state
    );
end entity MixColumns;

architecture MixColumns_arch of MixColumns is
    component MixColumns_elem is
        port(
            mce_data_i : in  column_state;    -- 4 octets
            mce_data_o : out column_state
        );
    end component MixColumns_elem;
    signal data_o_s : type_state;
begin
    G1 : for i in 0 to 3 generate
        inter : MixColumns_elem port map(
            mce_data_i(0) => mc_data_i(0)(i), 
            mce_data_i(1) => mc_data_i(1)(i),
            mce_data_i(2) => mc_data_i(2)(i), 
            mce_data_i(3) => mc_data_i(3)(i),

            mce_data_o(0) => data_o_s(0)(i), 
            mce_data_o(1) => data_o_s(1)(i), 
            mce_data_o(2) => data_o_s(2)(i), 
            mce_data_o(3) => data_o_s(3)(i)
        );
    mc_data_o <= data_o_s when enable_i = '1' else mc_data_i;
    end generate G1;

end architecture MixColumns_arch;

configuration MixColumns_conf of MixColumns is
    for MixColumns_arch
        for G1
            for all : MixColumns_elem
                use entity LIB_RTL.MixColumns_elem(MixColumns_elem_arch);
            end for;
        end for;
    end for;
end MixColumns_conf;