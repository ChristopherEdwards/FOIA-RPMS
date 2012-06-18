APCLOP1 ; IHS/CMI/LAB - list procedures and tally operation provider ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in PROC1,PRINT
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("LISTING/TALLY OF OF VISITS WITH SELECTED PROCEDURE CODES",80)
 W !!,"This report will tally the operating provider for selected procedures"
 W !,"done.  You can optionally get a list of all the visits with these"
 W !,"procedures."
 W !
 D EOJ
 S APCLH=$H,APCLJ=$J
 K ^XTMP("APCLOP1",APCLJ,APCLH)
 D XTMP^APCLOSUT("APCLOP1","PROCEDURES REPORT")
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
SC ;type of refusal all or one?
 K APCLSCT
 K APCLSC,APCLSCT W ! S DIR(0)="YO",DIR("A")="Include ALL Visit Service Categories",DIR("B")="Yes"
 S DIR("?")="If you wish to include all visit service categories (Ambulatory,Hospitalization,etc) answer Yes.  If you wish to list visits for only one service category enter NO." D ^DIR K DIR
 G:$D(DIRUT) DATES
 I Y=1 G FAC
SC1 ;enter sc
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G DATES
 D PEP^AMQQGTX0(+Y,"APCLSCT(")
 I '$D(APCLSCT) G SC
 I $D(APCLSCT("*")) K APCLSCT
FAC ;
 S APCLLOCT=""
 S DIR(0)="S^A:ALL Locations/Facilities;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCLLOCT=Y
 I APCLLOCT="A" G OPCODE
 D O
 G:APCLLOC="" FAC
OPCODE ;
 S APCLICD=""
 K ^XTMP("APCLOP1",APCLJ,APCLH,"ICD")
 S DIR(0)="S^A:ALL Procedures;S:Selected Set of ICD Procedure codes",DIR("A")="Include which ICD Procedurs in the Report"
 S DIR("A")="Enter a code indicating what ICD Procedure codes are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FAC
 S APCLICD=Y
 I APCLICD="A" G LIST
 D ^XBFMK
 S X="PROCEDURE (MEDICAL)",DIC="^AMQQ(5,",DIC(0)="",DIC("S")="I $P(^(0),U,14)"
 D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G EOJ
 D PEP^AMQQGTX0(+Y,"^XTMP(""APCLOP1"",APCLJ,APCLH,""ICD"",")
 I '$D(^XTMP("APCLOP1",APCLJ,APCLH,"ICD")) G FAC
 I $D(^XTMP("APCLOP1",APCLJ,APCLH,"ICD","*")) S APCLICD="A"
LIST ;
 S APCLLIST=0 W ! S DIR(0)="YO",DIR("A")="Do you want a List of all the procedures in addition to the tally",DIR("B")="Yes"
 S DIR("?")="If you wish to include a list of all procedures, enter yes" D ^DIR K DIR
 G:$D(DIRUT) OPCODE
 S APCLLIST=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G LIST
 S XBRP="PRINT^APCLOP1",XBRC="PROC^APCLOP1",XBRX="EOJ^APCLOP1",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
