library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity read_fsm is
    port (
        clk  : in std_logic;
        full : in std_logic;
        MT   : in std_logic;
        rd   : out std_logic;
        en   : out std_logic;
        clr  : out std_logic
    );
end read_fsm;

architecture states of read_fsm is
    type state_type is (idle, reading_fifo, T1, T2);
    signal current_state, next_state : state_type;
begin

    -- State Transition Process
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic and Output Process
    process(current_state, full, MT)
    begin
        case current_state is
            when idle =>
                rd <= '0';
                en <= '0';
                clr <= '0';
                if full = '1' then
                    rd <= '1';
                    en <= '1';
                    next_state <= reading_fifo;
                else
                    next_state <= idle;
                end if;

            when T1 =>
                rd <= '0';
                en <= '0';
                clr <= '0';
                next_state <= T2;
            when T2 =>
                rd <= '0';
                en <= '0';
                clr <= '0';
                next_state <= reading_fifo;

            when reading_fifo =>
                rd <= '1';
                en <= '1';
                clr <= '0';
                if MT = '1' then
                    rd <= '0';
                    en <= '0';
                    clr <= '1';
                    next_state <= idle;
                else
                    next_state <= reading_fifo;
                end if;

            when others =>
                next_state <= idle;  -- default to idle
        end case;
    end process;
end states;
