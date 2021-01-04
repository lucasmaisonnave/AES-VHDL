-- MixColumns_tb.vhd
-- test bench du MixColumn
-- Lucas Maisonnave 07/12/2020
-- Marche bien
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity MixColumns_tb is
end MixColumns_tb;

architecture MixColumns_tb_arch of MixColumns_tb is

    component MixColumns is
    port(   
        mc_data_i : in  type_state;    -- 16 octets
        enable_i  : in  std_logic;
        mc_data_o : out type_state);
    end component;

    signal mc_data_i_s, mc_data_o_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s, enable_i_s : std_logic;
begin
    DUT : MixColumns port map(
        mc_data_i  => mc_data_i_s,
        mc_data_o  => mc_data_o_s,
        enable_i => enable_i_s
    );
    
    enable_i_s <= '0';
    mc_data_i_s <= ((X"9F", X"4C", X"A6", X"F8"), 
                    (X"19", X"81", X"AC", X"D7"), 
                    (X"10", X"A8", X"07", X"C8"), 
                    (X"7B", X"AA", X"DD", X"8E"));
    test_ok_s <= ((X"9F", X"4C", X"A6", X"F8"), 
                  (X"19", X"81", X"AC", X"D7"), 
                  (X"10", X"A8", X"07", X"C8"), 
                  (X"7B", X"AA", X"DD", X"8E"));
    pass_fail_s <= '1' when mc_data_o_s = test_ok_s else '0';
end MixColumns_tb_arch ; -- arch

configuration MixColumns_tb_conf of MixColumns_tb is
    for MixColumns_tb_arch
        for DUT : MixColumns
            use configuration LIB_RTL.MixColumns_conf;
        end for;
    end for;
end MixColumns_tb_conf;

--test_ok_s <= ((X"65", X"02", X"62", X"CF"), 
--                  (X"E6", X"1C", X"31", X"80"), 
--                  (X"2B", X"63", X"78", X"2D"), 
--                  (X"45", X"B2", X"FB", X"0B"));
