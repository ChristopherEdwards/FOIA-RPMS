ACRFIRS9 ;IHS/OIRM/DSD/AEF - WRITE IRS 1099 INSTRUCTIONS TO SCREEN; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
 ;Writes instructions for using the IRS/1099 menu options.
EN ;EP -- MAIN ENTRY POINT
 ;
 N DIR,X,Y
 S DIR(0)="Y"
 S DIR("A")="Do you want to print a copy of the instructions"
 S DIR("B")="N"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 Q:'Y
 D QUE^ACRFUTL("DQ^ACRFIRS9","","PRINT 1099 INSTRUCTIONS")
 Q
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 W !,?3,"The following steps should be done in sequence to ensure accuracy of 1099's:"
 W !,"1 -Option EFIN to make any needed corrections to the Finance Location",!,"   fields and be sure to enter CONTACT NAME and CONTACT PHONE number."
 W !,"2 -Option CALC to calculate YTD Paid vendor amounts."
 W !,"3 -Option RPTS to list & review all vendors with YTD-PAID entries."
 W !,"4 -Decide whether to zero-out YTD-PAID field for all vendors and enter all OR"
 W !,"   make selected corrections to YTD-PAID field because most are already correct"
 W !,"  (Option ZERO to 'zero-out' YTD-PAID field for all vendors and enter for all)"
 W !,"5 -Option INPT to enter/correct YTD-PAID field."
 W !,"6 -Option RPTS again to check all YTD-PAID entries before printing."
 W !,"7 -Option TRNS to prepare staging file for EXPORT & PRINT process."
 W !,"8 -Option LIST to review a list of entries in the staging file.  Correct"
 W !,"   any missing data."
 W !,"9 -Option PRNT to print 1099's (Will offer chance to print test 1099s.)"
 W !,"10-Option EXP  to export 1099 data to UNIX IRS/STATE files. (MUST DO TRNS 1ST)"
 D ^%ZISC
 Q
