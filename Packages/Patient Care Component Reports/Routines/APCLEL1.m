APCLEL1 ; IHS/CMI/LAB - patients with elder care assessment ; 02 Sep 2010  7:05 AM
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
START ;
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will tally by age/sex, all patients who have had a functional",!,"assessment in a date range you specify.  You will also specity what age"
 W !,"range of patients you are interested in.  In order to determine the demoninator",!,"or population of patients to review, you will be asked if you want "
 W "patients who live a particular community or set of communities",!,"and to specify the minimum number of times the must have been seen"
 W !,"in the 3 years prior to the end of your date range in order to be included ",!,"in the report.",!
 W !,"You will be given the opportunity to get a tally of patients only, ",!,"or to get a tally and a list of the patients.",!!
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
CMMNTS ;
 K APCLCOMM
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="Review patients who live in",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) AGE
 I Y="A" W !!,"Patients from all communities will be included in the report.",! G NV
 I Y="O" D  G:'$D(APCLCOMM) CMMNTS G NV
 .K APCLCOMM
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 K APCLCOMM S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) G CMMNTS
 I $D(APCLCOMM("*")) K APCLCOMM G CMMNTS
 ;
NV ;
 W !!,"In order to determine 'active' patients please indicate the minimum number of"
 W !,"times the patient must have been seen in the 3 years prior to ",$$FMTE^XLFDT(APCLED),!,"in order to be considered active and be included in this report.",!
 S DIR(0)="N^1:999:0",DIR("A")="How many times must the patient have been seen",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CMMNTS
 S APCLNV=Y
 ;
RPT ;
 S APCLRPT=""
 S DIR(0)="S^T:Tally of patients by age/sex;L:List of Patients;B:Both a Tally and a List",DIR("A")="Would you like to produce",DIR("B")="T" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G NV
 S APCLRPT=Y
 ;
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G RPT
 S XBRP="PRINT^APCLEL1",XBRC="PROC^APCLEL1",XBRX="EXIT^APCLEL1",XBNS="APCL"
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
 K ^XTMP("APCLEL1",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLEL1","ELDER CARE TALLY")
 S I=$P(APCLAGET,"-"),J=$P(APCLAGET,"-",2)
 F X=I:1:J S ^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",X,"F")=0,^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",X,"M")=0
 ;$o through patient file, check age of patient, community, 
 ;# times seen, set demoninator counter by age,sex
 ;check for functional status in date range.  Set numerator cntr
 ;set list of patients for optional report
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$$DOD^AUPNPAT(DFN)]""
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .S AGE=$$AGE^AUPNPAT(DFN,APCLBD)
 .I AGE<$P(APCLAGET,"-")!(AGE>$P(APCLAGET,"-",2)) Q
 .;check community
 .I $D(APCLCOMM) S C=$P($G(^AUPNPAT(DFN,11)),U,18) Q:C=""  I '$D(APCLCOMM(C)) Q
 .;check number of times seen
 .I $$NUMV(DFN,APCLED)<APCLNV Q
 .;has pt had functional assessment
 .S X=$$FA(DFN,APCLBD,APCLED)
 .S ^XTMP("APCLEL1",APCLJOB,APCLBTH,"PATIENT LIST",AGE,$P(^DPT(DFN,0),U,2),DFN)=X
 .S $P(^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",AGE,$P(^DPT(DFN,0),U,2)),U)=$P($G(^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",AGE,$P(^DPT(DFN,0),U,2))),U)+1
 .S $P(^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",AGE,$P(^DPT(DFN,0),U,2)),U,2)=$P($G(^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",AGE,$P(^DPT(DFN,0),U,2))),U,2)+($S(X]"":1,1:0))
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
 .S G(9999999-D)=X
 .Q
 I $O(G(0))="" Q ""
 Q 9999999-$O(G(0))
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
 I '$D(^XTMP("APCLEL1",APCLJOB,APCLBTH)) S APCLTR="X" D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 I APCLRPT="B"!(APCLRPT="T") D TALLY
 G:$D(APCLQ) DONE
 I APCLRPT="B"!(APCLRPT="L") D LIST
 D DONE
 Q
