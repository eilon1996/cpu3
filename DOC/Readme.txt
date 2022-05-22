lab3 - VHDL
Barry Yosilevich - 208725218
Eilon Toledano - 206903445

.vhd file functional description:


top.vhd:
- Implements a central proccesing unit:
- ports functional description:
 	+ clk, rst, ena: control lines for the unit
	+ PM_write_Addr_TB, RF_write_address_from_TB, RF_read_address_from_TB ,PM_dataIn_TB, TBactive, RF_writeEn_from_TB, PM_writeEn_from_TB: activating/ disactivating test bench content muxing.
	+ done: TB finish flag

RF.vhd:
- Implements register file architecture:
- ports functional description:
	+ clk, rst, RF_writeEn: control lines for the unit
	+ RF_write_data: Register file content to be written.
	+ RF_write_address,RF_read_address: read & write adresses from program memory.
	+ RF_read_data: data read from program memory.

ProgMem.vhd:
- Implements program memory architecture:
- ports functional description:
	+ clk,PM_writeEn: control lines for the unit
	+ PM_dataIn: holds data to insert into program memory at a given time.
	+ PM_writeAddr, PM_readAddr: PM adresses to read/ write from/to at a given time.
	+ PM_readData: data read from the program memory.

PC.vhd:
- Implements program counter register:
- port functional description:
	+ clk: syncrhnization & unit control.
	+ PCin: Enable PC write.
	+ PCsel: PC input source select.
	+ offset: PC offset value.
	+ PC_out: holds PC value.

Datapath.vhd:
- Implements te data path of the CPU:
- port functional description:
	+ clk, rst, ena: control lines for the unit - received fom Control unit.
	+ Cout, Cin, Ain, RF_writeEn_control, RFout, IRin, PCin, Imm_in, done: functionality control lines - received from Control unit.
	+ TBactive,RF_writeEn_from_TB, PM_writeEn_from_TB: activating/ disactivating test bench content muxing.
	+ PM_dataIn_TB: holds the data to write into program memory from test bench.
	+ PM_write_Addr_TB: holds write-to address into the program memory from test bench.
	+ RF_write_address_from_TB, RF_read_address_from_TB: holds write/ read-to address into the register file from test bench.
	+ OPC_out, mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag: Assembly commands and flags generate to the control unit.

Control.vhd:
- Implements control unit architecture:
- port functional description:
	+  rst, ena, clk: control lines for the unit.
	+ done: Indicates whether writing/ reading has been completed.
	+ mov, done_code, nop, jnc, jc, jmp, sub, add, Nflag, Zflag, Cflag: assembly commands & flags to perform - received from datapath.
	+  PCsel, RFaddr, Cout, Cin, Ain, RF_writeEn_control, RFout, IRin, PCin, Imm_in : datapath functionality controls outputted to the datapath.
	+ OPC_in: OPC decoded from datapath.
	+ OPC OPC sent to datapath.

aux_package.vhd:
- General package containing component definitions.

ALU.vhd:
- implement arithemetic logical unit:
- port functional description:
	+ OPC: literally.
	+ a, b: operation opearands.
	+ c: operation result.
	+ Cflag, Zflag, Nflag: result flags.

AdderSub.vhd:
- impelements adder/ substructor unit:
- port functional description:
	+ a, b: operands.
	+ sub, carry_in: substraction enable, carry_in if there is.
	+ carry_out, result: literally.
