library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RNG is
    Port (
        clk       : in  std_logic;  -- Clock signal
        reset     : in  std_logic;  -- Reset signal
        rng_out   : out std_logic   -- Random output (0 or 1)
    );
end RNG;

architecture Behavioral of RNG is
    signal lfsr : std_logic_vector(3 downto 0) := "1101"; -- 4-bit LFSR initialized
begin
    process(clk, reset)
    begin
        if reset = '1' then
            lfsr <= "1101"; -- Reset LFSR to initial value
        elsif rising_edge(clk) then
            -- Update LFSR: XOR feedback and shift
            lfsr <= lfsr(2 downto 0) & (lfsr(3) xor lfsr(2));
        end if;
    end process;

    -- Use LSB as the RNG output (0 or 1)
    rng_out <= lfsr(0);

end Behavioral;