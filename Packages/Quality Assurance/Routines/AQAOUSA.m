AQAOUSA ; IHS/ORDC/LJF - OCCURRENCE ACCESS REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface to print users with access to
 ;a particular occurrence.  The audit report will list who has actually
 ;accessed the occurrence.
 ;
OCC ; >> ask user for occ
 S AQAOINAC=""
 D ASK^AQAOLKP G END:'$D(AQAOIFN),END:$D(DTOUT),OCC:$D(DUOUT)
 K AQAOINAC
 ;
DEV ; >>> get print device
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G CALC
 K IO("Q") S ZTRTN="CALC^AQAOUSA",ZTDESC="OCCURRENCE ACCESS REPORT"
 S ZTSAVE("AQAOIFN")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC D HOME^%ZIS D KILL^AQAOUTIL Q
 ;
 ;
CALC ; >> find all users with access
 K ^TMP("AQAOUSA",$J)
 D QISTAFF ;find all qi staff members
 D MEMBERS ;find team members associated with indicator
 D REFERRAL ;find all users occ was referred to
 ;
 ;
PRINT ; >> print user list by category then by name
 D ^AQAOUSA1 ;print rtn
 ;
 ;
END ; >> eoj
 K ^TMP("AQAOUSA",$J)
 D ^%ZISC D KILL^AQAOUTIL Q
 Q
 ; >>>>> END OF MAIN ROUTINE <<<<<
 ;
 ;
QISTAFF ; >> SUBRTN to find all qi staff members
 S AQAOX=0
 F  S AQAOX=$O(^AQAO(9,"AC",AQAOX)) Q:AQAOX=""  D
 .S AQAOUSR=0
 .F  S AQAOUSR=$O(^AQAO(9,"AC",AQAOX,AQAOUSR)) Q:AQAOUSR=""  D
 ..Q:$P(^AQAO(9,AQAOUSR,0),U,4)]""  ;inactive;PATCH 4
 ..S N=$P(^VA(200,AQAOUSR,0),U) ;user name
 ..S S=$S(AQAOX="QA":"QAI PKG ADMIN",1:"QI STAFF MEMBER")
 ..S ^TMP("AQAOUSA",$J,"A",N,AQAOUSR)=S
 Q
 ;
 ;
MEMBERS ; >> SUBRTN to find team members for ind tied to occ
 S AQAOIND=$P(^AQAOC(AQAOIFN,0),U,8) ;indicator
 S AQAOSRV=$P(^AQAOC(AQAOIFN,0),U,7) ;service
 ;
 S AQAOT=0 ;find all teams for ind
 F  S AQAOT=$O(^AQAO(2,AQAOIND,"QTM",AQAOT)) Q:AQAOT'=+AQAOT  D
 .Q:'$D(^AQAO(2,AQAOIND,"QTM",AQAOT,0))  S AQAOS=^(0)
 .S AQAOTN=$P(^AQAO1(1,$P(AQAOS,U),0),U,2) ;team name
 .S AQAOTX=$P(AQAOS,U)
 .I AQAOSRV]"",+$O(^AQAO1(1,AQAOTX,1,0)) Q:'$D(^AQAO1(1,"AB",AQAOSRV,AQAOTX))  ;team has access by srv; not right srv in this occ
 .;
 .S AQAOUSR=0 ;find all users on team & their access level
 .F  S AQAOUSR=$O(^AQAO(9,"AB",AQAOTX,AQAOUSR)) Q:AQAOUSR=""  D
 ..S AQAOX=0
 ..F  S AQAOX=$O(^AQAO(9,"AB",AQAOTX,AQAOUSR,AQAOX)) Q:AQAOX=""  D
 ...Q:$P(^AQAO(9,AQAOUSR,0),U,4)]""  ;inactive;PATCH 4
 ...S Y=$P($G(^AQAO(9,AQAOUSR,"TM",AQAOX,0)),U,2)
 ...I Y]"" S C=$P(^DD(9002168.91,.02,0),U,2) D Y^DIQ ;access level
 ...S N=$P(^VA(200,AQAOUSR,0),U) ;user name
 ...Q:$D(^TMP("AQAOUSA",$J,"A",N,AQAOUSR))  ;already listed as qi staff
 ...S ^TMP("AQAOUSA",$J,"M",N,AQAOUSR)=$G(^TMP("AQAOUSA",$J,"M",N,AQAOUSR))_AQAOTN_U_Y_U ;add team & access level
 Q
 ;
 ;
