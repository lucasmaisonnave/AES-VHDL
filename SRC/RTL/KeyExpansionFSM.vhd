-- KeyExpansionFSM.vhd
-- Implémentation de KeyExpansionFSM

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansionFSM is
    port(
        start_i : in std_logic;
        reset_i : in std_logic;
        clock_i : in std_logic;
        counter_i : in bit4;
        enable_o : out std_logic;
        reset_counter_o : out std_logic
    );
end entity KeyExpansionFSM;

architecture KeyExpansionFSM_Moore_arch of KeyExpansionFSM is

    type state_type is (init, count, stop0);
    signal present_state, next_state : state_type;
begin

    sequentiel : process(clock_i, reset_i)
    begin
        if reset_i = '0' then
            present_state <= init;
        elsif clock_i 'event and clock_i = '1' then
            present_state <= next_state;
        end if;
    end process;

    C0 : process(present_state, start_i, counter_i)
    begin
        case present_state is
        when init=>
            if start_i = '1' then
                next_state <= count;
            else
                next_state <= init;
            end if;       
        when count =>
            if counter_i = X"A" then --On arrête de compter à 10
                next_state <= stop0;
            else 
                next_state <= count;
            end if;
        when stop0 =>
            if  start_i = '1' then
                next_state <= stop0;
            else
                next_state <= init;
            end if;
        end case;
    end process C0;

    C1 : process(present_state)
    begin
        case present_state is
        when init =>
            enable_o <= '0';
            reset_counter_o <= '0';
        when count =>
            enable_o <= '1';
            reset_counter_o <= '1';
        when stop0 =>
            enable_o <= '0';
            reset_counter_o <= '1';
        end case;
    end process C1;

end architecture KeyExpansionFSM_Moore_arch;
