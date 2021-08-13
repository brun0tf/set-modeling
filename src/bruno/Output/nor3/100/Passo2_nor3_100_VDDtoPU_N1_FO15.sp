
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	'iTotal' = 3.749E-4
+	'Qcoll' = 15f - 4.8193E-15
+	'tF_delay' = 2n
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
v1 nAux  pu_n1 0  
mp2 nAux b pu_n3 vdd pmos  l = 90n w = '3*widthpmos'
mp3 out c pu_n3 vdd pmos  l = 90n w = '3*widthpmos'
mn4 out a gnd gnd nmos  l = 90n w = 1*200n
mn5 out b gnd gnd nmos  l = 90n w = 1*200n
mn6 out c gnd gnd nmos  l = 90n w = 1*200n
.ENDS nor3

Xdut   high	low	low		outDUT	VDD	GND	nor3

iSp	Xdut.VDD	Xdut.pu_n1	0	exp	(0	'iTotal'	2n	2p	2.015n	0)
fSh	Xdut.VDD	Xdut.pu_n1 poly(2) xdut.v1 vi2 0 0 0 0 1
iSh_	y	GND	0	exp	(0	1	2.015n	0p	2.1n	4p)
vi2	y	GND	0

Xinv0	outDut	void	VDD	GND	inverter
Xinv1	outDut	void	VDD	GND	inverter
Xinv2	outDut	void	VDD	GND	inverter
Xinv3	outDut	void	VDD	GND	inverter
Xinv4	outDut	void	VDD	GND	inverter
Xinv5	outDut	void	VDD	GND	inverter
Xinv6	outDut	void	VDD	GND	inverter
Xinv7	outDut	void	VDD	GND	inverter
Xinv8	outDut	void	VDD	GND	inverter
Xinv9	outDut	void	VDD	GND	inverter
Xinv10	outDut	void	VDD	GND	inverter
Xinv11	outDut	void	VDD	GND	inverter
Xinv12	outDut	void	VDD	GND	inverter
Xinv13	outDut	void	VDD	GND	inverter
Xinv14	outDut	void	VDD	GND	inverter

.measure	tran	setTracker	max	v(Xdut.pu_n1)	 from = 2.0ns to = 2.1ns

.measure	tran	vPeakMin	min	v(Xdut.pu_n1)	 from = 2.04ns to = 2.1ns

.measure	tran	vPeakMax	max	v(Xdut.pu_n1)	 from = 2.04ns to = 2.1ns

.measure tran avgPrompt			avg i(iSp) from = 2ns to = 2.4ns
.measure tran cargaPrompt		param = 'avgPrompt * 0.4n'
.measure tran avgHold			avg i(fSh) from = 2ns to = 2.4ns
.measure tran cargaHold		param = 'avgHold * 0.4n'


.print v(outDUT) v(Xdut.pu_n1)
.print i(fSh) i(iSp)

.tran	1p	5ns
.end
