-- KeyExpansion_tb.vhd
-- test bench du KeyExpansion
-- Lucas Maisonnave 12/12/2020
-- Marche bien
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansion_tb is
end KeyExpansion_tb;

architecture KeyExpansion_tb_arch of KeyExpansion_tb is

    component KeyExpansion is
    port(   
        key_i : in  bit128;    -- 16 octets
        expansion_key_o : out bit128;
        Rcon_i : in column_state);
    end component;

    signal key_i_s, expansion_key_o_s  : bit128;
    signal Rcon_i_s : column_state;
    signal test_ok_s : bit128;
    signal pass_fail_s: std_logic;
begin
    DUT : KeyExpansion port map(
        key_i => key_i_s,    
        expansion_key_o => expansion_key_o_s,
        Rcon_i => Rcon_i_s
    );
    
    key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c";
    Rcon_i_s <= (X"01", X"00", X"00", X"00");
    test_ok_s <= X"a0fafe1788542cb123a339392a6c7605";
    pass_fail_s <= '1' when expansion_key_o_s = test_ok_s else '0';
end KeyExpansion_tb_arch ; -- arch

configuration KeyExpansion_tb_conf of KeyExpansion_tb is
    for KeyExpansion_tb_arch
        for DUT : KeyExpansion
            use configuration LIB_RTL.KeyExpansion_conf;
        end for;
    end for;
end KeyExpansion_tb_conf;

--Round 0 -> 1
--key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c"; Rcom_i_s <= (X"01", X"00", X"00", X"00"); test_ok_s <= X"a0fafe1788542cb123a339392a6c7605";
