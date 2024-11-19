-- read in velocitites, update new position for ball
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_logic is
	port (
		clk 	 : in std_logic;
		xposb 	 : out integer;
		yposb 	 : out integer;
		Vx 		 : in integer;
		Vy 		 : in integer
	);
end;

architecture behavioral of ball_logic is
	signal xposb_internal : integer := 320;
	signal yposb_internal : integer := 60;
begin
	
	process(clk) 
	begin
		if rising_edge(clk) then
			xposb_internal <= xposb_internal + Vx;
			yposb_internal <= yposb_internal - Vy;
		end if;
		xposb <= xposb_internal;
		yposb <= yposb_internal;
	end process;
end behavioral;