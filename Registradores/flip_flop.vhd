library ieee;
use ieee.numeric_bit.all;

entity flip_flop is
  port(
    clk, d, rst: in bit;
    q, q_n: out bit;
    en: in bit
  );
end flip_flop;

architecture rtl of flip_flop is
begin
  process(clk, rst)
    begin
        if rst = '1' then
            q <= '0';
        elsif clk'event and clk = '1' then
            if en = '1' then
                q <= d;
            end if;    
        end if;
    end process;
    q_n <= not q; 
end rtl;
