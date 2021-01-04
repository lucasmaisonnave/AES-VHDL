library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AddRoundKey_tb is
end AddRoundKey_tb;

architecture AddRoundKey_tb_arch of AddRoundKey_tb is

    component AddRoundKey is
    port(   
        ark_data_i, key_i : in  type_state;
        ark_data_o : out type_state);
    end component;

    signal ark_data_i_s, ark_data_o_s, key_i_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

begin
    DUT : AddRoundKey port map(
        ark_data_i  => ark_data_i_s,
        ark_data_o  => ark_data_o_s,
        key_i => key_i_s
    );
    ark_data_i_s <= ((X"45", X"75", X"6E", X"E8"), 
                     (X"73", X"20", X"66", X"65"), 
                     (X"2D", X"63", X"69", X"20"), 
                     (X"74", X"6F", X"6E", X"3F"));

    key_i_s <= ((X"2B", X"28", X"AB", X"09"), 
                (X"7E", X"AE", X"F7", X"CF"), 
                (X"15", X"D2", X"15", X"4F"), 
                (X"16", X"A6", X"88", X"3C"));

    test_ok_s <= ((X"6E", X"5D", X"C5", X"E1"), 
                  (X"0D", X"8E", X"91", X"AA"), 
                  (X"38", X"B1", X"7C", X"6F"), 
                  (X"62", X"C9", X"E6", X"03"));

    pass_fail_s <= '1' when ark_data_o_s = test_ok_s else '0';

end AddRoundKey_tb_arch ; -- arch

configuration AddRoundKey_tb_conf of AddRoundKey_tb is
    for AddRoundKey_tb_arch
        for DUT : AddRoundKey
            use entity LIB_RTL.AddRoundKey(AddRoundKey_arch);
        end for;
    end for;
end AddRoundKey_tb_conf;