
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	 'iTotal'  = 20u

V1		VDD  		0		DC		supply
V2		VDD2  	0		DC		supply
vinA 	high	0	PWL(0ns 0			1ns		0			1.001ns	supply )
vinB 	in		0	PWL(0ns supply	1ns		supply	1.001ns	0  2ns 0 2.001ns supply)

.subckt inverter in out VDD GND 
MP1	VDD	in	out	VDD pmos	L = 90n  W = 'widthPmos'	
MN2	GND	in	out	GND nmos	L = 90n  W = 200n		
.ends inverter

.SUBCKT inv a out VDD GND
MP1 out a VDD VDD pmos L = 90n W = 'widthPmos'
MN2 out a GND GND nmos L = 90n W = 1*200n
.ENDS inv


Xdut	in		out	VDD	GND	inv
iS	Xdut.vdd	Xdut.out	0	exp	(0	'iTotal'	2.5n	2p	2.5015n	4p)

Xinv0	out	void	VDD	GND	inverter
Xinv1	out	void	VDD	GND	inverter
Xinv2	out	void	VDD	GND	inverter
Xinv3	out	void	VDD	GND	inverter
.measure	tran	Vpeak	min	v(Xdut.out)	 from = 1.5ns to = 3ns

.model	optmod	opt	itropt = 40
.optimize	opt2	model=optmod	analysisname=tran
.optgoal	opt2	cargaTotal = 7f
.paramlimits opt2 'iTotal' minval=20u maxval=5m

.measure tran avgiS			avg i(iS) from = 2ns to = 3ns
.measure tran cargaTotal	param = 'avgiS * 1n'
.print v(out)v(in)
.print i(is)

.tran	1p	5ns
.end
