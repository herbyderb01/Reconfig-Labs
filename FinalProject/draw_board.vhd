library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity draw_board is
    Port (
        pixel_x     : in  STD_LOGIC_VECTOR(9 downto 0); -- Current X pixel
        pixel_y     : in  STD_LOGIC_VECTOR(9 downto 0); -- Current Y pixel
        pixel_en    : in  STD_LOGIC;                   -- Pixel enable
        board_color : out STD_LOGIC_VECTOR(11 downto 0) -- RGB output for board
    );
end draw_board;

architecture Behavioral of draw_board is
    constant PLAYING_FIELD_TOP    : integer := 80;  -- Y position
    constant PLAYING_FIELD_BOTTOM : integer := 400; -- Y position
    constant PLAYING_FIELD_LEFT   : integer := 20;  -- X position
    constant PLAYING_FIELD_RIGHT  : integer := 620; -- X position

    constant GOAL_WIDTH           : integer := 70;
    constant OBSTACLE_SIZE        : integer := 20;
    constant OBSTACLE_PATTERN     : integer_array(0 to 8) := 
                                    (120, 180, 240, 300, 360, 420, 480, 540, 600); 
begin
    process(pixel_x, pixel_y, pixel_en)
    begin
        if pixel_en = '1' then
            if pixel_x >= PLAYING_FIELD_LEFT and pixel_x <= PLAYING_FIELD_RIGHT and 
               pixel_y >= PLAYING_FIELD_TOP and pixel_y <= PLAYING_FIELD_BOTTOM then
                -- Playing field boundary
                if pixel_x = PLAYING_FIELD_LEFT or pixel_x = PLAYING_FIELD_RIGHT or
                   pixel_y = PLAYING_FIELD_TOP or pixel_y = PLAYING_FIELD_BOTTOM then
                    board_color <= "111111111111"; -- White
                -- Obstacles
                elsif (pixel_x mod OBSTACLE_SIZE = 0 and 
                       pixel_y mod OBSTACLE_SIZE = 0) then
                    board_color <= "111100000000"; -- Red
                else
                    board_color <= "000000000000"; -- Black
                end if;
            else
                board_color <= "000000000000"; -- Black
            end if;
        else
            board_color <= "000000000000"; -- Default to black
        end if;
    end process;
end Behavioral;
