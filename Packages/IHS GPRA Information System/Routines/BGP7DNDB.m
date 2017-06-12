BGP7DNDB ; IHS/CMI/LAB - NATL COMP EXPORT 13 Nov 2006 12:31 PM 17 Apr 2017 11:15 AM ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
 ;
 W:$D(IOF) @IOF
INTRO ;
 D XIT
 W !
 S Y=$O(^BGPCTRL("B",2017,0))
 S X=0 F  S X=$O(^BGPCTRL(Y,88,X)) Q:X'=+X  W !,^BGPCTRL(Y,88,X,0)
 W !
 ;K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 ;
 ;
 D TAXCHK^BGP7XTCN
 S X=$$DEMOCHK^BGP7UTL2()
 I 'X W !!,"Exiting Report....." D PAUSE^BGP7DU,XIT Q
TP ;get time period
 D XIT
PROV ;RUN FOR FACILITY OR ONE PROVIDER
 S BGPRPF=""
 S DIR(0)="S^F:Entire Facility;P:Designated Provider(s)",DIR("A")="Run report for",DIR("B")="F" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPRPF=Y
 I BGPRPF="F" G NEXT
PNST ;
 K BGPDESPG
 W !!,"You can enter individual provider names or a TAXONOMY of providers."
 K DIR
 S DIR(0)="S^P:Provider's Names;T:Taxonomy of Providers",DIR("A")="Do you want to enter",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No providers selected.  Exiting report..." D PAUSE^BGP7DU,XIT Q
 S BGPXX=Y
 I BGPXX="T" D  I '$O(BGPDESGP(0)) W !!,"No providers selected.  Exiting report..." D PAUSE^BGP7DU,XIT Q
 .S DIC("S")="I $P(^(0),U,15)=200" S DIC="^ATXAX(",DIC("A")="Enter Provider TAXONOMY name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 .I Y=-1 Q
 .W !!,"TAXONOMY contains:",!
 .S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X'=+X  S BGPDESGP(X)="" W ?5,$P(^VA(200,X,0),U),!
 .Q
 I BGPXX="P" D  I '$O(BGPDESGP(0)) W !!,"No providers selected.  Exiting report..." D PAUSE^BGP7DU,XIT Q
P .K DIC S DIC="^VA(200,",DIC("A")="Enter "_$S($O(BGPDESGP(0)):"another ",1:"")_"Provider's name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 .I Y=-1 Q
 .S BGPDESGP(+Y)="" ;W ?5,$P(^VA(200,X,0),U),!
 .G P
NEXT ;
 S BGPRTYPE=1,BGPYRPTH="",BGPDASH=1
 S X=$O(^BGPCTRL("B",2017,0))
 S Y=^BGPCTRL(X,0)
 S BGPBD=$P(Y,U,8),BGPED=$P(Y,U,9)
 S BGPPBD=$P(Y,U,10),BGPPED=$P(Y,U,11)
 S BGPBBD=$P(Y,U,12),BGPBED=$P(Y,U,13)
 S (BGPPER,BGPDASHY)=$P(Y,U,14),BGPDASHP=$E(BGPPED,1,3)_"0000"
 ;BEGIN TEST STUFF
 G NT  ;comment out when testing in TEHR
 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:January 1 - December 31;2:April 1 - March 31;3:July 1 - June 30;4:October 1 - September 30;5:User-Defined Report Period",DIR("A")="Enter the date range for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPQTR=Y
 I BGPQTR=5 D ENDDATE^BGP7DGPU
 I BGPQTR'=5 D F
 I BGPPER="" W !,"Year not entered.",! G TP
 I BGPQTR=1 S BGPBD=$E(BGPPER,1,3)_"0101",BGPED=$E(BGPPER,1,3)_"1231"
 I BGPQTR=2 S BGPBD=($E(BGPPER,1,3)-1)_"0401",BGPED=$E(BGPPER,1,3)_"0331"
 I BGPQTR=3 S BGPBD=($E(BGPPER,1,3)-1)_"0701",BGPED=$E(BGPPER,1,3)_"0630"
 I BGPQTR=4 S BGPBD=($E(BGPPER,1,3)-1)_"1001",BGPED=$E(BGPPER,1,3)_"0930"
 I BGPQTR=5 S BGPBD=$$FMADD^XLFDT(BGPPER,-364),BGPED=BGPPER,BGPPER=$E(BGPED,1,3)_"0000"
 S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7),BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 S (BGPDASHY)=BGPPER,BGPDASHP=$E(BGPPED,1,3)_"0000"
 I BGPED>DT D  G:BGPDO=1 TP
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
NT ;END TEST STUFF
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
COMM ;
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BGPTAX
 S BGPTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC K DIC
 I Y=-1 D XIT Q
 S BGPTAXI=+Y
