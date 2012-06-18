ABSPOSR1 ; IHS/FCS/DRS - silent claim submitter ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ; This routine monitors ^PSRX indexes.  As it detects 
 ; the release of prescriptions and sometimes cancellations, too,
 ; it silently submits claims and sometimes reversals, too.
 ; Only one of these may run at a time!
 Q
STARTME ;EP - enter here to start the background job (by asking Taskman)
 ; option ABSP BACKGROUND SCAN START
 W !
 Q:'$$CHKTYPE(1)
 N STATUS S STATUS=$$STATUS
 W "The background scanner is now ",$$STATUS,!
 I $$RUNNING W "The background scanner job is already running.",!
 I STATUS["?" D
 . W "But since the status is uncertain, let's stop and restart:",!
 . D STOPME
 D TASK^ABSPOSR1
 W "Taskman will start the background scanner job.",!
 Q
STOPME ;EP - enter here to stop the background job
 ; option ABSP BACKGROUND SCAN STOP
 W !
 Q:'$$CHKTYPE(1)
 W "Stopping the background scanner job..."
 D STOPIT(1)
 W !
 Q
MYSTATUS ;EP - enter here to inquire of background job's status
 ; option ABSP BACKGROUND SCAN STATUS
 W !
 Q:'$$CHKTYPE(1)
 N X S X=$$STATUS
 W "Status of POS background job: ",X,!
 N DIC,DA,DR,DIQ
 S DIC="^ABSP(9002313.99,",DA=1,DR=$T(+0) D EN^DIQ
 Q
LOGFILE ;EP -
 D LOGFILE1(.3) Q
LOGFILE1(OFFSET) ;EP - enter here to print background job's log file
 ; OFFSET = the .3 or .6 or whatever the "+" is for this type
 W !,"Print "
 I OFFSET=.3 W "background job's"
 E  I OFFSET=.6 W "back billing"
 W " log file",!
 I $$CHKTYPE(1) ; just report; don't roadblock with it
 N ABSPDATE,PROMPT,DEFAULT
 S PROMPT="Print log file for what date? ",DEFAULT=DT
 S ABSPDATE=$$DATE^ABSPOSU1(PROMPT,DEFAULT,1,3010101,9999999,"EX")
 Q:ABSPDATE<1
 N POP D ^%ZIS Q:$G(POP)
 N LOGFILE S LOGFILE=ABSPDATE+OFFSET
 D PRINTLOG^ABSPOSL(ABSPDATE+OFFSET)
 D PRESSANY^ABSPOSU5()
 D ^%ZISC
 Q
RUNNING()          ;
 N I,S F I=1:1:10 S S=$$STATUS Q:S="RUNNING"  Q:S="STOPPED"  H 5
 Q S'="STOPPED" ; "REQUESTED STOP" comes back True, like RUNNING
CHKTYPE(ECHO) ; returns True if input type is the background polling job
 ; returns False if not
 N XI S XI=$$GET1^DIQ(9002313.99,"1,",943,"I")
 I XI=2 Q 1 ; yes, background scanner.
 ; not background scanner
 I $G(ECHO) D
 . W "The input method on this POS system is ",$$GET1^DIQ(9002313.99,"1,",943),!
 . W "This program is only for use with the background scanner method.",!
 Q 0
TASK ;EP -
 N X,%DT,Y S X="N",%DT="ST" D ^%DT
 D TASKAT(Y)
 Q
TASKAT(ZTDTH) ;
 N ZTRTN,ZTIO
 S ZTRTN="EN^ABSPOSR1",ZTIO=""
 D ^%ZTLOAD
 Q
STATUS() ; external call to get the status
 ; returns "RUNNING" or "STOPPED" or "REQUESTED STOP"
 ; maybe with a "?"
 N X S X=$$GETFIELD(120.03) S:X="" X=2
 ; make sure the lock status is consistent with the numerical status
 N Y S Y=$$LOCK I Y D UNLOCK
 I X=0 Q "RUNNING"_$S(Y:"?",1:"")
 I X=1 Q "REQUESTED STOP"_$S(Y:"?",1:"")
 I X=2 Q "STOPPED"_$S(Y:"",1:"?")
 Q "?"
STOPIT(ECHO,NOWAIT) ;EP - external call to request that it stop
 ; and wait until it is stopped
 ; May DO or $$; $$ returns value of stop flag (2 = success)
 I $$GETFIELD(120.03)=2 Q  ; already stopped
 D SETFIELD(120.03,1) ; set the "stop requested" flag
 I '$G(NOWAIT) D
 . F  Q:$$GETFIELD(120.03)=2  D  H 5
 . . I $G(ECHO) W "." W:$X>74 !
 . . ; Handle the case where the job was killed:
 . . ; Run flag says its running but the lock says it's not
 . . ; So force run flag to say "stopped".
 . . I $$STATUS="REQUESTED STOP?" D SETFIELD(120.03,2)
 Q:$Q $$GETFIELD(120.03) Q
DELAYSTP(N) H N D STOPIT() Q  ; J TEST^ABSPOSR1 for your testing
 ;
 ; Advice for testing:
 ;  0. Init ^ABSP(9002313.99,"ABSPOSR1")=a starting T1 time
 ;  Just do this once, ever.
 ;
 ;  Then for each time you do testing:
 ;  1. DO NEXT^ABSPOSR1(N) ; N = desired number of transactions
 ;     and it sets T1,T2 so you get N transactions
 ;  2. D TEST^ABSPOSR1 to actually run the test.
 ;     When done, it will update ^ABSP(9002313.99,"ABSPOSR1")
 ;     to be 1 second past the previous T2 that you used.
 ;  3. DO ^ABSPOS (which goes to EN^ABSPOS6A) to watch the results.
 ;  4. D LASTLOG^ABSPOSR1 to examine the .3 log and see what's going on
TEST W !,"Running the test - times ",T1,"-",T2,!
 I '$$LOCK W "Can't get LOCK",! Q
 D INIT^ABSPOSL(.3,1)
 D DEFAULTS
 D KTESTLST
 D WORKLIST^ABSPOSR3(T1,T2,$$TESTLIST)
 D PROCESS^ABSPOSR3($$TESTLIST)
 D LASTLOG
 D UNLOCK
 S $P(^ABSP(9002313.99,"ABSPOSR1"),U)=$$TADD^ABSPOSUD(T2,.000001)
 Q
KTESTLST K ^ABSPECP($T(+0)_" TESTING") Q
TESTLIST() Q "^ABSPECP("""_$T(+0)_" TESTING"")"
LASTLOG ; tool for test - find and print most recent log file
 N X S X=2990000
 F  S X=$O(^ABSPECP("LOG",X),-1) Q:'X  Q:X#1=.3
 I 'X W "No log file found",! Q
 D PRINTLOG^ABSPOSL(X)
 Q
EN ; EP - via Taskman as initiated by START, above
 ; main program for background job to stealthily submit claims
 ; changes to EN should be mimicked in TEST(), above
 I '$$LOCK Q
 N RESTART
 D SETFIELD(120.01,$J),SETFIELD(120.03,0)
 D INIT^ABSPOSL(DT+.3,1)
 D LOG("Background claim submitter running as job "_$J)
 D DEFAULTS
 D MONITOR^ABSPOSR3 ; may set RESTART
 D LOG("Background claim submitter job "_$J_" completed.")
 D RELSLOT^ABSPOSL
 D UNLOCK
 I $G(RESTART) D TASK
 Q
DEFAULTS ;EP -
 I '$$GETFIELD(120.02) D SETFIELD(120.02,"NOW","E") ; last time proc'd
 I '$$GETFIELD(120.04) D SETFIELD(120.04,30) ; default interval 30 sec
 ; 30 secs is the minimum!  you have to allow time for ABSPOSRX
 ; to get background jobs started, to create .59 entries, etc.
 I '$$GETFIELD(120.05) D SETFIELD(120.05,30) ; reach back more sec
 ; but you miss something if they enter it now with a release time
 ; of an hour ago, or yesterday
 I $$GETFIELD(120.06)="" D SETFIELD(120.06,"AL") ; index for new claims
 I $$GETFIELD(120.07)="" D SETFIELD(120.07,"AJ") ; index for canceled
 Q
SETFIELD(FIELD,VALUE,FLAGS) ;EP -
 N FDA,IENS,MSG,FN S IENS="1,",FN=9002313.99
 S FDA(FN,IENS,FIELD)=VALUE
SF1 D FILE^DIE($G(FLAGS),"FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("FLAGS","FDA","MSG","FIELD","VALUE")
 G SF1:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"SETFIELD",$T(+0))
 Q
GETFIELD(FIELD) ;EP -
 Q $P($G(^ABSP(9002313.99,1,"ABSPOSR1")),U,FIELD-120*100)
LOCK() L +^ABSP(9002313.99,"ABSPOSR1"):0 Q $T
UNLOCK L -^ABSP(9002313.99,"ABSPOSR1") Q
LOG(X) D LOG^ABSPOSL(X) Q
