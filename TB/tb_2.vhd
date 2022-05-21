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

architecture tb_rtl of tb_2 is


begin


p: process
begin
end process;

end tb_rtl;