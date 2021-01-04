-- KeyExpansion_I_O.vhd
-- Implémentation de KeyExpansion_I_O

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity KeyExpansion_I_O is
    port(
        key_i : in  bit128;    -- 16 octets
        start_i : in std_logic;
        clock_i : in std_logic;
        reset_i : in std_logic;
        expansion_key_o : out bit128
    );
end entity KeyExpansion_I_O;

architecture KeyExpansion_I_O_arch of KeyExpansion_I_O is

    component KeyExpansion is
        port(
            key_i : in  bit128;    -- 16 octets
            expansion_key_o : out bit128;
            Rcon_i : in column_state
        );
    end component KeyExpansion;

    component KeyExpansionFSM is
        port(
            start_i : in std_logic;
            reset_i : in std_logic;
            clock_i : in std_logic;
            counter_i : in bit4;
            enable_o : out std_logic;
            reset_counter_o : out std_logic
        );
    end component KeyExpansionFSM;

    component Counter is
        port(reset_i  : in  std_logic;
             enable_i : in  std_logic;
             clock_i  : in  std_logic;
             count_o  : out bit4);
    end component Counter;

    signal counter_s : bit4;
    signal enable_s, reset_counter_s : std_logic;
    signal key_reg_s, key_state_s, key_expansion_s : bit128;
    signal rcon_s : column_state;

    type rcontype is array(0 to 9) of column_state;
    constant RCON : rcontype := ((X"01", X"00",X"00",X"00"),
                                 (X"02", X"00",X"00",X"00"),
                                 (X"04", X"00",X"00",X"00"),
                                 (X"08", X"00",X"00",X"00"),
                                 (X"10", X"00",X"00",X"00"),
                                 (X"20", X"00",X"00",X"00"),
                                 (X"40", X"00",X"00",X"00"),
                                 (X"80", X"00",X"00",X"00"),
                                 (X"1B", X"00",X"00",X"00"),
                                 (X"36", X"00",X"00",X"00"));

begin
    --KeyExpansionFSM
    A1 : KeyExpansionFSM port map(
            start_i => start_i,
            reset_i => reset_i,
            clock_i => clock_i,
            counter_i => counter_s,
            enable_o => enable_s,
            reset_counter_o => reset_counter_s
        );
    --KeyExpansion
    rcon_s <= RCON(TO_INTEGER(Unsigned(counter_s)) mod 10); --ON ne peut pas diectement mettre cette expression dans Rcon_i
    A2 : KeyExpansion port map(
            key_i => key_state_s,
            Rcon_i => rcon_s,
            expansion_key_o => key_expansion_s
        );
    --Counter
    A3 : Counter port map(
            enable_i => enable_s,
            clock_i => clock_i,
            count_o => counter_s,
            reset_i => reset_counter_s
        );

    --Registre
    P0 : process(key_expansion_s, clock_i, reset_i, enable_s)
    begin   
        if reset_i = '0' then
            R0 : for row in 0 to 3 loop
                R1 : for col in 0 to 3 loop
                    key_reg_s(127 - 32*col - 8*row downto 120 - 32*col - 8*row) <= (others => '0');
                end loop;
            end loop;
        elsif (clock_i 'event and clock_i = '1') then
            if(enable_s = '1') then
                key_reg_s <= key_expansion_s;
            else
                key_reg_s <= key_i; --Pour l'initialisation
            end if;
        end if;
    end process P0;

    --MUX
    key_state_s <= key_reg_s when enable_s = '1' else key_i;

    --Sortie
    expansion_key_o <= key_state_s;


end architecture KeyExpansion_I_O_arch;

configuration KeyExpansion_I_O_conf of KeyExpansion_I_O is
    for KeyExpansion_I_O_arch
        for A1 : KeyExpansionFSM
            use entity LIB_RTL.KeyExpansionFSM(KeyExpansionFSM_Moore_arch);
        end for;
        for A2 : KeyExpansion
            use configuration LIB_RTL.KeyExpansion_conf;
        end for;
        for A3 : Counter
            use entity LIB_RTL.Counter(counter_arch);
        end for;
    end for;
end KeyExpansion_I_O_conf;