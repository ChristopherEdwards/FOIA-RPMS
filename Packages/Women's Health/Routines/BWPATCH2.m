BWPATCH2 ;IHS/ANMC/MWR - UTIL: MOSTLY PATIENT DATA  [ 01/23/97  4:37 PM ];15-Feb-2003 22:03;PLS
 ;;2.0;WOMEN'S HEALTH;**2,8**;JAN 21, 1997
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  PATCH ROUTINE TO FIX "AOPEN" XREF IN ^BWNOT( GLOBAL
 ;;  (BW NOTIFICATION FILE).
 ;
 ;----------
START ;EP
 D INIT
 D MAIN
 D EOJ
 Q
 ;
 ;----------
INIT ;EP - Initialization.
 D SETVARS^BWUTL5
 S IOP=$I D ^%ZIS
 S BWPTITL="v2.0 PATCH PROGRAM"
 Q
 ;
 ;----------
MAIN ;EP - Main program.
 D TITLE^BWUTL5(BWPTITL)
 D TEXT1
 W !!,"   Do you wish to apply the patch and reindex the data now?"
 S DIR("?")="     Enter YES to apply the patch, enter NO to abort."
 S DIR(0)="Y",DIR("A")="   Enter Yes or No"
 D ^DIR W !
 I $D(DIRUT)!(Y<1) D NOCHANGE Q
 ;
 D TITLE^BWUTL5(BWPTITL)
 I '$D(^DD(9002086.4))!('$D(^BWNOT(0))) D TEXT2,NOCHANGE Q
 ;
 ;---> Correct xref logic in ^DD.
 N BWY
 S BWY="I ""o""[$P(^BWNOT(DA,0),U,14) S ^BWNOT(""AOPEN"",X,DA)="""""
 S ^DD(9002086.4,.02,1,1,1)=BWY
 S BWY="K ^BWNOT(""AOPEN"",X,DA)"
 S ^DD(9002086.4,.02,1,1,2)=BWY
 ;
 ;---> Reindex AOPEN xref.
 K ^BWNOT("AOPEN")
 S BWINC=$J(($P(^BWNOT(0),U,4))/50,0,0) S:BWINC<1 BWINC=1
 W !!?14,"Reindexing..."
 W !!!?14,"0%                      50%                     100%"
 W !?14,"----------------------------------------------------"
 W !?14,"["
 N I,Y S BWIEN=0,BWCOUNT=0
 F I=1:1 S BWIEN=$O(^BWNOT(BWIEN)) Q:'BWIEN  D
 .I '(I#BWINC)&(BWCOUNT<51) W "=" S BWCOUNT=BWCOUNT+1
 .S Y=^BWNOT(BWIEN,0)
 .Q:"o"'[$P(Y,U,14)
 .S ^BWNOT("AOPEN",$P(Y,U,2),BWIEN)=""
 I BWCOUNT<50 F I=1:1:50-BWCOUNT W "="
 W "]"
 W !!!!?14,"Patch applied successfully!  Job complete.",!!
 D DIRZ^BWUTL3
 Q
 ;
 ;----------
EOJ ;EP - End of job.
 D KILLALL^BWUTL8 K BWINC
 Q
 ;
 ;----------
TEXT1 ;EP
 ;;This routine will correct an error in the crossreference logic
 ;;in the data dictionary for Women's Health Notifications.  It will
 ;;then reindex the "AOPEN" crossreference on field .02 of the
 ;;BW NOTIFICATIONS File #9002086.4.
 ;;
 ;;NO user/programmer action is required.  The program will present a
 ;;progress bar 0%-100% during the job, which may take several minutes.
 ;;
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
 ;----------
TEXT2 ;EP
 ;;The BW NOTIFICATIONS File does not appear to be loaded on this
 ;;system.  Please contact your Women's Health support person or
 ;;Mike Remillard at (907)696-7472."
 ;;
 S BWTAB=5,BWLINL="TEXT2" D PRINTX
 Q
 ;
 ;----------
NOCHANGE ;EP
 W !?25,"NO CHANGES MADE!" D DIRZ^BWUTL3
 Q
 ;
 ;----------
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
