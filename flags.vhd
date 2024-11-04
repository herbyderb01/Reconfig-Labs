library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity flags is
	port (
		clk : in std_logic;
		pixel_en : in std_logic;
		rst : in std_logic;
		advance: in std_logic;
		VGA_R : out std_logic_vector(3 downto 0);
		VGA_G : out std_logic_vector(3 downto 0);
		VGA_B : out std_logic_vector(3 downto 0)
	);
end flags;

architecture states of flags is
	type flag_state is (france, italy, ireland, belgium, mali, 
	chad, nigeria, ivory, poland, germany, austria, congo);
	signal current_flag, next_flag : flag_state := france;
	
	signal flag_en : std_logic_vector(11 downto 0) := (others => '0');
	
	type vga_array is array (0 to 11) of std_logic_vector(17 downto 0);
	signal vga_colors : vga_array;
	
	component FrenchFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component FrenchFlag;
	
	component ItalyFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component ItalyFlag;
	
	component IrelandFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component IrelandFlag;
	
		component BelgiumFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component BelgiumFlag;
	
		component MaliFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component MaliFlag;
	
		component ChadFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component ChadFlag;
	
		component NigeriaFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component NigeriaFlag;
	
		component IvoryFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component IvoryFlag;
	
		component PolandFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component PolandFlag;
	
		component GermanyFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component GermanyFlag;
	
		component AustriaFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component AustriaFlag;
	
		component CongoFlag
		port (
			clk			: in std_logic;						-- VGA clock
			rst			: in std_logic;						-- Reset
			en			: in std_logic;						-- Enable
			h_count		: in integer range 0 to 639;		-- Horizontal pixel count
			v_count		: in integer range 0 to 479;		-- Vertical pixel count
			pixel_en	: in std_logic;						-- Pixel enable signal from VGA controller
			pixel_rgb	: out std_logic_vector(17 downto 0)	-- 18-bit RGB output (6 bits each for R, G, B)
		);
	end component CongoFlag;
	
