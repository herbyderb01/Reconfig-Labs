-- read in velocitites, update new position for ball
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ball_logic is
	port (
		clk			: in std_logic;
		rst			: in std_logic;
		frame_end	: in std_logic;
		new_round	: in std_logic;
		start_pos	: in std_logic;
		ball_en		: in std_logic;
		Vx			: in integer;
		Vy			: in integer;
		xposb		: out integer;
		yposb		: out integer
	);
end;

architecture behavioral of ball_logic is
	-- signal xposb_internal : integer := 320;
	-- signal yposb_internal : integer := 290;
	signal xposb_internal : integer := 230;
	signal yposb_internal : integer := 60;

	signal start_xposb : integer := 320;
	signal top_start_yposb : integer := 60;
	signal bottom_start_yposb : integer := 290;
begin
	
	process(clk, new_round) 
	begin
		if new_round = '1' then
			if start_pos = '0' then				
				xposb_internal <= start_xposb;
				yposb_internal <= top_start_yposb;
			else
				xposb_internal <= start_xposb;
				yposb_internal <= bottom_start_yposb;
			end if;

		elsif rising_edge(clk) and frame_end = '1' and ball_en = '1' then
			xposb_internal <= xposb_internal + Vx;
			yposb_internal <= yposb_internal + Vy;
			xposb <= xposb_internal;
			yposb <= yposb_internal;
		end if;
	end process;

end behavioral;