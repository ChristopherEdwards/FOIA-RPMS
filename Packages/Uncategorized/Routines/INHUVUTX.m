INHUVUTX ; cmi/flag/maw - DGH,FRW,CHEM,WAB 06 Aug 1999 14:39 Generic TCP/IP socket utilities ; [ 05/14/2002 1:26 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;
NEXT(INDEST,INPRI,INHOR,INPEND) ;Return next transaction in the queue for destination
 Q $$NEXT^INHUVUT3(INDEST,.INPRI,.INHOR,.INPEND)
 ;
SEND(INUIF,INIPPO,INIP) ;Send a message from INTHU to a socket
 ;More Generic 16-Apr-99 because it
 ;1) includes INIP variables for message framing.
 ;2) encrypts outgoing messages if the encryption flag is on.
 ;INPUT:
 ; INTHU=entry in ^INTHU
 ; INIPPO=socket
 ; INIP=array containing parameters (PBR). Key parameters are:
 ; INIP("SOM")= start of message
 ; INIP("EOL")=end of line (end of segment)
 ; INIP("EOM")=end of message
 ; INIP("CRYPT")=encryption flag
 ; INIP("DESKEY")=DES key
 ;OUTPUT:
 ;0 if successful, 1 if error
 N %,LCT,LINE,EOL,I,INDELIM,INBUF,INCRYPT,INFIRST,INLAST
 S EOL=INIP("EOL"),INDELIM=$$FIELD^INHUT(),INFIRST=1
 ;Set maximum string length dependent upon whether encryption is on
 S INMAX=$S('INIP("CRYPT"):508,1:328),INBUF=""
 ;Write message
 ;;NOTE: APCOTS requested we concatenate "^" to end of segment.
 S (%,LCT)=0 F  D GETLINE^INHOU(INUIF,.LCT,.LINE) Q:'$D(LINE)  D
 .I $D(LINE)<10 D
 ..;remove control characters if they exist
 ..I LINE?.E1C.E S LINE=$$NOCTRL^INHUTIL(LINE)
 ..S LINE=LINE_INDELIM
 .;copy main line
 .S X=$$PACK^INCRYP(LINE,INMAX,.INBUF)
 .;Don't send unless X has length
 .I $L(X) D
 ..S %=%+1
 ..I INIP("CRYPT") D
 ... S INLAST=$S($D(LINE)>9:0,$D(^INTHU(INUIF,3,LCT+1,0)):0,1:1)
 ... D ENCRYPT^INCRYPT(X,.INCRYPT,$L(X),INFIRST,INLAST)
 ... S X=INCRYPT,INFIRST=0
 ..;SOM needed for first packet
 ..S:%=1 X=INIP("SOM")_X
 ..D SEND^%INET(X,INIPPO,1)
 ..;D SEND^%INET(X,INIPPO,1,$G(INBPN))  ;maw cache
 .;Copy overflow nodes
 .F I=1:1 Q:'$D(LINE(I))  D
 ..;remove control characters if they exist
 ..I LINE(I)?.E1C.E S LINE(I)=$$NOCTRL^INHUTIL(LINE(I))
 ..;If no line following set delim at end
 ..I '$D(LINE(I+1)) S LINE(I)=LINE(I)_INDELIM
 ..S X=$$PACK^INCRYP(LINE(I),INMAX,.INBUF)
 ..;don't send unless X has length
 ..Q:'$L(X)
 ..S %=%+1
 ..I INIP("CRYPT") D
 ... S INLAST=$S($D(LINE(I+1)):0,$D(^INTHU(INUIF,3,LCT+1,0)):0,1:1)
 ... D ENCRYPT^INCRYPT(X,.INCRYPT,$L(X),INFIRST,INLAST)
 ... S X=INCRYPT,INFIRST=0
 ..S:%=1 X=INIP("SOM")_X
 ..D SEND^%INET(X,INIPPO,1)
 ..;D SEND^%INET(X,INIPPO,1,$G(INBPN))  ;maw cache
 .;Add segment terminator to this line
 .S X=$$PACK^INCRYP(INIP("EOL"),INMAX,.INBUF)
 .Q:'$L(X)
 .S %=%+1
 .I INIP("CRYPT") D
 .. S INLAST=$S($D(^INTHU(INUIF,3,LCT+1,0)):0,1:1)
 .. D ENCRYPT^INCRYPT(X,.INCRYPT,$L(X),INFIRST,INLAST)
 .. S X=INCRYPT,INFIRST=0
 .S:%=1 X=INIP("SOM")_X
 .D SEND^%INET(X,INIPPO,1)
 .;D SEND^%INET(X,INIPPO,1,$G(INBPN))  ;maw cache
 ;If there's no encryption, send what's in buffer and quit
 S X=INBUF
 S:$L(X) %=%+1
 I $L(X),INIP("CRYPT") D
 . D ENCRYPT^INCRYPT(X,.INCRYPT,$L(X),INFIRST,1)
 . S X=INCRYPT,INFIRST=0
 S X=$S(%=1:INIP("SOM"),1:"")_X_INIP("EOM")_INIP("EOL")
 D SEND^%INET(X,INIPPO,1)
 ;D SEND^%INET(X,INIPPO,1,$G(INBPN))  ;maw cache
 D:$G(INDEBUG) LOG^INHVCRA1("Message "_$G(INUIF)_" sent.",5)
 Q 0
 ;
SENDSTR(STR,INIPPO) ;Sends a initiation string to socket
 ;INPUT:
 ; STR = initiation string (such as $C(11))
 ; INIPPO=socket
 ;Write initiation
 D SEND^%INET(STR,INIPPO,1)
 ;D SEND^%INET(X,INIPPO,1,$G(INBPN))  ;maw cache
 Q
 ;
 ;Tags OPEN, ADDR, PORT are used to find and open a socket
OPEN(INBPN,INCHNL,INERR,INMEM) ;Open socket for destination
 ;INPUT:
 ; INBPN = background process file
 ; INCHNL=channel opened (1st param)
 ; INMEM=memory location (2nd)
 ; INERR=error array
 ;
 N INOUT
 S INOUT=$$OPEN^INHUVUT2(INBPN,.INCHNL,.INERR,.INMEM)
 Q INOUT
 ;
 ;---tags RECEIVE, PARSE, R2 read entries from socket
RECEIVE(INV,INCHNL,INIP,INERR,INMEM) ;Read socket
 ;16-Apr-1999 Added support for decryption of incoming messages
 ;if the encryption flag is set.
 ;INPUT
 ; INV=Location to store message, pass by reference
 ; INCHNL=socket
 ; INIP=array of parameters, PBR
 ; INERR=error array, PBR
 ; INMEM=not used (placeholder.  %INET secondary memory)
 ;OUTPUT
 ;0=ok, 1=no response at all, 2=failure in middle of receive
 ;3=remote system disconnected
 ;   Note: the check for remote system disconnect is based on a string
 ;   match from utility routine %INET. If that utility is changed, this
 ;   must also be changed.
 ;
 N NULLREAD,NORESP,RTO,AP,APDONE,API,APREC,X,REM,INSMIN,REC,INERRREC,INSOM,INEOM,INMS,INREC
 S RTO=INIP("RTO"),INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ;Set defaults
 S INDEBUG=1  ;cmi/maw turned debug on
 S INSOM=INIP("SOM"),INEOM=INIP("EOM")
 ;;Following must change for X12
 S INDELIM=$$FIELD^INHUT()
 D:$G(INDEBUG) LOG^INHVCRA1("Receiving from socket.",5)
 ; load socket input into INREC (or into ^UTILITY("INREC")
 S (APDONE,APREC,AP)="",(NULLREAD,NORESP)=0,INREC="REC"
 K @INREC
 F  D  Q:APDONE!NORESP
 .D RECV^%INET(.APREC,.INCHNL,RTO,1)
 .;D RECV^%INET(.APREC,.INCHNL,RTO,1,$G(INBPN))  ;maw cache
 .I 'AP,$L(APREC),INIP("NOSOM"),APREC'[INSOM S AP=1    ;S APREC=INSOM_APREC ;FOR APCOTS NAKS
 . I $G(APREC)="VQACK" S APREC=INSOM_APREC S APDONE=1  ;cmi/maw added for X12
 .;check for remote disconnect
 .I $G(APREC(0))["Remote end disconnect" S APDONE=3 Q
 .;Check for SOM at start of message.
 .I 'AP,$L(APREC),APREC'[INSOM D
 ..S INERRREC=$$CLEAN(APREC),APREC=""
 ..S INMS="Data Fragmentation error, no SOM. Ignored: "_$E(INERRREC,1,196)
 ..D ENR^INHE(INBPN,INMS) D:$G(INDEBUG) LOG^INHVCRA1(INMS,3)
 .;Check for multiple SOM's after 1st msg (socket read).
 .I AP,APREC[INSOM D
 ..N X S X=$L(APREC,INSOM),AP=AP+1,@INREC@(AP)=$$CLEAN($P(APREC,INSOM,1,X-1))
 ..S APREC=INSOM_$P(APREC,INSOM,X)
 ..K INMS S INMS(1)="Data Fragmentation error, Multiple SOMs. Ignored: "
 ..S INMS(2)=APREC
 ..D ENR^INHE(INBPN,.INMS) D:$G(INDEBUG) LOG^INHVCRA1(.INMS,3)
 ..K @INREC,INMS S AP=0
 .;Check for multiple SOM's in 1st msg.
 .I 'AP,$L(APREC,INSOM)>2 D
 ..N X S X=$L(APREC,INSOM)
 ..S INERRREC=$$CLEAN($P(APREC,INSOM,1,X-1)),APREC=INSOM_$P(APREC,INSOM,X)
 ..S INMS="Data Fragmentation error, mult SOM.  Ignored: "_$E(INERRREC,1,196)
 ..D ENR^INHE(INBPN,INMS) D:$G(INDEBUG) LOG^INHVCRA1(INMS,3)
 .;Use AP as flag, not a true counter.
 .I 'AP,APREC[INSOM S AP=1 D:$E(APREC)'=INSOM  ;
 ..S INERRREC=$$CLEAN($P(APREC,INSOM)),APREC=INSOM_$P(APREC,INSOM,2)
 ..S INMS="Data Fragmentation error, data before SOM.  Ignored: "_$E(INERRREC,1,196)
 ..D ENR^INHE(INBPN,INMS) D:$G(INDEBUG) LOG^INHVCRA1(INMS,3)
 .;Check for data after EOM
 .I APREC[INEOM D
 ..S INERRREC=$P(APREC,INEOM,2,$L(APREC,INEOM)),APREC=$P(APREC,INEOM)_INEOM
 ..Q:(INERRREC=INIP("EOL"))!'$L(INERRREC)  S INERRREC=$$CLEAN(INERRREC)
 ..S INMS="Data Fragmentation error, data past EOM.  Ignored string: "_$E(INERRREC,1,196)
 ..D ENR^INHE(INBPN,INMS) D:$G(INDEBUG) LOG^INHVCRA1(INMS,3)
 .I APREC=""!(APREC[INEOM) S APDONE=1
 .;Remove message framing characters from packet
 .S APREC=$TR(APREC,INSOM_INEOM)
 .;Check for no response from remote system after NNN tries
 .I '$L(APREC) D  Q
 ..D WAIT^INHUVUT2(INBPN,INIP("RHNG"),"Reading socket",.NORESP) Q:NORESP
 ..S NULLREAD=NULLREAD+1 S:NULLREAD>INIP("RTRY") NORESP=1
 .;If encryption is on, call decryption
 .I $G(INIP("CRYPT")) D
 ..D DECRYPT^INCRYPT(APREC,.X,$L(APREC),$S(AP=1:1,1:0),$S(APDONE:1,1:0))
 ..S APREC=X
 .I $S<INSMIN D
 ..Q:INREC["^"
 ..K ^UTILITY("INREC",$J)
 ..M ^UTILITY("INREC",$J)=@INREC K @INREC S INREC="^UTILITY(""INREC"","_$J_")"
 .S AP=AP+1,@INREC@(AP)=APREC
 ;If remote end disconnected
 I APDONE=3 S INERR=$G(APREC(0)) Q APDONE
 ;If No message was received
 I 'AP S INERR="No message received from remote system on receiver "_$P($G(^INTHPC(INBPN,0)),U) Q 1
 ;If remote system timed-out log error
 I NORESP S INERR="Remote system on "_$P($G(^INTHPC(INBPN,0)),U)_" timed out during transmission of message "_$P($G(@INREC@(1)),$G(INDELIM),10) Q 2
 D PARSE^INHUVUT1
 K @INREC
 Q 0
 ;
PARSE ;Parse INREC array (raw message) into ING array (HL7 segments).
 ;PARSE tag moved to INHUVUT1 because routine size is too large
 D PARSE^INHUVUT1 Q
 ;
INIT(INBPN,INIP) ; Intialize parameters
 D INIT^INHUVUT1(INBPN,.INIP)
 Q
 ;
ASCII(X) ;Converts a string into an ASCII string
 Q $$ASCII^INHUVUT1(X)
 ;
ADDR(INBPN,INIPADIE,INERR) ;Get next IP address from Background Proc file
 Q $$ADDR^INHUVUT2(.INBPN,.INIPADIE,.INERR)
 ;
CPORT(INBPN,INIPADIE,INIPPOIE) ;Get next client port from Background Proc. file
 Q $$CPORT^INHUVUT2(.INBPN,.INIPADIE,.INIPPOIE)
 ;
SPORT(INBPN,INIPADIE,INERR) ;Get next server port from Background Prc. file
 Q $$SPORT^INHUVUT2(.INBPN,.INIPADIE,.INERR)
 ;
WAIT(INBPN,HNG,STAT,STOP) ;Hang function which periodically checks ^INRHB
 D WAIT^INHUVUT2(.INBPN,.HNG,.STAT,.STOP) ; Called by INHV*
 Q
CLEAN(X) ; Clean out control characters
 N I,Y S Y=""
 F I=1:1:$L(X) D  Q:$L(Y)>234
 .I $A(X,I)<32!($A(X,I)>127) S Y=Y_"["_$A(X,I)_"]" Q
 .S Y=Y_$E(X,I)
 Q Y
DB() ;
 Q 0
