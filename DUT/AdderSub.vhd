LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY AdderSub IS
GENERIC (
      Dwidth : INTEGER := 16);
  PORT ( a, b: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
          sub, carry_in: IN STD_LOGIC;
          result: OUT STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
         carry_out: OUT STD_LOGIC);
END AdderSub;
------------------------------------------------
ARCHITECTURE rtl OF AdderSub IS
  signal carry : STD_LOGIC_VECTOR (Dwidth DOWNTO 0);
  signal b_sub : STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);

BEGIN
    -- if sub and carry_in == 1 assert
    carry(0) <= sub or carry_in;
    loop1 : for i in 0 to Dwidth-1 generate
      b_sub(i) <= b(i) xor sub;
    end generate;


    loop2 : for i in 0 to Dwidth-1 generate
      result(i) <= b_sub(i) XOR a(i) XOR carry(i);
      carry(i+1) <= (b_sub(i) AND a(i)) OR (b_sub(i) AND carry(i)) OR (a(i) AND carry(i));
    end generate;
    carry_out <= carry(Dwidth);
END rtl;
