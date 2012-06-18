XMLTCP2 ;(WASH ISC)/CAP - TCP/IP TO MAILMAN ;11/30/89  10:09 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ; modified to run with MSM NT and Protocol TCP/IP2-MAILMAN (file 3.4)
 ;
OPEN S X=0 X ^%ZOSF("RM") I ^%ZOSF("OS")["VAX" S XMOS("OS")=1
 S (XMLINE,XMLCHAR,XMLER,XMLST,XMNO220)=0,XMLTCP="",XMSTIME=60
 S XMTRAP=^%ZOSF("TRAP"),XMLF=$C(10),XMPLF="."_$C(10),XMCRLF=$C(10,13)
 Q
CLOSE K XMLTCP,XMLF,XMPLF,XMCRLF,XMTRAP,XMOS("OS")
 L -^XMBX("TCPCHAN",XMHOST)
 Q
SEND ;returns ER(0 OR 1), XMLER=number of "soft" errors
 S X="ITRAP^XMCTRAP",@XMTRAP
 S %=XMSG I $L(%)>255 S ER=1,XMTRAN="Line too long" D TRAN Q
 ;I %'?.ANP S %=$$STR^XMLUTL(%)
 S XMSG=% I $G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,1,XMSG,"TCP/IP2-MailMan",1)
 W XMSG,XMCRLF,!
 Q
 ;Receive a line (must keep buffer / lines divided by LF)
REC I $D(XMRG),$G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,2,XMRG,"TCP/IP2-MailMan",1)
 ;Return line if read last time
RE G R:XMLTCP[XMLF S %=255-$L(XMLTCP)
 ;Insure can clean up if line dropped, etc.
 S X="ITRAP^XMCTRAP",@XMTRAP
 I $G(XMOS("OS")) R X#$S(%:%,1:1):$S($G(XMSTIME):XMSTIME,1:160)
 ;Compliant with M standard
 E  R X:$S($G(XMSTIME):XMSTIME,1:299)
 ;
 I '$T,XMLTCP'=(XMPLF) S ER=1,XMRG="",XMTRAN="Rcvr timed out" D TRAN Q
 E  I X="" S ER=ER+.1 Q:ER=1  H 1 G RE
 G RE:X="" S XMLTCP=XMLTCP_X
R S %=$F(XMLTCP,XMLF)
 ;
 ;Strip out LF (and CR, if present)
 I %,%<256 S XMRG=$E(XMLTCP,1,%-3+($A(XMLTCP,%-2)'=13)),XMLTCP=$E(XMLTCP,%,999)
 G RQ
 ;
 ;Line too long or doesn't contain a Line Feed, return first 255 chars.
 S XMRG=$E(XMLTCP,1,255),XMLTCP=$E(XMLTCP,256,999)
 ;
RQ I $L(XMRG),XMCRLF[$E(XMRG) S XMRG=$E(XMRG,2,$L(XMRG)) G RQ
 Q
TRAN Q:XM'["D"  D TRAN^XMC1
 Q
