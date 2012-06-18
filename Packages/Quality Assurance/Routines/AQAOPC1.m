AQAOPC1 ; IHS/ORDC/LJF - OCC BY INDICATOR W/ CRITERIA ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface for the trending report by
 ;review criteria.
 ;
 D CRIT^AQAOHOP2 ;intro text
TYPE ; >>> ask user what type of report to print
 K DIR S DIR(0)="SO^L:LISTING PLUS STATISTICS;S:STATISTICS ONLY"
 S DIR("A")="Choose TYPE of report to print"
 S DIR("?",1)="Which report style do you want?"
 S DIR("?",2)="     Enter L to list occurrences PLUS statistics"
 S DIR("?",3)="     Enter S to print the statistical page ONLY"
 S DIR("?")="For more information on these styles, see the User Manual."
 D ^DIR G END:$D(DIRUT) S AQAOTYP=Y
 ;
IND ; >>> occurrences for which indicator?
 S AQAOIND=$$IND^AQAOLKP G END:AQAOIND=U,TYPE:AQAOIND=-1
 S AQAOIND=+AQAOIND
 ;
CRIT ; >>> check criteria defined for this indicator
 I '$D(^AQAO1(6,"C",AQAOIND)) D  G TYPE
 .W !!,*7,"NO Criteria for this Indicator",!
 S (X,AQAOCNT)=0 K AQAOCR,AQAOIOMX ;init count;  kill array & iom var
 F  S X=$O(^AQAO1(6,"C",AQAOIND,X)) Q:X=""  D
 .Q:'$D(^AQAO1(6,X,0))  S AQAOCR(X)=$P(^(0),U) ;set array w/crit name
 .S AQAOCNT=AQAOCNT+1 ;increment count
 I (AQAOTYP="L"),(AQAOCNT>7) D
 .S AQAOIOMX=132
 .W !,*7,"You have more than 7 criteria for this indicator."
 .W !,"Please use CONDENSED PRINT or WIDE PAPER.",!
 ;
 ; >> if too many defined, must choose up to 14 for this report
 W !!,"There are ",AQAOCNT," criteria defined for this indicator.  Only"
 W !,"14 can fit on the report.  Please choose up to 14 from the list."
 W !! K DIR S DIR(0)="L^1:"_AQAOCNT_"^K:X#1 X",(Y,X)=0
 F  S X=$O(AQAOCR(X)) Q:X=""  D
 .S Y=Y+1,DIR("A",Y)=Y_". "_AQAOCR(X),AQAOAR(X)=Y
 S DIR("A")="Choose the CRITERIA for this report" D ^DIR
 G END:$D(DIRUT) I $P(Y,",",15)'="" G CRIT ;still too many
 ; >> kill off items not selected
 F I=1:1 S X=$P(Y,",",I) Q:X=""  S Y(X)=""
 S X=0 F  S X=$O(AQAOCR(X)) Q:X=""  I '$D(Y(AQAOAR(X))) K AQAOCR(X)
 K Y,AQAOAR
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G IND:AQAOBD=U,IND:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G DATES:AQAOED=U,DATES:AQAOED=""
 ;
 ;
DEV ; >>> get print device
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G DATES:Y=U
 W !!
 I $D(AQAOIOMX) W *7,"REMEMBER to use CONDENSED PRINT or WIDE PAPER!",!!
 S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G ^AQAOPC11
 K IO("Q") S ZTRTN="^AQAOPC11",ZTDESC="OCC BY IND & CRIT"
 F I="AQAOTYP","AQAOIND","AQAOCR(","AQAOBD","AQAOED" S ZTSAVE(I)=""
 S:$D(AQAODLM) ZTSAVE("AQAODLM")=""
 S:$D(AQAOIOMX) ZTSAVE("AQAOIOMX")=""
 S:$D(AQAOXSN) ZTSAVE("AQAOXSN")="",ZTSAVE("AQAOXSM")=""
 S:$D(AQAOXS) ZTSAVE("AQAOXS(")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
END ; >>> eoj
 D HOME^%ZIS D KILL^AQAOUTIL Q
