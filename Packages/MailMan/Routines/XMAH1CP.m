XMAH1 ;(WASH ISC)/CAP- Network Responses ;3/25/91  20:13 ; [ 02/22/96  9:27 AM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**4**;Jun 02, 1994
ENTA G AQ:XMK>.999,AQ:"Yy"[$E($P(XMR,U,12)_" ")
 S Y=$O(^XMB(3.9,XMZ,1,"C",XMDUZ,0))
 I Y,$D(^XMB(3.9,XMZ,1,Y,"T")) G AZ:^("T")="I"
 W *7,!!,"   << Message SAVED in IN Basket ! >>",!
 S (XMK,XMKM)=1,XMKN="IN",XMKD=.5 D NEW^XMA,KL^XMA1B,S2^XMA1B K XMKD,XMKM S XMKS=""
AQ ;Is it a network response ?  (current code just checks sender)
 ;IHS/MFD added ,IHSREC and ,IHSREC=1 below
 ;IHSREC -the sender is from another domain, also used for other domain
 ;        recipients under IHS1 subroutine
 ;IHS    -one or more recipients are of another domain
 ;IHSNET -the send across network question has already been asked
 ;FORUM is screened when sender is from there
 ;R mfd  ;for testing
 K XMNETREC,IHSREC I XMDUZ'=.6,$S($P(XMR,U,2)["@":1,1:0),$S($P(XMR,U,2)["DOMAIN.NAME":0,1:1) S XMNETREC=1,IHSREC=1
 K IHS,IHSNET D IHS  ;IHS/MFD added line
 D REPLY^XMA11 K XMSUB I X[U K XMNETREC G AZ
 W !!," << LOCAL Reply Sent >>",!
AQ1 ;I $S('$D(XMNETREC):0,XMNETREC:1,1:0) K XMCHAN D AR  ;IHS/MFD comm out
 I $S('$D(IHSREC):0,IHSREC:1,1:0) K XMCHAN K IHSREC D AR  ;IHS/MFD added line
 I $D(IHS) D IHS1 K IHSX,IHS,IHSNET,IHSREC  ;IHS/MFD added line
AZ G C1^XMA1
AR K XMY,XMY0,^TMP("XMY",$J),^TMP("XMY0",$J)
 ;
 G ARN:$D(IHSNET)
 G ARN:$D(XMCHAN) D ZIS
ARA W *7,$S($D(IORVON):IORVON,1:""),!,"Do you wish to send this reply across the network ? YES//",$S($D(IORVOFF):IORVOFF,1:"") R X:DTIME  ;IHS/MFD changed NO to YES for default
 S IHSNET=""
 G ARS:X["^" S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;G ARS:$E("NO",1,$L(X))=X,ARN:$E("YES",1,$L(X))=X
 G ARN:$E("YES",1,$L(X))=X,ARS:$E("NO",1,$L(X))=X  ;IHS/MFD added line
 W !!,$C(7)_"Enter 'Yes' if you wish to send this message across the network."
 W !,"Enter 'No' if you wish your response to remain local."
 W !,"The sender of this message will not see your response if you answer 'No'."
 W !!,"CAUTION !!!",!!
 W "A network response will go to all message recipients on the mail system"
 W !,"of the sender.  FOR EXAMPLE, If the sender's address ends '@DOMAIN.NAME'"
 W !,"and the message had 500 recipients on FORUM, then a response sent across"
 W !,"the network will be delivered to 500 recipients.  If you prefer to send a"
 W !,"response only to the sender, you should create a new message.",!!
 G ARA
ARN S XMNETREC(0)=XMZ,XMSUB="Reply to: "_$E($P(XMR,U),1,50)
 S XMNETREC("XMR")=XMR,XMR=^XMB(3.9,XMNETREC,0),$P(XMR,U,8)=XMZ,XMZ=XMNETREC I $D(XMCHAN)!($D(IHS)) S $P(XMR,U)=XMSUB,^(0)=XMR
 I '$D(XMCHAN),'$D(IHSNET) S X=0 D ENTS^XMA20 W !  ;IHS/MFD comm out ask of subject
 I $S(X=U:1,'$D(^XMB(3.9,XMZ,0)):1,1:0) G ARS
 S X=XMSUB  ;IHS/MFD added line
 S Y=$P(^XMB(3.9,XMZ,0),U) I $L(Y) K ^XMB(3.9,"B",$E(Y,1,30),XMZ)
 S ^XMB(3.9,"B",$E(X,1,30),XMZ)="",$P(XMR,U,1,2)=X_U_$S($D(XMDUZ):XMDUZ,1:DUZ),^XMB(3.9,XMZ,0)=XMR,XMN=0
 ;
 ;Send Network Response to Sender's home system
 S (Y1,X)=$P($$NET^XMRENT(XMNETREC(0)),U,3) I $G(X)="" S (Y1,X)=$P(^XMB(3.9,XMNETREC(0),0),U,2)
 I $D(IHSREC) S (Y1,X)=IHSREC K IHSREC
 I X["@" D ACHK I Y<0,'$D(XMCHAN) W !,"Reply NOT sent to sender.",*7 S Y=$S($P(X,"@")["POSTMASTER":"No responses allowed to remote Postmaster",1:"no known path") W !,*7,"(",$S('$D(XMMG):Y,XMMG="":Y,1:XMMG),")"
 S Y=$S($D(^XMB(3.9,XMNETREC(0),5)):^(5),1:XMNETREC(0)_"@"_^XMB("NETNAME")),%=$S($D(^XMB(3.9,XMNETREC(0),"K")):^("K"),1:""),^XMB(3.9,XMZ,"IN")=Y I $L(%) S ^("K")=%
 D ENT1^XMAD1 D POP ;I '$D(XMCHAN) W !,"Network Reply complete !"  ;IHS/MFD commented out
 Q:$D(IHS)   ;IHS/MFD
ARQ K XMNETREC,XMSUB Q
ARS W !!,"Response will only be local !",!! D POP G ARQ
ACHK I X["@",$P(X,"@")["POSTMASTER" S Y=-1,XMMG="Replies to message from remote POSTMASTERS not allowed !"_$C(7) Q
 N % D INSTXM^XMA21 Q
ZIS Q:$D(IORVON)  S X="IORVON;IORVOFF;IOBON;IOBOFF" D ENDR^%ZISS Q
POP Q:'$D(XMNETREC(0))  S XMZ=XMNETREC(0),XMR=XMNETREC("XMR") Q
IHS ;IHS/MFD added subroutine looking for network recipients
 N X S X=""
 F  S X=$O(^XMB(3.9,XMZ,1,"C",X)) Q:X=""  I X["@" S (XMNETREC,IHS)=1 Q
 Q
IHS1 S IHSX=""
 F  S IHSX=$O(^XMB(3.9,XMZ,1,"C",IHSX)) Q:IHSX=""  I IHSX["@" S IHSREC="<"_IHSX_">" I $D(XMNETREC) D AR
 Q