COM1 ;
 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(BGPTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but was not",!,"found in the standard community table." S G=1
 .Q
 I G D  I BGPQUIT D XIT Q
 .W !!,"These communities may have been renamed or there may be patients"
 .W !,"who have been reassigned from this community to a new community and this"
 .W !,"could reduce your patient population."
 .S BGPQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you want to cancel the report and review the communities" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1
 .I Y S BGPQUIT=1
 .Q
 K BGPQUIT
BEN ;
 S BGPBEN=1
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
AI ;gather all gpra measures
 ;F X=1:100 I $D(^BGPINDG("GPRA",1,X)) S BGPIND(X)=""
 S X=0 F  S X=$O(^BGPINDG("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 S BGPINDG="G"
EXPORT ;export to area or not?
 S BGPEXPT=""
 ;S DIR(0)="Y",DIR("A")="Do you wish to export this data to Area" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G COMM
EISSEX ;
 S BGPEXCEL=""
 S BGPUF=$$GETDIR^BGP7UTL2()
 I BGPUF="" W !!!,"Cannot find export or pub directory.  Notify your IT staff." D XIT Q
 ;
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF NATIONAL GPRA/GPRAMA DASHBOARD REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 ;W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 D PT^BGP7DSL
 I BGPRPF="P",BGPROT="D"!(BGPROT="B"),BGPDELT="F" D
 .W !!,"Please NOTE:  Your filenames will be:"
 .S X=0,Y=BGPDELF F  S X=$O(BGPDESGP(X)) Q:X'=+X  D
 ..S J=BGPDELF_"_"_$E($P($P(^VA(200,X,0),U),","),1,9)_X
 ..W !?5,J
 ..S $P(BGPDESGP(X),U,2)=J
 I BGPROT="" G COMM
ZIS ;call to XBDBQUE
 I BGPRPF="P" S BGPXX=0 F  S BGPXX=$O(BGPDESGP(BGPXX)) Q:BGPXX'=+BGPXX  D
 .D REPORT^BGP7UTL
 .S $P(BGPDESGP(BGPXX),U,1)=BGPRPT
 I BGPRPF="F" D REPORT^BGP7UTL
 I $G(BGPQUIT) D XIT Q
 I BGPRPT="" D XIT Q
 K IOP,%ZIS I BGPROT="D",BGPDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(BGPDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP,BGPRPF="F" D  D XIT Q
 .W !,"Report Aborted." S DA=BGPRPT,DIK="^BGPGPDCG(" D ^DIK K DIK
 .S DA=BGPRPT,DIK="^BGPGPDPG(" D ^DIK K DIK
 .S DA=BGPRPT,DIK="^BGPGPDBG(" D ^DIK K DIK
 I POP,BGPRPF="P" D  D XIT Q
 .W !,"Report Aborted."
 .S BGPXX=0 F  S BGPXX=$O(BGPDESGP(BGPXX)) Q:BGPXX'=+BGPXX  S BGPRPT=BGPDESGP(BGPXX) D
 ..S DA=BGPRPT,DIK="^BGPGPDCG(" D ^DIK K DIK
 ..S DA=BGPRPT,DIK="^BGPGPDPG(" D ^DIK K DIK
 ..S DA=BGPRPT,DIK="^BGPGPDBG(" D ^DIK K DIK
 I $D(IO("Q")) G TSKMN
DRIVER ;
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^BGP7D1
 U IO
 D ^BGP7DP
 D ^%ZISC
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGP7DNDB",XBRX="XIT^BGP7DNDB",XBNS="BGP"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D ^BGP7D1
 D ^BGP7DP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP7DNDB",ZTDTH="",ZTDESC="NATIONAL GPRA REPORT 11" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR KILL DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
CHKY ;
 W !!,"The baseline year and the previous year time periods are the same.",!!
 S DIR(0)="Y",DIR("A")="Do you want to change the baseline year",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S Y="" Q
 Q
F ;fiscal year
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the year for the report.  Use a 4 digit ",!,"year, e.g. 2017"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S BGPPER=BGPVDT
 Q
B ;fiscal year
 S (BGPBPER,BGPVDT)=""
 W !!,"Enter the BASELINE year for the report.  Use a 4 digit ",!,"year, e.g. 2010"
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
FY ;calendar year
 S (BGPPER,BGPVDT,BGPNGR09)=""
 S DIR(0)="D^::EP"
 S DIR("A")="Run report for GPRA year 2017 or 2018"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 ;I Y'=3170000,Y'=3180000 W !,"Must be 2017 or 2018" G FY   ;LORI
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G FY
 S BGPPER=BGPVDT
 I BGPPER="3180000" S BGPNGR09=1
 Q
