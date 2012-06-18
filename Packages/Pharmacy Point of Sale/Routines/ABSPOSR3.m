ABSPOSR3 ; IHS/FCS/DRS - silent claim submitter ;    
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q  ; continuation of ABSPOSR1
GETFIELD(X)        Q $$GETFIELD^ABSPOSR1(X)
MONITOR ;EP -
 N DOLLARH S DOLLARH(2)=+$H
 F  D  Q:$$STOP
 . D HANG
 . S DOLLARH(1)=DOLLARH(2)
 . S DOLLARH(2)=+$H
 . I DOLLARH(1)=DOLLARH(2) D
 . . D POLL
 . E  D  ; $H flipped over to a new day
 . . D STOPIT^ABSPOSR1(0,1) ; stop the background job (no echo, no wait)
 . . S RESTART=1 ; flag - we want to start it up again
 D SETFIELD^ABSPOSR1(120.03,2) ; mark that we stopped
 Q
HANG N X S X=$$GETFIELD(120.04)
 H $S(X>30:X,1:30) Q  ; enforce minimum of 30 seconds between polls
STOP() Q $$GETFIELD(120.03)=1 ; returns True if value 1 = Stop requested
LOG(X) D LOG^ABSPOSL(X) Q
POLL ; here's where we poll and see what's new
 D LOG("Polling")
 ; What was the last time we polled?
 N LASTTIME S LASTTIME=$$GETFIELD(120.02)
 ; And update it to say "last time we did it was now"
 D SETFIELD^ABSPOSR1(120.02,"NOW","E")
 ; Reach back some more beyond that time
 ;  (this is to allow for delays in filing)
 S LASTTIME=$$TADDSECS^ABSPOSUD(LASTTIME,-$$GETFIELD(120.05))
 N TIME,ENDTIME S TIME=LASTTIME,ENDTIME=""
 D WORKLIST(TIME,ENDTIME,$$MYLIST)
 D PROCESS($$MYLIST)
 Q
 ; The work list for this routine is maintained in
 ;  ^ABSPECP("ABSPOSR1",TIME,ACTION,RXI,RXR)
 ;   ACTION=1 for claims, ACTION=2 for reversals
 ;
