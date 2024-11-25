-- read in velocitites, update new position for ball
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_logic is
	port (
		clk 	 : in std_logic;
		xposb 	 : out integer;
		yposb 	 : out integer;
		frame_end: in std_logic;
		Vx 		 : in integer;
		Vy 		 : in integer
	);
end;

architecture behavioral of ball_logic is
	-- signal xposb_internal : integer := 185;
	-- signal yposb_internal : integer := 180;
	signal xposb_internal : integer := 230;
	signal yposb_internal : integer := 180;
begin
	
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