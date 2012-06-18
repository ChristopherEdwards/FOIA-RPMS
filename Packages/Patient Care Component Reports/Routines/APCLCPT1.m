APCLCPT1 ; IHS/CMI/LAB - list CPT CODES BY PROVIDER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;EP
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("TALLY OF CPT CODES BY PROVIDER",80)
 W !!,"This report will tally the all CPT codes entered by provider."
 W !,"You will be able to specify the date range; whether to include"
 W !,"outpatient (ambulatory, day surgery, observation), inpatient visits"
 W !,"or both; tally cpts codes by primary provider only or primary"
 W !,"and secondary provider; and whether to include only visits to"
 W !,"one facility, a service unit or to patients who are members"
 W !,"of a particular tribe."
 W !!,"PLEASE NOTE:  If you choose both primary and secondary providers"
 W !,"               the following logic will be applied:"
 W !,"               If you use the CPE mnemonic or the CPT code is entered"
 W !,"               through EHR the CPT code will be linked to the encounter"
 W !,"               provider documented.  If there is no encounter provider"
 W !,"               documented then the CPT code will be tallied under each"
 W !,"               provider on that visit thus the counts will include the"
 W !,"               same CPT code multiple times."
 W !
 D EOJ
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
PS ;
 S APCLPRIM=""
 S DIR(0)="SO^P:Primary Provider Only;A:All Providers (Primary and Secondary)",DIR("A")="Report should include"
 S DIR("?")="If you wish to count only the primary provider of service enter a 'P'.  To include ALL providers enter an 'A'." D ^DIR K DIR
 G:$D(DIRUT) DATES
 S APCLPRIM=Y
SC ;
 S APCLOI=""
 S DIR(0)="SO^O:Outpatient Visits (ambulatory, day surgery, observation);I:Inpatient;B:Both",DIR("A")="Report should include",DIR("B")="B"
 S DIR("?")="If you wish to count only the primary provider of service enter a 'P'.  To include ALL providers enter an 'A'." D ^DIR K DIR
 G:$D(DIRUT) PS
 S APCLOI=Y
FAC ;
 S APCLLOCT=""
 S DIR(0)="S^S:One Service Unit;L:One Location/Facility;T:One Tribe;A:All visits",DIR("A")="Include Visits to"
 S DIR("A")="Enter a code indicating which visits are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) SC
 S APCLLOCT=Y
 K APCLQ
 D @APCLLOCT
 I $D(APCLQ) W !!,"none selected" G SC
