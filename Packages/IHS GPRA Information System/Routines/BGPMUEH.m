BGPMUEH ; IHS/MSC/JSM/SAT - IHS MU HOSPITAL PERFORMANCE MEASURE REPORT FRONT-END ;02-Mar-2011 16:48;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
ENTRY ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS Meaningful Use Clinical Quality Measure Report",80)
 W !,$$CTR("Report on all Patients regardless of Community of Residence",80),!!
 D MUCHECK^BGPMUEP
 Q:BGPQUIT
INTRO ;
 D XIT
 W !,"This will produce a Clinical Quality Measure Report for one or more measures"
 W !,"for a period you specify.  You will be asked to provide: 1) the length of the"
 W !,"reporting period , 2) the desired start date for your reporting period and,"
 W !,"3) the baseline period to compare data to."
SETIND ;
 D XIT
 S BGPINDT=""
 S BGPMUYF="90595.11"
 S BGPRTYPE=4,BGP0RPTH="A"
 S BGPMUT="H" ; BGPMU Hospital Measures
TP ;get time period
 S BGPRTYPE=4,BGP0RPTH="A"
 S (BGPBD,BGPED,BGPTP)=""
 S DIR(0)="S^1:90-Days;2:One Year",DIR("A")="Enter the reporting period length for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPLEN=$S(Y=1:89,1:364)
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the reporting period start date."
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Date"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 S BGPPER=BGPVDT
 I BGPPER="" W !,"Start date not entered.",! G TP
 ;Setup: BGPBD - begin date & BGPED - end date
 S BGPBD=BGPPER
 S:$E(BGPBD,4,7)="0000" $E(BGPBD,4,7)="0101"
 S BGPED=$$FMADD^XLFDT(BGPPER,BGPLEN)
 ;I BGPLEN=90 S BGPMON=$E(BGPPER,4,5)+3 S:BGPMON<10 BGPMON="0"_BGPMON S BGPED=$E(BGPPER,1,3)_BGPMON_$E(BGPPER,6,7)
 ;I BGPLEN=365 S BGPED=($E(BGPPER,1,3)+1)_$E(BGPPER,4,7)
 I BGPED>DT D  G:BGPDO=1 TP
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(BGPBD)," through ",$$FMTE^XLFDT(BGPED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S BGPDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPDO=1 Q
 .I Y S BGPDO=1 Q
 .Q
BY ;get previous  year
 N X1,X2,X
 S X1=$E(BGPBD),X2=$E(BGPBD,2,3)
 S X2=X2-1
 I $L(X2)=1 S X2="0"_X2
 I X2>$E(BGPBD,2,3) S X1=X1-1
 S BGPPBD=X1_X2_$E(BGPBD,4,7)
 S X1=$E(BGPED),X2=$E(BGPED,2,3)
 S X2=X2-1
 I $L(X2)=1 S X2="0"_X2
 I X2>$E(BGPED,2,3) S X1=X1-1
 S BGPPED=X1_X2_$E(BGPED,4,7)
 ;get baseline year
 S BGPVDT=""
 W !!,"Enter the Baseline Year to compare data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 2000)"
 D ^DIR KILL DIR
 I $D(DIRUT) G TP
 I $D(DUOUT) S DIRUT=1 G TP
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S X=$E(BGPPER,1,3)-$E(BGPVDT,1,3)
 S X=X_"0000"
 S BGPBBD=BGPBD-X,BGPBBD=$E(BGPBBD,1,3)_$E(BGPBD,4,7)
 S BGPBED=BGPED-X,BGPBED=$E(BGPBED,1,3)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
EP ;
 W !!
 S DIR(0)="ST^HOS:All Hospital Measures;SEL:Selected Measures (User Defined)"
 S DIR("A")="Which set of Measures should be included in this report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BGPINDT=$E(Y)
 I BGPINDT="S" D SI I '$D(BGPIND) G SETIND
GI ;gather all measures
 I BGPINDT="H" D HI
 I '$D(BGPIND) W !!,"no measures selected" G SETIND
COMM ;
 ;I BGPINDT'="S" D LISTS
BEN ;
 S BGPBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="3"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPBEN=Y
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF MEANINGFUL USE CLINICAL QUALITY MEASURE REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
 W !!,"ALL Patients will be included."
 W !!,"These measures will be calculated: " S X=0 F  S X=$O(BGPIND(X)) Q:X'=+X  W !,?10,$P(^BGPMUIND(BGPMUYF,X,0),U,3)
 W !!,"Lists will be produced for these measures: "
 S X=0 F  S X=$O(BGPLIST(X)) Q:X'=+X  W !,?10,$P(^BGPMUIND(BGPMUYF,X,0),U,3)
 D PH^BGPMUDSL
 I BGPROT="" G LISTS
ZIS ;call to XBDBQUE
 ;D REPORT^BGPMUUTL  ;- I don't think this is necessary since it seems to only handle data export files
 ;I $G(BGPQUIT) D XIT Q
 ;I BGPRPT="" D XIT Q
 K IOP,%ZIS I (BGPROT="D"!(BGPROT="X")),BGPDELT="F" D NODEV,XIT Q
 W !! S %ZIS=$S(BGPDELT'="S":"QM",1:"M") D ^%ZIS
ZIS1 ;
 ;I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDCT(" D ^DIK K DIK D XIT Q
 ;I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDPT(" D ^DIK K DIK D XIT Q
 ;I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPGPDBT(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 K ^TMP($J)
 D ^BGPMUEHD ;gather data
 U IO
 D ^BGPMUPP ;print/export data
 D ^%ZISC
 K ^TMP($J)
 D XIT
 Q
 ;
NODEV1 ;
 D ^BGPMUEHD  ;gather data
 D ^BGPMUPP  ;print/export data
 D ^%ZISC
 D XIT
 Q
HI ;
 S X=0 F  S X=$O(^BGPMUIND(BGPMUYF,"AMS","H",X)) Q:X'=+X  S BGPIND(X)=""
 D LISTS
 Q
SI ;
 K BGPIND
 D ENH^BGPMUDSI
 I '$D(BGPIND) Q
 D LISTS
 Q
LISTS ;any lists with measures?
 K BGPLIST
 W !!,"PATIENT LISTS"
 I '$D(^XUSEC("BGPZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the BGPZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any of the measures",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") Q
 I Y=0 Q
 K BGPLIST
 D EN^BGPMUDSL
 I '$D(BGPLIST) W !!,"No lists selected.",!
 I $D(BGPLIST) D RT^BGPMUDSL I '$D(BGPLIST)!($D(BGPQUIT)) G LISTS ;get report type for each list
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGPMUEH",ZTDTH="",ZTDESC="MU PERF MEASURE REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^BGPMUEH",XBRX="XIT^BGPMUEH",XBNS="BGP"
 D ^XBDBQUE
 ;D XIT
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K DFN,IOCPU,IOT
 K XBNS,XBRC,XBRP,XBRX
 K ZTCPU,ZTDESC,ZTIO,ZTQUEUED,ZTRTN,ZTREQ
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
F ;report start date
 S (BGPPER,BGPVDT)=""
 W !!,"Enter the reporting period start date."
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Date"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S BGPVDT=Y
 S BGPPER=BGPVDT
 Q
 ;
TESTC ;capture input data
 ; call with D:$G(^TMP("BGPMU0028B","TEST")=1 TESTC
 ;  DFN      = patient code from VA PATIENT file
 ;  BGPBDATE = begin date of report
 ;  BGPEDATE = end date of report
 ;  BGPPROV   = provider code from NEW PERSON file
 ;  BGPMUTF  = timeframe variable - "C"=current year; "P"=previous year; "B"=baseline year
 ;S ^TMP("BGPMU0028B",$J,"DFN")=DFN
 ;S ^TMP("BGPMU0028B",$J,"BGPBDATE")=BGPBDATE
 ;S ^TMP("BGPMU0028B",$J,"BGPEDATE")=BGPEDATE
 ;S ^TMP("BGPMU0028B",$J,"BGPPROV")=BGPPROV
 ;S ^TMP("BGPMU0028B",$J,"BGPMUTF")=BGPMUTF
 Q
 ;
