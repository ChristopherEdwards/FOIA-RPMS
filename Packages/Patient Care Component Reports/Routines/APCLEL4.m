APCLEL4 ; IHS/CMI/LAB - patients with elder care assessment ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will tally the number of patients who have had",!,"2 or more items in the ADL and 2 or more items in the IADL groups",!,"documented as NEEDS HELP or TOTALLY DEPENDENT.",!
 W !,"All patients who have had a functional assessment in the year prior the as of",!,"date entered will be reviewed.",!
 W !,"A list of the patients will also be listed.",!
 D EXIT
DATE ;get visit date range for functional assessment
 S APCLED=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter As of Visit Date"
 D ^DIR K DIR G:Y<1 EXIT S APCLED=Y
 S APCLBD=$$FMADD^XLFDT(APCLED,-365)
 ;
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DATE
 S XBRP="PRINT^APCLEL4",XBRC="PROC^APCLEL4",XBRX="EXIT^APCLEL4",XBNS="APCL"
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
 K ^XTMP("APCLEL4",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLEL4","ELDER CARE TALLY")
 S APCLADL=0,APCLIADL=0
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$$DOD^AUPNPAT(DFN)]""
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .;has pt had functional assessment
 .S X=$$FA(DFN,APCLBD,APCLED)
 .I X="" Q
 .S APCLPTOT=APCLPTOT+1
 .;tally each item
 .S G=0,APCLDA=X F APCLX=.04:.01:.09  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) I V="T"!(V="N") S G=G+1
 .S H=0,APCLDA=X F APCLX=.11:.01:.16  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) I V="T"!(V="N") S H=H+1
 .I G>1,H>1 S APCLADL=APCLADL+1,^XTMP("APCLEL4",APCLJOB,APCLBTH,"TALLY",DFN)=X
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
PRINT ;EP - called from xbdbque
 K APCLQ
 S APCL80D="-------------------------------------------------------------------------------",APCLTR="T"
 S APCLPG=0
 I '$D(^XTMP("APCLEL4",APCLJOB,APCLBTH)) D HEAD W !!,"NO DATA TO REPORT" G DONE
 D TALLY
 D DONE
 Q
TALLY ;
 S APCLTR="L"
 D HEAD
 W !!,"Total Number of Patients w/Functional Assessment Documented:  ",?70,$J(APCLPTOT,6)
 W !!,"Total Number of Patients w/2 or more in ADL and IADL documented",!,"as NEEDS HELP or TOTALLY DEPENDENT",?70,$J(APCLADL,6),!!
 D HEAD
 S DFN=0 F  S DFN=$O(^XTMP("APCLEL4",APCLJOB,APCLBTH,"TALLY",DFN)) Q:DFN=""!($D(APCLQ))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQ)
 .S APCLIEN=^XTMP("APCLEL4",APCLJOB,APCLBTH,"TALLY",DFN)
 .W !,$E($P(^DPT(DFN,0),U),1,25),?28,$$HRN^AUPNPAT(DFN,DUZ(2)),?37,$P(^DPT(DFN,0),U,2),?41,$$DOB^AUPNPAT(DFN,"E"),?59,$$AGE^AUPNPAT(DFN,APCLBD,"Y"),?65,$$FMTE^XLFDT($P(^AUPNVSIT($P(^AUPNVELD(APCLIEN,0),U,3),0),U),"1D"),!
 .S G=0,APCLDA=APCLIEN F APCLX=.04:.01:.09  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) W $P(^DD(9000010.35,APCLX,0),U),"-",V,"  "
 .W ! S H=0,APCLDA=APCLIEN F APCLX=.11:.01:.16  S V=$$VALI^XBDIQ1(9000010.35,APCLDA,APCLX) W $E($P(^DD(9000010.35,APCLX,0),U),1,12),"-",V,"  "
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("APCLEL4",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("ELDER PATIENTS WITH 2 OR MORE ITEMS",80),!
 W $$CTR("documented as NEEDS HELP or TOTALLY DEPENDENT",80),!
 S X="between "_$$FMTE^XLFDT(APCLBD)_" and "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80)
 I APCLTR="L" W !?64,"LAST FUNCTIONAL",!,"PATIENT NAME",?28,"HRN",?36,"SEX",?41,"DOB",?59,"AGE",?64,"ASSESSMENT"
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
