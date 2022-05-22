library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--USE work.aux_package.all;


use ieee.std_logic_textio.all;
library std;
use std.textio.all;
entity tb_2 is

	generic(
	   Dwidth: integer := 16;
	   Awidth: integer := 6;
	   dept:   integer := 64;
	   regAddrWidth:   integer := 4
	  );
  end tb_2;

architecture xxxx of tb_2 is

	SIGNAL clk, rst, ena  : std_logic;                                                                  -- basic control

	SIGNAL TBactive, RF_writeEn_from_TB, PM_writeEn_from_TB: std_logic;                                  -- TB controls enable
	SIGNAL PM_dataIn_TB : std_logic_vector(Dwidth-1 downto 0);                                          -- TB controls data
	SIGNAL RF_write_address_from_TB, RF_read_address_from_TB: std_logic_vector(regAddrWidth-1 downto 0);
	SIGNAL PM_write_Addr_TB : std_logic_vector(Awidth-1 downto 0);  -- TB controls address
	SIGNAL done : std_logic;


begin

p: process
	file RAMinit : text open read_mode is "D:\Users\barryyos\Documents\CPU_Labs\cpu3\TB\RAMinit.txt";
	file output : text open write_mode is "D:\Users\barryyos\Documents\CPU_Labs\cpu3\TB\output.txt";
	variable L : line;
	variable PM_dataIn_TB : std_logic_vector(Dwidth-1 downto 0);

	begin

		while not endfile(RAMinit) loop
			
			readline(RAMinit, L);
			hread(L, PM_dataIn_TB);	-- read hexa
			report "report read" severity note;

			hwrite(L, PM_dataIn_TB);
			writeline(output, L);
			report "report write" severity note;
	  end loop;

  file_close(RAMinit);
  file_close(output);
  wait;
  end process; 

end xxxx;




