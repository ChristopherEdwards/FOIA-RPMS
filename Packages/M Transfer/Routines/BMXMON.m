BMXMON ; IHS/OIT/HMW - BMXNet MONITOR ; 04 Jun 2010  3:10 PM
 ;;4.0;BMX;**2,1000**;OCT 27, 2011;Build 2
 ;
 ; Changes for *1000 by WV/SMH (Feb 2 2011) to support GT.M
 ; - XINETD entry point for GT.M
 ; - Replacement of all W *-3 to W !
 ;
 ;
 ;IHS/OIT/HMW Patch 1 added validity check for passed-in namespace
 ;
STRT(BMXPORT,NS,IS,VB) ;EP
 ;Interactive monitor start
 ;Optional NS = namespace.  If undefined, start in current ns
 ;Optional IS = Integrated Security.  Default is 1
 ;Optional VB = Verbose. Default is 1
 ;
 N Y,BMXNS,BMXWIN
 ;
 ;Verbose
 S BMXVB=$G(VB,1)
 ;
 ;Check if port already running
 I '$$SEMAPHOR(BMXPORT,"LOCK") W:BMXVB "BMXNet Monitor on port "_BMXPORT_" appears to be running already.",! Q
 S %=$$SEMAPHOR(BMXPORT,"UNLOCK")
 ;
 D MARKER(BMXPORT,1) ;record problem marker
 ; -- start the monitor
 ;
 ;Namespace
 X ^%ZOSF("UCI")
 S BMXNS=$G(NS,$P(Y,","))
 ;
 ;Integrated security
 S BMXWIN=$G(IS,1)
 ;
 ;J DEBUG^%Serenji("MON^BMXMON("_BMXPORT_","_BMXNS_","_BMXWIN_")")
 J MON^BMXMON(BMXPORT,BMXNS,BMXWIN)::5 I '$T W:BMXVB "Unable to run BMXNet Monitor in background.",! Q  ;IHS/OIT/HMW SAC Exemption Applied For
 F %=1:1:5 D  Q:%=0
 . W:BMXVB "Checking if BMXNet Monitor has started...",!
 . H 1
 . S:'$$MARKER(BMXPORT,0) %=0
 I $$MARKER(BMXPORT,0) D
 . W:BMXVB !,"BMXNet Monitor could not be started!",!
 . W:BMXVB "Check if port "_BMXPORT_" is busy on this CPU.",!
 . D MARKER(BMXPORT,-1) ;clear marker
 E  W:BMXVB "BMXNet Monitor started successfully."
 ;
 Q
 ;
RESTART ;EP
 ;Stop and Start all monitors in BMX MONITOR file
 ;Called by option BMX MONITOR START
 ;
 D STOPALL
 D STRTALL
 Q
 ;
STRTALL ;EP
 ;Start all monitors in BMX MONITOR file
 ;
 N BMXIEN
 S BMXIEN=0 F  S BMXIEN=$O(^BMXMON(BMXIEN)) Q:'+BMXIEN  D
 . S BMXNOD=$G(^BMXMON(BMXIEN,0))
 . Q:'+BMXNOD
 . Q:'+$P(BMXNOD,U,2)
 . S BMXWIN=$P(BMXNOD,U,3)
 . S BMXNS=$P(BMXNOD,U,4)
 . D STRT($P(BMXNOD,U),BMXNS,BMXWIN,0)
 . Q
 Q
 ;
STOPALL ;EP
 ;Stop all monitors in BMXNET MONITOR file
 ;
 N BMXIEN,BMXPORT
 S BMXIEN=0 F  S BMXIEN=$O(^BMXMON(BMXIEN)) Q:'+BMXIEN  D
 . S BMXNOD=$G(^BMXMON(BMXIEN,0))
 . Q:'+BMXNOD
 . S BMXPORT=+BMXNOD
 . D STOP(BMXPORT,0)
 Q
 ;
