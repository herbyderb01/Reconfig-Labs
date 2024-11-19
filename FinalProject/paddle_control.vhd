-- read in velocitites, update new position for ball
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity paddle_control is
	port (
		clk				: in std_logic;
		rst_btn				: in std_logic;
		xposb			: out integer;
		yposb			: out integer;
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

	signal xposb_internal : integer := 230;
	signal yposb_internal : integer := 60;

begin

	adc1 : ADC
		port map (
			clk => ADC_CLK_10,
			btn => not rst_btn,
			output => sum
		);
	adc2 : ADC
		port map (
			clk => ADC_CLK_10,
			btn => not rst_btn,
			output => sum
		);

	process(clk) 
	begin
		if rising_edge(clk) and frame_end = '1' then
			xposb_internal <= xposb_internal + Vx;
			yposb_internal <= yposb_internal + Vy;
			xposb <= xposb_internal;
			yposb <= yposb_internal;
		end if;
	end process;

end behavioral;