TALLY ;
 S APCLTR="T",APCLTM=0,APCLTF=0
 D HEAD Q:$D(APCLQ)
 S APCLA=0 F  S APCLA=$O(^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",APCLA)) Q:APCLA=""!($D(APCLQ))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQ)
 .W !?2,APCLA
 .S APCLF=^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",APCLA,"F"),$P(APCLTF,U)=$P(APCLTF,U)+$P(APCLF,U),$P(APCLTF,U,2)=$P(APCLTF,U,2)+$P(APCLF,U,2)
 .S APCLM=^XTMP("APCLEL1",APCLJOB,APCLBTH,"TALLY",APCLA,"M"),$P(APCLTM,U)=$P(APCLTM,U)+$P(APCLM,U),$P(APCLTM,U,2)=$P(APCLTM,U,2)+$P(APCLM,U,2)
 .I $P(APCLF,U)=0 W ?20,"-",?27,"-",?33,"-"
 .I $P(APCLF,U)>0 W ?15,$J($P(APCLF,U,2),6),?22,$J($P(APCLF,U),6) S V=$J((($P(APCLF,U,2)/$P(APCLF,U))*100),5,1) W ?29,V
 .I $P(APCLM,U)=0 W ?40,"-",?47,"-",?53,"-"
 .I $P(APCLM,U)>0 W ?35,$J($P(APCLM,U,2),6),?42,$J($P(APCLM,U),6) S V=$J((($P(APCLM,U,2)/$P(APCLM,U))*100),5,1) W ?49,V
 .S T=$P(APCLM,U)+$P(APCLF,U),T1=$P(APCLM,U,2)+$P(APCLF,U,2)
 .I T=0 W ?60,"-",?67,"-",?73,"-"
 .I T>0 W ?55,$J(T1,6),?62,$J(T,6) S V=$J(((T1/T)*100),5,1) W ?69,V
 Q:$D(APCLQ)
 I $Y>(IOSL-3) D HEAD Q:$D(APCLQ)
 W !!,"TOTAL"
 I $P(APCLTF,U)=0 W ?20,"-",?27,"-",?33,"-"
 I $P(APCLTF,U)>0 W ?15,$J($P(APCLTF,U,2),6),?22,$J($P(APCLTF,U),6) S V=$J((($P(APCLTF,U,2)/$P(APCLTF,U))*100),5,1) W ?29,V
 I $P(APCLTM,U)=0 W ?40,"-",?47,"-",?53,"-"
 I $P(APCLTM,U)>0 W ?35,$J($P(APCLTM,U,2),6),?42,$J($P(APCLTM,U),6) S V=$J((($P(APCLTM,U,2)/$P(APCLTM,U))*100),5,1) W ?49,V
 S T=$P(APCLTM,U)+$P(APCLTF,U),T1=$P(APCLTM,U,2)+$P(APCLTF,U,2)
 I T=0 W ?60,"-",?67,"-",?73,"-"
 I T>0 W ?55,$J(T1,6),?62,$J(T,6) S V=$J(((T1/T)*100),5,1) W ?69,V
 Q
LIST ;
 S APCLTR="L"
 D HEAD Q:$D(APCLQ)
 S APCLA=0 F  S APCLA=$O(^XTMP("APCLEL1",APCLJOB,APCLBTH,"PATIENT LIST",APCLA)) Q:APCLA'=+APCLA!($D(APCLQ))  D
 .S APCLS="" F  S APCLS=$O(^XTMP("APCLEL1",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS)) Q:APCLS=""!($D(APCLQ))  D
 ..S DFN=0 F  S DFN=$O(^XTMP("APCLEL1",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS,DFN)) Q:DFN'=+DFN!($D(APCLQ))  D
 ...I $Y>(IOSL-3) D HEAD Q:$D(APCLQ)
 ...W !,$E($P(^DPT(DFN,0),U),1,25),?28,$$HRN^AUPNPAT(DFN,DUZ(2)),?37,$P(^DPT(DFN,0),U,2),?41,$$DOB^AUPNPAT(DFN,"E"),?59,$$AGE^AUPNPAT(DFN,APCLBD,"Y"),?65,$$FMTE^XLFDT(^XTMP("APCLEL1",APCLJOB,APCLBTH,"PATIENT LIST",APCLA,APCLS,DFN))
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("APCLEL1",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("PATIENTS WITH FUNCTIONAL ASSESSMENT DOCUMENTED",80),!
 S X="between "_$$FMTE^XLFDT(APCLBD)_" and "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80)
 I '$D(APCLCOMM) S X="All Communities" W !,$$CTR(X)
 I $D(APCLCOMM) S X="Selected Communities" W !,$$CTR(X)
 W !,APCL80D
 I APCLTR="T" W !,?24,"FEMALES",?45,"MALES",?65,"TOTAL",!,?20,"#",?27,"N",?32,"%",?40,"#",?47,"N",?52,"%",?60,"#",?66,"N",?72,"%",!,?17,"------------------" D
 .W ?37,"------------------",?57,"------------------"
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
