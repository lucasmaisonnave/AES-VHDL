-- Counter.vhd
-- Module Counter
-- Implémentation du bloc Counter

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

entity Counter is
  port(reset_i  : in  std_logic;
       enable_i : in  std_logic;
       clock_i  : in  std_logic;
       count_o  : out bit4);
end entity Counter;

architecture counter_arch of Counter is
  signal counter_s : natural range 0 to 15;
begin
  P0 : process(clock_i, reset_i, enable_i)
  begin
    if (reset_i = '0') then
      counter_s <= 0;
    elsif (clock_i'event and clock_i = '1') then
      if (enable_i = '1') then
        if(counter_s = 15) then --On remet à 0 quand on arrive à 2**4 - 1
          counter_s <= 0;
        else                    --Sinon on incrémente
          counter_s <= counter_s + 1;
        end if;
      else
        counter_s <= counter_s;
      end if;
    end if;
  end process P0;

  count_o <= std_logic_vector(to_unsigned(counter_s, 4));

end architecture counter_arch;

