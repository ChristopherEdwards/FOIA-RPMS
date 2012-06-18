AQAOHPKG ; IHS/ORDC/LJF - HELP TEXT FOR PKG ADMIN OPTIONS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points for introductory text on options
 ;on the Package Administrator's menu.
 ;
AUDIT ;ENTRY POINT >>> intro text for audit report
 ;called by entry action on option AQAO USER PRINT AUDIT
 W @IOF,!!?20,"OCCURRENCE AUDIT LISTING UTILITY",!!
 W !!?5,"Use this option to view actions taken on OCCURRENCES by"
 W !?5,"QI users.  It will list the occurrence ID #, the date and time,"
 W !?5,"the action performed (add, edit, review, or delete), and the"
 W !?5,"user's name.  This can be very helpful in tracking who accessed"
 W !?5,"a particular occurrence and when.  You can print all audited"
 W !?5,"events for a date range, all for a specific occurrence, or all"
 W !?5,"those performed by a particular user.",!!
 Q
 ;
 ;
KEYS ;ENTRY POINT >>> intro text for users with qai keys report
 ;called by entry action to option AQAO USER PRINT KEYS
 W @IOF,!!?20,"USERS WITH QAI SECURITY KEYS",!!
 W !!?5,"Use this option to check who has access to the LOCKED MENU"
 W !?5,"OPTIONS in the QAI system.  This report will tell you who"
 W !?5,"has been given access to update indicators, close occurrences,"
 W !?5,"print provider reports, and any other functions that require"
 W !?5,"additional keys to access.",!
 Q
 ;
 ;
MEMBER ;ENTRY POINT >>> intro text for listing of team members
 ;called by entry action of option AQAO USER MEMBERSHIPS
 W @IOF,!!?20,"LISTING OF QI TEAM MEMBERS",!!
 W !?5,"Use this option to print a list by QI TEAM of the QAI USERS"
 W !?5,"who have access to the team's indicators, occurrences, and"
 W !?5,"action plans.  Remember, all users designated as QI Staff"
 W !?5,"members can access ALL data in the QAI system.",!!
 Q
