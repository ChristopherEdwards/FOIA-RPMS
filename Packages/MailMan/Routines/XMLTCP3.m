XMLTCP3 ;(WASH ISC)/CAP - TCP/IP TO MAILMAN ;11/30/89  10:09 ; [ 02/15/95  2:45 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;May 23, 1994
 ;IHS/REP;2/15/94; Changed for testing on port 3602
SEND ;returns ER(0 OR 1), XMLER=number of "soft" errors
 S X="ITRAP^XMCTRAP",@^%ZOSF("TRAP")
 S %=XMSG I $L(%)>255 S ER=1,XMTRAN="Line too long" G TRAN
 I %'?.ANP F %1=1:1:$L(%) I $E(%,%1)?1C,$A(%,%1)'=9 S %=$E(%,1,%1-1)_$E(%,%1+1,999) Q:%?.ANP  S %1=%1-1
 S XMSG=% I $G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,1,XMSG,"TCP/IP-MailMan",1)
 W XMSG,$C(10),! I XMSG="." W $C(13)
 Q
 ;Receive a line (must keep buffer / lines divided by LF)
REC I $D(XMRG),$G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,2,XMRG,"TCP/IP-MailMan",1)
RE S %MORE="" G R:XMLTCP[$C(10) S %=255-$L(XMLTCP)
 S X="ITRAP^XMCTRAP",@^%ZOSF("TRAP")
 R X#$S(%:%,1:1):$S($G(XMSTIME):XMSTIME,1:299)
 I '$T,XMLTCP'=("."_$C(10)) S ER=1,XMRG="",XMTRAN="Receiver timed out" G TRAN
 E  I X="" S ER=ER+.1 Q:ER=1  H 1 G RE
 I $L(XMLTCP)=255 S %MORE=X
 E  S XMLTCP=$G(XMLTCP)_X
 I (XMLTCP_%MORE)'[$C(10) G RE:%MORE=""
R S %=$F(XMLTCP_%MORE,$C(10))
 I % S XMRG=$E(XMLTCP_%MORE,1,%-3+($A(XMLTCP,%-2)'=13)),XMLTCP=$E(XMLTCP_%MORE,%,999),%MORE="" G RQ
 S XMRG=XMLTCP,XMLTCP="" K %MORE
RQ I $L(XMRG),$C(13,10)[$E(XMRG) S XMRG=$E(XMRG,2,$L(XMRG)) G RQ
 Q
TRAN Q:XM'["D"  D TRAN^XMC1 Q
