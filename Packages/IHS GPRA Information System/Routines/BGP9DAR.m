BGP9DAR ; IHS/CMI/LAB - ihs area GPRA 02 Sep 2004 1:11 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !!,$$CTR(BGPA_" Area Aggregate National GPRA & PART Report",80)
INTRO ;
 D EXIT
TP ;
 S BGPAREAA=1
 S BGPRTYPE=1,BGPBEN=1,BGP9RPTH=""
 S X=$O(^BGPCTRL("B",2009,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S BGPPER=$P(Y,U,14),BGPQTR=3
 G NT  ;comment out when testing in TEHR
 W !!,"for testing purposes only, please enter a report year",!
 D F
 I BGPPER="" W !!,"no year entered..bye" D EXIT Q
 S BGPQTR=3
 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 S BGPPBD=($E(BGPPER,1,3)-1)_"0101",BGPPED=($E(BGPPER,1,3)-1)_"1231"
 W !!,"for testing purposes only, please enter a BASELINE year",!
 D B
 I BGPBPER="" W !!,"no year entered..bye" D EXIT Q
 S BGPBBD=$E(BGPBPER,1,3)_"0101",BGPBED=$E(BGPBPER,1,3)_"1231"
NT ;END TEST STUFF
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
ASU ;
 S BGPSUCNT=0
 S BGPRPTT=""
 S DIR(0)="S^A:AREA Aggregate;F:One Facility",DIR("A")="Run Report for",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EXIT
 S BGPRPTT=Y
 W !!!,"You will now be able to select which sites to use in the",!,"area aggregate/facility report.",!
 S DIR(0)="E",DIR("A")="Press Enter to Continue" KILL DA D ^DIR KILL DIR
 K BGPSUL
 D EN^BGP9ASL
 I '$D(BGPSUL) W !!,"No sites selected" D EXIT Q
 S X=0,C=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S C=C+1
 W !!,"A total of ",C," facilities have been selected.",!!
 ;I C=1 S BGPRPTT="F",BGPSUCNT=1,Y=$O(BGPSUL(0)),X=$P(^BGPGPDCN(Y,0),U,9),X=$O(^AUTTLOC("C",X,0)) I X S BGPSUNM=$P(^DIC(4,X,0),U)
ZIS ;call to XBDBQUE
EISSEX ;
 S BGPEXCEL=$S($G(BGPSUMON):0,1:1)
 S BGPUF=$$GETDIR^BGP9UTL2()
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 ;I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 I BGPEXCEL=1 D
 .S BGPNOW=$$NOW^XLFDT() S BGPNOW=$$NOW^XLFDT() S BGPNOW=$P(BGPNOW,".")_"."_$$RZERO^BGP9UTL($P(BGPNOW,".",2),6)
 .S BGPC=0,X=0 F  S X=$O(BGPSUL(X)) Q:X'=+X  S BGPC=BGPC+1
 .I BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." Q
 .S BGPFGNT1="CRSGPRANT1"_$P(^AUTTLOC(DUZ(2),0),U,10)_2009063000000000_$$D^BGP9UTL(BGPNOW)_"_"_$$LZERO^BGP9UTL(BGPC,6)_".TXT"
 .S BGPFGNT2="CRSGPRANT2"_$P(^AUTTLOC(DUZ(2),0),U,10)_2009063000000000_$$D^BGP9UTL(BGPNOW)_"_"_$$LZERO^BGP9UTL(BGPC,6)_".TXT"
 .S BGPFGNT3="CRSGPRANT3"_$P(^AUTTLOC(DUZ(2),0),U,10)_2009063000000000_$$D^BGP9UTL(BGPNOW)_"_"_$$LZERO^BGP9UTL(BGPC,6)_".TXT"
 .S BGPFGNT4="CRSGPRANT4"_$P(^AUTTLOC(DUZ(2),0),U,10)_2009063000000000_$$D^BGP9UTL(BGPNOW)_"_"_$$LZERO^BGP9UTL(BGPC,6)_".TXT"
 .Q
 S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 I BGPEXCEL D
 .W !!,"A file will be created called ",BGPFGNT1,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 .W !!,"A file will be created called ",BGPFGNT2,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 .W !!,"A file will be created called ",BGPFGNT3,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 .W !!,"A file will be created called ",BGPFGNT4,!,"and will reside in the ",BGPUF," directory. This file can be used in Excel.",!
 . S BGPASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
GI ;gather all gpra measures
 S X=0 F  S X=$O(^BGPINDN("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDT="G"
 D PT^BGP9DSL
 I BGPROT="" G ASU
 ;
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,EXIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP D EXIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 U IO
 D PRINT^BGP9PARP
 I BGPRPTT="A",BGPIFTR=1,BGPEXCEL D GNT1^BGP9UTL
 D ^%ZISC
 D EXIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP9DAR",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D HOME^%ZIS D EXIT Q
 Q
 ;
EXIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 D KILL^AUPNPAT
 D ^XBFMK
 Q
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP9DAR",XBRX="EXIT^BGP9DAR",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D PRINT^BGP9PARP
 I BGPRPTT="A",BGPIFTR,BGPEXCEL D GNT1^BGP9UTL
 D ^%ZISC
 D EXIT
 Q
 ;
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2005"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter BASELINE year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPBPER=BGPVDT
 Q
F ;fiscal year
 S BGPPER=""
 W !
 S BGPVDT=""
 W !,"Enter the Fiscal Year (FY) for the report END date.  Use a 4 digit",!,"year, e.g. 2002, 2005"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter FY"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"1001",BGPED=$E(BGPVDT,1,3)_"0930"
 Q
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
SUMONLY ;EP
 W:$D(IOF) @IOF
 S BGPA=$E($P(^AUTTLOC(DUZ(2),0),U,10),1,2),BGPA=$O(^AUTTAREA("C",BGPA,0)) S BGPA=$S(BGPA:$P(^AUTTAREA(BGPA,0),U),1:"UNKNOWN AREA")
 W !,$$CTR("IHS 2009 Area National GPRA & PART Report Clinical Performance Summaries")
 W !!,"This will produce ONLY the clinical performance summaries for the Area "
 W !,"National GPRA & PART Report for the 2009 GPRA year.  If you want the detailed "
 W !,"information included in the report, including performance measure "
 W !,"definitions and number of patients in each denominator and numerator"
 W !,"you need to run the AGP menu option."
 W !!,"The CRSGPRANT export files will not be created; use the AGP menu option "
 W !,"to run the report that will create these files."
 W !
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" D ^DIR K DIR
 S BGPSUMON=1
 G TP
