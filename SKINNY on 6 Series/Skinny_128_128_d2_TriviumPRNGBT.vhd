library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Skinny_128_128_d2_TriviumPRNGBT is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           plaintext_s0 : in STD_LOGIC_VECTOR (127 downto 0);
           plaintext_s1 : in STD_LOGIC_VECTOR (127 downto 0);
           key_s0 : in STD_LOGIC_VECTOR (127 downto 0);
           key_s1 : in STD_LOGIC_VECTOR (127 downto 0);
           seed : in STD_LOGIC_VECTOR (79 downto 0);
           ciphertext_s0 : out STD_LOGIC_VECTOR (127 downto 0);
           ciphertext_s1 : out STD_LOGIC_VECTOR (127 downto 0);
           done : out STD_LOGIC;
		   clear : in STD_LOGIC );
end Skinny_128_128_d2_TriviumPRNGBT;

architecture Behavioral of Skinny_128_128_d2_TriviumPRNGBT is

    component MSK_FSMBT is
        Generic (d : INTEGER := 2);
        Port ( clk : in STD_LOGIC;
               start : in STD_LOGIC;
               reset : in STD_LOGIC;
               rnd : in STD_LOGIC_VECTOR (31 downto 0);
			   rnd_BT : in STD_LOGIC_VECTOR (63 downto 0);
               K_in : in STD_LOGIC_VECTOR (255 downto 0);
               PT_in : in STD_LOGIC_VECTOR (255 downto 0);
               CT : out STD_LOGIC_VECTOR (255 downto 0);
               done : out STD_LOGIC;
			   clear : in STD_LOGIC);
    end component;
    
    component Trivium is
        Generic (output_bits : INTEGER := 96);
        Port (  clk : in STD_LOGIC;
                rst : in STD_LOGIC;
                en : in STD_LOGIC;
                key : in STD_LOGIC_VECTOR(79 downto 0);
                iv : in STD_LOGIC_VECTOR(79 downto 0);
                stream_out : out STD_LOGIC_VECTOR(output_bits-1 downto 0));
    end component;
    
    signal core_en, core_rst, core_done : STD_LOGIC;
    signal plaintext, key, ciphertext : STD_LOGIC_VECTOR (255 downto 0);
    signal core_plaintext, core_key, core_ciphertext : STD_LOGIC_VECTOR (255 downto 0);
    signal core_fresh_randomness : STD_LOGIC_VECTOR(95 downto 0);
    signal prng_rst, prng_en : STD_LOGIC;
    constant prng_iv : STD_LOGIC_VECTOR(79 downto 0) := x"dc72d410a81291f5422e";
    
begin

    -- SKINNY-128-128 instance
    SKINNY_inst: MSK_FSMBT Port Map (clk, core_en, core_rst, core_fresh_randomness(31 downto 0), core_fresh_randomness(95 downto 32), core_key, core_plaintext, core_ciphertext, core_done, clear);
    -- PRNG instance
    PRNG_inst: Trivium Generic Map (96) Port Map (clk, prng_rst, prng_en, seed, prng_iv, core_fresh_randomness);
    
    RO: for i in 0 to 127 generate
        plaintext(i*2) <= plaintext_s0(i);
        plaintext(i*2+1) <= plaintext_s1(i);
        key(i*2) <= key_s0(i);
        key(i*2+1) <= key_s1(i);
        ciphertext_s0(i) <= ciphertext(i*2);
        ciphertext_s1(i) <= ciphertext(i*2+1);
    end generate;
    
    -- State Machine
    FSM: process(clk)
        variable initcounter : integer range 0 to 35;
        variable inputflag : integer range 0 to 1;
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                core_rst                    <= '1';
                prng_rst                    <= '1';
                prng_en                     <= '0';
                initcounter                 := 0;
                inputflag                   := 0;
                core_plaintext              <= (others => '0');
                core_key                    <= (others => '0');
                ciphertext                  <= (others => '0');
                done                        <= '0';
            else
                if (initcounter < 35) then
                    prng_rst                <= '0';
                    prng_en                 <= '1';
                    initcounter             := initcounter + 1;
                elsif (inputflag = 0) then
                    inputflag               := 1;
                    core_rst                <= '0';
                    core_plaintext          <= plaintext;
                    core_key                <= key;
                else
                    core_en                 <= '1';
                    if (core_done = '1') then
                        ciphertext          <= core_ciphertext;
                        core_en             <= '0';
                        prng_en             <= '0';
                        done                <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;