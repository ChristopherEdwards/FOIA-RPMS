BARDMAN2 ; IHS/SD/LSL - A/R Debt Collection Process (2) ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/08/2004 - V1.8
 ;      Routine created.  Moved (modified) from BBMDC2
 ;      Callable entry points from BARDMAN that will find bills
 ;      needing to be sent to Transworld for Stop/Start Collection.
 ;      This routine calls one of four entry points to BARDMAN3 that
 ;      build a temporary global of the necessary data.
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
 ;
 ; Verify the following 2 entries exist in ZISH SEND PARAMETERS file or
 ; the creation and sending of files won't work.
 ;
 ; 1.  BAR DCM F     (foreground)
 ; 2.  BAR DCM B     (background or queued)
 ;
 ; ********************************************************************
 Q
 ;
FINDSTOP ; EP
 ; Loop log and create stops for bills with a changed balance in this DUZ(2)
 ; code of 1 - bill is adjusted to 0 - stop collection service
 ; code of 5 = bill is paid in full - stop collection service
 ; code of A = an adjustment has been made to the previous service
 S BARSYMB=0
 S BARTCNT=0
 S BARL=0
 S BARSSELF=0                        ; Initialize self pay stop counter
 S BARSINS=0                         ; Initialize insurer stop counter
 ;
 ; Loop Active log entries
 F  S BARL=$O(^BARDEBT("AD",1,BARL)) Q:'+BARL  D ACTLOG
 S ^TMP($J,"BAR-STOPS-CNT")=BARTCNT
 Q
 ; ********************************************************************
 ;
