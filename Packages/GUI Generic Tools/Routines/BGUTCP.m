BGUTCP ; IHS/OIT/MJL - Primary Control TCP listener ; 
 ;;1.5;BGU;;MAY 26, 2005
 ;;Primary TCP Utility to start and stop Listener
 ;;BGUTSKT is the Socket port number for listening
 ;;
EN ;EP-- entry point for interactive use
 N X1,X2,BGUTDBG S:'$D(DTIME) DTIME=300
 D EN^DDIOL("Enter client address: ") R X1:DTIME Q:'$T  Q:X1="^"
 D EN^DDIOL("   Enter client port: ") R X2:DTIME Q:'$T  Q:X2="^"
 S BGUTDBG=""
 D EN^BGUTCPH(X1,X2)
 Q
STRT(BGUTSKT) D EN^DDIOL("Start TCP Listener...") ;EP--entry point for starting listener
 S U="^" D HOME^%ZIS
STRTEN ;EP-- entry point for starting from startup
 I $G(BGUTSKT)="" S BGUTSKT=$G(^BGUSP(1,2),8000) ;default port
 ; -- see if 'running flag' for listener is set
 L +^BGUSP("TMP","RUNNING"):1
 I '$T D EN^DDIOL("TCP Listener appears to be running already.") Q
 L -^BGUSP("TMP","RUNNING"):1
 ;
 ; -- set stop flag to false and start the listener
 S ^BGUSP("TMP","STOP")=""
 ;D GETENV^%ZOSV
 ; -- START listener
 D
 .J EN^BGUTCPL(BGUTSKT)::5
 I '$T D EN^DDIOL("Unable to run TCP Listener in background.") Q
 D EN^DDIOL("TCP Listener started successfully.")
 Q
 ;
STOAP(BGUTSKT) D EN^DDIOL("Stop TCP Listener...") ;EP--entry point for stoping listener
 ;
 I $G(BGUTSKT)="" S BGUTSKT=8000 ;default port
 ; -- make sure the listener is running
 L +^BGUSP("TMP","RUNNING"):1
 I $T D  Q
 . L -^BGUSP("TMP","RUNNING"):1
 . D EN^DDIOL("TCP Listener does not appear to be running.")
 ;
 ; -- set the stop flag
 S ^BGUSP("TMP","STOP")=1
 ;
 ; -- send the shutdown message to the TCP Listener process
 S BGUVER=$G(^%ZOSF("OS")) S:'$L(BGUVER) BGUVER=$ZV
 S BGUMSM=$S(BGUVER["MSM":1,1:0)
 I BGUMSM D
 .O 56 U 56::"TCP"
 .W /SOCKET("127.0.0.1",BGUTSKT) ; -- connect to this machine
 .W $C(11),"TCPshutdown",! ; -- send the shutdown message
 .R X#3:5 ; -- get the three char 'ack' back
 .C 56
 I 'BGUMSM  D
 .D CALL^%ZISTCP("127.0.0.1",BGUTSKT)
 .U IO
 .W $C(11),"TCPshutdown",!  ; -- send the shutdown message
 .R X#3:5 ; -- get the three char 'ack' back
 .;C IO
 .;D CLOSE^%ZISTCP
 D EN^DDIOL("TCP Listener has been shutdown.")
 Q
 ;
STOP(BGUTSKT) ;EP--entry point for stop TCP Listener.  Interactive and TaskMan entry point
STPEN  ;EP -- entry point for stopping from option
 I $G(BGUTSKT)="" S BGUTSKT=$G(^BGUSP(1,2),8000) ;default port
 ;N IP,REF,X,DEV,XWBOS,XWBIP
 S U="^" D HOME^%ZIS
 D EN^DDIOL("Stop TCP Listener...")
 X ^%ZOSF("UCI") S REF=Y
 S IP="0.0.0.0" ;get server IP
 S XWBOS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["MSM":"MSM",^("OS")["OpenM":"OpenM",1:"") ;RWF
 ;
 I $G(BGUTSKT)="" S BGUTSKT=8000 ;default port
 ; -- make sure the listener is running
 L +^BGUSP("TMP","RUNNING"):1
 I $T D  Q
 . L -^BGUSP("TMP","RUNNING"):1
 . D EN^DDIOL("TCP Listener does not appear to be running.")
 ;
 ; -- set the stop flag
 S ^BGUSP("TMP","STOP")=1
 ;
 ; -- send the shutdown message to the TCP Listener process
 ;    using loopback address
 S XWBTSKT=BGUTSKT
 S XWBIP="127.0.0.1"
 D CALL^%ZISTCP("127.0.0.1",XWBTSKT) I POP D  Q
 . D EN^DDIOL("TCP Listener does not appear to be running.")
 U IO
 ;
 W $C(11),"TCPshutdown",! ; -- send the shutdown message
 R X#3:5
 D EN^DDIOL("TCP Listener Response to Shutdown Request: "_X)
 D CLOSE^%ZISTCP
 IF X="ack" D EN^DDIOL("TCP Listener has been shutdown.")
 ELSE  D EN^DDIOL("Shutdown Failed!")
 ;change process name
 ;D CHPRN^XWBTCPC($J)
 Q
RESTART(BGUTSKT) ;STOPS AND STARTS LISTENER
 D STOP(BGUTSKT)
 H 2
 D STRT(BGUTSKT)
 Q
