library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity collision_detector is
	port (
		clk 	 : in std_logic;
		xposb 	 : in integer;
		yposb 	 : in integer;
		yposbmp1 : in integer;
		yposbmp2 : in integer;
		frame_end: in std_logic;
		p1_points: out integer;
		p2_points: out integer;
		Vx 		 : out integer;
		Vy 		 : out integer
	);
end;

--for all xpos and ypos checks may need to change
--to account for width and height of ball and other objects

architecture behavioral of collision_detector is
	signal sig_Vx : integer := 2;
	signal sig_Vy : integer := 2;
	signal sig_p1_points : integer := 0;
	signal sig_p2_points : integer := 0;
	constant BOX_YPOS_UPPER : integer := 110;
	constant BOX_YPOS_LOWER : integer := 250;
	constant BOX_XPOS_RP : integer := 185;
	constant BOX_YPOS_MIDDLE : integer := 180;
	constant BOX_XPOS_MID : integer := 300;
	constant X_BOS_DIST : integer := 90;
	
begin
	p1_points <= sig_p1_points;
	p2_points <= sig_p2_points;
	process(clk) begin
	
		if rising_edge(clk) and frame_end = '1' then
	
			--ceiling and floor
			if yposb >= 330 and sig_Vy > 0 then -- floor
				sig_Vy <= -sig_Vy;
			elsif yposb <= 30 and sig_Vy < 0 then -- ceiling
				sig_Vy <= -sig_Vy;
			end if;
			
			--left and right walls and goals
			if xposb >= 610 and sig_Vx > 0 then
				-- if yposb > 265 and yposb < 335 then
				-- 	sig_p1_points <= sig_p1_points + 1;
				sig_Vx <= -sig_Vx;
				-- end if;
			elsif xposb <= 30 and sig_Vx < 0 then
				-- if yposb > 265 and yposb < 335 then
				-- 	sig_p2_points <= sig_p2_points + 1;
				sig_Vx <= -sig_Vx;
				-- end if;
			end if;
			
		-- 	--Boxes Y DIR
		-- 	-- plut 15 is 10 for box's height plus 5 for hit box
		-- 	-- top of upper rox box
		-- 	if yposb <= BOX_YPOS_UPPER + 15 and yposb >= BOX_YPOS_UPPER + 10 then 
		-- 		for i in 0 to 3 loop
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
		-- 				sig_Vy <= -sig_Vy;
		-- 			end if;
		-- 		end loop;
		-- 	-- bottom of upper row boxes
		-- 	elsif yposb >= BOX_YPOS_UPPER - 15 and yposb >= BOX_YPOS_UPPER - 10 then
		-- 		for i in 0 to 3 loop
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
		-- 				sig_Vy <= -sig_Vy;
		-- 			end if;
		-- 		end loop;
		-- 	-- top of bottom row boxes
		-- 	elsif yposb <= BOX_YPOS_LOWER + 15 and yposb >= BOX_YPOS_LOWER + 10 then 
		-- 		for i in 0 to 3 loop
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
		-- 				sig_Vy <= -sig_Vy;
		-- 			end if;
		-- 		end loop;
		-- 	-- bottom of bottom row boxes
		-- 	elsif yposb >= BOX_YPOS_LOWER - 15 and yposb >= BOX_YPOS_LOWER - 10 then
		-- 		for i in 0 to 3 loop
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
		-- 				sig_Vy <= -sig_Vy;
		-- 			end if;
		-- 		end loop;
		-- 	-- top of middle box
		-- 	elsif yposb <= BOX_YPOS_MIDDLE + 15 and yposb >= BOX_YPOS_MIDDLE + 10 then 
		-- 		if xposb >= BOX_XPOS_MID  - 15 AND xposb <= BOX_XPOS_MID + 15 then
		-- 			sig_Vy <= -sig_Vy;
		-- 		end if;
		-- 	-- bottom of middle box
		-- 	elsif yposb >= BOX_YPOS_MIDDLE - 15 and yposb >= BOX_YPOS_MIDDLE - 10 then
		-- 		if xposb >= BOX_XPOS_MID - 15 AND xposb <= BOX_XPOS_MID + 15 then
		-- 			sig_Vy <= -sig_Vy;
		-- 		end if;
		-- 	end if;
			
		-- 	--Boxes X DIR
		-- 	--upper row
		-- 	if yposb <= BOX_YPOS_UPPER + 10 and yposb >= BOX_YPOS_UPPER - 10 then 
		-- 		for i in 0 to 3 loop
		-- 			--Left side
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			--Right side
		-- 			elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			end if;
		-- 		end loop;
		-- 	--bottom row
		-- 	elsif yposb <= BOX_YPOS_LOWER + 10 and yposb >= BOX_YPOS_LOWER - 10 then 
		-- 		for i in 0 to 3 loop
		-- 			--Left side
		-- 			if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			--Right side
		-- 			elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			end if;
		-- 		end loop;
		-- 	--middle box
		-- 	elsif yposb <= BOX_YPOS_MIDDLE + 10 and yposb >= BOX_YPOS_MIDDLE - 10 then 
		-- 		for i in 0 to 3 loop
		-- 			--Left side
		-- 			if xposb >= BOX_XPOS_MID + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_MID + i * X_BOS_DIST  - 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			--Right side
		-- 			elsif xposb <= BOX_XPOS_MID + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_MID + i * X_BOS_DIST  + 10 then
		-- 				sig_Vx <= sig_Vx;
		-- 			end if;
		-- 		end loop;
		-- 	end if;
		end if;
		--bumper collision logic 
		--if yposb < yposbmp1 + 10 and yposb > yposbmp1 - 10 then
		--	if xposb >= 65
		-- end if;
		Vx <= sig_Vx;
		Vy <= sig_Vy;
	end process;
end behavioral;