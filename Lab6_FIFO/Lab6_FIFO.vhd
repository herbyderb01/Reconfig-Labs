library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab6_FIFO is
	port (
		ADC_CLK_10 : in std_logic;
		MAX10_CLK1_50 : in std_logic;
		MAX10_CLK2_50 : in std_logic;
		
		KEY : in std_logic_vector(1 downto 0);
		SW : in std_logic_vector(9 downto 0);
		
		HEX0 : out std_logic_vector(7 downto 0);
		HEX1 : out std_logic_vector(7 downto 0);
		HEX2 : out std_logic_vector(7 downto 0);
		HEX3 : out std_logic_vector(7 downto 0);
		HEX4 : out std_logic_vector(7 downto 0);
		HEX5 : out std_logic_vector(7 downto 0);
		
		LEDR : out std_logic_vector(9 downto 0)
	);
end Lab6_FIFO;

architecture component_list of Lab6_FIFO is

	component fifo is
		port (
			aclr		: IN STD_LOGIC  := '0';
			data		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			rdclk		: IN STD_LOGIC ;
			rdreq		: IN STD_LOGIC ;
			wrclk		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			rdusedw		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			wrusedw		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)	
			);
	end component fifo;

	component PLL is
		port (
			inclk0		: IN STD_LOGIC  := '0';
			c0		: OUT STD_LOGIC ;
			c1		: OUT STD_LOGIC 
		);
	end component PLL;
		
	component write_fsm is
		port (
			clk : in std_logic;
			btn : in std_logic;
			full : in std_logic;
			MT : in std_logic;
			wr_en : out std_logic
		);
	end component write_fsm;

	component read_fsm is
		port (
			clk  : in std_logic;
			full : in std_logic;
			MT   : in std_logic;
			rd   : out std_logic;
			en   : out std_logic;
			clr  : out std_logic
			);
	end component read_fsm;
	
	component debouncer
		port (
			clk : in std_logic;
			btn : in std_logic;
			output : out std_logic
		);
	end component debouncer;
	
	component HEX_seven_seg_disp_6
		port (
			IN0 : in std_logic_vector(3 downto 0);
			IN1 : in std_logic_vector(3 downto 0);
			IN2 : in std_logic_vector(3 downto 0);
			IN3 : in std_logic_vector(3 downto 0);
			IN4 : in std_logic_vector(3 downto 0);
			IN5 : in std_logic_vector(3 downto 0);
			clk : in  std_logic;
			HEX0 : out std_logic_vector(7 downto 0);
			HEX1 : out std_logic_vector(7 downto 0);
			HEX2 : out std_logic_vector(7 downto 0);
			HEX3 : out std_logic_vector(7 downto 0);
			HEX4 : out std_logic_vector(7 downto 0);
			HEX5 : out std_logic_vector(7 downto 0)
		);
	end component HEX_seven_seg_disp_6;
	
	component accumulator
		generic (
			N : integer := 10;
			M : integer := 10
		);
			port (
			en : in std_logic;
			rst : in std_logic;
			clk : in std_logic;
			input : in std_logic_vector(N-1 downto 0);
			sum : out std_logic_vector(M-1 downto 0)
		);
	end component accumulator;
	
	signal rst : std_logic;
	signal sum : std_logic_vector(23 downto 0);

	signal key0_l : std_logic;
	signal key1_l : std_logic;

	signal pressed : std_logic;
	
	signal wr_clk : std_logic;
	signal rd_clk : std_logic;

	signal full : std_logic;
	signal MT : std_logic;

	signal q_sig : std_logic_vector(9 downto 0);

	signal en : std_logic;
	signal rd_en : std_logic;
	signal wr_en : std_logic;

	signal counter : integer;

	signal rdusedw_sig : std_logic_vector(2 downto 0);
	signal wrusedw_sig : std_logic_vector(2 downto 0);

	signal aclr_sig : std_logic;
	
begin

	fifo_inst : fifo 
		port map (
			aclr	 => aclr_sig,
			data	 => SW,
			rdclk	 => rd_clk,
			rdreq	 => rd_en,
			wrclk	 => wr_clk,
			wrreq	 => wr_en,
			q	 => q_sig,
			rdusedw	 => rdusedw_sig,
			wrusedw	 => wrusedw_sig
			);

	PLL1 : PLL
		port map (
			inclk0 => MAX10_CLK2_50,
			c0 => rd_clk, --12.5 MHZ
			c1 => wr_clk -- 5 MHz
		);
	
	fsm1 : write_fsm 
		port map (
			clk => wr_clk,
			btn => pressed,
			full => full,
			MT => MT,
			wr_en => wr_en
		);

	fsm2 : read_fsm 
		port map (
			clk => rd_clk,
			full => full,
			MT => MT,
			rd => rd_en,
			en => en,
			clr => aclr_sig
		);

	accumulator1 : accumulator
		generic map (
			N => 10,
			M => 24
		)
		port map (
			clk => rd_clk,
			en => en,
			rst => rst,
			input => q_sig,
			sum => sum
		);

	display : HEX_seven_seg_disp_6
		port map (
			clk => rd_clk,
			IN0 => sum(3 downto 0),
			IN1 => sum(7 downto 4), 
			IN2 => sum(11 downto 8),
			IN3 => sum(15 downto 12),
			IN4 => sum(19 downto 16),
			IN5 => sum(23 downto 20),
			HEX0 => HEX0,
			HEX1 => HEX1,
			HEX2 => HEX2,
			HEX3 => HEX3,
			HEX4 => HEX4,
			HEX5 => HEX5
		);
	
	rst_btn : debouncer
		port map (
			clk => rd_clk,
			btn => key0_l,
			output => rst
		);
		
	en_btn : debouncer
		port map (
			clk => wr_clk,
			btn => key1_l,
			output => pressed
		);
		
	LEDR <= SW;

	key0_l <= not KEY(0); 
	key1_l <= not KEY(1); 

	full <= '1' when (wrusedw_sig = "101") else '0';
	MT <= '1' when (wrusedw_sig = "000") else '0';
	
end component_list;