OUTP ;type of output, printed or excel delimited
 K APCLQ
 D PT
 I $D(APCLQ) W !!,"no output type selected." G FAC
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G OUTP
 K IOP,%ZIS I APCLROT="D",APCLDELT="F" D NODEV,XIT Q
 W !! S %ZIS=$S(APCLDELT'="S":"PQM",1:"PM") D ^%ZIS
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC
 U IO
 D PRINT
 D ^%ZISC
 D XIT
 Q
 ;
NODEV1 ;
 D PROC
 D PRINT
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("APCL*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCLCPT1",ZTDTH="",ZTDESC="CPT PROVIDER TALLY" D ^%ZTLOAD D XIT Q
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^APCLCPT1",XBRX="XIT^APCLCPT1",XBNS="APCL"
 D ^XBDBQUE
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("APCL")
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D ^XBFMK
 Q
EOJ ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
PROC ;
 S APCLH=$H,APCLJ=$J
 K ^XTMP("APCLCPT1",APCLJ,APCLH)
 D XTMP^APCLOSUT("APCLCPT1","CPT BY PROVIDER REPORT")
 ; Run by visit date
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 S APCLODAT=APCLSD_".9999" F  S APCLODAT=$O(^AUPNVSIT("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D V1
 Q
V1 ;
 S APCLVIEN="" F  S APCLVIEN=$O(^AUPNVSIT("B",APCLODAT,APCLVIEN)) Q:APCLVIEN'=+APCLVIEN  D PROC1
 Q
PROC1 ;
 Q:'$D(^AUPNVSIT(APCLVIEN,0))
 S APCLVREC=^AUPNVSIT(APCLVIEN,0)
 Q:'$P(APCLVREC,U,9)  ;no dep entries
 Q:$P(APCLVREC,U,11)  ;deleted
 S DFN=$P(APCLVREC,U,5)
 Q:DFN=""
 Q:'$D(^DPT(DFN,0))
 Q:'$D(^AUPNPAT(DFN,0))
 Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 S X=$P(APCLVREC,U,7)
 Q:X=""
 Q:"AIHSO"'[X
 I APCLOI="O",X'="A",X'="S",X'="O" Q  ;want only outpt and it's not a A,O or S
 I APCLOI="I",X'="H",X'="I" Q  ;want inpatient only
 S X=$P(^AUPNVSIT(APCLVIEN,0),U,6) Q:X=""
 I APCLLOCT="L" Q:X'=APCLLOC
 I APCLLOCT="S" Q:$P(^AUTTLOC(X,0),U,5)'=APCLSU  ;not correct su
 I APCLLOCT="T" Q:$$TRIBE^AUPNPAT(DFN,"I")'=APCLTRIB  ;not correct tribe
 ;get e&m and loop through V CPT
 K AUPNCPT
 S X=$$CPT^AUPNCPT(APCLVIEN)
 Q:'$D(AUPNCPT)
 S APCLX=0 F  S APCLX=$O(AUPNCPT(APCLX)) Q:APCLX'=+APCLX  D
 .S APCLC=$P(AUPNCPT(APCLX),U)
 .S APCLN=$P(AUPNCPT(APCLX),U,2)
 .S APCLF=$P(AUPNCPT(APCLX),U,4)
 .S APCLI=$P(AUPNCPT(APCLX),U,5)
 .S APCLQ=1 I $P(AUPNCPT(APCLX),U,4)=9000010.18 S I=$P(AUPNCPT(APCLX),U,5) I $P($G(^AUPNVCPT(I,0)),U,16)>1 S APCLQ=$P(^AUPNVCPT(I,0),U,16)  ;reset quantity if necessary
 .;get providers for this cpt code
 .K APCLPROV
 .S P="",Q=""
 .I APCLF=9000010.08 D  I P,'Q S APCLPROV(P)="" G SETP
 ..S P=$P(^AUPNVPRC(APCLI,0),U,11)
 ..Q:P
 ..S P=$P($G(^AUPNVPRC(APCLI,12)),U,4)
 ..Q:'P
 ..I APCLPRIM="P",P'=$$PRIMPROV^APCLV($P(^AUPNVPRC(APCLI,0),U,3),"I") S Q=1  ;don't want this cpt or provider as it isn't the primary provider
 .I APCLF=9000010.22 D  I P,'Q S APCLPROV(P)="" G SETP
 ..S P=$P($G(^AUPNVRAD(APCLI,12)),U,4)
 ..Q:'P
 ..I APCLPRIM="P",P'=$$PRIMPROV^APCLV($P(^AUPNVRAD(APCLI,0),U,3),"I") S Q=1  ;don't want this cpt or provider as it isn't the primary provider
 .I APCLF=9000010.18 D  I P,'Q S APCLPROV(P)="" G SETP
 ..S P=$P($G(^AUPNVCPT(APCLI,12)),U,4)
 ..Q:'P
 ..I APCLPRIM="P",P'=$$PRIMPROV^APCLV($P(^AUPNVCPT(APCLI,0),U,3),"I") S Q=1  ;don't want this cpt or provider as it isn't the primary provider
 .;
 .;check all provider since none documented in the v file
 .S APCLY=0 F  S APCLY=$O(^AUPNVPRV("AD",APCLVIEN,APCLY)) Q:APCLY'=+APCLY  D
 ..Q:'$D(^AUPNVPRV(APCLY,0))
 ..I APCLPRIM="P",$P(^AUPNVPRV(APCLY,0),U,4)'="P" Q
 ..S APCLPROV($P(^AUPNVPRV(APCLY,0),U))=""
 .I '$D(APCLPROV),$P(APCLVREC,U,7)="I" D  ;get providers from the H visit
 ..S V=$P(APCLVREC,U,12)
 ..Q:V=""
 ..S APCLY=0 F  S APCLY=$O(^AUPNVPRV("AD",V,APCLY)) Q:APCLY'=+APCLY  D
 ...Q:'$D(^AUPNVPRV(APCLY,0))
 ...I APCLPRIM="P",$P(^AUPNVPRV(APCLY,0),U,4)'="P" Q
 ...S APCLPROV($P(^AUPNVPRV(APCLY,0),U))=""
SETP .;
 .S APCLY=0 F  S APCLY=$O(APCLPROV(APCLY)) Q:APCLY'=+APCLY  D
 ..S APCLPN=$P($G(^VA(200,APCLY,0)),U) I APCLPN="" S APCLPN="????????"
 ..S APCLDISC=$$VAL^XBDIQ1(200,APCLY,53.5) I APCLDISC="" S APCLDISC="?????"
 ..D SET
 .I '$D(APCLPROV) S APCLPN="NO PROVIDER ENTERED, UNKNOWN",APCLDISC="?????",APCLY=9999999 D SET
 .Q
 Q
SET ;
 I "AOS"[$P(APCLVREC,U,7) S ^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLY,APCLDISC,"OUTPATIENT",APCLC,APCLN)=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLY,APCLDISC,"OUTPATIENT",APCLC,APCLN))+APCLQ
 I "HI"[$P(APCLVREC,U,7) S ^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLY,APCLDISC,"INPATIENT",APCLC,APCLN)=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLY,APCLDISC,"INPATIENT",APCLC,APCLN))+APCLQ
 I "AOS"[$P(APCLVREC,U,7) S ^XTMP("APCLCPT1",APCLJ,APCLH,"OUTPATIENT",APCLPN,APCLY,APCLDISC)=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"OUTPATIENT",APCLPN,APCLY,APCLDISC))+1
 I "HI"[$P(APCLVREC,U,7) S ^XTMP("APCLCPT1",APCLJ,APCLH,"INPATIENT",APCLPN,APCLY,APCLDISC)=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"INPATIENT",APCLPN,APCLY,APCLDISC))+1
 Q:$D(^XTMP("APCLCPT1",APCLJ,APCLH,"DFN",APCLPN,APCLY,APCLDISC,DFN))
 S ^XTMP("APCLCPT1",APCLJ,APCLH,"DFN",APCLPN,APCLY,APCLDISC,DFN)=""
 S ^XTMP("APCLCPT1",APCLJ,APCLH,"PATIENTS",APCLPN,APCLY,APCLDISC)=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"PATIENTS",APCLPN,APCLY,APCLDISC))+1
 Q
