library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab2_stopwatch is
	port (
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0);
		HEX5 : out std_logic_vector(7 downto 0);
		ADC_CLK_10 : IN STD_LOGIC;
		MAX10_CLK1_50 : IN STD_LOGIC;
		MAX10_CLK2_50 : IN STD_LOGIC;
		KEY : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
end Lab2_stopwatch;


architecture componentlist of Lab2_stopwatch is
	component HEX_seven_seg_disp_6
		port (
			clk : in std_logic;
			IN0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			IN1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			IN2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			IN3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			IN4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			IN5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			HEX0 : out std_logic_vector(7 downto 0);
			HEX1 : out std_logic_vector(7 downto 0);
			HEX2 : out std_logic_vector(7 downto 0);
			HEX3 : out std_logic_vector(7 downto 0);
			HEX4 : out std_logic_vector(7 downto 0);
			HEX5 : out std_logic_vector(7 downto 0)
		);
	end component HEX_seven_seg_disp_6;
	
	component counter
		generic (
			n : integer := 4;
			div : integer := 4;
			div_min : integer := 9
		);
		port (
			clk : in std_logic;
			rst_l : in  std_logic;
			go : in std_logic;
			output : out std_logic_vector((n-1) downto 0)
		);
	end component counter;
	signal IN0 : std_logic_vector(3 downto 0);
	signal IN1 : std_logic_vector(3 downto 0);
	signal IN2 : std_logic_vector(3 downto 0);
	signal IN3 : std_logic_vector(3 downto 0);
	signal IN4 : std_logic_vector(3 downto 0);
	signal IN5 : std_logic_vector(3 downto 0);
	signal hex4_temp : std_logic_vector(7 downto 0);
	signal hex2_temp : std_logic_vector(7 downto 0);
begin
	display : HEX_seven_seg_disp_6
		port map (
			clk => MAX10_CLK1_50,
			IN0 => IN0,
			IN1 => IN1,
			IN2 => IN2,
			IN3 => IN3,
			IN4 => IN4,
			IN5 => IN5,
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2_temp,
			HEX3 => HEX3,
			HEX4 => HEX4_temp,
			HEX5 => HEX5
		);
	counter_H2 : counter
		generic map (
			n => 4,
			div => 500000,
			div_min => 9
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN0
		);
	counter_H1 : counter
		generic map (
			n => 4,
			div =>5000000,
			div_min => 9
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN1
		);
	counter_S2 : counter
		generic map (
			n => 4,
			div => 50000000,
			div_min => 9
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN2
		);
	counter_S1 : counter
		generic map (
			n => 4,
			div => 500000000,
			div_min => 5
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN3
		);
	counter_M2 : counter
		generic map (
			n => 4,
			div => 3000000000,
			div_min => 9
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN4
		);
	counter_M1 : counter
		generic map (
			n => 4,
			div => 30000000000,
			div_min => 5
		)
		port map (
			clk => MAX10_CLK1_50,
			rst_l => key(0),
			go => key(1),
			output => IN5
		);
	HEX4 <= "01111111" and HEX4_temp;
	HEX2 <= "01111111" and HEX2_temp;

end componentlist;