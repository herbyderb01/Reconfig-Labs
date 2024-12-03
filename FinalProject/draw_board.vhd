library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity draw_board is
	Port (
		clk			: in  std_logic;  -- VGA clock
		rst			: in  std_logic;  -- Reset
		pixel_x    : in  STD_LOGIC_VECTOR(9 downto 0);  -- Pixel X coordinate
		pixel_y    : in  STD_LOGIC_VECTOR(9 downto 0);  -- Pixel Y coordinate
		pixel_en   : in  STD_LOGIC;                     -- Pixel enable signal
		ball_en   : in  STD_LOGIC;                       -- Ball enable signal
		ball_x     : in  integer;                        -- Ball X position
		ball_y     : in  integer;                        -- Ball Y position
		paddle_1_y : in  integer;                        -- Paddle 1 Y position
		paddle_2_y : in  integer;                        -- Paddle 2 Y position
		p1_points: in integer;							 -- P1 points
		p2_points: in integer;							 -- P2 points
		frame_end  : out std_logic;
		board_color : out STD_LOGIC_VECTOR(11 downto 0)  -- RGB color output for each pixel
	);
end draw_board;

architecture Behavioral of draw_board is

	-- Constants for Score 
	constant SEGMENT_W    : integer := 30;   -- Width of horizontal segments (scaled for 20-pixel width)
	constant SEGMENT_H    : integer := 6;    -- Height of horizontal segments (scaled for clarity)
	constant SEGMENT_V_H  : integer := 17;   -- Height of vertical segments (scaled for 30-pixel height)
	constant SEGMENT_GAP  : integer := 0;    -- Gap between segments
	
	-- Player 1 Score Position
	constant P1_DIGIT_LEFT   : integer := 125;  -- X-coordinate of the digit's top-left corner
	constant P1_DIGIT_TOP    : integer := 390;  -- Y-coordinate of the digit's top-left corner
	
	-- Player 2 Score Position
	constant P2_DIGIT_LEFT   : integer := 485;  -- X-coordinate of the digit's top-left corner
	constant P2_DIGIT_TOP    : integer := 390;  -- Y-coordinate of the digit's top-left corner

	-- Signal for active segments
	signal segments_p1 : std_logic_vector(6 downto 0);  -- 7-segment encoding
	signal score_num_p1    : integer range 0 to 5;  -- The number to display
	signal segments_p2 : std_logic_vector(6 downto 0);  -- 7-segment encoding
	signal score_num_p2    : integer range 0 to 5;  -- The number to display

	-- Segment mapping:
	-- segments(6): Top
	-- segments(5): Top-right
	-- segments(4): Bottom-right
	-- segments(3): Bottom
	-- segments(2): Bottom-left
	-- segments(1): Top-left
	-- segments(0): Middle

	-- Testing Signals
	-- signal ball_x : integer := 320;
	-- signal ball_y : integer := 60;

	signal x_pixel_pos : integer := 0; -- x pixel pos
	signal y_pixel_pos : integer := 0; -- y pixel pos

