BUDCRP6B ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B ; 25 Jan 2016  3:25 PM
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
T6B ;
 D EOJ
EN ;
 S BUDNOLI=1
 D GENI
 D T6BI
 D PAUSE
 D PRENATT
 D PAUSE
 ;
EN1 ;EP
PNC ;
 ;S BUDPREN=""
 ;S DIR(0)="Y",DIR("A")="Does your facility provide prenatal care",DIR("B")="N" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) D EOJ Q
 ;S BUDPREN=Y
 ;
EN2 ;
 S BUDSITE=""
 S DIC="^BUDCSITE(",DIC(0)="AEMQ",DIC("A")="Enter your site: " D ^DIC
 I Y=-1 D EOJ Q
 S BUDSITE=+Y
 I '$O(^BUDCSITE(BUDSITE,11,0)) W !!,"Warning:  There are no locations defined in the site parameter file for this",!,"site.  Report will not be accurate!" G EN
 S BUDTAXT="B6" D TAXCHK^BUDCXTCH
 D YEAR
 I BUDYEAR="" D EOJ Q
 W !!,"Your report will be run for the time period: ",$$FMTE^XLFDT(BUDBD)," to ",$$FMTE^XLFDT(BUDED)
 ;get indian or not
 S BUDCEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"Classification not entered." D EOJ Q
 S BUDCEN=Y
 I $G(BUDNOLI) S BUDROT="P",BUDDELT="" G ZIS
 D PT^BUDCRPTE
 I BUDROT="" G EN1
