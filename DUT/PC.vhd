LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity PC is
  GENERIC (OPC_length : INTEGER := 4;
            Dwidth: INTEGER := 16;
            Awidth: INTEGER := 6);
    port(	clk, PCin: in std_logic;
            PCsel:	in std_logic_vector(1 downto 0);
            offset:	in std_logic_vector(4 downto 0);
            PC_out :out std_logic_vector(Awidth-1 downto 0)
        );
end PC;
------------- complete the ALU Architecture code --------------
architecture PC_rtl of PC is

signal PC_buffer, PC_value_plus1, PC_value_plus_offset: std_logic_vector(Awidth-1 downto 0);
signal offset_extend : std_logic_vector(Awidth-1 downto 0);

begin

offset_extend(4 downto 0) <= offset;
offset_extend(Awidth - 1 downto 5) <= (others => offset(4));

plus1_pm: AdderSub
generic map(
    Dwidth=>Awidth
)
port map(
    sub => '0',
    carry_in => '1',
    a => PC_buffer,
    b => (others => '0'),
    result => PC_value_plus1
);

plus_offset_pm: AdderSub
generic map(
    Dwidth=>Awidth
)
port map(
    sub => '0',
    carry_in => '0',
    a => PC_buffer,
    b => offset_extend,
    result => PC_value_plus_offset
);

PC_process: process (clk)
begin
    if (rising_edge(clk)) then

        case PCsel is
        when "00" => PC_buffer <= (others => '0');
        when "01" => PC_buffer <= PC_value_plus_offset;
        when "10" => PC_buffer <= PC_value_plus1;
        when others => PC_out <= PC_buffer;
      end case;

    end if;
end process;

PC_out <= PC_buffer;

end PC_rtl;