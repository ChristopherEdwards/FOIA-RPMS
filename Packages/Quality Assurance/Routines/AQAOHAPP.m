AQAOHAPP ; IHS/ORDC/LJF - HELP TEXT: ACTION PLAN PRINTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for the introductory text for action
 ;plan report options.
 ;
IMPLEM ;ENTRY POINT for intro text for implementation report
 ;    called by entry action of option AQAO ACTPLAN IMPLEMENT PRINT
 W @IOF,!!?20,"ACTION IMPLEMENTATION STATUS REPORT",!!
 W !?5,"Use this option to print a listing of action plans either"
 W !?5,"AWAITING IMPLEMENTATION or IMPLEMENTED but not reviewed.  The"
 W !?5,"report can be sorted by action plan #, by action type, by"
 W !?5,"action status or by implementation date.  You will be asked if"
 W !?5,"you want to include action plan SUMMARIES with the listing.  If"
 W !?5,"you sort by implementation date, you will get only those plans"
 W !?5,"already implemented."
 W !! Q
 ;
 ;
DUE ;ENTRY POINT for intro text to plans due for evaluation report
 ;    called by entry action of option AQAO ACTPLAN DUE
 W @IOF,!!?20,"ACTION PLANS DUE FOR EVALUATION & REVIEW",!!
 W !?5,"Use this option to print a listing of those plans that are"
 W !?5,"READY FOR EVALUATION.  The report prints only IMPLEMENTED plans"
 W !?5,"with review dates in the past or with no review date.  You can"
 W !?5,"sort the report by plan #, by action type, or by review date."
 W !! Q
 ;
 ;
WRKSHT ;ENTRY POINT for intro text for action evaluation worksheets
 ;    called by entry action of option AQAO ACTPLAN WORKSHEET
 W @IOF,!!?20,"PRINT ACTION EVALUATION WORKSHEETS",!!
 W !?5,"Use this option to print WORKSHEETS used in the evaluation of"
 W !?5,"action plans.  You can choose as many action plans as you want"
 W !?5,"from the list of IMPLEMENTED ones.  This worksheet will be most"
 W !?5,"effective if you enter the EVALUATION CRITERIA in a worksheet"
 W !?5,"format.",!!
 Q
 ;
 ;
REV ;ENTRY POINT for intro text for reviewed actions report
 ;    called by entry action of option AQAO ACTPLAN REVIEWED
 W @IOF,!!?20,"REVIEWED ACTION PLANS REPORT UTILITY",!!
 W !?5,"Use this option to print VARIOUS LISTINGS of actions that"
 W !?5,"have been REVIEWED and are no longer active.  You can SORT"
 W !?5,"the report by plan #, by action type, by date implemented, by"
 W !?5,"review date, or by implementation team.  You can LIMIT the"
 W !?5,"plans printed by the sort category you selected.  You will"
 W !?5,"also be asked to choose between printing BRIEF LISTINGS or"
 W !?5,"FULL-PAGE SUMMARIES of each plan.",!!
 Q
 ;
 ;
DELETED ;ENTRY POINT for intro text for deleted plans report
 ;    called by entry action of option AQAO ACTPLAN DELETED
 W @IOF,!!?20,"LISTING OF DELETED ACTION PLANS",!!
 W !?5,"Use this option to print a listing of DELETED action plans."
 W !?5,"You can limit the list by CLOSE OUT DATE.  The listing will"
 W !?5,"include new action plan numbers if noted.",!!
 Q
