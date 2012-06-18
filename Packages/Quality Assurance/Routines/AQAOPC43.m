AQAOPC43 ; IHS/ORDC/LJF - OCC WITH FINDINGS/ACTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point called by ^AQAOPC42 to print the
 ;summary page for the trending report with findings and actions.
 ;
SUMMARY ;ENTRY POINT called by ^AQAOPC42  >>> print summary page(s)
 I $D(AQAODLM) D SUMDLM Q
 D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 S X=^AQAO(2,AQAOIND,0) W !!,$P(X,U),?10,$P(X,U,2) ;ind # and name
 I $P(X,U,5)]"" W ?55,"THRESHOLD/TRIGGER:  ",$P(X,U,5),"%"
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:  ",AQAOCNT
 W !,"                     DENOMINATOR:  ______"
 W "  SOURCE: _____________________________"
 ;
 F I="F","A" D
 .W !!,"Subtotals by ",$S(I="F":"FINDING",1:"ACTION"),": "
 .S AQAOSUB=0 I '$D(AQAOXSN) D SUM1 Q
 .F  S AQAOSUB=$O(^TMP("AQAO",$J,I,AQAOSUB)) Q:AQAOSUB=""  D
 ..W !!,AQAOSUB,":",! D SUM1
 Q
 ;
SUM1 ; >> SUBRTN to print counts for each primary sort item
 S AQAOX=0 F  S AQAOX=$O(^TMP("AQAO",$J,I,AQAOSUB,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 .W ?26,AQAOX,?70,^TMP("AQAO",$J,I,AQAOSUB,AQAOX),! ;print counts
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 Q
 ;
 ;
HDG2 ; >> SUBRTN for second half of heading2    
 W ?33,"(SUMMARY PAGE)",!?30,AQAORG,!,AQAOLINE,!
 Q
 ;
 ;
SUMDLM ; >> SUBRTN to print summary page(s) in ASCII format
 W !!!,"**SUMMARY DATA**"
 S X=^AQAO(2,AQAOIND,0) W !!,$P(X,U),AQAODLM,$P(X,U,2) ;ind # and name
 I $P(X,U,5)]"" W AQAODLM,"THRESHOLD/TRIGGER:  ",$P(X,U,5),"%"
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:",AQAODLM,AQAOCNT
 W AQAODLM,"DENOMINATOR:  ______",AQAODLM,"SOURCE: ___________________"
 ;
 F I="F","A" D
 .W !!,"Subtotals by ",$S(I="F":"FINDING",1:"ACTION")
 .S AQAOSUB=0 I '$D(AQAOXSN) D SUMDLM1 Q
 .F  S AQAOSUB=$O(^TMP("AQAO",$J,I,AQAOSUB)) Q:AQAOSUB=""  D
 ..W !!,AQAOSUB,";" D SUMDLM1
 Q
 ;
SUMDLM1 ; >> SUBRTN to print totals by primary sort (DLM format)
 S AQAOX=0 F  S AQAOX=$O(^TMP("AQAO",$J,I,AQAOSUB,AQAOX)) Q:AQAOX=""  D
 .W AQAODLM,AQAOX,AQAODLM,^TMP("AQAO",$J,I,AQAOSUB,AQAOX),! ;prt counts
 Q
 ;
 ;
DLMHDG ; >> SUBRTN for ASCII heading for listing portion
 W !!!!,"***OCCURRENCE LISTINGS WITH FINDINGS & ACTIONS***",!,AQAORG,!
 W !,"Printed by ",AQAODUZ," Printed on " S %H=$H D YX^%DTC W Y
 F I="Case #","Occ Date","Age","Sex","Status","Stage","Finding","Action" W I,AQAODLM
 Q
