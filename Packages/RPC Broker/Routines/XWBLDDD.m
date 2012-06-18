XWBTCPL ;SLC/KCM - Listener for TCP connects [ 02/13/95  9:01 PM ] ;10/16/96  11:33
 ;;1.1T3;RPC BROKER;;Nov 25, 1996
 ;ISC-SF/EG - DHCP Broker
 ;
 ; This routine is the background process that listens for client
 ; requests to connect to M.  When a request is received, This
 ; procedure will job a s small routine to listen for new requests
 ; on the known service port.
 ;
 ; This job may be started in the background with:  D STRT^XWBTCP(PORT)
 ;
 ; When running, this job may be stopped with:      D STOP^XWBTCP(PORT)
 ;
 ; Where port is the known service port to listen for connections
 ;
EN(XWBTSKT) ; -- accept clients and start the individual message handler
 N IP,REF,RETRY,XWBVER
 S U="^"
 S RETRY="START"
 X ^%ZOSF("UCI") S REF=Y
 S IP="0.0.0.0" ;get server IP
 IF $G(XWBTSKT)="" S XWBTSKT=9000 ; default service port
 S XWBTDEV=XWBTSKT
 ;
 D SETNM^%ZOSV($E("RPCB_Port:"_XWBTSKT,1,15)) ;change process name
 N LEN,MSG,XWBOS,DONE,DSMTCP,X
 ; -- check the TCP stop parameter
 ;IF $G(^XWB(IP,REF,XWBTSKT,"STOP")) K ^XWB(IP,REF,XWBTSKT) Q   ; -- change to param file later ***
 Q:'$$SEMAPHOR(XWBTSKT,"LOCK")  ; -- quit if job is already running
 ;
 D UPDTREC(XWBTSKT,3) ;updt RPC BROKER SITE PARAMETER record as RUNNING
 ;
