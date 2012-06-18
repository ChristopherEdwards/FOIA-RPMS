HLCSTCP1 ;SFIRMFO/RSD - BI-DIRECTIONAL TCP ;09/13/2006
 ;;1.6;HEALTH LEVEL SEVEN;**19,43,57,64,71,133**;JUL 17,1995;Build 13
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;Receiver
 ;connection is initiated by sender and listener accepts connection
 ;and calls this routine
 ;
 N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSTCP1"
 N HLMIEN,HLASTMSG
 D MON^HLCSTCP("Open")
 K ^TMP("HLCSTCP",$J,0)
 S HLMIEN=0,HLASTMSG=""
 F  D  Q:$$STOP^HLCSTCP  I 'HLMIEN D MON^HLCSTCP("Idle") H 3
 . S HLMIEN=$$READ
 . Q:'HLMIEN
 . D PROCESS
 Q
 ;
PROCESS ;check message and reply
 ;HLDP=LL in 870, update monitor, received msg.
 N HLTCP,HLTCPI,HLTCPO
 S HLTCP="",HLTCPO=HLDP,HLTCPI=+HLMIEN
 ;update monitor, msg. received
 D LLCNT^HLCSTCP(HLDP,1)
 D NEW^HLTP3(HLMIEN)
 ;update monitor, msg. processed
 D LLCNT^HLCSTCP(HLDP,2)
 Q
 ;
READ() ;read 1 message, returns ien in 773^ien in 772 for message
 D MON^HLCSTCP("Reading")
 N HLDB,HLDT,HLDEND,HLACKWT,HLDSTRT,HLHDR,HLIND1,HLINE,HLMSG,HLRDOUT,HLRS,HLX,X
 ;HLDSTRT=start char., HLDEND=end char., HLRS=record seperator
 S HLDSTRT=$C(11),HLDEND=$C(28),HLRS=$C(13)
 ;HLRDOUT=exit read loop, HLINE=line count, HLIND1=ien 773^ien 772
 ;HLHDR=have a header, ^TMP(...)=excess from last read, HLACKWT=wait for ack
 S (HLRDOUT,HLINE,HLIND1,HLHDR)=0,HLX=$G(^TMP("HLCSTCP",$J,0)),HLACKWT=HLDBACK
 K ^TMP("HLCSTCP",$J,0)
 F  D RDBLK Q:HLRDOUT
 ;save any excess for next time
 S:$L(HLX) ^TMP("HLCSTCP",$J,0)=HLX
 I +HLIND1,'$P(HLIND1,U,3) D DELMSG(HLIND1) S HLIND1=0
 Q HLIND1
 ;
