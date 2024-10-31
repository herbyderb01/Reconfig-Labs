library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--insert name of file i.e. debouncer_tb
entity vga_1_tb is
end vga_1_tb;

architecture behavioral of vga_1_tb is
	
	component VGA 
		port (
			clk        : in std_logic;  -- VGA clock
			rst      : in std_logic;  -- Reset signal
			h_sync     : out std_logic; -- Horizontal sync output
			v_sync     : out std_logic; -- Vertical sync output
			pixel_en   : out std_logic; -- Pixel enable signal (high when in active region)
			h_count    : out integer;   -- Horizontal pixel count (optional, for debugging or extra features)
			v_count    : out integer    -- Vertical line count (optional, for debugging or extra features)
		);
	end component VGA;
	
	signal clk : std_logic;
	signal rst : std_logic := 0;
	signal h_sync : std_logic;
	signal v_sync : std_logic;
	signal pixel_en : std_logic;
	signal h_count : integer;
	signal v_count : integer;
	signal pixel_count: unsigned := 0;
	
	
	--necessary to progress simulation
	constant CLK_PERIOD : time := 10 ns;
	
begin
	
	-- use ports and signals declared to map to module
	uut : VGA
		port map(
			clk => clk,
			rst => rst,
			h_sync => h_sync,
			v_sync => v_sync,
			pixel_en => pixel_en,
			h_count => h_count,
			v_count => v_count
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
		if pixel_en = '1' then
			pixel_count <= pixel_count + 1;
		end if;
	end process;
	
end architecture behavioral;