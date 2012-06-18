AQAOHPRT ; IHS/ORDC/LJF - HELP TEXT FOR IND PRINTOUTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory texts on options
 ;for reports found on the Indicator Development menu.
 ;
CID ;ENTRY POINT >> intro text for clinical indicator display
 W @IOF W !!?20,"CLINICAL INDICATOR DISPLAY"
 W !!?5,"Use this option to print a summary on a particular clinical"
 W !?5,"indicator.  The Summary includes code #, name, description,"
 W !?5,"type, threshold, key function, QI team members, methodology,"
 W !?5,"and review criteria and exceptions.",!
 Q
 ;
ILS ;ENTRY POINT >> intro text for indicator listings & summaries
 W @IOF W !!?15,"CLINICAL INDICATOR LISTINGS & SUMMARIES",!
 W !?5,"Use this option to print listings of indicators by code #,"
 W !?5,"by QI team, or by key function.  Also use this option to print"
 W !?5,"groupings of indicator summaries, for a range of code numbers"
 W !?5,"or sorted by QI team or by function.",!
 S X="AQAOPR8" X ^%ZOSF("TEST") I $T D  ;ENHANCE 1
 . W !
 . W ?5,"With Enhancement #1 a third choice has been added. The matrix"
 . W !?5,"shows which Key Functions and/or Dimensions of Performance"
 . W !?5,"are covered by the indicators you have defined.",!
 Q
 ;
FNC ;ENTRY POINT >> intro text for hospital service summary; entry action
 W @IOF W !!?20,"SUMMARY BY KEY FUNCTION"
 W !!?5,"Use this option to print a SUMMARY for the KEY FUNCTION you"
 W !?5,"specify listing all INDICATORS linked to it.  If there are any"
 W !?5,"ACTION PLANS linked to those indicators, they will also be"
 W !?5,"displayed.  Over time, this summary can show the quality"
 W !?5,"improvement work that has been done for a key function.",!
 Q
 ;
PWK ;ENTRY POINT >> intro text for print worksheet option; entry action
 W @IOF W !!?15,"PRINT OCCURRENCE WORKSHEET FOR DATA ENTRY"
 W !!!?5,"Use this option to print BLANK WORKSHEETS for collecting"
 W !?5,"occurrence data.  This is especially helpful when dealing with"
 W !?5,"indicators with many REVIEW CRITERIA.  You will be asked to"
 W !?5,"SELECT the INDICATOR name, the REVIEW LEVEL for the initial"
 W !?5,"review, and the printer name. Then MAKE MANY COPIES of this"
 W !?5,"worksheet and place them in a convenient location for the"
 W !?5,"collection of the appropriate data.",!
 Q
 ;
 ;
MATRIX ;EP; -- intor text for indicator matrix report
 W @IOF W !!?20,"PRINT CLINICAL INDICATOR MATRIX",!!
 W !?5,"Use this report to see how many Key Functions and Dimensions"
 W !?5,"of Performance are monitored by your defined indicators. This"
 W !?5,"gives you a good overall view of your quality improvement"
 W !?5,"activities.",!!
 Q
