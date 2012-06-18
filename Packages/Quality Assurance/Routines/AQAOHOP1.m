AQAOHOP1 ; IHS/ORDC/LJF - HELP TEXT FOR OCC REPORTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;for occurrence reports.  More can be found in rtns ^AQAOHOP2,P3.
 ;
SUMM ;ENTRY POINT intro text for to print occurrence summaries
 ;    called by entry action of option AQAO PRINT OCC SUMMARY
 W @IOF,!!?20,"PRINT OCCURRENCE SUMMARIES",!!
 W !?5,"Use this option to print full page summaries of selected"
 W !?5,"occurrences.  Once you select one occurrence, you will be asked"
 W !?5,"to select another.  Upon choosing all you wish to print, simply"
 W !?5,"hit <return> to proceed to the device prompt."
 W !! Q
 ;
 ;
WRKSHT ;ENTRY POINT intro text for to print occurrence review worksheets  
 ;    called by entry action of option AQAO OCC WORKSHEET
 W @IOF,!!?20,"PRINT REVIEW WORKSHEETS FOR OCCURRENCES",!!
 W !?5,"Use this option if you wish to print a WORKSHEET for your"
 W !?5,"review of one or more occurrences.  You will be asked to choose"
 W !?5,"the REVIEW STAGE for your worksheets.  Then you will be asked"
 W !?5,"for all the occurrences for which you need a worksheet at that"
 W !?5,"review stage.  Each worksheet lists your OPTIONS for possible"
 W !?5,"findings and actions related to that review stage.",!!
 Q
 ;
 ;
APLAN ;ENTRY POINT intro text to print a summary of selected action plans
 ;    called by entry action of option AQAO ACTPLAN PRINT
 W @IOF,!!?20,"PRINT ACTION PLAN SUMMARIES",!!
 W !?5,"Use this option to print full page summaries of action plans"
 W !?5,"tied to your review of occurrences.  Action plans are specific"
 W !?5,"projects to improve quality based on the review of occurrences."
 W !?5,"Please see the EVALUATION OF ACTIONS Menu for more details on"
 W !?5,"action plans.",!!
 Q
 ;
 ;
QRACT ;ENTRY POINT for intro text for quick reference on actions
 ;    called by entry action of option AQAO QUICK ACTIONS
 W @IOF,!!?10,"PRINT QUICK REFERENCE SHEET - ACTIONS With Abbreviations"
 W !!?5,"Use this option to print a REFERENCE SHEET of the ACTIONS"
 W !?5,"available for occurrence reviews with their associated"
 W !?5,"ABBREVIATIONS.  This will help you to read reports where there"
 W !?5,"is only enough room for the abbreviations.",!!
 Q
 ;
 ;
QRFND ;ENTRY POINT for intro text for quick reference on findings
 ;    called by entry action of option AQAO QUICK FINDINGS
 W @IOF,!!?7,"PRINT QUICK REFERENCE SHEET - FINDINGS With Abbreviations"
 W !!?5,"Use this option to print a REFERENCE SHEET of the FINDINGS"
 W !?5,"available for occurrence reviews with their associated"
 W !?5,"ABBREVIATIONS.  This will help you to read reports where there"
 W !?5,"is only enough room for the abbreviations.",!!
 Q
 ;
 ;
QRIND ;ENTRY POINT for intro text for quick reference on indicators
 ;    called by entry action of option AQAO QUICK INDICATOR
 W @IOF,!!?7,"PRINT QUICK REFERENCE SHEET - INDICATORS By Number"
 W !!?5,"Use this option to print a REFERENCE SHEET of the INDICATORS"
 W !?5,"available for occurrence reviews along with their CODE NUMBER."
 W !?5,"This will help you to read reports where there is only enough"
 W !?5,"room for the indicator number.",!!
 Q
