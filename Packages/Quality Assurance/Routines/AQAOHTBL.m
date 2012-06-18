AQAOHTBL ; IHS/ORDC/LJF - HELP TEXT FOR TABLE MAINTENANCE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for help text on data fields found
 ;in options on the Table Maintenance menu under Pkg Admin menu.
 ;
STAGES ;ENTRY POINT for xecutable help on stages fields in
 ;    QI Findings and QI Actions files
 W !,"State which REVIEW STAGES may use this action or finding."
 W !,"Enter the numbers for each stage that applies.  For example,"
 W !,"if every stage applies, enter '1234'.  If only Peer Review (3)"
 W !,"and Committee Review (4) apply, then enter '34'.",!
 W !,"The stages are",?30,"1 - Non-clinician Preliminary"
 W !?30,"2 - Clinician Preliminary"
 W !?30,"3 - Peer Review (both individual and team)"
 W !?30,"4 - Committee Review (facility-wide QI teams)",!
 Q