PRINT ;
 I APCLROT="D" G DEL
 D PRINT1
 I APCLROT'="B" D DONE Q
DEL ;create delimited output file
 D ^%ZISC ;close printer device
 K ^TMP($J)
 D ^APCLCPTD ;create ^tmp of delimited report
 K ^TMP($J)
 D DONE
 Q
PRINT1 ;EP - called from xbdbque
 S APCLPG=0 K APCLQUIT
 I '$D(^XTMP("APCLCPT1",APCLJ,APCLH)) D HEADER W !!,"No data to report.",! G DONE
 S APCLPN="" F  S APCLPN=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN)) Q:APCLPN=""!($D(APCLQUIT))  D
 .S APCLPIEN=0 F  S APCLPIEN=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN)) Q:APCLPIEN'=+APCLPIEN!($D(APCLQUIT))  D
 ..D HEADER
 ..W !!,"Provider Name",?55,"Discipline"
 ..S APCLDISC=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,""))
 ..W !,APCLPN,?55,APCLDISC
 ..I APCLOI="B"!(APCLOI="O") D
 ...D AMBHDR
 ...S APCLY="" F  S APCLY=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"OUTPATIENT",APCLY)) Q:APCLY=""!($D(APCLQUIT))  D
 ....I $Y>(IOSL-5) D HEADER,AMBHDR
 ....S APCLN="" F  S APCLN=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"OUTPATIENT",APCLY,APCLN)) Q:APCLN=""!($D(APCLQUIT))  D PRNO
 ..;INPATIENT
 ..I APCLOI="B"!(APCLOI="I") D
 ...I $Y>(IOSL-5) D HEADER
 ...D INPHDR
 ...S APCLY="" F  S APCLY=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"INPATIENT",APCLY)) Q:APCLY=""!($D(APCLQUIT))  D
 ....I $Y>(IOSL-5) D HEADER,INPHDR
 ....S APCLN="" F  S APCLN=$O(^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"INPATIENT",APCLY,APCLN)) Q:APCLN=""!($D(APCLQUIT))  D PRNI
 ..;TOTALS
 ..I $Y>(IOSL-8) D HEADER
 ..I APCLOI="B"!(APCLOI="O") D
 ...S APCLCNT=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"OUTPATIENT",APCLPN,APCLPIEN,APCLDISC))
 ...W !!,"Total Outpatient Visits: ",$$PAD($$C(APCLCNT,0,7),7)
 ..I APCLOI="B"!(APCLOI="I") D
 ...S APCLCNT=$G(^XTMP("APCLCPT1",APCLJ,APCLH,"INPATIENT",APCLPN,APCLPIEN,APCLDISC))
 ...W !!,"Total Inpatient Services: ",$$PAD($$C(APCLCNT,0,7),7)
 ..W !!,"Total Patients:  ",$$PAD($$C(APCLCNT,0,7),7)
 .Q
 Q
