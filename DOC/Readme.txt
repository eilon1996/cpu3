lab2 - VHDL
Barry Yosilevich - 208725218
Eilon Toledano - 206903445

.vhd file functional description:


Adder.vhd:
- Implements an n-bit adder with carry:
- ports functional description:
 	+ a, b: binary vectors of length n - representing numbers to be summerized or substructed ( x-y operation)
	+ cin: carry in to take in calculation
 	+ cout: carry out
 	+ s: the addition result



aux_package.vhd:
- gathers entire system's components in on package.


top.vhd:
- descripts a synchronous digital system which detects valid sub series for a given condition value (noted at the task pdf file), consists of three concurrent proccesses (acting as a pipeline):
  1st process:  given an input series x, it outputs 2 serieses which demonstrate a -2, and -1 delay of the input series.
	- sensitive list:
		+ x: input series
		+ rst: reset line
		+ clk: clock line
		+ ena: enable line
  2nd process:  given 2 input series (from process 1), calculates the substraction result between the two serieses (element-wise) and outputs '1' whether the substraction result matches the detection code, else '0'.
	- sensitive list:
		+ rst: reset line
		+ clk: clock line
		+ ena: enable line
		+ valid:  validity of the substraction results
  3rd process: counts input valid bits in a row (from process 2), outputs '1' if there are more than m bits in a row at a given time, '0' else.
	- sensitive list:
		+ rst: reset line
		+ clk: clock line
		+ ena: enable line
		+ valid:  validity of the substraction results

- port functional description:
	+ rst, ena, clk: system control lines
	+ x: input binary vector to manipulate on.
	+ DetectionCode: process 2 input detection code - to compare with substraction result.
	+ detector: system output - holds whether there's a valid (by defined means) sub-series of x.
