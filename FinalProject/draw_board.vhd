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
		ball_x     : in  integer;                        -- Ball X position
		ball_y     : in  integer;                        -- Ball Y position
		paddle_1_y : in  integer;                        -- Paddle 1 Y position
		paddle_2_y : in  integer;                        -- Paddle 2 Y position
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
	constant P2_DIGIT_LEFT   : integer := 400;  -- X-coordinate of the digit's top-left corner
	constant P2_DIGIT_TOP    : integer := 390;  -- Y-coordinate of the digit's top-left corner

	-- Signal for active segments
	signal segments : std_logic_vector(6 downto 0);  -- 7-segment encoding
	signal case_num    : integer range 0 to 5;  -- The number to display

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

	-- -- Case statement to control active segments
	-- process(case_num)
	-- begin
	-- 	case case_num is
	-- 		when 0 => segments <= "1111110";  -- 0
	-- 		when 1 => segments <= "0110000";  -- 1
	-- 		when 2 => segments <= "1101101";  -- 2
	-- 		when 3 => segments <= "1111001";  -- 3
	-- 		when 4 => segments <= "0110011";  -- 4
	-- 		when 5 => segments <= "1011011";  -- 5
	-- 		when others => segments <= "0000000";  -- Blank (default)
	-- 	end case;
	-- end process;

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

			-- Drawing or static obstacle:
			if (x_pixel_pos >= 310 and x_pixel_pos < 330) and
			   (y_pixel_pos >= 170 and y_pixel_pos < 190) then
				board_color <= "111100000000";  -- Obstacle (red)
			end if;

			-- Draw upper 4 red boxes, each 20x20 pixels, spaced 60 pixels apart from left to right
			for i in 0 to 3 loop
				if (x_pixel_pos >= (175 + (i * 90)) and x_pixel_pos < (195 + (i * 90))) and
				(y_pixel_pos >= 100 and y_pixel_pos < 120) then
					board_color <= "111100000000";  -- Obstacle (red)
				end if;
			end loop;

			-- Draw lower 4 red boxes, each 20x20 pixels, spaced 60 pixels apart from left to right
			for i in 0 to 3 loop
				if (x_pixel_pos >= (175 + (i * 90)) and x_pixel_pos < (195 + (i * 90))) and
				(y_pixel_pos >= 240 and y_pixel_pos < 260) then
					board_color <= "111100000000";  -- Obstacle (red)
				end if;
			end loop;

			-- Draw the ball (diameter 10 pixels, radius 5 pixels)
			if ((x_pixel_pos - ball_x) * (x_pixel_pos - ball_x) + 
				(y_pixel_pos - ball_y) * (y_pixel_pos - ball_y)) < (5 * 5) then
				board_color <= "111111111111";  -- White color for the ball
			end if;
			
			-- -- Draw Paddle 1 (40x5 brown or orange)
			-- if (x_pixel_pos >= 270 and x_pixel_pos < 310) and  -- TODO: Change to center of ball for 0,0 x,y cordinate
			--    (y_pixel_pos >= paddle_1_y and y_pixel_pos < paddle_1_y + 5) then
			--     board_color <= "101010000000";  -- Paddle 1 color (dark brown/orange)
			-- end if;

			-- -- Draw Paddle 2 (40x5 brown or orange)
			-- if (x_pixel_pos >= 330 and x_pixel_pos < 370)   -- TODO: Change to center of ball for 0,0 x,y cordinate
			--    (y_pixel_pos >= paddle_2_y and y_pixel_pos < paddle_2_y + 5) then
			--     board_color <= "101010000000";  -- Paddle 2 color (dark brown/orange)
			-- end if;

			-- Add additional logic for other game elements like obstacles, score display, etc.
			
			-- DRAW SCORES
			-- Draw the top segment
			-- if segments(6) = '1' and
			if 
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-right segment
			-- if segments(5) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-right segment
			-- if segments(4) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom segment
			-- if segments(3) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 3 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the bottom-left segment
			-- if segments(2) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the top-left segment
			-- if segments(1) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_H and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H and y_pixel_pos < P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
				board_color <= "111111111111";  -- White
			end if;

			-- Draw the middle segment
			-- if segments(0) = '1' and
			if
			x_pixel_pos >= P1_DIGIT_LEFT and x_pixel_pos < P1_DIGIT_LEFT + SEGMENT_W and
			y_pixel_pos >= P1_DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
			y_pixel_pos < P1_DIGIT_TOP + 2 * SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP then
				board_color <= "111111111111";  -- White
			end if;

		else
			board_color <= (others => '0');
		end if;
	end process;

end Behavioral;