STOP(BMXPORT,VB) ;EP Stop monitor on BMXPORT
 ;Open a channel to monitor on BMXPORT and send shutdown request
 ;Optional VB = Verbose. Default is 1
 ;
 N IP,REF,X,DEV
 S U="^" D HOME^%ZIS
 ;
 ;Verbose
 S BMXVB=$G(VB,1)
 ;
 D:BMXVB EN^DDIOL("Stop BMXNet Monitor...")
 X ^%ZOSF("UCI") S REF=Y
 S IP="0.0.0.0" ;get server IP
 IF $G(BMXPORT)="" S BMXPORT=9200
 ; -- make sure the listener is running
 I $$SEMAPHOR(BMXPORT,"LOCK") D  Q
 . S %=$$SEMAPHOR(BMXPORT,"UNLOCK")
 . D:BMXVB EN^DDIOL("BMXNet Monitor does not appear to be running.")
 ; -- send the shutdown message to the TCP Listener process
 D CALL^%ZISTCP("127.0.0.1",BMXPORT) I POP D  Q
 . S %=$$SEMAPHOR(BMXPORT,"UNLOCK")
 . D:BMXVB EN^DDIOL("BMXNet Monitor does not appear to be running.")
 U IO
 S X=$T(+2),X=$P(X,";;",2),X=$P(X,";")
 IF X="" S X=0
 S X=$C($L(X))_X
 W "{BMX}00011TCPshutdown",!
 R X#3:5 ;IHS/OIT/HMW SAC Exemption Applied For
 D CLOSE^%ZISTCP
 I X="ack" D:BMXVB EN^DDIOL("BMXNet Monitor has been shutdown.")
 E  D:BMXVB EN^DDIOL("Shutdown Failed!")
 ;change process name
 D CHPRN($J)
 Q
 ;
MON(BMXPORT,NS,IS) ;Monitor port for connection & shutdown requests
 ;NS = Namespace to Start monitor
 ;IS = 1: Enable integrated security
 ;
 N BMXDEV,BMXQUIT,BMXDTIME,BMXLEN,BMXACT,BMXWIN,BMXNS
 S BMXQUIT=0,BMXDTIME=999999
 ;
 ;Set lock
 Q:'$$SEMAPHOR(BMXPORT,"LOCK")
 ;Clear problem marker
 D MARKER(BMXPORT,-1)
 ;H 1
 ;
 ;Namespace
 X ^%ZOSF("UCI")
 I $G(NS)="" S BMXNS=$P(Y,",")
 E  S BMXNS=NS
 ;
 ;Integrated security
 S BMXWIN=$G(IS,1)
 ;
 ;Open server port; 
 S BMXDEV="|TCP|"_BMXPORT
