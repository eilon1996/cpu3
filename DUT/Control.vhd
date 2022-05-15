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
        rst, ena, clk: in std_logic;    --from tb
        done: out std_logic;            --to tb
		mov, done, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag : in std_logic;  --status
		Cout, Cin, Ain, wrRFen, RDout, IRin, PCin, Imm_in : out std_logic;    --control
        PCsel, RFaddr: out std_logic_vector(1 downto 0);                                    --control
        OPC: out std_logic_vector(3 downto 0);                                       --control
    );
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is

-----------logic-------
-- TODO handle get instraction and update PC

-- R type
-- 1 - insert ra to RF
-- 2 - insert Ra to A, rb to RF
-- 3 - insert Rb to B + calc with A, res enter C, insert rc to RF + enable writing
-- 4 - insert C to out (cout)

-- Jmp
-- 1 - pc = pc+offset
-- 2 - done

-- Jc/jnc
-- 1 - if(carry/notcarry) pc = pc+offset
-- 2 - done

-- I type
-- 1 - insert ra to RF, immidiet + sign extention,
-- 2


variable state :integer :=0;
signal opc_type : std_logic_vector(1 downto 0);


--subtype opc_type is  std_logic_vector(1 downto 0);
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


FSM_PROC : process(clk)
begin
    if rst = '1' then
        state <= IDLE;

    elsif ena = '0' then
        state <= IDLE;

    elsif rising_edge(clk) then
        case state is

            when 1 =>
            case opc_type is

                when R_type =>
                    readAddr <= ra;
                    RFout <= '1';
                    Ain <= '0';
                    Cout <= '0';
                    wrRFen <= '0';
                when 1 =>
                when 1 =>
                when 1 =>


            end case;

        end if;
    end if;
end process;





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
				pc <= pc+1;
			END IF;

		ELSIF(OPC_type=J_type) THEN
			IF(OPC(1 downto 0)="00" or (OPC(1 downto 0)="01" and Cflag='1') or (OPC(1 downto 0)="10" and Cflag='0')) THEN
				IF(state=0) THEN
					--insert dataOut to IR
				ELSIF(state=1) THEN
					-- insert PC to A
					PCout <= '1';
					Ain <= '1';
					Cout <= '0';
				ELSIF(state=2) THEN

	-- 2 - insert offset to B + carry_in = 1 + calc with A res enter C
					dataBus(4 downto 0) <= offsetAddress; -- add sign extention
					Ain <= '0';
					Cin <= '1';
					carry_in <= '1';
					Cout <= '0';
				ELSIF(state=3) THEN
				-- 3 - get C out
					Ain <= '0';
					Cin <= '0';
					Cout <= '1';
					PCin <= '1';
				END IF;
			ELSIF
				PC <= PC+1; --impliment
			END IF;

		ELSIF(OPC_type=I_type) THEN

			IF(state=0) THEN
				--insert dataOut to IR
			ELSIF(state=1) THEN
				readAddr <= ra;
				RFout <= '1';
				Ain <= '0';
				Cout <= '0';
				wrRFen <= '1';
				dataBus(7 downto 0) <= immidiet; -- add sign extention
				pc <= pc+1;
			END IF;

		END IF;
	END IF;
