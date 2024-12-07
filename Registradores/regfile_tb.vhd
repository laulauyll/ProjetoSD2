--------------------------------------------------------------------------------
-- pacote com funcoes uteis para bit_vector (Prof. Bruno Albertini)
--------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;
use std.textio.all;

package utils is
  -- Based on Morten Zilmer answer on stackoverflow
  -- https://stackoverflow.com/questions/24329155/is-there-a-way-to-print-the-values-of-a-signal-to-a-file-from-a-modelsim-simulat
  function to_bstring(b : bit) return string;
  function to_bstring(bv : bit_vector) return string;
  -- function to_bstring(s : signed) return string;
  -- https://stackoverflow.com/questions/26575986/vhdl-coding-conversion-from-integer-to-bit-vector
  -- function to_bv(n, size : natural) return bit_vector;
  -- Support comparison functions
  function equal(a,b: std_logic_vector) return boolean;
  function equalSignedBitvector(a: signed; b: bit_vector) return boolean;
end package utils;

package body utils is
  function to_bstring(b : bit) return string is
  variable b_str_v : string(1 to 3);  -- bit image with quotes around
  begin
    b_str_v := bit'image(b);
    return "" & b_str_v(2);  -- "" & character to get string
  end function;

  function to_bstring(bv : bit_vector) return string is
    alias    bv_norm : bit_vector(1 to bv'length) is bv;
    variable b_str_v : string(1 to 1);  -- String of bit
    variable res_v    : string(1 to bv'length);
  begin
    for idx in bv_norm'range loop
      b_str_v := to_bstring(bv_norm(idx));
      res_v(idx) := b_str_v(1);
    end loop;
    return res_v;
  end function;

  function equal(a,b: std_logic_vector) return boolean is
  begin
    if a'length = b'length then
      for idx in 0 to a'length-1 loop
        if a(idx) /= b(idx) then
          return false;
        end if;
      end loop;
      return true;
    else
      return false;
    end if;
  end function;

  function equalSignedBitvector(a: signed; b: bit_vector) return boolean is
  begin
    if a'length = b'length then
      for idx in 0 to a'length-1 loop
        if a(idx) /= b(idx) then
          return false;
        end if;
      end loop;
      return true;
    else
      return false;
    end if;
  end function;

end package body utils;

--------------------------------------------------------------------------------
-- modelo de testbench para o banco de registradores do PoliLEG
-- baseado no testbench elaborado pelo Prof. Bruno Albertini
--
-- este modelo testa um banco de registradores com 8 registradores de 16 bits
-- e nao verifica o funcionamento do ultimo registrador como XZR
--
-- emidorik@usp.br
-- 20231125
--------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;  -- necessario para to_unsigned

library work;
use work.utils.all;

entity regfile_tb is
end regfile_tb;

architecture dataflow of regfile_tb is

  component regfile
    generic(
        wordSize: integer := 64;
        addressSize: integer := 5
    );
    port(
        clock    : in  bit;                     --! entrada de clock
        reset    : in  bit;                     --! entrada de reset
        regWrite : in  bit;                     --! entrada de carga do registrador wr
        rr1      : in  bit_vector(addressSize-1 downto 0);  --! endereco do registrador 1
        rr2      : in  bit_vector(addressSize-1 downto 0);  --! endereco do registrador 2
        wr       : in  bit_vector(addressSize-1 downto 0);  --! endereco do registrador de escrita
        d        : in  bit_vector(wordSize-1 downto 0);     --! dado a ser escrito
        q1       : out bit_vector(wordSize-1 downto 0);     --! saida do registrador 1
        q2       : out bit_vector(wordSize-1 downto 0)      --! saida do registrador 2
    );
  end component regfile;

  constant clkPeriod : time := 1 ns;
  signal simulando : bit := '0';
  signal clk, rt, ld : bit := '0';
  signal rr1, rr2, wr: bit_vector(4 downto 0);
  signal d, q1, q2: bit_vector(63 downto 0);

  signal caso : natural := 0;  -- caso de teste

begin
  -- geracao de clock
  clk <= (simulando and (not clk)) after clkPeriod/2;
    

  --! DUT = Design Under Test
    DUT: regfile
    generic map(
        wordSize   => 64,
        addressSize => 5
    )
    port map(
        clock    => clk,
        reset    => rt,
        regWrite => ld,
        rr1      => rr1,
        rr2      => rr2,
        wr       => wr,
        d        => d,
        q1       => q1,
        q2       => q2
    );

  -- processo para geracao de estimulos do testbench
  stim: process

      -- vetor de teste com padroes de dados para escrita nos registradores
      type test_pattern_array is array (natural range <>) of bit_vector(63 downto 0);
      constant test_patterns: test_pattern_array :=
      (
        (X"0000000000000000"), -- usado para verificacao do reset (nao mudar)
        -- inserir outros padroes de teste
        (X"FFFFFFFFFFFFFFFF"),
        (X"F0F0F0F0F0F0F0F0"),
        (X"0F0F0F0F0F0F0F0F")
      );

  begin
    report "Inicio do testbench";
    simulando <= '1';
    -- 1. Verificacao do Reset
    caso <= 1;
    report integer'image(caso);
    -- valores iniciais
    rr1 <= "00000"; rr2 <= "00000"; wr <= "00000"; ld <= '0';
    d <= X"FFFFFFFFFFFFFFFF";
    -- gera pulso de reset
    rt <= '1';
    wait for 10 ns;
    rt <= '0';
    -- verifica se saidas dos registradores eh zero
    for ri in 0 to 7 loop
        rr1 <= bit_vector(to_unsigned(ri,5));
        rr2 <= bit_vector(to_unsigned(ri,5));
        assert (q1=X"0000000000000000" and q2=X"0000000000000000")
            report "Saidas apos reset nao sao zero para o registrador #" &
                   integer'image(ri) & "."
            severity warning;
    end loop;
    report "Fim do teste de reset";

    -- 2. Verificacao de escrita dos padroes de dados
    caso <= 2;
    -- testa conjunto de padroes de dados
    for idx in test_patterns'range loop
        report "Teste de padrao #" & integer'image(idx) & " d=" & to_bstring(test_patterns(idx));
        d <= test_patterns(idx);
        for ri in 0 to 7 loop
            wr  <= bit_vector(to_unsigned(ri,5));
            rr1 <= bit_vector(to_unsigned(ri,5));
            rr2 <= bit_vector(to_unsigned(ri,5));
            wait for 1 ns;
            -- 2.a) testa valores dos registradores antes da escrita
            if idx/=0 then
                if ri/=7 then
                    -- teste da saida de registrador 1
                    assert (q1=test_patterns(idx-1))
                        report "Saida anterior invalida para o registrador #" &
                               integer'image(ri) & " antes da escrita" & LF &
                               " esperado:" & to_bstring(test_patterns(idx-1)) & LF &
                               " saida:   " & to_bstring(q1)
                        severity warning;
                    -- teste da saida de registrador 2
                    assert (q2=test_patterns(idx-1))
                        report "Saida anterior invalida para o registrador #" &
                               integer'image(ri) & " antes da escrita" & LF &
                               " esperado:" & to_bstring(test_patterns(idx-1)) & LF &
                               " saida:   " & to_bstring(q1)
                        severity warning;
                -- teste do registrador XZR (ultimo registrador)
                else

                    report "Teste do XZR antes da escrita"; 
                    -- completar o codigo deste teste

                end if;
            end if;

            -- 2.b) execucao da escrita de registradores
            ld <= '1';
            wait until (clk='0' and clk'event);
            ld <= '0';

            -- 2.c) testa valor escrito nos registradores
            if idx/=0 then
                if ri/=7 then
                    assert (q1=test_patterns(idx))
                        report "Saida invalida no registrador #" &
                               integer'image(ri) & " apos a escrita" & LF &
                               " esperado:" & to_bstring(d) & LF &
                               " saida   :" & to_bstring(q1)
                        severity warning;
                    assert (q2=test_patterns(idx))
                        report "Saida invalida no registrador #" &
                               integer'image(ri) & " apos a escrita" & LF &
                               " esperado:" & to_bstring(test_patterns(idx-1)) & LF &
                               " saida   :" & to_bstring(q1)
                        severity warning;
                else

                    report "Teste do XZR depois da escrita"; 
                    -- completar o codigo deste teste

                end if;
            end if;
        end loop;
    end loop;

    report "Fim do testbench";
    simulando <= '0';
    wait;
  end process;

end architecture;
