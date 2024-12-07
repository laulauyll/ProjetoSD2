library ieee;
use ieee.numeric_bit.all;

entity ula1bit is
    port(
        a, b: in bit;
        cin: in bit;
        ainvert : in bit;
        binvert : in bit;
        operation: in bit_vector(1 downto 0);
        result: out bit;
        cout: out bit
    );
end entity ula1bit;


architecture behavior of ula1bit is
    signal aa, bb: bit;

    begin
        aa <= a when ainvert = '0' else not a;
        bb <= b when binvert = '0' else not b;

        with operation select
            result <= aa and bb when "00",
                      aa or bb when "01",
                      aa xor bb xor cin when "10",
                      b when others;
        -- cálculo do vai-um
        cout <= (aa and bb) or (aa and cin) or (bb and cin);
    end architecture;
