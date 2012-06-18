GMPLIENV	; SLC/MKB -- Environment Check rtn ;5/11/94  10:43
	;;2.0;Problem List;;Aug 25, 1994
EN	; entry point
	I $S('($D(DUZ)#2):1,'($D(DUZ(0))#2):1,'DUZ:1,1:0) D  K DIFQ Q
	. W !!,$C(7),"DUZ and DUZ(0) must be defined as an active user."
	. W !,"Please sign-on before running GMPLINIT."
	I DUZ(0)'="@" D  K DIFQ Q
	. W !!,$C(7),"You must have programmer access to run this init routine."
VA	; Check for file #200
	I '$D(^VA(200,0)) D  K DIFQ Q
	. W !!,$C(7),"You must have the NEW PERSON file (A4A7) installed!"
	. W !,"Please install this file first."
ICD	; Check for file #80
	I '$D(^ICD9(0)) D  K DIFQ Q
	. W !!,$C(7),"You must have the ICD DIAGNOSIS file installed!"
	. W !,"Please install this file first."
PXPT	; Check for the PCE Patient/IHS files
	I '$D(^AUPNPAT(0))!('$D(^AUTTLOC(0)))!('$D(^AUTNPOV(0))) D  K DIFQ Q
	. W !!,$C(7),"You must have the PCE PATIENT/IHS SUBSET installed!"
	. W !,"Please D ^PXPTINIT before continuing with this init."
CLU	; Check for the Clinical Lexicon Utility files
	I '$D(^GMP(757,0)) D  K DIFQ Q
	. W !!,$C(7),"You must have the CLINICAL LEXICON UTILITY installed!"
	. W !,"Please D ^GMPTINIT before continuing with this init."
LMGR	; Check for List Manager utility
	S X="VALM" X ^%ZOSF("TEST") K X
	I '$T!('$D(^SD(409.61,0))) D  K DIFQ Q
	. W !!,$C(7),"You must have the LIST MANAGER utility installed!"
	. W !,"Please D ^VALMINIT before continuing with this init."
	W "   <done> "
	Q
