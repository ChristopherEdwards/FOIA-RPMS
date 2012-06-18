AQAOPC7 ; IHS/ORDC/LJF - OCC BY SINGLE CRITERIA ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine contains the code for the user interface for printing
 ;a trending report on a single criterion over time.
 ;
 D SCRIT^AQAOHOP3 ;intro text
TYPE ; >>> ask user what type of report to print
 K DIR S DIR(0)="SO^L:LISTING PLUS STATISTICS;S:STATISTICS ONLY"
 S DIR("A")="Choose TYPE of report to print"
 S DIR("?",1)="Which report style do you want?"
 S DIR("?",2)="     Enter L to list occurrences PLUS subtotals"
 S DIR("?",3)="     Enter S to print the subtotals ONLY"
 S DIR("?")="For more information on these styles, see the User Manual."
 D ^DIR G END:$D(DIRUT) S AQAOTYPE=Y
 ;
IND ; >>> occurrences for which indicator?
 S AQAOIND=$$IND^AQAOLKP G TYPE:AQAOIND=U,TYPE:AQAOIND=-1
 S AQAOIND=+AQAOIND
 ;
CRIT ; >>> check criteria defined for this indicator
 I '$D(^AQAO1(6,"C",AQAOIND)) D  G END
 .W !!,*7,"NO Criteria for this Indicator",!
 S (X,AQAOCNT)=0 K AQAOCR,AQAOIOMX ;init count;  kill array & iom var
 F  S X=$O(^AQAO1(6,"C",AQAOIND,X)) Q:X=""  D
 .Q:'$D(^AQAO1(6,X,0))  S AQAOCR(X)=$P(^(0),U) ;set array w/crit name
 .S AQAOCNT=AQAOCNT+1 ;increment count
 ;
 W !!,"There are ",AQAOCNT," criteria defined for this indicator."
 W !,"Please choose one from the list for this report."
 W !! K DIR S DIR(0)="N^1:"_AQAOCNT,(Y,X)=0
 F  S X=$O(AQAOCR(X)) Q:X=""  D
 .S Y=Y+1,DIR("A",Y)=Y_". "_AQAOCR(X),AQAOAR(X)=Y
 S DIR("A")="Choose the CRITERION for this report" D ^DIR
 G END:$D(DIRUT)
 ; >> kill off items not selected
 F I=1:1 S X=$P(Y,",",I) Q:X=""  S Y(X)=""
 S X=0 F  S X=$O(AQAOCR(X)) Q:X=""  I '$D(Y(AQAOAR(X))) K AQAOCR(X)
 K Y,AQAOAR
 ;
BDATE ; >>> ask for beginning date
 W !! K DIR S DIR(0)="DO^::E",DIR("A")="Select FIRST MONTH/YEAR"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G BDATE
 G IND:X="",END:$D(DIRUT),BDATE:Y=-1
 I $E(Y,6,7)'="00" W *7,"  MUST BE MONTH AND YEAR ONLY!!" G BDATE
 I $E(Y,4,5)="00" W *7,"  MUST INCLUDE MONTH!!" G BDATE
 S AQAOBD=Y
 ;
EDATE ; >>> choose ending occurrence date for report
 W ! K DIR S DIR(0)="DO^::E",DIR("A")="Select LAST MONTH/YEAR"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G EDATE
 I Y<AQAOBD W *7,"  ENDING DATE MUST BE AFTER BEGINNING DATE" G BDATE
 G BDATE:X="",END:$D(DIRUT),EDATE:Y=-1
 I $E(Y,6,7)'="00" W *7,"  MUST BE MONTH AND YEAR ONLY!!" G BDATE
 I $E(Y,4,5)="00" W *7,"  MUST INCLUDE MONTH!!" G EDATE
 S AQAOED=Y+31,X2=AQAOBD+1,X1=AQAOED D ^%DTC
 I X>366 D  G BDATE
 .W *7,!,"  CANNOT PRINT REPORT FOR MORE THAN 1 YEAR!",! K AQAOBD,AQAOED
 S Y=AQAOBD+700 I $E(Y,4,5)>12 S Y=Y-1200+10000
 I AQAOED'<Y D
 .W !!,*7,"You've selected more than 7 months;"
 .W " use CONDENSED print OR WIDE paper!"
 ;
 ;
DEV ; >>> get print device
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G BDATE:Y=U
 W !!
 I $D(AQAOIOMX) W *7,"REMEMBER to use CONDENSED PRINT or WIDE PAPER!",!!
 S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G ^AQAOPC71
 K IO("Q") S ZTRTN="^AQAOPC71",ZTDESC="OCC BY IND & CRIT"
 F I="AQAOTYPE","AQAOIND","AQAOCR(","AQAOBD","AQAOED" S ZTSAVE(I)=""
 S:$D(AQAODLM) ZTSAVE("AQAODLM")=""
 S:$D(AQAOIOMX) ZTSAVE("AQAOIOMX")=""
 S:$D(AQAOXSN) ZTSAVE("AQAOXSN")="",ZTSAVE("AQAOXSM")=""
 S:$D(AQAOXS) ZTSAVE("AQAOXS(")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
END ; >>> eoj
 D HOME^%ZIS D KILL^AQAOUTIL Q
