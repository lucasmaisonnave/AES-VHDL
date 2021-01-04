-- AESRound.vhd
-- Module AESRound
-- Implémentation du bloc AESRound


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AESRound
 is
    port(
        text_i : in  bit128;    -- 16 octets
        currentkey_i  : in  bit128;
        clock_i : in std_logic;
        resetb_i : in std_logic;
        enableRoundComputing_i : in std_logic;
        enableMixColumns_i : in std_logic;
        data_o : out bit128
    );
end entity AESRound;

architecture AESRound_arch of AESRound is

    component SubBytes is
        port(
            sub_data_i : in  type_state;    -- 16 octets
            sub_data_o : out type_state
        );
    end component SubBytes;

    component ShiftRows is
        port(
            shr_data_i : in  type_state;    -- 16 octets
            shr_data_o : out type_state
        );
    end component ShiftRows;

    component MixColumns is
        port(
            mc_data_i : in  type_state;    -- 16 octets
            enable_i  : in  std_logic;
            mc_data_o : out type_state
        );
    end component MixColumns;

    component AddRoundKey is
        port(
            ark_data_i, key_i : in  type_state;    -- 16 octets
            ark_data_o : out type_state
        );
    end component AddRoundKey;

    signal output_SB_s, output_SR_s, output_MC_s, text_state_s, currentKeyState_s, output_MUX_s, output_ARK_s, data_s : type_state;

begin
    --conversion de text_i et current_i en type_state
    K1 : for col in 0 to 3 generate
        K2 : for row in 0 to 3 generate
            currentKeyState_s(row)(col) <= currentkey_i(127 - 32*col - 8*row downto 120 - 32*col - 8*row);
            text_state_s(row)(col) <= text_i(127 - 32*col - 8*row downto 120 - 32*col - 8*row);
        end generate;
    end generate;

    --Bloc SubBytes
    SB : SubBytes port map(
        sub_data_i => data_s,
        sub_data_o => output_SB_s
    );
    --Bloc ShiftRows
    SR : ShiftRows port map(
        shr_data_i => output_SB_s,
        shr_data_o => output_SR_s
    );
    --Bloc MixColumns
    MC : MixColumns port map(
        mc_data_i => output_SR_s,
        mc_data_o => output_MC_s,
        enable_i => enableMixColumns_i
    );

    --Multiplexeur
    output_MUX_s <= output_MC_s when enableRoundComputing_i = '1' else text_state_s;

    --AddRoundKey
    AR : AddRoundKey port map(
        ark_data_i => output_MUX_s, 
        key_i  => currentKeyState_s,    -- 16 octets
        ark_data_o => output_ARK_s
    );

    --Registre
    P0 : process(output_ARK_s, clock_i, resetb_i)
    begin   
        if resetb_i = '0' then
            R0 : for i in 0 to 3 loop
                R1 : for j in 0 to 3 loop
                    data_s(i)(j) <= (others => '0');
                end loop;
            end loop;
        elsif (clock_i'event and clock_i = '1') then
            data_s <= output_ARK_s;
        end if;
    end process P0;

    --Convertion type_state -> bit128
    J1 : for col in 0 to 3 generate
        J2 : for row in 0 to 3 generate
            data_o(127 - 32*col - 8*row downto 120 - 32*col - 8*row) <= data_s(row)(col);
        end generate;
    end generate;

end architecture AESRound_arch;

configuration AESRound_conf of AESRound is
    for AESRound_arch
        for SB : SubBytes
            use configuration LIB_RTL.SubBytes_conf;
        end for;
        for SR : ShiftRows
            use entity LIB_RTL.ShiftRows(ShiftRows_arch);
        end for;
        for MC : MixColumns
            use configuration LIB_RTL.MixColumns_conf;
        end for;
        for AR : AddRoundKey
            use entity LIB_RTL.AddRoundKey(AddRoundKey_arch);
        end for;
    end for;
end AESRound_conf;