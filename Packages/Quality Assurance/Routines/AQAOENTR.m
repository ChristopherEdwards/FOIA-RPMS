AQAOENTR ; IHS/ORDC/LJF - ENTER OR EDIT AN OCCURRENCE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the main rtn for occurrence data entry.  It is used for
 ;adding new occurrences, editing occ data and initial reviews, and
 ;creating occurrences from visit-based search templates.
 ;
CHOOSE ; >>> choose add new occurrence or edit open one
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN) K AQAOIFN ;unlock previous occ
 D INTRO^AQAOHOCC ;intro text for option
 K DIR S DIR(0)="SO^A:ADD NEW OCCURRENCE;C:CREATE ENTRIES FROM SEARCH TEMPLATE;E:EDIT EXISTING OCCURRENCE"
 S DIR("A")="Choose the ACTION you wish to perform" D ^DIR
 G EXIT:X="",EXIT:$D(DIRUT),CHOOSE:Y=-1
 ;
 ; >>> use proper lookup then edit occurrence data
 I Y="C" D ^AQAOENTS G CHOOSE ;separate code for occ from searches
 ;                            ;if for edit, get occ, drop to visit
 I Y="E" D  G EXIT:'$D(AQAOIFN),CHOOSE:$D(DUOUT),EXIT:$D(DTOUT)
 .D ASK^AQAOLKP
 ;                            ;add new one, drop to visit line
 E  D ADD^AQAOLKP G EXIT:'$D(AQAOIFN),CHOOSE:$D(DUOUT),EXIT:$D(DTOUT)
 ;
 ;
VISIT ; >>> look up and add patient's visit
 L +^AQAOC(AQAOIFN):1 I '$T D  G CHOOSE ;lock occ
 .W !!,"CANNOT EDIT; ANOTHER USER IS EDITING THIS OCCURRENCE.",!
 L +^AQAGU(0):1 I '$T D  G CHOOSE ;lock audit file
 .W !!,"CANNOT EDIT OCCURRENCE; AUDIT FILE LOCKED. TRY AGAIN.",!
 S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="E"
 S AQAOUDIT("COMMENT")="EDIT OCCURRENCE" D ^AQAOAUD ;record transact
 ;
 W ! S AQAOVSIT=$P($G(^AQAO(2,$P(^AQAOC(AQAOIFN,0),U,8),1)),U,2)
 G EDIT:AQAOVSIT'="Y" ;not visit related
 G EDIT:$P(^AQAOC(AQAOIFN,0),U,3)'="" ;visit already in occurrence
 D VISIT^AQAOHOCC ;help text on visit
 W !! K DIR S DIR(0)="D^::EX",DIR("?")="^D VHELP^AQAOHOCC" ;PATCH 3
 S DIR("A")="Enter VISIT DATE" D ^DIR
 G EDIT:Y=U I Y<0 W *7,"??" G EDIT ;PATCH 3
 S APCDVLDT=Y ;date sent to pcc lookup rtn for visit ifn
 ;set APCDOVRR to override screen that dep entry count must be >1
 S APCDPAT=AQAOPAT,(APCDOVRR,APCDLOOK,APCDVSIT)=""
 D ^APCDVLK K APCDOVRR,APCDLOOK ;visit lookup needs only date
 G EDIT:X=U I APCDVSIT="" W *7,"??" G EDIT ;PATCH 3
 S AQAOSTR=$G(^AUPNVSIT(APCDVSIT,0))
 S DIE="^AQAOC(",DA=AQAOIFN S DR=".03////"_APCDVSIT D ^DIE ;stuff vsit
 K APCDCAT,APCDCLN,APCDDATE,APCDLOC,APCDPAT,APCDTYPE,APCDVSIT,APCDVLDT
 ;
 ;
