BGUTCPL ; IHS/OIT/MJL - Background Listener for TCP connects ; 25 Jan 2006  9:01 AM [ 04/08/2008  2:01 PM ]
 ;;1.5;BGU;**4**;MAY 26, 2005
 ; This routine is the background process that listens for client
 ; requests to connect to M. When a request is received, a new
 ; process is started (via a parameterized JOB command). The jobbed
 ; process will handle all the messages (procedure calls) from the
 ; client application. This process will then resume listening for the
 ; next client application to make a connect request.
 ;
 ; This job may be started in the background with:  D STRT^BGUTCP(PORT#)
 ;
 ; When running, this job may be stopped with:      D STOP^BGUTCP(PORT#)
 ;
EN(BGUTSKT) ; -- accept client connects and start the individual message handler
 N $ETRAP,$ESTACK S $ETRAP="D RELEASE^BGUTCPL(1),^%ZTER J EN^BGUTCPL($G(BGUTSKT)) HALT"
 I $G(BGUTSKT)="" S BGUTSKT=8000 ; default port number
 ;
 N BGULEN,BGUMSG S:'$D(DTIME) DTIME=300
 ;
 D SETNM^%ZOSV($E("RPCB_Port:"_BGUTSKT,1,15)) ;change process name
 ; -- check the TCP stop parameter
 Q:$G(^BGUSP("TMP","STOP"))  ; -- change to param file later ***
 L +^BGUSP("TMP","RUNNING"):1 Q:'$T  ; -- quit if job is already running
 ;
 S BGUOS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["MSM":"MSM",^("OS")["OpenM":"OpenM",1:"")
 ;I BGUOS="OpenM" S BGUTDEV="|TCP|"_BGUTSKT O BGUTDEV:(:BGUTSKT:"AT"):10 Q:'$T  U BGUTDEV       ; 'BGULEN means lost connection
 I BGUOS="OpenM" D  I '$T Q
 .S BGUTDEV="|TCP|"_BGUTSKT
 .C BGUTDEV ;IHS/OIT/HMW SAC Exemption Applied For
 .O BGUTDEV:(:BGUTSKT:"S"):5 I '$T Q  ;IHS/OIT/HMW SAC Exemption Applied For
 .U BGUTDEV
 ;
 ; -- loop until TCP stop parameter is set
 F  D  Q:$G(^BGUSP("TMP","STOP"))=1
 . ; -- listen for connect & get the initial message from the client
 .I BGUOS="DSM" O BGUTSKT:TCPCHAN:5 ;Open listener
 .I BGUOS="MSM" O 56 U 56::"TCP" W /SOCKET("",BGUTSKT)
 .I BGUOS="DSM" U BGUTSKT
 .;I BGUOS="OpenM" U BGUTDEV R *X ;S BGUTDEV="|TCP|"_BGUTSKT O BGUTDEV:(:BGUTSKT:"AT"):10 Q:'$T  U BGUTDEV       ; 'BGULEN means lost connection
 .R *BGULEN:DTIME I 'BGULEN D RELEASE(0) Q
 .I BGULEN=-1 D RELEASE(0) Q
 .R BGUMSG#BGULEN:DTIME
 .; -- msg should be:  action^client IP^client port^XX^App ID
 .; -- if the action is TCPconnect (usual case)
 .I $P(BGUMSG,"^")["TCPconnect" D
 ..; -- start up the handling process and respond OK to client
 ..S BGUU=$P(BGUMSG,"^",5)
 ..;S NATIP=$$GETPEER^%ZOSV S:'$L(NATIP) NATIP=$P(BGUMSG,"^",2)
 ..;I NATIP'=$P(BGUMSG,"^",2) S $P(BGUMSG,"^",2)=NATIP
 ..I BGUOS="MSM" D
 ...I BGUU'="" S BGUUCI=$P(BGUU,",",1),BGUVGRP=$P(BGUU,",",2) D  Q
 ....I BGUUCI'="",BGUVGRP'="" J EN^BPCTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))[BGUUCI,BGUVGRP]::5 Q
 ....J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))[BGUUCI]::5
 ...J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))::5
 ...I $T W "accept",$C(4),! Q
 ..I BGUOS="OpenM" D
 ...;I BGUU'="" S BGUUCI=$P(BGUU,",",1) J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))[BGUUCI]::5 S %T=$T
 ...;I BGUU="" J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))::5 S %T=$T
 ...I BGUU'="" S BGUUCI=$P(BGUU,",",1) J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3))[BGUUCI]:(:5:BGUTDEV:BGUTDEV):5 S %T=$T
 ...I BGUU="" J EN^BGUTCPH($P(BGUMSG,"^",2),$P(BGUMSG,"^",3)):(:5:BGUTDEV:BGUTDEV):5 S %T=$T
 ...;J SESSION^BMXMON(BMXWIN)[BMXNSJ]:(:5:BMXDEV:BMXDEV):5
 ...;I %T W "accept",$C(4),! Q
 ...;W "reject",$C(4),!
 .;
 .; -- if the action is TCPdebug (when msg handler run interactively)
 .I $P(BGUMSG,"^")="TCPdebug" D
 ..; -- don't job handler, just respond with 'accept'
 ..W "accept",$C(4),!
 .;
 .; -- if the action is TCPshutdown, this listener will quit if the
 .;    stop flag has been set. This request comes from an M process.
 .I $P(BGUMSG,"^")="TCPshutdown" D
 ..W "ack",!
 ..L -^BGUSP("TMP","RUNNING"):1        ; destroy 'running flag'
 .I BGUOS="OpenM"  W *-3,*-2 ;Send any data and release the socket
 .D RELEASE(0)
 ; -- loop end
 D RELEASE(1)
 Q
 ;
CLOSE ;CLOSE CONNECTION
 I BGUOS="DSM" U BGUTSKT:DISCONNECT
 I BGUOS="MSM" C 56
 I BGUOS="OpenM" C BGUTDEV
 Q
 ;
RELEASE(%) ;Now release the connection. (*p7*)
 ;Parameter is zero to Release, one to Close
 I BGUOS="DSM" D
 . I $G(%) C BGUTSKT Q
 . U BGUTSKT:DISCONNECT ; release this socket
 I BGUOS="MSM" C 56
 I BGUOS="OpenM" D
 . I $G(%) C BGUTDEV Q
 . W *-3,*-2 ;Send any data and release the socket
 Q
 ;