begin

	French_Flag : FrenchFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(0), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(0)
        );
	
	Italy_Flag : ItalyFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(1), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(1)(17 downto 0)
        );
		
	Ireland_Flag : IrelandFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(2), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(2)(17 downto 0)
        );
		
	Belgium_Flag : BelgiumFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(3), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(3)(17 downto 0)
        );
		
	Mali_Flag : MaliFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(4), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(4)(17 downto 0)
        );
		
	Chad_Flag : ChadFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(5), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(5)(17 downto 0)
        );
		
	Nigeria_Flag : NigeriaFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(6), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(6)(17 downto 0)
        );
		
	Ivory_Flag : IvoryFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(7), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(7)(17 downto 0)
        );
		
	Poland_Flag : PolandFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(8), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(8)(17 downto 0)
        );
		
	Germany_Flag : GermanyFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(9), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(9)(17 downto 0)
        );
		
	Austria_Flag : AustriaFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(10), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(10)(17 downto 0)
        );
		
	Congo_Flag : CongoFlag
        port map (
            clk			=> clk,
			rst			=> rst,
			en			=> flag_en(11), --fix later
            h_count		=> 0,
            v_count		=> 0,
            pixel_en	=> pixel_en,
            pixel_rgb	=> vga_colors(11)(17 downto 0)
        );

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_flag <= france;
			else
				current_flag <= next_flag;
			end if;
		end if;
	end process;
	
	process(current_flag, next_flag)
	begin
		case current_flag is
			when france =>
			flag_en(0) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= italy;
			else	
				next_flag <= france;
			end if;
			
			when italy =>
			flag_en(1) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= ireland;
			else	
				next_flag <= italy;
			end if;
			
			when ireland =>
			flag_en(2) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= belgium;
			else	
				next_flag <= ireland;
			end if;
			
			when belgium =>
			flag_en(3) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= mali;
			else	
				next_flag <= belgium;
			end if;
			
			when mali =>
			flag_en(4) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= chad;
			else	
				next_flag <= mali;
			end if;
			
			when chad =>
			flag_en(5) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= nigeria;
			else	
				next_flag <= chad;
			end if;
			
			when nigeria =>
			flag_en(6) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= ivory;
			else	
				next_flag <= nigeria;
			end if;
			
			when ivory =>
			flag_en(7) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= poland;
			else	
				next_flag <= ivory;
			end if;
			
			when poland =>
			flag_en(8) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= germany;
			else	
				next_flag <= poland;
			end if;
			
			when germany =>
			flag_en(9) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= austria;
			else	
				next_flag <= germany;
			end if;
			
			when austria =>
			flag_en(10) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= congo;
			else	
				next_flag <= austria;
			end if;
			
			when congo =>
			
			flag_en(11) <= '1';
			if advance = '1' then
				flag_en <= (others => '0');
				next_flag <= france;
			else	
				next_flag <= congo;
			end if;
			
			when others => 
				flag_en <= (others => '0');
				next_flag <= france;
		end case;
	end process;
	
	VGA_R <= vga_colors(0)(17 downto 14) when flag_en(0) = '1' else
         vga_colors(1)(17 downto 14) when flag_en(1) = '1' else
         vga_colors(2)(17 downto 14) when flag_en(2) = '1' else
         vga_colors(3)(17 downto 14) when flag_en(3) = '1' else
         vga_colors(4)(17 downto 14) when flag_en(4) = '1' else
         vga_colors(5)(17 downto 14) when flag_en(5) = '1' else
         vga_colors(6)(17 downto 14) when flag_en(6) = '1' else
         vga_colors(7)(17 downto 14) when flag_en(7) = '1' else
         vga_colors(8)(17 downto 14) when flag_en(8) = '1' else
         vga_colors(9)(17 downto 14) when flag_en(9) = '1' else
         vga_colors(10)(17 downto 14) when flag_en(10) = '1' else
         vga_colors(11)(17 downto 14) when flag_en(11) = '1' else
         (others => '0');

	
	VGA_G <= vga_colors(0)(11 downto 8) when flag_en(0) = '1' else
         vga_colors(1)(11 downto 8) when flag_en(1) = '1' else
         vga_colors(2)(11 downto 8) when flag_en(2) = '1' else
         vga_colors(3)(11 downto 8) when flag_en(3) = '1' else
         vga_colors(4)(11 downto 8) when flag_en(4) = '1' else
         vga_colors(5)(11 downto 8) when flag_en(5) = '1' else
         vga_colors(6)(11 downto 8) when flag_en(6) = '1' else
         vga_colors(7)(11 downto 8) when flag_en(7) = '1' else
         vga_colors(8)(11 downto 8) when flag_en(8) = '1' else
         vga_colors(9)(11 downto 8) when flag_en(9) = '1' else
         vga_colors(10)(11 downto 8) when flag_en(10) = '1' else
         vga_colors(11)(11 downto 8) when flag_en(11) = '1' else
         (others => '0');

	VGA_B <= vga_colors(0)(7 downto 4) when flag_en(0) = '1' else
         vga_colors(1)(7 downto 4) when flag_en(1) = '1' else
         vga_colors(2)(7 downto 4) when flag_en(2) = '1' else
         vga_colors(3)(7 downto 4) when flag_en(3) = '1' else
         vga_colors(4)(7 downto 4) when flag_en(4) = '1' else
         vga_colors(5)(7 downto 4) when flag_en(5) = '1' else
         vga_colors(6)(7 downto 4) when flag_en(6) = '1' else
         vga_colors(7)(7 downto 4) when flag_en(7) = '1' else
         vga_colors(8)(7 downto 4) when flag_en(8) = '1' else
         vga_colors(9)(7 downto 4) when flag_en(9) = '1' else
         vga_colors(10)(7 downto 4) when flag_en(10) = '1' else
         vga_colors(11)(7 downto 4) when flag_en(11) = '1' else
         (others => '0');



end states;