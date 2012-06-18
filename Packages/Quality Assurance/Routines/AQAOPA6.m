AQAOPA6 ; IHS/ORDC/LJF - PRINT DELETED ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn includes the user interface and DIP call to print a simple
 ;listing of actoin plans that have been deleted.
 ;
ALL ; >>> choose all or just one entry
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to print ALL DELETED Action Plans"
 D ^DIR G END:$D(DIRUT) I Y=1 S (TO,FR)="" G PRINT
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G END:AQAOBD=U,ALL:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G END:AQAOED=U,DATES:AQAOED=""
 ;
 ;
 ;
 ; >>> FIND DATA FOR SELECTED REPORT <<<
PRINT ; >>> set up variables for dip call
 K DIC S DIC="^AQAO(5,",L=0,BY="CLOSE DATE",FLDS="[AQAO DELETED]"
 S DIS(0)="I $P(^AQAO(5,D0,0),U,5)=9"
 S DIS(1)="S Y=D0 D ACTCHK^AQAOSEC I $D(AQAOCHK(""OK""))"
 S AQAOINAC="" D EN1^DIP K AQAOCHK("OK")
 ;
 ;
 I IOST["C-" D PRTOPT^AQAOVAR
 ;
END D ^%ZISC,KILL^AQAOUTIL Q
