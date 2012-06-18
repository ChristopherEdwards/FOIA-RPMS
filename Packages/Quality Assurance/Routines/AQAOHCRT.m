AQAOHCRT ; IHS/ORDC/LJF - HELP TEXT FOR CRITERIA ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;and help text on data fields for review criteria data entry and
 ;report options.
 ;
CRINTRO ;ENTRY POINT for introduction to criteria edit option
 ;called by rtn ^AQAODICC
 W @IOF,!!!?15,"Define REVIEW CRITERIA for specified INDICATORS",!!
 W !?5,"Use this option to define REVIEW CRITERIA for each of your"
 W !?5,"INDICATORS.  The criteria will be used in the evaluation"
 W !?5,"process to IDENTIFY TRENDS and to help highlight possible areas"
 W !?5,"of IMPROVEMENT.  Define criteria ONLY for those indicators"
 W !?5,"where the data collection method is OCCURRENCE TRACKING and"
 W !?5,"where factors beyond diagnosis, procedure, and provider are"
 W !?5,"needed in the evaluation.",!!
 Q
 ;
 ;
QREF ;ENTRY POINT for intro to criteria quick reference
 ;called by entry action for option AQAO QUICK CRITERIA
 W @IOF,!!!?15,"QUICK REFERENCE - REVIEW CRITERIA by INDICATOR",!!
 W !?5,"Use this option to print a REFERENCE SHEET for yourself of"
 W !?5,"the REVIEW CRITERIA defined for a particular indicator.  This"
 W !?5,"will be helpful if you are using occurrence data collection or"
 W !?5,"evaluation worksheets with only criteria numbers.",!!
 Q
 ;
 ;
LINK ;ENTRY POINT for intro text on quick ref-indicator/criteria links
 ;called by entry action of AQAO QUICK
 W @IOF,!!?15,"QUICK REFERENCE - INDICATOR/CRITERIA LINKS",!!
 W !!?5,"Use this option to check to see which indicators are using"
 W !?5,"a particular review criteria.  This is very helpful if you are"
 W !?5,"thinking of changing a criteria's definition.  You need to see"
 W !?5,"who else will be affected.  This option only displays to your"
 W !?5,"screen.",!
 Q
 ;
 ;
TRIGGER ;ENTRY POINT help text on treshold/trigger field in qi rev crit file
 ;called by xecute help
 W !!?5,"For those indicators that are labeled RATE-BASED, a THRESHOLD"
 W !,"will be requested.  Here you can specify an INDIVIDUAL treshold"
 W !,"for this review criteria for this indicator.  This can help you"
 W !,"watch for trends for each criteria as well as overall trends for"
 W !,"the indicator.  Please remember that a Desirable Trend Indicator"
 W !,"will have a HIGH Threshold number (for example, 95%) and an"
 W !,"Undesirable Trend Indicator should have a LOW number, (say 5%)."
 W !,"For this field, just enter the number; the computer will add the"
 W !,"'%' to the end.",!
 Q
