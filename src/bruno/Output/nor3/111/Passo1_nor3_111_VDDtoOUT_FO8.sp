
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	 'iTotal'  = 20u
V1		VDD  		0		DC		supply
V2		VDD2  	0		DC		supply
vinA 	high	0	PWL(0ns 0		1ns		0		1.001ns	supply)
vinB 	low		0	PWL(0ns supply	1ns		supply	1.001ns	0)

.subckt inverter in out VDD GND 
MP1	VDD	in	out	VDD pmos	L = 90n  W = 'widthPmos'	
MN2	GND	in	out	GND nmos	L = 90n  W = 200n		
.ends inverter

.SUBCKT nor3 a b c out VDD GND
MP1 pu_n1 a VDD VDD pmos	L = 90n W = '3*widthpmos'
MP2 pu_n3 b pu_n1 VDD pmos	L = 90n W = '3*widthpmos'
MP3 out c pu_n3 VDD pmos	L = 90n W = '3*widthpmos'
MN4 out a GND GND nmos		L = 90n W = 1*200n
MN5 out b GND GND nmos		L = 90n W = 1*200n
MN6 out c GND GND nmos		L = 90n W = 1*200n
.ENDS nor3


Xdut	high	high	high		outDUT	VDD	GND	nor3
iS	Xdut.VDD	Xdut.out	0	exp	(0	'iTotal'	2n	2p	2.015n	0p)

Xinv0	outDut	void	VDD	GND	inverter
Xinv1	outDut	void	VDD	GND	inverter
Xinv2	outDut	void	VDD	GND	inverter
Xinv3	outDut	void	VDD	GND	inverter
Xinv4	outDut	void	VDD	GND	inverter
Xinv5	outDut	void	VDD	GND	inverter
Xinv6	outDut	void	VDD	GND	inverter
Xinv7	outDut	void	VDD	GND	inverter

.measure	tran	Vpeak	max	v(Xdut.out)	 from = 1.5ns to = 3ns

.model	optmod	opt	itropt = 40
.optimize	opt2	model=optmod	analysisname=tran
.optgoal	opt2	vPeak = 1.2
.paramlimits opt2 'iTotal' minval=20u maxval=5m

.measure tran avgiS			avg i(iS) from = 2ns to = 2.4ns
.measure tran cargaTotal	param = 'avgiS * 0.4n'
.print v(outDUT)

.tran	1p	5ns
.end
