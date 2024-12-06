library ieee;
use ieee.numeric_bit.all;
use work.mux_p;

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

architecture gen of regfile is
    signal mux1_signal: mux_p.slv_array_t(0 to 2**addressSize-1)(wordSize-1 downto 0);
    signal mux2_signal: mux_p.slv_array_t(0 to 2**addressSize-1)(wordSize-1 downto 0);

    component reg is
        generic(wordSize: integer := 64);
        port(
            clock, reset: in bit;
            enable: in bit;
            d: in bit_vector(wordSize-1 downto 0);
            q: out bit_vector(wordSize-1 downto 0)
        );
    end component reg;

    component mux is
        generic(
          LEN : natural;   -- Bits in each input
          NUM : natural);  -- Number of inputs
        port(
          v_i   : in  mux_p.slv_array_t(0 to NUM - 1)(LEN - 1 downto 0);
          sel_i : in  natural range 0 to NUM - 1;
          z_o   : out bit_vector(LEN - 1 downto 0));
    end component mux;
begin
    mux1 : mux
        generic map(
            LEN => wordSize,
            NUM => 2**addressSize
        )
        port map(
            v_i => mux1_signal,
            sel_i => rr1,
            z_o => q1
        );
    mux2 : mux
        generic map(
            LEN => wordSize,
            NUM => 2**addressSize
        )
        port map(
            v_i => mux2_signal,
            sel_i => rr2,
            z_o => q2
        );
    
    GEN_REG:
    for I in 0 to 2**addressSize-2 generate
        REG : entity work.reg
            generic map(wordSize => wordSize)
            port map(
                clock => clock,
                reset => reset,
                enable => regWrite and (wr = I),
                d => d,
                q => mux1_signal(I),
                q2 => mux2_signal(I)
            );
    end generate GEN_REG;
    
    XRZ: entity work.reg
        generic map(wordSize => wordSize)
        port map(
            clock => clock,
            reset => 1,
            enable => regWrite and (wr = 2**addressSize-1),
            d => (others => '0'),
            q => mux1_signal(2**addressSize-1),
            q2 => mux2_signal(2**addressSize-1)
        );

    q1 <= mux1.z_o;
    q2 <= mux2.z_o;
end architecture gen;

    
    
