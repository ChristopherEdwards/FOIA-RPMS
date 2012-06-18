APCLPDEM ; IHS/CMI/LAB - report of visits re-linked ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;EP - called from option
 D XIT
 W:$D(IOF) @IOF
 W !!,"This option will print a list of all visits for your 'DEMO' patients."
 W !,"The patient visits listed are those for patients whose name begins with"
 W !,"DEMO,PATIENT or who reside in your site defined DEMO patient search template."
 W !!,"You can use this list to delete the visits using the data entry delete"
 W !,"visit option."
 W !
 ;
GETDATES ;
 W !!,"Please enter the range of visit dates for the demo patients."
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCLBD_":DT:EP",DIR("A")="Enter ending Date" S Y=APCLBD D DD^%DT D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X S Y=APCLBD D DD^%DT S APCLBDD=Y S Y=APCLED D DD^%DT S APCLEDD=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G GETDATES
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^APCLPDEM",XBRC="PROC^APCLPDEM",XBNS="APCL*",XBRX="XIT^APCLPDEM"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLPDEM"")"
 S XBNS="APCL",XBRC="PROC^APCLPDEM",XBRX="XIT^APCLPDEM",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROC ;EP - called from xbdbque
 ;loop through all visits in date range and look for DEMO patient visits
 S APCLJOB=$J,APCLTOT=0,APCLBT=$H
 D XTMP("APCLPDEM","DEMO PATIENT VISIT LIST")
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 S APCLODAT=APCLSD_".9999" F  S APCLODAT=$O(^AUPNVSIT("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("B",APCLODAT,APCLV)) Q:APCLV'=+APCLV  D
 ..Q:$P(^AUPNVSIT(APCLV,0),U,11)
 ..Q:$P(^AUPNVSIT(APCLV,0),U,5)=""
 ..Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCLV,0),U,5),$G(APCLDEMO))
 ..S ^XTMP("APCLPDEM",APCLJOB,APCLBT,"VISITS",$P(^AUPNVSIT(APCLV,0),U,5),APCLV)="",APCLTOT=APCLTOT+1
 Q
PRINT ;EP - called from xbdbque
 K APCLQ S APCLPG=0
 I '$D(^XTMP("APCLPDEM",APCLJOB,APCLBT,"VISITS")) D HEADER W !!,"There are no Demo patient visits for that time period.",! Q
 D HEADER
 S APCLP=0 F  S APCLP=$O(^XTMP("APCLPDEM",APCLJOB,APCLBT,"VISITS",APCLP)) Q:APCLP=""!($D(APCLQ))  D
 .S APCLV=0 F  S APCLV=$O(^XTMP("APCLPDEM",APCLJOB,APCLBT,"VISITS",APCLP,APCLV)) Q:APCLV'=+APCLV!($D(APCLQ))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(APCLQ)
 ..W !,$$HRN^AUPNPAT(APCLP,DUZ(2)),?7,$E($P(^DPT(APCLP,0),U),1,22),?29,$$FMTE^XLFDT($P(^AUPNVSIT(APCLV,0),U),1)," (",APCLV,")",?62,$P(^AUPNVSIT(APCLV,0),U,3),?65,$P(^AUPNVSIT(APCLV,0),U,7),?68,$E($$CLINIC^APCLV(APCLV,"E"),1,12)
 W !!,"Total # of Visits: ",APCLTOT,!
 K ^XTMP("APCLPDEM",APCLJOB,APCLBT)
XIT ;
 D EN^XBVK("APCL")
 D KILL^AUPNPAT
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
HEADER ;EP
 I 'APCLPG G HEADER1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?($S(80=132:120,1:72)),"Page ",APCLPG,!
 S APCLTEXT="'DEMO' PATIENT VISITS"
 W !?(80-$L(APCLTEXT)/2),APCLTEXT,!
 S APCLTEXT="Visit Dates:  "_APCLBDD_" and "_APCLEDD
 W ?(80-$L(APCLTEXT)/2),APCLTEXT,!
 W $TR($J(" ",80)," ","-")
 W !,"HRN",?7,"PATIENT",?32,"DATE/TIME (IEN)",?60,"TYPE",?65,"SC",?68,"CLINIC"
 W !,$TR($J(" ",80)," ","-")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
XTMP(N,D) ;EP - set xtmp 0 node
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
 ;
 ;
