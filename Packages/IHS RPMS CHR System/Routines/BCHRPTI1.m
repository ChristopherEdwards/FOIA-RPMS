BCHRPTI1 ; IHS/TUCSON/LAB - cont. of amhrpti ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;
BDRL ;EP - CALLED FROM BCHRPTI
 W:$D(IOF) @IOF
 W !?9,"********************* CHR Record List **********************"
 W !!,"This report will produce either a detailed or a brief listing of CHR records.",!!,"These records will be for the date range specified by the user.  Records can"
 W !,"be printed based on selected data items."
 W !!
 Q
 ;
GENR ;EP - CALLED FROM BCHRPTI
 NEW X
 W:$D(IOF) @IOF
 S X="RECORD/ENCOUNTER GENERAL RETRIEVAL"
 W ?((80-$L(X))/2),X
 W !!!,"This report will produce a listing of records in a date range selected by the",!,"user.  The records printed can be selected based on any combination of items.",!,"The user will select these criteria.  The items printed on the report",!
 W "are also selected by the user.",!!,"Be sure to have a printer available that has 132-column print capability.",!!
 Q
