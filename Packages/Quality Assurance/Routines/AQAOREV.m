AQAOREV ; IHS/ORDC/LJF - ENTER OCCURRENCE REVIEWS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface to enter occurrence reviews.
 ;
ASK ; >> ask for occ id
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN) ;unlock last occ reviewed
 S AQAORVW="" ;flag:allow referred to reviewer to see occ
 D INTRO^AQAOHREV ;intro text
 K AQAOIFN ;start out clean, no occ variable
 ;
 D ASK^AQAOLKP G EXIT:'$D(AQAOIFN),EXIT:$D(DUOUT),EXIT:$D(DTOUT)
 ;
START ; >> lock entry, display summary, display reviews
 L +^AQAOC(AQAOIFN):1 I '$T D  G ASK
 .W !!,"CANNOT EDIT; ANOTHER USER IS EDITING THIS OCCURRENCE.",!
 ;
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to see this occurrence's SUMMARY" D ^DIR
 I Y=1 S X=AQAOIFN D SUM^AQAOREV1
 ;
 D FIND^AQAOREV1 G ASK:AQAOSTOP=U ;find and display all reviews
 ;
CHOOSE ; >> choose review entry to add or edit
 I AQAONUM=0 D ADD G:'$D(AQAORIFN) ASK G EDIT ;if none, try add
 K DIR S DIR(0)="NO^1:"_(AQAONUM+1),DIR("A")="Choose ONE from list"
 S DIR("A",1)=(AQAONUM+1)_".  ADD a NEW REVIEW Entry"
 D ^DIR G EXIT:$D(DIRUT)
 I Y=(AQAONUM+1) D  G:'$D(AQAORIFN) ASK I 1 ;chose to add new entry
 .K AQAO,AQAORIFN D ADD
 E  S AQAORIFN=$P(AQAO(+Y),U) ;chose to edit an entry
 ;
EDIT ; edit review
 L +^AQAGU(0):1 I '$T D  G EXIT
 .W !!,"CANNOT ENTER REVIEW; AUDIT FILE LOCKED. TRY AGAIN.",!
 S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="E"
 S AQAOUDIT("REV")=AQAORIFN
 S AQAOUDIT("COMMENT")="EDIT OCCURRENCE REVIEW" D ^AQAOAUD
 ;
 K DIE,DIR S DIE="^AQAOC("_AQAOIFN_",""REV"",",DA(1)=AQAOIFN,DA=AQAORIFN
 S DR=".01;S AQAORLX=X;.02;.04;I AQAORLX=1 S Y=""@1"";.011;.06;@1;.05;.07;S:$P(^AQAO(6,$P(^AQAOC(AQAOIFN,""REV"",AQAORIFN,0),U,7),0),U,4)'=1 Y=""@2"";.09;2;@2;1"
 D ^DIE
 ;
 S AQAOACT=$P($G(^AQAOC(AQAOIFN,"REV",AQAORIFN,0)),U,7) ;action;PATCH 1
 I AQAOACT]"",$P(^AQAO(6,AQAOACT,0),U,4)=2 D  ;practitioner action
 .S AQAOPT=$O(^AQAQX("B","AQAO PROV ACTION",0)) Q:AQAOPT=""
 .K AQAOP D ^AQAOEDTS ;call data entry driver
 E  D  ;update prov list;PATCH 3
 .S AQAOPT=$O(^AQAQX("B","AQAO PROV LEVEL",0)) Q:AQAOPT=""  ;PATCH 3
 .K AQAOP D ^AQAOEDTS ;PATCH 3
 ;
 I $D(^XUSEC("AQAOZVAL",DUZ)),$P($G(^AQAO(6,+AQAOACT,0)),U,4)'=1,'$O(^AQAOC(AQAOIFN,"REV",AQAORIFN)),$$ALLREV D  ;PATCH 3
 .S AQAOENTR="" D CLOSE^AQAOVAL K AQAOENTR ;close out occ
 ;
 D PRTOPT^AQAOVAR G ASK
 ;
EXIT ; >> eoj
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN)
 D KILL^AQAOUTIL Q
 ;
ADD ; SUBRTN to add new review to occ
 L +^AQAGU(0):1 I '$T D  Q
 .W !!,"CANNOT ADD NEW REVIEW; AUDIT FILE LOCKED.  TRY AGAIN.",!
 W !!,"(To add a review for a stage already used, enter in quotes, i.e. ""PEER"".)"
 I '$D(^AQAOC(AQAOIFN,"REV",0)) S ^AQAOC(AQAOIFN,"REV",0)="^9002167.01P^^"
 K DIC S DIC="^AQAOC("_AQAOIFN_",""REV"",",DA(1)=AQAOIFN
 S DIC(0)="AEMZQL" D ^DIC I +Y>0 S AQAORIFN=+Y
 Q:'$D(AQAORIFN)  S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="E"
 S AQAOUDIT("COMMENT")="ADD OCCURRENCE REVIEW",AQAOUDIT("REV")=AQAORIFN
 D ^AQAOAUD
 Q
 ;
 ;
ALLREV() ;EP; -- SUBRTN to return whether referrals covered by reviews;PATCH 3
 Q $S($$REFCNT>$$REVCNT:0,1:1)
 ;
REFCNT() ; -- SUBRTN to return # of referrals;PATCH 3
 NEW AQAORF,X,Y S AQAORF=0
 ;
 ; -- initial review was referral?
 I $P($G(^AQAOC(AQAOIFN,1)),U,9)]"" S AQAORF=AQAORF+1
 ; -- any additional referrals on initial review?
 S X=0
 F  S X=$O(^AQAOC(AQAOIFN,"IADDRV",X)) Q:X'=+X  S AQAORF=AQAORF+1
 ;
 ; -- count referrals on other reviews
 S X=0 F  S X=$O(^AQAOC(AQAOIFN,"REV",X)) Q:X'=+X  D
 . I $P($G(^AQAOC(AQAOIFN,"REV",X,0)),U,9)]"" S AQAORF=AQAORF+1
 . S Y=0
 . F  S Y=$O(^AQAOC(AQAOIFN,"REV",X,"ADDRV",Y)) Q:Y'=+Y  D
 .. S AQAORF=AQAORF+1
 ;
 Q AQAORF
 ;
REVCNT() ; -- SUBRTN to return # of reviews;PATCH 3
 NEW AQAORV,X S AQAORV=0
 S X=0 F  S X=$O(^AQAOC(AQAOIFN,"REV",X)) Q:X'=+X  S AQAORV=AQAORV+1
 Q AQAORV
