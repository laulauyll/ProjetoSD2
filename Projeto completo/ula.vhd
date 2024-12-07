library ieee;
use ieee.numeric_bit.all;
use work.ula1bit.all;

--
-- descrição comportamental da ULA
--
architecture behavior of ula is
    begin
       with op select 
          y <= a and b when "0000",
               a or b  when "0001",
               a + b when   "0010",
               a - b when   "0110",
               b     when   "0111",
               a nor b when "1100",
               (others => '0') when others;
        z <= '1' when y = 0 else '0';
    end architecture;

entity ula is
    port(
        A: in bit_vector(63 downto 0);
        B: in bit_vector(63 downto 0);
        operation: in bit_vector(3 downto 0);
        result: out bit_vector(63 downto 0);
        -- Flags
        zero: out bit;
        overflow: out bit;
        carryOut: out bit
    );
end entity ula;

architecture struct of ula is
    signal invertA, invertB: bit;
    signal o: bit_vector(1 downto 0);
    signal c: bit_vector(64 downto 0);
    begin
        gen: for i in 0 to 63 generate
            ula1bit_inst: ula1bit
                port map(
                    a => A(i),
                    b => B(i),
                    cin => c(i),
                    ainvert => invertA,
                    binvert => invertB,
                    operation => o,
                    result => result(i),
                    cout => c(i+1)
                );
        end generate;

        -- invertar as entradas?
        invertA <= '1' when operation = "1100" else '0'; -- NOR
        invertB <= '1' when operation = "1100" else      -- NOR ou
                   '1' when operation = "0110";          -- Subtração

        -- somar um na subtração (complemento de 2)
        c(0) <= '1' when operation = "0110" else '0';

        -- operação na ula1bit
        o <= "00" when operation = "0000" else -- AND
             "00" when operation = "1100" else -- NOR = AND com entradas invertidas
             "01" when operation = "0001" else -- OR
             "10" when operation = "0010" else -- ADD
             "10" when operation = "0110" else -- SUB
             "11";                             -- B    
        
        -- flags
        zero <= not (result = (others => '0'));
        overflow <= c(64) xor c(63);
        carryOut <= c(64);
end architecture;