BWRPSNP1 ;IHS/ANMC/MWR - REPORT: SNAPSHOT OF PROGRAM [ 12/17/98  3:46 PM ];15-Feb-2003 22:10;PLS
 ;;2.0;WOMEN'S HEALTH;**4,8**;MAY 16, 1996
 ;IHS/CMI/LAB - removed hard coded year Y2K patch 4
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  DISPLAY CODE FOR SNAPSHOT REPORT.  CALLED BY BWRPSNP.
 ;
 ;---> REQUIRED VARIABLES: BWDT=DATE SNAPSHOT WAS RUN.
 ;--->                     BWFAC=FACILITY IEN IN ^DIC(4 - DUZ(2)
 ;--->                     A-L,P,Q = FIELDS #.03-#.16 IN FILE 9002086.71
 ;
DISPLAY ;EP
 U IO
 S BWTITLE="* * *  PROGRAM SNAPSHOT FOR "_$$TXDT^BWUTL5(BWDT)_"  * * *"
 D CENTERT^BWUTL5(.BWTITLE),TOPHEAD^BWUTL7,HEADER6^BWUTL7
 ;
 N X,Y
 W !
 S X="Total Active Women in Register:",Y=A D PNUM
 S X="Women Who Are Pregnant:",Y=B D PNUM
 ;S X="Woman Who Are DES Daughters:",Y=C D PNUM
 S X="Women with Cervical Tx Needs not specified or not dated:",Y=D
 D PNUM
 S X="Women with Cervical Tx Needs specified and past due:",Y=E D PNUM
 S X="Women with Breast Tx Needs not specified or not dated:",Y=F D PNUM
 S X="Women with Breast Tx Needs specified and past due:",Y=G D PNUM
 W !
 S X="Total Number of Procedures with a Status of ""OPEN"":",Y=H D DOTS
 S X="Number of OPEN Procedures Past Due (or not dated):",Y=S D DOTS
 W:'BWCRT !
 ;beginning Y2K IHS/CMI/LAB
 ;S X="Total Number of PAP Smears done since Jan 1, 19"_$E(BWDT,2,3)_":" ;Y2000 IHS/CMI/LAB
 S X="Total Number of PAP Smears done since Jan 1, "_(1700+$E(BWDT,1,3))_":" ;Y2000 IHS/CMI/LAB
 S Y=P D DOTS
 ;S X="Total Number of CBEs done since Jan 1, 19"_$E(BWDT,2,3)_":" ;Y2000 IHS/CMI/LAB
 S X="Total Number of CBEs done since Jan 1, "_(1700+$E(BWDT,1,3))_":" ;Y2000 IHS/CMI/LAB
 S Y=R D DOTS
 ;S X="Total Number of Mammograms done since Jan 1, 19"_$E(BWDT,2,3)_":" ;Y2000 IHS/CMI/LAB
 S X="Total Number of Mammograms done since Jan 1, "_(1700+$E(BWDT,1,3))_":" ;Y2000 IHS/CMI/LAB
 ;end Y2K IHS/CMI/LAB
 S Y=Q D DOTS
 W !
 S X="Total Number of Notifications with a Status of ""OPEN"":",Y=J
 D DOTS
 S X="Number of OPEN Notifications Past Due (or not dated):",Y=K D DOTS
 S X="Number of Letters Queued (for later printing):",Y=L D DOTS
 ;
 D:'BWCRT
 .N BWTITLE S BWTITLE="-----  End of Report  -----"
 .D CENTERT^BWUTL5(.BWTITLE) W !!!,BWTITLE,@IOF
 I BWCRT&('$D(IO("S"))) D DIRZ^BWUTL3 W @IOF
 D ^%ZISC
 Q
 ;
PNUM ;EP
 ;---> PATIENT NUMBERS
 W:'BWCRT ! W !?3,X F I=1:1:(58-$L(X))/2 W " ."
 W ?61,".",?62,$J(Y,5) W:A>0 ?69,$J(Y/A*100,3,0),"%"
 Q
 ;
DOTS ;EP
 W:'BWCRT ! W !?3,X F I=1:1:(58-$L(X))/2 W " ."
 W ?61,".",?62,$J(Y,5)
 Q
