AQAOHQIT ; IHS/ORDC/LJF - QI TOOLS HELP TEXT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text and help text
 ;on data fields for the Brainstorming and Multivoting option.
 ;
INTRO ;ENTRY POINT for intro text on Brainstorming menu
 ;called by ^AQAOTL1
 W @IOF,!!?25,"BRAINSTORMING TOOLS MENU",!!
 W !?5,"Use this option to record brainstorming sessions by your"
 W !?5,"QI team.  You can also perform multivoting with this option."
 W !?5,"Use the GENERAL INFO function to record the session date & time"
 W !?5,"the team name, all members in attendance, and optionally, the"
 W !?5,"minutes.  Use the BRAINSTORMING function to record all ideas,"
 W !?5,"to list them, and to group them by category.  Use MULTIVOTING"
 W !?5,"to cast your votes, by team member.  Then print REPORTS for"
 W !?5,"the results of the session.",!!
 Q
 ;
 ;
MIN ;ENTRY POINT for help on MINUTES field in Qi Brainstorm Session
 ;called by input tempalte [AQAO QIT MTG]
 W !!?20,"SESSION MINUTES (OPTIONAL)",!
 W !?5,"Enter the minutes for your brainstorming session.  These"
 W !?5,"will print on the FULL REPORT followed by the listing of IDEAS"
 W !?5,"and VOTING RESULTS.",!
 Q
