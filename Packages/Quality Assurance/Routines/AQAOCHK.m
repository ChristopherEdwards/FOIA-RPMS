AQAOCHK ; IHS/ORDC/LJF - CHECK OCC NEEDING REVIEW ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is main driver for the Introductory Message upom entrance
 ;to main QAI menu.  It is also called from the Tickler Report option.
 ;This rtn finds all occurrences needing some action by the user who
 ;is signed on.  QI staff members see all occurrences pending.
 ;PATCH #4: close to a complete rewrite
 ;
 ; AQAOXYZ="ALL" for QI staff which see all occurrences
 ; AQAOXYZ(1,TEAM IFN)
 ; AQAOXYZ(2,INDICATOR IFN) for entries in AQAOXYZ(1,TEAM IFN)
 ; array for occ counts AQAOXYZ(3,
 ; second subscript: 1=initial review needed
 ;                   2=personal referral
 ;                   3=referral to team
 ;                   4=reviewed, not closed
 ;                   5=pending action plans
 ;
ENTRY ;ENTRY POINT to build array counting occ needing review
 ;called by main menu option AQAOMENU and by AQAOCHK2
 W !!,*7,"Checking for OCCURRENCES & ACTION PLANS you need to review"
 W ". . . . ."
 ;
 S AQAODUZ=DUZ
 K AQAOXYZ K ^TMP("AQAOCHK",$J) ;start clean
 I $P(AQAOUA("USER"),U,6)]"" S AQAOXYZ="ALL" ;qi staff sees all
 ;
 ; -- find indicators user has access to
 ; -- find all teams user has write access to
 S X=0 F  S X=$O(^AQAO(9,AQAODUZ,"TM",X)) Q:'X  D
 . Q:$P(^AQAO(9,AQAODUZ,"TM",X,0),U,2)'=2  ;need write access
 . S Y=$P(^AQAO(9,AQAODUZ,"TM",X,0),U)
 . S AQAOXYZ(1,Y)=""
 . ; -- find all indicators for this team
 . S AQAOIND=0
 . F  S AQAOIND=$O(^AQAO(2,"AC",Y,AQAOIND)) Q:AQAOIND=""  D
 .. S AQAOXYZ(2,AQAOIND)="" ;save list of indicators
 ;
 ;
OCC ;EP; -- loop thru open occurrences then check if on indicator list
 S AQAOIFN=0
 F  S AQAOIFN=$O(^AQAOC("AD",0,AQAOIFN)) Q:AQAOIFN=""  D
 . Q:'$D(^AQAOC(AQAOIFN,0))  Q:$P(^(0),U,9)'=DUZ(2)
 . S AQAOIND=$P(^AQAOC(AQAOIFN,0),U,8),AQAODT=$P(^(0),U,4)
 . S AQAOAC=$P($G(^AQAOC(AQAOIFN,1)),U,6) ;initial review action
 . I AQAOAC="" S X=1 D SET^AQAOCHK0 Q  ;needs initial review
 . D REVIEWS,OPEN
 D ACTION
 ;
NEXT ; -- go to print rtn
 ;if no occ needing review found; quit rtn
 I '$D(AQAOXYZ(3)) W !!,"*** NONE FOUND ***" G END^AQAOCHK2
 G ^AQAOCHK1
 ;
 ;
