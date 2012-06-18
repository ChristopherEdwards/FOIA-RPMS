APCLEL2 ; IHS/CMI/LAB - patients with elder care assessment ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will tally by age, all patients who have had their change",!,"in functional status documented in the date range your specify."
 W !,"In addition, a list of patients who have had a decline in functional",!,"status will be listed.",!
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
AGE ;what age range of patients
 W !,"Please enter the age range of patients you are interested in."
 W !
 S DIR(0)="F^1:7",DIR("A")="Enter an Age Range (e.g. 55-100,55-75)" D ^DIR K DIR
 I $D(DIRUT) G DATE
 I Y="" W !!,"No age range entered." G DATE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGE
 I $P(Y,"-",2)>130 W !,"Enter an age range, maximum age 130",! G AGE
 S APCLAGET=Y
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCLEL2",XBRC="PROC^APCLEL2",XBRX="EXIT^APCLEL2",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PROC ;EP - called from XBDBQUE
 S APCLJOB=$J,APCLBTH=$H
 K ^XTMP("APCLEL2",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLEL2","ELDER CARE TALLY")
 S I=$P(APCLAGET,"-"),J=$P(APCLAGET,"-",2)
 F X=I:1:J S ^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",X)="0^0^0^0"
 ;$o through patient file, check age of patient, community, 
 ;# times seen, set demoninator counter by age,sex
 ;check for functional status in date range.  Set numerator cntr
 ;set list of patients for optional report
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$$DOD^AUPNPAT(DFN)]""
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .S AGE=$$AGE^AUPNPAT(DFN,APCLBD)
 .I AGE<$P(APCLAGET,"-")!(AGE>$P(APCLAGET,"-",2)) Q
 .;has pt had functional assessment
 .S X=$$FA(DFN,APCLBD,APCLED)
 .I X="" Q
 .I $P(X,U)="D" S ^XTMP("APCLEL2",APCLJOB,APCLBTH,"PATIENT LIST",AGE,$P(^DPT(DFN,0),U,2),DFN)=$P(X,U,2)
 .S $P(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE),U)=$P($G(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE)),U)+1
 .I $P(X,U)="I" S $P(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE),U,2)=$P($G(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE)),U,2)+1
 .I $P(X,U)="S" S $P(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE),U,3)=$P($G(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE)),U,3)+1
 .I $P(X,U)="D" S $P(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE),U,4)=$P($G(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",AGE)),U,4)+1
 .Q
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
 .I $P(^AUPNVELD(X,0),U,17)]"" S G(9999999-D)=$P(^AUPNVELD(X,0),U,17)
 .Q
 I $O(G(0))="" Q ""
 S X=0,X=$O(G(X)) Q G(X)_"^"_(9999999-X)
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
 I '$D(^XTMP("APCLEL2",APCLJOB,APCLBTH)) S APCLTR="X" D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 D TALLY
 G:$D(APCLQ) DONE
 D LIST
 D DONE
 Q
TALLY ;
 S APCLTR="T",APCLTM=0,APCLTF=0
 D HEAD Q:$D(APCLQ)
 S APCLA=0 F  S APCLA=$O(^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",APCLA)) Q:APCLA=""!($D(APCLQ))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQ)
 .W !?2,APCLA
 .S APCLF=^XTMP("APCLEL2",APCLJOB,APCLBTH,"TALLY",APCLA),$P(APCLTF,U)=$P(APCLTF,U)+$P(APCLF,U),$P(APCLTF,U,2)=$P(APCLTF,U,2)+$P(APCLF,U,2),$P(APCLTF,U,3)=$P(APCLTF,U,3)+$P(APCLF,U,3),$P(APCLTF,U,4)=$P(APCLTF,U,4)+$P(APCLF,U,4)
 .I $P(APCLF,U)=0 F J=11,24,31,42,50,60,68 W ?J,"-"
 .I $P(APCLF,U)>0 W ?8,$J($P(APCLF,U),6),?21,$J($P(APCLF,U,2),6) S V=$J((($P(APCLF,U,2)/$P(APCLF,U))*100),5,1) W ?28,V
 .I $P(APCLF,U)>0 W ?39,$J($P(APCLF,U,3),6) S V=$J((($P(APCLF,U,3)/$P(APCLF,U))*100),5,1) W ?47,V
 .I $P(APCLF,U)>0 W ?57,$J($P(APCLF,U,4),6) S V=$J((($P(APCLF,U,4)/$P(APCLF,U))*100),5,1) W ?65,V
 Q:$D(APCLQ)
 I $Y>(IOSL-3) D HEAD Q:$D(APCLQ)
 W !!,"TOTAL"
 I $P(APCLTF,U)=0 F J=11,24,31,42,50,60,68 W ?J,"-"
 I $P(APCLTF,U)>0 W ?8,$J($P(APCLTF,U),6),?21,$J($P(APCLTF,U,2),6) S V=$J((($P(APCLTF,U,2)/$P(APCLTF,U))*100),5,1) W ?28,V
 I $P(APCLTF,U)>0 W ?39,$J($P(APCLTF,U,3),6) S V=$J((($P(APCLTF,U,3)/$P(APCLTF,U))*100),5,1) W ?47,V
 I $P(APCLTF,U)>0 W ?57,$J($P(APCLTF,U,4),6) S V=$J((($P(APCLTF,U,4)/$P(APCLTF,U))*100),5,1) W ?65,V
 Q
LIST ;
 S APCLTR="L"
 D HEAD Q:$D(APCLQ)
 S APCLA=0 F  S APCLA=$O(^XTMP("APCLEL2",APCLJOB,APCLBTH,"PATIENT LIST",APCLA)) Q:APCLA'=+APCLA!($D(APCLQ))  D
 .S APCLS="" F  S APCLS=$O(^XTMP("APCLEL2",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS)) Q:APCLS=""!($D(APCLQ))  D
 ..S DFN=0 F  S DFN=$O(^XTMP("APCLEL2",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS,DFN)) Q:DFN'=+DFN!($D(APCLQ))  D
 ...I $Y>(IOSL-3) D HEAD Q:$D(APCLQ)
 ...W !,$E($P(^DPT(DFN,0),U),1,25),?28,$$HRN^AUPNPAT(DFN,DUZ(2)),?37,$P(^DPT(DFN,0),U,2),?41,$$DOB^AUPNPAT(DFN,"E"),?59,$$AGE^AUPNPAT(DFN,APCLBD,"Y"),?65,$$FMTE^XLFDT(^XTMP("APCLEL2",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS,DFN))
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("APCLEL2",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("PATIENTS WITH CHANGE IN FUNCTIONAL ASSESSMENT DOCUMENTED",80),!
 S X="between "_$$FMTE^XLFDT(APCLBD)_" and "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80)
 I APCLTR="L" S X="Listing of Patient with a documented DECLINE in Functional Satus" W !,$$CTR(X,80)
 W !,APCL80D
 I APCLTR="T" W !,?9,"# OF",?24,"IMPROVED",?44,"SAME",?60,"DECLINED",!,"AGE",?8,"PATIENTS",?24,"#",?31,"%",?42,"#",?50,"%",?60,"#",?68,"%",!,?22,"------------",?40,"-------------",?58,"-------------"
 I APCLTR="L" W !?64,"LAST FUNCTIONAL",!,"PATIENT NAME",?28,"HRN",?36,"SEX",?41,"DOB",?59,"AGE",?64,"ASSESSMENT",!,APCL80D
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
