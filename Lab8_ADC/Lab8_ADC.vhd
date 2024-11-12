library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab8_ADC is
	port (
		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic;
		MAX10_CLK2_50 : in std_logic;
		
		KEY : in std_logic_vector(1 downto 0);
		
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0);
		HEX5 : out std_logic_vector(7 downto 0)
	);
end Lab8_ADC;

architecture component_list of Lab8_ADC is
	
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
	
	component ADC
		-- generic (
		-- 	N : integer := 10000000
		-- );
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic_vector(11 downto 0)					
		);
	end component ADC;
	
	signal rst_btn : std_logic;
	signal en : std_logic;

	signal key0_l : std_logic;
	signal key1_l : std_logic;

	signal sum 		: std_logic_vector(11 downto 0);
	signal turn_off : std_logic_vector(7 downto 0);
	
begin

	adc1 : ADC
		-- generic map (
		-- 	N => 10000000
		-- )
		port map (
			clk => ADC_CLK_10,
			btn => not rst_btn,
			output => sum
		);

	display : HEX_seven_seg_disp_6
		port map (
			clk => ADC_CLK_10,
			IN0 => sum(3 downto 0),
			IN1 => sum(7 downto 4), 
			IN2 => sum(11 downto 8),
			IN3 => turn_off(3 downto 0),
			IN4 => turn_off(3 downto 0),
			IN5 => turn_off(3 downto 0),
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2,
			HEX3 => turn_off,
			HEX4 => turn_off,
			HEX5 => turn_off
		);
	
	rst_bbtn : debouncer
		port map (
			clk => ADC_CLK_10,
			btn => key0_l,
			output => rst_btn
		);

	key0_l <= not KEY(0); 
	-- key1_l <= not KEY(1); 
	HEX3 <= (others => '1');
	HEX4 <= (others => '1');
	HEX5 <= (others => '1');
	
end component_list;