ZIS ;call to XBDBQUE
 K IOP,%ZIS I BUDROT="D",BUDDELT="F" D NODEV,EOJ Q
 W !! S %ZIS=$S(BUDDELT'="S":"PQM",1:"PM") D ^%ZIS
ZIS1 ;
 I POP W !,"Report Aborted" D EOJ Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC
 U IO
 D PRINT
 D ^%ZISC
 D EOJ
 Q
NODEV ;
 S XBRP="",XBRC="NODEV1^BUDCRP6B",XBRX="EOJ^BUDCRP6B",XBNS="BUD"
 D ^XBDBQUE
 Q
NODEV1 ;
 D PROC^BUDCRP6B
 D PRINT^BUDCRP6B
 D ^%ZISC
 D EOJ
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BUD*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BUDCRP6B",ZTDTH="",ZTDESC="UDS 15 REPORT TABLE 6B" D ^%ZTLOAD D EOJ Q
 Q
EOJ ;
 D EN^XBVK("BUD")
 Q
PAPLIST1 ;EP
 D EOJ
 S BUDPAP1L=1
 D PAP1^BUDCRP6P
 G EN1
 ;
PAPLIST2 ;EP
 D EOJ
 S BUDPAP2L=1
 D PAP2^BUDCRP6P
 G EN1
DSLIST1 ;EP
 D EOJ
 S BUDDS1L=1
 D DS1^BUDCRP61
 G EN1
 ;
DSLIST2 ;EP
 D EOJ
 S BUDDS2L=1
 D DS2^BUDCRP61
 G EN1
IMMLIST1 ;EP
 D EOJ
 S BUDIMM1L=1
 D IMM1^BUDCRP6I
 G EN1
IMMLIST2 ;EP
 D EOJ
 S BUDIMM2L=1
 D IMM2^BUDCRP6I
 G EN1
PRGA ;EP
 D EOJ
 S BUDPRGAL=1
 D PRGA^BUDCRP6W
 G EN1
 ;
M ;EP - called from option
 D EOJ
 D GENI^BUDCRP6I
 K BUDTIND,BUDIND
 D EN^BUDCDSI
 I '$D(BUDIND) W !,"No Lists Selected." H 2 D EOJ Q
 S X=0 F  S X=$O(BUDIND(X)) Q:X'=+X  X ^BUDCLST2(X,1)
 G EN1
PROC ;EP - called from taskman
 S BUDJ=$J,BUDH=$H
 S ^XTMP("BUDCRP6B",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^BUD TABLE 6B LISTS"
 ;NOW LOOP PATS
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .K ^TMP($J)
 .Q:'$D(^AUPNPAT(DFN,0))
 .Q:'$D(^DPT(DFN,0))
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .Q:$$DEMO^BUDCDU(DFN,"E")
 .;;I DUZ=2881 Q:DFN'=25951
 .;I DUZ=2881 Q:DFN'=21116
 .;I DUZ=2881,'$D(^DIBT(14251,1,DFN)) Q
 .;I DUZ=2881 Q:$$HRN^AUPNPAT(DFN,DUZ(2))'=111933
LORIN .;
 .I BUDCEN=1,$$BEN^AUPNPAT(DFN,"C")'="01" Q  ;must be Indian/Alaskan Native
 .I BUDCEN=2,$$BEN^AUPNPAT(DFN,"C")="01" Q  ;must not be I/A
 .S C=$$COMMRES^AUPNPAT(DFN,"E")
 .S BUDSEX=$P(^DPT(DFN,0),U,2)
 .I BUDSEX'="F",BUDSEX'="M" Q
 .S BUDCOM=$$COMMRES^AUPNPAT(DFN,"E") I BUDCOM="" S BUDCOM="UNKNOWN"
 .S BUDAGE=$$AGE^AUPNPAT(DFN,BUDED)  ;age at end of time period
 .S BUDAGEP=$$AGE^AUPNPAT(DFN,BUDCAD)  ;age on june 30 for pregnancy 
 .D GETV^BUDCRPTD  ;get visits that meet criteria
 .I BUDT35V=0 Q  ;user doesn't have any countable visits
 .I $G(BUDPRGAL) D PRGALST
 .D IMM^BUDCRP6C
 .D PAPD^BUDCRP6D
 .D ADOLWT^BUDCRP6V
 .D ADULT^BUDCRP6V
 .D G^BUDCRP6V
 .D H^BUDCRP6U
 .D I^BUDCRP6O
 .D J^BUDCRP6M
 .D K^BUDCRP6N
 .D L^BUDCRP6Q
 .D M^BUDCRP6Q
 .D N^BUDCRP6H
 Q
PRGALST ;EP - list of pregnant females
 ;is patient pregnant during the time period BUDCD and BUDED
 Q:BUDSEX'="F"
 S BUDP=$$PREG(DFN,$$FMADD^XLFDT(BUDED,-609),BUDED)
 I '$P(BUDP,U) Q  ;not pregnant
 S X=$$AGB(BUDAGEP)
 S ^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",X,BUDAGEP,$P(^DPT(DFN,0),U),BUDCOM,DFN)=$P(BUDP,"*",2)
 Q
AGB(N) ;
 I N<15 Q "Less than 15 Years"
 I N>14,N<20 Q "Ages 15-19"
 I N>19,N<25 Q "Ages 20-24"
 I N>24,N<45 Q "Ages 25-44"
 Q "Ages 45 and Over"
PREG(P,BDATE,EDATE,NORXCHR) ;EP
 NEW BUDDX,B,CNT,BUDD,BUDG,BUDALL,BUDA
 S B=0,CNT=0,BUDD="",BUDALL=""  ;if there is one before time frame set this to 1
 S NORXCHR=$G(NORXCHR)
 K BUDG
 S Y="BUDG("
 S X=P_"^ALL DX [BGP PREGNANCY DIAGNOSES 2;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 ;now reorder by date of diagnosis and eliminate all chr and rx if necessary
 ;I '$D(BUDG) G PROB  ;no diagnoses
 ;unduplicate by date
 S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  S BUDA($P(BUDG(X),U,1))=BUDG(X)
 K BUDG
 M BUDG=BUDA
 S X=0 F  S X=$O(BUDG(X)) Q:X'=+X  D
 .;get date
 .S D=$P(BUDG(X),U,1)
 .S C=$$CLINIC^APCLV($P(BUDG(X),U,5),"C")
 .I NORXCHR,C=39 Q
 .S C=$$PRIMPROV^APCLV($P(BUDG(X),U,5),"D")
 .I NORXCHR,C=53 Q  ;no chr as primary provider
 .S V=$P(BUDG(X),U,5)
 .S BUDDX(D)="",CNT=CNT+1,BUDALL=BUDALL_V_"|"_$P(BUDG(X),U,2)_U I CNT=2 S BUDD=D
 .I D>$$FMADD^XLFDT(EDATE,-365) S B=1
 .Q
 I CNT>1,B G MA
 I 'B Q 0  ;no visit during time period
PROB S T=$O(^ATXAX("B","BGP GPRA PREGNANCY DIAGNOSES",0))
 S (X,G)=0,Z="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .Q:$P(^AUPNPROB(X,0),U,8)<BDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=$P(^AUPNPROB(X,0),U,8),Z=X
 .Q
 I G=0,BUDD="" Q 0  ;no dxs and no problem list
 S BUDD=G,BUDALL=BUDALL_"Problem List: "_$$VAL^XBDIQ1(9000011,Z,.01)_" on "_$$DATE^BUDCUTL1(G)
MA ;now check for abortion or miscarriage
 ;abortion first
 K BUDG S Y="BUDG(" S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_$$FMTE^XLFDT(BUDD)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BUDG(1)) Q 0  ;HAD MIS/AB
 S BUDG=$$LASTPRC^BUDCUTL1(P,"BGP ABORTION PROCEDURES",BDATE,EDATE)
 I BUDG Q 0
 S T=$O(^ATXAX("B","BGP MISCARRIAGE/ABORTION DXS",0))
 S (X,G)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G)  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,8)<BUDD
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S G=1
 .Q
 I G Q 0
 ;now check CPTs for Abortion and Miscarriage
 S T=$O(^ATXAX("B","BGP CPT ABORTION",0))
 S %=$$CPT^BUDCDU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT MISCARRIAGE",0))
 S %=$$CPT^BUDCDU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT ABORTION",0))
 S %=$$TRAN^BUDCDU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 S T=$O(^ATXAX("B","BGP CPT MISCARRIAGE",0))
 S %=$$TRAN^BUDCDU(P,BUDD,EDATE,T,3)
 I %]"" Q 0
 Q 1_"*"_BUDALL
 ;
