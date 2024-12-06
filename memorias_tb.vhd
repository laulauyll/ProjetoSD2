library ieee;
use ieee.numeric_std.all;
use std.textio.all;
use work.utils.all;  -- Importa o pacote utils

entity memorias_tb is
end memorias_tb;



architecture testbench of memorias_tb is
  component memoriaInstrucoes is
    generic(
      address_size   : natural := 8;
      word_size      : natural := 32;
      data_file_name : string  := "conteudo_memInstr_af11_p1e5_carga.dat"
    );
    port(
      addr : in  bit_vector(address_size-1 downto 0);
      data : out bit_vector(word_size-1 downto 0)
    );
  end component;

  component memoriaDados is
    generic(
      address_size : natural := 8;
      word_size    : natural := 64;
      data_file_name : string  := "conteudo_memDados_af11_p1e5_carga.dat"
    );
    port(
      ck, wr : in  bit;
      addr   : in  bit_vector(address_size-1 downto 0);
      data_i : in  bit_vector(word_size-1 downto 0);
      data_o : out bit_vector(word_size-1 downto 0)
    );
  end component;

  -- Sinais de suporte
  signal a5: bit_vector(7 downto 0);  -- Ajuste para corresponder ao tamanho do endereço
  signal d4d: bit_vector(31 downto 0);  -- Ajuste para corresponder ao tamanho da palavra
  signal d4ci, d4co: bit_vector(63 downto 0);  -- Ajuste para corresponder ao tamanho da palavra
  signal stopc, clk, wr: bit := '0';  -- Ajuste para bit
  -- Período do clock
  constant periodo : time := 10 ns;
begin
  -- Geração de clock
  clk <= stopc and (not clk) after periodo/2;
  -- Instancias a serem testadas
  dutD: memoriaInstrucoes generic map(8, 32, "conteudo_memInstr_af11_p1e5_carga.dat") port map(a5, d4d);
  dutC: memoriaDados generic map(8, 64, "conteudo_memDados_af11_p1e5_carga.dat") port map(clk, wr, a5, d4ci, d4co);
  -- Estímulos
  stim: process
    variable addr_tmp: bit_vector(7 downto 0);  -- Ajuste para corresponder ao tamanho do endereço
  begin
    stopc <= '1';
    wr <= '0';
    --! Escrevendo um padrão na RAM
    for i in 0 to 31 loop
      addr_tmp := to_bv(i, 8);  -- Ajuste para corresponder ao tamanho do endereço      
      d4ci <= (63 downto addr_tmp'length => '0') & addr_tmp;
      a5 <= addr_tmp;
      wr<='1';
      wait until (clk'event and clk='1');
      wr<='0';
    end loop;
    --! Lendo todas as memórias
    for i in 0 to 31 loop
      a5 <= to_bv(i, 8);  -- Ajuste para corresponder ao tamanho do endereço
      wait for 1 ns;
      assert d4co = (63 downto a5'length => '0') & a5;
        report "RAM mem("&to_bstring(a5)&")="&to_bstring(d4co);
    end loop;
    stopc <= '0';
    wait;
  end process;
end architecture testbench;