library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AESRound_tb is
end AESRound_tb;

architecture AESRound_tb_arch of AESRound_tb is

    component AESRound is
    port(   
        text_i : in  bit128;    -- 16 octets
        currentkey_i  : in  bit128;
        clock_i : in std_logic ;
        resetb_i : in std_logic;
        enableRoundComputing_i : in std_logic;
        enableMixColumns_i : in std_logic;
        data_o : out bit128
        );
    end component;

    signal text_i_s, currentkey_i_s, data_o_s : bit128;
    signal clock_i_s: std_logic := '1';
    signal resetb_i_s, enableRoundComputing_i_s, enableMixColumns_i_s: std_logic;
    signal test_ok_s : bit128;
    signal pass_fail_s : std_logic;

begin
    DUT : AESRound port map(
        text_i => text_i_s,    -- 16 octets
        currentkey_i  => currentkey_i_s,
        clock_i => clock_i_s,
        resetb_i => resetb_i_s,
        enableRoundComputing_i => enableRoundComputing_i_s,
        enableMixColumns_i => enableMixColumns_i_s,
        data_o => data_o_s
    );
    text_i_s <= X"45732d747520636f6e66696ee865203f";

    currentkey_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c",    --Round 0
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

    test_ok_s <= X"6e0d38625d8eb1c9c5917ce6e1aa6f03", 
    X"c51cd5528a484f03419241c2e5ec5b0e" after 400 ns, 
    X"7bf59a9f6e3dfab7754f46dfc411cf5d" after 600 ns,
    X"004d21fba4c49c27b3dbea8bd75891f3" after 800 ns,
    X"8780d86564e5a382e3188c981a9ca055" after 1000 ns,
    X"123fdf9fbbf77f95e3f480164e82a40a" after 1200 ns,
    X"f6ba2a5196848f83785dddab9eefbfa5" after 1400 ns, 
    X"ecf6795a699e6da59467d2944ea96311" after 1600 ns,
    X"474c5ac98dcdf2dbab73796ff9405a64" after 1800 ns,
    X"de34c9854aa61556f0c1f53924bf5a35" after 2000 ns;

    clock_i_s <= not(clock_i_s) after 100 ns;

    resetb_i_s <= '0', '1' after 100 ns;

    enableRoundComputing_i_s <= '0', '1' after 200 ns;

    enableMixColumns_i_s <= '0', '1' after 200 ns;    

    pass_fail_s <= '1' when data_o_s = test_ok_s else '0';

end AESRound_tb_arch ; -- arch

configuration AESRound_tb_conf of AESRound_tb is
    for AESRound_tb_arch
        for DUT : AESRound
            use configuration LIB_RTL.AESRound_conf;
        end for;
    end for;
end AESRound_tb_conf;