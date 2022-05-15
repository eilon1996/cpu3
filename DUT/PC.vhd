LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity PC is
  GENERIC (OPC_length : INTEGER := 4;
            Dwidth: INTEGER := 16);
    port(	clk, PCin: in std_logic;
            PCsel:	in std_logic_vector(1 downto 0);
            offset:	in std_logic_vector(4 downto 0);
            PC_out :out std_logic_vector(Dwidth-1 downto 0)
        );
end PC;
------------- complete the ALU Architecture code --------------
architecture PC_rtl of PC is

signal PC_value, PC_value_plus1, PC_value_plus_offset: std_logic_vector(Dwidth-1 downto 0);

begin

plus1_pm: AdderSub port map(
    sub => '0',
    carry_in => '1',
    a => PC_out,
    b => (others => '0'),
    result => PC_value_plus1
);

plus_offset_pm: AdderSub port map(
    sub => '0',
    carry_in => '0',
    a => PC_value_plus1,
    b => offset,
    result => PC_value_plus_offset
);

WITH PCsel SELECT
PC_out    <=  (others => 0)        when "00",
                PC_value_plus_offset when "01",
                PC_value_plus1       when "10",
                UNAFFECTED when others ;


PC_out <= PC_value;

end PC_rtl;