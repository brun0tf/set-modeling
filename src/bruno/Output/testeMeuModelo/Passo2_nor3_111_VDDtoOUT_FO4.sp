
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	'iTotal' = 0.0010948
+	'Qcoll' = 15f - 1.4074E-14
+	'x' = 1p
V1		VDD  		0		DC		supply
V2		VDD2  	0		DC		supply

vinA 	high	0	PWL(0ns 0		1ns	0			1.001ns	supply)
vinB 	low	0	PWL(0ns supply	1ns	supply	1.001ns	0)

.subckt inverter in out VDD GND 
MP1	VDD	in	out	VDD pmos	L = 90n  W = 'widthPmos'	
MN2	GND	in	out	GND nmos	L = 90n  W = 200n		
.ends inverter

.SUBCKT nor3 a b c out VDD GND
mp1 pu_n1 a vdd vdd pmos  l = 90n w = '3*widthpmos'
mp2 pu_n3 b pu_n1 vdd pmos  l = 90n w = '3*widthpmos'
mp3 out c pu_n3 vdd pmos  l = 90n w = '3*widthpmos'
mn4 out a nAux gnd nmos  l = 90n w = 1*200n
mn5 out b nAux gnd nmos  l = 90n w = 1*200n
mn6 out c nAux gnd nmos  l = 90n w = 1*200n
v1 gnd  nAux 0  
.ENDS nor3

Xdut   high	high	high		outDUT	VDD	GND	nor3

iSp	Xdut.VDD	Xdut.out	0	exp	(0	'iTotal'	2n	2p	2.015n	'x')
fSh	Xdut.VDD	Xdut.out poly(2) xdut.v1 vi2 0 0 0 0 1
iSh_	y	GND	0	exp	(0	1	2.015n	0p	2.1n	4p)
vi2	y	GND	0

Xinv0	outDut	void	VDD	GND	inverter
Xinv1	outDut	void	VDD	GND	inverter
Xinv2	outDut	void	VDD	GND	inverter
Xinv3	outDut	void	VDD	GND	inverter

.measure	tran	setTracker	max	v(Xdut.out)	 from = 2.0ns to = 2.1ns

.measure	tran	vPeakMin	min	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure	tran	vPeakMax	max	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure tran avgPrompt			avg i(iSp) from = 2ns to = 2.4ns
.measure tran cargaPrompt		param = 'avgPrompt * 0.4n'
.measure tran avgHold			avg i(fSh) from = 2ns to = 2.4ns
.measure tran cargaHold		param = 'avgHold * 0.4n'

.model	optmod	opt	itropt = 40
.optimize	opt2	model=optmod	analysisname=tran
.optgoal	opt2	vpeakmax = 1.2
.paramlimits opt2 'x' minval=0p maxval=5p

.print v(outDUT) v(Xdut.out)
.print i(fSh) i(iSp)

.tran	1p	5ns
.end
