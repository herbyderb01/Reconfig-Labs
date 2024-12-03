library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity collision_detector is
	port (
		clk 	 : in std_logic;
		rst 	 : in std_logic;
		xposb 	 : in integer;
		yposb 	 : in integer;
		paddle_1_y : in integer;
		paddle_2_y : in integer;
		frame_end: in std_logic;
		p1_points: out integer;
		p2_points: out integer;
		p1_just_scored : out std_logic;
		p2_just_scored : out std_logic;
		Vx 		 : out integer;
		Vy 		 : out integer
	);
end;

--for all xpos and ypos checks may need to change
--to account for width and height of ball and other objects

architecture behavioral of collision_detector is
	signal sig_Vx : integer := -2;
	signal sig_Vy : integer := 0;
	signal sig_p1_points : integer := 0;
	signal sig_p2_points : integer := 0;

	constant BOX_YPOS_UPPER : integer := 110;
	constant BOX_YPOS_LOWER : integer := 250;
	constant BOX_XPOS_RP : integer := 165;
	constant BOX_YPOS_MIDDLE : integer := 180;
	constant BOX_XPOS_MID : integer := 320;
	constant X_BOS_DIST : integer := 95;

	-- signal paddle_1_y : integer := 160;
	-- signal paddle_2_y : integer := 160;
	
