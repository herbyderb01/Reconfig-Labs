library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FinalProject is
	port (
		-- CLOCK --
		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic;
		MAX10_CLK2_50 : in std_logic;

		-- KEY --
		KEY : in std_logic_vector(1 downto 0);
		
		-- VGA --
		VGA_B : out std_logic_vector(3 downto 0);
		VGA_G : out std_logic_vector(3 downto 0);
		VGA_HS : out std_logic;
		VGA_R : out std_logic_vector(3 downto 0);
		VGA_VS : out std_logic
	);
end FinalProject;

architecture component_list of FinalProject is

	component debouncer
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;

	component RNG is
		port (
			clk       : in  std_logic;  -- Clock signal
			reset     : in  std_logic;  -- Reset signal
			rng_out   : out std_logic   -- Random output (0 or 1)
		);
	end component;

	component VGA
		port (
			clk        : in std_logic;  -- VGA clock
			rst      : in std_logic;  -- Reset signal
			h_sync     : out std_logic; -- Horizontal sync output
			v_sync     : out std_logic; -- Vertical sync output
			pixel_en   : out std_logic; -- Pixel enable signal (high when in active region)
			h_count    : out integer;   -- Horizontal pixel count (optional, for debugging or extra features)
			v_count    : out integer    -- Vertical line count (optional, for debugging or extra features)
		);
	end component VGA;

	component draw_board is
        port (
			clk			: in  std_logic;  -- VGA clock
			rst			: in  std_logic;  -- Reset
			pixel_x    : in  STD_LOGIC_VECTOR(9 downto 0);  -- Pixel X coordinate
			pixel_y    : in  STD_LOGIC_VECTOR(9 downto 0);  -- Pixel Y coordinate
			pixel_en   : in  STD_LOGIC;                     -- Pixel enable signal
			ball_en   : in  STD_LOGIC;                      -- Ball enable signal
			ball_x     : in  integer;                        -- Ball X position
			ball_y     : in  integer;                        -- Ball Y position
			paddle_1_y : in  integer;                        -- Paddle 1 Y position
			paddle_2_y : in  integer;                        -- Paddle 2 Y position
			p1_points: in integer;							 -- P1 points
			p2_points: in integer;							 -- P2 points
			frame_end  : out std_logic;
			board_color : out STD_LOGIC_VECTOR(11 downto 0)  -- RGB color output for each pixel
		);
    end component;

	component PLL_25M
		port (
			inclk0	: in STD_LOGIC;
			c0		: out STD_LOGIC
		);
	end component PLL_25M;

	component ball_logic 
		port (
			clk			: in std_logic;
			rst			: in std_logic;
			frame_end	: in std_logic;
			new_round	: in std_logic;
			start_pos	: in std_logic;
			ball_en		: in std_logic;
			Vx			: in integer;
			Vy			: in integer;
			xposb		: out integer;
			yposb		: out integer
		);
	end component ball_logic;
	
	component collision_detector 
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
	end component collision_detector;

	component paddle_control
		port (
			clk				: in std_logic;
			rst_btn			: in std_logic;
			frame_end		: in std_logic;
			paddle_1_y		: out integer;
			paddle_2_y		: out integer
		);
	end component paddle_control;

	type state_type is (START, GAME_RUNNING, SCORED, FINISHED);
	signal current_state, next_state: state_type;
		
	signal key0_l : std_logic;
	signal key1_l : std_logic;
	signal new_ball_btn : std_logic;

	signal vga_clk	: std_logic;  -- VGA clock
	signal rst		: std_logic;  -- Reset signal
	signal pixel_en	: std_logic; -- Pixel enable signal (high when in active region)
	signal ball_en	: std_logic := '1'; -- Ball enable signal (high when playing before scoring)
	signal h_count	: integer;   -- Horizontal pixel count (optional, for debugging or extra features)
	signal v_count	: integer;    -- Vertical line count (optional, for debugging or extra features)

	signal pixel_rgb        : std_logic_vector(17 downto 0);

	-- Signal declarations for VGA and board drawing
    signal pixel_x     : STD_LOGIC_VECTOR(9 downto 0);
    signal pixel_y     : STD_LOGIC_VECTOR(9 downto 0);
    signal board_color : STD_LOGIC_VECTOR(11 downto 0); -- RGB color output

	signal ball_x		: integer; -- Ball X position
	signal ball_y		: integer; -- Ball Y position
	signal paddle_1_y		: integer; -- Paddle 1 Y position
	signal paddle_2_y		: integer; -- Paddle 2 Y position

	-- Collision Signals
	signal p1_points		: integer; -- Player 1 Score
	signal p2_points		: integer; -- Player 2 Score
	signal Vx				: integer; -- Ball Velocity x direction
	signal Vy				: integer; -- Ball Velocity y direction
	signal frame_end		: std_logic;
	signal p1_just_scored	: std_logic;
	signal p2_just_scored	: std_logic;

	signal rng_output : std_logic;

