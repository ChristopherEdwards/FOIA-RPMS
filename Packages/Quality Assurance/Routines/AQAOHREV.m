AQAOHREV ; IHS/ORDC/LJF - HELP TEXT FOR OCC REVIEWS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;for reviewing, closing, deleting, and reopening occurrences.
 ;
INTRO ;ENTRY POINT intro text for occurrence review option
 ;    called by entry action on AQAO OCC REVIEW EDIT
 W @IOF,!!?20,"ENTER & EDIT OCCURRENCE REVIEWS",!!
 W !?5,"Use this option to enter all reviews on an occurrence"
 W !?5,"beyond the initial review.  You can also use this option to"
 W !?5,"edit (change) reviews already entered."
 W !! Q
 ;
 ;
VAL ;ENTRY POINT intro text for validate/close out occurrence options
 ;    called by entry action for AQAO OCC CLOSE OUT
 W @IOF,!!?20,"OCCURRENCE VALIDATION & CLOSE OUT",!!
 W !?5,"Selected users will use this option to enter the FINAL"
 W !?5,"FINDINGS, ACTIONS, and SEVERITY OF OUTCOME determinations for"
 W !?5,"an occurrence, including the LAST REVIEW STAGE.  In addition,"
 W !?5,"the CLOSE OUT DATE is noted as well as WHO CLOSED OUT the "
 W !?5,"selected occurrence.  This function is used to bring an end to "
 W !?5,"the review process.  You can view a closed occurrence via the"
 W !?5,"the OCCURRENCE SUMMARY option.  Otherwise, once an occurrence"
 W !?5,"is CLOSED it can only be edited if REOPENED.  To perform this,"
 W !?5,"use the 'REOPEN a Closed/Deleted Occurrence' on this menu."
 Q
 ;
 ;
REOPEN ;ENTRY POINT intro text for reopen occurrences option
 ;    called by entry action for AQAO OCC REOPEN
 W @IOF,!!?15,"REOPEN A CLOSED OR DELETED OCCURRENCE RECORD",!!
 W !?5,"Use this option to reopen any occurrence that has previously"
 W !?5,"been closed out or deleted.  Once this is done, the occurrence"
 W !?5,"will be available for editing in the other data entry options."
 W !! Q
 ;
 ;
DELETE ;ENTRY POINT intro text for delete an occurrence option
 ;    called by entry action of AQAO OCC DELETE
 W @IOF,!!?20,"DELETE AN OCCURRENCE RECORD",!!
 W !?5,"Use this option to delete any occurrences ENTERED BY MISTAKE."
 W !?5,"The occurrence is only FLAGGED as deleted, allowing you to "
 W !?5,"reactivate it by using the 'REOPEN a Closed/Deleted Occurrence'"
 W !?5,"option.  A deleted record, will not show up in reports except"
 W !?5,"for the 'Listing of Deleted Occurrences' on the Reports Menu."
 W !! Q
 ;
 ;
RISKMGT ;ENTRY POINT for help text on field REVIEWED FOR RISK MGT
 ;called by xecute help
 W !!,"Enter the date you reviewed this occurrence for Risk Management"
 W !,"purposes.  This will help you keep track of which you have"
 W !,"reviewed and which you have not."
 W ! Q
 ;
 ;
RMINTRO ;ENTRY POINT for intro text on option AQAO OCC RM REVIEW
 ;called by entry action
 W @IOF,!!?20,"RISK MANAGEMENT REVIEW",!!
 W !!?5,"Use this option to flag which occurrences you have reviewed"
 W !?5,"for risk management purposes.  You will only need to enter"
 W !?5,"the date reviewed.  You can then list all occurrences not yet"
 W !?5,"reviewed using the RISK MGT REVIEW REPORT on this menu.  It"
 W !?5,"can also list all occurrences reviewed for risk management"
 W !?5,"but not yet closed.",!!
 Q
 ;
 ;
RMRPT ;ENTRY POINT for intro text for RM Review Report
 ;called by entry action
 W @IOF,!!?20,"OCCURRENCES REVIEWED FOR RISK MANAGEMENT",!!
 W !!?5,"Use this option to list 1) Occurrences not yet reviewed"
 W !?5,"for risk management issues OR 2) Occurrences already reviewed"
 W !?5,"but not yet closed.  This will help you make sure all cases"
 W !?5,"have been checked for possible risk management problems.",!!
 Q