begin
	p1_points <= sig_p1_points;
	p2_points <= sig_p2_points;
	process(clk) begin
	
		if rst = '1' then
			sig_p1_points <= 0;
			sig_p2_points <= 0;
			sig_Vx <= -2;
			sig_Vy <= 0;

		elsif rising_edge(clk) and frame_end = '1' then

			p1_just_scored <= '0';
			p2_just_scored <= '0';

			--ceiling and floor
			if yposb >= 330 and sig_Vy > 0 then -- floor
				sig_Vy <= -sig_Vy;
			elsif yposb <= 30 and sig_Vy < 0 then -- ceiling
				sig_Vy <= -sig_Vy;
			end if;
			
			--left and right walls and goals
			if xposb >= 610 and sig_Vx > 0 then
				if yposb > 145 and yposb < 215 then -- P1 Goal
					sig_p1_points <= sig_p1_points + 1;
					p1_just_scored <= '1';
					sig_Vx <= -2;
					sig_Vy <= 0;			
				end if;
				sig_Vx <= -sig_Vx;
			elsif xposb <= 30 and sig_Vx < 0 then
				if yposb > 145 and yposb < 215 then -- P2 Goal
					sig_p2_points <= sig_p2_points + 1;
					p2_just_scored <= '1';
					sig_Vx <= 2;
					sig_Vy <= 0;
				end if;
				sig_Vx <= -sig_Vx;
			end if;
			
			--Boxes Y DIR
			-- plus 15 is 10 for box's height plus 3 for hit box
			-- top of upper row box
			if yposb >= BOX_YPOS_UPPER - 18 and yposb <= BOX_YPOS_UPPER - 13  and sig_Vy > 0 then 
				for i in 0 to 3 loop
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
						sig_Vy <= -sig_Vy;
					end if;
				end loop;
			-- bottom of upper row boxes
			elsif yposb <= BOX_YPOS_UPPER + 18 and yposb >= BOX_YPOS_UPPER + 13 and sig_Vy < 0 then
				for i in 0 to 3 loop
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
						sig_Vy <= -sig_Vy;
					end if;
				end loop;
			-- top of bottom row boxes
			elsif yposb >= BOX_YPOS_LOWER - 18 and yposb <= BOX_YPOS_LOWER - 13 and sig_Vy > 0 then 
				for i in 0 to 3 loop
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
						sig_Vy <= -sig_Vy;
					end if;
				end loop;
			-- bottom of bottom row boxes
			elsif yposb <= BOX_YPOS_LOWER + 18 and yposb >= BOX_YPOS_LOWER + 13 and sig_Vy < 0 then
				for i in 0 to 3 loop
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
						sig_Vy <= -sig_Vy;
					end if;
				end loop;
			-- top of middle box
			elsif yposb >= BOX_YPOS_MIDDLE - 25 and yposb >= BOX_YPOS_MIDDLE - 20  and sig_Vy > 0 then 
				if xposb >= BOX_XPOS_MID  - 15 AND xposb <= BOX_XPOS_MID + 15 then
					sig_Vy <= -sig_Vy;
				end if;
			-- bottom of middle box
			elsif yposb <= BOX_YPOS_MIDDLE + 18 and yposb >= BOX_YPOS_MIDDLE + 13 and sig_Vy < 0 then
				if xposb >= BOX_XPOS_MID - 15 AND xposb <= BOX_XPOS_MID + 15 then
					sig_Vy <= -sig_Vy;
				end if;
			end if;
			
			--Boxes X DIR
			--upper row
			if yposb <= BOX_YPOS_UPPER + 15 and yposb >= BOX_YPOS_UPPER - 15 then 
				for i in 0 to 3 loop
					--Left side
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 18 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 15 and sig_Vx > 0 then
						sig_Vx <= -sig_Vx;
					--Right side
					elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 18 AND xposb >= BOX_XPOS_RP + i * X_BOS_DIST  + 15 and sig_Vx < 0 then
						sig_Vx <= -sig_Vx;
					end if;
				end loop;
			--bottom row
			elsif yposb <= BOX_YPOS_LOWER + 15 and yposb >= BOX_YPOS_LOWER - 15 then 
				for i in 0 to 3 loop
					--Left side
					if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 18 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 15 and sig_Vx > 0 then
						sig_Vx <= -sig_Vx;
					--Right side
					elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 18 AND xposb >= BOX_XPOS_RP + i * X_BOS_DIST  + 15 and sig_Vx < 0 then
						sig_Vx <= -sig_Vx;
					end if;
				end loop;
			--middle box
			elsif yposb <= BOX_YPOS_MIDDLE + 15 and yposb >= BOX_YPOS_MIDDLE - 15 then 
				-- Left side
				if xposb >= BOX_XPOS_MID - 18 AND xposb <= BOX_XPOS_MID - 15 and sig_Vx > 0 then
					sig_Vx <= -sig_Vx;
				-- Right side
				elsif xposb <= BOX_XPOS_MID + 18 AND xposb >= BOX_XPOS_MID + 15 and sig_Vx < 0 then
					sig_Vx <= -sig_Vx;
				end if;
			end if;	

			-- Paddle 1 Collision Logic
			if (xposb >= 40 and xposb < (45 + 10)) then  -- Ball overlaps with Paddle 1 x-coordinates
				if (yposb >= paddle_1_y - 6 and yposb < paddle_1_y + 8) then
					-- Topmost section: sharp deflection upward
					sig_Vx <= 4;
					sig_Vy <= -2;
				elsif (yposb >= paddle_1_y + 8 and yposb < paddle_1_y + 16) then
					-- Second section: moderate deflection upward
					sig_Vx <= 3;
					sig_Vy <= -1;
				elsif (yposb >= paddle_1_y + 16 and yposb < paddle_1_y + 24) then
					-- Middle section: normal bounce
					sig_Vx <= -sig_Vx;  -- Reverse x-direction
				elsif (yposb >= paddle_1_y + 24 and yposb < paddle_1_y + 32) then
					-- Fourth section: moderate deflection downward
					sig_Vx <= 3;
					sig_Vy <= 1;
				elsif (yposb >= paddle_1_y + 32 and yposb < paddle_1_y + 40) then
					-- Bottommost section: sharp deflection downward
					sig_Vx <= 4;
					sig_Vy <= 2;
				end if;
			end if;

			-- Paddle 2 Collision Logic
			if (xposb >= (595 - 10) and xposb < 600) then  -- Ball overlaps with Paddle 2 x-coordinates
				if (yposb >= paddle_2_y - 6 and yposb < paddle_2_y + 8) then
					-- Topmost section: sharp deflection upward
					sig_Vx <= -4;
					sig_Vy <= -2;
				elsif (yposb >= paddle_2_y + 8 and yposb < paddle_2_y + 16) then
					-- Second section: moderate deflection upward
					sig_Vx <= -3;
					sig_Vy <= -1;
				elsif (yposb >= paddle_2_y + 16 and yposb < paddle_2_y + 24) then
					-- Middle section: normal bounce
					sig_Vx <= -sig_Vx;  -- Reverse x-direction
				elsif (yposb >= paddle_2_y + 24 and yposb < paddle_2_y + 32) then
					-- Fourth section: moderate deflection downward
					sig_Vx <= -3;
					sig_Vy <= 1;
				elsif (yposb >= paddle_2_y + 32 and yposb < paddle_2_y + 40) then
					-- Bottommost section: sharp deflection downward
					sig_Vx <= -4;
					sig_Vy <= 2;
				end if;
			end if;
		end if;


		Vx <= sig_Vx;
		Vy <= sig_Vy;
		p1_points <= sig_p1_points;
		p2_points <= sig_p2_points;
	end process;
end behavioral;