REVIEWS ; -- SUBRTN to find occ referred to user or team
 K AQAOR1,AQAOR2,AQAOA,AQAOB
 ; -- check for initial referral
 S A=$P(^AQAOC(AQAOIFN,1),U,6) Q:A=""  Q:$P(^AQAO(6,A,0),U,4)'=1
 S AQAOX=$P(^AQAOC(AQAOIFN,1),U,9) Q:AQAOX=""  ;no referral on initial
 S AQAODT=$P(^AQAOC(AQAOIFN,1),U,8),R=$P(^AQAOC(AQAOIFN,1),U,4)
 D REVSET(AQAOX,0,AQAODT,R)
 ;
 ; -- check for addtnl referrals on initial review
 S AQAOA=0
 F  S AQAOA=$O(^AQAOC(AQAOIFN,"IADDRV",AQAOA)) Q:'AQAOA  D
 . S AQAOX=$P(^AQAOC(AQAOIFN,"IADDRV",AQAOA,0),U)
 . D REVSET(AQAOX,0_","_AQAOA,AQAODT,R)
 ;
 ; -- check for other reviews
 S AQAOREV=0
 F  S AQAOREV=$O(^AQAOC(AQAOIFN,"REV",AQAOREV)) Q:AQAOREV'=+AQAOREV  D
 . S X=^AQAOC(AQAOIFN,"REV",AQAOREV,0),AQAOY=$P(X,U,2)
 . S A=$P(X,U,7) Q:A=""
 . S AQAOX=$P(X,U,9),AQAODT=$P(X,U,4)
 . ; -- not referral action but still save reviewed by
 . I (AQAOX="")!($P(^AQAO(6,A,0),U,4)'=1) S AQAOR2(AQAOY)=AQAODT_U_AQAOREV Q
 . D REVSET(AQAOX,AQAOREV,AQAODT,AQAOY) ;chk referred to
 . ;
 . ; -- check addtnl refls on review
 . S AQAOB=0
 . F  S AQAOB=$O(^AQAOC(AQAOIFN,"REV",AQAOREV,"ADDRV",AQAOB)) Q:'AQAOB  D
 .. S AQAOX=$P(^AQAOC(AQAOIFN,"REV",AQAOREV,"ADDRV",AQAOB,0),U)
 .. D REVSET(AQAOX,AQAOREV,AQAODT,AQAOY)
 ;
 ; -- show all referrals not yet reviewed if qi staff
 I $D(AQAOXYZ)#2 D QIREF^AQAOCHK0 Q
 ;
 Q:'$D(AQAOR1)
 D USER
 D TEAM
 Q
 ;
 ;
USER ; -- check if user has referral after last review performed by user
 NEW X,Y,AQAOREF
 S X=AQAODUZ_";AQAO(9," Q:'$D(AQAOR1(X))  ;no referrals for user
 S Y=AQAODUZ_";VA(200,"
 I $P(AQAOR1(X),U)'<+$G(AQAOR2(Y)) D
 . S Y=$P(AQAOR1(X),U,2),(X,AQAOLST)=+Y,Y=$P(Y,",",2)
 . S AQAOREF=$$SETREFRL^AQAOCHK0(X,Y) Q:AQAOREF=""
 . D REFSET^AQAOCHK0
 Q
 ;
TEAM ; -- check if team has referral after last review performed by team
 NEW X,Y,Z,AQAOREF
 S Z=0 F  S Z=$O(AQAOXYZ(1,Z)) Q:'Z  D
 . S (X,Y)=Z_";AQAO1(1," Q:'$D(AQAOR1(X))
 . I $P(AQAOR1(X),U)'<+$G(AQAOR2(Y)) D
 .. S Y=$P(AQAOR1(X),U,2),(X,AQAOLST)=+Y,Y=$P(Y,",",2)
 .. S AQAOREF=$$SETREFRL^AQAOCHK0(X,Y)
 .. D REFSET^AQAOCHK0
 Q
 ;
REVSET(X,Y,D,R) ; -- SUBRTN to set review array
 ; X=referred to, Y=review number, D=review date, R=reviewed by
 S AQAOR1(X)=D_U_Y,AQAOR2(R)=D_U_Y Q
 I $D(AQAOXYZ)#2 S AQAOR1(X)=D_U_Y,AQAOR2(R)=D_U_Y Q
 I X["AQAO(9",+X=AQAODUZ S AQAOR1(X)=D_U_Y
 I X["AQAO1(1",$D(AQAOXYZ(1,+X)) S AQAOR1(X)=D_U_Y
 I R["VA(200",+R=AQAODUZ S AQAOR2(R)=D_U_Y
 I R["AQAO1(1",$D(AQAOXYZ(1,+R)) S AQAOR2(R)=D_U_Y
 Q
 ;
OPEN ; -- SUBRTN to find open cases
 NEW X,Y
 S X=0 F  S X=$O(AQAOR1(X)) Q:'X  D
 . I $P(AQAOR1(X),U)<+$G(AQAOR2(X)) K AQAOR1(X)
 Q:$D(AQAOR1)
 S X=4,AQAOLST=$$LASTREV D SET^AQAOCHK0
 Q
 ;
LASTREV() ; -- SUBRTN to find last review date
 NEW X,D,Y S (X,D,Y)=0
 F  S X=$O(AQAOR2(X)) Q:'X  D
 . I AQAOR2(X)>D S Y=$P(AQAOR2(X),U,2),D=$P(AQAOR2(X),U)
 Q Y
 ;
ACTION ; -- SUBRTN to find any pending action plans user needs to review
 F I=1:1:5 S AQAOPLN=0 D
 .F  S AQAOPLN=$O(^AQAO(5,"AC",I,AQAOPLN)) Q:AQAOPLN=""  D
 ..Q:'$D(^AQAO(5,AQAOPLN,0))  S AQAOSTR=^(0),AQAOIND=$P(AQAOSTR,U,14)
 ..Q:$P(^AQAO(5,AQAOPLN,0),U,12)'=DUZ(2)  ;PATCH 3
 ..I '($D(AQAOXYZ)#2),AQAOIND]"" Q:'$D(AQAOXYZ(2,AQAOIND))  ;not usr ind
 ..I (I=2),($P(AQAOSTR,U,4)]""),($P(AQAOSTR,U,4)<DT) Q  ;future revw dt
 ..Q:$P(AQAOSTR,U,6)]""  ;closed action
 ..S AQAOXYZ(3,5,I)=$G(AQAOXYZ(3,5,I))+1
 ..S ^TMP("AQAOCHK",$J,5,AQAOIND,I,AQAOPLN)=""
 Q
