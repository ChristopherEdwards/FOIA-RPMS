AQAOVAL ; IHS/ORDC/LJF - CLOSE OUT OCCURRENCES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface to close out an occurrence
 ;after all reviews have been performed.  This can be called from
 ;the review process if the user has access and the action was not
 ;a referral.
 ;
ASK ; >>> ask for occ id or patient name or indicator
 G EXIT:$D(AQAOENTR) ;called by ^AQAOENTR
 D ASK^AQAOLKP G EXIT:'$D(AQAOIFN),EXIT:$D(DUOUT),EXIT:$D(DTOUT)
 ;
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to see this occurrence's SUMMARY" D ^DIR
 I Y=1 S X=AQAOIFN D SUM
 ;
FIND ; >> find all reviews for this occurrence
 D FIND^AQAOREV1
 ;
 ;
CLOSE ;ENTRY POINT >>> close out occurrence
 W ! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("?",1)="Enter YES if the review process has been completed and"
 S DIR("?",2)="validated for this occurrence.",DIR("?")=" "
 S DIR("A")="Do you wish to CLOSE OUT this Occurrence" D ^DIR
 G EXIT:$D(DIRUT),ASK:Y'=1
 ;
 I '$$ALLREV^AQAOREV D  G EXIT:$D(DIRUT),ASK:Y'=1 ;PATCH 3
 . W !!,*7,"There appears to be some outstanding referrals" ;PATCH 3
 . W ! K DIR S DIR(0)="Y",DIR("B")="NO" ;PATCH 3
 . S DIR("A")="Are you SURE you want to close out this occurrence" ;PATCH 3
 . D ^DIR ;PATCH 3
 L +^AQAGU(0):1
 I '$T W !!,"CANNOT CLOSE; AUDIT FILE LOCKED. TRY AGAIN!",! G ASK
 L +^AQAOC(AQAOIFN):1
 I '$T W !!,"CANNOT CLOSE; ANOTHER USER EDITING OCCURRENCE.",! G ASK
 W !!!?5,"Closing out Occurrence #",AQAOCID,". . . .",!!
 S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="C"
 S AQAOUDIT("COMMENT")="CLOSE OUT RECORD" D ^AQAOAUD
 K DIE S DIE="^AQAOC(",DA=AQAOIFN
 I '$O(^AQAOC(AQAOIFN,"REV",0)) D  I 1
 .S X=^AQAOC(AQAOIFN,1) K AQAOCLS
 .S AQAOCLS(2)=$P(X,U,3),AQAOCLS(3)=$P(X,U,11),AQAOCLS(4)=$P(X,U,5)
 .S AQAOCLS(6)=$P(X,U,6),AQAOCLS(7)=$P(X,U,7)
 .S DR="[AQAO INITIAL CLOSE]" D ^DIE L -^AQAOC(AQAOIFN)
 E  I $D(AQAORIFN) D  I 1
 .K DIR S DIR(0)="Y"
 .S DIR("A")="Should I use this review as the final say for this occurrence"
 .S DIR("?",1)="Do you wish to use your answers for this review as the"
 .S DIR("?",2)="final ones for this occurrence?"
 .S DIR("?",3)="If you answer YES, I will automatically stuff your"
 .S DIR("?",4)="answers from this review as the final ones."
 .S DIR("?",5)="If you answer NO, I will ask you to answer each"
 .S DIR("?",6)="question for the final say on this occurrence"
 .S DIR("?")=" " D ^DIR
 .I Y=1 D  I 1 ;stuff answers
 ..S X=^AQAOC(AQAOIFN,"REV",AQAORIFN,0) K AQAOCLS
 ..S AQAOCLS(2)=$P(X,U),AQAOCLS(3)=$P(X,U,11),AQAOCLS(4)=$P(X,U,5)
 ..S AQAOCLS(6)=$P(X,U,7),AQAOCLS(7)=$P(X,U,6)
 ..S DR="[AQAO INITIAL CLOSE]" D ^DIE L -^AQAOC(AQAOIFN)
 .E  S DR="[AQAO CLOSE OUT]" D ^DIE L -^AQAOC(AQAOIFN)
 E  S DR="[AQAO CLOSE OUT]" D ^DIE L -^AQAOC(AQAOIFN)
 I '$D(Y) D
 .S AQAOACT=$P(^AQAOC(AQAOIFN,"FINAL"),U,6) ;action
 .I AQAOACT]"",$P(^AQAO(6,AQAOACT,0),U,4)=2 D  ;practitioner action
 ..S AQAOPT=$O(^AQAQX("B","AQAO PROV ACTION",0)) Q:AQAOPT=""
 ..K AQAOP D ^AQAOEDTS ;calls data entry driver
 .I $P(^AQAOC(AQAOIFN,"FINAL"),U,2)>1 D  ;not for non-clin prelim
 ..S AQAOPT=$O(^AQAQX("B","AQAO PROV LEVEL",0)) Q:AQAOPT=""
 ..K AQAOP D ^AQAOEDTS
 .W !! K DIR S DIR(0)="E"
 .S DIR("A")="Occurrence Closed.  Press RETURN to continue" D ^DIR
 ;
 ;
EXIT ; >> eoj
 D KILL^AQAOUTIL G EXIT1:$D(AQAOENTR)
 W ! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you wish to CLOSE OUT another occurrence" D ^DIR
 G EXIT1:$D(DIRUT),ASK:Y=1
EXIT1 K DIR,DIC Q
 ;
 ;
SUM ; >> SUBRTN to print occurrence summary
 N AQAOIFN,AQAORVW,AQAOARR,AQAOCID,AQAOPAT,AQAOIND,AQAODATE
 S AQAOIFN=X
 S X=$P(^AQAOC(AQAOIFN,0),U,2),AQAOARR(AQAOIFN)=$P(^DPT(X,0),U)
 S AQAODEV="HOME" D PRINT^AQAOPR3
 Q
