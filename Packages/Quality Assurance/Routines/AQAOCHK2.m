AQAOCHK2 ; IHS/ORDC/LJF - PRINT TICKLER REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn asks the user to choose from 5 groups of occurrences and
 ;choose print device.  It then calls ^AQAOCHK4 to do the actual print.
 ;
RANGE ; >>> ask user for range of items to print
 W !!!?20,"OCCURRENCE TICKLER REPORT",!!
 W !,"OCCURRENCE GROUPINGS:",! K DIR S DIR(0)="LO^1:5^K:X#1 X"
 S DIR("A")="Choose which ITEM(S) you wish to print",DIR("A",6)=" "
 F I=1:1:5 S DIR("A",I)=I_".  "_$P($T(MSG+I),";;",3)
 D ^DIR G END:X="",END:$D(DIRUT) S AQAOXYZ(4)=Y
 ;
QIASK ; >> ask qi staff user if want to print all referrals or just his/hers
 I '($D(AQAOXYZ)#2) G DEV ;no a qi staff member
 I (AQAOXYZ(4)'[2),(AQAOXYZ(4)'[3) G DEV ;didn't choose referrals
 W ! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to print MORE THAN just YOUR REFERRALS"
 D ^DIR G RANGE:X="",END:$D(DIRUT),DEV:Y=0 S AQAOALL=""
 W !,"OKAY, I will print ALL REFERRALS"
 ;
DEV ; >>> get print device
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G PRINT^AQAOCHK4
 K IO("Q") S ZTRTN="PRINT^AQAOCHK4",ZTDESC="TICKLER REPORT"
 F I="AQAOXYZ(","^TMP(""AQAOCHK"",$J," S ZTSAVE(I)=""
 D ^%ZTLOAD K ZTSK D ^%ZISC D HOME^%ZIS D KILL^AQAOUTIL Q
 ;
 ;
END ;ENTRY POINT called by AQAOCHK1
 K ^TMP("AQAOCHK",$J) K AQAOXYZ
 D ^%ZISC D KILL^AQAOUTIL
 Q
 ;
 ;
MSG ;;
 ;; Occurrence(s) needing INITIAL REVIEWS;;INITIAL REVIEWS
 ;; Occurrence(s) with PERSONAL REFERRALS;;PERSONAL REFERRALS
 ;; Occurrence(s) with REFERRALS TO QI TEAM;;TEAM REFERRALS
 ;; Occurrence(s) REVIEWED but NOT CLOSED;;OPEN OCCURRENCES
 ;; Pending ACTION PLAN(S);;ACTION PLANS
