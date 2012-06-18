APCLACGM ;IHS/CMI/LAB - A/C monthly report; [ 12/9/2009 19:39 PM ]
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;
 ;
 D PRINT
 K ^XTMP("APCLACG",APCLJOB,APCLBTH)
 K APCLJOB,APCLBTH
 D DONE^APCLOSUT
 Q
PRINT ;
 S APCL80S="-------------------------------------------------------------------------------"
 D NOW^%DTC S Y=X D DD^%DT S APCLDT=Y
 S (APCLPG,APCLAP)=0
 K APCLQUIT
 D HEAD
 ;S (APCLUPWR,APCLUPOP,APCLUPAC,APCLRPOP,APCLRPWR,APCLRPAC)=999999
 S APCLSHD=""
 W !,"Date Range:",?40,$$FMTE^XLFDT(APCLBD)," - ",$$FMTE^XLFDT(APCLED),!
 W !,"Total Demographics",!
 W !,"User Population",?40,$J($$C(APCLUPOP,0,8),12),!
 W !,"Number of patients in the User Population",!
 W "who had a prescription for Warfarin in the",!
 W "45 days prior to ",$$FMTE^XLFDT(APCLED),".",?40,$J($$C(APCLUPWR,0,8),12),?55,$$PER(APCLUPWR,APCLUPOP)," (of User Pop)",!
 W !,"Number of patients on Warfarin managed "
 W !,"by the Anticoagulation Clinic (had a visit",!,"to Anticoagulation clinic in the ",!,"time period",?40,$J($$C(APCLUPAC,0,8),12),?55,$$PER(APCLUPAC,APCLUPWR)," (of Warfarin Pop)"
 I $Y>(IOSL-8) D HEAD Q:$D(APCLQUIT)
RPTPOP ;report population
 W !!,"Report Demographics",!
 W !,"Report Population:" D
 .I APCLGRP="W" W ?40,"Warfarin Patients",!
 .I APCLGRP="A" W ?40,"Anticoagulation Clinic Patients",! D
 ..S X=0 F  S X=$O(APCLACCR(X)) Q:X'=+X  W ?40,$P(^DIC(40.7,X,0),U),!
 .I APCLGRP="S" W ?40,"Search Template: ",!?40,$P(^DIBT(APCLSTMP,0),U),!
 .I APCLGRP="I" W ?40,"iCare Panel: ",!?40,$P(APCLICP,U,3),!
 .I APCLGRP="E" W ?40,"EHR Personal List: ",!?40,$P(APCLICP,U,3),!
 W !,"Number of patients included on this",!,"report",?40,$J($$C(APCLRPOP,0,8),12),!
 I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included in this ",!
 W "report who had a prescription for Warfarin ",!
 W "in the 45 days prior to ",$$FMTE^XLFDT(APCLED),".",?40,$J($$C(APCLRPWR,0,8),12),?55,$$PER(APCLRPWR,APCLRPOP)," (of Report Pop)",!
 I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients on Warfarin managed ",!
 W "by the Anticoagulation Clinic (had a visit",!,"to Anticoagulation clinic in the ",!,"time period",?40,$J($$C(APCLRPWA,0,8),12),?55,$$PER(APCLRPWA,APCLRPWR)," (of Warfarin Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin",!
 W "AND had a documented INR within the 45",!
 W "days prior to the end of the report:",?40,$J($$C(APCLRPIN,0,8),12),?55,$$PER(APCLRPIN,APCLRPWR)," (of Rep/INR Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin",!
 W "AND had an INR value greater than or equal",!
 W "to 9.0 during the report date range:",?40,$J($$C(APCLRPI9,0,8),12),?55,$$PER(APCLRPI9,APCLRPIN)," (of Rep/War Pop)",!
 I $Y>(IOSL-6) D HEAD Q:$D(APCLQUIT)
 W !?3,"Patients who had an INR > 9 this month:",!
 D SUBHEAD1
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"INR >9",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD1
 .W ?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .S APCLVD=0 F  S APCLVD=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"INR >9",DFN,APCLVD)) Q:APCLVD=""!($D(APCLQUIT))  D
 ..S APCLI=0 F  S APCLI=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"INR >9",DFN,APCLVD,APCLI)) Q:APCLI'=+APCLI!($D(APCLQUIT))  D
 ...S APCLR=^XTMP("APCLACG",APCLJOB,APCLBTH,"INR >9",DFN,APCLVD,APCLI)
 ...W ?43,$P($$INRGOAL(DFN,APCLED),U,1),?56,APCLR,?66,$$D1^APCHSMU(APCLVD),!
 .;NOW DISPLAY INDICATIONS - ALL DXS IN TIME PERIOD
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD1
 .K APCLD
 .S %=DFN_"^ALL DX [BJPC AC THRPY INDIC DXS;DURING "_APCLBD_"-"_APCLED,E=$$START1^APCLDF(%,"APCLD(")
 .W ?3,"Indication for Anticoag Therapy:"
 .S X=0 F  S X=$O(APCLD(X)) Q:X'=+X  W "  ",$P(APCLD(X),U,2)
 .W !
