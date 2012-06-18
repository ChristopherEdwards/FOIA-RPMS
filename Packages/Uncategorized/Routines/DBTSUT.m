DBTSUT ;utility routine to have several calls for diff functions [ 11/01/1999  10:33 AM ]
 ;
IMM ;to save the auttimm table out to a tab delimited text file
 ;
 O 51:("/usr/spool/uucppublic/dbts.imm":"W")
 S N=0
 S DBTSCT=0
 F  S N=$O(^AUTTIMM(N)) Q:+N=0  D
 .I '$D(^AUTTIMM(N,0)) Q
 .S DBTSREC=^AUTTIMM(N,0)
 .S DBTSN=$P(DBTSREC,"^",1)
 .S DBTSCO=$P(DBTSREC,"^",3)
 .S OUTREC=DBTSN_$C(9)_DBTSCO
 .U 51 W OUTREC,!
 .S DBTSCT=DBTSCT+1
 C 51
 U 0 W "TOTAL IMM RECORDS: ",DBTSCT
 K DBTSREC,DBTSN,DBTSCO,OUTREC,DBTSCT,N
 Q
EXAM ;
 ;
 O 51:("/usr/spool/uucppublic/dbts.ex":"W")
 S N=0
 S DBTSCT=0
 F  S N=$O(^AUTTEXAM(N)) Q:+N=0  D
 .I '$D(^AUTTEXAM(N,0)) Q
 .S DBTSREC=^AUTTEXAM(N,0)
 .S DBTSN=$P(DBTSREC,"^",1)
 .S DBTSCO=$P(DBTSREC,"^",2)
 .S OUTREC=DBTSN_$C(9)_DBTSCO
 .U 51 W OUTREC,!
 .S DBTSCT=DBTSCT+1
 C 51
 U 0 W "TOTAL EXAM RECORDS: ",DBTSCT
 K DBTSREC,DBTSN,DBTSCO,OUTREC,DBTSCT,N
 Q
DD ;
DRUG ;
 O 51:("/usr/spool/uucppublic/dbtsdrug.txt":"W")
 F I=84534,5177,5176,84338,84339,84328,83870,84078,340,84093,84172,84359,338,551,84092,357,644,2980,84008,654,84174,83839,703,657,2977,84033 D
 .S NAME=$P(^PSDRUG(I,0),"^",1)
 .S NDC=$P($G(^PSDRUG(I,2)),"^",4)
 .S OUTREC=NAME_$C(9)_NDC
 .U 51 W OUTREC,!
 C 51
 Q
AMP ;create icd op/proc. amputation text file
 O 51:("/usr/spool/uucppublic/dbtsamp.txt":"W")
 F DFN=2117,2118,2120,2121,2123,3360 D
 .S REC=^ICD0(DFN,0)
 .S CODE=$P(REC,U,1)
 .S NAME=$P(REC,U,4)
 .S OUTREC=NAME_$C(9)_CODE
 .U 51 W OUTREC,!
 C 51
 Q
CARD ;create text file of all cardiac diagnosis put to the DBTS CARDIAC DIAGNOSIS
 O 51:("/usr/spool/uucppublic/dbtscard.txt":"W")
 S DFN=0
 F  S DFN=$O(^DBTSCARD(DFN)) Q:+DFN=0  D
 .S ICD=$P(^DBTSCARD(DFN,0),"^",1)
 .S ICDREC=^ICD9(ICD,0)
 .S CODE=$P(ICDREC,"^",1)
 .S DIAG=$P(ICDREC,"^",3)
 .S OUTREC=CODE_$C(9)_DIAG
 .U 51 W OUTREC,!
 C 51
 Q
DRUGCL ;create text file of all drug class entries in the va drug class file
 O 51:("/usr/spool/uucppublic/dbtsdrclass.txt":"W")
 S DFN=0
 F  S DFN=$O(^PS(50.605,DFN)) Q:+DFN=0  D
 .S REC=^PS(50.605,DFN,0)
 .S CODE=$P(REC,"^",1)
 .S DESC=$P(REC,"^",2)
 .S PARENT=$P(REC,"^",3)
 .I PARENT'="" S PARENT=$P(^PS(50.605,PARENT,0),"^",1)
 .S TYPE=$P(REC,"^",4)
 .I TYPE'="" S TYPE=$S(TYPE=0:"MAJOR",TYPE=1:"MINOR",TYPE=2:"SUB-CLASS")
 .S OUTREC=CODE_$C(9)_DESC_$C(9)_PARENT_$C(9)_TYPE
 .U 51 W OUTREC,!
 C 51
 Q
