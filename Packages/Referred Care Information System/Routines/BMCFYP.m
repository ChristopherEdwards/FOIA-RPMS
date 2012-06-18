BMCFYP ; IHS/PHXAO/TMJ - Print Routine for FY PO Cost Analysis ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;**3**;JAN 09, 2006
 ;4.0*3 10.25.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
PRINT W:$D(IOF) @IOF,?20,"***** FREQUENCY OF DIAGNOSIS REPORT *****",!!
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !?20,"********** FREQUENCY OF DIAGNOSES REPORT **********"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains a ",$S(BMCPTVS="R":"PCC Visit",1:"Patient")," report based on the",!,"following criteria:",!
SHOW ;
 W !,$S(BMCPTVS="P":"PATIENT",1:"VISIT")," Selection Criteria"
 W:BMCTYPE="D" !!?6,"Encounter Date range:  ",BMCBDD," to ",BMCEDD,!
 W:BMCTYPE="S" !!?6,"Search Template: ",$P(^DIBT(BMCSEAT,0),U),!
 I '$D(^BMCRTMP(BMCRPT,11)) W !!?5,"ALL VISITS IN DATE RANGE SELECTED." G COUNT
 S BMCI=0 F  S BMCI=$O(^BMCRTMP(BMCRPT,11,BMCI)) Q:BMCI'=+BMCI  D
 .I $Y>(IOSL-5) D PAUSE^BMCRL01 W @IOF
 .W !?6,$P(^BMCTSORT(BMCI,0),U),":  "
 .K BMCQ S BMCY=0,C=0 K BMCQ F  S BMCY=$O(^BMCRTMP(BMCRPT,11,BMCI,11,"B",BMCY)) S C=C+1 W:C'=1&(BMCY'="") " ; " Q:BMCY=""!($D(BMCQ))  S X=BMCY X:$D(^BMCTSORT(BMCI,2)) ^(2) W X
 K BMCQ
COUNT ;if COUNTING entries only   
 I $Y>(IOSL-5) D PAUSE^BMCRL01 W:$D(IOF) @IOF
 I $D(BMCALL) W !!?5,"ALL (Primary and Secondary) POV's included.",!
 I $D(BMCPRIM) W !!?5,"PRIMARY POV's Only",!
 W:$D(BMCRTOT) !!!,"Total COUNT of ",$S(BMCPTVS="P":"Patients",1:"Visits"),":  ",BMCRTOT
 D PAUSE^BMCRL01
 W:$D(IOF) @IOF
 K BMCQUIT
 W !?20,"********** FREQUENCY OF DIAGNOSES REPORT **********"
PPOV I $E(IOST)="C",IO=IO(0),$Y>(IOSL-4) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BMCQUIT="" Q
 S %="^XTMP(""BMCFY"",BMCJOB,BMCBT,",A=%_"""POV"",BMCPOV)",B=%_"""APC"",BMCAPC)",C=%_"1)",E=%_"2)",F=%_"3)",G=%_"4)"
 W !!,"No. VISITs: ",BMCRTOT,?20,"No. POVs: ",BMCTOT,?40,"POV/VISIT ratio: ",$S(BMCRTOT>0:$J((BMCTOT/BMCRTOT),1,2),1:0)," (min. std. > 1.6)"
 W !!!,"TOP ",BMCLNO," POV's =>",!
 S J=0 F I=1:1 Q:'$D(@F@(I))!($D(BMCQUIT))  D
 .S BMCPOV=@F@(I)
 .I $Y>(IOSL-4) D FF Q:$D(BMCQUIT)
 .I I=1,BMCCHRT="B" D SETDASH(A)
 .;BMC 4.0*3 10.25.2007 IHS/OIT/FCJ CSV CHANGES NXT 4 LINES
 .;I BMCCHRT="L" W !?3,I,".",?7,$P(^ICD9(BMCPOV,0),U),?15,$P(^ICD9(BMCPOV,0),U,3),"  (",@A,")" Q
 .I BMCCHRT="L" W !?3,I,".",?7,$P($$ICDDX^ICDCODE(BMCPOV,0),U,2),?15,$P($$ICDDX^ICDCODE(BMCPOV,0),U,4),"  (",@A,")" Q
 .;W !,$E($P(^ICD9(BMCPOV,0),U,3),1,17),?18," (",$P(^ICD9(BMCPOV,0),U),")",?27,"|" S L=+(@A),D=L\BMCDASH F %=1:1:D W "*"
 .W !,$E($P($$ICDDX^ICDCODE(BMCPOV,0),U,4),1,17),?18," (",$P($$ICDDX^ICDCODE(BMCPOV,0),U,2),")",?27,"|" S L=+(@A),D=L\BMCDASH F %=1:1:D W "*"
 .W " ",+(@A)
 .Q
 G:$D(BMCQUIT) PEXIT
 I $Y>(IOSL-5) D FF G:$D(BMCQUIT) PEXIT
 I BMCCHRT="B" D
 .W ! S J=27 F X=1:1:10 W ?J,"|_________" S J=J+10
 .W "|",!
 .S J=27 F X=0:1:10 W ?J,BMCDASH*10*X S J=J+10
 .W !!,"each * represents ",BMCDASH," POV"_$S(BMCDASH>1:"'s",1:""),!
 I $Y>(IOSL-4) D FF G:$D(BMCQUIT) PEXIT
PAPC W !!,"TOP ",BMCLNO," DIAGNOSTIC CATEGORIES =>",!
 F I=1:1 Q:'$D(@G@(I))!($D(BMCQUIT))  D
 .S BMCAPC=@G@(I)
 .I I=1,BMCCHRT="B" D SETDASH(B)
 .I $Y>(IOSL-4) D FF Q:$D(BMCQUIT)
 .I BMCCHRT="L" W !?3,I,".",?7,$P(^ICM(BMCAPC,0),U),"   (",@B,")" Q
 .W !,$E($P(^ICM(BMCAPC,0),U),1,25),?27,"|" S L=+(@B),D=L\BMCDASH F %=1:1:D W "*"
 .W " ",+(@B)
 .Q
 I $Y>(IOSL-5) D FF G:$D(BMCQUIT) PEXIT
 I BMCCHRT="B" D
 .W ! S J=27 F X=1:1:10 W ?J,"|_________" S J=J+10
 .W "|",!
 .S J=27 F X=0:1:10 W ?J,BMCDASH*10*X S J=J+10
 .W !!,"each * represents ",BMCDASH," POV"_$S(BMCDASH>1:"'s",1:""),!
PEXIT D DONE^BMCOSUT Q
 ;
SETDASH(BMCG) ;
 NEW L,D,F,M
 S L=+(@BMCG)
 S M=$L(L),F=$E(L)+1,L=F F %=1:1:(M-1) S L=L_"0"
 S:L<100 L=100
 S BMCDASH=L\100
 Q
FF I IOST["P-" W:$D(IOF) @IOF Q
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S X="^",BMCQUIT=""
 W:$D(IOF) @IOF
 Q
 ;
