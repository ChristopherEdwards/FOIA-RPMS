ACMRL01 ; IHS/TUCSON/TMJ - SCREEN LOGIC ; [ 01/07/02  3:43 PM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**4,8**;JAN 10, 1996
 ;
 ;
INFORM ;PEP-GEN RETRIEVAL INFORMING
 S ACMTCW=0
 W:$D(IOF) @IOF
 S ACMLHDR="CASE MANAGEMENT REGISTER PATIENT GENERAL RETRIEVAL"
 W ?((80-$L(ACMLHDR))/2),ACMLHDR
 W !!!,"This report will produce a listing of Patients on a Register selected by the",!
 W "user.  You will be asked (in three separate steps) to identify your",!
 W "selection criteria; what you wish displayed for each patitent; and the",!
 W "sorting order for your list.  You may save the logic used to produce the report",!
 W "for future use.  If you design a report that is 80 characters or less in width,",!
 W "it can be displayed on your screen or printed.  If your report is 81-132",!
 W "characters wide, it must be printed - and only on a printer capable of",!
 W "producing 132 character lines.",!
 Q
 ;
ADD ;EP
 K ACMCAND
 W !!
 I $D(ACMNCAN) G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S ACMQUIT=1 Q
 I 'Y G ADD1
 S DIC="^ACM(58.8,",DIC("S")="I $P(^(0),U,11)=DUZ&($P(^(0),U,6)=ACMRG)",DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S ACMQUIT=1 Q
 S ACMRPT=+Y,ACMCAND=1
 ;--- set up sorting and report control variables
 S ACMSORT=$P(^ACM(58.8,ACMRPT,0),U,7),ACMSORV=$P(^(0),U,8),ACMSPAG=$P(^(0),U,4),ACMCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^ACM(58.8,ACMRPT,12,X)) Q:X'=+X  S ACMTCW=ACMTCW+$P(^ACM(58.8,ACMRPT,12,X,0),U,2)+2
DATEFIX ;
 ;are any items date items???  if so, ask for date range.
 S ACMX=0 F  S ACMX=$O(^ACM(58.8,ACMRPT,11,ACMX)) Q:ACMX'=+ACMX  I $P(^ACM(58.1,ACMX,0),U,2)="D" D
 .W !!,"The date range defined in this report for ",$P(^ACM(58.1,ACMX,0),U)," is:",!?5,$$FMTE^XLFDT($P($G(^ACM(58.8,ACMRPT,11,ACMX,11,1,0)),U))_" to "_$$FMTE^XLFDT($P($G(^ACM(58.8,ACMRPT,11,ACMX,11,1,0)),U,2))
 .;WOULD THEY LIKE TO CHANGE THIS RANGE
 .S DIR(0)="Y",DIR("A")="Do you wish to modify this date range",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .Q:'Y
 .;get new bd and ed and file
 .S ACMCRIT=ACMX,ACMTEXT=$P(^ACM(58.1,ACMX,0),U) D D^ACMRL0
 K ACMX,ACMCRIT,ACMTEXT
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^ACM(58.8,",DLAYGO=9002258.8,DIADD=1,DIC("DR")=".06////"_ACMRG_";.11////"_DUZ
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S ACMQUIT=1 Q
 S ACMRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^ACM(58.8,ACMRPT,11)
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Hit return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
 ;
N ;EP
 K ^ACM(58.8,ACMRPT,11,ACMCRIT),^ACM(58.8,ACMRPT,11,"B",ACMCRIT)
 S DIR(0)="FO^1:7",DIR("A")="Enter a Range of numbers (e.g. 5-12,1-1)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No numeric range entered.  All numerics will be included." Q
 I $D(^ACM(58.1,ACMCRIT,25)) S X=Y X ^(25) I '$D(X),$D(^ACM(58.1,ACMCRIT,26)) W !! X ^(26) G N ;if input tx exists and fails G N
 I '$D(^ACM(58.1,ACMCRIT,25)),Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn.  E.g. 0-5, 0-99, 5-20." G N
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,0)=ACMCRIT,^ACM(58.8,ACMRPT,11,"B",ACMCRIT,ACMCRIT)=""
 S ACMCNT=0,^ACM(58.8,ACMRPT,11,ACMCRIT,11,0)="^9002258.8110101A^1^1" F X=$P(Y,"-"):1:$P(Y,"-",2) S ACMCNT=ACMCNT+1,^ACM(58.8,ACMRPT,11,ACMCRIT,11,ACMCNT,0)=X,^ACM(58.8,ACMRPT,11,ACMCRIT,11,"B",X,ACMCNT)=""
 S $P(^ACM(58.8,ACMRPT,11,ACMCRIT,11,1,0),U,2)=$P(Y,"-",2)
 Q
F ;EP - free text
 K ^ACM(58.8,ACMRPT,11,ACMCRIT),^ACM(58.8,ACMRPT,11,"B",ACMCRIT)
 S DIR(0)="FO^1:20",DIR("A")="Enter a Range of Characters for Search (e.g. A:B) " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No range entered.  All ",ACMTEXT,"  will be included." Q
 I $D(^ACM(58.1,ACMCRIT,21)) S X=Y X ^(21) I '$D(X),$D(^ACM(58.1,ACMCRIT,22)) W !! X ^(22) G F ;if input tx exists and fails G N
 I '$D(^ACM(58.1,ACMCRIT,21)),Y'?1.ANP1":"1.ANP W !!,$C(7),$C(7),"Enter an free text range in the format AAA:AAA.  E.g. 94-01:94-200,CA:CZ, A:Z." G F
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,0)=ACMCRIT,^ACM(58.8,ACMRPT,11,"B",ACMCRIT,ACMCRIT)=""
 S ACMCNT=0,^ACM(58.8,ACMRPT,11,ACMCRIT,11,ACMCNT,0)="^9002258.8110101A^1^1" S ACMCNT=ACMCNT+1,^ACM(58.8,ACMRPT,11,ACMCRIT,11,1,0)=$P(X,":")_U_$P(X,":",2),^ACM(58.8,ACMRPT,11,ACMCRIT,11,"B",$P(X,":"),ACMCNT)=""
 Q
J ;EP;JUST A HIT
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,0)=ACMCRIT,^ACM(58.8,ACMRPT,11,"B",ACMCRIT,ACMCRIT)=""
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,11,1,0)=1,^ACM(58.8,ACMRPT,11,ACMCRIT,11,"B",1,1)="",^ACM(58.8,ACMRPT,11,ACMCRIT,11,0)="^9002258.8110101A^"_1_"^"_1
 Q
Y ;EP - called from apclvl0
 S DIR(0)="S^1:"_ACMTEXT_";0:NO "_ACMTEXT_"",DIR("A")="Should Patient have",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,0)=ACMCRIT,^ACM(58.8,ACMRPT,11,"B",ACMCRIT,ACMCRIT)=""
 S ^ACM(58.8,ACMRPT,11,ACMCRIT,11,1,0)=Y,^ACM(58.8,ACMRPT,11,ACMCRIT,11,"B",Y,1)="",^ACM(58.8,ACMRPT,11,ACMCRIT,11,0)="^9002258.8110101A^"_1_"^"_1
 Q
