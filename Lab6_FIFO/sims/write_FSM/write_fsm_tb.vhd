library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--insert name of file i.e. debouncer_tb
entity write_fsm_tb is
end write_fsm_tb;

architecture behavioral of write_fsm_tb is
	
	component write_fsm 
		port (
		clk : in std_logic;
		btn : in std_logic;
		full : in std_logic;
		MT : in std_logic;
		wr_en : out std_logic
		);
	end component write_fsm;
	
	signal clk : std_logic;
	signal btn : std_logic := '0';
	signal full : std_logic := '0';
	signal MT : std_logic := '0';
	signal wr : std_logic;
	signal count : integer := 0;
	--create signals that match component ports to simulate
	--signal en : std_logic := '1';
	--signal rst : std_logic := '1';
	--signal rn : std_logic_vector(7 downto 0);
	
	--necessary to progress simulation
	constant CLK_PERIOD : time := 10 ns;
	
begin
	
	-- use ports and signals declared to map to module
	uut : write_fsm
		port map(
			--insert signals to module like below
			--clk => clk,
			--en => en,
			--rst => rst,
			--rn => rn
			clk => clk,
			btn => btn,
			full => full,
			MT => MT,
			wr_en => wr
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
		wait for clk_period * 4;
		btn <= '1';
		wait for CLK_PERIOD;
		btn <= '0';
		wait for clk_period * 4;
		btn <= '1';
		wait for CLK_PERIOD;
		btn <= '0';
		wait for clk_period * 4;
		btn <= '1';
		wait for CLK_PERIOD;
		btn <= '0';
		wait for clk_period * 4;
		btn <= '1';
		wait for CLK_PERIOD;
		btn <= '0';
		wait for clk_period * 4;
		btn <= '1';
		wait for CLK_PERIOD;
		btn <= '0';
		wait for clk_period * 4;
		MT <= '1';
		wait for CLK_PERIOD;
		MT <= '0';
	end process;
	
end architecture behavioral;