REFERRAL ; -- SUBRTN to find all users to whom occ was referred;PATCH 4
 ;PATCH 4: SUBRTN REWRITTEN
 NEW X,AQAOX,Y
 ; -- initial review
 S X=$P(^AQAOC(AQAOIFN,1),U,9) Q:X=""  S Y=$P(^(1),U,4)
 D REFSET(X,Y)
 ;
 ; -- addtnl referrals on initial review
 S AQAOX=0
 F  S AQAOX=$O(^AQAOC(AQAOIFN,"IADDRV",AQAOX)) Q:'AQAOX  D
 . S X=^AQAOC(AQAOIFN,"IADDRV",AQAOX,0) D REFSET(X,Y)
 ;
 ; -- referrals from reviews
 S AQAOX=0
 F  S AQAOX=$O(^AQAOC(AQAOIFN,"REV",AQAOX)) Q:'AQAOX  D
 . S X=$P($G(^AQAOC(AQAOIFN,"REV",AQAOX,0)),U,9) Q:X=""
 . S Y=$P($G(^AQAOC(AQAOIFN,"REV",AQAOX,0)),U,2)
 . D REFSET(X,Y)
 . ; -- addtnl referrals from this review
 . S AQAOY=0
 . F  S AQAOY=$O(^AQAOC(AQAOIFN,"REV",AQAOX,"ADDRV",AQAOY)) Q:'AQAOY  D
 .. S X=^AQAOC(AQAOIFN,"REV",AQAOX,"ADDRV",AQAOY,0) D REFSET(X,Y)
 Q
 ;
 ;
REFSET(X,AQAOY) ; -- SUBRTN to set ^tmp for users found;PATCH 4
 ;PATCH 4: SUBRTN ADDED
 ; X=referred to, AQAOY=referred by
 NEW AQAOUSR,AQAOT,AQAOTN,AQAOX,Y
 ; -- referred to user by name
 I X["AQAO(9" D  Q
 . S AQAOUSR=$P(X,";"),N=$P(^VA(200,AQAOUSR,0),U)
 . Q:$D(^TMP("AQAOUSA",$J,"A",N,AQAOUSR))  ;already on qi staff list
 . Q:$D(^TMP("AQAOUSA",$J,"M",N,AQAOUSR))  ;on team listing
 . S Y=AQAOY,C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ
 . S ^TMP("AQAOUSA",$J,"R",N,AQAOUSR)=$G(^TMP("AQAOUSA",$J,"R",N,AQAOUSR))_Y_U ;Y=referred by
 ;
 ; -- else if referred to team
 Q:$D(^AQAO(2,AQAOIND,"QTM","B",$P(X,";")))  ;team on ind list
 S AQAOT=$P(X,";"),AQAOTN=$P(^AQAO1(1,AQAOT,0),U,2) ;team name
 S Y=AQAOY,C=$P(^DD(9002167,.14,0),U,2) D Y^DIQ S AQAOY=Y
 ;
 ; -- find all users on team & their access level
 S AQAOUSR=0
 F  S AQAOUSR=$O(^AQAO(9,"AB",AQAOT,AQAOUSR)) Q:AQAOUSR=""  D
 . S AQAOX=0
 . F  S AQAOX=$O(^AQAO(9,"AB",AQAOT,AQAOUSR,AQAOX)) Q:AQAOX=""  D
 .. S Y=$P($G(^AQAO(9,AQAOUSR,"TM",AQAOX,0)),U,2)
 .. I Y]"" S C=$P(^DD(9002168.91,.02,0),U,2) D Y^DIQ ;access level
 .. S N=$P(^VA(200,AQAOUSR,0),U) ;user name
 .. Q:$D(^TMP("AQAOUSA",$J,"A",N,AQAOUSR))  ;already listed as qi staff
 .. Q:$D(^TMP("AQAOUSA",$J,"M",N,AQAOUSR))  ;already on team list
 .. Q:$D(^TMP("AQAOUSA",$J,"R",N,AQAOUSR))  ;already referred by name
 .. S ^TMP("AQAOUSA",$J,"T",N,AQAOUSR)=$G(^TMP("AQAOUSA",$J,"T",N,AQAOUSR))_AQAOY_U_AQAOTN_U_Y_U ;add team & accs lev
 Q
