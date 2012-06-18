AQAOHIN1 ; IHS/ORDC/LJF - CONT. OF INDICATOR HELP TEXT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is a continuation of ^AQAOHIND. It contains entry points
 ;for help text on data fields and introductory text for indicator
 ;print options.
 ;
VISIT ;ENTRY POINT for help text  for field 'visit related?'
 ;called by xecute help
 W !!?5,"Answer YES if occurrences tied to this indicator involve a"
 W !,"patient encounter.  Answer NO if the indicator deals with"
 W !,"non-visit related occurrences.",!!
 Q
 ;
 ;
TYPE ;ENTRY POINT for help text of 'type of review' field
 ;called by xecute help
 W !!?5,"The TYPE OF REVIEW you select will determine what QUESTIONS"
 W !?5,"are asked for each occurrence related to this indicator.  For"
 W !?5,"indicators needing special reviews, i.e. Blood Transfusions,"
 W !?5,"choose that review from the list.  For all other indicators use"
 W !?5,"one of the GENERAL M&E choices.  Pick the choice 'GENERAL M&E"
 W !?5,"with ICD codes' if you need to track diagnoses and procedures"
 W !?5,"for each occurrence.",!
 Q
 ;
 ;
MSFUNC ;ENTRY POINT for help text for "medical staff function" field
 ;called by xecute help
 W !!?5,"Answer the MEDICAL STAFF/FACILITY-WIDE FUNCTION field to group"
 W !?5,"occurrences using this indicator.  This will be used in version"
 W !?5,"3 of the Staff Credentials software in the profiling process."
 W !?5,"For example, for all indicators grouped under Blood Usage"
 W !?5,"Review, their occurrences will be displayed as a group to the"
 W !?5,"person reviewing the file of a particular provider."
 W !!?5,"You may bypass this field by hitting RETURN if it does not"
 W !?5,"apply to this indicator."
 W ! Q
 ;
 ;
INDMSF ;ENTRY POINT for option AQAO IND MS FUNCTION
 ;called by menu entry action
 W @IOF,!!?20,"INDICATORS BY MEDICAL STAFF FUNCTION",!!
 W !!?5,"Use this option to print a listing of indicators that have"
 W !?5,"been GROUPED by Medical Staff Function.  These groupings will"
 W !?5,"be used by version 3 of the Staff Credentials software when"
 W !?5,"viewing data from this QAI Management package.  For example,"
 W !?5,"all occurrences for indicators grouped under Surgical Case"
 W !?5,"Review will be displayed together.  This listing here lets you"
 W !?5,"know if you have indicators defined for all REQUIRED medical"
 W !?5,"staff QI reviews.",!!
 Q
 ;
 ;
RTYPE ;ENTRY POINT for intro text on option AQAO QUICK REVIEW TYPE
 ; called by entry action
 W @IOF,!!?15,"QUICK REFERENCE - TYPE OF REVIEW PERFORMED"
 W !?25,"with QUESTIONS ASKED",!!
 W !!?5,"Use this option to print a list of all REVIEW TYPES and the"
 W !?5,"QUESTIONS ASKED by each.  This may enable you to correctly"
 W !?5,"select which review type is appropriate for your indicator."
 W !! Q
 ;
 ;
DEFAULT ;ENTRY POINT for help text for default fields
 ;called by execute help for Default Finding, Action & Stage
 W !!,"The 3 questions DEFAULT FINDING, DEFAULT ACTION, & DEFAULT"
 W !,"STAGE are ONLY answered for those indicators where you plan"
 W !,"to collect occurrence data but not review each case entered."
 W !,"In those instances, these defaults will be automatically "
 W !,"stuffed into the initial review for each occurrence.  This"
 W !,"speeds up data entry for those types of indicators."
 W !! Q
