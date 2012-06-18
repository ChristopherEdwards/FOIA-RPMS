AQAOHPAR ; IHS/ORDC/LJF - PARAMETER FILE & RTN HELP ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for intro texts on options
 ;and help text on data fields for the QI Parameter options.
 ;
ADD ;EP; for intro text on adding new facility to file
 ;called by entry action of option AQAO PKG PARAMETER ADD
 W @IOF,!!?20,"ADD NEW FACILITY TO QI PARAMETER FILE",!!
 W !!?5,"Use this option to ADD additional facilities as QAI sites"
 W !?5,"for this package.  Your main site was added during software"
 W !?5,"installation.  Once you add the new facility, use the other"
 W !?5,"options on this menu to customize the new site.",!!
 Q
 ;
 ;
LINK ;EP; for intro text on editing qi parameters linkages
 ;called by entry action of option AQAO PKG PARAMETER LINK
 W @IOF,!!?20,"EDIT LINKAGES TO OTHER RPMS PACKAGES",!!
 W !!?5,"Use this option to EDIT linkages with other RPMS packages."
 W !?5,"Here you can customize these linkages as well as turning them"
 W !?5,"on and off as your needs change.  If you have many facilities"
 W !?5,"entered in this file, be sure to check the status of these"
 W !?5,"linkages for each one!",!!
 Q
 ;
 ;
RPT ;EP; for intro text on setting up facility reports
 W @IOF,!!?20,"CREATE CUSTOMIZED REPORTS FORMATS",!!
 W !!?5,"Use this option to customize the Quarterly Progress Report"
 W !?5,"for each of your facilities.  You can create as many different"
 W !?5,"formats as you like.  Formats can be restricted to certain"
 W !?5,"users or left unrestricted.  There is plenty of help text to"
 W !?5,"assist you in setting up a custom format.",!!
 Q
 ;
 ;
ACCESS ;EP; to print help text on RESTRICTED ACCESS field
 ;called by DR string in ^AQAOLARP
 W !!!?20,"IS ACCESS TO THIS REPORT TO BE RESTRICTED?",!
 W !?5,"If you want to RESTRICT access, enter only those users who"
 W !?5,"should have access.  If you do NOT want to restrict access to"
 W !?5,"the report format, do not enter any names and the program"
 W !?5,"assumes it is UNRESTRICTED.",!!
 Q
 ;
 ;
MSF ;EP; to print help text for med staff function multiple
 ;called by DR string in ^AQAOLARP
 W !!!?20,"MEDICAL STAFF FUNCTIONS FOR THIS REPORT",!
 W !?5,"Enter those Medical Staff Functions you want to include in this"
 W !?5,"particular report.  When printing the report, the computer will"
 W !?5,"find all indicators linked to each Med Staff Function at print"
 W !?5,"time.  To see which indicators are presently linked to the MS"
 W !?5,"Functions you've listed here, use the PRINT FACILITY REPORT"
 W !?5,"FORMAT option on the menu.  If you don't enter any MS Functions"
 W !?5,"here, there won't be a ""MEDICAL STAFF FUNCTIONS"" heading on"
 W !?5,"this report.",!!
 Q
 ;
 ;
DIM ;EP; print help text for dimensions of performance;ENH1
 ;called by DR string in ^AQAOLARP
 W !!!?20,"DIMENSIONS OF PERFORMANCE FOR THIS REPORT",!
 W !?5,"Enter those Dimensions of Performance you want to include in"
 W !?5,"this particular report. When printing the report, the computer"
 W !?5,"will find all indicators linked to each dimension at print"
 W !?5,"time. To see which indicators are presently linked to the"
 W !?5,"Dimensions you've listed here, use the PRINT FACILITY REPORT"
 W !?5,"FORMAT option on the menu.  If you don't select any Dimensions"
 W !?5,"here, there won't be a ""DIMENSIONS OF PERFORMANCE"" section"
 W !?5,"on this report.",!!
 Q
 ;
 ;
FWIDE ;EP; to print help text for hospital wide indicators multipl
 ;called by DIR string in ^AQAOLARP
 W !!!?20,"FACILITY-WIDE INDICATORS",!
 W !?5,"Enter those indicators you wish to include under the heading of"
 W !?5,"Facility-Wide Indicators in this particular report.  At print"
 W !?5,"time, these indicators will be screened to eliminate those to"
 W !?5,"which you do not have access.  If an indicator has been made"
 W !?5,"inactive, it will still appear on the report until you remove"
 W !?5,"it from this list.  If you don't enter any indicators here, "
 W !?5,"there will be no heading titled ""Facility-Wide Indicators"".",!
 W ! Q
 ;
 ;
KEYF ;EP; to print help text for key functions multiple
 ;called by DR string in ^AQAOLARP
 W !!!?20,"KEY FUNCTIONS FOR THIS REPORT",!
 W !?5,"Enter those Key Functions you wish to include on this report."
 W !?5,"At print time, the computer will print the results for all the"
 W !?5,"indicators linked to these key functions.  INACTIVE indicators"
 W !?5,"and those to which you don't have access will be screened from"
 W !?5,"the report.  If you don't enter any Key Functions here, there"
 W !?5,"will be no heading titled ""KEY FUNCTIONS"" on your report.",!!
 Q
 ;
 ;
OTHER ;EP; to print help text for other indicators multiple
 ;called by DR string in ^AQAOLARP
 W !!!?20,"OTHER INDICATORS TO INCLUDE IN THIS REPORT",!
 W !?5,"Enter any other indicators, not included in any of the other"
 W !?5,"categories, that you want on this report.  Check the option"
 W !?5,"titled ""PRINT FACILITY REPORT FORMAT"" to see a list of those"
 W !?5,"indicators included under the Medical Staff Functions and the"
 W !?5,"Key Functions headings.",!!
 Q
