AQAOCHK0 ; IHS/ORDC/LJF - CHECK OCC NEEDNG REVIEW SUBRTNS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains subrtns called by ^AQAOCHK.  These subrtns set
 ;the appropriate array entries based on occurrence status.  These
 ;arrays are used in the printing of the introductory message.
 ;
REFSET ;ENTRY POINT >> set referral data
 S X=$S($P(AQAOREF,";",2)="AQAO(9,":2,1:3)
REFSET1 ;ENTRY POINT >> SUBRTN REFSET but X already set
 I $D(AQAOXYZ)#2 D QIREF ;set all referrals in qi staff
 I X=2 Q:$P(AQAOREF,";")'=AQAODUZ  ;referred to another user
 I X=3 Q:'$D(AQAOXYZ(1,$P(AQAOREF,";")))  ;referred to other team
 D SET1 Q
 ;
 ;
SET ;ENTRY POINT >> SUBRTN to set array variables
 I '($D(AQAOXYZ)#2) Q:'$D(AQAOXYZ(2,AQAOIND))
SET1 I (X=1)!(X=4) Q:'$$SRV  ;check affil srv for auto occ
 S AQAOXYZ(3,X)=$G(AQAOXYZ(3,X))+1 ;increment count
 I X=1 S AQAOSTR=AQAOIND_U_U_U_$$DATESTMP ;initial review data
 I (X=2)!(X=3) S AQAOSTR=AQAOIND_U_$S(AQAOLST=0:$P(^AQAOC(+AQAOIFN,1),U,4),1:$P(^AQAOC(+AQAOIFN,"REV",AQAOLST,0),U,2))_U_AQAOREF_U_$$DATESTMP ;if referral, store indicator & referred by & date review entered
 I X=4 S AQAOSTR=AQAOIND_U_$S(AQAOLST=0:$P(^AQAOC(+AQAOIFN,1),U,3)_U_$P(^(1),U,6),1:$P(^AQAOC(+AQAOIFN,"REV",AQAOLST,0),U)_U_$P(^(0),U,7)) ;for occ not closed,store indicator & review stage
 S ^TMP("AQAOCHK",$J,X,AQAOIND,AQAODT,AQAOIFN)=AQAOSTR ;set occ 4 rprt
 Q
 ;
 ;
QIREF ;EP; >> SUBRTN to set all referrals in user is qi staff;PATCH 4
 NEW AQAOX
 S AQAOX=0
 F  S AQAOX=$O(AQAOR1(AQAOX)) Q:'AQAOX  D
 . I $P(AQAOR1(AQAOX),U)<+$G(AQAOR2(AQAOX)) Q
 . S Y=$P(AQAOR1(AQAOX),U,2),(X,AQAOLST)=+Y,Y=$P(Y,",",2)
 . S AQAOREF=$$SETREFRL(X,Y) Q:AQAOREF=""
 . S X=$S(AQAOREF["AQAO(9,":2,1:3)
 . S AQAOXYZ(3,X,1)=$G(AQAOXYZ(3,X,1))+1 ;increment count
 . I $D(AQAOXYZ(1,$P(AQAOREF,";"))) S AQAOXYZ(3,X)=$G(AQAOXYZ(3,X))+1
 . S AQAOSTR=AQAOIND_U_$S(AQAOLST=0:$P(^AQAOC(+AQAOIFN,1),U,4),1:$P(^AQAOC(+AQAOIFN,"REV",AQAOLST,0),U,2)) ;if referral, store indicator & referred by
 . S AQAOSTR=AQAOSTR_U_AQAOREF_U_$$DATESTMP ;include referred to
 . S ^TMP("AQAOCHK",$J,X,AQAOIND,AQAODT,AQAOIFN,AQAOLST,+Y)=AQAOSTR
 Q
 ;
SETREFRL(X,Y) ;EP; -- SUBRTN to set referred to;PATCH 4
 NEW Z S Z=""
 I X=0,+Y=0 S Z=$P(^AQAOC(AQAOIFN,1),U,9)
 I X=0,Y>0 S Z=$P(^AQAOC(AQAOIFN,"IADDRV",Y,0),U)
 I X>0,+Y=0 S Z=$P(^AQAOC(AQAOIFN,"REV",X,0),U,9)
 I X>0,Y>0 S Z=$P(^AQAOC(AQAOIFN,"REV",X,"ADDRV",Y,0),U)
 Q Z
 ;
DATESTMP()         ;EXTRN VAR to find data occ or review entered
 ;used to see if occ overdue for review
 N AQAODT,AQAOU S AQAOU=0 Q:X>3
 F  S AQAOU=$O(^AQAGU("AC",+AQAOIFN,AQAOU)) Q:AQAOU=""  Q:$D(AQAODT)  D
 .I X=1 Q:$P($G(^AQAGU(AQAOU,0)),U,4)'="O"
 .I X>1 Q:$P($G(^AQAGU(AQAOU,0)),U,4)'="E"
 .I X>1,AQAOLST=0 Q:$P($G(^AQAGU(AQAOU,0)),U,5)'="INITIAL REVIEW"
 .I X>1,AQAOLST>0 Q:$P($G(^AQAGU(AQAOU,0)),U,6)'=AQAOLST
 .S AQAODT=$P($G(^AQAGU(AQAOU,0)),U) ;date/time stamp
 Q $G(AQAODT)
 ;
 ;
OVERDUE() ;ENTRY POINT for EXTRN VAR
 ;to print * if occ overdue for review
 ;called by AQAOCHK2
 N AQAOP,X
 S X1=DT,X2=$P(AQAOSTR,U,4) D ^%DTC
 I X>$P(^AQAGP(DUZ(2),0),U,2) S AQAOP="*"
 Q $G(AQAOP)
 ;
 ;
SRV() ;EXTRN VAR to see if service screen is needed
 N X,Y S Y=1,X=0
 I $P(^AQAOC(AQAOIFN,0),U,11)=1,$P(^(0),U,7)]"",'($D(AQAOXYZ)#2) D
 .F  S X=$O(AQAOXYZ(1,X)) Q:X=""  I $D(^AQAO(2,"AC",X,$P(^AQAOC(AQAOIFN,0),U,8))),$D(^AQAO1(1,"AB",$P(^AQAOC(AQAOIFN,0),U,7),X)) Q  ;PATCH 2
 I X="" S Y=0 ;is auto occ and user not have access to team/srv combo
 Q Y
