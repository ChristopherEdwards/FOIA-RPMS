XMM5 ; ACC-IHS ; MODEM CONTROL LOGIC FOR TIMPLEX MULTIPLEXOR LINE ; [ 09/30/93  4:33 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.0;;ACC/IHS ROUTINE FROM;;3.08;3.27
 ;
 Q
DTIMPLX ; "INITIALIZE" AND "DIAL" CODE
 U IO W *13 D CLEAR
 U IO W *13 F %=0:0 R Y:5 D STRIP Q:Y]""  Q:'$T
 I Y'=" >>> " S Y="could not synchronize with Timeplex ["_Y_"]",ER=1 Q
 ;I 'SILENT U 0 W !,"Synchronized with Timeplex."
 S ER=0 S X=XMPHONE D DIAL F %=1:1 D READ Q:NOMORE
 S XMMSG=Y
 I XMMSG["NO CONNECT" U IO W *27
 I XMMSG'["COMPLETE" S Y=$S(XMMSG="":"timed out before receiving 'connect' msg from Timeplex",1:"received '"_XMMSG_"' msg from Timeplex"),ER=1
 K XMMSG
 Q
STRIP F %=0:0 Q:$A(Y)'=0  S Y=$E(Y,2,$L(Y))
 S:$A(Y,$L(Y))=10 Y=$E(Y,1,$L(Y)-1)
 S %=0
 Q
 ;
HTIMPLX ; "HANGUP" CODE
 U IO W $C(2),$C(3) H 1 W "BYE",*13 D CLEAR
 ;U IO
 F %=0:0 R Y:60 Q:'$T  Q:Y["Exit"
 I Y'[">>>" D CLEAR W $C(2),$C(3) H 1
 W "BYE",*13 D CLEAR
 S Y="disconnected from Timeplex"
 ;I 'SILENT U 0 W !,"Timeplex disconnected and reset."
 Q
 ;
STIMPLX ; "STATUS" CODE
 S Y="no status report",ER=0
 Q
 ;
TIMPLXM ;;CONNECT COMPLETE;;1
 ;;INVALID CONNECT REQUEST;;1
 ;;SORRY, NO CONNECTION;;1
 ;;>>>;;0
 ;;UNRECOGNIZED RESPONSE!;;1
 ;
CLEAR F %=1:1 U IO R Y:2 Q:'$T  ;u 0 w %,") ",Y,!
 Q
DIAL ;I 'SILENT U 0 W !,"Dialing ",X,*13
 U IO W X,*13
 Q
READ U IO F %=1:1 R Y:5 Q:'$T&(Y="")  D STRIP I Y]"" D FINDMSG S NOMORE=$P($T(TIMPLXM+Y),";;",3),Y=$P($T(TIMPLXM+Y),";;",2) Q
 I '$T,Y=""  S Y="NO RESPONSE FROM TIMEPLEX",NOMORE=1
 Q
FINDMSG F XMI=0:1:4 S:Y="" XMI=4 Q:XMI=4  Q:Y[$P($T(TIMPLXM+XMI),";;",2)
 S Y=XMI
 K XMI
 Q
