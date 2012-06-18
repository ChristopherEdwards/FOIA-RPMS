XWBTCPH ;ISC-SF/EG - TCP/IP PROCESS HANDLER ; 4/28/95
 ;;1.0T11;RPC BROKER;;Oct 31, 1995
 ;;V1.0T10;KERNEL RPC BROKER;
 ;Based on:
 ;XQORTCPH ;SLC/KCM - Service TCP Messages [ 12/04/94  9:06 PM ]
 ;XWBTCPH  ;XXX/KCMO converted to use UCX service; 4/28/95
 ;
 ;Modified by ISC-SF/EG
 ; 0. No longer supports old style OERR messages
 ; 1. Makes call to RPC  broker
 ; 2. Handles MSM Server under Windows NT
 ; 3. Handles MSM under Unix - same as DSM
 ; 4. Result of an rpc call can be a closed form of global
 ; 5. Can receive a large local array, within limits of job
 ;    partition size.
 ; 6. Sets default device to NULL device prior to call, restores
 ;    at termination.  Prevents garbage from 'talking' calls.
 ; 7. All reads have a timeout.
 ; 8. Intro message is sent when first connected.
 ;
EN ; -- Main entry point for the UCX service call
 N TYPE,XWBTBUF,XWBTBUF1,XWBTDEV,XWBTLEN,XWBTOS,XWBTRTN,XWBWRAP
 N X,XWBL,XWB1,XWB2,Y,XWBTIME,XWBPTYPE,XWBPLEN,XWBNULL,XWBODEV
 S XWBTIME=1
 S XWBOS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["UNIX":"UNIX",1:"MSM")
 S XWBNULL=$S(XWBOS="DSM":"NLA0:",1:"")
 IF XWBOS="DSM" D
 . IF '$D(%)#2 S %=$P($ZIO,":")_":" ; Call with dsm$xecute()
 . S (XWBTDEV,IO,IO(0))=%,X=$E(%_"WKSTA",1,15)
 . D SETENV^%ZOSV
 . O IO:(SHARE) X ^%ZOSF("TRMOFF")
 IF XWBOS="MSM"!(XWBOS="UNIX") D
 . S (XWBTDEV,IO,IO(0))=56
 IF XWBOS="DSM" S $ETRAP="S %ZTER11S=$STACK D ETRAP^XWBTCPH"
 E  S X="ETRAP^XWBTCPH",@^%ZOSF("TRAP")
 S DIQUIET=1,X="ETRAP^XWBTCPH",@^%ZOSF("TRAP") D DT^DICRW
 ;S DIQUIET=1 D DT^DICRW
 S U="^"
 ;
