library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--insert name of file i.e. debouncer_tb
entity collision_tb is
end collision_tb;

architecture behavioral of collision_tb is
	
	component ball_logic 
		port (
		    clk 	 : in std_logic;
			xposb 	 : out integer;
			yposb 	 : out integer;
			Vx 		 : in integer;
			Vy 		 : in integer
		);
	end component ball_logic;
	
	component collision_detector 
		port (
			clk 	 : in std_logic;
			xposb 	 : in integer;
			yposb 	 : in integer;
			yposbmp1 : in integer;
			yposbmp2 : in integer;
			p1_points: out integer;
			p2_points: out integer;
			Vx 		 : out integer;
			Vy 		 : out integer
		);
	end component collision_detector;
	
	signal clk : std_logic;
	signal xposbs : integer;
	signal yposbs : integer;
	signal Vxs : integer;
	signal Vys : integer;
	signal p1_pointss : integer;
	signal p2_pointss : integer;
	signal yposbmp1 : integer;
	signal yposbmp2 : integer;
	
	--necessary to progress simulation
	constant CLK_PERIOD : time := 10 ns;
	
begin
	
	-- use ports and signals declared to map to module
	uut1 : ball_logic
		port map(
			clk => clk,
			xposb => xposbs,
			yposb => yposbs,
			Vx => Vxs,
			Vy => Vys
		);
		
	uut2 : collision_detector
		port map(
			clk => clk,
			xposb => xposbs,
			yposb => yposbs,
			yposbmp1 => yposbmp1,
			yposbmp2 => yposbmp2,
			p1_points => p1_pointss,
			p2_points => p2_pointss,
			Vx => Vxs,
			Vy => Vys
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
	--stm_process : process
	--begin
		
	--end process;
	
end architecture behavioral;