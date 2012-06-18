ABSPOS6I ; IHS/FCS/DRS - Data Entry & Status Disp ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; ALL writes of screen lines as follows:
 ;  IF $$VISIBLE(line) DO WRITE^VALM10(line)
 ; When approp., set NODISPLY=true and $$VISIBLE returns false
 Q
 ; DISPDBG:  are we debugging the display?
DISPDBG() Q $P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U)
DISPHIST(MSG,HANG) ; DEBUGGING - to record history and pause
 Q:'$$DISPDBG
 I '$D(HANG) S HANG=1
 D DISPHIST^ABSPOS6H(MSG,HANG)
 Q
UPDATE(COUNTER)       ;EP - from ABSPOS6A 
 ; with COUNTER = a count down, -1 for indefinite repeat
 N CHGCOUNT S CHGCOUNT=0
 N STOP F  D  Q:$G(STOP)
 .D UPD1
 .S COUNTER=COUNTER-1 I 'COUNTER S STOP=1 Q
 .I '$G(NODISPLY) D
 ..D MSG^VALM10("In continuous update mode: press Q to Quit")
 ..N X ;R X#1:^TMP("ABSPOS",$J,"FREQ") D MSG^VALM10(" ")
 ..;Try doing this single-character read with ^XGKB
 ..;I $D(^TMP("XGKEY",$J)) ; possible interference
 ..S X=$$READ^XGKB(1,^TMP("ABSPOS",$J,"FREQ"))
 ..;I X]"","Qq^^"[X S STOP=1
 ..I '$G(DTOUT),X]"","Qq^^"[X S STOP=1
 ..N Y F  R Y:0 Q:'$T  ; clean out typeahead (like mistaken arrow keys)
 Q
UPD1 ; one update cycle
 N NOW,PAT,RXI,T,CHG,LAST,OLDEST,ONEPAT D
 .N %,%H,%I,X D NOW^%DTC S NOW=%
 S ONEPAT=^TMP("ABSPOS",$J,"PATIENT")
 I ONEPAT D
 .S T=^TMP("ABSPOS",$J,"PATIENT TIME")
 .S CHG=$$SORT^ABSPOSUA(0,ONEPAT,T,1)
 E  D
 .S T=^TMP("ABSPOS",$J,"LAST UPDATE") ; absolute time on 2nd & subseq
 .I T="" S T=^TMP("ABSPOS",$J,"TIME") ; delta time on 1st call
 .S ^TMP("ABSPOS",$J,"LAST UPDATE")=NOW ; remember the time you did this
 .S CHG=$$SORT^ABSPOSUA(^TMP("ABSPOS",$J,"USER"),,T) ; get changes
 S OLDEST=$$TADD^ABSPOSUD(NOW,-^TMP("ABSPOS",$J,"TIME"))
 ;
 ; Deal with dismissals
 ;
 S PAT="" F  S PAT=$O(@DISMISS@(PAT)) Q:PAT=""  D
 .I PAT'?1"*".E,'ONEPAT Q
 .I @DISMISS@(PAT)<OLDEST K @DISMISS@(PAT) Q  ; dismissal order expired
 .I '$D(@CHG@(PAT)) Q  ; no changes for this patient
 .S RXI="" F  S RXI=$O(@DISMISS@(PAT,RXI)) Q:RXI=""  D
 ..I @DISMISS@(PAT,RXI)<OLDEST K @DISMISS@(PAT,RXI) Q  ; order expired
 ..I $D(@CHG@(PAT,RXI)) D  ; a change has occurred in a dismissed RX
 ...K @CHG@(PAT,RXI) ; so ignore the change
 ...I $O(@CHG@(PAT,""))="" K @CHG@(PAT) ; and maybe patient is empty
 S CHGCOUNT=$G(CHGCOUNT)+1
 I $$DISPDBG D
 . D DISPHIST("CHGCOUNT="_CHGCOUNT_" computed with T="_T)
 . K ^TMP("ABSPOS",$J,"CHG",CHGCOUNT)
 . M ^TMP("ABSPOS",$J,"CHG",CHGCOUNT)=@CHG
 ; And you have DISP,DISPLINE,DISPIDX already set up from caller
 ;
 ; Now deal with any surviving changes
 ;
 S PAT="" F  S PAT=$O(@CHG@(PAT)) Q:PAT=""  D UPDPAT
 ;
 ; And finally, weed out any which haven't seen any changes
 ; in the last ^TMP("ABSPOS",$J,"TIME") time
 ;
 I 'ONEPAT S PAT="" F  S PAT=$O(@DISP@(PAT)) Q:PAT=""  D
 .S X=@DISP@(PAT),LAST=$P(X,U,3) ; last update for this patient
 .I LAST<OLDEST,$P(X,U,4)*100=$P(X,U,2) D  ; old & complete
 ..D DISPHIST("Deleting "_PAT_" "_LAST_"<"_OLDEST)
 ..N NLINES S NLINES=$P(X,U,4)+1 ; how many line this one occupies
 ..D SHIFTUP($P(X,U)+NLINES,$P(X,U)) ; 
 ..K @DISP@(PAT)
 Q
UPDPAT ; Update for a given @CHG@(PAT)
 ;I $P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U,2) S $ZT="ERR^ZU"
 N NEWPAT,RXI,I
 N PATCHG S PATCHG=0 ; "patient changed", set to 1 if so
 D DISPHIST("UPDPAT for PAT="_PAT,0)
 ;
 I $D(@DISP@(PAT)) S NEWPAT=0 G UPD2 ; nope, we already have them
 ;
 D DISPHIST("New patient not yet on our list",0)
 S (NEWPAT,PATCHG)=1 ; set "new patient" flag
 N NPRESC S NPRESC=@CHG@(PAT) ; how many prescriptions
 N NLINES S NLINES=NPRESC+1 ; plus one more line for the patient
 I VALMCNT+NLINES>^TMP("ABSPOS",$J,"MAX LINES") Q  ; overflow
 N PATNEXT S PATNEXT=$O(@DISP@(PAT))
 I PATNEXT="" D  ; the new patient and prescriptions go at end
 .S LINE=@DISPLINE+1 ; this is the new line number
 .S (VALMCNT,@DISPLINE)=@DISPLINE+NLINES ; update count of total lines
 .D DISPHIST("Goes at end, on line #"_LINE,0)
 E  D  ; the new patient pushes the next one downward
 .D DISPHIST("Pushes existing ones at line "_LINE_" down "_NLINES,1)
 .S LINE=$P(@DISP@(PATNEXT),U)
 .D SHIFTDN(LINE,NLINES)
 ;
 ; common handling for new patient, whether at end or not
 ;
 S @DISP@(PAT)=LINE_U_U_U_NPRESC
 S @DISPLINE@(LINE)=PAT_U ; remember who's stored here
 ;
 ; Init for each prescription that came with this new patient
 ;
 S RXI="" ; should always get @CHG@(PAT) iterations, right?
 F I=1:1:@CHG@(PAT) S RXI=$O(@CHG@(PAT,"RXI",RXI)) Q:RXI=""  D
 .S @DISP@(PAT,RXI)=(LINE+I)_U_U
 .S @DISPLINE@(LINE+I)=PAT_U_RXI
 ;
 ; and fall through to treat the rest of it same as existing patient
 G UPD3
