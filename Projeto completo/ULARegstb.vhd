library ieee;
use ieee.numeric_bit.all;

entity ULARegstb is 
end entity;

architecture ULARegstb_arch of ULARegs is 
    signal rd_tb, rn_tb, rm_tb: bit_vector(4 downto 0);
    signal op_tb: bit_vector(3 downto 0);
    signal we_tb: bit;
    signal clk_tb: bit;
    signal y_tb: bit_vector(63 downto 0);
    signal zero_tb: bit;

    component ULARegs 

        port( 
            y: out bit_vector(63 downto 0); -- saída da ULA 
            op: in bit_vector(3 downto 0); -- operação da ULA
            zero: out bit; -- flag zero
            rd: in bit_vector(4 downto 0); -- índice do registrador a ser escrito
            rm: in bit_vector(4 downto 0); -- índice do registrador 1
            rn: in bit_vector(4 downto 0); -- índice do registrador 2
            we: in bit; -- habilitação de escrita
            clk: in bit;
        );

    end component;

    begin 

    DUT: ULARegs port map(y_tb, op_tb, zero_tb, rd_tb, rm_tb, rn_tb, we_tb, clk_tb);

    process 
    begin 




end architecture;