EOJ ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
PROC ;
 S APCLCNTV=0,APCLCNTP=0,APCLCNTD=0 K APCLOPRV,APCLOPRC
 ; Run by visit date
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 S APCLODAT=APCLSD_".9999" F  S APCLODAT=$O(^AUPNVSIT("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D V1
 Q
V1 ;
 S APCLVIEN="" F  S APCLVIEN=$O(^AUPNVSIT("B",APCLODAT,APCLVIEN)) Q:APCLVIEN'=+APCLVIEN  I $D(^AUPNVSIT(APCLVIEN,0)),$P(^(0),U,9),'$P(^(0),U,11) D PROC1
 Q
PROC1 ;
 Q:'$D(^AUPNVPRC("AD",APCLVIEN))  ;no procedures
 S X=$P(^AUPNVSIT(APCLVIEN,0),U,7)
 Q:X=""
 I $D(APCLSCT),'$D(APCLSCT(X)) Q
 S X=$P(^AUPNVSIT(APCLVIEN,0),U,6) Q:X=""
 S X=$P(^AUPNVSIT(APCLVIEN,0),U,5) Q:X=""  Q:$$DEMO^APCLUTL(X,$G(APCLDEMO))
 I APCLLOCT="O" Q:X'=APCLLOC
 ;loop through procedures
 S APCLPIEN=0 F  S APCLPIEN=$O(^AUPNVPRC("AD",APCLVIEN,APCLPIEN)) Q:APCLPIEN'=+APCLPIEN  D
 .S APCLIPTR=0 S APCLIPTR=$P(^AUPNVPRC(APCLPIEN,0),U) Q:'APCLIPTR  Q:'$D(^ICD0(APCLIPTR,0))
 .I APCLICD="S",'$D(^XTMP("APCLOP1",APCLJ,APCLH,"ICD",APCLIPTR)) Q
 .S ^XTMP("APCLOP1",APCLJ,APCLH,"VISITS",$P($P(^AUPNVSIT(APCLVIEN,0),U),"."),APCLVIEN,APCLPIEN)=""
 .S X=$P(^AUPNVPRC(APCLPIEN,0),U,11)
 .I X="" S X="UNKNOWN",Y="??" I 1
 .E  S Y=X,X=$P(^VA(200,X,0),U)
 .;S P=$P(^ICD0(APCLIPTR,0),U)  ;cmi/anch/maw 9/12/2007 orig line
 .S P=$P($$ICDOP^ICDCODE(APCLIPTR),U,2) ;cmi/anch/maw 9/12/2007 csv
 .S APCLOPRV(X,Y,P,APCLIPTR)=$G(APCLOPRV(X,Y,P,APCLIPTR))+1,APCLOPRV(X,Y,"TOTAL")=$G(APCLOPRV(X,Y,"TOTAL"))+1
 .S APCLCNTP=APCLCNTP+1
 .S APCLOPRC(P,APCLIPTR,X,Y)=$G(APCLOPRC(P,APCLIPTR,X,Y))+1,APCLOPRC(P,APCLIPTR,"TOTAL")=$G(APCLOPRC(P,APCLIPTR,"TOTAL"))+1
 Q
 ;
PRINT ;EP - called from xbdbque
 S APCLPG=0 K APCLQUIT
 I '$D(^XTMP("APCLOP1",APCLJ,APCLH)) D HEADER W !!,"No data to report.",! G DONE
 D HEADER
 W !,$TR($J("",80)," ","-")
 W !!,"Total # of Procedures: ",?50,$$PAD($$C(APCLCNTP,0,7),7)
 W !!,"Tally BY Operating Providers:"
 W !?3,"Operating Provider",?50,"# of Procedures"
 S APCLP=0 F  S APCLP=$O(APCLOPRV(APCLP)) Q:APCLP=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-6) D HEADER
 .W !!,APCLP
 .S APCLY="" F  S APCLY=$O(APCLOPRV(APCLP,APCLY)) Q:APCLY=""!($D(APCLQUIT))  D
 ..S APCLX="" F  S APCLX=$O(APCLOPRV(APCLP,APCLY,APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 ...Q:APCLX="TOTAL"
 ...S APCLI=$O(APCLOPRV(APCLP,APCLY,APCLX,0))
 ...;W !?5,APCLX,?12,$E($P(^ICD0(APCLI,0),U,4),1,25),?50,$$PAD($$C(APCLOPRV(APCLP,APCLY,APCLX,APCLI),0,7),7)  ;cmi/anch/maw 9/12/2007 orig line
 ...W !?5,APCLX,?12,$E($P($$ICDOP^ICDCODE(APCLI),U,5),1,25),?50,$$PAD($$C(APCLOPRV(APCLP,APCLY,APCLX,APCLI),0,7),7)  ;cmi/anch/maw 9/12/2007 csv
 ..W !?3,"Total # Procedures for ",$E(APCLP,1,20),?50,$$PAD($$C(APCLOPRV(APCLP,APCLY,"TOTAL"),0,7),7)
 .Q
 D HEADER
 W !,$TR($J("",80)," ","-")
 W !!,"Tally BY ICD Procedure Code:"
 W !?3,"Procedure",?50,"# of Procedures"
 S APCLP="" F  S APCLP=$O(APCLOPRC(APCLP)) Q:APCLP=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-6) D HEADER
 .S APCLI=$O(APCLOPRC(APCLP,0))
 .;W !!,APCLP,?7,$E($P(^ICD0(APCLI,0),U,4),1,25),?50,$$PAD($$C(APCLOPRC(APCLP,APCLI,"TOTAL"),0,7),7)  ;cmi/anch/maw 9/12/2007 orig line
 .W !!,APCLP,?7,$E($P($$ICDOP^ICDCODE(APCLI),U,5),1,25),?50,$$PAD($$C(APCLOPRC(APCLP,APCLI,"TOTAL"),0,7),7)  ;cmi/anch/maw 9/12/2007 csv
 .S APCLY="" F  S APCLY=$O(APCLOPRC(APCLP,APCLI,APCLY)) Q:APCLY=""!($D(APCLQUIT))  D
 ..Q:APCLY="TOTAL"
 ..S APCLX="" F  S APCLX=$O(APCLOPRC(APCLP,APCLI,APCLY,APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 ...W !?5,APCLY,?50,$$PAD($$C(APCLOPRC(APCLP,APCLI,APCLY,APCLX),0,7),7)
 ..;W !?3,"Total # Procedures for ",$E(APCLP,1,20),?50,$$PAD($$C(APCLOPRV(APCLP,APCLY,"TOTAL"),0,7),7)
 .Q
 I 'APCLLIST D DONE Q
 D HEADER,H1
 S APCLDATE=0 F  S APCLDATE=$O(^XTMP("APCLOP1",APCLJ,APCLH,"VISITS",APCLDATE)) Q:APCLDATE'=+APCLDATE!($D(APCLQUIT))  D P1
 D DONE
 Q
P1 ;
 S APCLV="" F  S APCLV=$O(^XTMP("APCLOP1",APCLJ,APCLH,"VISITS",APCLDATE,APCLV)) Q:APCLV=""!($D(APCLQUIT))  D
 .S DFN=$P(^AUPNVSIT(APCLV,0),U,5)
 .I $Y>(IOSL-4) D HEADER,H1
 .W !,$E($P(^DPT(DFN,0),U),1,21),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$$FMTE^XLFDT($$DOB^AUPNPAT(DFN),5),?40,$$FMTE^XLFDT($P($P(^AUPNVSIT(APCLV,0),U),"."),5),?51,$P(^AUPNVSIT(APCLV,0),U,7)
 .W ?53,$E($P(^AUTTLOC($P(^AUPNVSIT(APCLV,0),U,6),0),U,7),1,5)
 .S APCLPIEN=0,C=0 F  S APCLPIEN=$O(^XTMP("APCLOP1",APCLJ,APCLH,"VISITS",APCLDATE,APCLV,APCLPIEN)) Q:APCLPIEN'=+APCLPIEN!($D(APCLQUIT))  D
 ..S C=C+1 W:C>1 ! W ?58,$$VAL^XBDIQ1(9000010.08,APCLPIEN,.01),?64,$E($$VAL^XBDIQ1(9000010.08,APCLPIEN,.11),1,15)
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  PROCEDURE TALLY/LISTING  ***",80),!
 S X="Visit Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W "Service Categories: "
 I '$D(APCLSCT) W "ALL"
 I $D(APCLSCT) S X="" F  S X=$O(APCLSCT(X)) Q:X=""  W X," ;"
 W !,"Procedures included in this report:"
 I APCLICD="A" W "  ALL ICD PROCEDURES" Q
 ;S C=0,X=0 F  S X=$O(^XTMP("APCLOP1",APCLJ,APCLH,"ICD",X)) Q:X'=+X!(C>50)  W " ",$P(^ICD0(X,0),U) S C=C+1  ;cmi/anch/maw 9/12/2007 orig line
 S C=0,X=0 F  S X=$O(^XTMP("APCLOP1",APCLJ,APCLH,"ICD",X)) Q:X'=+X!(C>50)  W " ",$P($$ICDOP^ICDCODE(X),U,2) S C=C+1  ;cmi/anch/maw 9/12/2007 csv
 I C>50 W "  ....ETC"
 Q
H1 W !,"PATIENT NAME",?22,"HRN",?29,"DOB",?40,"VST DATE",?51,"SC",?54,"LOC",?58,"ICD",?64,"Operating Prov"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^XTMP("APCLOP1",APCLJ,APCLH)
 D EOP
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
O ;one location
 S APCLLOC=""
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOC=+Y
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 S L=L-$L(D)
 Q $E($$REPEAT^XLFSTR(" ",L),1,L)_D
