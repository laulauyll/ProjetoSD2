library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity memoriaDados is
    generic(
      address_size : natural := 8;
      word_size    : natural := 64;
      data_file_name : string := "conteudo_memDados_af11_p1e5_carga.dat"
    );
    port(
      ck, wr : in  bit;
      addr   : in  bit_vector(address_size-1 downto 0);
      data_i : in  bit_vector(word_size-1 downto 0);
      data_o : out bit_vector(word_size-1 downto 0)
    );
  end memoriaDados;
  
architecture vendorfree of memoriaDados is
    constant depth : natural := 2**address_size;
    type mem_type is array (0 to depth-1) of bit_vector(word_size-1 downto 0);
    
    impure function init_mem(file_name : in string) return mem_type is
      file     f       : text open read_mode is file_name;
      variable l       : line;
      variable tmp_bv  : bit_vector(word_size-1 downto 0);
      variable tmp_mem : mem_type;
    begin
      for i in mem_type'range loop
        readline(f, l);
        read(l, tmp_bv);
        tmp_mem(i) := tmp_bv;
      end loop;
      return tmp_mem;
    end;

    signal mem : mem_type := init_mem(data_file_name);
    
  begin
    wrt: process(ck)
    begin
      if (ck='1' and ck'event) then
        if (wr='1') then
          mem(to_integer(unsigned(addr))) <= data_i;
        end if;
      end if;
    end process;
    data_o <= mem(to_integer(unsigned(addr)));
  end vendorfree;