PRNO ;
 I $Y>(IOSL-2) D HEADER
 S APCLCNT=^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"OUTPATIENT",APCLY,APCLN)
 W !,APCLY,?11,APCLN,?55,$$PAD($$C(APCLCNT,0,7),7)
 Q
PRNI ;
 I $Y>(IOSL-2) D HEADER
 S APCLCNT=^XTMP("APCLCPT1",APCLJ,APCLH,"CPTS",APCLPN,APCLPIEN,APCLDISC,"INPATIENT",APCLY,APCLN)
 W !,APCLY,?11,APCLN,?55,$$PAD($$C(APCLCNT,0,7),7)
 Q
AMBHDR ;
 W !!,"Ambulatory/Outpatient Services:"
 W !!,"CPT Code",?11,"CPT Narrative",?50,"# Subtotaled by CPT"
 Q
INPHDR ;
 W !!,"Inpatient Services:"
 W !!,"CPT Code",?11,"CPT Narrative",?50,"# Subtotaled by CPT"
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  CPT Code by Provider Report  ***",80),!
 S X="Visit Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 Q
DONE ;
 K ^XTMP("APCLCPT1",APCLJ,APCLH)
 ;D EOP
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
A ;
 Q
L ;one location
 S APCLLOC=""
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOC=+Y
 Q
S ;
 S APCLSU=""
 S DIC="^AUTTSU(",DIC(0)="AEMQ",DIC("A")="Which SERVICE UNIT: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLSU=+Y
 Q
T ;
 S APCLTRIB=""
 S DIC="^AUTTTRI(",DIC(0)="AEMQ",DIC("A")="Which TRIBE: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLTRIB=+Y
 Q
PT ;EP
 S (APCLROT,APCLDELT,APCLDELF)=""
 W !!,"Please choose an output type.  For an explanation of the delimited",!,"file please see the user manual.",!
 S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);B:Both a Printed Report and Delimited File",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQ="" Q
 S APCLROT=Y
 Q:APCLROT="P"
 S APCLDELF="",APCLDELT=""
 W !!,"You have selected to create a delimited output file.  You can have this",!,"output file created as a text file in the pub directory, ",!,"OR you can have the delimited output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to",!,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to a file in pub",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S APCLDELT=Y
 Q:APCLDELT="S"
 S DIR(0)="F^1:40",DIR("A")="Enter a filename for the delimited output (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S APCLDELF=Y
 S APCLHDIR=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:$G(^XTV(8989.3,1,"DEV")))
 I $G(APCLHDIR)="" S APCLHDIR="/usr/spool/uucppublic/"
 W !!,"When the report is finished your delimited output will be found in the",!,APCLHDIR," directory.  The filename will be ",APCLDELF,".txt",!
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 S L=L-$L(D)
 Q $E($$REPEAT^XLFSTR(" ",L),1,L)_D
