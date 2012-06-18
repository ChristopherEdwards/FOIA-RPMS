APCLEL3 ; IHS/CMI/LAB - patients with elder care assessment ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will tally all items from the elder care PCC form.",!
 D EXIT
DATE ;get visit date range for functional assessment
 S (APCLBD,APCLED)=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR K DIR G:Y<1 EXIT S APCLBD=Y
 K DIR S DIR(0)="DO^::EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR K DIR G:Y<1 EXIT S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATE
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DATE
 S XBRP="PRINT^APCLEL3",XBRC="PROC^APCLEL3",XBRX="EXIT^APCLEL3",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PROC ;EP - called from XBDBQUE
 S APCLJOB=$J,APCLBTH=$H,APCLPTOT=0
 K ^XTMP("APCLEL3",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLEL3","ELDER CARE TALLY")
 F X=.04:.01:.09 S ^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",X)="0^0^0^0"
 F X=.11:.01:.16 S ^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",X)="0^0^0^0"
 ;$o through patient file, check age of patient, community, 
 ;# times seen, set demoninator counter by age,sex
 ;check for functional status in date range.  Set numerator cntr
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$$DOD^AUPNPAT(DFN)]""
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .;has pt had functional assessment
 .S X=$$FA(DFN,APCLBD,APCLED)
 .I X="" Q
 .S APCLPTOT=APCLPTOT+1
 .;tally each item
 .S APCLDA=X F APCLX=.04:.01:.09  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) S P=$S(V="":4,V="I":1,V="N":2,V="T":3,1:4),$P(^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLX),U,P)=$P(^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLX),U,P)+1
 .S APCLDA=X F APCLX=.11:.01:.16  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) S P=$S(V="":4,V="I":1,V="N":2,V="T":3,1:4),$P(^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLX),U,P)=$P(^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLX),U,P)+1
 Q
 ;
FA(P,B,E) ;
 I '$G(P) Q ""
 I '$D(^AUPNVELD("AC",P)) Q ""
 NEW X,Y,D,G
 K G S X=0,G="" F  S X=$O(^AUPNVELD("AC",P,X)) Q:X'=+X  D
 .S V=$P(^AUPNVELD(X,0),U,3),D=$P($P(^AUPNVSIT(V,0),U),".")
 .Q:D<B
 .Q:D>E
 .S G(9999999-D)=X
 .Q
 I $O(G(0))="" Q ""
 S X=0,X=$O(G(X)) Q G(X)
NUMV(P,E) ;
 I '$G(P) Q ""
 ;calcualte 3 yrs prior to E
 NEW B
 S B=$$FMADD^XLFDT(E,-(3*365))
 NEW X,J,APCL,Y
 S Y="APCL("
 S X=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(B)_"-"_$$FMTE^XLFDT(E) S J=$$START1^APCLDF(X,Y)
 S (X,Y)=0
 F  S X=$O(APCL(X)) Q:X'=+X  S Y=Y+1
 K APCL
 Q Y
 ;
PRINT ;EP - called from xbdbque
 K APCLQ
 S APCL80D="-------------------------------------------------------------------------------"
 S APCLPG=0
 I '$D(^XTMP("APCLEL3",APCLJOB,APCLBTH)) D HEAD W !!,"NO DATA TO REPORT" G DONE
 D TALLY
 D DONE
 Q
TALLY ;
 D HEAD
 W !!,"Total Number of Patients:  ",APCLPTOT
 S APCLA=0 F  S APCLA=$O(^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLA)) Q:APCLA=""!($D(APCLQ))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQ)
 .W !!?2,$P(^DD(9000010.35,APCLA,0),U)
 .S V=^XTMP("APCLEL3",APCLJOB,APCLBTH,"TALLY",APCLA)
 .S T=$P(V,U,1)+$P(V,U,2)+$P(V,U,3)+$P(V,U,4)
 .W !?10,"INDEPENDENT",?30,$J($P(V,U,1),6),?45,$S($P(V,U,1):$J((($P(V,U,1)/T)*100),5,1),1:$J(0,5,1)),"%"
 .W !?10,"NEEDS HELP",?30,$J($P(V,U,2),6),?45,$S($P(V,U,2):$J((($P(V,U,2)/T)*100),5,1),1:$J(0,5,1)),"%"
 .W !?10,"TOTALLY DEPENDENT",?30,$J($P(V,U,3),6),?45,$S($P(V,U,3):$J((($P(V,U,3)/T)*100),5,1),1:$J(0,5,1)),"%"
 .W !?10,"NOT DOCUMENTED",?30,$J($P(V,U,4),6),?45,$S($P(V,U,4):$J((($P(V,U,4)/T)*100),5,1),1:$J(0,5,1)),"%"
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("APCLEL3",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("TALLY OF ELDER CARE DATA ITEMS",80),!
 S X="between "_$$FMTE^XLFDT(APCLBD)_" and "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80)
 W !,APCL80D
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
