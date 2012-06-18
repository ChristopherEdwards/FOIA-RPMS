BWPOST ;IHS/ANMC/MWR - POST-INIT ROUTINE [ 07/30/2002  3:29 PM ];11-Feb-2003 12:43;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  POSTINIT ROUTINE TO EDIT SITE PARAMETERS, DELETE JUNK DATA,
 ;;  RESET ACC# COUNTERS, DISPLAY INFO REGARDING MENUS AND KEYS.
 ;
 ;
ENV ;EP;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 S XPDENV=1,(XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 D SETVARS^BWUTL5 S IOP=$I D ^%ZIS
 S Y=$P($P($T(BWPOST+1),";;",2),";")
 S BWPTITL="v"_Y_" POST-INIT PROGRAM"
 D PROGRAM
 D EXIT
 Q
 ;
 ;
PROGRAM ;EP
 ;---> UPDATE TABLES.
 ;D ^BWUPDATE
 ;
 ;---> RECOMMEND PRINTSCREEN.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> INTRODUCTION.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT11,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> EDIT SITE PARAMETERS.
 ;D TITLE^BWUTL5(BWPTITL) D
 ;.I DUZ(0)'["@"&(DUZ(0)'["W") D TEXT21 Q
 ;.D TEXT2,DIRZ^BWUTL3 Q:BWPOP  D EDIT^BWSITE
 ;D DIRZ^BWUTL3
 ;Q:BWPOP
 ;
 ;---> PLACEMENT OF OPTIONS.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT3^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 D TITLE^BWUTL5(BWPTITL)
 D TEXT31^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> SECURITY KEYS.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT4^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 D TITLE^BWUTL5(BWPTITL)
 D TEXT41^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> RECOMMEND USE OF C-VT100.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT5^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 D TITLE^BWUTL5(BWPTITL)
 D TEXT51^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> ADVISE REMOVAL OF OLD PAP TRACKING OPTIONS.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT6^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> CONVERSION.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT7,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> SITE PARAMETERS.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT8^BWPOST1,DIRZ^BWUTL3
 Q:BWPOP
 ;
 ;---> CONCLUSION.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT9^BWPOST1,DIRZ^BWUTL3
 Q
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
TEXT1 ;EP
 ;;This is the Women's Health Post-Initialization Program.
 ;;
 ;;It may be helpful to capture or printscreen the postinit screens
 ;;that follow for later reference in setting up menus and users,
 ;;assigning keys, etc.
 ;;
 ;;You may exit this Post-Initialization program now by entering
 ;;a "^" at the prompt.  This Post-Initialization program can be
 ;;restarted at any time from programmer mode by entering "D ^BWPOST".
 ;;
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
TEXT11 ;EP
 ;;Welcome to the Women's Health Post-Initialization Program.
 ;;
 ;;In the screens that follow, information regarding setup of the
 ;;software will be presented.
 ;;
 ;;You may exit this Post-Initialization program at any point by
 ;;entering a "^" at the prompt.  This Post-Initialization program
 ;;can be restarted at any time from programmer mode by entering
 ;;"D ^BWPOST".
 ;;
 ;
 S BWTAB=5,BWLINL="TEXT11" D PRINTX
 Q
 ;
TEXT2 ;EP
 ;;Next you will be given the opportunity to edit the Women's Health
 ;;site parameters.  At the "Select SITE/FACILITY: " prompt, enter
 ;;the name of site where this program is to be run.  You will then
 ;;be presented with the EDIT SITE PARAMETERS screen.  These parameters
 ;;may be changed at any time later through the File Maintenance menu,
 ;;under the Manager's Functions menu.
 ;;
 S BWTAB=5,BWLINL="TEXT2" D PRINTX
 Q
 ;
TEXT21 ;EP
 ;;Because your current DUZ(0) does not contain either an "@" or a "W",
 ;;the Edit Site Parameters Screen will not be displayed.  Editing the
 ;;site parameters is not a crucial step at this point.  Site parameters
 ;;may be edited at any time from the File Maintenance menu of the
 ;;Manager's Functions menu of the package.
 ;;
 ;;Alternatively, you could quit the postinit program now with an "^",
 ;;set your DUZ(0)="@" or "W", and restart the program by entering
 ;;D ^BWPOST.
 ;;
 S BWTAB=5,BWLINL="TEXT21" D PRINTX
 Q
 ;
 ;
TEXT7 ;EP
 ;;IMPORTING DATA FROM THE OLD PAP TRACKING PROGRAM:
 ;;-------------------------------------------------
 ;;
 ;;If data from the old RPMS PAP Tracking package is to be copied
 ;;into the new Women's Health database, this can be accomplished
 ;;by running the routine BWOLD (at the programmer prompt enter
 ;;D ^BWOLD).  WARNING: THIS ROUTINE SHOULD ONLY BE RUN ONCE.
 ;;This routine only copies data from the old database into the
 ;;new one.  The old data is left unchanged in the global ^AMCH(86.
 ;;The conversion can be done at a later time, however,
 ;;care should be taken not to enter PAPs or colposcopies into the
 ;;new Women's Health database that have already been entered in
 ;;the old PAP Tracking package.
 ;;
 S BWTAB=5,BWLINL="TEXT7" D PRINTX
 Q
 ;
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
