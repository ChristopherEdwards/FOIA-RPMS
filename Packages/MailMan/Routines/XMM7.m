XMM7 ;DSD/IHS/PDW; MODEM CONTROL LOGIC FOR COURIER AUTODIAL MODEM ; [ 09/30/93  4:34 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.0;;DSD/IHS/PDW ROUTINE FROM;;3.08;3.27;
 Q
DCOUR ; "INITIALIZE" AND "DIAL" CODE
 U IO W *13 D CLEAR
 U IO W "ATQ0V0E0",*13 D CLEAR
 U IO W "ATH",*13 R Y:5 S:'$T Y="" I Y'=0 S Y="could not synchronize with modem ["_Y_"]",ER=1 Q
 ;I 'SILENT U 0 W !,"Synchronized with modem."
 S ER=0 S X="ATDT"_XMPHONE D DIAL F %=1:1 D READ Q:NOMORE
 I Y'["CONNECT" S Y=$S(Y="":"timed out before receiving 'connect' msg from modem",1:"received '"_Y_"' msg from modem"),ER=1 Q
 Q
 ;
HCOUR ; "HANGUP" CODE
 U IO W "+++",*13 H 1 W "ATZ",*13 D CLEAR
 W "ATH0V1",*13
 F %=0:0 R Y:60 Q:'$T  Q:Y["OK"
 ;I 'SILENT U 0 W !,"Modem disconnected and reset."
 Q
 ;
SCOUR ; "STATUS" CODE
 S Y="no status report",ER=0
 Q
 ;
COURIER ;;OK;;1
1 ;;CONNECT;;1
2 ;;RING;;0
3 ;;NO CARRIER;;1
4 ;;ERROR;;1
5 ;;CONNECT 1200;;1
6 ;;NO DIAL TONE;;1
7 ;;BUSY;;1
8 ;;NO ANSWER;;1
9 ;;reserved;;0
10 ;;CONNECT 2400;;1
11 ;;RINGING;;0
12 ;;NOT USED;;0
13 ;;NOT USED;;0
14 ;;CONNECT /ARQ;;1
15 ;;CONNECT 1200/ARQ;;1
16 ;;CONNECT 2400/ARQ;;1
 ;
CLEAR U IO F %=1:1 R *Y:2 Q:'$T
 Q
DIAL ;I 'SILENT U 0 W !,"Dialing ",X,*13
 U IO W X,*13
 Q
READ ;
 S Y="" U IO F %1=1:1 R C:60 Q:'$T  I C'=$A(10) S Y=C,NOMORE=$P($T(COURIER+Y),";;",3),Y=$P($T(COURIER+Y),";;",2) Q
 I '$T S Y="NO RESPONSE FROM MODEM",NOMORE=1
 Q
