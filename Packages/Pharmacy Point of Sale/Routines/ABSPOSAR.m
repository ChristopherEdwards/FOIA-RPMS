ABSPOSAR ; IHS/FCS/DRS - low-level Receive response ;    [ 09/12/2002  10:06 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,11**;JUN 21, 2001
 ;---------------------------------------------------------------------
 ;Gather message from host until ETX, EOT control characters have been
 ;received or timeout has occurred
 ;
 ;Parameters:  DIALOUT
 ;             .RESPMSG - Message text gathered from modem
 ;             .RESPLRC - Longitudinal redundancy checker character
 ;             TIMEOUT  - Number of seconds before process terminates
 ;
 ;Returns:     "EOT"      - an EOT was received from the host
 ;             ""         - process timed out 
 ;             "ETX"      - ETX received; we have a message & LRC
 ;---------------------------------------------------------------------
 ;IHS/SD/lwj 10/13/04  patch 11
 ; With NCPDP 5.1 the limitation on the response length is now extended
 ; with the repeating segments and fields.  Due to this, the limitation
 ; originally set (2048 characters) needs to be extended and the number
 ; of prescriptions sent on a claim for some processors needs to be
 ; reduced to help limit the size of the response coming back.
 ; Limitation extended to 4096, and for now Pharmacare 5.1 altered to 
 ; 2 rxs per claim.
 ;---------------------------------------------------------------------
 Q
GETMSG(DIALOUT,RESPMSG,RESPLRC,TIMEOUT) ;EP - from ABSPOSAM
 ;
 ;     Since we cannot USE:(parameters) to set the READ terminator,
 ;     we must read one character at a time and check for STX,ETX,EOT
 ; 
 ;FIXED128 = how many times we had to clear unwanted high bit
 ;ZB mimics a terminal device's $ZB, the READ terminator
 N IO S IO=$$IO^ABSPOSA(DIALOUT) U IO
 D LOG^ABSPOSL($T(+0)_" - RESP - Begin gathering host system's response",$G(ECHO))
1 N FIXED128,MAXMSG,ZA,ZB,I,X,T1LENGTH,T1LINE
 ;IHS/SD/lwj 10/13/04 patch 11 nxt line rmkd out, following added
 ;S FIXED128=0,MAXMSG=2048
 S FIXED128=0,MAXMSG=4096
 ;IHS/SD/lwj 10/13/04 patch 11 end changes
 S T1LINE=$$T1DIRECT^ABSPOSA(DIALOUT) ; true if this is a T1 connection
 ;
START S (RESPMSG,RESPLRC,RET)="",(T1LENGTH,ZB)=0
 S X="GETZE^"_$T(+0),@^%ZOSF("TRAP")
 F I=1:1:MAXMSG D  Q:ZB  ; loop to read characters
4 . R *X:0
 . I '$T S ZB=-1 D  ; timed out; retry for up to TIMEOUT secs more
 . . N J F J=1:1:TIMEOUT U IO R *X:1 I $T S ZB=0 Q
 . I ZB D  S RET="+++" Q  ; Timed out, retried, still couldn't get more
 . . D LOG^ABSPOSL($T(+0)_" - RESP - Timed out after "_$L(RESPMSG)_" characters",$G(ECHO))
 . I X<1 Q  ; Something's wrong: got a character but it's 0 or negative
5 . I X>127 S X=X-128,FIXED128=FIXED128+1 ; clear unwanted high bit
 . ;
 . ; Did not time out; process the character
 . ;
 . S X=$C(X)
 . ;
 . ; If it's a T1 connection, first four bytes are the length
 . ; But if a length contains a nonnumeric byte, you have an error.
 . ;
 . I T1LINE,I<5 D  Q:X?1N
 . . I X'?1N D  S X=EOT
 . . . D LOG^ABSPOSL($T(+0)_" - RESP - Character #"_I_" of length prefix was nonnumeric $C("_$A(X)_")")
 . . S T1LENGTH=T1LENGTH*10+$A(X)-$A("0")
 . ; 
 . ; Handle special control characters for modem connections:
 . ;
 . I 'T1LINE,X=STX!(X=ETX)!(X=EOT) D  Q  ; a terminator was received
 . . S ZB=$A(X) ; remember what terminated the READ
 . . I X=ETX D  ; (and this terminator is our favorite one)
7 . . . S RESPMSG=RESPMSG_X
 . . . S RESPLRC=$$GETCH(5) ; got the RESPMSG,now get the LRC
 . . . I RESPLRC="" D  S ZB=-1 ; reset ZB to indicate timeout in GETLRC()
 . . . . D LOG^ABSPOSL($T(+0)_" - RESP - Timed out - got "_$L(RESPMSG)_" characters but not LRC character",$G(ECHO))
8 . S RESPMSG=RESPMSG_X
 . ;
 . ; If T1 line and you've got the entire message gathered,
 . ; then fake out an ETX.  This will cause the outer loop to stop.
 . ; 
 . I T1LINE,I=(T1LENGTH+4) S ZB=$A(ETX),RESPLRC=0
 ;
 ; The READ loop is done - now act on the results
 ;
 ;D SAVECOPY^ABSPOSAY(RESPMSG,"R",RESPLRC)
 I FIXED128 D LOG^ABSPOSL($T(+0)_" - RESP - Had to clear high bit "_FIXED128_" times",$G(ECHO))
 I ZB=$A(EOT) D  Q "EOT" ; EOT received from host
 .D LOG^ABSPOSL($T(+0)_" - RESP - received EOT",$G(ECHO))
 I ZB=$A(STX) D  G START ; 03/08/2000
 . D LOG^ABSPOSL($T(+0)_" - RESP - received STX, read again",$G(ECHO))
 I ZB=-1 D  Q "" ; timed out
 .D LOG^ABSPOSL($T(+0)_" - RESP - timed out",$G(ECHO))
 I ZB=0 D  Q "" ; must have gotten to MAXMSG !?
 .D LOG^ABSPOSL($T(+0)_" - RESP - got to MAXMSG characters",$G(ECHO))
 I ZB'=$A(ETX) D  Q ""  ;ZT  ; must be ETX, then, right?
 .D LOG^ABSPOSL($T(+0)_" - RESP - unexpected ZB = "_ZB_" (should have gotten ETX)",$G(ECHO))
 . D IMPOSS^ABSPOSUE("P","TRI","ZB="_ZB,,"GETMSG",$T(+0))
 D LOG^ABSPOSL($T(+0)_" - RESP - Received "_$L(RESPMSG)_" characters",$G(ECHO))
9999999 Q "ETX"
 ;
 ; GETCH(timeout)  - read one character
 ;    Returns the character obtained, if any.
 ;    Returns "" if it timed out.
GETCH(TO)         ; read one character, timeout TO ; returns "" if timed out
 ;
 ;   If a character is ready immediately, grab it and get out.
 ;
 N X U IO R *X:0 I $T Q $C(X)
 ;
 ;   Otherwise, loop and keep trying; maybe timeout.
 ;
 N J,RET S RET="" F J=1:1:TO R *X:1 I $T S RET=$C(X) Q
 Q RET
 ;
GETZE D LOGZE("GETMSG") Q:$Q "" Q
LOGZE(WHERE) D LOG^ABSPOSL($T(+0)_" - MODEM - "_WHERE_" - $ZE="_$$ZE^ABSPOS) Q
