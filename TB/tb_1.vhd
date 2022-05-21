library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;


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

	top_PM: top

	generic map (Awidth => Awidth, Dwidth => Dwidth, dept=>dept, regAddrWidth=>regAddrWidth)

	port map(
					clk 						=> clk			,
					rst 						=> rst			,
					ena 						=> ena			,
					TBactive					=> TBactive						,
					RF_writeEn_from_TB			=> RF_writeEn_from_TB			,
					PM_writeEn_from_TB     		=> PM_writeEn_from_TB     		,
					PM_dataIn_TB				=> PM_dataIn_TB					,
					RF_write_address_from_TB	=> RF_write_address_from_TB		,
					RF_read_address_from_TB		=> RF_read_address_from_TB		,
					PM_write_Addr_TB			=> PM_write_Addr_TB
		);

p: process
	file RAMinit : text open read_mode is "C:\Users\eilon.toledano\Desktop\study\CPU\labs\LAB3\TB\RAMinit.txt";
	file output : text open write_mode is "C:\Users\eilon.toledano\Desktop\study\CPU\labs\LAB3\TB\output.txt";
	variable L : line;
	variable PM_dataIn_TB : std_logic_vector(3 downto 0);

	begin

		while not endfile(RAMinit) loop
			readline(RAMinit, L);
			hread(L, PM_dataIn_TB);	-- read hexa
			report "report read" severity note;

			write(L, to_bitvector(PM_dataIn_TB), left, 10);
			writeline(output, L);
			report "report write" severity note;
		end loop;

end process;

end xxxx;




-- 	file RAMinit 	: text open read_mode is "RAMinit.txt";
-- 	file RFcontent 	: text open read_mode is "RFcontent.txt";
-- 	file RFinit 	: text open read_mode is "RFinit.txt";
-- 	file output 	: text open write_mode is "output.txt";

-- 	Variable RAMinit_L	:	std_logic_vector(Dwidth-1 downto 0);
-- 	Variable RFcontent_L:	std_logic_vector(Dwidth-1 downto 0);
-- 	Variable RFinit_L 	:	std_logic_vector(Dwidth-1 downto 0);
-- 	Variable output_L 	:	std_logic_vector(Dwidth-1 downto 0);
-- 	Variable PM_dataIn_TB_bits : bit_vector(Dwidth-1 downto 0);
-- 	Variable PM_dataIn_TB_bits2 : string(0 to Dwidth-1);

-- 	variable L : line;
-- 	variable good : boolean;
-- 	variable clk_delay: time := 50 ns;

-- 	function to_std_logic_vector(a : string) return std_logic_vector is
-- 		variable ret : std_logic_vector(a'length*8-1 downto 0);
-- 	begin
-- 		for i in a'range loop
-- 			ret(i*8+7 downto i*8) := std_logic_vector(to_unsigned(character'pos(a(i)), 8));
-- 		end loop;
-- 		return ret;
-- 	end function to_std_logic_vector;

-- 	begin
-- 	--------- start of stimulus section ------------------
-- 	TBactive <= '1';
-- 	ena <= '0';
-- 	clk <= '0';


-- 	PM_writeEn_from_TB <= '1';
-- 	PM_write_Addr_TB <= (others => '0');
-- 	RAMinit_L := (others => '0');
-- 	while not endfile(RAMinit) loop
-- 		readline(RAMinit, L);
-- 		read(L, PM_dataIn_TB_bits2, good);
-- 		next when not good;
-- 		PM_dataIn_TB	<= RAMinit_L;
-- 		PM_write_Addr_TB <= to_std_logic_vector(PM_dataIn_TB_bits2) + 1;
-- 		clk <= '1';
-- 		wait for (clk_delay);
-- 		clk <= '0';
-- 		wait for (clk_delay);

-- 		assert false
-- 			report PM_dataIn_TB_bits2
-- 			severity Note;
-- 	end loop;
-- 	end process;
-- end architecture rtb;
