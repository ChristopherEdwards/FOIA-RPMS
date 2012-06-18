AQAOHPA1 ; IHS/ORDC/LJF - PARAMETER FILE HELP CONTINUED ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory texts for parameter
 ;options and help text for data fields.  This is a continuation of
 ;rtn ^AQAOHPAR.
 ;
OVERDUE ;ENTRY POINT >>help text for occurrence review limit field
 ;called by execute help
 W !!,"Enter the number of days after which an occurrence will be"
 W !,"flagged as OVERDUE for an initial review or a referral review."
 W !,"For occurrences needing initial review, counting begins on the"
 W !,"date the occurrence was created.  For those referred for review,"
 W !,"counting begins on the review date.  The overdue occurrences will"
 W !,"be printing on the Tickler Report with ""*"" on either side of"
 W !,"the occurrence case ID number.",!
 Q
 ;
 ;
PAREDIT ;ENTRY POINT >> intro text for option to edit parameter file
 ;called by entry action to option AQAO PKG PARAMETER EDIT
 W @IOF,!!?20,"EDIT QAI PARAMETERS (GENERAL)",!!
 W !?5,"Use this option to edit the QAI parameters not associated"
 W !?5,"with the linkages to other software.  These parameters include"
 W !?5,"the # of days after which a review is overdue.",!
 Q
 ;
 ;
VIEW ;ENTRY POINT >> intro text for option to view report format
 ;called by entry action of option AQAO PKG PARAMENTER VIEW
 W @IOF,!!?20,"VIEW QUARTERLY PROGRESS REPORT FORMATS",!!
 W !?5,"Use this option to view report formats already defined for"
 W !?5,"your facilities.  These formats can be used in printing the"
 W !?5,"Quarterly Progress Report on the Occurrence Reports Menu."
 W !! Q
