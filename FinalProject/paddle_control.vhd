-- read in velocitites, update new position for ball
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity paddle_control is
	port (
		clk				: in std_logic;
		rst_btn			: in std_logic;
		frame_end		: in std_logic;
		paddle_1_y		: out integer;
		paddle_2_y		: out integer
	);
end;

architecture behavioral of paddle_control is

	component ADC
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic_vector(11 downto 0)					
		);
	end component ADC;

	signal clk				: std_logic;

	signal adc1_out			: std_logic_vector(11 downto 0);
	signal adc2_out			: std_logic_vector(11 downto 0);

	constant min_y : integer := 60;
    constant max_y : integer := 320;
    constant adc_max : integer := 4095;
    signal adc_value1 : integer;
	signal adc_value2 : integer;

begin

	adc1 : ADC
		port map (
			clk => clk,
			btn => not rst_btn,
			output1 => adc1_out,
			output2 => adc2_out
		);


	process(clk) 
	begin
		-- Convert the 12-bit ADC value to an integer
		adc_value1 := to_integer(unsigned(adc1_out));
		adc_value2 := to_integer(unsigned(adc2_out));

		if rising_edge(clk) and frame_end = '1' then
			-- Map the ADC value to the paddle_1_y range
			paddle_1_y <= min_y + ((adc_value * (max_y - min_y)) / adc_max);
			paddle_1_y <= min_y + ((adc_value * (max_y - min_y)) / adc_max);
		end if;
	end process;

end behavioral;