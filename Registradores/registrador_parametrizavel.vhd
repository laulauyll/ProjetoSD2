library ieee;
use ieee.numeric_bit.all;

entity reg is
    generic(wordSize: integer := 64);
    port(
        clock, reset: in bit;
        enable: in bit;
        d: in bit_vector(wordSize-1 downto 0);
        q: out bit_vector(wordSize-1 downto 0)
    );
end entity reg;

architecture rtl of reg is
begin
  process(clock, reset)
  begin
    if reset = '1' then
      q <= (others => '0');
    elsif clock'event and clock = '1' then
      if enable = '1' then
        q <= d;
      end if;
    end if;
  end process;
end architecture rtl;

