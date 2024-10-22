library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--insert name of file i.e. debouncer_tb
entity debouncer_tb is
end debouncer_tb;

architecture behavioral of debouncer_tb is
	
	component debouncer 
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;
	
	signal clk : std_logic := '0';
	signal btn : std_logic := '0';
	signal output : std_logic;
	
	--necessary to progress simulation
	constant CLK_PERIOD : time := 10 ns;
	
begin
	
	-- use ports and signals declared to map to module
	uut : debouncer
		port map(
			clk => clk,
			btn => btn,
			output => output
		);
		
	--process to set the clock
	--keep this the same for all simulations
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	--manipulate inputs to module to view results you want
	stm_process : process
	begin
		wait for clk_period * 10;
		btn <= '1';
		wait for CLK_PERIOD/2; 
		btn <= '0';
		wait for CLK_PERIOD/2;
		btn <= '1';
		wait for CLK_PERIOD/2;
		btn <= '0';
		wait for CLK_PERIOD/2; 
		btn <= '1';
		wait for CLK_PERIOD * 5;
		btn <= '0';
		wait for CLK_PERIOD/2;
		btn <= '1';
		wait for CLK_PERIOD/2; 
		btn <= '0';
	end process;
	
end architecture behavioral;