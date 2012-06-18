AQAOHOP3 ; IHS/ORDC/LJF - HELP TEXT FOR MORE OCC REPORTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtns contains more entry points on introductory texts for
 ;occurrence-base report options.
 ;
REVT ;ENTRY POINT for help text on ^AQAOPC7
 W @IOF,!!?20,"OCCURRENCE REPORTS WITH EXTRA SORT FIELD",!!
 W !!?5,"Use this report to print one of the main trending reports"
 W !?5,"by indicator with an additional sort added on.  You can choose"
 W !?5,"from a list of possible sort fields and choose which sort"
 W !?5,"values to include.",!!
 Q
 ;
 ;
PROV ;ENTRY POINT for intro text on ^AQAOPC8 provider reports
 W @IOF,!?25,"PROVIDER OCCURRENCE REPORTS"
 W !!?5,"Use this option to print reports on occurrences sorted by"
 W !?5,"PROVIDER.  If you are a mamber of the QI staff, you have the"
 W !?5,"choice of two kinds of reports.  One is to print TRENDING"
 W !?5,"reports by provider and the other a single PROVIDER PROFILE.",!
 W !! Q
 ;
 ;
PROVQ ;ENTRY POINT for question on types of provider reports
 W !!?5,"The Trending Report allows you to select the providers and"
 W !?5,"to select the report to run.  Your choices are OCCURRENCES"
 W !?5,"BY REVIEW CRITERIA, OCCURRENCES BY DIAGNOSIS/PROCEDURE, or"
 W !?5,"OCCURRENCES BY FINDINGS/ACTIONS.  All the data will be sorted"
 W !?5,"and subtotaled by provider.",!
 W !?5,"The PROVIDER PROFILE gives you a summary of occurrences for"
 W !?5,"ONE provider sorted by the MEDICAL STAFF FUNCTIONS you specify."
 W !?5,"Displayed for each occurrence will be the final finding, final"
 W !?5,"action, provider's occurrence designation (Primary, Ordering,"
 W !?5,"etc.), whether the action is directed at this provider, and"
 W !?5,"the various outcome levels for the occurrence (Potential Risk,"
 W !?5,"Actual Occurrence Outcome, and Ultimate Patient Outcome)."
 Q
 ;
 ;
OUTCOME ;ENTRY POINT for option that prints outcome levels quick reference
 ;called by entry action of AQAO QUICK OUTCOME
 W @IOF,!!?10,"QUICK REFERENCE - OUTCOME/PERFORMANCE LEVELS",!!
 W !!?5,"Use this option to print a handy reference of the defined"
 W !?5,"outcome and performance levels for your facility.  Some"
 W !?5,"reports only print the level number and not the description"
 W !?5,"due to lack of sufficient space.  Use this report to decipher"
 W !?5,"the numbers."
 W !! Q
 ;
 ;
CLOSED ;ENTRY POINT for intro text for closed occ report
 ;called by entry action of AQAO PRINT OCC CLOSED
 W @IOF,!!?20,"QUARTERLY PROGRESS REPORT",!!
 W !!?5,"Use this option to review the PROGRESS made in different "
 W !?5,"quality improvement areas.  You can review the progress on ONE"
 W !?5,"clinical INDICATOR, or all indicators for a KEY FUNCTION, or"
 W !?5,"a defined group of indicators (FACILITY-DEFINED REPORT FORMAT)."
 W !?5,"Your QAI Package Administrator can set up a defined group of"
 W !?5,"indicators as a report format.  Although this report is most"
 W !?5,"useful on a quarterly basis, you can defined any date range"
 W !?5,"you wish.",!! Q
 ;
 ;
REVWD ;ENTRY POINT for intro text for reviewed occ report
 ;called by entry action of option AQAO PRINT OCC REVIEWED
 W @IOF,!!?20,"REVIEWED OCCURRENCES REPORT",!!
 W !!?10,"Use this option to TRACK the REVIEW PROCESS of your"
 W !?5,"occurrences.  It will list each occurrence to which you have"
 W !?5,"access, the reviews performed, and all referrals made.  The"
 W !?5,"report is sorted by clinical indicator based on your selection"
 W !?5,"and can be limited to certain users and/or QI teams. A summary"
 W !?5,"prints the number of occurrences reviewed for each reviewer"
 W !?5,"by indicator plus the total occurrences reviewed."
 W !! Q
 ;
SCRIT ;ENTRY POINT for intro text to single criterion trending report
 ;called by ^AQAOPC7
 W @IOF,!!?20,"SINGLE CRITERION TRENDING REPORT",!!
 W !?5,"Use this report to look for monthly trends on one particular"
 W !?5,"criterion for your indicator.  This report does not give a"
 W !?5,"listing of occurrences.  It just gives you totals by month"
 W !?5,"of the different values possible for your criterion.  This"
 W !?5,"report is also available if you select the Trending Report"
 W !?5,"with Extra Sort Criteria.",!
 Q
