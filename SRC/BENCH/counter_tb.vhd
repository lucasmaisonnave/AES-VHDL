-- counter_tbvhd
-- test bench du compteur
-- Lucas Maisonnave 27/11/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity counter_tb is
end counter_tb;

architecture counter_tb_arch of counter_tb is

    component Counter is
    port(reset_i  : in  std_logic;
         enable_i : in  std_logic;
         clock_i  : in  std_logic;
         count_o  : out bit4);
    end component;

    signal reset_s, enable_s : std_logic;
    signal clock_s : std_logic := '0';
    signal count_s : bit4;

begin
    DUT : Counter port map(
        reset_i  => reset_s,
        enable_i => enable_s,
        clock_i  => clock_s,
        count_o  => count_s
    );
    clock_s   <= NOT clock_s AFTER 50 ns;
    reset_s <= '0', '1' after 25 ns, '0' after 600 ns, '1' after 700 ns;
    enable_s  <= '0', '1' after 425 ns, '0' after 1000 ns, '1' after 1425 ns;

end counter_tb_arch ; -- arch

configuration counter_tb_conf of counter_tb is
    for counter_tb_arch
        for DUT : Counter
            use entity LIB_RTL.Counter(counter_arch);
        end for;
    end for;
end counter_tb_conf;