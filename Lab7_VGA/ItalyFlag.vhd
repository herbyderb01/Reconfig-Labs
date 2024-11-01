library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ItalyFlag is
	port (
		clk			: in std_logic;						-- VGA clock
		rst			: in std_logic;						-- Reset
		en			: in std_logic;						-- Enable
		h_count		: in integer range 0 to 639;		-- Horizontal pixel count
		v_count		: in integer range 0 to 479;		-- Vertical pixel count
		pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
		pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
	);
end ItalyFlag;

architecture Behavioral of ItalyFlag is
	signal count : integer := 0;

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				count <= 0;
				pixel_rgb <= (others => '0');  -- Black when not in active area
			elsif pixel_en = '1' and en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Green)
					pixel_rgb <= "000000" & "100100" & "010001";
				elsif count < 426 then
					-- Middle third of the flag (White)
					pixel_rgb <= "111111" & "111111" & "111111";
				else
					-- Right third of the flag (Red)
					pixel_rgb <= "110011" & "001010" & "001101";
				end if;
				count <= count + 1;

				if count = 639 then
					count <= 0;
				end if;
			else
				pixel_rgb <= (others => '0');  -- Black when not in active area

			end if;
		end if;
	end process;
end Behavioral;

