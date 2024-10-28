library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
	generic (
		N : integer := 10;
		M : integer := 24
	);

	port (
		clk : in std_logic;
		en : in std_logic;
		rst : in std_logic;
		input : in std_logic_vector(N-1 downto 0);
		sum : out std_logic_vector(M-1 downto 0)
	);
end entity accumulator;

architecture behavior of accumulator is
	signal count : unsigned ((M-1) downto 0) := (others => '0');
	signal in_num : unsigned ((N-1) downto 0);
begin
	
	proc1: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				count <= (others => '0');
			elsif en = '1' then
				count <= in_num + count;
			end if;
		end if;
	end process proc1;

	in_num <= unsigned(input);
	sum <= std_logic_vector(count);

end architecture behavior;