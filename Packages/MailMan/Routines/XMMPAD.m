XMMPAD ;IHS/NPO/FBD - ACP-50 X.25 PAD CONTROL LOGIC; [ 06/24/94  1:27 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;3.27;;
 Q
 ;
DIAL ;INITIATE CALL SEQUENCE
 S:XMPHONE'["*" XMPHONE=$P(XMPHONE,"p",1)_"*p"_$P(XMPHONE,"p",2)
 U IO W *13 D CLEAR
 U IO W *13 D CLEAR
 S ER=0 U IO W XMPHONE,*13
 S (NOMORE,XMMHIT)=0
 F %=1:1:3 D  Q:XMMHIT  Q:NOMORE
 .D READ
 .S:Y["com" XMMHIT=1
 I Y'["com" S Y=$S(Y="":"Timed out before receiving 'connect' msg from modem",1:"Received '"_Y_"' msg from modem"),ER=1
 K NOMORE,XMMHIT
 Q
 ;
HANGUP ;DISCONNECT SEQUENCE
 S Y="Disconnected",ER=0
 Q
 ;
STATUS ; "STATUS" CODE
 S Y=" status report",ER=0
 Q
 ;
CLEAR ;FLUSH INPUT BUFFER
 U IO F %=1:1 R *Y:2 Q:'$T
 Q
 ;
READ ;READ ONE LINE OF INPUT
 S Y=""  U IO  F %1=1:1 R C#1:20  Q:'$T  Q:C=$C(10)  S Y=Y_C
 I '$T,'$L(Y) S Y="NO RESPONSE FROM ACP-50",NOMORE=1
 Q
