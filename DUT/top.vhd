LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is

-----------logic-------
-- R type
-- 1 - insert ra to RF
-- 2 - insert Ra to A, rb to RF
-- 3 - insert Rb to B + calc with A, res enter C, insert rc to RF + enable writing
-- 4 - insert C to out (cout)

-- J type
--  insert A (offset)
--  insert B (PC), cin = 1, calc with A res enter C
--  get C out

-- I type
--  no action needed


variable state :integer :=0;
-- RF signals
signal readAddr, writeAddr:std_logic_vector(3 downto 0);
signal wrRFen, RFout:std_logic;
-- ALU signals
signal Cin, Ain, Cout, Cflag, Zflag, Nflag  :std_logic;
-- dataOut signals
signal IR :std_logic_vector(3 downto 0);
----

signal data_bus:std_logic_vector(n-1 downto 0);


alias OPC : std_logic_vector(3 downto 0) is IR(15 downto 12);
alias ra : std_logic_vector(3 downto 0) is IR(11 downto 8);
alias rb : std_logic_vector(3 downto 0) is IR(7 downto 4);
alias rc : std_logic_vector(3 downto 0) is IR(3 downto 0);

--subtype opc_type is  std_logic_vector(1 downto 0);
alias OPC_type : std_logic_vector(1 downto 0) is OPC(3 downto 2);
constant R_type   : std_logic_vector(1 downto 0) := "00";
constant J_type   : std_logic_vector(1 downto 0) := "01";
constant I_type   : std_logic_vector(1 downto 0) := "10";

BEGIN
-------- handle register file -----
--TODO: add componnent

RF_pm: RF port map(
	clk => clk,
	rst => rst,
	WregEn => WregEn,

	WregData => WregData,
	WregData => WregData,
	RregAddr => RregAddr,
	RregData => RregData
);



ALU_pm: ALU port map(
	clk => clk,
	rst => rst,
	Ain => Ain,
	Cin => Cin,
	Cout => Cout,
	OPC => OPC,

	data_bus => data_bus,	-- maybe change to A and B
	Cflag => Cflag,
	Nflag => Nflag,
	Zflag => Zflag
);

--TODO: similar to below but with out the clock
PROCESS (x, rst, clk, ena)

	BEGIN
	IF (ena = '1')	THEN			-- if enable bit is on than save the current state
	--
	ELSIF (rst = '1')	THEN			-- if enable bit is on than save the current state
	--
	ELSIF (rising_edge(clk)) THEN
		IF(OPC_type=R_type) THEN
			IF(state=0) THEN
				--insert dataOut to IR
			ELSIF(state=1) THEN
				readAddr <= ra;
				RFout <= '1';
				Ain <= '0';
				Cout <= '0';
				wrRFen <= '0';
			ELSIF(state=2) THEN
				readAddr <= rb;
				RFout <= '1';
				Ain <= '1';
				Cin <= '0';
				Cout <= '0';
				wrRFen <= '0';
			ELSIF(state=3) THEN
				readAddr <= rc;
				RFout <= '1';
				Ain <= '0';
				Cin <= '1';
				Cout <= '0';
			ELSIF(state=4) THEN
				RFout <= '0';
				Ain <= '0';
				Cin <= '0';
				Cout <= '1';
				wrRFen <= '1';
			END IF;

		ELSIF(OPC_type=J_type) THEN
		--
		ELSIF(OPC_type=I_type) THEN
		--
		END IF;
	END IF;

END arc_sys;







