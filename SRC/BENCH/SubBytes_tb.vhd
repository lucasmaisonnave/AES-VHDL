-- SubBytes_tb.vhd
-- test bench du SubBytesr
-- Lucas Maisonnave 27/11/2020
-- Marche bien

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity SubBytes_tb is
end SubBytes_tb;

architecture SubBytes_tb_arch of SubBytes_tb is

    component SubBytes is
    port(   
        sub_data_i : in  type_state;
        sub_data_o : out type_state);
    end component;

    signal sub_data_i_s, sub_data_o_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

begin
    DUT : SubBytes port map(
        sub_data_i  => sub_data_i_s,
        sub_data_o  => sub_data_o_s
    );
    sub_data_i_s <= ((X"6E", X"0D", X"38", X"62"), 
                     (X"5D", X"8E", X"B1", X"C9"), 
                     (X"C5", X"91", X"7C", X"E6"), 
                     (X"E1", X"AA", X"6F", X"03"));
    test_ok_s <= ((X"9f", X"d7", X"07", X"aa"), 
                  (X"4c", X"19", X"c8", X"dd"),
                  (X"a6", X"81", X"10", X"8e"), 
                  (X"f8", X"ac", X"a8", X"7b"));
    pass_fail_s <= '1' when sub_data_o_s = test_ok_s else '0';
    

end SubBytes_tb_arch ; -- arch

configuration SubBytes_tb_conf of SubBytes_tb is
    for SubBytes_tb_arch
        for DUT : SubBytes
            use configuration LIB_RTL.SubBytes_conf;
        end for;
    end for;
end SubBytes_tb_conf;