ACTLOG ;
 ; For each active log entry do the following...
 S BARSYMB=BARSYMB+1
 S:BARSYMB>10 BARSYMB=1
 W:'$D(BARQUIET) $C(32+BARSYMB),$C(8)
 Q:($P($G(^BARDEBT(BARL,0)),U,8)'=DUZ(2))    ; log entry not this fac
 Q:($P($G(^BARDEBT(BARL,0)),U,2)="")         ; No bill # this log ent
 S BARLDT=$P($G(^BARDEBT(BARL,0)),U)           ; Log date
 S X1=DT
 S X2=-160                   ; Changed from 100 per Sandra Lahi 4/13/04
 D C^%DTC
 S BARCHKDT=X
 ;
 ; Log entry 100 days old, mark inactive, don't send stop
 I +BARLDT,BARLDT<BARCHKDT D INACTREC Q
 S BARLBAL=$P($G(^BARDEBT(BARL,0)),U,3)      ; Bill Balance on log
 S BARBL=$P(^BARDEBT(BARL,0),U,2)            ; IEN A/R Bill File
 S BARBAL=$P($G(^BARBL(DUZ(2),BARBL,0)),U,15)  ; Bill Bal AR bill
 Q:+BARLBAL=+BARBAL                          ; Balances same, no stop
 I BARBAL>0 S BARACT="A"
 E  S BARACT=$$GETTX(BARBL)
 S BARBLNM=$$GET1^DIQ(90050.01,BARBL,.01)
 S BARBLNM=$TR(BARBLNM,"-","")            ; Don;t send - in bill name
 S:BARBAL<0 BARBAL=0                      ; Don't send negative
 S BARX=$P(BARBAL,".")_"."_$P(BARBAL,".",2)_"00"
 S BARBAL=$P(BARX,".")_$E($P(BARX,".",2),1,2)
 I $P($G(^BARDEBT(BARL,0)),U,6)="S",$L(BARSNUM) D  Q
 . D SSELFILE^BARDMAN3                    ; Build self pay stops global
 . S BARTCNT=BARTCNT+1
 I $P($G(^BARDEBT(BARL,0)),U,6)="I",$L(BARINUM) D  Q
 . D SINSFILE^BARDMAN3                    ; Build insurer stops global
 . S BARTCNT=BARTCNT+1
 Q
 ; ********************************************************************
 ;
INACTREC ;
 K DIE,DA,DR
 S DIE="^BARDEBT("
 S DA=BARL
 S DR=".05////^S X=0"
 D ^DIE
 Q
 ; ********************************************************************
 ;
GETTX(BARBL) ; EP
 ;
 ;** this function is only called if the current balance is 0
 ;** find last transaction - determine if it is a payment
 ; if last tx is a payment, pass the action code 5 (paid in full)
 ; if last tx is an adj., pass the action code 1 (cancel)
 ;
 N BARPMT
 S BARTR=$O(^BARTR(DUZ(2),"AC",BARBL,""),-1)
 I '+BARTR Q 1
 S BARPMT=$$GET1^DIQ(90050.03,BARTR,3.6)
 Q $S(+BARPMT:5,1:1)
 ; ********************************************************************
 ; ********************************************************************
 ;
FINDSTRT ; EP
 ; search A/R Bill file for this DUZ(2) for matches to extract to data file
 S X1=DT
 S X2=-365
 D C^%DTC
 S BARYRCHK=X                                ; Date 1 yr ago
 S BARTCNT=0
 S BARSYMB=0
 S BARTSELF=0                       ; Initialize self pay start counter
 S BARTSINS=0                        ; Initialize insurer start counter
 S BARIRCHD=0                        ; Max ins transaction reached
 S BARSRCHD=0                        ; Max self pay transaction reached
 S BARDT=BARSTART-.5
 S BAREND=BAREND_".9999999"
 ;
 ; Loop 3P Approval Date x-ref of AR bill for approval dates within
 ; selected range.
 F  S BARDT=$O(^BARBL(DUZ(2),"AG",BARDT)) Q:'+BARDT!(BARDT>BAREND)  D LOOP
 S ^TMP($J,"BAR-STARTS-CNT")=BARTCNT
 Q
 ; ********************************************************************
 ;
LOOP ;
 ; For each valid 3P approval date do...
 S BARBL=0
 F  S BARBL=$O(^BARBL(DUZ(2),"AG",BARDT,BARBL)) Q:'+BARBL  D BILL
 Q
 ; ********************************************************************
 ;
BILL ;
 S BARSYMB=BARSYMB+1
 S:BARSYMB>10 BARSYMB=1
 W:'$D(BARQUIET) $C(32+BARSYMB),$C(8)
 ;
 ; Check balance on greater than limit
 S BARBAL=$$GET1^DIQ(90050.01,BARBL,15)
 Q:(BARBAL<BARAMT)
 ;
 ; Check DOS after earliest DOS allowed
 S BARDOS=$$GET1^DIQ(90050.01,BARBL,102,"I")   ; DOS Begin of AR bill
 I $G(BAREDOS),BARDOS<BAREDOS Q
 ;
 ; Check A/R Bill already sent for collection
 S BARL=$O(^BARDEBT("C",BARBL,0))
 I +BARL D  Q:(BARLOC=DUZ(2))                ; AR bill IEN in log
 . S BARLOC=$P($G(^BARDEBT(BARL,0)),U,8)
 ;
 ; Check to see if A/R Account on bill is restricted
 S BARAC=$$GET1^DIQ(90050.01,BARBL,"3","I")
 Q:'+BARAC                                   ; No AR Account on bill
 S BARACTP=$$GET1^DIQ(90050.02,BARAC,1)
 K BARNOGO
 I BARACTP=9999999.18 D  Q:$D(BARNOGO)
 . I $D(^BAR(90052.06,DUZ(2),DUZ(2),13,"B",BARAC)) D
 . . S BAR13IEN=$O(^BAR(90052.06,DUZ(2),DUZ(2),13,"B",BARAC,""))
 . . S BARESTRT=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),13,BAR13IEN,0)),U,2)
 . . S:BARESTRT=1 BARNOGO=1
 . I (BARICUR>BARIMAX!(BARICUR=BARIMAX)) S BARNOGO=1
 S BARCAT=""
 ;
 ; Check if AR Account, TSI Account Number
 I BARACTP=9999999.18,$L(BARINUM) S BARCAT="I"
 ;
 ; Check if Self Pay, age less 1 yr, TSI Self Pay Number
 I BARACTP=9000001 D
 . Q:BARSNUM=""
 . Q:BARSCUR>BARSMAX
 . Q:BARSCUR=BARSMAX
 . Q:(BARDT<BARYRCHK)
 . S BARCAT="S"
 Q:BARCAT=""
 S BARBLNMD=$$GET1^DIQ(90050.01,BARBL,.01)   ;bill number - w/dashes
 S BARBLNM=$TR(BARBLNMD,"-","")          ;bill number - strip dashes
 S BARX=$P(BARBAL,".")_"."_$P(BARBAL,".",2)_"00"
 S BARBAL=$P(BARX,".")_$E($P(BARX,".",2),1,2)
 I BARCAT="I" D  Q:+BARIRCHD
 . S BARICUR=BARICUR+1
 . I BARICUR>BARIMAX S BARIRCHD=BARICUR Q
 . D TINSFILE^BARDMAN3        ; Build Insurer Starts global
 I BARCAT="S" D  Q:+BARSRCHD
 . S BARSCUR=BARSCUR+1
 . I BARSCUR>BARSMAX S BARSRCHD=BARSCUR Q
 . D TSELFILE^BARDMAN3        ; Build Self Pay Starts global
 S BARTCNT=BARTCNT+1
 Q
 ; ********************************************************************
 ;
