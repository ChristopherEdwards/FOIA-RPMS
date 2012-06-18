AQAOCHK4 ; IHS/ORDC/LJF - PRINT TICKLER REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by ^AQAOCHK2 to print each occurrence with its
 ;case ID, patient, indicator, ward/service and more.
 ;PATCH 4: rewrote routine
 ;
PRINT ;ENTRY POINT >>> print selected range of items
 ;called by AQAOCHK2
 D INIT^AQAOUTIL
 S AQAOHCON="Patient",AQAOTY="OCCURRENCE TICKLER REPORT"
 D HEADING^AQAOUTIL D HDG1
 ;
 F AQAOI=1:1 S AQAOX=$P(AQAOXYZ(4),",",AQAOI) Q:'AQAOX  Q:AQAOSTOP=U  D
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 .W !!,$P($T(MSG+AQAOX),";;",3),":" ;print section heading
 .D LOOP
 ;
 I '($D(AQAOXYZ)#2) D MAP
 I '$D(ZTQUEUED),IOST["C-" D PRTOPT^AQAOVAR
 D END
 Q
 ;
 ;
LOOP ; -- SUBRTN to loop thru ^TMP to find cases to display
 NEW AQAOIND,AQAODT,AQAOIFN
 S AQAOIND=0
 F  S AQAOIND=$O(^TMP("AQAOCHK",$J,AQAOX,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 .S AQAODT=0
 .F  S AQAODT=$O(^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 ..S AQAOIFN=0
 ..F  S AQAOIFN=$O(^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT,AQAOIFN)) Q:AQAOIFN=""  Q:AQAOSTOP=U  D
 ...I $D(AQAOXYZ)#2,((AQAOX=2)!(AQAOX=3)) D ALLREF Q  ;prt all referrals
 ...S AQAOSTR=$G(^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT,AQAOIFN)) ;PATCH 3
 ...I AQAOX=5 D PRINTA Q  ;action plan item
 ...Q:AQAOSTR=""  ;PATCH 3
 ...D OCCPRNT
 Q
 ;
OCCPRNT ; -- SUBRTN to print out cases
 I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 W !,"#",$P(^AQAOC(+AQAOIFN,0),U) ;case id #
 I AQAOX<4 W $$OVERDUE^AQAOCHK0 ;print * if overdue for review
 S Y=AQAODT X ^DD("DD") W ?10,Y ;occ or review date
 S X=$P(^AQAOC(+AQAOIFN,0),U,2)
 W:X]"" ?23,$J($P(^AUPNPAT(X,41,DUZ(2),0),U,2),6) ;chart #
 W ?32,$P(^AQAO(2,AQAOIND,0),U) ;indicator #
 ;
 I AQAOX=1 D  Q  ;no other print items for initial reviews
 .W:$P(^AQAOC(+AQAOIFN,0),U,11)=1 ?43,"AUTOMATED ENTRY" W ?60
 .S X=$P(^AQAOC(+AQAOIFN,0),U,6) I X]"" W $P($G(^SC(X,0)),U,2),"/"
 .S X=$P(^AQAOC(+AQAOIFN,0),U,7) I X]"" W $P($G(^DIC(49,X,0)),U,2)
 ;
 I AQAOX=4 D  Q  ;reviewed, not closed occ
 .W ?43,"Last review: ",$E($P(^AQAO(7,$P(AQAOSTR,U,2),0),U),1,4)
 .S X=$P(AQAOSTR,U,3) W:X]"" ?62,"Action: ",$P(^AQAO(6,X,0),U,2)
 ;
 ;print referred by for aqax=2 or 3
 S Y=$P(AQAOSTR,U,2),C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ
 W ?43,"Referred by: ",$E(Y,1,23)
 S Y=$P(AQAOSTR,U,3),C=$P(^DD(9002167,.19,0),U,2) D Y^DIQ
 W !?43,"Referred to: ",$E(Y,1,23)
 Q
 ;
