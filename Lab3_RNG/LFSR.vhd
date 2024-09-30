library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LFSR is
    generic (
        M : integer := 12  -- LFSR bit width
    );
    port (
        clk     	: in  std_logic;
		input		: in std_logic;
        rst     	: in  std_logic;
        enable  	: in  std_logic;
        lfsr_out	: out std_logic_vector(M-1 downto 0)
    );
end entity LFSR;

architecture behavioral of LFSR is
    signal lfsr : std_logic_vector(M-1 downto 0) := x"9AC";
begin	
    process (clk, rst)
    begin
        if rst = '0' then
            lfsr <= x"9AC";  -- Initial non-zero start state
        elsif rising_edge(clk) then
            if enable = '0' then
                lfsr(M-1 downto 1) <= lfsr(M-2 downto 0);  -- Shift the register
				lfsr(0) <= input;
            end if;
        end if;
    end process;

    lfsr_out <= lfsr;
end architecture behavioral;