PRINT ;EP - called from taskman
 S BUDPG=0
 S BUDQUIT=0
 S BUD80L="",$P(BUD80L,"_",79)="_"
 I BUDROT="D" D  G PL
 .D ^%ZISC ;close printer device
 .K ^TMP($J)
 .S ^TMP($J,"BUDDEL",0)=0
 .S BUDDECNT=0
 D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION A:  AGE CATEGORIES FOR PRENATAL PATIENTS"),!
 D LINE
 W $$CTR("DEMOGRAPHIC CHARACTERISTICS OF PRENATAL CARE PATIENTS"),!
 D LINE
 W ?20,"AGE",?45,"|",?50,"NUMBER OF PATIENTS (a)",!
 D LINE1
 W ?2,"1",?5,"LESS THAN 15 YEARS",?45,"|",?58,"",!
 D LINE1
 W ?2,"2",?5,"AGES 15-19",?45,"|",?58,"",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W ?2,"3",?5,"AGES 20-24",?45,"|",?58,"",! D LINE1
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W ?2,"4",?5,"AGES 25-44",?45,"|",?58,"",! D LINE1
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W ?2,"5",?5,"AGES 45 AND OVER",?45,"|","",! D LINE1
 I $Y>(IOSL-3) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W ?2,"6",?5,"TOTAL PATIENTS (SUM LINES 1-5)",?45,"|","",! D LINE1
 I $Y>(IOSL-12) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W !,$$CTR("SECTION B - TRIMESTER OF ENTRY INTO PRENATAL CARE"),! D LINE
 W "TRIMESTER OF ENTRY INTO",?37,"|",?40,"WOMEN HAVING",?60,"|",?63,"WOMEN HAVING",!
 W "PRENATAL CARE",?37,"|",?40,"FIRST VISIT WITH",?60,"|",?63,"FIRST VISIT WITH",!
 W "",?37,"|",?40,"HEALTH CENTER",?60,"|",?63,"ANOTHER PROVIDER",!
 W ?37,"|",?45,"(a)",?60,"|",?68,"(b)",!
 D LINE2
 W ?2,7,?5,"First Trimester",?37,"|",?45,"",?60,"|",?68,"",! D LINE2
 W ?2,8,?5,"Second Trimester",?37,"|",?45,"",?60,"|",?68,"",! D LINE2
 W ?2,9,?5,"Third Trimester",?37,"|",?45,"",?60,"|",?68,"",! D LINE2
 ;
 D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION C - CHILDHOOD IMMUNIZATION"),!
 D LINE
 W "CHILDHOOD IMMUNIZATION",?23,"|",?26,"TOTAL NUMBER",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?26,"PATIENTS WITH 3RD",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"PATIENTS",!
 W ?23,"|",?26,"BIRTHDAY DURING",?45,"|",?47,"TOTAL",?65,"|",?67,"IMMUNIZED",!
 W ?23,"|",?26,"MEASUREMENT YEAR",?45,"|",?47,"",?65,"|",?67,"",!
 W ?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"10",?5,"MEASURE: Children ",?23,"|",?45,"|",?65,"|",!
 W ?5,"who have received",?23,"|",?45,"|",?65,"|",!
 W ?5,"age appropriate",?23,"|",?45,"|",?65,"|",!
 W ?5,"vaccines who",?23,"|",?45,"|",?65,"|",!
 W ?5,"had their 3rd",?23,"|",?30,$$C($G(BUDSECTC("PTS"))),?45,"|",?50,$$C($G(BUDSECTC("PTS"))),?65,"|",?70,$$C($G(BUDSECTC("IMM"))),!
 W ?5,"birthday during",?23,"|",?45,"|",?65,"|",!
 W ?5,"measurement year",?23,"|",?45,"|",?65,"|",!
 W ?5,"(on or prior to",?23,"|",?45,"|",?65,"|",!
 W ?5,"31 December)",?23,"|",?45,"|",?65,"|",!
 D LINE
 I $Y>(IOSL-20) D HEADER^BUDCRPTP Q:BUDQUIT  D T6BH
 W $$CTR("SECTION D - CERVICAL CANCER SCREENING"),!
 D LINE
 W "PAP TESTS",?23,"|",?26,"TOTAL NUMBER",?45,"|",?47,"NUMBER CHARTS",?65,"|",?67,"NUMBER OF",!
 W ?23,"|",?26,"OF FEMALE PATIENTS",?45,"|",?47,"SAMPLED OR EHR",?65,"|",?67,"PATIENTS",!
 W ?23,"|",?26,"24-64 YEARS OF AGE",?45,"|",?47,"TOTAL",?65,"|",?67,"TESTED",!
 W ?23,"|",?30,"(a)",?45,"|",?50,"(b)",?65,"|",?70,"(c)",!
 D LINE3
 W ?1,"11",?5,"MEASURE: Female",?23,"|",?45,"|",?65,"|",!
 W ?5,"patients aged ",?23,"|",?45,"|",?65,"|",!
 W ?5,"24-64 who received",?23,"|",?45,"|",?65,"|",!
 W ?5,"one or more Pap ",?23,"|",?30,$$C($G(BUDSECTD("PTS"))),?45,"|",?50,$$C($G(BUDSECTD("PTS"))),?65,"|",?70,$$C($G(BUDSECTD("PAP"))),!
 W ?5,"tests to screen",?23,"|",?45,"|",?65,"|",!
 W ?5,"for cervical ",?23,"|",?45,"|",?65,"|",!
 W ?5,"cancer",?23,"|",?45,"|",?65,"|",!
 D LINE
 D REST6B^BUDCRP6E
