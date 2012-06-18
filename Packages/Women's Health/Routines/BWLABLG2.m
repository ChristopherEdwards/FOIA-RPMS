BWLABLG2 ;IHS/ANMC/MWR - DISPLAY LAB LOG;15-Feb-2003 21:56;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  HELP PROMPTS FOR DISPLAYING LAB LOG.  CALLED BY BWLABLG.
 ;
HELP1 ;EP
 ;;Answer "ALL" to display ALL Procedures for the selected date range.
 ;;Answer "NO" to display only those Procedures that at this time
 ;;have NO RESULTS, within the selected date range.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
HELP2 ;EP
 ;;Answer "EACH" to display the data for each individual Procedure,
 ;;in other words, show date, accession#, name, chart#, provider, etc.
 ;;Answer "TOTALS" to display only the total counts, in other words,
 ;;show only the number procedures with no results and the total
 ;;number of procedures (for the selected date range).
 S BWTAB=5,BWLINL="HELP2" D HELPTX
 Q
 ;
HELP3 ;EP
 ;;Answer "ACCESSION#" to display Procedures in order of ACCESSION#,
 ;;in other words, earliest ACCESSION# first.
 ;;Answer "PATIENT NAME" to display Procedures alphabetically by
 ;;patient name.
 S BWTAB=5,BWLINL="HELP3" D HELPTX
 Q
 ;
HELPTX ;EP
 ;---> CREATES DIR ARRAY FOR DIR.  REQUIRED VARIABLES: BWTAB,BWLINL.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
