BMCRL01 ; IHS/PHXAO/TMJ - SCREEN LOGIC ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
INFORM ;EP
 S BMCTCW=0
 W:$D(IOF) @IOF
 S BMCLHDR="REFERRED CARE INFORMATION SYSTEM (RCIS) GENERAL RETRIEVAL"
 W ?((80-$L(BMCLHDR))/2),BMCLHDR
 W !!!,"This report will list or count referrals based on selection criteria"
 W !,"entered by the user.  You will be asked, in 3 separate steps, to identify"
 W !,"your selection criteria, what you wish displayed for each referral",!,"and the sorting order for your list.  You may save the logic used to produce"
 W !,"the list for future use.  If you design a report that is 80 characters or less",!,"it can be displayed on your screen or printed.  If your report is 81-132",!,"characters wide, it must be printed - and only on a printer capable of "
 W !,"producing 132 character lines.  ",!
 S (BMCPCNT,BMCPTCT)=0 ;BMCPTCT -- pt total for # of "R"eferrals
 K BMCRDTR,BMCBDD,BMCBD,BMCEDD,BMCED
 K BMCTYPE ;--- just in case variable left around
 Q
 ;
ADD ;EP
 W !
 I '$D(BMCCAND) G ADD1
 S DIC="^BMCRTMP(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=BMCPTVS)" S:$D(BMCEP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=BMCPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S BMCQUIT=1 Q
 S BMCRPT=+Y,BMCCAND=1
 ;--- set up sorting and report control variables
 S BMCSORT=$P(^BMCRTMP(BMCRPT,0),U,7),BMCSORV=$P(^(0),U,8),BMCSPAG=$P(^(0),U,4),BMCCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^BMCRTMP(BMCRPT,12,X)) Q:X'=+X  S BMCTCW=BMCTCW+$P(^BMCRTMP(BMCRPT,12,X,0),U,2)+2
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^BMCRTMP(",DLAYGO=90001.82,DIADD=1,DIC("DR")=".13////"_DUZ D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BMCQUIT=1 Q
 S BMCRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^BMCRTMP(BMCRPT,11)
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Hit return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
 ;
N ;EP
 K ^BMCRTMP(BMCRPT,11,BMCCRIT),^BMCRTMP(BMCRPT,11,"B",BMCCRIT)
 S DIR(0)="FO^1:11",DIR("A")="Enter a Range of numbers (e.g. 5-12,1-1,10000-99000)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No numeric range entered.  All numerics will be included." Q
 I $D(^BMCTSORT(BMCCRIT,25)) S X=Y X ^(25) I '$D(X) G N  ;if input tx exists and fails G N
 I '$D(^BMCTSORT(BMCCRIT,25)),Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn.  E.g. 0-5, 0-99, 5-20." G N
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,0)=BMCCRIT,^BMCRTMP(BMCRPT,11,"B",BMCCRIT,BMCCRIT)=""
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,11,0)="^90001.82110101A^1^1" S ^BMCRTMP(BMCRPT,11,BMCCRIT,11,1,0)=$P(Y,"-"),^BMCRTMP(BMCRPT,11,BMCCRIT,11,"B",$P(Y,"-"),1)=""
 S $P(^BMCRTMP(BMCRPT,11,BMCCRIT,11,1,0),U,2)=$P(Y,"-",2)
 Q
J ;EP - JUST A HIT
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,0)=BMCCRIT,^BMCRTMP(BMCRPT,11,"B",BMCCRIT,BMCCRIT)=""
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,11,1,0)=1,^BMCRTMP(BMCRPT,11,BMCCRIT,11,"B",1,1)="",^BMCRTMP(BMCRPT,11,BMCCRIT,11,0)="^90001.82110101A^"_1_"^"_1
 Q
Y ;EP - called from apclvl0
 S DIR(0)="S^1:"_BMCTEXT_";0:NO "_BMCTEXT_"",DIR("A")="Should "_$S(BMCPTVS="P":"patient",1:"referral")_" have",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,0)=BMCCRIT,^BMCRTMP(BMCRPT,11,"B",BMCCRIT,BMCCRIT)=""
 S ^BMCRTMP(BMCRPT,11,BMCCRIT,11,1,0)=Y,^BMCRTMP(BMCRPT,11,BMCCRIT,11,"B",Y,1)="",^BMCRTMP(BMCRPT,11,BMCCRIT,11,0)="^90001.82110101A^"_1_"^"_1
 Q
