XMCDNTI ;(HINES ISC)/EEJ-NT COMMUNICATIONS DIAGNOSTICS ; 3/28/95 9:00 AM ; [ 12/05/95  2:36 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**8**;Jun 02, 1994
 ;IHS/MFD IHS version of XMCDNT
 ; modified to loop and use parameter passing for silent calls
 ;EEJ,hines ISC.  Will test mailers in other domains for TCP/IP
 S PORT=3601   ;IHS standard mailer socket port
START ;
 S TALK=1     ; interactive flag
 W !,"TCP/IP tester using port "_PORT D  G END:ZHOST=""
 .W !!,"Enter the TCP/IP address of remote site: "
 .R ZHOST
 W !!,"Testing...",! H 1
 D ENT(ZHOST,PORT) K ZHOST G START
END K PORT,ZHOST,KEY,TALK Q
ENT(ZHOST,PORT) ; enter here for silent call, KEY and QF returned
 ; return var QF=0   attempt was successful
 ;            QF=1   mailer not listening at requested site
 ;            QF=2   could not open device 56
 N ZANSWER
 O 56::10 E  S QF=2 Q
 U 56::"TCP"
 W /SOCKET(ZHOST,PORT) S KEY=$KEY
 U 56 R ZANSWER:30
 I $D(TALK) U 0 W !,"$KEY=",KEY
 I ZANSWER["220" S QF=0 
 E  U 0 S QF=1 I $D(TALK) W !,"No answer from mailer at ",ZHOST
 U 0 I $D(TALK),QF=0 W !,ZANSWER,"     Successful."
 C 56 Q
25 S PORT=25 G START   ;standard mailer socket port for SMTP
