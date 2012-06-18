FHASMR	; HISC/REL/NCA - Assessment Report ;4/25/93  18:46
	;;5.0;Dietetics;;Oct 11, 1995
	S ALL=1 D ^FHDPA G:'DFN KIL
	I '$D(^FHPT(DFN,"N",0)) W !!,"No Nutrition Assessments on file" G KIL
	K DIC S DIC="^FHPT(DFN,""N"",",DIC(0)="Q",DA=DFN,X="??" D ^DIC
A0	S DIC="^FHPT(DFN,""N"",",DIC(0)="AEQM",DIC("A")="SELECT Assessment Date: " W ! D ^DIC G KIL:"^"[X!$D(DTOUT),A0:Y<1 S ASN=+Y
P0	; Select Device
	K IOP S %ZIS="MQ",%ZIS("B")="HOME" W ! D ^%ZIS K %ZIS,IOP G:POP KIL
	I $D(IO("Q")) S FHPGM="Q1^FHASMR",FHLST="DFN^PID^ASN" D EN2^FH G KIL
	U IO D Q1 D ^%ZISC K %ZIS,IOP G KIL
Q1	; Process Printing Assessment
	S %DT="XT",X="NOW" D ^%DT S DT=Y\1,DTP=+Y D DTP^FH S NOW=DTP
	S NAM=$P(^DPT(DFN,0),"^",1)
	S FHAP=$G(^FH(119.9,1,3)),FHU=$P(FHAP,"^",1)
	S Y=^FHPT(DFN,"N",ASN,0)
	F K=1:1:22 S @$P("ADT SEX AGE HGT HGP WGT WGP DWGT UWGT IBW FRM AMP X X X KCAL PRO FLD RC XD BMI BMIP"," ",K)=$P(Y,"^",K)
	S NB=$P(Y,"^",25)
	S EXT="" I $D(^FHPT(DFN,"N",ASN,1)) S EXT="Y",Y=^(1) F K=1:1:10 S @$P("TSF TSFP SCA SCAP ACIR ACIRP CCIR CCIRP BFAMA BFAMAP"," ",K)=$P(Y,"^",K)
	S APP=$G(^FHPT(DFN,"N",ASN,2))
	K LRTST F K=0:0 S K=$O(^FHPT(DFN,"N",ASN,"L",K)) Q:K<1  S LRTST(K)=^(K,0)
	S PRT=1 G ^FHASMR1
KIL	; Final variable kill
	G KILL^XUSCLEAN
