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


--variable state :integer :=0;
-- RF signals
signal readAddr, writeAddr:std_logic_vector(3 downto 0);
signal wrRFen, RFout:std_logic;
-- ALU signals
signal Cin, Ain, Cout, Cflag, Zflag, Nflag  :std_logic;
-- dataOut signals
signal IR :std_logic_vector(3 downto 0);
signal PCin, PCout :std_logic;
----

signal data_bus:std_logic_vector(n-1 downto 0);



BEGIN
-------- handle register file -----
--TODO: add componnent


END arc_sys;







