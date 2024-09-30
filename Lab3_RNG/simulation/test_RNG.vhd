library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_RNG is
end test_RNG;

architecture behavioral of test_RNG is
	
	component RNG 
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
	end component RNG;
	
	signal clk : std_logic;
	signal en : std_logic := '1';
	signal rst : std_logic := '1';
	signal rn : std_logic_vector(7 downto 0);
	
	constant CLK_PERIOD : time := 10 ns;
	
begin

	uut : RNG
		generic map (
			N => 8,
			M => 12
		)
		port map(
			clk => clk,
			en => en,
			rst => rst,
			rn => rn
		);
		
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	stm_process : process
	begin
		wait for clk_period *10;
		en <= '0';
		wait for clk_period * 20;
		en <= '1';
		wait for clk_period *5;
		rst <= '0';
		wait for clk_period * 5;
		rst <= '1';
		wait for clk_period * 5;
		en <= '0';
		wait;
	end process;
	
end architecture behavioral;