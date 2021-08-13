
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	'iTotal' = 9.5736E-4
+	'Qcoll' = 15f - 1.23069E-14
+	'x' = 0
V1		VDD  		0		DC		supply
V2		VDD2  	0		DC		supply

vinA 	high	0	PWL(0ns 0		1ns	0			1.001ns	supply)
vinB 	low	0	PWL(0ns supply	1ns	supply	1.001ns	0)

.subckt inverter in out VDD GND 
MP1	VDD	in	out	VDD pmos	L = 90n  W = 'widthPmos'	
MN2	GND	in	out	GND nmos	L = 90n  W = 200n		
.ends inverter

.SUBCKT nand3 A B C out nAux VDD GND
mp1 nAux a vdd vdd pmos  l = 90n w = 'widthpmos'
mp2 nAux b vdd vdd pmos  l = 90n w = 'widthpmos'
mp3 nAux c vdd vdd pmos  l = 90n w = 'widthpmos'
vi1 out  nAux 0  
mn4 Naux a pd_n1 gnd nmos  l = 90n w = 3*200n
mn5 pd_n1 b pd_n3 gnd nmos  l = 90n w = 3*200n
mn6 pd_n3 c gnd gnd nmos  l = 90n w = 3*200n
.ENDS nand3

Xdut   low	low	low		outDUT nAux	VDD	GND	nand3

iSp	Xdut.out	Xdut.GND	0	exp	(0	'iTotal'	2n	2p	2.015n	1p)
fSh	Xdut.out	Xdut.GND poly(2) xdut.vi1 vi2 0 0 0 0 1
iSh_	y	GND	0	exp	(0	1	2.015n	1p	2.1n	4p)
vi2	y	GND	0

Xinv0	out	void	VDD	GND	inverter
Xinv1	out	void	VDD	GND	inverter
Xinv2	out	void	VDD	GND	inverter
Xinv3	out	void	VDD	GND	inverter

.measure	tran	setTracker	min	v(Xdut.out)	 from = 2.0ns to = 2.1ns

.measure	tran	vPeakMin	min	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure	tran	vPeakMax	max	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure tran avgPrompt			avg i(iSp) from = 2ns to = 2.4ns
.measure tran cargaPrompt		param = 'avgPrompt * 0.4n'
.measure tran avgHold			avg i(fSh) from = 2ns to = 2.4ns
.measure tran cargaHold		param = 'avgHold * 0.4n'

*.model	optmod	opt	itropt = 40
*.optimize	opt2	model=optmod	analysisname=tran
*.optgoal	opt2	vPeakMax = 0
*.paramlimits opt2 'x' minval=0p maxval=50p

.print v(outDUT) v(Xdut.out)
.print i(fSh) i(iSp)

.tran	1p	5ns
.end
