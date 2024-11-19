-- Inputs
signal case_num    : integer range 0 to 5;  -- The number to display
signal x_pixel_pos : integer;              -- Current x pixel position
signal y_pixel_pos : integer;              -- Current y pixel position
signal vga_color   : std_logic_vector(11 downto 0);  -- VGA color output

-- Constants
constant DIGIT_LEFT   : integer := 300;  -- X-coordinate of the digit's top-left corner
constant DIGIT_TOP    : integer := 460;  -- Y-coordinate of the digit's top-left corner
constant SEGMENT_W    : integer := 40;   -- Width of horizontal segments
constant SEGMENT_H    : integer := 8;    -- Height of horizontal segments
constant SEGMENT_GAP  : integer := 5;    -- Gap between segments
constant SEGMENT_V_H  : integer := 20;   -- Vertical height for vertical segments

-- Signal for active segments
signal segments : std_logic_vector(6 downto 0);  -- 7-segment encoding

-- Segment mapping:
-- segments(6): Top
-- segments(5): Top-right
-- segments(4): Bottom-right
-- segments(3): Bottom
-- segments(2): Bottom-left
-- segments(1): Top-left
-- segments(0): Middle
begin

-- Case statement to control active segments
process(case_num)
begin
    case case_num is
        when 0 => segments <= "1111110";  -- 0
        when 1 => segments <= "0110000";  -- 1
        when 2 => segments <= "1101101";  -- 2
        when 3 => segments <= "1111001";  -- 3
        when 4 => segments <= "0110011";  -- 4
        when 5 => segments <= "1011011";  -- 5
        when others => segments <= "0000000";  -- Blank (default)
    end case;
end process;

-- VGA drawing logic
process(x_pixel_pos, y_pixel_pos, segments)
begin
    vga_color <= "000000000000";  -- Default to black

    -- Draw the top segment
    if segments(6) = '1' and
       x_pixel_pos >= DIGIT_LEFT and x_pixel_pos < DIGIT_LEFT + SEGMENT_W and
       y_pixel_pos >= DIGIT_TOP and y_pixel_pos < DIGIT_TOP + SEGMENT_H then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the top-right segment
    if segments(5) = '1' and
       x_pixel_pos >= DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < DIGIT_LEFT + SEGMENT_W and
       y_pixel_pos >= DIGIT_TOP + SEGMENT_H and y_pixel_pos < DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the bottom-right segment
    if segments(4) = '1' and
       x_pixel_pos >= DIGIT_LEFT + SEGMENT_W - SEGMENT_H and x_pixel_pos < DIGIT_LEFT + SEGMENT_W and
       y_pixel_pos >= DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
       y_pixel_pos < DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the bottom segment
    if segments(3) = '1' and
       x_pixel_pos >= DIGIT_LEFT and x_pixel_pos < DIGIT_LEFT + SEGMENT_W and
       y_pixel_pos >= DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP and
       y_pixel_pos < DIGIT_TOP + 3 * SEGMENT_H + 2 * SEGMENT_V_H + 2 * SEGMENT_GAP then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the bottom-left segment
    if segments(2) = '1' and
       x_pixel_pos >= DIGIT_LEFT and x_pixel_pos < DIGIT_LEFT + SEGMENT_H and
       y_pixel_pos >= DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
       y_pixel_pos < DIGIT_TOP + 2 * SEGMENT_H + 2 * SEGMENT_V_H + SEGMENT_GAP then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the top-left segment
    if segments(1) = '1' and
       x_pixel_pos >= DIGIT_LEFT and x_pixel_pos < DIGIT_LEFT + SEGMENT_H and
       y_pixel_pos >= DIGIT_TOP + SEGMENT_H and y_pixel_pos < DIGIT_TOP + SEGMENT_H + SEGMENT_V_H then
        vga_color <= "111111111111";  -- White
    end if;

    -- Draw the middle segment
    if segments(0) = '1' and
       x_pixel_pos >= DIGIT_LEFT and x_pixel_pos < DIGIT_LEFT + SEGMENT_W and
       y_pixel_pos >= DIGIT_TOP + SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP and
       y_pixel_pos < DIGIT_TOP + 2 * SEGMENT_H + SEGMENT_V_H + SEGMENT_GAP then
        vga_color <= "111111111111";  -- White
    end if;
end process;