PL D LISTS^BUDCRP6I
 D ^%ZISC
 I BUDROT="D" D SAVEDEL^BUDCRPTD
 K ^XTMP("BUDCRP6B",BUDJ,BUDH)
 Q
T6BH ;
 W !,$$CTR("TABLE 6B - QUALITY OF CARE INDICATORS"),!,$$REPEAT^XLFSTR("_",79),!
 Q
LINE ;
 W $$REPEAT^XLFSTR("_",79),!
 Q
LINE1 ;
 W $$REPEAT^XLFSTR("_",45),"|",$$REPEAT^XLFSTR("_",33),!
 Q
LINE2 ;
 W $$REPEAT^XLFSTR("_",37),"|",$$REPEAT^XLFSTR("_",22),"|",$$REPEAT^XLFSTR("_",18),!
 Q
LINE3 ;
 W $$REPEAT^XLFSTR("_",23),"|",$$REPEAT^XLFSTR("_",21),"|",$$REPEAT^XLFSTR("_",19),"|",$$REPEAT^XLFSTR("_",13),!
 Q
T6BI ;
 W !!,"TABLE 6B:  QUALITY OF CARE INDICATORS"
 W !,"This report will produce UDS Table 6B, quality of care indicators"
 W !,"for prenatal care, childhood immunizations, and Pap tests.  Patients"
 W !,"must meet additional criteria as specified for each indicator."
 Q
GENI ;general introductions
 W:$D(IOF) @(IOF)
 W !!,$$CTR($$LOC,80),!,$$CTR("UDS 2015",80),!
 W !,"UDS searches your database to find all patients reported for the quality"
 W !,"of care indicators during the time period January 1 - "
 W !,"December 31, 2015.  Based on the UDS definition, to be considered a"
 W !,"patient, the patient must have had at least one visit meeting the"
 W !,"following criteria:"
 W !?4,"- must be to a location specified in your visit location setup"
 W !?4,"- must be to Service Category Ambulatory (A), Hospitalization (H), Day"
 W !?6,"Surgery (S), Observation (O), Telemedicine (M), Nursing home visit (R), "
 W !?6,"or In-Hospital (I) visit"
 W !?4,"- must NOT have an excluded clinic code (see User Manual for a list)"
 W !?4,"- must have a primary provider and a coded purpose of visit"
 W !?4,"- the patient must NOT have a gender of 'Unknown'"
 W !
 Q
 ;
PRENATT ;EP
 D PRENATT^BUDCRP6I
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
NRY ;
 W !!,"not developed yet....." H 3
 Q
PAUSE ;
  K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
  Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "********"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
YEAR ;
 S BUDYEAR=""
 W !
 W !,"Enter the Calendar Year.  Use a 4 digit year, e.g. 2015"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Calendar Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 Q
 I $D(DIRUT) Q
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YEAR
 S BUDYEAR=Y,BUDBD=$E(BUDYEAR,1,3)_"0101",BUDED=$E(BUDYEAR,1,3)_"1231"
 S BUDCAD=$E(BUDYEAR,1,3)_"0630"
 Q
