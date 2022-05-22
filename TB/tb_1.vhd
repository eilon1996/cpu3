library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;


use ieee.std_logic_textio.all;
library std;
use std.textio.all;
entity tb_1 is

	generic(
	   Dwidth: integer := 16;
	   Awidth: integer := 6;
	   dept:   integer := 64;
	   regAddrWidth:   integer := 4
	  );
  end tb_1;

architecture xxxx of tb_1 is

	SIGNAL clk : std_logic := '0';
	SIGNAL ena, rst : std_logic;                                                         -- basic control

	SIGNAL TBactive, RF_writeEn_from_TB, PM_writeEn_from_TB: std_logic;                                  -- TB controls enable
	SIGNAL PM_dataIn_TB, RF_write_data_from_TB : std_logic_vector(Dwidth-1 downto 0);                                          -- TB controls data
	SIGNAL RF_write_address_from_TB, RF_read_address_from_TB: std_logic_vector(regAddrWidth-1 downto 0);
	SIGNAL PM_write_Addr_TB : std_logic_vector(Awidth-1 downto 0);  -- TB controls address

	SIGNAL RF_read_data_TB : std_logic_vector(Dwidth-1 downto 0) ;
	SIGNAL done : std_logic;


begin


top_PM: top

    generic map (Awidth => Awidth, Dwidth => Dwidth, dept=>dept, regAddrWidth=>regAddrWidth)

    port map(
                 clk                         => clk          ,
                 rst                         => rst          ,
                 ena                         => ena          ,
                 TBactive                    => TBactive                     ,
                 RF_writeEn_from_TB          => RF_writeEn_from_TB           ,
                 PM_writeEn_from_TB          => PM_writeEn_from_TB           ,
                 PM_dataIn_TB                => PM_dataIn_TB                 ,
                 RF_write_address_from_TB    => RF_write_address_from_TB     ,
                 RF_read_address_from_TB     => RF_read_address_from_TB      ,
                 PM_write_Addr_TB            => PM_write_Addr_TB,
                 RF_write_data_from_TB       => RF_write_data_from_TB
     );


gen: process
  variable clk_delay:time := 5 ns;
  begin
  clk <= not clk; wait for clk_delay;
end process;

init: process
	file RAMinit : text open read_mode is "D:\Users\barryyos\Documents\CPU_Labs\cpu3\TB\RAMinit.txt";
	file RFinit : text open read_mode is "D:\Users\barryyos\Documents\CPU_Labs\cpu3\TB\RFinit.txt";
	variable L : line;

	variable RF_write_data_from_TB_var, PM_dataIn_TB_var : std_logic_vector(Dwidth-1 downto 0) ;

	begin
	TBactive <= '1';
	rst <= '0';
	ena <= '0';
	-- init PM

	PM_writeEn_from_TB <= '1';
    PM_write_Addr_TB <= (others => '0');
	while not endfile(RAMinit) loop
		readline(RAMinit, L);

		wait until (clk='1');
		hread(L, PM_dataIn_TB_var);	-- read hexa,  take a single cycle
		PM_dataIn_TB <= PM_dataIn_TB_var;
		wait until (clk='0');
		PM_write_Addr_TB <= PM_write_Addr_TB + 1;
		report "report read" severity note;

	end loop;
	PM_writeEn_from_TB <= '0';
    PM_write_Addr_TB <= (others => '0');
	file_close(RAMinit);

	-- init RF
	RF_writeEn_from_TB <='1';
    RF_write_address_from_TB <= (others => '0');
	while not endfile(RFinit) loop
		readline(RFinit, L);

		wait until (clk='1');
		hread(L, RF_write_data_from_TB_var);	-- read hexa,  take a single cycle
		RF_write_data_from_TB <= RF_write_data_from_TB_var;
		wait until (clk='0');
		RF_write_address_from_TB <= RF_write_address_from_TB + 1;
		report "report read" severity note;

	end loop;
	RF_writeEn_from_TB <='0';
  RF_write_address_from_TB <= (others => '0');


  -- finish init

	wait until (clk='0');
	TBactive <= '0';
	ena <= '1';
	wait until (clk='0');
	rst <= '1';
	wait until (clk='0');
	rst <= '0';

  -- run program

  wait until (done='1');

  wait;
  end process;

end xxxx;




