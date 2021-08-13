
.include ptm_90nm.l
.param 'supply' = 1.2
+	'lambda' = 1.8087
+	'widthPmos' = '200n*lambda'
+	'iTotal' = 9.8336E-4
+	'Qcoll' = 15f - 1.26411E-14
+	'tF_delay' = 2n
V1		VDD  		0		DC		supply
V2		VDD2  	0		DC		supply

vinA 	high	0	PWL(0ns 0		1ns	0			1.001ns	supply)
vinB 	low	0	PWL(0ns supply	1ns	supply	1.001ns	0)

.subckt inverter in out VDD GND 
MP1	VDD	in	out	VDD pmos	L = 90n  W = 'widthPmos'	
MN2	GND	in	out	GND nmos	L = 90n  W = 200n		
.ends inverter

.SUBCKT f33 a b c d out vdd gnd
mp11 pu_n9 not_d vdd vdd pmos  l = 90n w = '4*widthpmos'
mp9 pu_n8 d vdd vdd pmos  l = 90n w = '4*widthpmos'
mp6 pu_n6 d vdd vdd pmos  l = 90n w = '4*widthpmos'
mp4 pu_n4 not_d vdd vdd pmos  l = 90n w = '4*widthpmos'
mp10 pu_n7 not_c pu_n9 vdd pmos  l = 90n w = '4*widthpmos'
mp8 pu_n7 c pu_n8 vdd pmos  l = 90n w = '4*widthpmos'
mp5 pu_n3 not_c pu_n6 vdd pmos  l = 90n w = '4*widthpmos'
mp3 pu_n3 c pu_n4 vdd pmos  l = 90n w = '4*widthpmos'
mp7 pu_n1 b pu_n7 vdd pmos  l = 90n w = '4*widthpmos'
mp2 pu_n1 not_b pu_n3 vdd pmos  l = 90n w = '4*widthpmos'
mp1 nAux a pu_n1 vdd pmos  l = 90n w = '4*widthpmos'
v1 out  nAux 0  
mn18 out b pd_n6 gnd nmos  l = 90n w = 3*108n
mn17 out a gnd gnd nmos  l = 90n w = 1*108n
mn12 out not_b pd_n1 gnd nmos  l = 90n w = 3*108n
mn21 pd_n6 c pd_n8 gnd nmos  l = 90n w = 3*108n
mn19 pd_n6 not_c pd_n7 gnd nmos  l = 90n w = 3*108n
mn22 pd_n8 d gnd gnd nmos  l = 90n w = 3*108n
mn20 pd_n7 not_d gnd gnd nmos  l = 90n w = 3*108n
mn16 pd_n5 not_d gnd gnd nmos  l = 90n w = 3*108n
mn14 pd_n3 d gnd gnd nmos  l = 90n w = 3*108n
mn15 pd_n1 c pd_n5 gnd nmos  l = 90n w = 3*108n
mn13 pd_n1 not_c pd_n3 gnd nmos  l = 90n w = 3*108n
.ENDS f33

Xdut   low	low	low	low		outDUT	VDD	GND	f33

iSp	Xdut.out	Xdut.GND	0	exp	(0	'iTotal'	2n	2p	2.015n	0p)
fSh	Xdut.out	Xdut.GND poly(2) xdut.v1 vi2 0 0 0 0 1
iSh_	y	GND	0	exp	(0	1	2.015n	0p	2.1n	4p)
vi2	y	GND	0

Xinv0	outDut	void	VDD	GND	inverter
Xinv1	outDut	void	VDD	GND	inverter
Xinv2	outDut	void	VDD	GND	inverter
Xinv3	outDut	void	VDD	GND	inverter

.measure	tran	setTracker	min	v(Xdut.out)	 from = 2.0ns to = 2.1ns

.measure	tran	vPeakMin	min	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure	tran	vPeakMax	max	v(Xdut.out)	 from = 2.04ns to = 2.1ns

.measure tran avgPrompt			avg i(iSp) from = 2ns to = 2.4ns
.measure tran cargaPrompt		param = 'avgPrompt * 0.4n'
.measure tran avgHold			avg i(fSh) from = 2ns to = 2.4ns
.measure tran cargaHold		param = 'avgHold * 0.4n'


.print v(outDUT) v(Xdut.out)
.print i(fSh) i(iSp)

.tran	1p	5ns
.end