UPD2 ;
 ; Patient was already in our list, but maybe there are
 ; new prescriptions for which we must make room
 ;
 S RXI="" F I=1:1:@CHG@(PAT) S RXI=$O(@CHG@(PAT,"RXI",RXI)) D
 .Q:$D(@DISP@(PAT,RXI))  ; prescription already has a spot
 .I VALMCNT+1>^TMP("ABSPOS",$J,"MAX LINES") Q  ; overflow
 .N I ; protect index
 .D DISPHIST("New prescription "_RXI_" for "_PAT,0)
 .;
 .; a new prescription for the already-existent patient
 .; assign a line for it and shift everything else down
 .;
 .S PATCHG=1 ; flag: "patient info has changed"
 .N ADDATEND
 .N RXINEXT S RXINEXT=$O(@DISP@(PAT,RXI))
 .I RXINEXT S LINE=$P(@DISP@(PAT,RXINEXT),U),ADDATEND=0
 .E  D  ; prescription comes at end of this patient's stuff
 ..N PATNEXT S PATNEXT=$O(@DISP@(PAT))
 ..I PATNEXT="" S ADDATEND=1
 ..E  S LINE=$P(@DISP@(PATNEXT),U),ADDATEND=0
 .I ADDATEND D  ; adding at end, nothing needs to be shifted down
 ..S LINE=@DISPLINE+1,(VALMCNT,@DISPLINE)=@DISPLINE+1
 .E  D  ; adding in the middle or beginning; need to shift down
 ..D SHIFTDN(LINE,1)
 .;
 .; no matter where we added the new prescription, do the following:
 .;
 .S @DISP@(PAT,RXI)=LINE_U_U
 .S @DISPLINE@(LINE)=PAT_U_RXI ; 02/02/2000
 .S $P(@DISP@(PAT),U,4)=$P(@DISP@(PAT),U,4)+1
 ;
