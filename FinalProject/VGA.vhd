library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity VGA is
	port (
		clk			: in std_logic;  -- VGA clock
		rst			: in std_logic;  -- Reset signal
		h_sync		: out std_logic; -- Horizontal sync output
		v_sync		: out std_logic; -- Vertical sync output
		pixel_en	: out std_logic -- Pixel enable signal (high when in active region)
		--h_count		: out integer;   -- Horizontal pixel count (optional, for debugging or extra features)
		--v_count		: out integer    -- Vertical line count (optional, for debugging or extra features)
	);
end VGA;

architecture Behavioral of VGA is

	-- VGA Parameters for 640x480 @ 60 Hz
	constant H_ACTIVE      : integer := 640;  -- Active video (visible pixels)
	constant H_FRONT_PORCH : integer := 16;   -- Front porch
	constant H_SYNC_PULSE  : integer := 96;   -- Sync pulse
	constant H_BACK_PORCH  : integer := 48;   -- Back porch
	constant H_TOTAL       : integer := H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;  -- Total horizontal pixels

	constant V_ACTIVE      : integer := 480;  -- Active video (visible lines)
	constant V_FRONT_PORCH : integer := 10;   -- Front porch
	constant V_SYNC_PULSE  : integer := 2;    -- Sync pulse
	constant V_BACK_PORCH  : integer := 33;   -- Back porch
	constant V_TOTAL       : integer := V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;  -- Total vertical lines

	-- VGA State Machine states
	type VGA_State is (PIXEL_DATA, FRONT_PORCH, SYNC_PULSE, BACK_PORCH);
	signal h_state, next_h_state : VGA_State := FRONT_PORCH;
	signal v_state, next_v_state : VGA_State := FRONT_PORCH;

	-- Counters for horizontal and vertical timing
	-- signal h_counter : integer range 0 to H_TOTAL - 1 := 0;
	-- signal v_counter : integer range 0 to V_TOTAL - 1 := 0;
	signal h_counter : integer := 0;
	signal v_counter : integer := 0;

begin

	-- Horizontal state machine process
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				h_counter <= 0;
				h_state <= FRONT_PORCH;
			else
				-- Update state and counter
				h_state <= next_h_state;
				if h_counter = H_TOTAL then
					h_counter <= 0;  -- Reset on end of line
				else
					h_counter <= h_counter + 1;
				end if;
			end if;
		end if;
	end process;

	-- Vertical state machine process
	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				v_counter <= 0;
				v_state <= FRONT_PORCH;
			elsif h_counter = H_TOTAL then  -- Only increment on each new line
				v_state <= next_v_state;
				if v_counter = V_TOTAL then
					v_counter <= 0;  -- Reset on end of frame
				else
					v_counter <= v_counter + 1;
				end if;
			end if;
		end if;
	end process;

	-- Horizontal state transition logic
	process(h_counter, h_state)
	begin
		case h_state is
			when FRONT_PORCH =>
			if h_counter = H_FRONT_PORCH then
				next_h_state <= SYNC_PULSE;
			else
				next_h_state <= FRONT_PORCH;
			end if;
			
			when SYNC_PULSE =>
			if h_counter = H_FRONT_PORCH + H_SYNC_PULSE then
				next_h_state <= BACK_PORCH;
			else
				next_h_state <= SYNC_PULSE;
			end if;
			
			when BACK_PORCH =>
			if h_counter = H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH then
				next_h_state <= PIXEL_DATA;
			else
				next_h_state <= BACK_PORCH;
			end if;

			when PIXEL_DATA =>
				if h_counter = H_TOTAL then
					next_h_state <= FRONT_PORCH;
				else
					next_h_state <= PIXEL_DATA;
				end if;
		end case;
	end process;

	-- Vertical state transition logic
	process(v_counter, v_state)
	begin
		case v_state is
			when FRONT_PORCH =>
			if v_counter = V_FRONT_PORCH then
				next_v_state <= SYNC_PULSE;
			else
				next_v_state <= FRONT_PORCH;
			end if;
			
			when SYNC_PULSE =>
			if v_counter = V_FRONT_PORCH + V_SYNC_PULSE then
				next_v_state <= BACK_PORCH;
			else
				next_v_state <= SYNC_PULSE;
			end if;
			
			when BACK_PORCH =>
			if v_counter = V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH then
				next_v_state <= PIXEL_DATA;
			else
				next_v_state <= BACK_PORCH;
			end if;

			when PIXEL_DATA =>
				if v_counter = V_TOTAL then
					next_v_state <= FRONT_PORCH;
				else
					next_v_state <= PIXEL_DATA;
				end if;

		end case;
	end process;

	-- Output assignments
	h_sync <= '0' when h_state = SYNC_PULSE else '1';
	v_sync <= '0' when v_state = SYNC_PULSE else '1';
	pixel_en <= '1' when (h_state = PIXEL_DATA) and (v_state = PIXEL_DATA) else '0';

	-- Optional outputs for debugging
	--h_count <= h_counter;
	--v_count <= v_counter;

end Behavioral;
