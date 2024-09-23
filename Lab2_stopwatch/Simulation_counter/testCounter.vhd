library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_counter is
end TB_counter;

architecture behavioral of TB_counter is

	component Lab2_stopwatch
	 	port (
			ADC_CLK_10 : in STD_LOGIC;
			MAX10_CLK1_50 : in STD_LOGIC;
			MAX10_CLK2_50 : in STD_LOGIC;
			KEY : in std_logic_vector(1 downto 0);
			HEX0 : out STD_LOGIC_VECTOR(7 downto 0);
			HEX1 : out STD_LOGIC_VECTOR(7 downto 0);
			HEX2 : out STD_LOGIC_VECTOR(7 downto 0);
			HEX3 : out STD_LOGIC_VECTOR(7 downto 0);
			HEX4 : out STD_LOGIC_VECTOR(7 downto 0);
			HEX5 : out STD_LOGIC_VECTOR(7 downto 0)
	 	);
	 end component;
	
	signal clk_TB : std_logic := '0';
	signal rst_l_TB : std_logic := '1';
	signal go_TB : std_logic := '1';
	
	constant CLK_PERIOD : time := 10 ns;
	
	signal hex0_temp : std_logic_vector(7 downto 0);
	signal hex1_temp : std_logic_vector(7 downto 0);
	signal hex2_temp : std_logic_vector(7 downto 0);
	signal hex3_temp : std_logic_vector(7 downto 0);
	signal hex4_temp : std_logic_vector(7 downto 0);
	signal hex5_temp : std_logic_vector(7 downto 0);
	
begin

	uut : Lab2_stopwatch
	 	port map(
	 		ADC_CLK_10 => clk_TB,
			MAX10_CLK1_50 => clk_TB,
			MAX10_CLK2_50 => clk_TB,
			KEY(0) => rst_l_TB,
			key(1) => go_TB,
			HEX0 => hex0_temp,
			HEX1 => hex1_temp,
			HEX2 => hex2_temp,
			HEX3 => hex3_temp,
			HEX4 => hex4_temp,
			HEX5 => hex5_temp
	 	);

	clk_process : process
	begin
		clk_TB <= '0';
		wait for clk_period / 2;
		clk_TB <= '1';
		wait for clk_period/2;
	end process;
	
	stm_process : process
	begin
		wait for clk_period *10;
		go_TB <= '0';
		wait for clk_period * 20;
		go_TB <= '1';
		wait for clk_period *5;
		rst_l_TB <= '0';
		wait for clk_period * 5;
		rst_l_TB <= '1';
		wait for clk_period * 5;
		go_TB <= '0';
		wait for clk_period * 200;
		rst_l_TB <= '0';
		wait for clk_period * 5;
		rst_l_TB <= '1';
		wait;
	end process;

end architecture behavioral;