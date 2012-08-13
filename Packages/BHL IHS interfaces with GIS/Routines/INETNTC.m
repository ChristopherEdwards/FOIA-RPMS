INETNTC ;cmi/anch/maw - Internet function utility - Cache 
 ;;3.01;BHL IHS Interfaces with GIS;**10,15**;APR 03, 2003
 ;CHCS TLS_4603; GEN 1; 21-MAY-1999
 ;COPYRIGHT 1998 SAIC
 ;NOTE: unlike DSM %INET, this version does NOT support multiple client
 ; connections to the same address simultaneously by a single process.
 ;
 ;IHS/ANMC/HMW Modified for AIX/Cache April & May 2002
 Q
OPEN(ZICHAN,ZIX,ZIDOMAIN,ZIPORT,ZIPROT) ;open an internet socket
 ;input:
 ;  ZICHAN   --> receives the "IP Address, domain" or "IP Address"
 ;  ZIX      --> variable used as 1st argument to RECV procedure
 ;  ZIDOMAIN --> domain name i.e. Internet address (null to open a server connection.)
 ;  ZIPORT   --> port number
 ;  ZIPROT   --> null, 0 or 1:tcp, 2:udp
 ;
 N %,INDI,X
 ;S $ZT="ERR^"_$T(+0) ;IHS/ANMC/HMW Restore after testing
 S INDI=$G(IO,$I)
 S ZICHAN=0,ZIX(1)="",ZIX(2)=""
 S ZIPROT=$G(ZIPROT),ZIPROT=$S('ZIPROT!(ZIPROT=1):"TCP",1:"UDP")
 ;IHS/ANMC/HMW Begin cache mods
 ;Cache doesn't use $KEY they way MSM does to define a unique TCP channel
 ;This cache mod uses the PORT^IP to uniquely define the channel.  HMW
 I ^%ZOSF("OS")["OpenM" D
 . N ZIDEV,ZIPARAM,ZIKEY
 . S ZIPARAM=$S(ZIDOMAIN="":"P",1:"M") ;IHS/ANMC/HMW Changed "MA" to "P" mode for server open (Wed 1500)
 . S ZIDEV="|TCP|"_ZIPORT
 . OPEN ZIDEV:(ZIDOMAIN:ZIPORT:ZIPARAM):5
 . Q:'$T
 . U ZIDEV
 . S ZICHAN=ZIPORT_"^"_ZIDOMAIN
 . U:INDI]"" INDI
 . Q
 Q:^%ZOSF("OS")["OpenM"
 ;
 ;IHS/ANMC/HMW End cache mods
 C 56 O 56::5
 ;Xecute statements for ^ZCMS (not proper DSM syntax - duh.)
 ; :(:1) sets the flag on the TCP port to change the behavior of 
 ; a WRITE ! to the socket - it will transmit <CR><LF> instead of 
 ; merely flushing the buffer.  See "MSM-Server User's Guide" in the 
 ; "Using Peripheral Devices" section labeled "TCP/IP Socket Device" 
 ; for more information.
 ;
 X "U 56:(:1)" ; !=$C(13,10)
 X "U 56::ZIPROT W /SOCKET(ZIDOMAIN,ZIPORT) S %=$KEY=""""!$ZC" Q:%
 X "S ZICHAN=$KEY" ; $KEY is MSM's "connection" (numeric) identifier
 U:INDI]"" INDI
 Q
 ;
CLOSE(ZICHAN) ;close the Internet socket (flush)
 ;input:
 ;  ZICHAN --> "IP Address, domain" or "IP Address"
 ;
 Q:'$L($G(ZICHAN))
 ;S $ZT="QUIT^"_$T(+0) ;IHS/ANMC/HMW Restore after testing
 ;IHS/ANMC/HMW Begin cache mods
 ;
 I ^%ZOSF("OS")["OpenM" D
 . N ZIDEV,ZIPORT
 . S ZIPORT=$P(ZICHAN,"^")
 . S ZIDEV="|TCP|"_ZIPORT
 . C:ZIPORT ZIDEV
 . K ZICHAN
 . Q
 Q:^%ZOSF("OS")["OpenM"
 ;
 ;IHS/ANMC/HMW End cache mods
 X "C:ZICHAN 56:ZICHAN" K ZICHAN
 Q
 ;
SEND(ZIX,ZICHAN,ZICRLF) ;send a message over socket
 ;input:
 ;  ZIX    --> a line of text to be sent
 ;  ZICHAN --> "IP Address, Domain" or "IP Address"
 ;  ZICRLF --> carriage return/line feed flag 0:yes, 1:no
 ;
 S $ZT="ERR^"_$T(+0)
 ;
 ;IHS/ANMC/HMW Begin cache mods
 ;N INDI S INDI=$G(IO,$I) U 56 ;IHS/ANMC/HMW Original
 N INDI S INDI=$G(IO,$I)
 I ^%ZOSF("OS")["OpenM" D
 . U "|TCP|"_$P(ZICHAN,"^")
 E  D
 . U 56
 ;IHS/ANMC/HMW End cache mods
 ;
 I '$G(ZICRLF),$L(ZIX)<511 W ZIX_$C(13,10)
 E  W ZIX W:'$G(ZICRLF) !
 I ^%ZOSF("OS")["OpenM" W *-3 ;IHS/ANMC/HMW Added for cache
 U:INDI]"" INDI Q
 ;
RECV(ZIX,ZICHAN,ZITO,ZICRLF) ;receive message from socket
 ;input:
 ;  ZIX       --> variable/array buffer
 ;  ZICHAN    --> "IP Address, Domain" or "IP Address"
 ;  ZITO      --> numeric time out valued in seconds
 ;  ZICRLF    --> carriage return/line feed flag 0:yes, 1:no
 ;         (YES means we expect a CR LF and wish to strip it before
 ;          returning to calling application.)
 ;output:
 ;  ZIX --> received message
 ;
 S $ZT="ERR^"_$T(+0)
 ;IHS/ANMC/HMW Begin cache mods
 ;N INDI S INDI=$G(IO,$I) U 56 ;IHS/ANMC/HMW Original
 N INDI S INDI=$G(IO,$I)
 I ^%ZOSF("OS")["OpenM" D
 . U "|TCP|"_$P(ZICHAN,"^")
 E  D
 . U 56
 ;IHS/ANMC/HMW End cache mods
 S ZICRLF=$G(ZICRLF) K ZIX(0)
 S ZITO=$S('$D(ZITO):600,1:ZITO),ZIX(1)=$G(ZIX(1)),ZIX(2)=$G(ZIX(2))
 ;
 ; If a <CR> <LF> is expected as delimiter, and should be stripped...
 I 'ZICRLF D  U:INDI]"" INDI Q
 .;Loop until we either get a terminator or a read timeout
 .N INOK S INOK=0,ZIX="" F  D  Q:$D(ZIX(0))!(INOK)
 ..S ZIX(2)=ZIX(2)_ZIX
 ..;If data left in buffer, use that first
 ..I $L(ZIX(2)),$F(ZIX(2),$C(10)) D  S INOK=1 Q
 ...N Y S Y=$F(ZIX(2),$C(10)),ZIX=$E(ZIX(2),1,Y-($A(ZIX(2),Y-2)=13)-2),ZIX(2)=$E(ZIX(2),Y,$L(ZIX(2)))
 ...I $L(ZIX)>512 S ZIX(2)=$E(ZIX,513,$L(ZIX))_$C(10)_ZIX(2),ZIX=$E(ZIX,1,512)
 ..I $L(ZIX(2))>511 S INOK=1,ZIX=$E(ZIX(2),1,512),ZIX(2)=$E(ZIX(2),513,$L(ZIX(2))) Q
 ..;Read more from socket...
 ..I ZITO R ZIX:ZITO E  S ZIX(0)="Connection timed out",ZIX="" Q
 ..;I ZITO,$ZC S ZIX(0)="Socket closed: MSM Error $ZB="_$ZB,ZIX="" Q  ;IHS/ANMC/HMW Original
 ..I ^%ZOSF("OS")["MSM",ZITO,$ZC S ZIX(0)="Socket closed: MSM Error $ZB="_$ZB,ZIX="" Q  ;IHS/ANMC/HMW Modified for cache
 ..I ^%ZOSF("OS")["OpenM",ZITO,$ZEOF S ZIX(0)="Socket closed: Cache Error $ZB="_$ZB,ZIX="" Q  ;IHS/ANMC/HMW Modified for cache, BUT I don't think $ZEOF works like this.  Test.
 ..I 'ZITO R ZIX S INOK=1 Q
 ..;and append result to the string we will check on next pass
 ..S ZIX=ZIX(2)_ZIX,ZIX(2)=""
 ;
 ;If we are reading just packets, with no terminators (eg CR LF)
 ;
 ;If data left in buffer, use that first
 I ZICRLF,$L(ZIX(2)) D  U:INDI]"" INDI Q
 .S ZIX=$E(ZIX(2),1,512),ZIX(2)=$E(ZIX(2),513,$L(ZIX(2)))
 ;
 ;Read more from socket
 I ZITO R ZIX:ZITO E  S ZIX(0)="Connection timed out",ZIX="" U:INDI]"" INDI Q
 I 'ZITO R ZIX
 ;
 S ZIX=ZIX(2)_ZIX,ZIX(2)=""
 ;
 I $L(ZIX)>512 S ZIX(2)=$E(ZIX,513,$L(ZIX)),ZIX=$E(ZIX,1,512)
 U:INDI]"" INDI
 Q
 ;
ERR ; Handle error trap
 ;IHS/ANMC/HMW Begin cache mods
 ;I $ZE["<DSCON" S ZIX(0)="Remote end disconected" X:$G(ZICHAN) "C 56:ZICHAN S ZICHAN=""""" U:INDI]"" INDI Q  ;IHS/ANMC/HMW Original
 I ^%ZOSF("OS")["MSM",$ZE["<DSCON" S ZIX(0)="Remote end disconected" X:$G(ZICHAN) "C 56:ZICHAN S ZICHAN=""""" U:INDI]"" INDI Q
 I ^%ZOSF("OS")["OpenM",(($ZE["<DSCON")!($ZE["<READ")) D  U:INDI]"" INDI Q
 . S ZIX(0)="Remote end disconect"
 . I $G(ZICHAN) D
 . . N ZIDEV,ZIPORT
 . . S ZIPORT=$P(ZICHAN,"^")
 . . S ZIDEV="|TCP|"_ZIPORT
 . . C ZIDEV
 . Q
 ;IHS/ANMC/HMW End cache mods
 G ^%ET
QUIT ; Ignore all errors when closing the channel.  Just close it.
 Q
 ;
