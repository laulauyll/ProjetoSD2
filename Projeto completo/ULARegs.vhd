library ieee;
use ieee.numeric_bit.ALL;

entity ULARegs is 
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
end ULARegs;

architecture integracao of ULARegs is 
    component ula is 
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
    end component;

    component regfile is 
        generic(
            wordSize: integer := 64;
            addressSize: integer := 5
        );
        port(
            clock: in bit;
            reset: in bit;
            regWrite: in bit;
            rr1: in bit_vector(addressSize-1 downto 0);
            rr2: in bit_vector(addressSize-1 downto 0);
            wr: in bit_vector(addressSize-1 downto 0);
            d: in bit_vector(wordSize-1 downto 0);
            q1, q2: out bit_vector(wordSize-1 downto 0)
        );
    end component;

    -- Sinais internos
    signal operando1, operando2: bit_vector(63 downto 0); -- Entradas da ULA
    signal resultado: bit_vector(63 downto 0); -- Saída da ULA
    signal flagZero: bit; -- Flag zero da ULA

begin 
    -- Instância do regfile
    regfile_inst: regfile
        generic map(
            wordSize => 64,
            addressSize => 5
        )
        port map(
            clock => clk,
            regWrite => we,
            rr1 => rm,
            rr2 => rn,
            wr => rd,
            d => resultado, -- Escreve o resultado no registrador
            q1 => operando1, -- Leitura do registrador rm
            q2 => operando2  -- Leitura do registrador rn
            reset => open
        );

    -- Instância da ULA
    ula_inst: ula
        port map(
            A => operando1,
            B => operando2,
            operation => op,
            result => resultado,
            zero => flagZero,
            overflow => open, -- Ignorando overflow
            carryOut => open  -- Ignorando carryOut
        );

    -- Saídas
    y <= resultado; -- Saída da ULA conectada ao `y`
    zero <= flagZero; -- Flag zero conectada ao sinal `zero`

end architecture;