UPD3 ; this patient is already in our list (maybe having just been added)
 ; The patient and all of his prescriptions have display space
 ; Now we can deal with the actual changes (date-time of change,status)
 ;I $P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U,2) S $ZT="ERR^ZU"
 S RXI="" F I=1:1:@CHG@(PAT) D
 .;K ^ABSTMP("ABSPOS SAVE",$J) M ^ABSTMP("ABSPOS SAVE",$J)=^TMP("ABSPOS",$J) ; TEMPORARY TEMPORARY TEMPORARY
 .S RXI=$O(@CHG@(PAT,"RXI",RXI)) ; next changed prescription
 .N X S X=@CHG@(PAT,"RXI",RXI) ; status^dateTimeof last change
 .;D DISPHIST("UPD3:"_PAT_" "_RXI_":"_X)
 .I '$D(@DISP@(PAT,RXI)) D LOGERR^ABSPOS6F("UPD3^ABSPOS") ; 01/27/2000
 .I X=$P(@DISP@(PAT,RXI),U,2,3) D  Q  ; we saw this last time around
 ..D DISPHIST("UPD3: already processed this one, so quit early")
UPD4 .N S,D S S=$P(X,U),D=$P(X,U,2)
 .; NO! I D>^TMP("ABSPOS",$J,"LAST UPDATE") S ^("LAST UPDATE")=D
 .;D DISPHIST("UPD3: reset LAST UPDATE to "_D)
 .N L S L=$P(@DISP@(PAT,RXI),U) ; line #
UPD5 .I S=100,$P(@DISP@(PAT,RXI),U,2)'=100 D  ; marking as complete
 ..N B S B=$$BUCKET^ABSPOS6B(RXI)
 ..; NO! S $P(@DISP@(PAT),U,4)=$P(@DISP@(PAT),U,4)+1
 ..S $P(@DISP@(PAT),U,B)=$P(@DISP@(PAT),U,B)+1
 .S @DISP@(PAT,RXI)=L_U_S_U_D ; line^status^dateTime of change
 .;D DISPHIST("UPD3: PAT REC BEFORE:"_@DISP@(PAT))
UPD6 .I D>$P(@DISP@(PAT),U,3) S $P(@DISP@(PAT),U,3)=D,PATCHG=1
 .;D DISPHIST("UPD3: PAT REC AFTER:"_@DISP@(PAT))
 .D SETLINE^ABSPOS6H(L,PAT,RXI) ; update list manager data and disp. if visible
 ;
