AQAOPR9 ; IHS/ORDC/LJF - OCC AUDIT LISTINGS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface and the DIP call to print
 ;audit activity for one occurrence, for one user, or by a date
 ;range.  Every data entry action on occurrences and action plans
 ;is tracked by the QI Audit file.
 ;
REPORT ; >>> choose type of report to print
 S AQAOINAC="" ;bypass screen on occurrence file
 K AQAOBD,AQAOED S AQAOSRT=""
 K DIR S DIR(0)="SO^",DIR("A")="Choose ONE Report from List"
 F X=1:1:3 S DIR(0)=DIR(0)_X_":"_$P($T(RPT+X),";;",2)_";"
 S DIR(0)=$E(DIR(0),1,$L(DIR(0))-1)
 D ^DIR G END:$D(DIRUT),END:X="",END:Y=-1
 S AQAORPT=+Y G DATES:AQAORPT=1
 ;
CHOOSE ; >>> choose which entry
 K DIC S DIC=$P($T(RPT+AQAORPT),";;",3),DIC(0)="AEQMZ" D ^DIC
 G REPORT:$D(DTOUT),REPORT:$D(DUOUT),CHOOSE:Y=-1
 S AQAOSRT=$S(AQAORPT=2:$P(Y,U,2),1:$P(^VA(200,+Y,0),U,2)) G PRINT
 ;
DATES ; >> choose date ranges
 S AQAOBD=$$BDATE^AQAOLKP G REPORT:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G DATES:AQAOED=""
 ;
 ;
 ; >>> FIND DATA FOR SELECTED REPORT <<<
PRINT ; >>> set up variables for dip call
 K DIC S DIC="^AQAGU(",L=0,FLDS="[AQAO AUDIT LIST]"
 S BY=$P($T(RPT+AQAORPT),";;",4),(FR,TO)=AQAOSRT_",?"
 I $D(AQAOBD) S FR=AQAOBD,TO=AQAOED
 D EN1^DIP
 ;
 D PRTOPT^AQAOVAR ;<cr> to continue code
 ;
END D ^%ZISC,KILL^AQAOUTIL Q
 ;
 ;
RPT ;;
 ;;For a DATE RANGE;;;;AUDIT DATE & TIME;;
 ;;For an OCCURRENCE;;^AQAOC(;;OCCURRENCE IFN,@AUDIT DATE & TIME;;
 ;;For a QI USER;;^AQAO(9,;;@USER INITIALS,@AUDIT DATE & TIME;;