RELOAD C BMXDEV ;IHS/OIT/HMW SAC Exemption Applied For ; IHS/OIT/GIS 10/4/2011
 O BMXDEV:(:BMXPORT:"S"):5 I '$T Q  ;IHS/OIT/HMW SAC Exemption Applied For
 ;
 ;S BMXDTIME(1)=BMXDTIME ; TODO: Set timeouts
 S BMXDTIME(1)=.5 ;HMW 20050120
 U BMXDEV
 F  D  Q:BMXQUIT
 . R BMXACT#5:BMXDTIME ;Read first 5 chars from TCP buffer, timeout=BMXDTIME ;IHS/OIT/HMW SAC Exemption Applied For
 . I BMXACT="" S BMXQUIT=1 Q  ; LISTENER TIMED OUT AFTER 999999 SECONDS (10 DAYS) ; IHS/OIT/GIS 10/4/2011
 . I BMXACT'="{BMX}" S BMXQUIT=2 Q  ; PRIMARY MESSSAGE IS INVALID.  NEED TO CLEAN OUT TCP BUFFER AND START OVER ; IHS/OIT/GIS 10/4/2011
 . R BMXACT#5:BMXDTIME ;Read next 5 chars - message length ;IHS/OIT/HMW SAC Exemption Applied For
 . S BMXLEN=+BMXACT
 . R BMXACT#BMXLEN:BMXDTIME ;IHS/OIT/HMW SAC Exemption Applied For
 . I $P(BMXACT,"^")="TCPconnect" D  Q
 . . N BMXNSJ,X,Y,ZCHILD,%
 . . S BMXNSJ=$P(BMXACT,"^",2) ;Namespace
 . . S BMXNSJ=$P(BMXNSJ,",")
 . . I BMXNSJ="" S BMXNSJ=BMXNS
 . . S X=BMXNSJ
 . . X ^%ZOSF("UCICHECK") I Y=0 S BMXNSJ=BMXNS
 . . S STATUS=$S(Y'=0:"CONNECTION OK",1:"CONNECTION FAILED, INVALID NAMESPACE") ; SET CONNECTION STATUS BASED ON NAMESPACE VALIDITY
 . . J SESSION^BMXMON(BMXWIN)[BMXNSJ]:(:5:BMXDEV:BMXDEV):5 ;IHS/OIT/HMW SAC Exemption Applied For
 . . X ("S ZCHILD="_$C(36,90)_"CHILD")
 . . I ZCHILD S ^BMXTMP("CONNECT STATUS",ZCHILD)=STATUS
 . . Q
 . I $P(BMXACT,"^")="TCPshutdown" S BMXQUIT=1 W "ack",!
 I BMXQUIT=2 S BMXQUIT=0 G RELOAD ; PRIMARY MSG IS INVALID.  CLEAR TCP BUFFER AND START ITERATING AGAIN. ; IHS/OIT/GIS 10/4/2011
 S %=$$SEMAPHOR(BMXPORT,"UNLOCK") ; destroy 'running flag'
 Q
 ;
XINETD    ;PEP Directly from xinetd or inetd for GT.M
  N BMXDEV
  S U="^",$ETRAP="D ^%ZTER H" ;Set up the error trap
  S $ZT="" ;Clear old trap
  ; GT.M specific error and device code; get remove ip address
  S @("$ZINTERRUPT=""I $$JOBEXAM^ZU($ZPOSITION)""")
  S BMXDEV=$P X "U BMXDEV:(nowrap:nodelimiter:ioerror=""TRAP"")"
  S %="",@("%=$ZTRNLNM(""REMOTE_HOST"")") S:$L(%) IO("GTM-IP")=%
  ; Read message type
  N BMXACT,BMXDTIME
  S BMXDTIME=10  ; change in 2.2 instead of 9999999 - initial conn timout
  R BMXACT#5:BMXDTIME
  Q:BMXACT'="{BMX}"  ; Not a BMX message - quit.
  ; Fall through to below...
GTMLNX    ;EP from XWBTCPM for GT.M
  ; not implementing NS and integrated authentication
  ; Vars: Read timeout, msg len, msg, windows auth, Namespace
  N BMXDTIME,BMXLEN,BMXACT,BMXWIN,BMXNS
  S BMXNSJ="",BMXWIN=0  ; No NS on GT.M, no Windows Authentication
  S BMXDTIME(1)=.5,BMXDTIME=180  ; sign on timeout
  R BMXACT#5:BMXDTIME ;Read next 5 chars - message length
  S BMXLEN=+BMXACT
  R BMXACT#BMXLEN:BMXDTIME
  I $P(BMXACT,"^")="TCPconnect" G SESSRES
  I $P(BMXACT,"^")="TCPshutdown" W "ack",! Q
  Q  ; Should't hit this quit, but just in case
  ;
SESSION(BMXWIN) ;EP
 ;Start session monitor
 ;BMXWIN = 1: Enable integrated security
SESSRES ;EP - reentry point from trap
 ;IHS/OIT/HMW SAC Exemption Applied For
 N $ESTACK S $ETRAP="D ETRAP^BMXMON"
 S DIQUIET=1,U="^" D DT^DICRW
 D UNREGALL^BMXMEVN ;Unregister all events for this session
 U $P D SESSMAIN
 ;Turn off the error trap for the exit
 S $ETRAP=""
 I $G(DUZ) D LOGOUT^XUSRB
 K BMXR,BMXARY
 C $P ;IHS/OIT/HMW SAC Exemption Applied For
 Q
 ;
SESSMAIN ;
 N BMXTBUF
 D SETUP^BMXMSEC(.RET) ;Setup required system vars
 S U="^"
 U $P
 F  D  Q:BMXTBUF="#BYE#"
 . R BMXTBUF#11:BMXDTIME IF '$T D TIMEOUT S BMXTBUF="#BYE#" Q  ;IHS/OIT/HMW SAC Exemption Applied For
 . I BMXTBUF["XQKEY" S HWMP=1
 . I BMXTBUF="#BYE#" Q
 . S BMXHTYPE=$S($E(BMXTBUF,1,5)="{BMX}":1,1:0)  ;check HDR
 . I 'BMXHTYPE S BMXTBUF="#BYE#" D SNDERR W BMXTBUF,$C(4),! Q
 . S BMXTLEN=$E(BMXTBUF,6,10),L=$E(BMXTBUF,11,11)
 . R BMXTBUF#4:BMXDTIME(1) S BMXTBUF=L_BMXTBUF ;IHS/OIT/HMW SAC Exemption Applied For
 . S BMXPLEN=BMXTBUF
 . R BMXTBUF#BMXPLEN:BMXDTIME(1) ;IHS/OIT/HMW SAC Exemption Applied For
 . I $P(BMXTBUF,U)="TCPconnect" D  Q
 . . D SNDERR W "accept",$C(4),!  ;Ack
 . IF BMXHTYPE D
 . . K BMXR,BMXARY
 . . IF BMXTBUF="#BYE#" D SNDERR W "#BYE#",$C(4),! Q
 . . S BMXTLEN=BMXTLEN-15
 . . D CALLP^BMXMBRK(.BMXR,BMXTBUF)
 . . S BMXPTYPE=$S('$D(BMXPTYPE):1,BMXPTYPE<1:1,BMXPTYPE>6:1,1:BMXPTYPE)
 . IF BMXTBUF="#BYE#" Q
 . U $P
 . D SNDERR ;Clears SNDERR parameters
 . D SND
 . D WRITE($C(4)) W ! ;send eot and flush buffer
 D UNREGALL^BMXMEVN ;Unregister all events for this session
 Q  ;End Of Main
 ;
 ;
SNDERR ;send error information
 ;BMXSEC is the security packet, BMXERROR is application packet
 N X
 S X=$E($G(BMXSEC),1,255)
 W $C($L(X))_X W !
 S X=$E($G(BMXERROR),1,255)
 W $C($L(X))_X W !
 S BMXERROR="",BMXSEC="" ;clears parameters
 Q
 ;
WRITE(BMXSTR) ;Write a data string
 ;
 I $L(BMXSTR)<511 W ! W BMXSTR Q
 ;Handle a long string
 W ! ;Flush the buffer
 F  Q:'$L(BMXSTR)  W $E(BMXSTR,1,510),! S BMXSTR=$E(BMXSTR,511,99999)
 Q
SND ; -- send data for all, Let WRITE sort it out
 N I,T
 ;
 ; -- error or abort occurred, send null
 IF $L(BMXSEC)>0 D WRITE("") Q
 ; -- single value
 IF BMXPTYPE=1 S BMXR=$G(BMXR) D WRITE(BMXR) Q
 ; -- table delimited by CR+LF
 IF BMXPTYPE=2 D  Q
 . S I="" F  S I=$O(BMXR(I)) Q:I=""  D WRITE(BMXR(I)),WRITE($C(13,10))
 ; -- word processing
 IF BMXPTYPE=3 D  Q
 . S I="" F  S I=$O(BMXR(I)) Q:I=""  D WRITE(BMXR(I)) D:BMXWRAP WRITE($C(13,10))
 ; -- global array
 IF BMXPTYPE=4 D  Q
 . S I=$G(BMXR) Q:I=""  S T=$E(I,1,$L(I)-1) D:$D(@I)>10 WRITE(@I)
 . F  S I=$Q(@I) Q:I=""!(I'[T)  W ! W @I W:BMXWRAP&(@I'=$C(13,10)) $C(13,10)
 . IF $D(@BMXR) K @BMXR
 ; -- global instance
 IF BMXPTYPE=5 S BMXR=$G(@BMXR) D WRITE(BMXR) Q
 ; -- variable length records only good upto 255 char)
 IF BMXPTYPE=6 S I="" F  S I=$O(BMXR(I)) Q:I=""  D WRITE($C($L(BMXR(I)))),WRITE(BMXR(I))
 Q
 ;
TIMEOUT ;Do this on MAIN  loop timeout
 I $G(DUZ)>0 D SNDERR,WRITE("#BYE#"_$C(4)) Q
 ;Sign-on timeout
 S BMXR(0)=0,BMXR(1)=1,BMXR(2)="",BMXR(3)="TIME-OUT",BMXPTYPE=2
 D SNDERR,SND,WRITE($C(4))
 Q
 ;
SEMAPHOR(BMXTSKT,BMXACT) ;Lock/Unlock BMXMON semaphore
 N RESULT
 S U="^",RESULT=1
 D GETENV^%ZOSV ;get Y=UCI^VOL^NODE^BOXLOOKUP of current system
 I BMXACT="LOCK" D
 . L +^BMXMON("BMXMON",$P(Y,U,2),$P(Y,U),$P(Y,U,4),BMXTSKT):1
 . S RESULT=$T
 E  L -^BMXMON("BMXMON",$P(Y,U,2),$P(Y,U),$P(Y,U,4),BMXTSKT)
 Q RESULT
 ;
CHPRN(N) ;Change process name to N.
 D SETNM^%ZOSV($E(N,1,15))
 Q
 ; 
CKSTAT(OUT,IN) ; EP - RPC: BMX CONNECT STATUS ; CONFIRMS THAT THAT A VALID PROCESS HAS BEEN SPAWNED BY BMXMON
 N PORT,STATUS,JOBID
 S PORT=+$P($P,"|",3)
 S JOBID=$P($J,":",1)
 I $G(^BMXTMP("CONNECT STATUS",JOBID))="" HANG 1  ;Wait for job to spawn ZCHILD to be set in MON^
 I $G(^BMXTMP("CONNECT STATUS",JOBID))="" HANG 1
 I $G(^BMXTMP("CONNECT STATUS",JOBID))="" HANG 1
 S STATUS=$G(^BMXTMP("CONNECT STATUS",JOBID))
 K ^BMXTMP("CONNECT STATUS",JOBID)
 I STATUS="" S STATUS="CONNECTION STATUS UNKNOWN"
 S OUT=PORT_"|"_STATUS_"|"_JOBID
 Q
 ;
MARKER(BMXPORT,BMXMODE) ;Set/Test/Clear Problem Marker, BMXMODE=0 is a function
 N IP,Y,%,REF X ^%ZOSF("UCI") S REF=Y,IP="0.0.0.0",%=0
 L +^BMX(IP,REF,BMXPORT,"PROBLEM MARKER"):1
 I BMXMODE=1 S ^BMX(IP,REF,BMXPORT,"PROBLEM MARKER")=1
 I BMXMODE=0 S:$D(^BMX(IP,REF,BMXPORT,"PROBLEM MARKER")) %=1
 I BMXMODE=-1 K ^BMX(IP,REF,BMXPORT,"PROBLEM MARKER")
 L -^BMX(IP,REF,BMXPORT,"PROBLEM MARKER")
 Q:BMXMODE=0 % Q
 ;
ETRAP ; -- on trapped error, send error info to client
 N BMXERC,BMXERR,BMXLGR
 ;Change trapping during trap.
 S $ETRAP="D ^%ZTER HALT" ;IHS/OIT/HMW SAC Exemption Applied For
 S BMXERC=$$EC^%ZOSV
 S BMXERR="M ERROR="_BMXERC_$C(13,10)_"LAST REF="
 S BMXLGR=$$LGR^%ZOSV_$C(4)
 S BMXERR=BMXERR_BMXLGR
 D ^%ZTER ;%ZTER clears $ZE and $ECODE
 I (BMXERC["READ")!(BMXERC["WRITE")!(BMXERC["SYSTEM-F") D:$G(DUZ) LOGOUT^XUSRB G ^XUSCLEAN
 U $P
 D SNDERR,WRITE(BMXERR) W !
 S $ETRAP="Q:($ESTACK&'$QUIT)  Q:$ESTACK -9 S $ECODE="""" G SESSRES^BMXMON",$ECODE=",U99," ;IHS/OIT/HMW SAC Exemption Applied For
 Q
 ;
MENU ;EP - ENTRY ACTION FROM BMXMENU OPTION
 ;
 N BMX,BMXVER
 ;VERSION
 D
 . S BMXN="BMXNET ADO.NET DATA PROVIDER" I $D(^DIC(9.4,"B",BMXN)) Q
 . S BMXN="BMXNET RPMS .NET UTILITIES" I $D(^DIC(9.4,"B",BMXN)) Q
 . S BMXN=""
 . Q
 ;
 S BMXVER=""
 I BMXN]"",$D(^DIC(9.4,"B",BMXN)) D
 . S BMX=$O(^DIC(9.4,"B",BMXN,0))
 . I $D(^DIC(9.4,BMX,"VERSION")) S BMXVER=$P(^DIC(9.4,BMX,"VERSION"),"^")
 . E  S BMXVER="VERSION NOT FOUND"
 S:BMXVER="" BMXVER="VERSION NOT FOUND"
 ;
 ;LOCATION
 N BMXLOC
 S BMXLOC=""
 I $G(DUZ(2)),$D(^DIC(4,DUZ(2),0)) S BMXLOC=$P(^DIC(4,DUZ(2),0),"^")
 S:BMXLOC="" BMXLOC="LOCATION NOT FOUND"
 ;
 ;WRITE
 W !
 W !,"BMXNet Version: ",BMXVER
 W !,"Location: ",BMXLOC
 Q