MYLIST() Q "^ABSPECP("""_$T(+0)_""")"
KMYLIST K ^ABSPECP($T(+0)) Q
SEELIST(TIME,ENDTIME)       ;
 I '$D(TIME) S TIME=T1,ENDTIME=T2
 W "Probing for time range ",TIME," through ",ENDTIME,"...",!
 K TMP D WORKLIST(TIME,ENDTIME,"TMP")
 N Q,I S Q="TMP" F I=0:1 S Q=$Q(@Q) Q:Q=""  D
 . I I<10 W Q,!
 . I I=10 W "...and more... ZW TMP to see them all",!
 W "Total = ",I," entr",$S(I=1:"y",1:"ies")
 Q
NEXT(N) ; advances T1,T2 ; come in with T1,T2 already set
 S T1=$P(^ABSP(9002313.99,"ABSPOSR1"),U)
 S T2=$$T2("AL",T1,N)
 D SEELIST(T1,T2) W !
 D ZWRITE^ABSPOS("T1","T2")
 Q
T2(INDEX,T1,N) ;  sets T2 to include N transactions from given T1
 ; may be more than N if there are several at the exact same time
 N T S T=T1
 F  D  Q:N<1  Q:T=""
 . S A=""
 . F  S A=$O(^PSRX(INDEX,T,A)) Q:A=""  D  Q:N<1
 . . S B=""
 . . F  S B=$O(^PSRX(INDEX,T,A,B)) Q:B=""  D
 . . . S N=N-1
 . I N>0 S T=$O(^PSRX("AL",T))
 S T2=T
 Q:$Q T2 Q
WORKLIST(TIME,ENDTIME,LISTROOT) ; EP - from ABSPOSR4
 ; callable from outside:
 ; given TIME = starting time to examine
 ; given ENDTIME="" to go through end, else ending date.time
 ; Be careful to process them in order!
 I $$GETFIELD(120.07)="" D DEFAULTS^ABSPOSR1
 N CLAIM,CANCEL S CLAIM=$$GETFIELD(120.06),CANCEL=$$GETFIELD(120.07)
 N INDEX F INDEX=CLAIM,CANCEL D
 . N T S T=TIME
 . F  D  Q:T=""  I ENDTIME,T>ENDTIME Q
 . . N RXI,RXR
 . . S RXI="" F  S RXI=$O(^PSRX(INDEX,T,RXI)) Q:RXI=""  D
 . . . S RXR="" F  S RXR=$O(^PSRX(INDEX,T,RXI,RXR)) Q:RXR=""  D
 . . . . D WORK1
 . . S T=$O(^PSRX(INDEX,T)) ; then get the next time
 Q
WORK1 ; we have LISTROOT,CLAIM,CANCEL,INDEX,T,RXI,RXR
 ; put it on the work list
 S @LISTROOT@(T,$S(INDEX=CLAIM:1,INDEX=CANCEL:2),RXI,RXR)=""
 Q
PROCESS(WORKLIST)  ; EP - from ABSPOSR4
 ; where WORKLIST was constructed by the paragraph, above
 N TIME,TYPE,RXI,RXR
 S TIME="" F  S TIME=$O(@WORKLIST@(TIME)) Q:'TIME  D
 . F TYPE=1,2 D
 . . S RXI="" F  S RXI=$O(@WORKLIST@(TIME,TYPE,RXI)) Q:RXI=""  D
 . . . S RXR="" F  S RXR=$O(@WORKLIST@(TIME,TYPE,RXI,RXR)) Q:RXR=""  D
 . . . . D PROC1
 Q
TURNEDON() Q 1
PROC1 ; given WORKLIST,TIME,TYPE,RXI,RXR
 ; MSG for logging: set to null if you don't want a message
 ; (we'll probably change a lot of these to "" as we gain confidence)
 N X,MSG,KILL S MSG=RXI_","_RXR
 I TYPE=1 D  ; new claim
 . S MOREDATA("ORIGIN")=6
 . S MOREDATA("DO NOT RESUBMIT")=1
 . I $$TURNEDON F  D  Q:X  Q:'$$IMPOSS^ABSPOSUE("P","RIT","$$CLAIM^ABSPOSRX failed",,,$T(+0))
 . . S X=$$CLAIM^ABSPOSRX(RXI,RXR,.MOREDATA)
 . . Q:X  ; success
 . . D LOG("Unexpected failure of CLAIM^ABSPOSRX")
 . . D LOG("X="_X_",RXI="_RXI_",RXR="_RXR)
 . . S X=0
 . E  D
 . . D LOG("Testing - skipping $$CLAIM^ABSPOSRX("_RXI_","_RXR_",.MOREDATA)")
 . S KILL=1
 E  I TYPE=2 D  ; reversal
 . I $$TURNEDON F  D  Q:X  Q:'$$IMPOSS^ABSPOSUE("P","RIT","$$UNCLAIM^ABSPOSRX failed",,,$T(+0))
 . . S X=$$UNCLAIM^ABSPOSRX(RXI,RXR) Q:X  ; success
 . . D LOG("Unexpected failure of CLAIM^ABSPOSRX")
 . E  D
 . . D LOG("Testing - skipping $$UNCLAIM^ABSPOSRX("_RXI_","_RXR_")")
 . . S X=1
 . S KILL=1
 E  D IMPOSS^ABSPOSUE("P","RIT","TYPE="_TYPE,"at bottom of loop",,$T(+0))
 I KILL D
 . K @WORKLIST@(TIME,TYPE,RXI,RXR)
 Q
LASTUP(RXI,RXR)    Q $$LASTUP59^ABSPOSRX(RXI,RXR)
