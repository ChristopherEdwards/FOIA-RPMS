ABSPOS2A ; IHS/FCS/DRS - continuation of ABSPOS2 ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
JOBS ; protocol ABSP P2 TMIT JOBS
 N WHAT S WHAT="Maximum number of transmitter-receiver jobs: "
 N PMT S PMT=WHAT
 S DEF=$$MAXJOBS^ABSPOSQ3
 N OPT,MIN,MAX,DEC S OPT=1,MIN=1,MAX=10,DEC=0
 N ANS S ANS=$$NUMERIC^ABSPOSU2(PMT,DEF,OPT,MIN,MAX,DEC)
 I ANS?1N.N D MAXJOBS^ABSPOSQ3(ANS)
 S ANS=$$MAXJOBS^ABSPOSQ3
 W !,WHAT," = ",ANS,!
 D ANY
 S VALMBCK=""
 Q
WOW ; protocol ABSP P2 WINNOW ; Winnow or Erase data or Big erase data
 ; This is going to be put on the manager menu proper, instead.
 ; Re-development is underway in ABSPOSK*
 W !,"This option is temporarily disabled.",! D ANY S VALMBCK="R" Q
ZERO ; protocol ABSP P2 ZERO ; clearing stats
 N PMT S PMT="Clear your local copy of stats (L) or clear the permanent copy (P)? "
 N DEF S DEF="L" ; default: my local copy
 N OPT S OPT=1 ; answer is optional
 N DISP S DISP="N" ; no display (it's in the prompt)
 N CHC S CHC="L:my Local copy;P:the Permanent copy"
 N ANS S ANS=$$SET^ABSPOSU3(PMT,DEF,OPT,DISP,CHC)
 ; ANS = "" or -1 or ^ or ^^ or L or P
 I ANS="L" D
 .W !,"Clearing local stats - in testing - copying CURR to BASE:",!
 .D DIFF^ABSPOS2 ; compute DIFF=CURR-BASE one last time
 .D ZLOCAL ; now we copy CURR into BASE; next time DIFFs will be 0
 E  I ANS="P" D
 .W !,"Clear the permanent stats? " I $$SURE'=1 Q
 .D ZPERM
 .D FETCHES^ABSPOS2(0) ; fetch all these zeroes into BASE(*)
 E  D  ; nothing if "" or -1 or ^ or ^^
 .W !,"Nothing changed.",!
 D ANY ; press any key
 ; then UPD calls UPDATE(1) calls UPD1 calls FETCHES(1) and DIFF,
 ; which will set lots of CHG nodes = 0, and display should show that
 D UPD^ABSPOS2
 S VALMBCK=""
 Q
ZLOCAL W !,"Clearing local stats - in testing",!
 W "we copy CURR(*) to BASE(*)",!
 K BASE M BASE=CURR
 Q
ZPERM W !,"Clearing permanent stats - in testing",!
 W "We do it by setting many fields in file 9002313.58 to zero",!
 N FILE S FILE=9002313.58
 L +^ABSPECX("S"):300 I '$T W "LOCK failed",! Q
 ;W "Idea: save old copies in higher-numbered nodes.",!
 D
 .N I F I=3,4 D
 . . N N S N=$P(^ABSPECX("S",0),U,I)+1
 . . S $P(^ABSPECX("S",0),U,I)=N
 . N N S N=$P(^ABSPECX("S",0),U,3)
 .M ^ABSPECX("S",N)=^ABSPECX("S",1)
 .S $P(^ABSPECX("S",N,0),U)=N ; fix up the .01 field
 .N DIK,DA S DIK="^ABSPECX(""S"",",DA=N D IX^DIK ; trivial indexing
 W "Now we zero out lots of fields: " H 1
 N FIELD S FIELD=.01
 F  S FIELD=$O(^DD(FILE,FIELD)) Q:'FIELD  D
 .N VALUE
 .I FIELD=2 D  ; date/time last cleared
 ..N %,%H,%I,X D NOW^%DTC S VALUE=%
 .E  S VALUE=0
 .N DIE,DA,DR S DIE=FILE,DA=1,DR=FIELD_"////"_VALUE D ^DIE
 W "Done",!
 L -^ABSPECX("S")
 Q
TMR ; Protocol ABSP P2 TRANSMITTER ; Transmitter on/off
 N CURR S CURR=$$SHUTDOWN^ABSPOSQ3 ; currently, the shutdown flag is:
 D TMNOW
 N PMT,DEF,OPT,ANS S PMT="Do you wish to "_$S(CURR:"en",1:"dis")
 S PMT=PMT_"able the transmitter-receiver"
 S DEF="N"
 S OPT=1
 S ANS=$$YESNO^ABSPOSU3(PMT,DEF,OPT)
 I ANS=1 I $$SHUTDOWN^ABSPOSQ3('CURR)
 S CURR=$$SHUTDOWN^ABSPOSQ3
 D TMNOW,ANY
 S VALMBCK=""
 Q
TMNOW W !,"The transmitter-receiver is currently "
 W $S(CURR:"dis",1:"en"),"abled.",! Q
POK ; protocol ABSP P2 POKE ; Poke the queues
 W !,"Poke the queues? " I $$SURE=1 D POKE^ABSPOS2D
 S VALMBCK=""
 Q
SURE(DEF) N SURE
 S PMT="Are you sure"
 I '$D(DEF) S DEF="Y"
 N OPT S OPT=1 ; answer is optional
 N ANS S ANS=$$YESNO^ABSPOSU3(PMT,DEF,OPT)
 Q ANS ; 1 or 0 or -1 or ^ or ^^ or null
ANY ;EP - from ABSPOS6D,ABSPOS6K
 W:$X ! D PRESSANY^ABSPOSU5() Q  ; Press any key
