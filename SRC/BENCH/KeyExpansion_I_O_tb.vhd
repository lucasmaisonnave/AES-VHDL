-- KeyExpansion_I_O_tb.vhd
-- test bench du KeyExpansion_I_O
-- Lucas Maisonnave 12/12/2020
-- Marche bien
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansion_I_O_tb is
end KeyExpansion_I_O_tb;

architecture KeyExpansion_I_O_tb_arch of KeyExpansion_I_O_tb is

    component KeyExpansion_I_O is
    port(   
        key_i : in  bit128;    -- 16 octets
        start_i : in std_logic;
        clock_i : in std_logic;
        reset_i : in std_logic;
        expansion_key_o : out bit128);
    end component;

    signal key_i_s, expansion_key_o_s  : bit128;
    signal start_i_s, reset_i_s: std_logic;
    signal clock_i_s : std_logic := '0';
    signal test_ok_s : bit128;
    signal pass_fail_s: std_logic;
begin
    DUT : KeyExpansion_I_O port map(
        key_i => key_i_s,    
        expansion_key_o => expansion_key_o_s,
        start_i => start_i_s,
        clock_i => clock_i_s,
        reset_i => reset_i_s
    );
    clock_i_s <= not(clock_i_s) after 100 ns;
    start_i_s <= '1'after 50 ns , '0' after 250 ns,'1'after 5000 ns , '0' after 5250 ns;
    reset_i_s <= '0', '1' after 100 ns; 
    key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c" after 50 ns;

    test_ok_s <=X"2b7e151628aed2a6abf7158809cf4f3c",    --Round 0
    X"a0fafe1788542cb123a339392a6c7605" after 300 ns,   --Round 1
    X"f2c295f27a96b9435935807a7359f67f" after 500 ns,   --Round 2
    X"3d80477d4716fe3e1e237e446d7a883b" after 700 ns,   --Round 3
    X"ef44a541a8525b7fb671253bdb0bad00" after 900 ns,   --Round 4
    X"d4d1c6f87c839d87caf2b8bc11f915bc" after 1100 ns,  --Round 5
    X"6d88a37a110b3efddbf98641ca0093fd" after 1300 ns,  --Round 6
    X"4e54f70e5f5fc9f384a64fb24ea6dc4f" after 1500 ns,  --Round 7
    X"ead27321b58dbad2312bf5607f8d292f" after 1700 ns,  --Round 8
    X"ac7766f319fadc2128d12941575c006e" after 1900 ns,  --Round 9
    X"d014f9a8c9ee2589e13f0cc8b6630ca6" after 2100 ns;  --Round 10
    pass_fail_s <= '1' when expansion_key_o_s = test_ok_s else '0';
end KeyExpansion_I_O_tb_arch ; -- arch

configuration KeyExpansion_I_O_tb_conf of KeyExpansion_I_O_tb is
    for KeyExpansion_I_O_tb_arch
        for DUT : KeyExpansion_I_O
            use configuration LIB_RTL.KeyExpansion_I_O_conf;
        end for;
    end for;
end KeyExpansion_I_O_tb_conf;

--Round 0 -> 1
--key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c"; Rcom_i_s <= (X"01", X"00", X"00", X"00"); test_ok_s <= X"a0fafe1788542cb123a339392a6c7605";
