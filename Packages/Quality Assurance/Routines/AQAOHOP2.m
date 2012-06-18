AQAOHOP2 ; IHS/ORDC/LJF - HELP TEXT FOR MORE OCC REPORTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains more entry points for introductory texts on
 ;occurrence-based reports.
 ;
CRIT ;ENTRY POINT for intro text on option AQAO PRINT OCC WITH CRITERIA
 ;option prints occ by indicator with criteria values
 W @IOF,!!?20,"OCCURRENCES BY INDICATOR WITH CRITERIA VALUES",!!
 W !?5,"Use this option as an EVALUATION TOOL for occurrences based on"
 W !?5,"an indicator with criteria defined for it.  If you choose to"
 W !?5,"print the LISTING it will list occurrences for the date range &"
 W !?5,"indicator with criteria & their values.  The SUMMARY PAGE will"
 W !?5,"list all CRITERIA for the indicator, the totals for each VALUE,"
 W !?5,"and percentages to compare with the defined THRESHOLD."
 W !?5,"Choose STATISTICS ONLY for the SUMMARY PAGE without the listing"
 W !?5,"of each occurrence.",!! Q
 ;
TICKLER ;ENTRY POINT for intro text to option AQAO PRINT OCCC TICKLER
 ;option print list of occurrences needing review or close out
 W @IOF,!!?20,"OCCURRENCE TICKLER REPORT",!!
 W !?5,"Use this option to print a listing of occurrences and actions"
 W !?5,"needing review.  First it will print the message you see when "
 W !?5,"you sign on the QAI Management system.  You can then print"
 W !?5,"any or all of the categories available.  This report helps you"
 W !?5,"keep track of your current occurrences.",!
 Q:($P(AQAOUA("USER"),U,6)="")  ;no qi staff
 W !?5,"QI staff members have the choice to print the report just as"
 W !?5,"it appears on their Introductory message OR to print the list"
 W !?5,"for an individual USER or QI TEAM.  This gives the QI Staff a"
 W !?5,"better indication of the workload and progress being made by"
 W !?5,"users and teams in getting their reviews done.",! Q
 ;
ICD ;ENTRY POINT for option to print occ by icd codes
 ; called by option AQAO PRINT OCC BY ICD
 W @IOF,!!?20,"OCCURRENCE LISTING WTH DIAGNOSES & PROCEDURES",!!
 W !!?5,"Use this option to print occurrences for which you have "
 W !?5,"entered DIAGNOSIS ICD CODES and/or PROCEDURE ICD CODES.  You "
 W !?5,"will be asked to choose to print occurrences for one INDICATOR"
 W !?5,"and for a given DATE RANGE.  You then can limit the listing to"
 W !?5,"certain DIAGNOSES (includes COMPLICATIONS) and /or PROCEDURES."
 W !?5,"You can print both the OCCURRENCE LISTING plus STATISTICS or"
 W !?5,"just the STATISTICS PAGE. "
 W !?5,"WARNING: The listing format prints on wide paper or condensed"
 W !?5,"print for 132 columns.",!! Q
 ;
BYVISIT ;ENTRY POINT for intro text for option to print occ for a visit
 ;called by entry action of AQAO PRINT OCC A VISIT
 W @IOF,!!?20,"PRINT ALL OCCURRENCES DURING A SELECTED VISIT",!!
 W !!?5,"Use this option to list ALL occurrences entered for a"
 W !?5,"patient's visit.  It could prove helpful, when evaluating an"
 W !?5,"occurrence, to know if other occurrences were noted.  Review"
 W !?5,"could point to an important relationship between occurrences."
 W !?5,"Unlike many reports, you WILL see occurrences for ALL clinical"
 W !?5,"indicators, not just your own.",!! Q
 ;
BYPAT ;ENTRY POINT for intro text for option to print occ for a pat
 ;called by entry action of AQAO PRINT OCC A PATIENT
 W @IOF,!!?10,"PRINT ALL A PATIENT'S OCCURRENCES DURING DATE RANGE",!!
 W !!?5,"Use this option to print ALL occurrences for a PATIENT within"
 W !?5,"a VISIT DATE RANGE.  This report could help point out trends"
 W !?5,"for patients with frequent visits.  Unlike many other reports,"
 W !?5,"you WILL see occurrences for ALL clinical indicators, not just"
 W !?5,"your own.",!! Q
 ;
FINDACT ;ENTRY POINT for intro text for option to print occ w/ find/actions
 ;called by entry action of AQAO PRINT OCC FINDINGS
 W @IOF,!!?20,"OCCURRENCES WITH FINDINGS AND ACTIONS",!!
 W !!?5,"Use this option to print occurrences for a selected clinical"
 W !?5,"indicator and selected date range with the last FINDING and"
 W !?5,"ACTION displayed.  The report will subtotal the occurrences"
 W !?5,"by the various findings and actions.  You can choose to print"
 W !?5,"ONLY Closed cases or BOTH Closed and Open cases.",!! Q
 ;
TREND ;ENTRY POINT for intro text to trending reports menu
 ;called by entry action of AQAO PRINT OCC TREND RPT
 W @IOF,!!?20,"OCCURRENCE TRENDING REPORTS",!!
 W !!?5,"Use these reports listed below to TRACK and EVALUATE any"
 W !?5,"possible trends related to your occurrences.  The QUALITY of"
 W !?5,"individual occurrences may appear fine yet a PATTERN can"
 W !?5,"emerge when reviewing many of these occurrences over time.",!!
 Q
