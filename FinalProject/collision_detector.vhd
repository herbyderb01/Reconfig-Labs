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
		p1_points: out integer;
		p2_points: out integer;
		Vx 		 : out integer;
		Vy 		 : out integer
	);
end;

--for all xpos and ypos checks may need to change
--to account for width and height of ball and other objects

architecture behavioral of collision_detector is

begin
	
	process(clk) begin
	
		--ceiling and floor
		if yposb >= 315 then
			--set Vy to reverse
		elsif yposb <= 5 then
			--set Vy to reverse
		end if;
		
		--left and right walls and goals
		if xposb >= 595 then
			if yposb > 265 and < 335 then
				p1_points <= p1_points + 1;
			--set Vx to reverse
		elsif xposb <= 5 then
			if yposb > 265 and < 335 then
				p2_points <= p2_points + 1;
			--set Vx to reverse
		end if;
		
		--Boxes Y DIR
		-- plut 15 is 10 for box's height plus 5 for hit box
		-- top of upper rox box
		if yposb <= BOX_YPOS_UPPER + 15 and yposb >= BOX_YPOS_UPPER + 10 then 
			for i in 0 to 3 loop
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
					--set vy
				end if;
			end loop;
		-- bottom of upper row boxes
		elsif yposb >= BOX_YPOS_UPPER - 15 and yposb >= BOX_YPOS_UPPER - 10 then
			for i in 0 to 3 loop
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
					--set vy
				end if;
			end loop;
		-- top of bottom row boxes
		elsif yposb <= BOX_YPOS_LOWER + 15 and yposb >= BOX_YPOS_LOWER + 10 then 
			for i in 0 to 3 loop
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
					--set vy
				end if;
			end loop;
		-- bottom of bottom row boxes
		elsif yposb >= BOX_YPOS_LOWER - 15 and yposb >= BOX_YPOS_LOWER - 10 then
			for i in 0 to 3 loop
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST  - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 15 then
					--set vy
				end if;
			end loop;
		-- top of middle box
		elsif yposb <= BOX_YPOS_MIDDLE + 15 and yposb >= BOX_YPOS_MIDDLE + 10 then 
			if xposb >= BOX_XPOS_MID  - 15 AND xposb <= BOX_XPOS_MID + i * X_BOS_DIST  + 15 then
				--set vy
			end if;
		-- bottom of middle box
		elsif yposb >= BOX_YPOS_MIDDLE - 15 and yposb >= BOX_YPOS_MIDDLE - 10 then
			if xposb >= BOX_XPOS_MID - 15 AND xposb <= BOX_XPOS_MID + 15 then
				--set vy
			end if;
		end if;
		
		--Boxes X DIR
		--upper row
		if yposb <= BOX_YPOS_UPPER + 10 and yposb >= BOX_YPOS_UPPER - 10 then 
			for i in 0 to 3 loop
				--Left side
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 10 then
					--set vx
				--Right side
				elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 10 then
					--set vx
				end if;
			end loop;
		--bottom row
		elsif yposb <= BOX_YPOS_LOWER + 10 and yposb >= BOX_YPOS_LOWER - 10 then 
			for i in 0 to 3 loop
				--Left side
				if xposb >= BOX_XPOS_RP + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  - 10 then
					--set vx
				--Right side
				elsif xposb <= BOX_XPOS_RP + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_RP + i * X_BOS_DIST  + 10 then
					--set vx
				end if;
			end loop;
		--middle box
		elsif yposb <= BOX_YPOS_MIDDLE + 10 and yposb >= BOX_YPOS_MIDDLE - 10 then 
			for i in 0 to 3 loop
				--Left side
				if xposb >= BOX_XPOS_MID + i * X_BOS_DIST - 15 AND xposb <= BOX_XPOS_MID + i * X_BOS_DIST  - 10 then
					--set vx
				--Right side
				elsif xposb <= BOX_XPOS_MID + i * X_BOS_DIST + 15 AND xposb <= BOX_XPOS_MID + i * X_BOS_DIST  + 10 then
					--set vx
				end if;
			end loop;
		end if;
		
		--bumper collision logic
		if yposb < yposbmp1 + 
		
	end process;
end behavioral;