RDBLK S HLDB=HLDBSIZE-$L(HLX)
 U IO R X#HLDB:HLDREAD
 ;switch to null device if opened to prevent 'leakage'
 I $G(IO(0))'="",$G(IO(0))'=IO U IO(0)
 ; timedout, check ack timeout, clean up
 I '$T,X="",HLX="" S HLACKWT=HLACKWT-HLDREAD D:HLACKWT<0&'HLHDR CLEAN Q
 ;data stream: <sb>dddd<cr><eb><cr>
 ;add incoming line to what wasn't processed in last read
 S HLX=$G(HLX)_X
 ; look for segment= <CR>
 F  Q:HLX'[HLRS  D  Q:HLRDOUT
 . ; Get the first piece, save the rest of the line
 . S HLINE=HLINE+1,HLMSG(HLINE,0)=$P(HLX,HLRS),HLX=$P(HLX,HLRS,2,999)
 . ; check for start block, Quit if no ien
 . I HLMSG(HLINE,0)[HLDSTRT!HLHDR D  Q
 .. D:HLMSG(HLINE,0)[HLDSTRT
 ... S X=$L(HLMSG(HLINE,0),HLDSTRT)
 ... S:X>2 HLMSG(HLINE,0)=HLDSTRT_$P(HLMSG(HLINE,0),HLDSTRT,X)
 ... S HLMSG(HLINE,0)=$P(HLMSG(HLINE,0),HLDSTRT,2)
 ... D RESET:(HLINE>1)
 .. ;ping message
 .. I $E(HLMSG(1,0),1,9)="MSH^PING^" D PING Q
 .. ; get next ien to store
 .. D MIEN
 .. K HLMSG
 .. S (HLINE,HLHDR)=0
 . ; check for end block; HLMSG(HLINE) = <eb><cr>
 . I HLMSG(HLINE,0)[HLDEND D
 .. ;no msg. ien
 .. Q:'HLIND1
 .. ; Kill just the last line
 .. K HLMSG(HLINE,0) S HLINE=HLINE-1
 .. ; move into 772
 .. D SAVE(.HLMSG,"^HL(772,"_+$P(HLIND1,U,2)_",""IN"")")
 .. ;mark that end block has been received
 .. ;HLIND1=ien in 773^ien in 772^1 if end block was received
 .. S $P(HLIND1,U,3)=1
 .. ;reset variables for next message
 .. D CLEAN
 . ;add blank line for carriage return
 . I HLINE'=0,HLMSG(HLINE,0)]"" S HLINE=HLINE+1,HLMSG(HLINE,0)=""
 Q:HLRDOUT
 ;If the line is long and no <CR> move it into the array. 
 I ($L(HLX)=HLDBSIZE),(HLX'[HLRS),(HLX'[HLDEND),(HLX'[HLDSTRT) D  Q
 . S HLINE=HLINE+1,HLMSG(HLINE,0)=HLX,HLX=""
 ;have start block but no record seperator
 I HLX[HLDSTRT D  Q
 . ;check for more than 1 start block
 . S X=$L(HLX,HLDSTRT) S:X>2 HLX=HLDSTRT_$P(HLX,HLDSTRT,X)
 . S:$L($P(HLX,HLDSTRT,2))>8 HLINE=HLINE+1,HLMSG(HLINE,0)=$P(HLX,HLDSTRT,2),HLX="",HLHDR=1
 . D RESET:(HLHDR&(HLINE>1))
 ;if no ien, then we don't have start block, reset
 I 'HLIND1 D CLEAN Q
 ; big message-merge from local to global every 100 lines
 I (HLINE-$O(HLMSG(0)))>100 D
 . M ^HL(772,+$P(HLIND1,U,2),"IN")=HLMSG
 . ; reset working array
 . K HLMSG
 Q
 ;
SAVE(SRC,DEST) ;save into global & set top node
 ;SRC=source array (passed by ref.), DEST=destination global
 M @DEST=SRC
 S @DEST@(0)="^^"_HLINE_"^"_HLINE_"^"_DT_"^"
 Q
 ;
DELMSG(HLMAMT) ;delete message from Message Administration/Message Text files.
 N DIK,DA
 S DA=+HLMAMT,DIK="^HLMA("
 D ^DIK
 S DA=$P(HLMAMT,U,2),DIK="^HL(772,"
 D ^DIK
 Q
MIEN ; sets HLIND1=ien in 773^ien in 772 for message
 N HLMID,X
 I HLIND1 D
 . S:'$G(^HLMA(+HLIND1,0)) HLIND1=0
 . S:'$G(^HL(772,+$P(HLIND1,U,2),0)) HLIND1=0
 ;msg. id is 10th of MSH & 11th for BSH or FSH
 S X=10+($E(HLMSG(1,0),1,3)'="MSH"),HLMID=$$PMSH(.HLMSG,X)
 ;if HLIND1 is set, kill old message, use HLIND1 for new
 ;message, it means we never got end block for 1st msg.
 I HLIND1 D  Q
 . ;get pointer to 772, kill header
 . K ^HLMA(+HLIND1,"MSH")
 . I $D(^HL(772,+$P(HLIND1,U,2),"IN")) K ^("IN")
 . S X=$$MAID^HLTF(+HLIND1,HLMID)
 . D SAVE(.HLMSG,"^HLMA("_+HLIND1_",""MSH"")")
 . S:$P(HLIND1,U,3) $P(HLIND1,U,3)=""
 D TCP^HLTF(.HLMID,.X,.HLDT)
 I 'X D  Q
 . ;error - record and reset array
 . ;killing HLLSTN will allow MON^HLCSTCP to work with multi-server
 . D CLEAN K HLLSTN
 . ;error 100=LLP Could not Enqueue the Message, reset array
 . D MONITOR^HLCSDR2(100,19,HLDP),MON^HLCSTCP("ERROR") H 30
 ;HLIND1=ien in 773^ien in 772
 S HLIND1=X_U_+$G(^HLMA(X,0))
 ;save MSH into 773
 D SAVE(.HLMSG,"^HLMA("_+HLIND1_",""MSH"")")
 Q
 ;
PMSH(MSH,P) ;get piece P from MSH array (passed by ref.)
 N FS,I,L,L1,L2,X,Y
 S FS=$E(MSH(1,0),4),(L2,Y)=0,X=""
 F I=1:1 S L1=$L($G(MSH(I,0)),FS),L=L1+Y-1 D  Q:$L(X)!'$D(MSH(I,0))
 . S:L1=1 L=L+1
 . S:P'>L X=$P($G(MSH(I-1,0)),FS,P-L2)_$P($G(MSH(I,0)),FS,(P-Y))
 . S L2=Y,Y=L
 Q X
 ;
PING ;process PING message
 S X=HLMSG(1,0)
 I X[HLDEND U IO W X,! I $G(IO(0))'="",$G(IO(0))'=IO U IO(0) ;switch to null device if opened to prevent 'leakage'
 ;
CLEAN ;reset var. for next message
 K HLMSG
 S HLINE=0,HLRDOUT=1
 Q
 ;
ERROR ; Error trap for disconnect error and return back to the read loop.
 S $ETRAP="D UNWIND^%ZTER"
 I $$EC^%ZOSV["READ"!($$EC^%ZOSV["NOTOPEN")!($$EC^%ZOSV["DEVNOTOPN") D UNWIND^%ZTER Q
 I $$EC^%ZOSV["WRITE" D CC("Wr-err") D UNWIND^%ZTER Q
 S HLCSOUT=1 D ^%ZTER,CC("Error")
 D UNWIND^%ZTER
 Q
 ;
CC(X) ;cleanup and close
 D MON^HLCSTCP(X)
 H 2
 Q
RESET ;reset info as a result of no end block
 N %
 S HLMSG(1,0)=HLMSG(HLINE,0)
 F %=2:1:HLINE K HLMSG(%,0)
 S HLINE=1
 Q
