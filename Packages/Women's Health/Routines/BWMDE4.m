BWMDE4 ;IHS/ANMC/MWR - EXPORT MDE'S FOR CDC.;06-Oct-2003 15:36;DKM
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY BWMDE IN EXPORT DATA OF TO CDC.
 ;
 ;
SETS ;EP
 Q
 ;
CHECKS ;EP
 N Y S Y=^BWSITE(DUZ(2),0)
 I '$P(Y,U,12) D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""CDC Export:"" set to NO."
 I '$P(Y,U,16) D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""FIPS County Code:"" not set."
 I '$P(Y,U,11) D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""FIPS Program Code:"" not set."
 I $P(Y,U,13)="" D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""CDC Tribal Pgm Abbreviation:"" not set."
 I '$P(Y,U,17) D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""Date CDC Funding Began:"" not set."
 I $P(Y,U,14)="" D  S BWPOP=1
 .W:'$D(BWSILENT) !?5,"Site Parameter ""Host File Path:"" not set."
 I BWPOP D DIRZ^BWUTL3 S BWPOP=1
 Q
 ;
SAVELOG ;EP
 I '$D(BWSILENT) D
 .W !!,"   The CDC Export Log contains a listing of CDC exports,"
 .W !,"   their dates, numbers of records exported, and host filenames."
 .W !!,"   Do you wish to save this export in the CDC Export Log?"
 .S DIR("?",1)="     Enter YES to save the date, number of records, and"
 .S DIR("?")="     filename in the CDC Export Log."
 .S DIR(0)="YO",DIR("A")="   Enter Yes or No"
 .D ^DIR W !
 .Q:Y<1
 S DIC("DR")=".02////"_BWCOUNT_";.03////"_BWPATH_BWFLNM
 D FILE^BWFMAN(9002086.92,DIC("DR"),"ML",DT,9002086,.Y)
 ;---> IF Y<0, CHECK PERMISSIONS.
 I Y<0 W:'$D(BWSILENT) !!,*7,"UNABLE TO LOG THIS EXPORT." D DIRZ^BWUTL3
 Q
 ;
LOG ;EP
 ;---> PRINT EXPORT LOG.
 S DIOEND="W:$E(IOST)'=""C"" @IOF D:$E(IOST)=""C"" DIRZ^BWUTL3"
 S DIC=9002086.92,FLDS="[BW CDC EXPORT LOG]",BY=".01",FR="",TO=""
 D EN1^DIP
 D KILLALL^BWUTL8
 Q
 ;
HELP1 ;EP
 ;;If you send the extract to the Host File, it can then be copied
 ;;to a floppy disc or transmitted to another computer using utilities
 ;;such as uucp or ftp.
 ;;
 ;;If you send the extract to your Screen, all of the records will
 ;;display in a scroll fashion very quickly.  This may be useful if
 ;;you are attempting to "capture" the file on a PC monitor and
 ;;download it to a drive on the PC. (Refer to your communications
 ;;software documentation for information on how to perform such
 ;;procedures.)
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
HELPTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
