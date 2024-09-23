library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use work.counter.all;
use work.counter;

entity TB_counter is
end TB_counter;

architecture behavioral of TB_counter is

	-- component my_counter
	-- 	generic (
	-- 		N : integer := 4
	-- 	);
	-- 	port (
	-- 		clk : in std_logic;
	-- 		rst_l : in std_logic;
	-- 		count : out unsigned((N-1) downto 0)
	-- 	);
	-- end component;
	
	signal clk_TB : std_logic := '0';
	signal rst_l_TB : std_logic := '1';
	signal count_TB : std_logic_vector(7 downto 0);
	
	constant CLK_PERIOD : time := 10 ns;
	
begin

	-- uut : my_counter
	-- 	generic map(
	-- 		N => 8
	-- 	)
	-- 	port map(
	-- 		clk => clk,
	-- 		rst_l => rst_l,
	-- 		count => count
	-- 	);
	uut : entity counter
		generic map(
			N => 8
		)
		port map(
			clk => clk_TB,
			rst_l => rst_l_TB,
			output => count_TB
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
		rst_l_TB <= '1';
		wait for clk_period * 10;
		rst_l_TB <= '0';
		wait for clk_period * 10;
		rst_l_TB <= '1';
		wait;
	end process;

end architecture behavioral;