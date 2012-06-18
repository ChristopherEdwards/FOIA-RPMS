AQAOHFNC ; IHS/ORDC/LJF - HELP TEXT FOR FUNCTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for the introductory text on options
 ;and help text on data fields for Key Functions data entry.
 ;
FNCEDIT ;ENTRY POINT >> intro text for option to define key functions & goals
 W @IOF,!!?30,"KEY FUNCTIONS AND GOALS"
 W !!?5,"Use this option to document the KEY FUNCTIONS AND GOALS for"
 W !?5,"your health care organization.  These functions can also be"
 W !?5,"referred to as IMPORTANT ASPECTS OF CARE, or VITAL ACTIVITIES"
 W !?5,"or OPPORTUNITIES FOR IMPROVEMENT.  They are still categorized"
 W !?5,"as the High-Risk, High-Volume or Problem-Prone areas of patient"
 W !?5,"care.",!
 Q
 ;
SHORT ;ENTRY POINT >> help test for short name field; called by execute help
 W !!?5,"Enter an ABBREVIATED version of your key function or goal, up"
 W !,"to 40 characters long.  This SHORT NAME will appear on reports"
 W !,"where space is limited.",!
 Q
 ;
LONG ;ENTRY POINT >> help text for long name field; called by execute help
 W !!?5,"Enter the EXPANDED description of your key function, up to"
 W !,"80 characters long.  When you enter the function for the first"
 W !,"time, the computer automatically uses the short name; you just"
 W !,"need to expand those words and phrases that were abbreviated.",!
 Q
 ;
 ;
SCOPE ;ENTRY POINT for intro text to Scope of Care option
 ;called by entry action of AQAO IND SCOPE
 W @IOF,!!?30,"SCOPE OF CARE",!!
 W !!?5,"Use this option to enter the SCOPE OF CARE for your service"
 W !?5,"or department."
 Q
 ;
 ;
SCOPEPRT ;ENTRY POINT for intro text on Print Scope of Care option
 ;called by entry action of AQAO IND SCOPE PRINT
 W @IOF,!!?20,"PRINT SCOPE OF CARE FOR A HOSPITAL SERVICE",!!
 W !!?5,"Use this option to print a paper copy of your service's"
 W !?5,"Scope Of Care entered via the option ""Define SCOPE OF CARE""."
 W !!
 Q