RESTART ;
 S DONE=0
 S XWBOS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["MSM":"MSM",^("OS")["OpenM":"OpenM",1:"")
 IF $$NEWERR^%ZTER N $ESTACK S $ETRAP="S %ZTER11S=$STACK D ETRAP^XWBTCPL"
 E  S X="ETRAP^XWBTCPL",@^%ZOSF("TRAP")
 ;
 ; -- check the TCP stop parameter
 ;IF $G(^XWB(IP,REF,XWBTSKT,"STOP")) K ^XWB(IP,REF,XWBTSKT) Q   ; -- change to param file later ***
 ;
 I XWBOS="DSM" O XWBTSKT:TCPCHAN:5 ;Open listener
 ; -- loop until TCP stop parameter is set
 ;F  D  Q:$G(^XWB(IP,REF,XWBTSKT,"STOP"))
 F  D  Q:DONE
 . L +^XWB(IP,REF,XWBTSKT,"PROBLEM MARKER")
 . K ^XWB(IP,REF,XWBTSKT,"PROBLEM MARKER")   ;clear problem marker
 . L -^XWB(IP,REF,XWBTSKT,"PROBLEM MARKER")
 . ;
 . ; -- listen for connect & get the initial message from the client
 . I XWBOS="DSM" U XWBTSKT
 . I XWBOS="MSM" S XWBTDEV=56 O 56 U 56::"TCP" W /SOCKET("",XWBTSKT)
 . I XWBOS="OpenM" S XWBTDEV="|TCP|"_XWBTSKT O XWBTDEV:(:XWBTSKT:"AT") U XWBTDEV R *X
 . S XWBVER=0
 . R LEN#11 IF $E(LEN,1,5)'="{XWB}" Q
 . IF $E(LEN,11,11)="|" D
 . . R X#1
 . . R XWBVER#$A(X)
 . . R LEN#5
 . . R MSG#LEN
 . ELSE  S X=$E(LEN,11,11),LEN=$E(LEN,6,10)-1 R MSG#LEN S MSG=X_MSG
 . ; -- msg should be:  action^client IP^client port^token
 . ;
 . ; -- if the action is TCPconnect (usual case)
 . I $P(MSG,"^")="TCPconnect" D
 . . ;-- decrypt token
 . . N X,%T S X="",%T=0
 . . IF XWBOS="DSM" J EN^XWBTCPC($P(MSG,"^",2),$P(MSG,"^",3),$P(X,"^"),XWBVER):OPTION="/SYMBOL=100000":5 S %T=$T
 . . IF XWBOS="MSM" J EN^XWBTCPC($P(MSG,"^",2),$P(MSG,"^",3),$P(X,"^"),XWBVER):100000:5 S %T=$T
 . . I XWBOS="OpenM" J EN^XWBTCPC($P(MSG,"^",2),$P(MSG,"^",3),$P(X,"^"),XWBVER)::5 S %T=$T
 . . I %T D SNDERR W "accept",$C(4),!
 . . E  D SNDERR W "reject",$C(4),! S ^TMP("TCP",$P($H,",",2))="REJECT"
 . ;
 . ; -- if the action is TCPdebug (when msg handler run interactively)
 . I $P(MSG,"^")="TCPdebug" D SNDERR W "accept",$C(4),!
 . ;
 . ; -- if the action is TCPshutdown, this listener will quit if the
 . ;    stop flag has been set.  This request comes from an M process.
 . I $P(MSG,"^")="TCPshutdown" S DONE=1 W "ack",!
 . ;Now release the connection.
 . I XWBOS="DSM" U XWBTSKT:DISCONNECT ; release this socket
 . I XWBOS="MSM" C 56
 . I XWBOS="OpenM" C XWBTDEV
 . Q
 ; -- loop end
 ;
 IF XWBOS="DSM" C XWBTSKT
 S %=$$SEMAPHOR(XWBTSKT,"UNLOCK") ; destroy 'running flag'
 ;K ^XWB(IP,REF,XWBTSKT,"STOP")
 D UPDTREC(XWBTSKT,6) ;updt RPC BROKER SITE PARAMETER record as STOPPED
 Q
 ;
ETRAP   ; -- on trapped error, send error info to client
 N XWBERR
 S XWBERR=$C(24)_"M  ERROR="_$ZERROR_$C(13,10)_"LAST REF="_$ZR_$C(4)
 D ^%ZTER ;Record it
 S RETRY=RETRY+1 H 3
 IF RETRY=5 H  ;give up trying, server should not restart
 IF $$NEWERR^%ZTER S $ETRAP="Q:($ESTACK&'$QUIT)  Q:$ESTACK 0 S $ECODE="""" G RESTART^XWBTCPL"
 IF XWBOS="DSM" D
 . I $D(XWBTLEN),XWBTLEN,$ZE'["SYSTEM-F" D SNDERR W XWBERR
 IF XWBOS'="DSM" D  G RESTART
 . D SNDERR W XWBERR
 S $ECODE=",U1," Q  ;Pass error up to pop stack.
 ;
SNDERR ;send error information
 ;XWBSEC is the security packet, XWBERROR is application packet
 N X
 S X=$G(XWBSEC)
 W $C($L(X))_X
 S X=$G(XWBERROR)
 W $C($L(X))_X W !
 S XWBERROR="" ;clears parameters
 Q
 ;
 ;
UPDTREC(XWBTSKT,STATE,XWBENV) ; -- update STATUS field and ^%ZIS X-ref of the
 ;RPC BROKER SITE PARAMETER file
 ;XWBTSKT: listener port
 N C,XWBOXIEN,XWBPOIEN,XWBFDA
 S C=",",U="^"
 I $G(XWBENV)'="" S Y=XWBENV
 E  D GETENV^%ZOSV ;get Y=UCI^VOL^NODE^BOXLOOKUP of current system
 I STATE=3 S ^%ZIS(8994.171,"RPCB Listener",$P(Y,U,2),$P(Y,U),$P(Y,U,4),XWBTSKT)=$J
 I STATE=6 K ^%ZIS(8994.171,"RPCB Listener",$P(Y,U,2),$P(Y,U),$P(Y,U,4),XWBTSKT)
 ;
 S XWBOXIEN=$$FIND1^DIC(8994.17,",1,","",$P(Y,U,4)) ;find rec for box
 S XWBPOIEN=$$FIND1^DIC(8994.171,C_XWBOXIEN_",1,","",XWBTSKT)
 D:XWBPOIEN>0  ;update STATUS field if entry was found
 . D FDA^DILF(8994.171,XWBPOIEN_C_XWBOXIEN_C_1_C,1,"R",STATE,"XWBFDA")
 . D FILE^DIE("","XWBFDA")
 Q
 ;
 ;
SEMAPHOR(XWBTSKT,XWBACT) ;Lock/Unlock listener semaphore
 ;XWBTSKT: listener port, XWBACT: "LOCK" | "UNLOCK" action to perform
 ;if LOCK is requested, it will be attempted with 1 sec timeout and if
 ;lock was obtained RESULT will be 1, otherwise it will be 0.  For
 ;unlock RESULT will always be 1.
 N RESULT
 S U="^",RESULT=1
 D GETENV^%ZOSV ;get Y=UCI^VOL^NODE^BOXLOOKUP of current system
 I XWBACT="LOCK" D
 . L +^%ZIS(8994.171,"RPCB Listener",$P(Y,U,2),$P(Y,U),$P(Y,U,4),XWBTSKT):1
 . S RESULT=$T
 E  L -^%ZIS(8994.171,"RPCB Listener",$P(Y,U,2),$P(Y,U),$P(Y,U,4),XWBTSKT)
 Q RESULT
