XBRESTL1 ; acc/ohprd - routine to restore 1st line of routines from save file ;  
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;
 W !!,"-- ROUTINE TO RESTORE 1ST LINE OF ROUTINES FROM %RS FILE --",!
 W "CAUTION: THIS ROUTINE KILLS ALL VARIABLES, IS NOT NAMESPACED.",!
 R "ABORT HERE (^ OR CTL-C) OR PRESS RETURN TO CONTINUE: ",%:$S($D(DTIME):DTIME,1:999),! I %="^" W "-- aborted.",! G OUT
 W !
 K
GETFN R "Name of %RS-format save file: ",FN:$S($D(DTIME):DTIME,1:999),! G:"^"[FN EXIT
 I FN["?" W "(Enter the name of a unix file containing routines which was produced by %RS)",! G GETFN
 D GETHFS E  W "-- couldn't get HFS device!",! G EXIT
 U DEV
 R L1,L2
 U 0
 W "Header lines from %RS file:",!,?2,L1,!,?2,L2,!
 R "OK to proceed: N// ",%:$S($D(DTIME):DTIME,1:999),! S %=$E(%_"N") I "Yy"'[% W "-- aborted.",! G OUT
 F NR=1:1 D GETR Q:RN=""  W:NR=1 "Routines repaired:",! W ?2,$J(NR,3),": ",RL1,! D FIXL1
 C DEV
EXIT W "Bye.",!
OUT K
 Q
GETHFS ;
 F DEV=51:1:54 O DEV:(FN:"R"):1 Q:$T
 E  S DEV=0
 Q
GETR ;
 U DEV
 R RN Q:RN=""
 R RL1
 F  R RL Q:RL=""
 U 0
 Q
FIXL1 ;
 X "ZL @RN ZR +1 ZI RL1 ZS @RN"
 Q