MAIN ; -- main message processing loop
 F  D  Q:XWBTBUF="#BYE#"
 . ;
 . ; -- read client request
 . R XWBTBUF#15:600 IF '$T S XWBTBUF="#BYE#" W XWBTBUF,$C(4),! Q
 . IF $L(XWBTBUF)=0 S XWBTBUF="#BYE#" W XWBTBUF,$C(4),! Q
 . S TYPE=$S($E(XWBTBUF,1,5)="{XWB}":1,1:0)
 . S XWBTLEN=$E(XWBTBUF,6,10)
 . S XWBPLEN=$E(XWBTBUF,11,15)
 . R XWBTBUF#XWBPLEN:XWBTIME
 . I $P(XWBTBUF,U)="TCPconnect" D  Q
 . . W "accept",$C(4),!  ;Ack
 . IF TYPE D
 . . K XWBR
 . . IF XWBTBUF="#BYE#" W "#BYE#",$C(4),! Q  ; -- clean disconnect
 . . S XWBTLEN=XWBTLEN-15
 . . ;IF XWBTLEN>240 S XWBR=$$RCN()
 . . D CALLP^XWBBRK(.XWBR,XWBTBUF)
 . . S XWBPTYPE=$S('$D(XWBPTYPE):1,XWBPTYPE<1:1,XWBPTYPE>6:1,1:XWBPTYPE)
 . IF XWBTBUF="#BYE#" Q
 . IF XWBOS="DSM"!(XWBOS="UNIX") D SNDDSM
 . IF XWBOS="MSM" D SND
 . W $C(4),! ;send eot and flush buffer
 IF 'TYPE D
 . W "#UNKNOWN MESSAGE TYPE#",$C(4),! Q  ;end session
 ;
 C XWBTDEV Q
 ;
SND ; -- Send data (all except DSM)
 N I,T
 ; -- single value
 IF XWBPTYPE=1 S XWBR=$G(XWBR) W XWBR Q
 ; -- table delimited by CR+LF
 IF XWBPTYPE=2 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W XWBR(I),$C(13,10)
 ; -- word processing
 IF XWBPTYPE=3 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W XWBR(I) W:XWBWRAP $C(13,10)
 ; -- global array
 IF XWBPTYPE=4 D  Q
 . S I=XWBR,T=$E(I,1,$L(I)-1) W:$D(@I)>10 @I F  S I=$Q(@I) Q:I=""!(I'[T)  W @I W:XWBWRAP $C(13,10)
 ; -- global instance
 IF XWBPTYPE=5 S XWBR=$G(@XWBR) W XWBR Q
 ; -- variable length records
 IF XWBPTYPE=6 S I="" F  S I=$O(XWBR(I)) Q:I=""  W $C($L(XWBR(I))),XWBR(I)
 Q
SNDDSM ; -- send data for DSM (requires buffer flush (!) every 512 chars)
 N I,T
 ; -- single value
 IF XWBPTYPE=1 S XWBR=$G(XWBR) W XWBR Q
 ; -- table delimited by CR+LF
 I XWBPTYPE=2 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>512 ! W XWBR(I),$C(13,10)
 ; -- word processing
 IF XWBPTYPE=3 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>512 ! W XWBR(I) W:XWBWRAP $C(13,10)
 ; -- global array
 IF XWBPTYPE=4 D  Q
 . S I=XWBR,T=$E(I,1,$L(I)-1) W:$D(@I)>10 @I F  S I=$Q(@I) Q:I=""!(I'[T)  W:($X+$L(@I))>512 ! W @I W:XWBWRAP&(@I'=$C(13,10)) $C(13,10)
 ; -- global instance
 IF XWBPTYPE=5 S XWBR=$G(@XWBR) W XWBR Q
 ; -- variable length records
 IF XWBPTYPE=6 S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>512 ! W $C($L(XWBR(I))),XWBR(I)
 Q
 ;
ETRAP ; -- on trapped error, send error info to client
 N XWBERR
 S XWBERR=$C(24)_"M  ERROR="_$ZERROR_$C(13,10)_"LAST REF="_$ZR_$C(4)
 U XWBTDEV
 IF XWBOS="DSM" D
 . I $D(XWBTLEN),XWBTLEN,$ZE'["SYSTEM-F" W XWBERR D @^%ZOSF("ERRTN")
 IF XWBOS="MSM" D
 . W XWBERR D @^%ZOSF("ERRTN")
 C XWBTDEV HALT
 ;
RCN() ;read entire buffer in chunks of 240 - save in global
 N I,T
T S T=$R(10000)+1
 L +^TMP("XWB",$J,T):3 IF '$T G T
 F I=1:1:(XWBTLEN\240) D
 . S ^TMP("XWB",$J,T,I)=$$BREAD(240)
 S ^TMP("XWB",$J,T,I+1)=$$BREAD(XWBTLEN#240)
 Q "^TMP(""XWB"","_$J_","_T_")"
 ;
BREAD(L) ;read tcp buffer, L is length
 N E,X,DONE
 S (E,DONE)=0
 R X#L:XWBTIME
 S E=X
 IF $L(E)<L F  D  Q:'DONE
 . IF $L(E)=L S DONE=1 Q
 . R X#(L-$L(E)):XWBTIME
 . S E=E_X
 Q E
 ;
