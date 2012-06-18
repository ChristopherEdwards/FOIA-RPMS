AQAOHUSR ; IHS/ORDC/LJF - HELP TEXT FOR USER OPTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options and
 ;help text on data fields for User and QI Team options found on the
 ;Pkg Admin menu.
 ;
INTRO ;ENTRY POINT for intro text for option to add qi users
 ;called by ^AQAOUSR rtn
 W @IOF,!!?20,"ADD OR EDIT QI USER ENTRIES",!!
 W !?5,"No computer users may use the QAI Management System without"
 W !?5,"first being defined to the system.  Use this option to ADD a"
 W !?5,"user to this package and define his/her ACCESS LEVEL.  You will"
 W !?5,"also use this option to EDIT a user's access to this package."
 W !?5,"By answering the following questions, the computer will set up"
 W !?5,"the user's access and then give you a listing of SECURITY KEYS"
 W !?5,"for your site manager to assign.",!!
 Q
 ;
 ;
DISPLAY ;ENTRY POINT for intro text to display profile option
 ;called by ^AQAOUSP after entry point DISPLAY
 W @IOF,!!?20,"DISPLAY QI USER PROFILE",!!
 W !?5,"Use this option to print a QI User's Profile for the user you"
 W !?5,"specify.  The profile shows whether or not the user is a QI"
 W !?5,"Staff member, all QI Teams to which the user belongs, plus"
 W !?5,"the assigned security keys which customize the user's menu.",!!
 Q
 ;
 ;
TEAM ;ENTRY POINT >> intro text for optio to charter qi team
 ;called by entry action of AQAO CHARTER TEAM
 W @IOF,!!?30,"CHARTER A QI TEAM",!!
 W !!?5,"Use this option to define the charter of a new QI TEAM or"
 W !?5,"to edit one already in existence.  A QI team can be a permanent"
 W !?5,"one or time-limited for a specific purpose chartered by your"
 W !?5,"Quality Council.  Any QA committees that still exist are now"
 W !?5,"considered permanent teams.",!!
 Q
 ;
 ;
PURPOSE ;ENTRY POINT >> help text for purpose wp field under Charter a QI Team
 ;called by execute help on field
 W !!?20,"PURPOSE FOR THIS QI TEAM"
 W !!?5,"Please include in your description the following:"
 W !?10,"1.  What is the ISSUE facing this team?"
 W !?10,"2.  What is this team's GOAL?"
 W !?10,"3.  How is this goal to be MEASURED, the CRITERIA?"
 W !?10,"4.  What is the team's LEVEL OF AUTHORITY?"
 W !?10,"5.  Your TIMETABLES and DEADLINES"
 W !?10,"6.  Team's EXPENSE LIMITATIONS"
 W !?10,"7.  REPORT calendar and distribution list"
 W ! Q
 ;
 ;
AFFIL ;ENTRY POINT >> help text for affiliated services under QI Team
 ;called xecute help
 W !!?5,"AFFILIATED SERVICES connects a QI team with occurrences ONLY"
 W !?5,"for its designated services for FACILITY-WIDE Indicators.  A"
 W !?5,"readmission to surgery will be forwarded to the QI team with "
 W !?5,"surgery listed as one of its affiliated services.",!
 Q
 ;
 ;
ACCESS ;ENTRY POINT for intro text for access by occurrence report
 ;called by entry action of option AQAO USR ACCESS
 W @IOF,!!?20,"USERS WITH ACCESS TO AN OCCURRENCE",!!
 W !!?5,"Use this option to print a listing of all users with access"
 W !?5,"to a particular occurrence.  It will list all QI STAFF members"
 W !?5,"as they have access to all occurrences.  It will also list all"
 W !?5,"MEMBERS of the QI Teams associated with the indicator linked to"
 W !?5,"to the occurrence.  The users' access level on the team will be"
 W !?5,"displayed.  Finally, it will list all users who have access due"
 W !?5,"to REFERRALS entered for the ocurrence.",!!
 Q
 ;
 ;
INACTIVE ;ENTRY POINT for intro text on option to inactivate user
 ;called by entry action of AQAO USER INACTIVE
 W @IOF,!!?30,"INACTIVATE QI USER ENTRY",!!
 W !!?5,"Use this option to inactivate a user who no longer needs"
 W !?5,"access to this software.  For security purposes please try to"
 W !?5,"keep your list of active users current!",!!
 Q
