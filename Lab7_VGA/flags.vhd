library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity flags is
	port (
		clk : in std_logic;
		pixel_en : out std_logic;
		rst : in std_logic;
		advance: in std_logic;
		VGA_R : out std_logic_vector(3 downto 0);
		VGA_G : out std_logic_vector(3 downto 0);
		VGA_B : out std_logic_vector(3 downto 0)
	);
end flags;

architecture states of flags is
	type flag_state is (french, italy, ireland, belgium, mali, 
	chad, nigeria, cotedivoire, poland, germany, austria, congo);
	signal current_flag, next_flag : flag_state := french;
	
	signal french_en : std_logic := '0';
	signal italy_en : std_logic := '0';
	signal ireland_en : std_logic := '0';
	signal belgium_en : std_logic := '0';
	signal mali_en : std_logic := '0';
	signal chad_en : std_logic := '0';
	signal nigeria_en : std_logic := '0';
	signal cotedivoire_en : std_logic := '0';
	signal poland_en : std_logic := '0';
	signal germany_en : std_logic := '0';
	signal austria_en : std_logic := '0';
	signal congo_en : std_logic := '0';
	
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_flag <= french;
				french_en <= '1';
				italy_en <= '0';
				ireland_en <= '0';
				belgium_en <= '0';
				mali_en <= '0';
				chad_en <= '0';
				nigeria_en <= '0';
				cotedivoire_en <= '0';
				poland_en <= '0';
				germany_en <= '0';
				austria_en <= '0';
				congo_en <= '0';
			else
				current_flag <= next_flag;
		end if
	end process
	
	process(current_flag, next_flag)
	begin
		case current_flag is
			when french =>
			french_en <= '1'
			if advance = '1' then
				next_flag <= italy;
			else	
				next_flag <= french;
			end if
			
	end process

end states;