AQAOPC5 ; IHS/ORDC/LJF - QTR PROGRESS REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains user interface code for setting up Quarterly
 ;Progress Report.  User is asked for type of report, date range,
 ;and device.  Type of report question calls extrinsic functions in
 ;rtns ^AQAOPU*.
 ;
TYPE ; >> ask user what type of report to print
 K ^TMP("AQAOPC5",$J) W !! K DIR
 S DIR(0)="SO^1:ONE INDICATOR;2:BY KEY FUNCTION;3:FACILITY REPORT"
 S DIR("A")="Select TYPE OF REPORT to print"
 S DIR("?")="Choose ONE from the list by number"
 D ^DIR G EXIT:$D(DIRUT),TYPE:Y=-1
 S X="AQAOPC5"
 S AQAOTYP=$S(Y=1:$$IND^AQAOPU(X),Y=2:$$KF^AQAOPU(X),1:$$FACR^AQAOPU1(X))
 K ^TMP("AQAOPC5",$J,2) ;ind you don't have access to
 G TYPE:AQAOTYP=U
 ;
 ;
BDATE ; >>> ask for beginning date
 W !! K DIR S DIR(0)="DO^::E",DIR("A")="Select FIRST MONTH/YEAR"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G BDATE
 G TYPE:X="",EXIT:$D(DIRUT),BDATE:Y=-1
 I $E(Y,6,7)'="00" W *7,"  MUST BE MONTH AND YEAR ONLY!!" G BDATE
 I $E(Y,4,5)="00" W *7,"  MUST INCLUDE MONTH!!" G BDATE
 S AQAOBD=Y
 ;
EDATE ; >>> choose ending occurrence date for report
 W ! K DIR S DIR(0)="DO^::E",DIR("A")="Select LAST MONTH/YEAR"
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G EDATE
 I Y<AQAOBD W *7,"  ENDING DATE MUST BE AFTER BEGINNING DATE" G BDATE
 G BDATE:X="",EXIT:$D(DIRUT),EDATE:Y=-1
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
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G EDATE:Y=U
 W !! S %ZIS="QP" D ^%ZIS G EXIT:POP
 I '$D(IO("Q")) U IO G ^AQAOPC51
 K IO("Q") S ZTRTN="^AQAOPC51",ZTDESC="CLOSED OCC REPORT"
 F I="AQAOTYP","^TMP(""AQAOPC5"",$J,","AQAOBD","AQAOED" S ZTSAVE(I)=""
 S:$D(AQAORPTT) ZTSAVE("AQAORPTT")=""
 I $D(AQAODLM) S ZTSAVE("AQAODLM")=""
 D ^%ZTLOAD D HOME^%ZIS D KILL^AQAOUTIL Q
 ;
 ;
EXIT ; >>> early eoj
 D KILL^AQAOUTIL K ^TMP("AQAOPC5",$J) Q