begin
	-- Reset the game button
	rst_btn : debouncer
		port map (
			clk => vga_clk,
			btn => key0_l,
			output => rst
		);

	-- start new ball button
	newBall_btn : debouncer
		port map (
			clk => vga_clk,
			btn => key1_l,
			output => new_ball_btn
		);

	-- Instantiate RNG
	rng_1 : RNG
		port map (
			clk     => vga_clk,       -- System clock
			reset   => rst,     -- System reset
			rng_out => rng_output -- Random output (0 or 1)
		);

	-- Instantiate VGA module
	VGA_inst : VGA
		port map (
			clk        => vga_clk,  
			rst        => rst,
			h_sync     => VGA_HS,
			v_sync     => VGA_VS,
			pixel_en   => pixel_en,
			h_count    => h_count,
			v_count    => v_count
		);

	-- Instantiate draw_board module
    draw_board_inst : draw_board
        port map (
			clk			=> vga_clk,
			rst			=> rst,
            pixel_x    => pixel_x,
            pixel_y    => pixel_y,
            pixel_en   => pixel_en,
            ball_en   => ball_en,
            ball_x     => ball_x,
            ball_y     => ball_y,
            paddle_1_y => paddle_1_y,
            paddle_2_y => paddle_2_y,
            p1_points => p1_points,
            p2_points => p2_points,
			frame_end => frame_end,
            board_color => board_color
        );

	PLL_25M_inst : PLL_25M 
		port map (
			inclk0	 => MAX10_CLK1_50,
			c0	 => vga_clk
		);

	ball : ball_logic
		port map(
			clk => vga_clk,
			rst => rst,
			frame_end => frame_end,
			new_round => new_ball_btn,
			start_pos => rng_output,
			ball_en => ball_en,
			Vx => Vx,
			Vy => Vy,
			xposb => ball_x,
			yposb => ball_y
		);
		
	boom : collision_detector
		port map(
			clk => vga_clk,
			rst => rst,
			xposb => ball_x,
			yposb => ball_y,
			paddle_1_y => paddle_1_y,
			paddle_2_y => paddle_2_y,
			frame_end => frame_end,
			p1_points => p1_points,
			p2_points => p2_points,
			p1_just_scored => p1_just_scored,
			p2_just_scored => p2_just_scored,
			Vx => Vx,
			Vy => Vy
		);
			
	paddle_control_inst : paddle_control
		port map(
			clk => ADC_CLK_10,
			rst_btn => rst,
			frame_end => frame_end,
			paddle_1_y => paddle_1_y,
			paddle_2_y => paddle_2_y
		);

	VGA_R <= board_color(11 downto 8);
	VGA_G <= board_color(7 downto 4);
	VGA_B <= board_color(3 downto 0);


	key0_l <= not KEY(0); 
	key1_l <= not KEY(1); 

	process(vga_clk) 
	begin
		if rising_edge(vga_clk) then
			current_state <= next_state;
			if rst = '1' then
				current_state <= START;
			end if;
		end if;
	end process;

	process (current_state, p1_points, p2_points, new_ball_btn)
	begin
		case current_state is
			when START =>
				ball_en <= '0';
				if new_ball_btn = '1' then
					next_state <= GAME_RUNNING;
					ball_en <= '1';
				else
					next_state <= START;
				end if;
				
			when GAME_RUNNING =>
				if p1_just_scored = '1' or p2_just_scored = '1' then
					ball_en <= '0';
					next_state <= SCORED;
				else
					next_state <= GAME_RUNNING;
				end if;
			
			when SCORED =>
				if new_ball_btn = '1' and (p1_points < 5 or p2_points < 5) then
					next_state <= GAME_RUNNING;
					ball_en <= '1';
				elsif p1_points = 5 or p2_points = 5 then
					next_state <= FINISHED;
					ball_en <= '0';
				end if;
			
			when FINISHED =>
				ball_en <= '0';
			
			when others =>
				next_state <= START;
		end case;
	end process;
	
end component_list;