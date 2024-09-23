library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab2_stopwatch is
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
end;

architecture behavioral of Lab2_stopwatch is

	component counter
		generic (
			n : integer := 4;
			div : integer := 4
		);
		
		port (
			clk : in std_logic;
			rst_l : in std_logic;
			output : out std_logic_vector((n-1) downto 0)
		);
	end component;
	
	begin
		u0 : counter
			generic map (
				n => 10,
				div => 25000000
			)
			port map (
				clk => MAX10_CLK1_50,
				rst_l => key(0),
				output => LEDR
			);
	
	
	
	end;
	