library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_fsm is
	port (
		clk : in std_logic;
		btn : in std_logic;
		full : in std_logic;
		MT : in std_logic;
		wr_en : out std_logic
	);
end write_fsm;

architecture states of write_fsm is
	type state_type is (waiting, num1, num2, num3, num4, num5);
	signal current_state, next_state : state_type;
begin

	process(clk) begin
		if rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process

	process (current_state, btn, full, MT)
	begin
		case current_state is
			when waiting =>
				wr_en <= '0';
				if btn = '1' and full = '0' then
					wr_en <= '1';
					next_state <= num1;
				else
					wr_en <= '0';
					next_state <= waiting;
				end if;
				
			when num1 =>
				wr_en <= '0';
				if btn = '1' and full = '0' then
					wr_en <= '1';
					next_state <= num2;
				else
					wr_en <= '0';
					next_state <= num1;
				end if;
			
			when num2 =>
				wr_en <= '0';
				if btn = '1' and full = '0' then
					wr_en <= '1';
					next_state <= num3;
				else
					wr_en <= '0';
					next_state <= num2;
				end if;
			
			when num3 =>
				wr_en <= '0';
				if btn = '1' and full = '0' then
					wr_en <= '1';
					next_state <= num4;
				else
					wr_en <= '0';
					next_state <= num3;
				end if;	
				
			when num4 =>
				wr_en <= '0';
				if btn = '1' and full = '0' then
					wr_en <= '1';
					next_state <= num5;
				else
					wr_en <= '0';
					next_state <= num4;
				end if;
				
			when num5 =>
				wr_en <= '0';
				if MT = '1' then
					next_state <= waiting;
				else
					wr_en <= '0';
					next_state <= num5;
				end if;
	
	end process
end states