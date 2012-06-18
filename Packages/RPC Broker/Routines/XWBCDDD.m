XWBTCPC ;ISC-SF/EG/VYD - TCP/IP PROCESS HANDLER ;11/19/96  14:01 [ 11/20/96  12:53 PM ]
 ;;1.1T3;RPC BROKER;;Nov 25, 1996
 ;Based on:
 ;XQORTCPH ;SLC/KCM - Service TCP Messages [ 12/04/94  9:06 PM ]
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
 ; 9. Uses callback model to connect to client
 ;
MSM ;entry point for MSERVER service - used by MSM
 N XWBVER,LEN,MSG,X
 S XWBVER=0
 R LEN#11 IF $E(LEN,1,5)'="{XWB}" D  Q  ;bad client, abort
 . W "RPC broker disconnect!",!
 . C 56
 . Q
 IF $E(LEN,11,11)="|" D
 . R X#1
 . R XWBVER#$A(X)
 . R LEN#5
 . R MSG#LEN
 . Q
 ELSE  S X=$E(LEN,11,11),LEN=$E(LEN,6,10)-1 R MSG#LEN S MSG=X_MSG
 IF $P(MSG,"^")="TCPconnect" D
 . D SNDERR W "accept",$C(4),!
 . C 56
 . D EN($P(MSG,"^",2),$P(MSG,"^",3),$P(X,"^"),XWBVER)
 IF $P(MSG,"^")="TCPdebug" D
 . D SNDERR W "accept",$C(4),!
 C 56
 Q
 ;
