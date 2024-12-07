library ieee;
use ieee.numeric_bit.all;

entity regfile is
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
end entity regfile;

architecture estrutural of regfile is

    component reg is
        generic(wordSize: integer := 64);
        port(
            clock, reset: in bit;
            enable: in bit;
            d: in bit_vector(wordSize-1 downto 0);
            q: out bit_vector(wordSize-1 downto 0)
        );
    end component reg;

    component decodificador_5x32 is
        port(
            sel: in bit_vector(addressSize-1 downto 0);
            saida: out bit_vector(wordSize-1 downto 0)
        );
    end component decodificador_5x32;

    component mux is
        generic(BITS: integer := 64);
        port(
            D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23, D24, D25, D26, D27, D28, D29, D30, D31: in bit_vector(BITS-1 downto 0);
            SEL: in bit_vector(addressSize-1 downto 0);
            SAIDA: out bit_vector(BITS-1 downto 0)
        );
    end component mux;

    signal s_decod: bit_vector(2**addressSize-1 downto 0);
    signal s_enable: bit_vector(2**addressSize-1 downto 0);

    signal mux1_signal: bit_vector(wordSize-1 downto 0);
    signal mux2_signal: bit_vector(wordSize-1 downto 0);

    type regfile_tipo is array(0 to 2**addressSize-1) of bit_vector(wordSize-1 downto 0);
    signal regfile_signal: regfile_tipo;

begin 

    regs: for i in 0 to 2**addressSize-2 generate
        reg_i: reg
            generic map(wordSize => wordSize)
            port map(
                clock => clock,
                reset => reset,
                enable => s_enable(i),
                d => d,
                q => regfile_signal(i)
            );
    end generate regs;

    reg_31: reg
        generic map(wordSize => wordSize)
        port map(
            clock => clock,
            reset => reset,
            enable => s_enable(2**addressSize-1),
            d => "00000000000000000000000000000000",
            q => regfile_signal(2**addressSize-1)
        );

    decod: decodificador_5x32
        port map(
            sel => wr,
            saida => s_decod
        );

    mux1: mux
        port map(
            D0 => regfile_signal(0),
            D1 => regfile_signal(1),
            D2 => regfile_signal(2),
            D3 => regfile_signal(3),
            D4 => regfile_signal(4),
            D5 => regfile_signal(5),
            D6 => regfile_signal(6),
            D7 => regfile_signal(7),
            D8 => regfile_signal(8),
            D9 => regfile_signal(9),
            D10 => regfile_signal(10),
            D11 => regfile_signal(11),
            D12 => regfile_signal(12),
            D13 => regfile_signal(13),
            D14 => regfile_signal(14),
            D15 => regfile_signal(15),
            D16 => regfile_signal(16),
            D17 => regfile_signal(17),
            D18 => regfile_signal(18),
            D19 => regfile_signal(19),
            D20 => regfile_signal(20),
            D21 => regfile_signal(21),
            D22 => regfile_signal(22),
            D23 => regfile_signal(23),
            D24 => regfile_signal(24),
            D25 => regfile_signal(25),
            D26 => regfile_signal(26),
            D27 => regfile_signal(27),
            D28 => regfile_signal(28),
            D29 => regfile_signal(29),
            D30 => regfile_signal(30),
            D31 => regfile_signal(31),
            SEL => rr1,
            SAIDA => mux1_signal
        );
    
    mux2: mux
        port map(
            D0 => regfile_signal(0),
            D1 => regfile_signal(1),
            D2 => regfile_signal(2),
            D3 => regfile_signal(3),
            D4 => regfile_signal(4),
            D5 => regfile_signal(5),
            D6 => regfile_signal(6),
            D7 => regfile_signal(7),
            D8 => regfile_signal(8),
            D9 => regfile_signal(9),
            D10 => regfile_signal(10),
            D11 => regfile_signal(11),
            D12 => regfile_signal(12),
            D13 => regfile_signal(13),
            D14 => regfile_signal(14),
            D15 => regfile_signal(15),
            D16 => regfile_signal(16),
            D17 => regfile_signal(17),
            D18 => regfile_signal(18),
            D19 => regfile_signal(19),
            D20 => regfile_signal(20),
            D21 => regfile_signal(21),
            D22 => regfile_signal(22),
            D23 => regfile_signal(23),
            D24 => regfile_signal(24),
            D25 => regfile_signal(25),
            D26 => regfile_signal(26),
            D27 => regfile_signal(27),
            D28 => regfile_signal(28),
            D29 => regfile_signal(29),
            D30 => regfile_signal(30),
            D31 => regfile_signal(31),
            SEL => rr2,
            SAIDA => mux2_signal
        );

    s_enable <= s_decod when regWrite = '1' else (others => '0');
    q1 <= mux1_signal;
    q2 <= mux2_signal;

end architecture estrutural;

    
    