SEND ; EP
 ; Using XBGSAVE, create local files from the 4 globals and send them
 ; to the ITSC Server.
 D NOW^%DTC
 S BARTM=$E($P(%,".",2),1,4)
 S BARJDT=$$JDT^XBFUNC(DT)
 ;
 I $D(^BARSSELF) D
 . S (XBFN,BARSSFN)="bar-stop-self-"_BARSNUM_"-"_BARTM_"-"_BARJDT_".dat"
 . S XBGL="BARSSELF("
 . D SENDFILE
 . I XBFLG=0 D
 . .  W:'$D(BARQUIET) !!,"File ",BARSSFN," sent. Updating LOG with Self Pay Stops"
 . . D LOGSSELF^BARDMAN4
 . I +XBFLG,'$D(BARQUIET) D
 . . W !!,"Creation/Send of file ",BARSSFN," was unsuccessful."
 . . W !,XBFLG(1)
 . D:$D(BARQUIET) PAZ^BARRUTL
 ;
 I $D(^BARSTOPS) D
 . S (XBFN,BARSIFN)="bar-stop-ins-"_BARINUM_"-"_BARTM_"-"_BARJDT_".dat"
 . S XBGL="BARSTOPS("
 . D SENDFILE
 . I XBFLG=0 D
 . . W:'$D(BARQUIET) !!,"File ",BARSIFN," sent.  Updating LOG with Insurer Stops"
 . . D LOGSTOP^BARDMAN4
 . I +XBFLG,'$D(BARQUIET) D
 . . W !!,"Creation/Send of file ",BARSIFN," was unsuccessful."
 . . W !,XBFLG(1)
 . D:'$D(BARQUIET) PAZ^BARRUTL
 ;
 I $D(^BARTSELF) D
 . S (XBFN,BARTSFN)="bar-start-self-"_BARSNUM_"-"_BARTM_"-"_BARJDT_".dat"
 . S XBGL="BARTSELF("
 . D SENDFILE
 . I XBFLG=0 D
 . . W:'$D(BARQUIET) !!,"File ",BARTSFN," sent.  Updating LOG with Self Pay Starts"
 . . D LOGTSELF^BARDMAN4
 . I +XBFLG,'$D(BARQUIET) D
 . . W !!,"Creation/Send of file ",BARTSFN," was unsuccessful."
 . . W !,XBFLG(1)
 . D:'$D(BARQUIET) PAZ^BARRUTL
 ;
 I $D(^BARSTART) D
 . S (XBFN,BARTIFN)="bar-start-ins-"_BARINUM_"-"_BARTM_"-"_BARJDT_".dat"
 . S XBGL="BARSTART("
 . D SENDFILE
 . I XBFLG=0 D
 . . W:'$D(BARQUIET) !!,"File ",BARTIFN," sent.  Updating LOG with Insurer Starts"
 . . D LOGSTART^BARDMAN4
 . I +XBFLG,'$D(BARQUIET) D
 . . W !!,"Creation/Send of file ",BARTIFN," was unsuccessful."
 . . W !,XBFLG(1)
 . D:'$D(BARQUIET) PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
SENDFILE ; EP
 ; Create self pay stops and send file to ITSC Server
 S XBQSHO=""
 S XBF=$J                       ; Beginning 1st level numeric subscript
 S XBE=$J                       ; Ending 1st level numeric subscript
 S XBFLT=1                      ; indicates flat file
 S XBMED="F"                    ; Flag indicates file as media
 S XBCON=1                      ; Q if non-cononic
 S XBS1="BAR DCM F"             ; ZISH SEND PARAMETERS entry
 I $D(ZTQUEUED) S XBS1="BAR DCM B"
 S XBQ="N"
 ;S BARITSC=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),10)),U,9,11)
 S XBUF=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),10)),U,7)         ; Local directory for file creation
 ;S BARUNAM=$P(BARITSC,U,2)      ; Username of system receiving file
 ;S BARUPASS=$P(BARITSC,U,3)     ; Password of system receiving file
 ;S XBQTO=$P(BARITSC,U)          ; System id to receive file
 ; Include username and password in system id
 ;S XBQTO="-l """_BARUNAM_":"_BARUPASS_""" "_XBQTO
 ;I XBUF=""!(BARUNAM="")!(BARUPASS="")!(XBQTO="") D  Q
 I XBUF="" D  Q
 . S XBFLG=-1
 . S XBFLG(1)="Missing local directory. Please check Debt Collection Parameters"
 I IO=IO(0) W !!
 D ^XBGSAVE
 Q