EDIT ; >>> edit basic occurrence data
 ; >> find review type entered then loop thru fields
 S AQAOIND=$P(^AQAOC(AQAOIFN,0),U,8) G ASKREVU:AQAOIND="" ;ind ifn
 S AQAORT=$P($G(^AQAO(2,AQAOIND,1)),U) G ASKREVU:AQAORT="" ;revtyp ifn
 S AQAOPT=$P(^AQAO(3,AQAORT,0),U,3) G ASKREVU:AQAOPT="" ;driver ifn
 D ^AQAOEDTS ;data entry driver
 ;
 ; >> edit case summary field
 W !! D CSUM^AQAOHOCC S DIE="^AQAOC(",DA=AQAOIFN,DR="2" D ^DIE
 I $D(Y) G CHOOSE ;user entered "^"
 ;
 ;
ASKREVU ; >>> ask to begin review process
 ;
 ; if rate-based, stuff review then continue
 I $P(^AQAO(2,AQAOIND,0),U,4)="R",$P(^(1),U,4)]"",$P(^(1),U,5)]"",$P(^(1),U,6)]"",$P(^AQAOC(AQAOIFN,1),U,6)="" D  G CLOSE
 .L +^AQAGU(0):1 I '$T D  G CHOOSE
 ..W !!,"CANNOT ENTER REVIEW; AUDIT FILE LOCKED. TRY AGAIN.",!
 .S AQAOUDIT("COMMENT")="REVIEW STUFFED",AQAOUDIT("DA")=AQAOIFN
 .S AQAOUDIT("ACTION")="E" D ^AQAOAUD ;audit review
 .W !! K DIR S DA=AQAOIFN,DIE="^AQAOC(",DR="[AQAO RATE REVIEW]" D ^DIE
 .W !!,"Initial Review Recorded. . ."
 ;
 ; otherwise ask if user wants to enter initial review
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="DO YOU WISH TO START REVIEW PROCESS FOR THIS ENTRY"
 D ^DIR G EXIT:$D(DIRUT) I Y=0 W @IOF G CHOOSE
 ;
 I $P($G(^AQAOC(AQAOIFN,1)),U,6)]"" D  I Y'=1 G CLOSE
 .W !!,*7,"INITIAL REVIEW already performed!"
 .K DIR S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you wish to edit this INITIAL REVIEW" D ^DIR
 ;
INITIAL ; >>> enter initial review data
 L +^AQAGU(0):1 I '$T D  G CHOOSE
 .W !!,"CANNOT ENTER REVIEW; AUDIT FILE LOCKED. TRY AGAIN.",!
 S AQAOUDIT("COMMENT")="INITIAL REVIEW",AQAOUDIT("DA")=AQAOIFN
 S AQAOUDIT("ACTION")="E" D ^AQAOAUD ;audit review
 W !! K DIR S DA=AQAOIFN,DIE="^AQAOC(",DR="[AQAO FIRST REVIEW]"
 D ^DIE
 ;
 ;if initial action is practitioner-based, flag providers
 S AQAOACT=$P(^AQAOC(AQAOIFN,1),U,6) ;initial action
 I AQAOACT]"",$P(^AQAO(6,AQAOACT,0),U,4)=2 D  ;practitioner-based
 .S AQAOPT=$O(^AQAQX("B","AQAO PROV ACTION",0)) Q:AQAOPT=""
 .K AQAOP D ^AQAOEDTS ;call driver
 ;
 W !!,"INITIAL REVIEW COMPLETE . . ." H 2
 ;
CLOSE ;if user has close out key AND initial action not referral AND
 ;no other reviews exist for occ THEN user has chance to close out occ
 I $D(^XUSEC("AQAOZCLS",DUZ)),$P(^AQAOC(AQAOIFN,1),U,6)]"",$P(^AQAO(6,$P(^AQAOC(AQAOIFN,1),U,6),0),U,4)'=1,'$O(^AQAOC(AQAOIFN,"REV",0)) D
 .S AQAOENTR="" D CLOSE^AQAOVAL K AQAOENTR
 ;
 ;
 G CHOOSE
 ;
 ;
EXIT ; >>> eoj
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN)
 D KILL^AQAOUTIL Q
 ;
 ;
ERROR ; >>> SUBRTN to print error msg
 W !!,*7,"COULD NOT ADD OCCURRENCE TO FILE!  PLEASE SEE SITE MANAGER!"
 W !! G EXIT
