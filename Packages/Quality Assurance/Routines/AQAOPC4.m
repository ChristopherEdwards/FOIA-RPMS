AQAOPC4 ; IHS/ORDC/LJF - OCC BY IND WITH FINDING/ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface to print the trending report
 ;of occurrences by finding and action.
 ;
 D FINDACT^AQAOHOP2 ;intro text
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
 S AQAOIND=$$IND^AQAOLKP G END:AQAOIND=U,TYPE:AQAOIND=-1
 S AQAOIND=+AQAOIND
 ;
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G END:AQAOBD=U,IND:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G END:AQAOED=U,DATES:AQAOED=""
 ;
 ;
OPEN ; >>> ask user if wants to include open cases
 K DIR S DIR(0)="SO^O:OPEN & CLOSED CASES;C:CLOSED CASES ONLY"
 S DIR("A")="Choose Case Statuses to include"
 S DIR("?",1)="Which occurrences do you want to include?"
 S DIR("?",2)="     Enter O to list BOTH Open and Closed Occurrences"
 S DIR("?",3)="     Enter C to print ONLY Closed Occurrences"
 S DIR("?")="For more information on these styles, see the User Manual."
 D ^DIR G DATES:X="",END:$D(DIRUT) S AQAOSTAT=Y
 ;
 ;
DEV ; >>> get print device
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G OPEN:Y=U
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G ^AQAOPC41
 K IO("Q") S ZTRTN="^AQAOPC41",ZTDESC="OCC WITH FINDINGS"
 F I="AQAOTYPE","AQAOIND","AQAOBD","AQAOSTAT","AQAOED" S ZTSAVE(I)=""
 S:$D(AQAODLM) ZTSAVE("AQAODLM")=""
 S:$D(AQAOXSN) ZTSAVE("AQAOXSN")="",ZTSAVE("AQAOXSM")=""
 S:$D(AQAOXS) ZTSAVE("AQAOXS(")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
END ; >>> eoj
 D HOME^%ZIS D KILL^AQAOUTIL Q
