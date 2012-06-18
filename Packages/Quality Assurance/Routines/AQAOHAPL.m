AQAOHAPL ; IHS/ORDC/LJF - HELP TEXT: ACTION PLAN OPTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introdcutory text for options
 ;as well as help text for data fields pertaining to action plans.
 ;
ADD ;ENTRY POINT for intro text on add action plan option
 ;    called by entry action of option AQAO ACTPLAN ADD
 W @IOF,!!?30,"ADD NEW ACTION PLAN",!!
 W !?5,"Use this option to add a new DETAILED ACTION PLAN linked to"
 W !?5,"a CLINICAL INDICATOR whose review initiated the action.  This"
 W !?5,"option will ask for details of the plan's implementation.  As"
 W !?5,"you update the status of the plan you will be asked for more"
 W !?5,"data to include implementation date, proposed review date, the"
 W !?5,"criteria to evaluate its effectiveness, and a summary of that"
 W !?5,"evaluation.",!!
 Q
 ;
 ;
IND ;ENTRY POINT for help text on INDICATOR ASSESSMENT REPORT field
 ;    called by input template AQAO PLAN EDIT
 W !!?10,"INDICATOR ASSESSMENT REPORT (wordprocessing field):"
 W !?5,"Please enter your assessment of the process measured by"
 W !?5,"this clinical indicator.  Discuss the findings of the data"
 W !?5,"collection referencing statistic tools, trending analysis,"
 W !?5,"and appropriate comparisons.  Why are you taking this action?"
 W !?5,"You can make references to other documents, as necessary."
 W !! Q
 ;
 ;
SUMM ;ENTRY POINT for help text on ACTION TAKEN field
 ;    called by input template AQAO PLAN EDIT
 W !!?15,"ACTION TAKEN (wordprocessing field):"
 W !!?5,"Please enter the specifics of this action plan.  You can be"
 W !?5,"as detailed as you wish.  Include references to other related"
 W !?5,"documents, if they exit.  You may include the process change"
 W !?5,"you propose, the implementation steps, and goals you wish to"
 W !?5,"reach.  You will have opportunities to update this summary as"
 W !?5,"you move into the implementation and evaluation phases of the"
 W !?5,"project."
 W !!
 Q
 ;
 ;
UPDATE ;ENTRY POINT for intro text to update action plan
 ;    called by entry action of option AQAO ACTPLAN UPDATE
 W @IOF,!!?20,"UPDATE AN ACTION PLAN",!!
 W !?5,"Use this option to UPDATE the STATUS of your action plan.  As"
 W !?5,"the plan enters each new phase, more data is requested such as"
 W !?5,"the IMPLEMENTATION DATE and the PROPOSED REVIEW DATE.  To keep"
 W !?5,"the process moving, as the plan is implemented you will be"
 W !?5,"asked for the CRITERIA to be used to evaluate the effectiveness"
 W !?5,"of this action.  Once the plan moves into the review phase, you"
 W !?5,"will be asked to give an EVALUATION REPORT and RATE the plan's"
 W !?5,"effectiveness.  At this point you can link it to a new plan."
 W !! Q
 ;
 ;
TEAM ;ENTRY POINT for help text on implementation team field
 ;    called by input template AQAO PLAN EDIT
 W !!?15,"IMPLEMENTATION TEAMS (multiple field):"
 W !!?5,"Enter the QI TEAM(S) involved in implementing this plan.  To"
 W !?5,"see the teams you have already entered or to see a list of all"
 W !?5,"teams in the computer system, enter a '?'.  See your QAI"
 W !?5,"Package Administrator for details on setting up a QI team in "
 W !?5,"the computer.",!!
 Q
 ;
 ;
CRITERIA ;ENTRY POINT for help text for evaluation criteria field
 ;    called by input template AQAO PLAN EDIT
 W !!?15,"PERFORMANCE MEASUREMENTS (wordprocessing field):"
 W !!?5,"Please enter those measurements or criteria you plan to use"
 W !?5,"to assess the effectiveness of this action plan.  Include"
 W !?5,"objective measurements and please be as specific as possible."
 W !! Q
 ;
 ;
REPORT ;ENTRY POINT for help text ofr evaluation report field
 ;    called by input template AQAO PLAN EDIT
 W !!?15,"ACTION ASSESSMENT REPORT (wordprocessing field):"
 W !?5,"Please enter your evaluation of the action plan, noting its"
 W !?5,"EFFECTIVENESS in improving patient care, any FURTHER ACTION to"
 W !?5,"be taken, the on-going MONIITORING MECHANISM, and how these"
 W !?5,"results will be COMMUNICATED to the appropriate parties.",!!
 Q
 ;
 ;
NEWNUM ;ENTRY POINT for help text on new action plan number field
 ;    called by execute help
 W !!?5,"For those plans with a status of REVIEWED-PARTIALLY EFFECTIVE,"
 W !?5,"REVIEWED-INEFFECTIVE CHANGE or DELETED, you may enter the"
 W !?5,"number of another action plan that supersedes this one.",!!
 Q
 ;
 ;
REOPEN ;ENTRY POINT for intro text to option that reopens plans
 ;called by entry action of option AQAO ACTPLAN REOPEN
 W @IOF,!!?20,"REOPEN A CLOSED ACTION PLAN",!!
 W !!?5,"Use this option to REOPEN an Action Plan that has been"
 W !?5,"CLOSED.  This allows you to then update the plan using the"
 W !?5,"UPDATE ACTION PLAN option.  NOTE:  Deleted action plans cannot"
 W !?5,"be reopened.  Their plan status must be changed to other than"
 W !?5,"deleted to allow updating.",!!
 Q
