APCLFPCP ; IHS/CMI/LAB - cont. of top ten ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set verioning in PCPT
 ;
PRINT ;EP
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !?20,"********** FREQUENCY OF CPTS REPORT **********"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains a ",$S(APCLPTVS="V":"PCC Visit",1:"Patient")," report based on the",!,"following criteria:",!
SHOW ;
 W !,$S(APCLPTVS="P":"PATIENT",1:"VISIT")," Selection Criteria"
 W:APCLTYPE="D" !!?6,"Encounter Date range:  ",APCLBDD," to ",APCLEDD,!
 W:APCLTYPE="S" !!?6,"Search Template: ",$P(^DIBT(APCLSEAT,0),U),!
 I '$D(^APCLVRPT(APCLRPT,11)) W !!,"ALL VISITS IN DATE RANGE SELECTED." G COUNT
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,11,APCLI)) Q:APCLI'=+APCLI  D
 .I $Y>(IOSL-5) D PAUSE^APCLVL01 W @IOF
 .W !?6,$P(^APCLVSTS(APCLI,0),U),":  "
 .K APCLQ S APCLY="",C=0 K APCLQ F  S APCLY=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",APCLY)) S C=C+1 W:C'=1&(APCLY'="") " ; " Q:APCLY=""!($D(APCLQ))  S X=APCLY X:$D(^APCLVSTS(APCLI,2)) ^(2) W X
 K APCLQ
COUNT ;if COUNTING entries only   
 I $Y>(IOSL-5) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 W:$D(APCLVTOT) !!!,"Total COUNT of ",$S(APCLPTVS="P":"Patients",1:"Visits"),":  ",APCLVTOT
 D PAUSE^APCLVL01
 W:$D(IOF) @IOF
 W !?20,"********** FREQUENCY OF CPTS REPORT **********"
PCPT I $E(IOST)="C",IO=IO(0),$Y>(IOSL-4) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
 I $Y>(IOSL-4) W:$D(IOF) @IOF
 S %="^XTMP(""APCLFPC"",APCLJOB,APCLBT,",APCLA=%_"""CPT"",APCLCPT)",APCLF=%_"3)"
 W !!,"No. VISITs: ",APCLVTOT,?20,"No. CPTs: ",APCLTOT,?40,"CPT/VISIT ratio: ",$S(APCLVTOT>0:$J((APCLTOT/APCLVTOT),1,2),1:0)," (min. std. > 1.6)" S APCLLINO=APCLLINO+2
 W !!!,"TOP ",APCLLNO," CPT's =>" S APCLLINO=APCLLINO+3
 ;F I=1:1 Q:'$D(@APCLF@(I))  S APCLCPT=@APCLF@(I) W !?3,I,".",?7,$P(^ICPT(APCLCPT,0),U),?15,$P(^ICPT(APCLCPT,0),U,2),"  (",@APCLA,")" S APCLLINO=APCLLINO+1 I $Y>(IOSL-8) D FF I $D(X),X=U G PEXIT  ;cmi/anch/maw 9/12/2007 orig line
 F I=1:1 Q:'$D(@APCLF@(I))  S APCLCPT=@APCLF@(I) W !?3,I,".",?7,$P($$CPT^ICPTCOD(APCLCPT),U,2),?15,$P($$CPT^ICPTCOD(APCLCPT),U,3),"  (",@APCLA,")" S APCLLINO=APCLLINO+1 I $Y>(IOSL-8) D FF I $D(X),X=U G PEXIT  ;cmi/anch/maw 9/12/2007 csv
 F %=1:1:2 W ! S APCLLINO=APCLLINO+1 I $Y>(IOSL-5) D FF I $D(X),X=U G PEXIT
PEXIT ;
 D DONE^APCLOSUT
 K ^XTMP("APCLFPC",APCLJOB,APCLBT) Q
FF I IOST["P-" W:$D(IOF) @IOF Q
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S X="^"
 W:$D(IOF) @IOF
 Q
 ;