PSDRUG ;  create drug table  delimit with "^" because pulling into M and merge
 ;  all su drug file
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtsdrugbr.txt":"W")
 S DFN=0
 F  S DFN=$O(^PSDRUG(DFN)) Q:+DFN=0  D
 .;Q:$D(^PSDRUG(DFN,"I"))
 .S INACT=$P($G(^PSDRUG(DFN,"I")),"^",1)
 .I INACT'="" I INACT<2960101 Q
 .;Q:'$D(^PSDRUG(DFN,"ND"))
 .Q:'$D(^PSDRUG(DFN,0))
 .S NAME=$P(^PSDRUG(DFN,0),"^",1)
 .S NDC=$P($G(^PSDRUG(DFN,2)),"^",4)
 .Q:NDC=""
 .S CLASS=$P($G(^PSDRUG(DFN,"ND")),"^",6)
 .I CLASS'="" S CLASS=$P($G(^PS(50.605,CLASS,0)),"^",1)
 .;S OUTREC=NDC_"^"_NAME_"^"_CLASS
 .S OUTREC=NDC_$C(9)_NAME_$C(9)_CLASS
 .U 51 W OUTREC,!
 .S CT=CT+1
 C 51
 U 0 W !!,"TOTAL DRUGS WRITTEN TO FILE: ",CT
 K CT,NDC,NAME,CLASS,INACT,DFN
 Q
DTCHK ;
 K DBTS("BADDT")
 I '$D(DBTS("DT")) S DBTS("BADDT")="Y" Q
 S MO=$E(DBTS("DT"),4,5)
 S DA=$E(DBTS("DT"),6,7)
 S YR=$E(DBTS("DT"),1,3)
 I +MO=0 S DBTS("BADDT")="Y"
 I +DA=0 S DBTS("BADDT")="Y" Q
 I +YR<100 S DBTS("BADDT")="Y" Q
 Q
NARR ;  convert the provider narr. to mixed case sentences
 Q:'$D(NARR)
 S DBTS("F")=$E(NARR,1)
