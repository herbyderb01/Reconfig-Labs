library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic (
		n : integer := 4;
		div : integer := 4
	);
	
	port (
		clk : in std_logic;
		rst_l : in std_logic;
		output : out std_logic_vector((n-1) downto 0)
	);
end;
architecture simple of counter is
begin
	process(clk, rst_l)
		variable count : unsigned ((n-1) downto 0);
		variable dly : integer;
	begin
		if rst_l = '0' then
			count := (others => '0');
			dly := 0;
		elsif rising_edge(clk) then
			if dly = (div-1) then
				dly := 0;
				count := count + 1;
			else
				dly := dly + 1;
			end if;
		end if;
		
		
	end process;
	
	output <= std_logic_vector(count);
end;
	