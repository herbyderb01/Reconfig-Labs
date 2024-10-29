library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab7_VGA is
	port (
		-- CLOCK --
		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic;
		MAX10_CLK2_50 : in std_logic;

		-- KEY --
		KEY : in std_logic_vector(1 downto 0);
		
		-- VGA --
		VGA_B : out std_logic_vector(3 downto 0);
		VGA_G : out std_logic_vector(3 downto 0);
		VGA_HS : out std_logic;
		VGA_R : out std_logic_vector(3 downto 0);
		VGA_VS : out std_logic;
	);
end Lab7_VGA;

architecture component_list of Lab7_VGA is

	component debouncer
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;

	signal key0_l : std_logic;
	signal key1_l : std_logic;

begin

	rst_btn : debouncer
		port map (
			clk => rd_clk,
			btn => key0_l,
			output => rst
		);
		
	nextFlag_btn : debouncer
		port map (
			clk => wr_clk,
			btn => key1_l,
			output => pressed
		);

	key0_l <= not KEY(0); 
	key1_l <= not KEY(1); 
	
	
end component_list;