begin

	process(clk)
	begin
		if rising_edge(clk) then
			frame_end <= '0';
			if rst = '1' then
				x_pixel_pos <= 0;
				y_pixel_pos <= 0;
			else
				if pixel_en = '1' then
					x_pixel_pos <= x_pixel_pos + 1;
					if x_pixel_pos = 639 then
						x_pixel_pos <= 0;
						y_pixel_pos <= y_pixel_pos + 1;
					end if;
					if y_pixel_pos = 480 then
						y_pixel_pos <= 0;
						frame_end <= '1';
					end if;
				end if;
				
			end if;
		end if;
	end process;

	-- process(p1_points, p2_points)
	-- begin
	-- 	-- Constrain p1_points to the range 0 to 5
	-- 	if p1_points < 0 then
	-- 		score_num_p1 <= 0;  -- Minimum value
	-- 	elsif p1_points > 5 then
	-- 		score_num_p1 <= 5;  -- Maximum value
	-- 	else
	-- 		score_num_p1 <= p1_points;  -- Within range
	-- 	end if;
	
	-- 	-- Constrain p2_points to the range 0 to 5
	-- 	if p2_points < 0 then
	-- 		score_num_p2 <= 0;  -- Minimum value
	-- 	elsif p2_points > 5 then
	-- 		score_num_p2 <= 5;  -- Maximum value
	-- 	else
	-- 		score_num_p2 <= p2_points;  -- Within range
	-- 	end if;
	-- end process;	

	-- Case statement to control active segments of p1
	process(p1_points)
	begin
		case p1_points is
			when 0 => segments_p1 <= "1111110";  -- 0
			when 1 => segments_p1 <= "0110000";  -- 1
			when 2 => segments_p1 <= "1101101";  -- 2
			when 3 => segments_p1 <= "1111001";  -- 3
			when 4 => segments_p1 <= "0110011";  -- 4
			when 5 => segments_p1 <= "1011011";  -- 5
			when others => segments_p1 <= "0000000";  -- Blank (default)
		end case;
	end process;

	-- Case statement to control active segments of p2
	process(p2_points)
	begin
		case p2_points is
			when 0 => segments_p2 <= "1111110";  -- 0
			when 1 => segments_p2 <= "0110000";  -- 1
			when 2 => segments_p2 <= "1101101";  -- 2
			when 3 => segments_p2 <= "1111001";  -- 3
			when 4 => segments_p2 <= "0110011";  -- 4
			when 5 => segments_p2 <= "1011011";  -- 5
			when others => segments_p2 <= "0000000";  -- Blank (default)
		end case;
	end process;

	process(clk, pixel_en)
	begin
		-- Default background color (black)
		board_color <= "000000000000";  -- Black color (no pixel enabled)
		
		if pixel_en = '1' then
			-- Draw the playing field (600x320) area
			if (x_pixel_pos >= 20 and x_pixel_pos < 620) and
			(y_pixel_pos >= 20 and y_pixel_pos < 340) then
				-- Drawing the boundary (3-pixel-wide white border)
				if (x_pixel_pos >= 20 and x_pixel_pos < 23) or  -- Left border
					(x_pixel_pos >= 617 and x_pixel_pos < 620) then  -- Right border
						if (y_pixel_pos >= 145 and y_pixel_pos < 215) then
							board_color <= "000000000000";  -- Black for goals
						else 
							board_color <= "111111111111";  -- White color for boundary
						end if;
					elsif (y_pixel_pos >= 20 and y_pixel_pos < 23) or  -- Top border
					(y_pixel_pos >= 337 and y_pixel_pos < 340) then  -- Bottom border
					
					board_color <= "111111111111";  -- White color for boundary
				else
				-- Inside the playing field (optional color logic)
				board_color <= "000000000000";  -- Black or any other color for the inside
				end if;
			end if;

			-- Draw middle box
			if (x_pixel_pos >= 310 and x_pixel_pos < 330) and
			   (y_pixel_pos >= 170 and y_pixel_pos < 190) then
				board_color <= "111100000000";  -- Obstacle (red)
			end if;

			-- Draw upper 4 red boxes, each 20x20 pixels, spaced 60 pixels apart from left to right
			for i in 0 to 3 loop
				if (x_pixel_pos >= (155 + (i * 95)) and x_pixel_pos < (175 + (i * 95))) and
				(y_pixel_pos >= 100 and y_pixel_pos < 120) then
					board_color <= "111100000000";  -- Obstacle (red)
				end if;
			end loop;

			-- Draw lower 4 red boxes, each 20x20 pixels, spaced 60 pixels apart from left to right
			for i in 0 to 3 loop
				if (x_pixel_pos >= (155 + (i * 95)) and x_pixel_pos < (175 + (i * 95))) and
				(y_pixel_pos >= 240 and y_pixel_pos < 260) then
					board_color <= "111100000000";  -- Obstacle (red)
				end if;
			end loop;

			-- Draw the ball (diameter 10 pixels, radius 5 pixels)
			if ball_en = '1' then
				if ((x_pixel_pos - ball_x) * (x_pixel_pos - ball_x) + 
					(y_pixel_pos - ball_y) * (y_pixel_pos - ball_y)) < (5 * 5) then
					board_color <= "111111111111";  -- White color for the ball
				end if;
			end if;
			
			-- Draw Paddle 1 (40x5 brown or orange)
			if (x_pixel_pos >= 40 and x_pixel_pos < 45) and  -- TODO: Change to center of ball for 0,0 x,y cordinate
			   (y_pixel_pos >= paddle_1_y and y_pixel_pos < paddle_1_y + 40) then
			    board_color <= "111101000000";  -- Paddle 1 color (dark brown/orange)
			end if;

			-- Draw Paddle 2 (40x5 brown or orange)
			if (x_pixel_pos >= 595 and x_pixel_pos < 600) and  -- TODO: Change to center of ball for 0,0 x,y cordinate
			   (y_pixel_pos >= paddle_2_y and y_pixel_pos < paddle_2_y + 40) then
			    board_color <= "111101000000";  -- Paddle 2 color (dark brown/orange)
			end if;
			
			--------------------------------- DRAW SCORES P1 ---------------------------------
			-- Draw the top segment
			if segments_p1(6) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-right segment
			if segments_p1(5) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-right segment
			if segments_p1(4) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom segment
			if segments_p1(3) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 3 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-left segment
			if segments_p1(2) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-left segment
			if segments_p1(1) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the middle segment
			if segments_p1(0) = '1' and
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			--------------------------------- DRAW SCORES P2 ---------------------------------
			-- Draw the top segment
			if segments_p2(6) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P2_DIGIT_TOP and y_pixel_pos < P2_DIGIT_TOP + SEGMENT_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-right segment
			if segments_p2(5) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P2_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P2_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-right segment
			if segments_p2(4) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P2_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P2_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom segment
			if segments_p2(3) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P2_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP and
			y_pixel_pos < P2_DIGIT_TOP + 3 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-left segment
			if segments_p2(2) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P2_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P2_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-left segment
			if segments_p2(1) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P2_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P2_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the middle segment
			if segments_p2(0) = '1' and
			x_pixel_pos >= P2_DIGIT_LEFT and x_pixel_pos < P2_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P2_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P2_DIGIT_TOP + 2 * SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

		else
			board_color <= (others => '0');
		end if;
	end process;

end Behavioral;