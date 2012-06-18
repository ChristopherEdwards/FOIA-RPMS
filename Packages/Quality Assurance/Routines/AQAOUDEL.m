AQAOUDEL ; IHS/ORDC/LJF - REOPEN AN OCCURRENCE RECORD ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface to reopen closed and deleted
 ;occurrences.
 ;
ASK ; >>> ask for occ id or patient name or indicator
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN) ;unlock last occ reopened
 S AQAOINAC="" W !! K DIC S DIC="^AQAOC(",DIC(0)="AEMQZ"
 S DIC("A")="Select OCCURRENCE (ID #, Patient, or Indicator):  "
 S DIC("S")="D OCCCHK^AQAOSEC I $D(AQAOCHK(""OK"")),($P(^(1),U)'=0)"
 D ^DIC G EXIT:$D(DTOUT),EXIT:$D(DUOUT),EXIT:X="",EXIT:Y=-1
 S AQAOIFN=+Y,AQAOCID=Y(0,0)
 ;
 ; >>> display occurrence
 S L="",DIC="^AQAOC(",FLDS="[AQAO OCC SHORT DISPLAY]"
 S BY="@NUMBER",(TO,FR)=AQAOIFN,IOP=IO(0) D EN1^DIP ;display occurrence
 K DIR S DIR(0)="E"
 S DIR("A")="Press RETURN to continue OR '^' to select another occurrence"
 D ^DIR
 ;
 ;
REOPEN ; >>> reopen occurrence
 W ! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you SURE you want to REOPEN this Occurrence"
 D ^DIR G EXIT:$D(DIRUT),EXIT:Y'=1
 L +^AQAOC(AQAOIFN):1 I '$T D  G ASK
 .W !!,"CANNOT REOPEN; ANOTHER USER IS EDITING THIS OCCURRENCE.",!
 L +^AQAGU(0):1 I '$T D  G ASK
 .W !!,"CANNOT REOPEN OCCURRENCE; AUDIT FILE LOCKED.  TRY AGAIN.",!
 W !!!?5,"Reactivating Occurrence #",AQAOCID,". . . .",!!
 S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="O"
 S AQAOUDIT("COMMENT")="REOPENING A RECORD" D ^AQAOAUD
 K DIE S DIE="^AQAOC(",DA=AQAOIFN,DR="[AQAO REOPEN]" D ^DIE
 ;
EXIT ; >> eoj
 I $D(AQAOIFN) L -^AQAOC(AQAOIFN)
 D KILL^AQAOUTIL K AQAOINAC Q
