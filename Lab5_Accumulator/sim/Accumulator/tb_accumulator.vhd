library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--insert name of file i.e. debouncer_tb
entity tb_accumulator is
end tb_accumulator;

architecture behavioral of tb_accumulator is
	
	component accumulator 
		generic (
			--insert generics if applicable
			N : integer := 10;
			M : integer := 24	
		);
		port (
		    --insert ports to module
			clk : in std_logic;
			en : in std_logic;
			rst : in std_logic;
			input : in std_logic_vector(N-1 downto 0);
			sum : out std_logic_vector(M-1 downto 0)
		);
	end component accumulator;
	
	signal clk : std_logic;
	--create signals that match component ports to simulate
	--signal en : std_logic := '1';
	--signal rst : std_logic := '1';
	--signal rn : std_logic_vector(7 downto 0);

		signal en : std_logic := '0';
		signal rst : std_logic := '0';
		signal input : std_logic_vector(9 downto 0);
		signal sum : std_logic_vector(23 downto 0);

	--necessary to progress simulation
	constant CLK_PERIOD : time := 10 ns;
	
begin
	
	-- use ports and signals declared to map to module
	uut : accumulator
		generic map (
			--insert generics if applicable 
			N => 10,
			M => 24
		)
		port map(
			--insert signals to module like below
			clk => clk,
			en => en,
			rst => rst,
			input => input,
			sum => sum
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
		-- ie
		--wait for clk_period *10;
		--en <= '0';
		--wait for clk_period * 20;
		--en <= '1';
		--wait;


		input <= "1100110101";
		wait for clk_period * 5;
		en <= '1';
		wait for clk_period;
		en <= '0';
		wait for clk_period * 5;
		input <= "1100111111";
		en <= '1';
		wait for clk_period;
		en <= '0';

		rst <= '1';
		wait for clk_period * 5;
		rst <= '0';
		en <= '1';
		wait for clk_period;
		en <= '0';


	end process;
	
end architecture behavioral;