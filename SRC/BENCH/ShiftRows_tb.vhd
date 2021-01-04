-- ShiftRows_tb.vhd
-- test bench du ShiftRows
-- Lucas Maisonnave 27/11/2020
-- Marche bien
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity ShiftRows_tb is
end ShiftRows_tb;

architecture ShiftRows_tb_arch of ShiftRows_tb is

    component ShiftRows is
    port(   
        shr_data_i : in  type_state;
        shr_data_o : out type_state);
    end component;

    signal shr_data_i_s, shr_data_o_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

begin
    DUT : ShiftRows port map(
        shr_data_i  => shr_data_i_s,
        shr_data_o  => shr_data_o_s
    );
    shr_data_i_s <= ((X"9f", X"4C", X"A6", X"F8"), 
                     (X"D7", X"19", X"81", X"AC"), 
                     (X"07", X"C8", X"10", X"A8"), 
                     (X"AA", X"DD", X"8E", X"7B"));
    test_ok_s <= ((X"9f", X"4C", X"A6", X"F8"), 
                  (X"19", X"81", X"AC", X"D7"), 
                  (X"10", X"A8", X"07", X"C8"), 
                  (X"7B", X"AA", X"DD", X"8E"));
    pass_fail_s <= '1' when shr_data_o_s = test_ok_s else '0';

end ShiftRows_tb_arch ; -- arch

configuration ShiftRows_tb_conf of ShiftRows_tb is
    for ShiftRows_tb_arch
        for DUT : ShiftRows
            use entity LIB_RTL.ShiftRows(ShiftRows_arch);
        end for;
    end for;
end ShiftRows_tb_conf;