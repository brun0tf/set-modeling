
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

.SUBCKT f33 a b c d out vdd gnd
*.PININFO a:I b:I c:I d:I out:O vdd:P gnd:G
*.EQN out=(!a * ((b * ((!c * d) + (c * !d))) + (!b * ((!c * !d) + (c * d)))));
MP1 out a pu_n1 vdd 		pmos			L = 90n  W = '4*widthPmos'
MP2 pu_n1 not_b pu_n3 vdd 	pmos	L = 90n  W = '4*widthPmos'
MP3 pu_n3 c pu_n4 vdd 		pmos		L = 90n  W = '4*widthPmos'
MP4 pu_n4 not_d vdd vdd 	pmos		L = 90n  W = '4*widthPmos'
MP5 pu_n3 not_c pu_n6 vdd 	pmos	L = 90n  W = '4*widthPmos'
MP6 pu_n6 d vdd vdd 		pmos			L = 90n  W = '4*widthPmos'
MP7 pu_n1 b pu_n7 vdd 		pmos		L = 90n  W = '4*widthPmos'
MP8 pu_n7 c pu_n8 vdd 		pmos		L = 90n  W = '4*widthPmos'
MP9 pu_n8 d vdd vdd 		pmos			L = 90n  W = '4*widthPmos'
MP10 pu_n7 not_c pu_n9 vdd	pmos	L = 90n  W = '4*widthPmos'
MP11 pu_n9 not_d vdd vdd 	pmos	L = 90n  W = '4*widthPmos'
MN12 out not_b pd_n1 gnd 	nmos	L = 90n  W = 3*108n
MN13 pd_n1 not_c pd_n3 gnd 	nmos	L = 90n  W = 3*108n
MN14 pd_n3 d gnd gnd 		nmos		L = 90n  W = 3*108n
MN15 pd_n1 c pd_n5 gnd 		nmos		L = 90n  W = 3*108n
MN16 pd_n5 not_d gnd gnd 	nmos	L = 90n  W = 3*108n
MN17 out a gnd gnd 			nmos			L = 90n  W = 1*108n
MN18 out b pd_n6 gnd 		nmos		L = 90n  W = 3*108n
MN19 pd_n6 not_c pd_n7 gnd 	nmos	L = 90n  W = 3*108n
MN20 pd_n7 not_d gnd gnd nmos	L = 90n  W = 3*108n
MN21 pd_n6 c pd_n8 gnd nmos		L = 90n  W = 3*108n
MN22 pd_n8 d gnd gnd nmos		L = 90n  W = 3*108n
MP_inv23 not_b b vdd vdd pmos	L = 90n  W = 'widthPmos'
MN_inv24 not_b b gnd gnd nmos	L = 90n  W = 108n
MP_inv25 not_c c vdd vdd pmos	L = 90n  W = 'widthPmos'
MN_inv26 not_c c gnd gnd nmos	L = 90n  W = 108n
MP_inv27 not_d d vdd vdd pmos	L = 90n  W = 'widthPmos'
MN_inv28 not_d d gnd gnd nmos	L = 90n  W = 108n
.ENDS f33


Xdut	low	low	low	low		outDUT	VDD	GND	f33
iS	Xdut.out	Xdut.GND	0	exp	(0	'iTotal'	2n	2p	2.015n	0p)

Xinv0	outDut	void	VDD	GND	inverter
Xinv1	outDut	void	VDD	GND	inverter
Xinv2	outDut	void	VDD	GND	inverter
Xinv3	outDut	void	VDD	GND	inverter
.measure	tran	Vpeak	min	v(Xdut.out)	 from = 1.5ns to = 3ns

.model	optmod	opt	itropt = 40
.optimize	opt2	model=optmod	analysisname=tran
.optgoal	opt2	vPeak = 0.0
.paramlimits opt2 'iTotal' minval=20u maxval=5m

.measure tran avgiS			avg i(iS) from = 2ns to = 2.4ns
.measure tran cargaTotal	param = 'avgiS * 0.4n'
.print v(outDUT)

.tran	1p	5ns
.end
