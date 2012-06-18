AQAOPR73 ; IHS/ORDC/LJF - REVIEWED OCC RPT-SUMMARY ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point called by ^AQAOPR72 to print the
 ;summary page totalling reviews by user and team.
 ;
SUMMARY ;ENTRY POINT called by ^AQAOPR72  >>> print summary page(s)
 D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ;
 S AQAORV=0
 F  S AQAORV=$O(^TMP("AQAO",$J,AQAORV)) Q:AQAORV=""  D
 .W !!,AQAORV S AQAOTOT=0 D SUM1
 W !!,"Occurrences NOT REVIEWED:",?70,$J(AQAONOT,3)
 Q
 ;
SUM1 ; >> SUBRTN to print counts of occ reviewed by indicator
 S AQAOIND=0,AQAOCNT=0
 F  S AQAOIND=$O(^TMP("AQAO",$J,AQAORV,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 .S AQAON=0
 .F  S AQAON=$O(^TMP("AQAO",$J,AQAORV,AQAOIND,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 ..S AQAOCNT=AQAOCNT+1,AQAOTOT=AQAOTOT+1
 .W !?5,"Occurrences Reviewed for ",AQAOIND,":",?70,$J(AQAOCNT,3)
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 W !?10,"TOTAL Occurrences Reviewed:",?70,$J(AQAOTOT,3)
 Q
 ;
 ;
HDG2 ; >> SUBRTN for second half of heading2    
 W ?33,"(SUMMARY PAGE)",!?30,AQAORG,!,AQAOLINE
 Q