UPD7 ; Sum the total of the statuses - used for computing %done
 N TOTSTAT S TOTSTAT=0
 S RXI="" F I=1:1:$P(@DISP@(PAT),U,4) D
 .S RXI=$O(@DISP@(PAT,RXI))
 .S TOTSTAT=TOTSTAT+$P(@DISP@(PAT,RXI),U,2)
 I TOTSTAT'=$P(@DISP@(PAT),U,2) S PATCHG=1 ; total of statuses changed
 S $P(@DISP@(PAT),U,2)=TOTSTAT
 D DISPHIST("After summing:"_@DISP@(PAT))
 ;
 ; If the patient data changed, update the list manager data and
 ; if the line is visible, update the display, too
 ;
 I PATCHG D SETLINE^ABSPOS6H($P(@DISP@(PAT),U),PAT)
 Q
VISIBLE(LINE)      ;EP - from ABSPOS6H -  is LINE number visible?
 ; HARDCODED!!!  list region is from line 6 to line 18
 ; ASSUMPTION!!  VALMBG is the first line number displayed
 ; so lines VALMBG through VALMBG+(18-6) are visitble
 I $G(NODISPLY) Q 0
 I '$G(VALMBG) Q 0
 I LINE<VALMBG Q 0
 I LINE>(VALMBG+(18-6)) Q 0
 Q 1
SHIFTDN(LINE,NLINES)         ; as in when something is inserted
 D DISPHIST("SHIFTDN(LINE,NLINES) for "_LINE_","_NLINES)
 F I=VALMCNT:-1:LINE D
 .D MOVELINE(I,I+NLINES)
 S (@DISPLINE,VALMCNT)=VALMCNT+NLINES
 Q
MOVELINE(FROM,TO,CLR)  ;
 D DISPHIST("Move line "_FROM_" to "_TO_";visible="_$$VISIBLE(TO)_","_$$VISIBLE(FROM))
 D DISPHIST("VALMAR="_VALMAR)
 M @DISPHIST@(@DISPHIST,"VALMAR")=@VALMAR
 ;I $P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U,2) S $ZT="ERR^ZU"
 I '$D(@DISPLINE@(FROM)) D LOGERR^ABSPOS6F("MOVELINE^ABSPOS") ;01/27/2000
 N PAT,RXI,X S X=@DISPLINE@(FROM),PAT=$P(X,U),RXI=$P(X,U,2)
 I $G(RXI) S $P(@DISP@(PAT,RXI),U)=TO
 E  S $P(@DISP@(PAT),U)=TO
 S @DISPLINE@(TO)=@DISPLINE@(FROM)
 D SET^VALM10(TO,@VALMAR@(FROM,0),TO) ; set destination = new contents
 D FLDTEXT^VALM10(TO,"LINE NUMBER",$J(TO,2)) ; fix line number in dest
 I $$VISIBLE(TO) D WRITE^VALM10(TO) ; if any visible, write them 
 I $G(CLR) D CLRLINE(FROM)
 D DISPHIST("Move line "_FROM_" to "_TO_" complete")
 Q
CLRLINE(N) ; clear out line N
 D DISPHIST("Clearing line "_N_", $$VISIBLE(N)="_$$VISIBLE(N))
 D SET^VALM10(N," ") ; clear contents of source line
 I $$VISIBLE(N) D WRITE^VALM10(N)
 S @DISPLINE@(N)="DELETED "_@DISPLINE@(N)
 K @VALMAR@("IDX",N)
 Q
SHIFTUP(FROM,TO)   ; move upward from SRC to DST, all the way to end
 D DISPHIST("SHIFTUP(FROM,TO) for "_FROM_","_TO)
 I FROM'>TO D  Q
 . D IMPOSS^ABSPOSUE("P","TI","bad params FROM="_FROM_",TO="_TO,,"SHIFTUP",$T(+0))
 N NLINES S NLINES=FROM-TO
 F  Q:FROM>VALMCNT  D
 .D MOVELINE(FROM,TO,0)
 .S FROM=FROM+1,TO=TO+1
 F  D CLRLINE(TO) Q:TO=VALMCNT  S TO=TO+1
 S (VALMCNT,@DISPLINE)=VALMCNT-NLINES
 Q
