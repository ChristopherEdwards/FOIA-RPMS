AQAOCHK1 ; IHS/ORDC/LJF - DISPLAY TICKLER SUMMARY ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the Introductory Message and asks if the user wants
 ;to print the Tickler Report listing occurrences needing attention.
 ;
 I '$D(AQAOXYZ)!('$D(^TMP("AQAOCHK",$J))) D ENTRY^AQAOCHK Q
 ;
DISPLAY ; >>> display review status for user
 W ! S Y=0 F  S Y=$O(AQAOXYZ(3,Y)) Q:Y=""  D
 .I $D(AQAOXYZ)#2,((Y=2)!(Y=3)) D QIDSPLY Q  ;refer for qi staff
 .I Y=5 D ACTDSPLY Q  ;display action plan numbers
 .W !,AQAOXYZ(3,Y),$P($T(MSG+Y),";;",2)
 ;
ASK ; >>> ask user if a printed report is  requested?
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to PRINT A LISTING of these Occurrences"
 D ^DIR G END:$D(DIRUT),^AQAOCHK2:Y=1
 ;
END ; >>> end of check & display
 W !,"You can print the report at any time by selecting the menu"
 W " option titled"
 W !,"'PRINT OCCURRENCE TICKLER REPORT' on the Occurrence EVALUATION"
 W " Reports Menu."
 G END^AQAOCHK2
 ;
 ;
QIDSPLY ; >> SUBRTN to display referrals if user is qi staff
 W !,AQAOXYZ(3,Y,1),$P($T(MSG+Y),";;",2)
 W "  (",+$G(AQAOXYZ(3,Y))," for you)"
 Q
 ;
 ;
ACTDSPLY ; >> SUBRTN to display action plan numbers
 S (Z,AQAOCNT)=0 F  S Z=$O(AQAOXYZ(3,5,Z)) Q:Z=""  D
 .S AQAOCNT=AQAOCNT+AQAOXYZ(3,5,Z)
 W !,AQAOCNT,$P($T(MSG+Y),";;",2)
 Q
 ;
 ;
MSG ;;
 ;; Occurrence(s) needing INITIAL REVIEWS;;INITIAL REVIEWS
 ;; Occurrence(s) with PERSONAL REFERRALS;;PERSONAL REFERRALS
 ;; Occurrence(s) with REFERRALS TO QI TEAM;;TEAM REFERRALS
 ;; Occurrence(s) REVIEWED but NOT CLOSED;;OPEN OCCURRENCES
 ;; Pending ACTION PLAN(S);;ACTION PLANS
