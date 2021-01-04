-- AES_tb.vhd
-- test bench du AES
-- Lucas Maisonnave 15/12/2020
-- En cours de test
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AES_tb is
end AES_tb;

architecture AES_tb_arch of AES_tb is

    component AES is
    port(   
        clock_i	: in  std_logic;
        reset_i	: in  std_logic;
        start_i	: in  std_logic;
        key_i	: in  bit128;
        data_i	: in  bit128;
        data_o	: out bit128;
        aes_on_o : out std_logic);
    end component;

    signal key_i_s, data_i_s, data_o_s : bit128;
    signal start_i_s, reset_i_s, aes_on_o_s: std_logic;
    signal clock_i_s : std_logic := '0';
    signal test_ok_s : bit128;
    signal pass_fail_s: std_logic;
begin
    DUT : AES port map(
        clock_i	=> clock_i_s,
        reset_i	=> reset_i_s,
        start_i	=> start_i_s,
        key_i	=> key_i_s,
        data_i	=> data_i_s,
        data_o	=> data_o_s,
        aes_on_o => aes_on_o_s
    );
    clock_i_s <= not(clock_i_s) after 100 ns;
    start_i_s <= '1', '0' after 320 ns;
    reset_i_s <= '1', '0' after 150 ns; 
    key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c";
    data_i_s <=  X"45732d747520636f6e66696ee865203f";
    test_ok_s <= X"cd301f3e1f969b1e6d37d179807b55b4";
    pass_fail_s <= '1' when data_o_s = test_ok_s else '0';
end AES_tb_arch ; -- arch

configuration AES_tb_conf of AES_tb is
    for AES_tb_arch
        for DUT : AES
            use configuration LIB_RTL.AES_conf;
        end for;
    end for;
end AES_tb_conf;

--Round 0 -> 1
--key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c"; Rcom_i_s <= (X"01", X"00", X"00", X"00"); test_ok_s <= X"a0fafe1788542cb123a339392a6c7605";
