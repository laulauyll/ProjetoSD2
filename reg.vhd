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
  variable q_var: bit_vector(wordSize-1 downto 0);
  begin
    if reset = '1' then
      q_var := (others => '0');
    elsif clock'event and clock = '1' then
      if enable = '1' then
        q_var := d;
      end if;
    end if;
    q <= q_var;
  end process;

end architecture rtl;