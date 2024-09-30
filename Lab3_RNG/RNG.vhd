library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RNG is
    generic (
        N : integer := 8; -- Output random number size
        M : integer := 12  -- LFSR bit width
    );
    port (
        clk : in std_logic;
        en  : in std_logic;
        rst : in std_logic;
        rn  : out std_logic_vector(N-1 downto 0) -- Random number output
    );
end RNG;

architecture behavioral of RNG is
    component LFSR
        generic (
            M 		: integer :=  12 -- LFSR bit width
         );
        port (
            input		: in std_logic;
			clk   		: in std_logic;
            enable		: in std_logic;
            rst			: in std_logic;
            lfsr_out	: out std_logic_vector(M-1 downto 0)
        );
    end component LFSR;

    signal lfsr_out : std_logic_vector(M-1 downto 0);
	signal bit  : std_logic;
    
begin
    -- Instantiate the LFSR
    LFSR1: LFSR
        generic map (
            M => 12
        )
		port map (
            clk      	=> clk,
			input		=> bit,
            enable   	=> en,   -- Map "en" from RNG to "enable" in LFSR
            rst     	=> rst,
            lfsr_out 	=> lfsr_out  -- Map "lfsr_out" instead of "data"
        );

	-- Feedback polynomial 8 bits: x^16 + x^14 + x^13 + x^11 + 1
	-- bit <= lfsr_out(0) xor lfsr_out(2) xor lfsr_out(3) xor lfsr_out(5);
	-- Feedback polynomial 12 bits: x^12 + x^11 + x^10 + x^4 + 1
	bit <= lfsr_out(3) xor lfsr_out(9) xor lfsr_out(10) xor lfsr_out(11);

		  
    -- Connect the LFSR output to the random number output
    rn <= lfsr_out(N-1 downto 0);

end architecture behavioral;
