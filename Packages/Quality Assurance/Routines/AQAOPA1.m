AQAOPA1 ; IHS/ORDC/LJF - ACT IMPLEMENTATION STATUS RPRT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn includes the user interface and the call to DIP to print
 ;a report listing action plans sorted by implementation status.
 ;
SORT ; >>> choose type of report to print
 K DIR S DIR(0)="SO^",DIR("A")="Choose SORT ORDER for Report"
 F X=1:1:4 S DIR(0)=DIR(0)_X_":"_$P($T(RPT+X),";;",2)_";"
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
 ;screen-only awaiting implementation or implemented but not reviewed
 S DIS(0)="I ($P(^AQAO(5,D0,0),U,5)=1)!($P(^(0),U,5)=2)"
 S DIS(1)="S Y=D0 D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S:BY="IMPLEMENTATION DATE" DIS(0)="I $P(^AQAO(5,D0,0),U,5)=2"
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
 ;;By ACTION STATUS;;PLAN STATUS;;
 ;;By IMPLEMENTATION DATE;;IMPLEMENTATION DATE;;
