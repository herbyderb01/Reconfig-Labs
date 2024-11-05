library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Flags is
	port (
		clk : in std_logic;
		pixel_en : in std_logic;
		rst : in std_logic;
		advance: in std_logic;
		VGA_R : out std_logic_vector(3 downto 0);
		VGA_G : out std_logic_vector(3 downto 0);
		VGA_B : out std_logic_vector(3 downto 0)
	);
end Flags;

architecture states of Flags is
	type flag_state is (france, italy, ireland, belgium, mali, 
	chad, nigeria, ivory, poland, germany, austria, congo, usa);
	signal current_flag, next_flag : flag_state := france;
	
	signal count : integer := 0;
	signal line_count : integer := 0;
		
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_flag <= france;
				count <= 0;
				line_count <= 0;
			else
				current_flag <= next_flag;
				if pixel_en = '1' then
					count <= count + 1;
					if count = 639 then
						count <= 0;
						line_count <= line_count + 1;
					end if;
					if line_count = 480 then
						line_count <= 0;
					end if;
				end if;
				
			end if;
		end if;
	end process;
	
	process(clk, current_flag, next_flag)
	begin
		case current_flag is
		when france =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0000";
					VGA_G <= "0010";
					VGA_B <= "1001";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1110";
					VGA_G <= "0010";
					VGA_B <= "0011";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;

			if advance = '1' then
				 
				next_flag <= italy;
			else	
				next_flag <= france;
			end if;
			
		when italy =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0000";
					VGA_G <= "1001";
					VGA_B <= "0100";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1100";
					VGA_G <= "0010";
					VGA_B <= "0011";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
		
			if advance = '1' then
				 
				next_flag <= ireland;
			else	
				next_flag <= italy;
			end if;
			
		when ireland =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0001";
					VGA_G <= "1001";
					VGA_B <= "0110";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1111";
					VGA_G <= "1000";
					VGA_B <= "0011";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= belgium;
			else	
				next_flag <= ireland;
			end if;
			
		when belgium =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "0100";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1110";
					VGA_G <= "0010";
					VGA_B <= "0011";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= mali;
			else	
				next_flag <= belgium;
			end if;
			
		when mali =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0001";
					VGA_G <= "1011";
					VGA_B <= "0011";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1101";
					VGA_B <= "0001";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1100";
					VGA_G <= "0001";
					VGA_B <= "0010";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= chad;
			else	
				next_flag <= mali;
			end if;
			
		when chad =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0000";
					VGA_G <= "0010";
					VGA_B <= "0110";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1100";
					VGA_B <= "0000";
				else
					-- Right third of the flag (Red)
					VGA_R <= "1100";
					VGA_G <= "0000";
					VGA_B <= "0011";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= nigeria;
			else	
				next_flag <= chad;
			end if;
			
		when nigeria =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "0000";
					VGA_G <= "1000";
					VGA_B <= "0101";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Right third of the flag (Red)
					VGA_R <= "0000";
					VGA_G <= "1000";
					VGA_B <= "0101";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= ivory;
			else	
				next_flag <= nigeria;
			end if;
			
		when ivory =>
			if pixel_en = '1' then
				-- Determine the color based on horizontal position (h_count)
				if count < 213 then
					-- Left third of the flag (Blue)
					VGA_R <= "1111";
					VGA_G <= "0111";
					VGA_B <= "0000";
				elsif count < 426 then
					-- Middle third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Right third of the flag (Red)
					VGA_R <= "0000";
					VGA_G <= "1001";
					VGA_B <= "0110";
				end if;
			else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');

			end if;
			if advance = '1' then
				 
				next_flag <= poland;
			else	
				next_flag <= ivory;
			end if;
			
		when poland =>
			if pixel_en = '1'then
				-- Determine the color based on vertical position (v_count)
				if line_count < 240 then
					-- Top third of the flag (White)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Bottom third of the flag (Red)
					VGA_R <= "1111"; 
					VGA_G <= "0000"; 
					VGA_B <= "0000";
				end if;
									
            else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');
            end if;

			if advance = '1' then
				 
				next_flag <= germany;
			else	
				next_flag <= poland;
			end if;
			
		when germany =>
			if pixel_en = '1'then
				-- Determine the color based on vertical position (v_count)
				if line_count < 160 then
					-- Top third of the flag (Black)
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "0000";
				elsif line_count < 320 then
					-- Middle third of the flag (Red)
					VGA_R <= "1111";
					VGA_G <= "0000";
					VGA_B <= "0000";
				else
					-- Bottom third of the flag (Yellow)
					VGA_R <= "1111"; 
					VGA_G <= "1100"; 
					VGA_B <= "0000";
				end if;
									
            else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');
            end if;

			if advance = '1' then
				 
				next_flag <= austria;
			else	
				next_flag <= germany;
			end if;
			
		when austria =>
			if pixel_en = '1'then
				-- Determine the color based on vertical position (v_count)
				if line_count < 160 then
					-- Top third of the flag (Black)
					VGA_R <= "1111";
					VGA_G <= "0000";
					VGA_B <= "0000";
				elsif line_count < 320 then
					-- Middle third of the flag (Red)
					VGA_R <= "1111";
					VGA_G <= "1111";
					VGA_B <= "1111";
				else
					-- Bottom third of the flag (Yellow)
					VGA_R <= "1111"; 
					VGA_G <= "0000"; 
					VGA_B <= "0000";
				end if;
									
            else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');
            end if;

			if advance = '1' then
				 
				next_flag <= congo;
			else	
				next_flag <= austria;
			end if;
			
		when congo =>
			if pixel_en = '1'then
				-- Determine the color based on vertical position (v_count)
				if count < 480 - line_count then
					-- Top third of the flag (Black)
					VGA_R <= "0000";
					VGA_G <= "1001";
					VGA_B <= "0100";
				elsif count < 640 - line_count then
					-- Middle third of the flag (Red)
					VGA_R <= "1111";
					VGA_G <= "1101";
					VGA_B <= "0100";
				else
					-- Bottom third of the flag (Yellow)
					VGA_R <= "1101"; 
					VGA_G <= "0010"; 
					VGA_B <= "0001";
				end if;
									
            else
				-- Black when not in active area
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');
            end if;
			if advance = '1' then
				 
				next_flag <= usa;
			else	
				next_flag <= congo;
			end if;

		when USA =>
			if pixel_en = '1' then
				-- Define the blue field for the stars (40% of width and 54% of height)
				if count < 256 and line_count < 259 then
					-- Blue field background
					VGA_R <= "0000";
					VGA_G <= "0000";
					VGA_B <= "1111";
					
					-- Star pattern within the blue field for 50 stars (5 rows of 6 stars, 4 rows of 5 stars)
					if ((line_count mod 26 < 10) and ((line_count / 26) mod 2 = 0 and (count mod 43 < 10))) or
						((line_count mod 26 < 10) and ((line_count / 26) mod 2 = 1 and ((count - 21) mod 43 < 10))) then
						-- Stars represented by white squares within the grid pattern
						VGA_R <= "1111";
						VGA_G <= "1111";
						VGA_B <= "1111";
					end if;
		
				else
					-- Draw stripes (13 stripes alternating red and white)
					if ((line_count / 37) mod 2 = 0) then
						-- Red stripe
						VGA_R <= "1111";
						VGA_G <= "0000";
						VGA_B <= "0000";
					else
						-- White stripe
						VGA_R <= "1111";
						VGA_G <= "1111";
						VGA_B <= "1111";
					end if;
				end if;
		
			else
				-- Black screen when not in the active region
				VGA_R <= (others => '0');
				VGA_G <= (others => '0');
				VGA_B <= (others => '0');
			end if;
		
			-- Transition to the next flag with the 'advance' button
			if advance = '1' then
				next_flag <= france;
			else
				next_flag <= USA;
			end if;
		
		when others => 
				 
				next_flag <= france;
		end case;
	end process;

end states;