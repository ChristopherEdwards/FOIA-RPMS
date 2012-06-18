BGUPRE ; IHS/OIT/MJL - PRE INSTALL TO STOP LISTENER ;
 ;;1.5;BGU;;MAY 26, 2005
 ;;TCP Utility to Stop Listener
 ;;BGUTSKT is the Socket port number for listening
 ;;
STOP ;EP-- entry point for stoping Listener before insatll of kids
 S BGUTSKT=$G(^BGUSP(1,2),8000) ;default port
 D END(BGUTSKT)
 Q
END(BGUTSKT) ;stop TCP Listener.  Interactive and TaskMan entry point
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
