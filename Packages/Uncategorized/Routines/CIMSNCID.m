CIMSNCID ; CMI/TUCSON/LAB -NCI STUDY ;   [ 06/09/98  6:56 AM ]
 ;;1.0;NCI STUDY EXTRACT 1.0;;MAY 14, 1998
 ;
START ; 
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 S X="*****  NCI CANCER STUDY  *****" W !,$$CTR(X,80)
 S X="Patterns of Care Among Native American Cancer Patients" W !,$$CTR(X,80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 W !,"There are " S X=0,C=0 F  S X=$O(^CIMSCPAT(X)) Q:X'=+X  S C=C+1
 W C," patients in the NCI Cancer Study Register.",!
 ;
YEARS ;
 S CIMSYRS=0
 S DIR(0)="N^1:99:0",DIR("A")="How many years of data should be downloaded",DIR("B")="1" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EOJ
 S CIMSYRS=Y
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I Y'=1 D EOJ Q
 I $D(DIRUT) D EOJ Q
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D EOJ,QUEUE1 Q
 I $D(DIRUT) D EOJ Q
 D PROC
 Q
QUEUE1 ;
 S ZTRTN="PROC^CIMSNCID"
 S ZTIO="",ZTDTH="",ZTDESC="NCI STUDY EXPORT SYSTEM" S ZTSAVE("CIM*")=""
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request Queued.",1:"Request cancelled.")
 I '$D(ZTSK) S Q=99 Q
 K ZTSK
 Q
PROC ;EP - called from xbdbque to process patients
 I '$D(ZTQUEUED) W !,"Processing patients"
 S CIMSH=$H,CIMSJ=$J,(CIMSA,CIMSB,CIMSC,CIMSD,CIMSE)=0
 K ^TMP("CIMSNCI",$J,CIMSJ,CIMSH)
 S DFN=0 F  S DFN=$O(^CIMSCPAT(DFN)) Q:DFN'=+DFN  S CIMSDDX=$P(^CIMSCPAT(DFN,0),U,4) D
 .W:'$D(ZTQUEUED) "." D GENA
 .D GENB
 .D GENE
 .Q
WRITEF ;write out flat file
A ;
 W:'$D(ZTQUEUED) !!,"Writing out file A"
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S CIMSJD=X+1
 K ^TMP($J) S X=0 F  S X=$O(^TMP("CIMSNCI",$J,"A",X)) Q:X'=+X  S ^TMP($J,X)=^TMP("CIMSNCI",$J,"A",X)
 S XBGL="TMP("_$J_","
 S F="ncifilea."_CIMSJD
 S XBMED="F",XBFN=F,XBTLE="SAVE OF NCI EXTRACT STUDY RECORDS BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
B ;
 W:'$D(ZTQUEUED) !!,"Writing out file B"
 K ^TMP($J) S X=0 F  S X=$O(^TMP("CIMSNCI",$J,"B",X)) Q:X'=+X  S ^TMP($J,X)=^TMP("CIMSNCI",$J,"B",X)
 S XBGL="TMP("_$J_",",F="ncifileb."_CIMSJD,XBMED="F",XBFN=F,XBTLE="SAVE OF NCI EXTRACT STUDY RECORDS BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
C ;
 W:'$D(ZTQUEUED) !!,"Writing out file C"
 K ^TMP($J) S X=0 F  S X=$O(^TMP("CIMSNCI",$J,"C",X)) Q:X'=+X  S ^TMP($J,X)=^TMP("CIMSNCI",$J,"C",X)
 S XBGL="TMP("_$J_",",F="ncifilec."_CIMSJD,XBMED="F",XBFN=F,XBTLE="SAVE OF NCI EXTRACT STUDY RECORDS BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
D ;
 W:'$D(ZTQUEUED) !!,"Writing out file D"
 K ^TMP($J) S X=0 F  S X=$O(^TMP("CIMSNCI",$J,"D",X)) Q:X'=+X  S ^TMP($J,X)=^TMP("CIMSNCI",$J,"D",X)
 S XBGL="TMP("_$J_",",F="ncifiled."_CIMSJD,XBMED="F",XBFN=F,XBTLE="SAVE OF NCI EXTRACT STUDY RECORDS BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
E ;
 W:'$D(ZTQUEUED) !!,"Writing out file E"
 K ^TMP($J) S X=0 F  S X=$O(^TMP("CIMSNCI",$J,"E",X)) Q:X'=+X  S ^TMP($J,X)=^TMP("CIMSNCI",$J,"E",X)
 S XBGL="TMP("_$J_",",F="ncifilee."_CIMSJD,XBMED="F",XBFN=F,XBTLE="SAVE OF NCI EXTRACT STUDY RECORDS BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
 K ^TMP("CIMSNCI",$J)
 K ^TMP($J)
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT
 D EOJ
 Q
GENA ;generate file a record
 S X=$$AREC^CIMSNCI1(DFN,CIMSDDX,"NCI RECORD A")
 S CIMSA=CIMSA+1
 S ^TMP("CIMSNCI",$J,"A",CIMSA)=X
 Q
GENB ;
 ;go through all visits 1 year prior to 1 year after cimsddx
 Q:CIMSDDX=""
 S CIMSBG=$$FMADD^XLFDT(CIMSDDX,(-365.25*CIMSYRS)),CIMSED=$$FMADD^XLFDT(CIMSDDX,(365.25*CIMSYRS))
 S CIMVSIT=0 F  S CIMVSIT=$O(^AUPNVSIT("AC",DFN,CIMVSIT)) Q:CIMVSIT'=+CIMVSIT  D
 .S D=$P($P(^AUPNVSIT(CIMVSIT,0),U),".")
 .Q:D<CIMSBG
 .Q:D>CIMSED
 .Q:$P(^AUPNVSIT(CIMVSIT,0),U,11)
 .Q:'$P(^AUPNVSIT(CIMVSIT,0),U,9)
 .Q:"AH"'[$P(^AUPNVSIT(CIMVSIT,0),U,7)
 .;Q:'$D(^AUPNVPOV("AD",CIMVSIT))
 .;Q:'$D(^AUPNVPRV("AD",CIMVSIT))
 .Q:$P(^AUPNVSIT(CIMVSIT,0),U,6)'=DUZ(2)
 .I $D(^AUPNVPOV("AD",CIMVSIT)),$D(^AUPNVPRV("AD",CIMVSIT))  D
 ..S X=$$BREC^CIMSNCI1(CIMVSIT,"NCI RECORD B")
 ..S CIMSB=CIMSB+1
 ..S ^TMP("CIMSNCI",$J,"B",CIMSB)=X
 .;DO GENERATE C RECORDS
 .S CIMSLAB=0 F  S CIMSLAB=$O(^AUPNVLAB("AD",CIMVSIT,CIMSLAB)) Q:CIMSLAB'=+CIMSLAB  D
 ..S X=$$LREC^CIMSNCI1(CIMSLAB,"NCI RECORD C")
 ..S CIMSC=CIMSC+1
 ..S ^TMP("CIMSNCI",$J,"C",CIMSC)=X
 .;go through meds and generate D
 .S CIMSMED=0 F  S CIMSMED=$O(^AUPNVMED("AD",CIMVSIT,CIMSMED)) Q:CIMSMED'=+CIMSMED  D
 ..S X=$$MREC^CIMSNCI1(CIMSMED,"NCI RECORD D")
 ..S CIMSD=CIMSD+1
 ..S ^TMP("CIMSNCI",$J,"D",CIMSD)=X
 ..Q
 .Q
 Q
GENE ;
 S CIMSPRB=0 F  S CIMSPRB=$O(^AUPNPROB("AC",DFN,CIMSPRB)) Q:CIMSPRB'=+CIMSPRB  D
 .S X=$$PREC^CIMSNCI1(CIMSPRB,"NCI RECORD E")
 .S CIMSE=CIMSE+1
 .S ^TMP("CIMSNCI",$J,"E",CIMSE)=X
 .Q
 Q
NPR(V) ;
 NEW C,X
 S (X,C)=0
 F  S X=$O(^AUPNVPRC("AD",V,X)) Q:X'=+X  S C=C+1
 Q C
HF(V,N) ;return N health factor on this visit
 NEW X,C,%
 S %="",(X,C)=0 F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X  S C=C+1 I C=N S %=$P(^AUTTHF($P(^AUPNVHF(X,0),U),0),U)
 Q %
DATE(D) ;EP convert internal fileman format to mmddyyyy
 I $G(D)="" Q ""
 Q $E(D,4,7)_($E(D,1,3)+1700)
VPR(P,D) ;
 I '$G(P) Q 0
 I $G(D)="" Q 0
 NEW X,C,B
 S (X,C)=0
 S B=$$FMADD^XLFDT(D,-365)
 F  S X=$O(^AUPNVSIT("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNVSIT(X,0),U,11)  ;deleted
 .Q:'$P(^AUPNVSIT(X,0),U,9)  ;no dep
 .Q:"AH"'[$P(^AUPNVSIT(X,0),U,7)
 .Q:$P(^AUPNVSIT(X,0),U,6)'=DUZ(2)
 .Q:'$D(^AUPNVPOV("AD",X))
 .Q:'$D(^AUPNVPRV("AD",X))
 .Q:$P($P(^AUPNVSIT(X,0),U),".")>D
 .Q:$P($P(^AUPNVSIT(X,0),U),".")<B
 .S C=C+1
 Q C
LASTHT(P,F,CIMSTYPE,CIMSDATE) ;PEP - return last ht before dx date
 I 'P Q ""
 I $G(CIMSDATE)="" Q ""
 I $G(CIMSTYPE)="" S CIMSTYPE="V"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,APCLARRY,H,E,G,A,B,D
 S A=$$FMTE^XLFDT(CIMSDATE),B="JAN 01, 1900"
 S %=P_"^LAST MEAS HT;DURING "_B_"-"_A NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2),D=$P($G(APCLARRY(1)),U,1)
 I H]"",CIMSTYPE="V" S H=$J(H,2,0) Q $S(F="I":H,1:(H\12)_" "_(H#12))
 I H]"",CIMSTYPE="D" Q D
 S A=$$FMTE^XLFDT(DT),B=$$FMTE^XLFDT(CIMSDATE)
 S %=P_"^LAST MEAS HT;DURING "_B_"-"_A NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2),D=$P($G(APCLARRY(1)),U,1)
 I H="" Q H
 I H]"",CIMSTYPE="V" S H=$J(H,2,0) Q $S(F="I":H,1:(H\12)_" "_(H#12))
 I H]"",CIMSTYPE="D" Q D
 ;F="I" - in inches, F="E" - feet and inches 5 5
LASTWT(P,CIMSTYPE,CIMSDATE) ;PEP - return last wt
 I 'P Q ""
 I $G(CIMSDATE)="" Q ""
 I $G(CIMSTYPE)="" S CIMSTYPE="V"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,APCLARRY,H,E,G,A,B,D
 S A=$$FMTE^XLFDT(CIMSDATE),B="JAN 01, 1900"
 S %=P_"^LAST MEAS WT;DURING "_B_"-"_A NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2),D=$P($G(APCLARRY(1)),U,1)
 I H]"",CIMSTYPE="V" S H=$J(H,3,1) Q H
 I H]"",CIMSTYPE="D" Q D
 S A=$$FMTE^XLFDT(DT),B=$$FMTE^XLFDT(CIMSDATE)
 S %=P_"^LAST MEAS WT;DURING "_B_"-"_A NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2),D=$P($G(APCLARRY(1)),U,1)
 I H="" Q H
 I H]"",CIMSTYPE="V" S H=$J(H,3,1) Q H
 I H]"",CIMSTYPE="D" Q D
