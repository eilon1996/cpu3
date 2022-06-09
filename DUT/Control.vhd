LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity Control is

	generic(    numOfStatus: integer := 2;
                numOfStates: integer := 2;
                numOfControlsBits : integer := 4);
	port(
        clk: in std_logic;    --from tb
        status_vector: in std_logic_vector(numOfStatus-1 downto 0);
        control_vector: out std_logic_vector(numOfControlsBits-1 downto 0)
    );
end Control;

architecture arc_sys of Control is



constant Cout_const : std_logic_vector(numOfControlsBits-1 downto 0) := (0 => '1', others => '0');
constant Cin_const : std_logic_vector(numOfControlsBits-1 downto 0) := (1 => '1', others => '0');
constant PCsel_plus1_constant : std_logic_vector(numOfControlsBits-1 downto 0) := (2 => '1', 3 => '1', others => '0');

constant state0_const : std_logic_vector(numOfControlsBits-1 downto 0) := Cout_const or Cin_const;
constant state1_const : std_logic_vector(numOfControlsBits-1 downto 0) := Cout_const;

constant state0_num : integer := 0;
constant state1_num : integer := 1;

type std_logic_vector_array is array (numOfStates-1 downto 0) of std_logic_vector(numOfControlsBits-1 downto 0);

constant states : std_logic_vector_array := (
    state0_num => state0_const,
    state1_num => state1_const
    );

type integer_array is array (numOfStates-1 downto 0) of integer;
constant next_state : integer_array := (
    state0_num => state1_num,
    state1_num => state0_num
    );

signal control_vector_tmp : std_logic_vector(numOfControlsBits-1 downto 0);

BEGIN


process(clk)

    variable state : integer range 0 to numOfStates-1 := 0;

    begin
        if rising_edge(clk) then
            control_vector_tmp <= states(state);
            state := next_state(state);
        else
            control_vector_tmp <= control_vector_tmp;
            state := state;
        end if;

end process;

control_vector <= control_vector_tmp;

end arc_sys;
