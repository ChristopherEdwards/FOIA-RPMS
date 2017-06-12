APCLTENP ; IHS/CMI/LAB - cont. of top ten ;
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;
 ;
PRINT W:$D(IOF) @IOF,?20,"***** FREQUENCY OF DIAGNOSIS REPORT *****",!!
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !?20,"********** FREQUENCY OF DIAGNOSES REPORT **********"
 S X=$P(^DIC(4,DUZ(2),0),U) W !,$$CTR("Report run at: "_X,80)
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains a ",$S(APCLPTVS="V":"PCC Visit",1:"Patient")," report based on the",!,"following criteria:",!
SHOW ;
 W !,$S(APCLPTVS="P":"PATIENT",1:"VISIT")," Selection Criteria"
 W:APCLTYPE="D" !!?6,"Encounter Date range:  ",APCLBDD," to ",APCLEDD,!
 W:$G(APCLSEAT) !!?6,"Search Template: ",$P(^DIBT(APCLSEAT,0),U),!
 I '$D(^APCLVRPT(APCLRPT,11)) W !!?5,"ALL VISITS IN DATE RANGE SELECTED." G EXCLP
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,11,APCLI)) Q:APCLI'=+APCLI  D
 .I $Y>(IOSL-5) D PAUSE^APCLVL01 W @IOF
 .W !?6,$P(^APCLVSTS(APCLI,0),U),":  "
 .K APCLQ S APCLY=0,C=0 K APCLQ F  S APCLY=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",APCLY)) S C=C+1 W:C'=1&(APCLY'="") " ; " Q:APCLY=""!($D(APCLQ))  S X=APCLY X:$D(^APCLVSTS(APCLI,2)) ^(2) W X
EXCLP ;
 K APCLQ
 I $O(APCLDXT(0)),APCLEXCL=1 D
 .W !!,"The following diagnoses are excluded"
 .S APCLX=0 F  S APCLX=$O(APCLDXT(APCLX)) Q:APCLX'=+APCLX!($D(APCLQ))  D
 ..I $Y>(IOSL-5) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 ..W ":",$P($$ICDDX^ICDEX(APCLX),U,2)  ;cmi/anch/maw 9/12/2007 csv
 ..Q
 .Q
COUNT ;if COUNTING entries only   
 I $Y>(IOSL-5) D PAUSE^APCLVL01 W:$D(IOF) @IOF
 I $D(APCLALL) W !!?5,"ALL (Primary and Secondary) POV's included.",!
 I $D(APCLPRIM) W !!?5,"PRIMARY POV's Only",!
 W:$D(APCLVTOT) !!!,"Total COUNT of ",$S(APCLPTVS="P":"Patients",1:"Visits"),":  ",APCLVTOT
 D PAUSE^APCLVL01
 W:$D(IOF) @IOF
 K APCLQUIT
 W !?20,"********** FREQUENCY OF DIAGNOSES REPORT **********"
PPOV I $E(IOST)="C",IO=IO(0),$Y>(IOSL-4) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
 S %="^XTMP(""APCLTEN"",APCLJOB,APCLBT,",A=%_"""POV"",APCLPOV)",B=%_"""APC"",APCLAPC)",C=%_"1)",E=%_"2)",F=%_"3)",G=%_"4)"
 W !!,"No. VISITs: ",APCLVTOT,?20,"No. POVs: ",APCLTOT,?40,"POV/VISIT ratio: ",$S(APCLVTOT>0:$J((APCLTOT/APCLVTOT),1,2),1:0)," (min. std. > 1.6)"
 W !!!,"TOP ",APCLLNO," POV's =>" I APCLCHRT="L" W !,?58,"# Visits",?68,"# Patients"
 S J=0 F I=1:1 Q:'$D(@F@(I))!($D(APCLQUIT))  D
 .S APCLPOV=@F@(I)
 .I $Y>(IOSL-4) D FF Q:$D(APCLQUIT)
 .I I=1,APCLCHRT="B" D SETDASH(A)
 .I APCLCHRT="L" W !?3,I,".",?7,$P($$ICDDX^ICDEX(APCLPOV),U,2),?17,$E($P($$ICDDX^ICDEX(APCLPOV),U,4),1,40) D  Q  ;cmi/anch/maw 9/12/2007 csv
 ..W ?58,@A,?70,$J($G(^XTMP("APCLTEN",APCLJOB,APCLBT,"PCOUNT",APCLPOV)),7,0)
 .W !,$E($P($$ICDDX^ICDEX(APCLPOV),U,4),1,17),?18," (",$P($$ICDDX^ICDEX(APCLPOV),U,2),")",?27,"|" S L=+(@A),D=L\APCLDASH F %=1:1:D W "*"  ;cmi/anch/maw 9/12/2007 csv
 .W " ",+(@A)
 .Q
 G:$D(APCLQUIT) PEXIT
 I $Y>(IOSL-5) D FF G:$D(APCLQUIT) PEXIT
 I APCLCHRT="B" D
 .W ! S J=27 F X=1:1:10 W ?J,"|_________" S J=J+10
 .W "|",!
 .S J=27 F X=0:1:10 W ?J,APCLDASH*10*X S J=J+10
 .W !!,"each * represents ",APCLDASH," POV"_$S(APCLDASH>1:"'s",1:""),!
 I $Y>(IOSL-4) D FF G:$D(APCLQUIT) PEXIT
PAPC W !!,"TOP ",APCLLNO," DIAGNOSTIC CATEGORIES =>",!
 F I=1:1 Q:'$D(@G@(I))!($D(APCLQUIT))  D
 .S APCLAPC=@G@(I)
 .I I=1,APCLCHRT="B" D SETDASH(B)
 .I $Y>(IOSL-4) D FF Q:$D(APCLQUIT)
 .I APCLCHRT="L" W !?3,I,".",?7,$P(^ICM(APCLAPC,0),U),"   (",@B,")" Q
 .W !,$E($P(^ICM(APCLAPC,0),U),1,25),?27,"|" S L=+(@B),D=L\APCLDASH F %=1:1:D W "*"
 .W " ",+(@B)
 .Q
 I $Y>(IOSL-5) D FF G:$D(APCLQUIT) PEXIT
 I APCLCHRT="B" D
 .W ! S J=27 F X=1:1:10 W ?J,"|_________" S J=J+10
 .W "|",!
 .S J=27 F X=0:1:10 W ?J,APCLDASH*10*X S J=J+10
 .W !!,"each * represents ",APCLDASH," POV"_$S(APCLDASH>1:"'s",1:""),!
PEXIT D DONE^APCLOSUT Q
 ;
SETDASH(APCLG) ;
 NEW L,D,F,M
 S L=+(@APCLG)
 S M=$L(L),F=$E(L)+1,L=F F %=1:1:(M-1) S L=L_"0"
 S:L<100 L=100
 S APCLDASH=L\100
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
FF I IOST["P-" W:$D(IOF) @IOF Q
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S X="^",APCLQUIT=""
 W:$D(IOF) @IOF
 Q
 ;
