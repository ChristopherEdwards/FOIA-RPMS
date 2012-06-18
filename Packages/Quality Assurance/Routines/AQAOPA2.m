AQAOPA2 ; IHS/ORDC/LJF - ACTIONS DUE FOR REVIEW ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface and call to DIP to print the
 ;report listing action plans due for evaluation review.
 ;
SORT ; >>> choose type of report to print
 K DIR S DIR(0)="SO^",DIR("A")="Choose SORT ORDER for Report"
 F X=1:1:3 S DIR(0)=DIR(0)_X_":"_$P($T(RPT+X),";;",2)_";"
 S DIR(0)=$E(DIR(0),1,$L(DIR(0))-1)
 D ^DIR G END:$D(DIRUT),END:X="",END:Y=-1
 S BY=$P($T(RPT+Y),";;",3) ;set sort order
 ;
 ;
SUMM ; >> does user want action summaries printed with listing
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you want to include the ACTION SUMMARY with the listing"
 D ^DIR G SORT:$D(DIRUT),END:Y=-1
 S FLDS=$S(Y=1:"[AQAO STATUS WITH SUM]",1:"[AQAO STATUS NO SUM]")
 ;
 ; >>> FIND DATA FOR SELECTED REPORT <<<
PRINT ; >>> set up variables for dip call
 K DIC S DIC="^AQAO(5,",L=0,FR="@",TO=""
 ;implemented plans only & review date in past or null
 S DIS(0)="I $P(^AQAO(5,D0,0),U,5)=2,$P(^(0),U,4)'>DT"
 S DIS(1)="S Y=D0 D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 D EN1^DIP K AQAOCHK("OK")
 ;
 ;
 I IOST["C-" D PRTOPT^AQAOVAR
 ;
END D ^%ZISC,KILL^AQAOUTIL Q
 ;
 ;
RPT ;;
 ;;By ACTION PLAN #;;ACTION NUMBER;;
 ;;By ACTION TYPE;;@ACTION TYPE;;
 ;;By REVIEW DATE;;REVIEW DATE;;
