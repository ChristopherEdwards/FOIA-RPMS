AQAOPA5 ; IHS/ORDC/LJF - REVIEWED ACTIONS REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn includes the user interface and DIP call to print a listing
 ;of reviewed actions sorted in various ways.
 ;
TYPE ; >> choose listing vs summaries
 W !! K DIR S DIR(0)="SO^L:BRIEF LISTING;S:FULL SUMMARIES"
 S DIR("A")="Choose TYPE of Report to Print" D ^DIR
 G END:X="",END:$D(DIRUT),END:Y=-1
 I Y="L" S FLDS="[AQAO REVIEWED]"
 E  S FLDS="[AQAO REVIEWED WITH SUM]"
 ;
SORT ; >>> choose sorting order for report
 W !! K DIR S DIR(0)="SO^",DIR("A")="Choose SORT ORDER for Report"
 F X=1:1:5 S DIR(0)=DIR(0)_X_":By "_$P($T(RPT+X),";;",2)_";"
 S DIR(0)=$E(DIR(0),1,$L(DIR(0))-1)
 D ^DIR G END:$D(DIRUT),SORT:X="",END:Y=-1 S AQAORPT=+Y
 S BY=$P($T(RPT+Y),";;",3) ;set sort order
 I FLDS="[AQAO REVIEWED WITH SUM]" D
 .S BY=$S(AQAORPT=1:"#"_BY,1:BY_",#ACTION NUMBER")
 I AQAORPT=1 S AQAOSRT="?" G PRINT ;no other ques for sort by plan #
 ;
CHOOSE ; >>> choose all or just one entry
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to print ALL "_$P($T(RPT+AQAORPT),";;",2)_"S"
 D ^DIR G END:$D(DIRUT)
 I (AQAORPT=3)!(AQAORPT=4) G BDATE:Y=0 S AQAOSRT="" G PRINT
 I Y=1 S AQAOSRT="" G PRINT
 ;
 K DIC S DIC=$P($T(RPT+AQAORPT),";;",4),DIC(0)="AEQMZ" D ^DIC
 G TYPE:$D(DIRUT),CHOOSE:Y=-1
 S AQAOSRT=$P(Y,U,2) G PRINT
 ;
BDATE ; >>> choose beginning date for report
 W !! K DIR S DIR(0)="DO^::EX"
 S DIR("A")="Select BEGINNING "_$P($T(RPT+AQAORPT),";;",3)
 D ^DIR I Y>DT W *7,"   NO FUTURE DATES" G BDATE
 G TYPE:X="",END:$D(DIRUT),BDATE:Y=-1 S FR=Y
 ;
EDATE ; >>> choose ending occurrence date for report
 W ! K DIR S DIR(0)="DO^::EX"
 S DIR("A")="Select ENDING "_$P($T(RPT+AQAORPT),";;",3)
 D ^DIR I Y=-1 G EDATE
 I Y>DT W *7,"   NO FUTURE DATES" G EDATE
 I Y<FR W *7,"  ENDING DATE MUST BE AFTER BEGINNING DATE" G BDATE
 G BDATE:X="",END:$D(DIRUT),EDATE:Y=-1 S TO=Y
 ;
 ;
 ; >>> FIND DATA FOR SELECTED REPORT <<<
PRINT ; >>> set up variables for dip call
 K DIC S DIC="^AQAO(5,",L=0 S:'$D(FR) (TO,FR)=AQAOSRT
 S DIS(0)="I ($P(^AQAO(5,D0,0),U,5)=3)!($P(^(0),U,5)=4)!($P(^(0),U,5)=5)"
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
 ;;ACTION PLAN #;;ACTION NUMBER;;^AQAO(5,;;
 ;;ACTION TYPE;;@ACTION TYPE;;^AQAO(6,;;
 ;;IMPLEMENTATION DATE;;IMPLEMENTATION DATE;;
 ;;REVIEW DATE;;PROPOSED REVIEW DATE;;
 ;;IMPLEMENTATION TEAM;;IMPLEMENTATION TEAMS,IMPLEMENTATION TEAM;;^AQAO1(1,;;
