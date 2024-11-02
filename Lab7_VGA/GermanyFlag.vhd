library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GermanyFlag is
    port (
        clk         : in std_logic;                       -- VGA clock
        rst         : in std_logic;                       -- Reset
        en          : in std_logic;                       -- Enable
        h_count     : in integer range 0 to 639;         -- Horizontal pixel count
        v_count     : in integer range 0 to 479;         -- Vertical pixel count
        pixel_en    : in std_logic;                       -- Pixel enable signal from VGA controller
        pixel_rgb   : out std_logic_vector(17 downto 0)   -- 18-bit RGB output (6 bits each for R, G, B)
    );
end GermanyFlag;

architecture Behavioral of GermanyFlag is
	signal count : integer := v_count;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pixel_rgb <= (others => '0');  -- Black when reset
            elsif pixel_en = '1' and en = '1' then
                -- Determine the color based on vertical position (v_count)
                if count < 160 then
                    -- Top third of the flag (Black)
                    pixel_rgb <= "000000" & "001001" & "011001";  -- Dark Blue
                elsif count < 320 then
                    -- Middle third of the flag (Red)
                    pixel_rgb <= "111111" & "110010" & "000000";  -- Yellow
                else
                    -- Bottom third of the flag (Yellow)
                    pixel_rgb <= "110001" & "000011" & "001100";  -- Red
                end if;

				if count = 479 then
					count <= 0;
				end if;

            else
                pixel_rgb <= (others => '0');  -- Black when not in active area
            end if;
        end if;
    end process;
end Behavioral;