EN(XWBTIP,XWBTSKT,DUZ,XWBVER) ; -- Main entry point
 N TYPE,XWBTBUF,XWBTBUF1,XWBTDEV,XWBTLEN,XWBTOS,XWBTRTN,XWBWRAP
 N X,XWBL,XWB1,XWB2,Y,XWBTIME,XWBPTYPE,XWBPLEN,XWBNULL,XWBODEV
 N XWBERROR,XWBSEC ;new error variable available to rpc calls
 N XRTL,IO,IOP,L,XWBAPVER
 ;
 S XWBOS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["UNIX":"UNIX",^("OS")["OpenM":"OpenM",1:"MSM")
 IF $$NEWERR^%ZTER S $ETRAP="D ^%ZTER H"
 E  S X="^%ZTER",@^%ZOSF("TRAP")
 K XRTL IF XWBOS="DSM" S XRTL=1 ;log response time data for DSM
 S XWBTIME=1
 ;call client on new port
 IF XWBOS="DSM" D
 . ;IF '$D(%)#2 S %=$P($ZIO,":")_":" ; Call with dsm$xecute()
 . ;S %=+$P($ZIO,"Port: ",2)_":"
 . ;S (XWBTDEV,IO,IO(0))=%,X=$E(%_"WKSTA",1,15)
 . ;;D SETENV^%ZOSV
 . O XWBTSKT:(TCPCHAN:ADDRESS=XWBTIP:SHARE)
 . U XWBTSKT X ^%ZOSF("TRMOFF")
 . S XWBTDEV=XWBTSKT
 ;
 IF XWBOS="MSM"!(XWBOS="UNIX") D
 . O 56 U 56::"TCP"
 . W /SOCKET(XWBTIP,XWBTSKT)
 . ;S (XWBTDEV,IO,IO(0))=56
 . S XWBTDEV=56
 ;
 ;Open in stream mode, Standard terminators, Big buffers
 IF XWBOS="OpenM" D
 . S XWBTDEV="|TCP|"_XWBTSKT
 . O XWBTDEV:(XWBTIP:XWBTSKT:"ST":$C(13,10):512:512) ;RWF
 . U XWBTDEV ;RWF
 ;
 ;setup null device "NULL"
 S XWBNULL=$S(XWBOS="DSM":"_NLA0:",1:"")
 IF XWBOS="DSM" O XWBNULL
 ELSE  D
 . S (IO,IO(0))=XWBTDEV
 . S IOP="NULL" D ^%ZIS S XWBNULL=IO
 ;
 ;change process name
 D CHPRN("ip"_$P(XWBTIP,".",3,4)_":"_XWBTSKT)
RESTART IF $$NEWERR^%ZTER N $ESTACK S $ETRAP="S %ZTER11S=$STACK D ETRAP^XWBTCPC"
 E  S X="ETRAP^XWBTCPC",@^%ZOSF("TRAP")
 S DIQUIET=1,U="^" D DT^DICRW
 U XWBTDEV D MAIN
 ;Turn off the error for the exit
 IF $$NEWERR^%ZTER S $ETRAP=""
 E  S X="",@^%ZOSF("TRAP")
 I $G(DUZ) D LOGOUT^XUSRB
 K XWBR,XWBARY
 C XWBTDEV
 IF XWBOS="DSM" C XWBNULL
 ELSE  D ^%ZISC
 Q
 ;
MAIN ; -- main message processing loop
 F  D  Q:XWBTBUF="#BYE#"
 . S XWBAPVER=0
 . ;
 . ; -- read client request
 . ;R XWBTBUF#15:36000 IF '$T S XWBTBUF="#BYE#" D SNDERR W XWBTBUF,$C(4),! Q
 . R XWBTBUF#11:36000 IF '$T S XWBTBUF="#BYE#" D SNDERR W XWBTBUF,$C(4),! Q
 . S TYPE=$S($E(XWBTBUF,1,5)="{XWB}":1,1:0)
 . I 'TYPE S XWBTBUF="#BYE#" D SNDERR W XWBTBUF,$C(4),! Q
 . S XWBTLEN=$E(XWBTBUF,6,10)
 . S L=$E(XWBTBUF,11,11) IF L="|" R L#1 S L=$A(L) R XWBAPVER#L R XWBTBUF#5
 . E  R XWBTBUF#4 S XWBTBUF=L_XWBTBUF
 . S XWBPLEN=XWBTBUF
 . R XWBTBUF#XWBPLEN:XWBTIME
 . I $P(XWBTBUF,U)="TCPconnect" D  Q
 . . D SNDERR W "accept",$C(4),!  ;Ack
 . IF TYPE D
 . . K XWBR,XWBARY
 . . IF XWBTBUF="#BYE#" D SNDERR W "#BYE#",$C(4),! Q  ; -- clean disconnect
 . . S XWBTLEN=XWBTLEN-15
 . . ;IF XWBOS="DSM" X "ZDEBUG ON B  "
 . . D CALLP^XWBBRK(.XWBR,XWBTBUF)
 . . S XWBPTYPE=$S('$D(XWBPTYPE):1,XWBPTYPE<1:1,XWBPTYPE>6:1,1:XWBPTYPE)
 . IF XWBTBUF="#BYE#" Q
 . U XWBTDEV
 . D SNDERR
 . D:$D(XRTL) T0^%ZOSV ;start RTL
 . IF XWBOS="DSM"!(XWBOS="UNIX")!(XWBOS="OpenM") D SNDDSM ;RWF
 . IF XWBOS="MSM" D SND
 . S XWBSEC=""
 . W $C(4),! ;send eot and flush buffer
 . S:$D(XRT0) XRTN="RPC BROKER WRITE" D:$D(XRT0) T1^%ZOSV ;stop RTL
 Q  ;End Of Main
 ;
SNDERR ;send error information
 ;XWBSEC is the security packet, XWBERROR is application packet
 N X
 S X=$G(XWBSEC)
 W $C($L(X))_X W:($X+$L(X)+1)>512 !
 S X=$G(XWBERROR)
 W $C($L(X))_X W:($X+$L(X)+1)>512 !
 S XWBERROR="" ;clears parameters
 Q
 ;
SND ; -- Send data (all except DSM)
 N I,T
 ;
 ; -- error or abort occurred, send null
 IF $L(XWBSEC)>0 W "" Q
 ; -- RPC returned closed root of array, process it as global array
 IF XWBPTYPE=2,$D(XWBR)#2,$D(@XWBR)>1 S XWBPTYPE=4,XWBWRAP=1
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
SNDDSM ; -- send data for DSM (requires buffer flush (!) every 509 chars)
 N I,T
 ;
 ; -- error or abort occurred, send null
 IF $L(XWBSEC)>0 W "" Q
 ; -- RPC returned closed root of array, process it as global array
 IF XWBPTYPE=2,$D(XWBR)#2,$D(@XWBR)>1 S XWBPTYPE=4,XWBWRAP=1
 ; -- single value
 IF XWBPTYPE=1 S XWBR=$G(XWBR) W XWBR Q
 ; -- table delimited by CR+LF
 I XWBPTYPE=2 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>509 ! W XWBR(I),$C(13,10)
 ; -- word processing
 IF XWBPTYPE=3 D  Q
 . S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>509 ! W XWBR(I) W:XWBWRAP $C(13,10)
 ; -- global array
 IF XWBPTYPE=4 D  Q
 . S I=XWBR,T=$E(I,1,$L(I)-1) W:$D(@I)>10 @I F  S I=$Q(@I) Q:I=""!(I'[T)  W:($X+$L(@I))>509 ! W @I W:XWBWRAP&(@I'=$C(13,10)) $C(13,10)
 ; -- global instance
 IF XWBPTYPE=5 S XWBR=$G(@XWBR) W XWBR Q
 ; -- variable length records
 IF XWBPTYPE=6 S I="" F  S I=$O(XWBR(I)) Q:I=""  W:($X+$L(XWBR(I)))>509 ! W $C($L(XWBR(I))),XWBR(I)
 Q
 ;
ETRAP ; -- on trapped error, send error info to client
 N XWBERR
 S XWBERR=$C(24)_"M  ERROR="_$ZERROR_$C(13,10)_"LAST REF="_$ZR_$C(4)
 ;Turn off trapping during trap.
 IF $$NEWERR^%ZTER S $ETRAP=""
 E  S X="",@^%ZOSF("TRAP")
 U XWBTDEV
 D ^%ZTER
 IF XWBOS="DSM" D
 . I $D(XWBTLEN),XWBTLEN,$ZE'["SYSTEM-F" D SNDERR W XWBERR,!
 IF XWBOS'="DSM" D
 . D SNDERR W XWBERR,!
 I ($ZE["READERR")!($ZE["DISCON")!($ZE["SYSTEM-F") HALT
 I '$$NEWERR^%ZTER G RESTART
 S $ETRAP="Q:($ESTACK&'$QUIT)  Q:$ESTACK 0 S $ECODE="""" G RESTART",$ECODE=",U99,"
 Q
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
CHPRN(N) ;change process name
 ;Change process name to N
 D SETNM^%ZOSV($E(N,1,15))
 Q
 ;
