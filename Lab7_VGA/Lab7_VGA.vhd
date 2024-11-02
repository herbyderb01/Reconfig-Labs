library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Lab7_VGA is
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
end Lab7_VGA;

architecture component_list of Lab7_VGA is

	component debouncer
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;

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

	component GermanyFlag
		port (
			clk			: in std_logic;          -- VGA clock
			rst			: in std_logic;
			en			: in std_logic;
			h_count		: in integer range 0 to 639; -- Horizontal pixel count
			v_count		: in integer range 0 to 479; -- Vertical pixel count
			pixel_en	: in std_logic;          -- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0) -- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component GermanyFlag;

	component PLL_25M
		port (
			inclk0	: in STD_LOGIC;
			c0		: out STD_LOGIC
		);
	end component PLL_25M;
	
	
	signal key0_l : std_logic;
	signal key1_l : std_logic;
	signal pressed : std_logic;


	signal vga_clk	: std_logic;  -- VGA clock
	signal rst		: std_logic;  -- Reset signal
	signal pixel_en	: std_logic; -- Pixel enable signal (high when in active region)
	signal h_count	: integer;   -- Horizontal pixel count (optional, for debugging or extra features)
	signal v_count	: integer;    -- Vertical line count (optional, for debugging or extra features)

	signal pixel_rgb        : std_logic_vector(17 downto 0);

begin

	rst_btn : debouncer
		port map (
			clk => vga_clk,
			btn => key0_l,
			output => rst
		);
		
	nextFlag_btn : debouncer
		port map (
			clk => vga_clk,
			btn => key1_l,
			output => pressed
		);

	vga_1 : VGA
		port map (
			clk        => vga_clk,  
			rst        => rst,
			h_sync     => VGA_HS,
			v_sync     => VGA_VS,
			pixel_en   => pixel_en,
			h_count    => h_count,
			v_count    => v_count
		);

    -- Instantiate GermanyFlag pattern generator
    french_flag : GermanyFlag
        port map (
            clk			=> vga_clk,
			rst			=> rst,
			en			=> pixel_en, --fix later
            h_count		=> h_count,
            v_count		=> v_count,
            pixel_en	=> pixel_en,
            pixel_rgb	=> pixel_rgb
        );

	PLL_25M_inst : PLL_25M 
		port map (
			inclk0	 => MAX10_CLK1_50,
			c0	 => vga_clk
		);


	key0_l <= not KEY(0); 
	key1_l <= not KEY(1); 

    -- Assign pixel RGB values to VGA output based on `pixel_rgb`
    VGA_R <= pixel_rgb(17 downto 14);
    VGA_G <= pixel_rgb(11 downto 8);
    VGA_B <= pixel_rgb(5 downto 2);	
	
end component_list;