AQAOPR4 ; IHS/ORDC/LJF - DELETED CASES LISTING ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn calls DIP to list deleted occurrences.
 ;
 W @IOF,!!?20,"LISTING OF DELETED OCCURRENCE RECORDS",!!
 W !!?5,"Use this option to print a listing BY OCCURENCE DATE of"
 W !?5,"DELETED occurrences. You may not have need for this report"
 W !?5,"very often but it is available just in case.",!!
 ;
PRINT ; >>> set up print variables and call fileman to print
 S AQAOINAC="",BY="[AQAO DELETED]"
 S FLDS="[AQAO OCC LISTING]",L=0,DIC=9002167 D EN1^DIP
 ;
 D PRTOPT^AQAOVAR
END D KILL^AQAOUTIL Q
