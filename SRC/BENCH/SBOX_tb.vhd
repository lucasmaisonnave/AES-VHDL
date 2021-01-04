-- counter_tbvhd
-- test bench du compteur
-- Lucas Maisonnave 27/11/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity sbox_tb is
end sbox_tb;

architecture sbox_tb_arch of sbox_tb is

    component SBOX is
    port(data_i : in bit8;
         data_o : out bit8);
    end component;

    signal data_i_s, data_o_s : bit8;

begin
    DUT : SBOX port map(
        data_i  => data_i_s,
        data_o => data_o_s
    );
    --data_i_s <= X"00", X"63" after 25 ns;
--Si on veut tester toutes les valeurs
P0 : process
begin
    for i in 0 to 255 loop
        data_i_s <= Std_logic_vector(To_unsigned(i,8));
        wait for 10 ns;
    end loop;
end process;



end sbox_tb_arch ; -- arch

configuration sbox_tb_conf of sbox_tb is
    for sbox_tb_arch
        for DUT : SBOX
            use entity LIB_RTL.SBOX(sbox_arch);
        end for;
    end for;
end sbox_tb_conf;