MAP ; -- SUBRTN to print out map to find options
 I $Y>(IOSL-9) D NEWPG^AQAOUTIL D HDG1
 W !!,">>To find Occurrence Data Entry options, follow this path:"
 W !?5,"D for Data Collection Menu;"
 W !?10,"ODE for Occurrence Data Entry Menu;"
 W !?15,"And then POW for Print Occurrence Worksheets;"
 W !?21,"Or OCC for Enter/Edit Occurrence Record;"
 W !?21,"Or PRW for Print Review Worksheets;"
 W !?21,"Or REV for Enter/Edit Occurrence Review."
 Q
 ;
 ;
END ;ENTRY POINT called by AQAOCHK1
 K ^TMP("AQAOCHK",$J) K AQAOXYZ,AQAOALL,AQAOR1,AQAOR2
 D ^%ZISC D KILL^AQAOUTIL
 Q
 ;
 ;
ALLREF ; >> SUBRTN to print all referrals for qi staff user
 NEW AQAON1,AQAON2
 S AQAON1=-1
 F  S AQAON1=$O(^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT,AQAOIFN,AQAON1)) Q:AQAON1=""  Q:AQAOSTOP=U  D
 . S AQAON2=-1
 . F  S AQAON2=$O(^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT,AQAOIFN,AQAON1,AQAON2)) Q:AQAON2=""  Q:AQAOSTOP=U  D
 .. S AQAOSTR=^TMP("AQAOCHK",$J,AQAOX,AQAOIND,AQAODT,AQAOIFN,AQAON1,AQAON2)
 .. I AQAOX=2,'$D(AQAOALL),+$P(AQAOSTR,U,3)'=DUZ Q  ;only your refrls
 .. I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 .. W !,"#",$P(^AQAOC(+AQAOIFN,0),U) ;case id #
 .. I AQAOX<4 W $$OVERDUE^AQAOCHK0 ;print * if overdue for review
 .. S Y=AQAODT X ^DD("DD") W ?10,Y ;occ date
 .. S X=$P(^AQAOC(+AQAOIFN,0),U,2)
 .. W:X]"" ?23,$J($P(^AUPNPAT(X,41,DUZ(2),0),U,2),6) ;chart #
 .. W ?32,$P(^AQAO(2,AQAOIND,0),U) ;indicator #
 .. S Y=$P(AQAOSTR,U,2),C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ
 .. W ?43,"Referred by: ",$E(Y,1,23)
 .. S Y=$P(AQAOSTR,U,3),C=$P(^DD(9002167,.19,0),U,2) D Y^DIQ
 .. W !?43,"Referred to: ",$E(Y,1,23)
 Q
 ;
 ;
PRINTA ; >> SUBRTN to print action plan items
 I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 W !,"#",$P(^AQAO(5,+AQAOIFN,0),U) ;action plan #
 W ?12,"Indicator: ",$P(^AQAO(2,AQAOIND,0),U) ;indicator #
 S Y=AQAODT,C=$P(^DD(9002168.5,.05,0),U,2) D Y^DIQ
 W ?32,$E(Y,1,25) ;status
 S X=$P(^AQAO(5,+AQAOIFN,0),U,2)
 W:X]"" ?60,"ACTION TYPE:  ",$P(^AQAO(6,X,0),U,2) ;action type
 Q
 ;
 ;
HDG1 ; >> SUBRTN to print 2nd half of heading
 W ?22,"(Occurrences & Action Plans Pending)"
 W !?20,"[""*"" after Case ID means overdue for review]",!,AQAOLINE
 W !,"Case ID",?10,"Occ/Rev Dt",?23,"Chart #",?32,"Indicator"
 W ?43,"Comments",!,AQAOLIN2,!
 Q
 ;
 ;
MSG ;;
 ;; Occurrence(s) needing INITIAL REVIEWS;;INITIAL REVIEWS
 ;; Occurrence(s) with PERSONAL REFERRALS;;PERSONAL REFERRALS
 ;; Occurrence(s) with REFERRALS TO QI TEAM;;TEAM REFERRALS
 ;; Occurrence(s) REVIEWED but NOT CLOSED;;OPEN OCCURRENCES
 ;; Pending ACTION PLAN(S);;ACTION PLANS
