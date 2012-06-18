AQAODEL ; IHS/ORDC/LJF - DELETE AN OCCURRENCE RECORD ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contians the code for user interface for deleting an
 ;occurrence.  Due to the importance of this data, the entry is just
 ;flagged as deleted.  It can be reopened, if needed.  Also, deleted
 ;occurrence summaries can be printed.
 ;
ASK ; >>> ask for occ id or patient name or indicator
 K AQAOIFN D ASK^AQAOLKP G EXIT:'$D(AQAOIFN)
 ;
 D FIND^AQAOREV1 ;find all reviews and display them
 ;
DELETE ; >>> delete occurrence
 W ! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you SURE you want to DELETE this Occurrence"
 D ^DIR G EXIT:$D(DIRUT),EXIT:Y'=1
 L +^AQAOC(AQAOIFN):1 I '$T D  G EXIT
 .W !!,"CANNOT DELETE; ANOTHER USER HAS ENTRY LOCKED. TRY AGAIN!",!
 L +^AQAGU(0):1 I '$T D  G EXIT
 .W !!,"CANNOT DELETE; AUDIT FILE LOCKED. TRY AGAIN.",!
 ;
 W !!!?5,"Deleting Occurrence #",AQAOCID,". . . .",!!
 S AQAOUDIT("DA")=AQAOIFN,AQAOUDIT("ACTION")="D"
 S AQAOUDIT("COMMENT")="DELETING A RECORD" D ^AQAOAUD
 K DIE S DIE="^AQAOC(",DA=AQAOIFN,DR=".11////2;.112"
 D ^DIE L -^AQAOC(AQAOIFN)
 ;
 ;
EXIT ; >> eoj
 D KILL^AQAOUTIL Q
