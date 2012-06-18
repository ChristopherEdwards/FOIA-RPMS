INHVTMT1 ; DGH,FRW,CHEM,WAB,KAC ; 06 Aug 1999 15:34:58; Multi-threaded TCP/IP socket utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
SEND(INUIF,INIPPO,INIP) ; Function - Send msg from ^INTHU to a socket
 ; 1) includes INIP variables for message framing.
 ; 2) encrypts outgoing messages if the encryption flag is on.
 ;
 ; Called by: INHVTMT
 ;
 ;Input:
 ; INIPPO         - (req) Socket
 ; INIP("SOM")    - (opt) Start of msg
 ; INIP("EOL")    - (opt) End of line (end of segment)
 ; INIP("EOM")    - (opt) End of msg
 ; INIP("CRYPT")  - (opt) Encryption flag
 ; INIP("DESKEY") - (opt) DES key
 ;
 ;Output:
 ; 0 - successful
 ; 1 - error
 ;
 N LCT,LINE,I,INBUF,INB,INCRYPT,INDELIM,INLAST,INMAX,INSL,INSMIN
 S INDELIM=$$FIELD^INHUT(),INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ; Set maximum string length dependent upon whether encryption is on
 S INMAX=$S('INIP("CRYPT"):508,1:328),INBUF="",INB="INB"
 ; Write message
 S LCT=0 F  D GETLINE^INHOU(INUIF,.LCT,.LINE) Q:'$D(LINE)  D
 . I LCT=1 D SAVE(INIP("SOM")_$TR($$NOCTRL^INHUTIL(LINE),INDELIM,INIP("FS"))_INIP("SOD")) Q
 . ;remove control characters if they exist
 . S LINE=$TR($$NOCTRL^INHUTIL(LINE),INDELIM,INIP("FS"))
 . D SAVE(LINE)
 . ;Copy overflow nodes (if any)
 . F I=1:1 Q:'$D(LINE(I))  D
 .. ;remove control characters if they exist
 .. S LINE(I)=$TR($$NOCTRL^INHUTIL(LINE(I)),INDELIM,INIP("FS"))
 .. D SAVE(LINE(I))
 . ;
 . ;Add segment terminator to this line if not last line
 . S INLAST=$S($D(^INTHU(INUIF,3,LCT+1,0)):0,1:1)
 . I 'INLAST D SAVE(INIP("EOL"))
 ;
 ; send what's in buffer and quit
 D SAVE(INIP("EOM"),1)
 D:$G(INDEBUG) LOG^INHVCRA1("Message "_$G(INUIF)_" sent.",5)
 Q 0
 ;
SAVE(INSTR,INLST) ; save msg to buffer
 ; INSTR = (req) string to save
 ; INLST = (opt) if TRUE, means end of msg, time to transmit
 ;         this assumes that INSTR is the EOM chars
 ;         and adds them after the body
 ;
 I $G(INLST) D  Q
 . N INDLEN,X1,X2,L,MX
 . I $L(INBUF) S INSL=INSL+1,@INB@(INSL)=INBUF
 . F I=2:1:INSL D
 .. ; encrypt if needed
 .. I INIP("CRYPT") D
 ... S X1=@INB@(I)
 ... D ENCRYPT^INCRYPT(.X1,.X2,$L(X1),I=2,I=INSL)
 ... S @INB@(I)=X2
 .. ; count data length
 .. S INDLEN=$G(INDLEN)+$L(@INB@(I))
 . ; add EOM chars
 . S INSL=INSL+1,@INB@(INSL)=INSTR
 . ; set data length in header here
 . S $E(@INB@(1),24,27)=$TR($J($G(INDLEN),4)," ","0")
 . ; pack lines into 512 strings for transmit
 . S INBUF="",MX=512 F I=1:1:INSL D
 .. S X=@INB@(I),L=MX-$L(INBUF)
 .. S INBUF=INBUF_$E(X,1,L),X=$E(X,L,$L(X))
 .. I $L(INBUF)=MX D SEND^%INET(INBUF,INIPPO,1) S INBUF=X
 . ; send remainder
 . I $L(INBUF) D SEND^%INET(INBUF,INIPPO,1)
 . ; clean up the send buffer
 . K @INB,INSL
 ;
 ; if line = 1 save
 I '$G(INSL) S INSL=1,@INB@(INSL)=INSTR Q
 ; pack for encription
 S X=$$PACK^INCRYP(INSTR,INMAX,.INBUF)
 Q:'$L(X)
 ; switch to global storage if short on memory
 I $E(INB)'="^",$S<INSMIN K ^UTILITY("INB",$J) M ^($J)=@INB K @INB S INB="^UTILITY(""INB"","_$J_")"
 ; inc line & save
 S INSL=$G(INSL)+1,@INB@(INSL)=X
 Q
 ;