VITK ;
 I $Y>(IOSL-8) D HEAD Q:$D(APCLQUIT)
 W !!!,"Number of patients included on this",!
 W "report who had a prescription for Vitamin K",!
 W "during the report date range:",?40,$J($$C(APCLRPVK,0,8),12),?55,$$PER(APCLRPVK,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-6) D HEAD Q:$D(APCLQUIT)
 W !?3,"Patients who received Vitamin K this month:",!
 D SUBHEAD2
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"VITK",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD2
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .;NOW DISPLAY INDICATIONS - ALL DXS IN TIME PERIOD
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)  D SUBHEAD2
 .W ?3,"Date of Last Vitamin K prescription: ",$$D1^APCHSMU(^XTMP("APCLACG",APCLJOB,APCLBTH,"VITK",DFN)),!
 .K APCLD
 .S %=DFN_"^ALL DX [BJPC AC THRPY INDIC DXS;DURING "_APCLBD_"-"_APCLED,E=$$START1^APCLDF(%,"APCLD(")
 .W ?3,"Indication for Anticoag Therapy:"
 .S X=0 F  S X=$O(APCLD(X)) Q:X'=+X  W "  ",$P(APCLD(X),U,2)
 .W !
MONT ;
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "are within their INR Goal range and were",!
 W "monitored this month",?40,$J($$C(APCLRPMI,0,8),12),?55,$$PER(APCLRPMI,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "are within their INR Goal range but were",!
 W "NOT monitored this month",?40,$J($$C(APCLRPNI,0,8),12),?55,$$PER(APCLRPNI,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "who are NOT within their INR Goal range but",!
 W "were monitored this month",?40,$J($$C(APCLRPMN,0,8),12),?55,$$PER(APCLRPMN,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "who are NOT within their INR Goal range and",!
 W "were NOT monitored this month",?40,$J($$C(APCLRPNN,0,8),12),?55,$$PER(APCLRPNN,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "who were monitored this month but their INR",!
 W "in goal status could not be determined",?40,$J($$C(APCLRPMU,0,8),12),?55,$$PER(APCLRPMU,APCLRPWR)," (of Rep/War Pop)",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !,"Number of patients included on this",!
 W "report who had a prescription for Warfarin,",!
 W "who were NOT monitored this month and their INR",!
 W "in goal status could not be determined",?40,$J($$C(APCLRPNU,0,8),12),?55,$$PER(APCLRPNU,APCLRPWR)," (of Rep/War Pop)",!
 ;
LISTS ;
 I '$D(APCLLIST) G DONE
 I $D(APCLLIST(1)) D LIST1
 G:$D(APCLQUIT) DONE
 I $D(APCLLIST(2)) D LIST2
 G:$D(APCLQUIT) DONE
 I $D(APCLLIST(3)) D LIST3
 G:$D(APCLQUIT) DONE
 I $D(APCLLIST(4)) D LIST4
 G:$D(APCLQUIT) DONE
 I $D(APCLLIST(5)) D LIST5
 Q:$D(APCLQUIT)
 ;
DONE ;
 Q
LIST1 ;all patient in ^TMP($J,"PATIENTS"
 S APCLSHD="Patient Population:  All patients in the Report Population"
 D HEAD
 Q:$D(APCLQUIT)
 I '$D(^XTMP("APCLACG",APCLJOB,APCLBTH,"PATIENTS")) W !!,"No data to report." Q
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"PATIENTS",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD3
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .Q
 Q
LIST2 ;all patient in ^TMP($J,"PATIENTS"
 S APCLSHD="Patient Population:  Only patients in INR Goal Range who were monitored this month."
 D HEAD
 Q:$D(APCLQUIT)
 I '$D(^XTMP("APCLACG",APCLJOB,APCLBTH,"MONT IN RANGE")) W !!,"No data to report." Q
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"MONT IN RANGE",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD3
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .Q
 Q
LIST3 ;all patient in ^TMP($J,"PATIENTS"
 S APCLSHD="Patient Population:  Only patients in INR Goal Range who were NOT monitored this month."
 D HEAD
 Q:$D(APCLQUIT)
 I '$D(^XTMP("APCLACG",APCLJOB,APCLBTH,"NOT MONT IN RANGE")) W !!,"No data to report." Q
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"NOT MONT IN RANGE",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD3
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .Q
 Q
LIST4 ;all patient in ^TMP($J,"PATIENTS"
 S APCLSHD="Patient Population:  Only patients NOT in INR Goal Range who were monitored this month."
 D HEAD
 Q:$D(APCLQUIT)
 I '$D(^XTMP("APCLACG",APCLJOB,APCLBTH,"MONT NOT IN RANGE")) W !!,"No data to report." Q
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"MONT NOT IN RANGE",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD3
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .Q
 Q
LIST5 ;all patient in ^TMP($J,"PATIENTS"
 S APCLSHD="Patient Population:  Only patients NOT in INR Goal Range who were NOT monitored this month."
 D HEAD
 Q:$D(APCLQUIT)
 I '$D(^XTMP("APCLACG",APCLJOB,APCLBTH,"NOT MONT NOT IN RANGE")) W !!,"No data to report." Q
 S DFN=0 F  S DFN=$O(^XTMP("APCLACG",APCLJOB,APCLBTH,"NOT MONT NOT IN RANGE",DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(APCLQUIT)  D SUBHEAD3
 .W !?1,$E($P(^DPT(DFN,0),U),1,20),?23,$$HRN^AUPNPAT(DFN,DUZ(2)),?30,$$D1^APCHSMU($$DOB^AUPNPAT(DFN))
 .W ?43,$P($$INRGOAL(DFN,APCLED),U,1)
 .S APCLL=$$LASTINR(DFN,APCLBD,APCLED)
 .W ?56,$P(APCLL,U,3),?66,$$D1^APCHSMU($P(APCLL,U,1)),!
 .Q
 Q
LASTINR(P,BD,ED) ;EP
 NEW APCLVAL
 S APCLVAL=$$LASTLAB^APCLAPIU(P,BD,ED,,,,,"A","INR")
 Q APCLVAL
SUBHEAD2 ;
 W !?1,"NAME",?25,"HRN",?32,"DOB",?43,"INR GOAL",?56,"Last INR",?66,"Last INR Date",!?62,"(in rpt period)",!
 W APCL80S,!
 Q
SUBHEAD1 ;
 W !?1,"NAME",?25,"HRN",?32,"DOB",?43,"GOAL INR",?56,"INR Value",?66,"INR Date",!
 W APCL80S,!
 Q
SUBHEAD3 ;
 W !?1,"NAME",?25,"HRN",?32,"DOB",?43,"INR GOAL",?56,"LAST INR",?66,"LAST INR DATE",!,?46,"----- last in report period -----",!
 W APCL80S,!
 Q
MRGOAL(P) ;PEP - most recent INR goal and date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z,S
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...Q:$P($G(^AUPNVACG(I,0)),U,4)=""
 ...S Z=$P(^AUPNVACG(I,0),U,4)
 ...I Z=3 S S=$P(^AUPNVACG(I,0),U,5)_" - "_$P(^AUPNVACG(I,0),U,6)
 ...I Z'=3 S S=$$VAL^XBDIQ1(9000010.51,I,.04)
 ...S R=$$VD^APCLV($P(^AUPNVACG(I,0),U,3))_"^"_S
 Q R
INRGOAL(P,A) ;EP - inr goal documented on or before this date
 I $G(P)="" Q ""
 I '$D(^AUPNVACG("AA",P)) Q ""
 NEW X,Y,D,R,I,Z,S,J
 S R=""
 S D=0 F  S D=$O(^AUPNVACG("AA",P,D)) Q:D'=+D!(R]"")  D
 .S X=0 F  S X=$O(^AUPNVACG("AA",P,D,X)) Q:X'=+X!(R]"")  D
 ..S I=0 F  S I=$O(^AUPNVACG("AA",P,D,X,I)) Q:I'=+I  D
 ...Q:$P($G(^AUPNVACG(I,0)),U,4)=""
 ...S J=9999999-X
 ...I J>A Q
 ...S Z=$P(^AUPNVACG(I,0),U,4)
 ...I Z=3 S S=$P(^AUPNVACG(I,0),U,5)_" - "_$P(^AUPNVACG(I,0),U,6)
 ...I Z'=3 S S=$$VAL^XBDIQ1(9000010.51,I,.04)
 ...S R=S ;_" ("_$$D1^APCHSACG($$VD^APCLV($P(^AUPNVACG(I,0),U,3)))
 Q R
C(X,X2,X3) ;
 I $G(X3)="" S X3=12
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
PER(N,D) ;return % of n/d
 I 'D Q "0.0%"
 NEW Z
 S Z=N/D,Z=Z*100,Z=$J(Z,3,1)
 Q $$STRIP^XLFSTR(Z," ")_"%"
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W $$FMTE^XLFDT(DT),?72,"Page ",APCLPG,!
 W !,$$CTR($$LOC())
 W !!,$$CTR("ANTICOAGULATION INR MANAGEMENT REPORT",80),!
 I $G(APCLSHD)]"" W !,"PATIENT LIST",!,$$CTR(APCLSHD),!
 W APCL80S,!
 I $G(APCLSHD)]"" D SUBHEAD3
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
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
