BCHRTEN ; IHS/TUCSON/LAB - TOP TEN POVS ;  [ 12/28/01  3:48 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**7,13**;OCT 28, 1996
 ;IHS/CMI/LAB - tmp to xtmp
PREPROC ;
 S %="^XTMP(""BCHTEN"",BCHJOB,BCHBT,",BCHA=%_"""POV"",BCHPOV)",BCHC=%_"1)",E=%_"2)",F=%_"3)",G=%_"4)",BCHTOT=0,BCHVTOT=0
 Q
POSTPROC ;
 D SET
 Q
 ;
 ;
SET ;  
 S BCHPOV="" F  S BCHPOV=$O(@BCHA) Q:BCHPOV=""  S %=^(BCHPOV),@BCHC@(9999999-%,BCHPOV)="" ;BCHA,BCHC global references are set in PREPROC+1
S1 S (X,I)=0 F  S X=$O(@BCHC@(X)) Q:'X  F Y=0:0 S Y=$O(@BCHC@(X,Y)) Q:'Y  S I=I+1,@F@(I)=Y I I=BCHLNO G S2
S2 S (X,I)=0 F  S X=$O(@E@(X)) Q:'X  F Y=0:0 S Y=$O(@E@(X,Y)) Q:'Y  S I=I+1,@G@(I)=Y I I=BCHLNO G S3
S3 Q
 ;
 ;
 ;
PRNTPRE ;EP
PRIM ;
 S BCHPRIM=""
 I $E(BCHRRPT)="A" G CHRT
 S DIR(0)="S^P:PRIMARY POV Only;S:PRIMARY and SECONDARY POV's",DIR("A")="Include which POV's",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 S BCHPRIM=Y
CHRT ;EP
 S DIR(0)="S^L:List of items with Counts;B:Bar Chart (REQUIRES 132 COLUMN PRINTER)",DIR("A")="Select Type of Report",DIR("B")="L" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G PRIM
 S BCHCHRT=Y
NUM ;get # entries
 S DIR(0)="NO^5:"_$S(BCHCHRT="B":35,1:100)_":0",DIR("A")="How many entries do you want in the "_$S(BCHCHRT="B":"bar chart",1:"list"),DIR("B")="10",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 I $D(DIRUT) G CHRT
 S BCHLNO=Y
 I $D(DTOUT)!(Y=-1) G NUM
 Q
 ;
PRINT ;EP;PRINT TOP TEN RECORDS
 D NOW^%DTC S Y=X D DD^%DT S BCHDT=Y
 S Y=BCHBD D DD^%DT S BCHBDD=Y S Y=BCHED D DD^%DT S BCHEDD=Y
 D COVPAGE^BCHRPTCP
 S BCHPG=0 D HEAD
 S %="^XTMP(""BCHTEN"",BCHJOB,BCHBT,",A=%_"""POV"",BCHPOV)",B=%_"""APC"",BCHAPC)",BCHC=%_"1)",E=%_"2)",F=%_"3)",G=%_"4)"
 S (J,I)=0 F  S I=$O(^XTMP("BCHTEN",BCHJOB,BCHBT,1,I)) Q:I'=+I!($D(BCHQUIT))!(J>(BCHLNO-1))  D
 .S BCHPOV="" F  S BCHPOV=$O(^XTMP("BCHTEN",BCHJOB,BCHBT,1,I,BCHPOV)) Q:BCHPOV=""!($D(BCHQUIT))  S J=J+1  D
 ..I J=1,BCHCHRT="B" D SETDASH
 ..I $Y>(IOSL-4) D HEAD Q:$D(BCHQUIT)
 ..I BCHCHRT="L" W !,J,".",?6,$E(BCHPOV,1,30),?39,$E($P(@BCHA,U,2),1,15),?56,+(@BCHA),?66,$J(($P(@BCHA,U,3)/60),7,1) Q
 ..W !,$E(BCHPOV,1,17),?18," (",$E($P(@BCHA,U,2),1,6),")",?27,"|" S L=+(@BCHA),D=L\BCHDASH F %=1:1:D W "*"
 ..W " ",+(@BCHA)
 I BCHCHRT="B",$G(BCHDASH) D
 .W ! S J=27 F X=1:1:10 W ?J,"|_________" S J=J+10
 .W "|",!
 .S J=27 F X=0:1:10 W ?J,BCHDASH*10*X S J=J+10
PEXIT D DONE^BCHUTIL1 Q
SETDASH ;set dash limits for bar chart
 NEW L,D
 S L=+(@BCHA)
 S M=$L(L),F=$E(L)+1,L=F F %=1:1:(M-1) S L=L_"0"
 I L<100 S L=100
 S BCHDASH=L\100
 Q
HEAD I 'BCHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BCHPG=BCHPG+1
 W !?2,BCHDT,?72,"Page ",BCHPG
 S BCHLENG=$L($P(^DIC(4,DUZ(2),0),U))
 W !?((80-BCHLENG)/2),$P(^DIC(4,DUZ(2),0),U)
 W !
 W !,"TOP ",BCHLNO," ",BCHINF,"'s."
 I $E(BCHRRPT)="P" W !,$S(BCHPRIM="P":"PRIMARY POV Only",1:"Both PRIMARY and SECONDARY POV's are included.")
 W !,"DATES:  ",BCHBDD,"  TO  ",BCHEDD,!
 I BCHCHRT="L" W !,"No.",?6,BCHHD1,?39,BCHHD2,?56,"# RECS",?65,"ACT TIME (hrs)"
 I BCHCHRT="B" W !,BCHHD1
 I BCHCHRT="L" W !,$TR($J(" ",80)," ","-")
 I BCHCHRT="B" W !,$TR($J(" ",132)," ","-")
 Q