BMI(P) ;PEP - return BMI with last weight,last height
 I 'P Q -1
 NEW %,W,H,B
 S %=""
 S W=$$LASTWT(P,"V",$P(^CIMSCPAT(P,0),U,4)) I W="" Q %
 S H=$$LASTHT(P,"I","V",$P(^CIMSCPAT(P,0),U,4)) I H="" Q %
 S W=(W/5)*2.3,H=(H*2.5),H=(H*H)/10000,%=(W/H),%=$J(%,4,1)
 Q %
ERR W $C(7),$C(7),!,"Must be a valid Year.  Enter a year only!!" Q
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
EOJ ;
 D ^XBFMK
 K X,X1,X2,IO("Q"),%,Y,%DT,%Y,%W,%T,%H,DUOUT,DTOUT,POP,ZTSK,ZTQUEUED,H,S,TS,M,DFN
 D KILL^AUPNPAT
 D EN^XBVK("CIM"),EN^XBVK("APCL"),EN^XBVK("AUPN")
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
HEADER ;EP called from menu header
 W:$D(IOF) @IOF
 W !,$$CTR("NATIONAL CANCER INSTITUTE",80)
 W !,$$CTR("Patterns of Care Among Native American Cancer Patients",80)
 W !,$$CTR("Main Study Menu"),!
 W !,$$CTR($$LOC(),80)
 W !,$$CTR("Version 1.0  April 1998",80)
 W !,$$CTR("Cimarron Medical Informatics, LLC",80)
 Q
INTRO ;
 ;;This program will download data from the RPMS system to support the study
 ;;identified above.  Data will be downloaded for each patient who is entered
 ;;into the NCI CANCER STUDY PATIENT REGISTER file.
 ;;
 ;;Five files of data will be created.  They will be named:
 ;;        - ncifilea.nnn
 ;;        - ncifileb.nnn
 ;;        - ncifilec.nnn
 ;;        - ncifiled.nnn
 ;;        - ncifilee.nnn   (nnn is the julian date when the file was created)
 ;;The files will be placed in the export directory.  (/usr/spool/uucppublic
 ;;if you are on a unix machine, C:\EXPORT on DOS)
 ;;
 ;;Please jot down these file names for future reference.
 ;;
 ;;END
 ;
 ;
