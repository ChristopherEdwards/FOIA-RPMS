ABSPOSL1 ; IHS/FCS/DRS - log file printing ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; D CLAIMLOG^ABSPOS6M - individual claims, as called from user screen
 ; D PRINTLOG^ABSPOSBD - DT+.2 - background posting to A/R 
 ; D label^ABSPOSBL   - billing log file - ILC interface - n+.2
 ; ABSPOSC2, ABSPOSC3 - testing and certification
 ; D LOGFILE^ABSPOSR1 - DT+.3 - background scanner of ^PSRX(indexes)
 ; D LASTLOG^ABSPOSRB - same as in ABSPOSRX, below
 ; D LASTLOG^ABSPOSRX - DT+.4 - background claims submission 
 ; D LOGFILE^ABSPOSR4 - DT+.6 - back billing
 ; D COMMSLOG^ABSPOSU6 - dial out's log files - offset .1
 ; (no entry point)  - DT+.5 - winnowing old data
 ; D PRINT^ABSPOSUT - the programmer-mode modem tests
 ;
 ;  Two entry points:  PRINTLOG to print the log file, given the #
 ;  And PRINTDAT(type,start,end) prints all log files of the given
 ;    type in the given date range.  It prompts for missing parameters.
 ;    (if start is given and end is missing, it just does start)
 ;
PRINTDAT(TYPE,START,END) ;EP
 I '$D(TYPE) S TYPE=$$GETTYPE Q:'TYPE
 W !
 I $D(START) D
 . I '$D(END) S END=START
 E  D  Q:'START
 . S START=$$GETDATES,END=$P(START,U,2),START=$P(START,U)
 N POP D ^%ZIS Q:$G(POP)
 N FORDATE S FORDATE=START F  D  Q:FORDATE>END
 . N SLOT S SLOT=FORDATE+(TYPE/10)
 . I $$EXISTS^ABSPOSL(SLOT) D
 . . D PRINTLOG(SLOT)
 . E  D
 . . W "There is no log file ",SLOT,! H 1
 . S FORDATE=$$TADD^ABSPOSUD(FORDATE,1) ; add one day
 D ^%ZISC
 Q
GETDATES() ; return start^end
 N PROMPT1 S PROMPT1="Starting date: "
 N PROMPT2 S PROMPT2="  Ending date: "
 N DEF1,DEF2 S (DEF1,DEF2)=DT
 Q $$DTR^ABSPOSU1(PROMPT1,PROMPT2,DEF1,DEF2,"")
GETTYPE() ; return 2 = billing, 3 = background scanner, etc.
 N PROMPT S PROMPT="Which log file? "
 N DEF S DEF=2
 N MODE S MODE="V"
 N MENU S MENU="2:Billing;3:Background scan;4:Claims submitter;5:Winnowing;6:Back billing"
 Q $$SET^ABSPOSU3(PROMPT,DEF,1,MODE,MENU)
PRINTLOG(SLOT,START,END)     ; EP 
 I $Y D HDR
 I '$$EXISTS^ABSPOSL(SLOT) W "Nothing in SLOT=",SLOT,! Q
 I '$G(START) N START S START=1
 I '$G(END) N END S END=$$PRINTEND^ABSPOSL(SLOT)
 N PREVTIME S PREVTIME=""
 N MISS S MISS=0 ; count of missing lines
 N LEN S LEN=$S($G(IOM):IOM,1:80)-10-1
 N STOP S STOP=0
 N LINE F LINE=START:1:END D  Q:STOP
 .I '$D(^ABSPECP("LOG",SLOT,LINE)) D  Q
 ..I MISS>3 Q  ; don't bother saying any more
 ..S MISS=MISS+1 W "Missing line ",LINE
 ..I MISS=3 W "; no more missing lines will be reported."
 ..W !
 .N X S X=^ABSPECP("LOG",SLOT,LINE) ; =$H seconds^text
 .N % S %=$P(X,U)
 .I %'=PREVTIME S PREVTIME=% D
 ..S %=PREVTIME W $J(%\3600,2),":" S %=%#3600
 ..W $TR($J(%\60,2)," ","0"),":" S %=$J(%#60,2) W $TR(%," ",0)
 .S X=$P(X,U,2,$L(X,U))
 .N I F I=1:LEN:$L(X) D  Q:STOP
 ..I I>1 W ?6,"..."
 ..W ?10,$E(X,I,I+LEN-1),!
 ..D EOP
 Q
EOP ; end of page handling
 ; set STOP if the user wants to get out
 S STOP=$$EOPQ^ABSPOSU8(2,,"D HDR^"_$T(+0))
 Q
HDR W @IOF,"Log file #",SLOT,! Q
