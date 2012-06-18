XWBTCPZ ;SLC/KCM - calls to client listener [ 12/04/94  8:58 PM ]
 ;;1.0T11;RPC BROKER;;Oct 31, 1995
 ;
STARTAPP(APP,ERR,DHCP) ; Start a windowed application (use full path name)
 ; input:  X is name of windowed app
 ; output: ERR is returned error code (passed by reference)
 N X,I,DEV,LEN,OS,SKT
 S SKT=9100,ERR="unknown error" IF '$L(APP) S ERR="no app" Q
 S OS=$S(^%ZOSF("OS")["DSM":"DSM",^("OS")["MSM":"MSM",1:"")
 ; -- get the IP address of the client
 I OS="DSM" S IP=$P($&ZLIB.%GETDVI($P,"TT_ACCPORNAM")," ",2)
 I OS="MSM" S IP="127.0.0.1"    ; -- for laptop demo only
 I '$L(IP) S ERR="not telnet device" Q
 ; -- connect to client
 I OS="DSM" O SKT:(TCPCHAN:ADDRESS=IP) U SKT S DEV=SKT
 I OS="MSM" O 56 U 56::"TCP" W /SOCKET(IP,SKT) S DEV=56
 ; -- send StartApp message
 S X="StartApp^"_APP
 I $G(DHCP) S X=X_" "_$$NCRYPT^XWBTCPZ(DUZ_"^password^"_$H,$C(83,69,67,82,69,84))
 W X,$C(4),!
 ; -- get acknowledgement
 R *LEN R X#LEN
 I X'="ack" S ERR="not started"
 E  S ERR=""
 ; -- close socket
 C DEV
 U $P
 Q
 ;
NCRYPT(SRC,KEY) ; Encrypt the string in SRC, using KEY
 ; Input:  SRC, KEY
 ; Output: DEST returned as value of function
 N OFFSET,SRCPOS,SRCASC,KEYPOS,DEST
 S OFFSET=($R(10000)#255)+1
 S DEST=$TR($J($$HEX(OFFSET),2)," ","0")
 S KEYPOS=0 F SRCPOS=1:1:$L(SRC) D
 . S SRCASC=($A(SRC,SRCPOS)+OFFSET)#255
 . I KEYPOS<$L(KEY) S KEYPOS=KEYPOS+1
 . E  S KEYPOS=1
 . S SRCASC=$$XOR(SRCASC,$A(KEY,KEYPOS))
 . S DEST=DEST_$J($$HEX(SRCASC),2)
 . S OFFSET=SRCASC
 Q DEST
DCRYPT(SRC,KEY) ; Decrypt the string in SRC, using KEY
 ; Input:  SRC, KEY
 ; Output: DEST returned as value of function
 N OFFSET,SRCPOS,SRCASC,KEYPOS,TMPASC,DEST
 S OFFSET=$$DEC($E(SRC,1,2)),DEST="",KEYPOS=0
 F SRCPOS=3:2:$L(SRC) D
 . S SRCASC=$$DEC($TR($E(SRC,SRCPOS,SRCPOS+1)," ",""))
 . I KEYPOS<$L(KEY) S KEYPOS=KEYPOS+1
 . E  S KEYPOS=1
 . S TMPASC=$$XOR(SRCASC,$A(KEY,KEYPOS))
 . I TMPASC'>OFFSET S TMPASC=255+TMPASC-OFFSET
 . E  S TMPASC=TMPASC-OFFSET
 . S DEST=DEST_$C(TMPASC),OFFSET=SRCASC
 Q DEST
HEX(X) ; Return the hex value of the decimal number in X
 N I,X1,Y S Y="",X1=16
 F I=1:1 S Y=$E("0123456789ABCDEF",X#X1+1)_Y,X=X\X1 Q:X<1
 Q Y
DEC(X) ; Return the decimal value of the hex number in X
 N I,X1,Y S Y=0,X1=16
 F I=1:1:$L(X) S Y=Y*X1+($F("0123456789ABCDEF",$E(X,I))-2)
 Q Y
XOR(X1,X2) ;Exclusive OR two numbers
 I ^%ZOSF("OS")["DSM" Q $&ZLIB.%BOOLEAN(X1,X2,6)
 I ^%ZOSF("OS")["MSM" Q @("$ZBOOLEAN("_X1_","_X2_",6)")
 Q ""
