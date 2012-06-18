AQAOHEX ; IHS/ORDC/LJF - HELP TEXT FOR EXCEPTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for the introductory text on options
 ;and help text on data fields for Exceptions to Criteria.
 ;
EXCEDIT ;ENTRY POINT >> intro text for exception entry/edit; entry action call
 W @IOF,!!?20,"EXCEPTIONS TO INDICATOR"
 W !!?5,"Use this option to enter any exceptions to clinical"
 W !?5,"indicators already defined.  Exceptions are flags which show"
 W !?5,"that a particular case doesn't belong in the general grouping."
 W !?5,"For example, for the indicator 'READMISSION WITHIN 14 DAYS',"
 W !?5,"an exception could be 'PLANNED READMISSION'.",!
 Q
 ;
REASON ;ENTRY POINT  >>> help text for reason field; xecutable help
 W !!
 W ?5,"Enter the REASON a particular occurrence may be excepted from a"
 W !,"clinical indicator.  The reason can be up to 100 characters long."
 W ! Q
 ;
CODE ;ENTRY POINT  >>> help text for code field; xecutable help
 W !!?5,"Enter a code number to identify this reason.  You may use"
 W !,"both numbers and letters up to 5 characters long.  You may wish"
 W !,"to group exceptions by service (OB001) or just number them in"
 W !,"sequential order.",!
 Q
