library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab5_accumulator is
	port (
		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic;
		MAX10_CLK2_50 : in std_logic;
		
		KEY : in std_logic_vector(1 downto 0);
		SW : in std_logic_vector(9 downto 0);
		
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0);
		HEX5 : out std_logic_vector(7 downto 0);
		
		LEDR : out std_logic_vector(9 downto 0)
	);
end Lab5_accumulator;

architecture component_list of Lab5_accumulator is
	
	component debouncer
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;
	
	component HEX_seven_seg_disp_6
		port (
			IN0 : in std_logic_vector(3 downto 0);
			IN1 : in std_logic_vector(3 downto 0);
			IN2 : in std_logic_vector(3 downto 0);
			IN3 : in std_logic_vector(3 downto 0);
			IN4 : in std_logic_vector(3 downto 0);
			IN5 : in std_logic_vector(3 downto 0);
			clk : in  std_logic;
			HEX0 : out std_logic_vector(7 downto 0);
			HEX1 : out std_logic_vector(7 downto 0);
			HEX2 : out std_logic_vector(7 downto 0);
			HEX3 : out std_logic_vector(7 downto 0);
			HEX4 : out std_logic_vector(7 downto 0);
			HEX5 : out std_logic_vector(7 downto 0)
		);
	end component HEX_seven_seg_disp_6;
	
	component accumulator
		generic (
			N : integer := 10;
			M : integer := 10
		);
			port (
			en : in std_logic;
			rst : in std_logic;
			clk : in std_logic;
			input : in std_logic_vector(N-1 downto 0);
			sum : out std_logic_vector(M-1 downto 0)
		);
	end component accumulator;
	
	signal rst : std_logic;
	signal en : std_logic;
	signal sum : std_logic_vector(23 downto 0);

	signal key0_l : std_logic;
	signal key1_l : std_logic;
	
begin

	accumulator1 : accumulator
		generic map (
			N => 10,
			M => 24
		)
		port map (
			clk => ADC_CLK_10,
			en => en,
			rst => rst,
			input => SW,
			sum => sum
		);

	display : HEX_seven_seg_disp_6
		port map (
			clk => ADC_CLK_10,
			IN0 => sum(3 downto 0),
			IN1 => sum(7 downto 4), 
			IN2 => sum(11 downto 8),
			IN3 => sum(15 downto 12),
			IN4 => sum(19 downto 16),
			IN5 => sum(23 downto 20),
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2,
			HEX3 => HEX3,
			HEX4 => HEX4,
			HEX5 => HEX5
		);
	
	rst_btn : debouncer
		port map (
			clk => ADC_CLK_10,
			btn => key0_l,
			output => rst
		);
		
	en_btn : debouncer
		port map (
			clk => ADC_CLK_10,
			btn => key1_l,
			output => en
		);
		
	LEDR <= SW;

	key0_l <= not KEY(0); 
	key1_l <= not KEY(1); 
	
end component_list;