UP S DBTS("F")=$TR(DBTS("F"),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S DBTS("L")=$E(NARR,2,80)
LOW S DBTS("L")=$TR(DBTS("L"),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 S NARR=DBTS("F")_DBTS("L")
 S DBTS("LEN")=$L(NARR)
 I $E(NARR,DBTS("L"))'="." S NARR=NARR_"."
 D NARR2
 Q
NARR2 ; chk for ii i Dm dm etc. and change the case to upper
 ;
 I NARR?.E1" ii".E D
 .S NARR=$P(NARR," ii",1)_" II"_$P(NARR," ii",2,99) 
 I NARR?.E1" iii".E D
 .S NARR=$P(NARR," iii",1)_" III"_$P(NARR," iii",2,99)
 I NARR?.E1" i ".E D
 .S NARR=$P(NARR," i ",1)_" I "_$P(NARR," i ",2,99) 
 I NARR?.E1" i.".E D 
 .S NARR=$P(NARR," i.",1)_" I."_$P(NARR," i.",2,99)
 I NARR?.E1" iv.".E D 
 .S NARR=$P(NARR," iv.",1)_" IV."_$P(NARR," iv.",2,99)
 I NARR?.E1" iv ".E D 
 .S NARR=$P(NARR," iv ",1)_" IV "_$P(NARR," iv ",2,99)
 I NARR?.E1" dm ".E D 
 .S NARR=$P(NARR," dm ",1)_" DM "_$P(NARR," dm ",2,99)
 I NARR?.E1" dm.".E D 
 .S NARR=$P(NARR," dm.",1)_" DM."_$P(NARR," dm.",2,99)
 I NARR?.E1" Dm ".E D 
 .S NARR=$P(NARR," Dm ",1)_" DM "_$P(NARR," Dm ",2,99)
 I NARR?.E1" Dm.".E D 
 .S NARR=$P(NARR," Dm.",1)_" DM."_$P(NARR," Dm.",2,99)
 I NARR?.E1"Dm.".E D 
 .S NARR=$P(NARR,"Dm.",1)_"DM."_$P(NARR,"Dm.",2,99)
 Q
DISC ;create provider discipline txt file for keith
 O 51:("/usr/spool/uucppublic/dbtspdisc.txt":"W")
 S N=0
 F  S N=$O(^DIC(7,N)) Q:+N=0  D
 .S REC=^DIC(7,N,0)
 .S NAME=$P(REC,U,1)
 .S CODE=$P($G(^DIC(7,N,9999999)),"^",1)
 .Q:CODE=""
 .S OUTREC=CODE_$C(9)_NAME
 .U 51 W OUTREC,!
 C 51
 Q
AFF ;
 O 51:("/usr/spool/uucppublic/dbtspaff.txt":"W")
 U 51 W "1"_$C(9)_"IHS",!
 W "2"_$C(9)_"CONTRACT",!
 W "3"_$C(9)_"TRIBAL",!
 W "4"_$C(9)_"STATE",!
 W "5"_$C(9)_"MUNICIPAL",!
 W "6"_$C(9)_"VOLUNTEER",!
 W "7"_$C(9)_"NTL HLTH SRV CORP",!
 W "8"_$C(9)_"638 PROGRAM",!
 W "9"_$C(9)_"OTHER",!
 C 51
 Q
CLI ;
 O 51:("/usr/spool/uucppublic/dbtscli.txt":"W")
 S N=0
 F  S N=$O(^DIC(40.7,N)) Q:+N=0  D
 .S REC=^DIC(40.7,N,0)
 .S NAME=$P(REC,U,1)
 .S CODE=$P(REC,"^",2)
 .S OUTREC=CODE_$C(9)_NAME
 .U 51 W OUTREC,!
 C 51
 Q
SVCCAT ;
 O 51:("/usr/spool/uucppublic/dbtssvcat.txt":"W")
 U 51 W "A"_$C(9)_"AMBULATORY",!
 W "H"_$C(9)_"HOSPITALIZATION",!
 W "I"_$C(9)_"IN HOSPITAL",!
 W "C"_$C(9)_"CHART REVIEW",!
 W "T"_$C(9)_"TELECOMMUNICATIONS",!
 W "N"_$C(9)_"NOT FOUND",!
 W "S"_$C(9)_"DAY SURGERY",!
 W "O"_$C(9)_"OBSERVATION",!
 W "E"_$C(9)_"EVENT (HISTORICAL)",!
 W "R"_$C(9)_"NURSING HOME",!
 W "D"_$C(9)_"DAILY HOSPITALIZATION DATA",!
 W "X"_$C(9)_"ANCILLARY PACKAGE DAILY DATA",!
 C 51
 Q
PROV ;
 S CT=0
 S N=0
 F  S N=$O(^VA(200,N)) Q:+N=0  D
 .Q:$P($G(^VA(200,N,"PS")),"^",5)=""
 .S ^DIA(200,N,0)=N
 .S ^DIA(200,"B",N,N)=""
 .S CT=CT+1
 .S $P(^DIA(200,0),"^",3)=CT
 .S $P(^DIA(200,0),"^",4)=CT
 Q
FAC ;  used to pull all the AREAs facilities to one txt file to be
 ;  loaded up into the facility file
 ;  9-30-99
 D ^XBKVAR
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtsfac.txt":"W")
 S N=0
 F  S N=$O(^AUTTLOC(N)) Q:+N=0  D
 .S AREA=$P($G(^AUTTLOC(N,0)),U,4)
 .Q:AREA=""
 .S AREA=$P($G(^AUTTAREA(AREA,0)),U,2)
 .I (AREA'=40),(AREA'=45),(AREA'=47) Q
 .S ZERO=^AUTTLOC(N,0)
 .S NO=$P(ZERO,U,10)
 .S DFN=$P(ZERO,U,1)
 .S NAME=$P($G(^DIC(4,DFN,0)),U,1)
 .S REC=NO_$C(9)_NAME_$C(9)
 .U 51 W REC,!
 .S CT=CT+1
 C 51
 Q
FAC2 ;  used to put the fac. number again and put the parent facility on the
 ;  2 field position and that is all
 ;  10-4-99
 D ^XBKVAR
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtsfac2.txt":"W")
 S N=0
 F  S N=$O(^AUTTLOC(N)) Q:+N=0  D
 .S AREA=$P($G(^AUTTLOC(N,0)),U,4)
 .Q:AREA=""
 .S AREA=$P($G(^AUTTAREA(AREA,0)),U,2)
 .I (AREA'=40),(AREA'=45),(AREA'=47) Q
 .S ZERO=^AUTTLOC(N,0)
 .S NO=$P(ZERO,U,10)
 .D PAR
 .I NO=PAR S PAR=""
 .S REC=NO_$C(9)_PAR
 .U 51 W REC,!
 .S CT=CT+1
 C 51
 Q
 ;
PAR ;
 S SU=$E(NO,3,4)
 I SU=41 S PAR=404101 Q
 I SU=42 S PAR=404201 Q
 I SU=43 S PAR=454312 Q
 I SU=44 S PAR=404401 Q
 I SU=45 S PAR=404510 Q
 I SU=46 S PAR=404610 Q
 I SU=47 S PAR=404710 Q
 I SU=48 S PAR=454810 Q
 S PAR=""
 Q
ICD ;   ICD9 table
 D ^XBKVAR
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtsicd.txt":"W")
 S N=0
 F  S N=$O(^ICD9(N)) Q:+N=0  D
 .S CODE=$P($G(^ICD9(N,0)),"^",1)
 .Q:CODE=""
 .S DESC=$P($G(^ICD9(N,0)),"^",3)
 .Q:DESC=""
 .S REC=CODE_$C(9)_DESC
 .U 51 W REC,!
 .S CT=CT+1
 C 51
 U 0 W !!,"TOTAL ICD: ",CT
 Q
 
 Q
ICDPCPT ;  icd procedure and the cpt code files
 D ^XBKVAR
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtsprocpt.txt":"W")
 S N=0
 F  S N=$O(^ICD0(N)) Q:+N=0  D
 .S CODE=$P($G(^ICD0(N,0)),"^",1)
 .Q:CODE=""
 .S DESC=$P($G(^ICD0(N,0)),"^",4)
 .Q:DESC=""
 .S REC=CODE_$C(9)_DESC_$C(9)_"ICD"
 .U 51 W REC,!
 .S CT=CT+1
 S CTCPT=0
 S N=0
 F  S N=$O(^ICPT(N)) Q:+N=0  D
 .S CODE=$P($G(^ICPT(N,0)),"^",1)
 .Q:CODE=""
 .S DESC=$P($G(^ICPT(N,0)),"^",2)
 .Q:DESC=""
 .S REC=CODE_$C(9)_DESC_$C(9)_"CPT"
 .U 51 W REC,!
 .S CTCPT=CTCPT+1
 C 51
 U 0 W !!,"TOTAL PROC: ",CT
 W !,"TOTAL CPT= ",CTCPT
 Q
 Q
CARFIL ;  cardiac filter diagnosis for keith's filter
 O 51:("/usr/spool/uucppublic/dbtscardfil.txt":"W")
 S CT=0
 S N=0
 F  S N=$O(^ICD9(N)) Q:+N=0  D
 .S REC=$G(^ICD9(N,0))
 .S CODE=$P(REC,"^",1)       
 .I CODE?1"401.".E D CW Q
 .I CODE?1"402.".E D CW Q
 .I CODE?1"403.".E D CW Q
 .I CODE?1"404.".E D CW Q
 .I CODE?1"405.".E D CW Q
 .I CODE?1"410.".E D CW Q
 .I CODE?1"411.".E D CW Q
 .I CODE?1"412.".E D CW Q
 .I CODE?1"413.".E D CW Q
 .I CODE?1"414.".E D CW Q
 .I CODE?1"428.".E D CW Q
 .Q
 U O W !!,"TOTAL CODES: ",CT
 C 51
 Q
CW ;
 U 51 W CODE_$C(9)_"501",!
 S CT=CT+1
 Q
CPTC ;  cpt category  10-6-1999
 D ^XBKVAR
 O 51:("/usr/spool/uucppublic/dbtscptc.txt":"W")
 S CT=0
 S NO=200
 S NA=""
 F  S NA=$O(^DIC(81.1,"B",NA)) Q:NA=""  D
 .S NO=NO+1
 .S REC=NO_$C(9)_NA
 .U 51 W REC,!
 .S CT=CT+1
 .Q
 U 0 W !!,"TOTAL: ",CT
 C 51
 Q
ICDFIL ;  build the skinny table for icd filter on ICD categories
 ;  1-17 in the code book  10-6-99
 D ^XBKVAR
 O 51:("/usr/spool/uucppublic/dbtsicdfilt.txt":"W")
 S N=0
 S CT=0
 F  S N=$O(^ICD9(N)) Q:+N=0  D
 .S CODE=$P(^ICD9(N,0),"^",1)
 .I $E(CODE,1)="0" S CAT=1 D ICDSET Q
 .I ($E(CODE,1,3)>99),($E(CODE,1,3)<140) S CAT=1 D ICDSET Q
 .I ($E(CODE,1,3)>139),($E(CODE,1,3)<240) S CAT=2 D ICDSET Q
 .I ($E(CODE,1,3)>239),($E(CODE,1,3)<280) S CAT=3 D ICDSET Q
 .I ($E(CODE,1,3)>279),($E(CODE,1,3)<290) S CAT=4 D ICDSET Q
 .I ($E(CODE,1,3)>289),($E(CODE,1,3)<320) S CAT=5 D ICDSET Q
 .I ($E(CODE,1,3)>319),($E(CODE,1,3)<390) S CAT=6 D ICDSET Q
 .I ($E(CODE,1,3)>389),($E(CODE,1,3)<460) S CAT=7 D ICDSET Q
 .I ($E(CODE,1,3)>459),($E(CODE,1,3)<520) S CAT=8 D ICDSET Q
 .I ($E(CODE,1,3)>519),($E(CODE,1,3)<580) S CAT=9 D ICDSET Q
 .I ($E(CODE,1,3)>579),($E(CODE,1,3)<630) S CAT=10 D ICDSET Q
 .I ($E(CODE,1,3)>629),($E(CODE,1,3)<680) S CAT=11 D ICDSET Q
 .I ($E(CODE,1,3)>679),($E(CODE,1,3)<710) S CAT=12 D ICDSET Q
 .I ($E(CODE,1,3)>709),($E(CODE,1,3)<740) S CAT=13 D ICDSET Q
 .I ($E(CODE,1,3)>739),($E(CODE,1,3)<760) S CAT=14 D ICDSET Q
 .I ($E(CODE,1,3)>759),($E(CODE,1,3)<780) S CAT=15 D ICDSET Q
 .I ($E(CODE,1,3)>779),($E(CODE,1,3)<800) S CAT=16 D ICDSET Q
 .I ($E(CODE,1,3)>799),($E(CODE,1,3)<999) S CAT=17 D ICDSET Q
 .I ($E(CODE,1)>"V"),($E(CODE,1)<"E") S CAT=17 D ICDSET Q
 U 0 W !!,"TOTAL: ",CT
 C 51
 Q
ICDSET ; 
 S REC=CODE_$C(9)_CAT
 U 51 W REC,!
 S CT=CT+1
 Q
CPTXWK ;  build a DBTSCPT(200-500) global for cross walk of proc category
 ;   number in node and description as 1st piece
 ;   used to pull the skinny file of cpt code and proc category file
 ;  for the refprocfilter file in SQL
 ;
 K ^DBTSCPTC
 D ^XBKVAR
 S CT=0
 S NO=200
 S NA=""
 F  S NA=$O(^DIC(81.1,"B",NA)) Q:NA=""  D
 .S DFN=$O(^DIC(81.1,"B",NA,0))
 .S NO=NO+1
 .S ^DBTSCPTC(NO)=NA
 .S ^DBTSCPTC("D",DFN)=NO_"^"_NA
 .S CT=CT+1
 .Q
 U 0 W !!,"TOTAL: ",CT
 Q
CPTFIL ;  build the skinny file for cpt filters using the DBTSCPTC global
 ;  I built with the 201-343 numbers for proc category
 ;
 D ^XBKVAR
 S CT=0
 O 51:("/usr/spool/uucppublic/dbtscptfilt.txt":"W")
 S N=0
 F  S N=$O(^ICPT(N)) Q:+N=0  D
 .S CODE=$P($G(^ICPT(N,0)),"^",1)
 .Q:CODE=""
 .S CAT=$P($G(^ICPT(N,0)),"^",3)
 .Q:CAT=""
 .I '$D(^DBTSCPTC("D",CAT)) Q
 .S PROCAT=$P(^DBTSCPTC("D",CAT),"^",1)
 .S REC=CODE_$C(9)_PROCAT
 .U 51 W REC,!
 .S CT=CT+1
 .Q
 U 0 W !!,"TOTAL: ",CT
 Q
