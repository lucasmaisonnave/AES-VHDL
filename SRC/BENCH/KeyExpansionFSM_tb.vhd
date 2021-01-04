-- KeyExpansionFSM_tb.vhd
-- test bench du KeyExpansionFSM
-- Lucas Maisonnave 15/12/2020
-- Marche bien
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansionFSM_tb is
end KeyExpansionFSM_tb;

architecture KeyExpansionFSM_tb_arch of KeyExpansionFSM_tb is

    component KeyExpansionFSM is
    port(   
        start_i : in std_logic;
        reset_i : in std_logic;
        clock_i : in std_logic;
        counter_i : in bit4;
        enable_o : out std_logic;
        reset_counter_o : out std_logic);
    end component;

    component Counter is
        port(reset_i  : in  std_logic;
             enable_i : in  std_logic;
             clock_i  : in  std_logic;
             count_o  : out bit4);
    end component Counter;

    signal counter_i_s  : bit4;
    signal start_i_s, reset_i_s, enable_o_s, reset_counter_o_s : std_logic;
    signal clock_i_s : std_logic := '0';
begin
    DUT : KeyExpansionFSM port map(
        start_i => start_i_s,
        reset_i => reset_i_s,
        clock_i => clock_i_s,
        counter_i  => counter_i_s,
        enable_o  => enable_o_s,
        reset_counter_o  => reset_counter_o_s
    );
    C0 : Counter port map(
        reset_i  => reset_counter_o_s,
        enable_i => enable_o_s,
        clock_i  => clock_i_s,
        count_o  => counter_i_s
    );
    
    start_i_s <= '1', '0' after 100 ns, '1' after 2800 ns, '0' after 3000 ns;
    reset_i_s <= '0', '1' after 50 ns;
    clock_i_s <= not(clock_i_s) after 100 ns;
end KeyExpansionFSM_tb_arch ; -- arch

configuration KeyExpansionFSM_tb_conf of KeyExpansionFSM_tb is
    for KeyExpansionFSM_tb_arch
        for DUT : KeyExpansionFSM
            use entity LIB_RTL.KeyExpansionFSM(KeyExpansionFSM_Moore_arch);
        end for;
        for C0 : Counter
            use entity LIB_RTL.Counter(Counter_arch);
        end for;
    end for;
end KeyExpansionFSM_tb_conf;

--Round 0 -> 1
--key_i_s <= X"2b7e151628aed2a6abf7158809cf4f3c"; Rcom_i_s <= (X"01", X"00", X"00", X"00"); test_ok_s <= X"a0fafe1788542cb123a339392a6c7605";

