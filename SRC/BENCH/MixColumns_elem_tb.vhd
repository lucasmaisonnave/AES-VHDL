-- MixColumns_elem_tb.vhd
-- test bench du MixColumns_elem
-- Lucas Maisonnave 27/11/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity MixColumns_elem_tb is
end MixColumns_elem_tb;

architecture MixColumns_elem_tb_arch of MixColumns_elem_tb is

    component MixColumns_elem is
    port(   
        mce_data_i : in  column_state;    -- 16 octets
        mce_data_o : out column_state);
    end component;

    signal mce_data_i_s, mce_data_o_s : column_state;
    signal test_ok_s : column_state;
    signal pass_fail_s : std_logic;

begin
    DUT : MixColumns_elem port map(
        mce_data_i  => mce_data_i_s,
        mce_data_o  => mce_data_o_s
    );
    mce_data_i_s <= (X"9f", X"19", X"10", X"7B");
    test_ok_s <= (X"65", X"E6", X"2B", X"45");
    pass_fail_s <= '1' when mce_data_o_s = test_ok_s else '0';

end MixColumns_elem_tb_arch ; -- arch

configuration MixColumns_elem_tb_conf of MixColumns_elem_tb is
    for MixColumns_elem_tb_arch
        for DUT : MixColumns_elem
            use entity LIB_RTL.MixColumns_elem(MixColumns_elem_arch);
        end for;
    end for;
end MixColumns_elem_tb_conf;
