AQAOREV1 ; IHS/ORDC/LJF - ENTER OCCURRENCE REVIEWS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains entry points called by ^AQAOREV.  These entry
 ;points print occ summary, finds and displays all previous reviews.
 ;
SUM ;ENTRY POINT >> SUBRTN to print occ summary
 N AQAOIFN,AQAORVW,AQAOARR,AQAOCID,AQAOPAT,AQAOIND,AQAODATE
 S AQAOIFN=X
 S X=$P(^AQAOC(AQAOIFN,0),U,2),AQAOARR(AQAOIFN)=$P(^DPT(X,0),U)
 S AQAODEV="HOME" D PRINT^AQAOPR3
 Q
 ;
FIND ;ENTRY POINT >> SUBRTN to find all reviews
 S (AQAODT,AQAOX,AQAONUM)=0,AQAOSTOP="" K AQAO
 F  S AQAODT=$O(^AQAOC(AQAOIFN,"REV","AC",AQAODT)) Q:AQAODT=""  D
 .S AQAOX=0
 .F  S AQAOX=$O(^AQAOC(AQAOIFN,"REV","AC",AQAODT,AQAOX)) Q:AQAOX=""  D
 ..Q:'$D(^AQAOC(AQAOIFN,"REV",AQAOX,0))  S AQAOSTR=^(0)
 ..S AQAOSTG=$P(AQAOSTR,U),AQAOFIN=$P(AQAOSTR,U,5),AQAOCT=$P(AQAOSTR,U,7)
 ..S AQAORISK=$P(AQAOSTR,U,11),AQAOUT=$P(AQAOSTR,U,6),AQAORVR=$P(AQAOSTR,U,2)
 ..S AQAOSTG=$P($G(^AQAO(7,+AQAOSTG,0)),U,2) ;review stage
 ..S:AQAORVR'="" AQAORVR=U_$P(AQAORVR,";",2)_+AQAORVR_",0)",AQAORVR=$P(@AQAORVR,U,2) ;reviewer
 ..S AQAOFIN=$P($G(^AQAO(8,+AQAOFIN,0)),U,2) ;finding
 ..S AQAOCT=$P($G(^AQAO(6,+AQAOCT,0)),U,2) ;action
 ..S AQAORISK=$P($G(^AQAO1(3,+AQAORISK,0)),U) ;risk
 ..S AQAOUT=$P($G(^AQAO1(3,+AQAOUT,0)),U) ;outcome
 ..S X=" ",Y=AQAODT X ^DD("DD") S AQAONUM=AQAONUM+1
 ..S AQAO(AQAONUM)=AQAOX_U_Y_U_AQAOSTG_U_AQAOFIN_U_AQAOCT_U_AQAORISK_U_AQAOUT_U_AQAORVR
 .Q
 S AQAOSTR=$G(^AQAOC(AQAOIFN,1))
 I $P(AQAOSTR,U,3)="" D  S AQAOSTOP=U Q
 .W !!!!,"INITIAL REVIEW not yet entered." D PRTOPT^AQAOVAR
 ;
DISPLAY ; display reviews found
 W !!?20,"**** REVIEWS FOUND FOR CASE #",AQAOCID," ****",!
 W ?20,"(Initial Review [I] cannot be edited here)",!
 W !?4,"Review Date",?19,"Stage",?26,"Reviewed by",?39,"Occ Risk"
 W ?49,"Occ Outcome",?62,"Finding",?72,"Action",!
 ; print initial review data
 S Y=$P(AQAOSTR,U,8) X ^DD("DD") W !,"I.",?4,Y ;review date
 S X=$P(AQAOSTR,U,3) W:X'="" ?21,$P($G(^AQAO(7,X,0)),U,2) ;stage
 S X=$P(AQAOSTR,U,4) I X]"" S X=U_$P(X,";",2)_+X_",0)" W ?29,$P(@X,U,2) ;reviewr
 S X=$P(AQAOSTR,U,11) W:X'="" ?43,$P($G(^AQAO1(3,X,0)),U) ;risk
 S X=$P(AQAOSTR,U,7) W:X'="" ?53,$P($G(^AQAO1(3,X,0)),U) ;outcome
 S X=$P(AQAOSTR,U,5) W:X'="" ?64,$P($G(^AQAO(8,X,0)),U,2) ;finding
 S X=$P(AQAOSTR,U,6) W:X'="" ?73,$P($G(^AQAO(6,X,0)),U,2) ;action
 ;
 ;print all other reviews by date
 S AQAON=0 F  S AQAON=$O(AQAO(AQAON)) Q:AQAON=""  D
 .W !,AQAON_".",?4,$P(AQAO(AQAON),U,2),?21,$P(AQAO(AQAON),U,3)
 .W ?29,$P(AQAO(AQAON),U,8),?43,$P(AQAO(AQAON),U,6),?53,$P(AQAO(AQAON),U,7)
 .W ?64,$P(AQAO(AQAON),U,4),?73,$P(AQAO(AQAON),U,5)
 Q
