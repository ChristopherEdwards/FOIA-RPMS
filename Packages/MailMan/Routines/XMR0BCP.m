XMR0B ;(WASH ISC)/THM/CAP-SMTP (HELO/MAIL) [ 11/22/95  11:15 AM ]
VER ;;7.1;Mailman;**1003**;OCT 27, 1998
VER ;;7.1;MailMan;**4,6,13**;Jun 02, 1994
HELO ;;HELLO COMMAND
 I XMP="" S XMSG="501 Missing domain specification" X XMSEN Q
 I '$D(^XMB("NETNAME")) S XMSG="550 Unchristened local domain" X XMSEN Q
 D R1^XMR S X=$P(XMP,"<") I $E(X,$L(X))="." S XMSG="Invalid Domain Name" X XMSEN Q
 S XMHELO("XMP")=X,Y=$$DOMAIN(X)
 S XMINST=+Y S:'$G(XMRDOM) XMRDOM=XMINST L +^DIC(4.2,+Y,"XMSSEND") I '$D(^XMBS(4.2999,+Y,0)) D STAT^XMC1(+Y)
 G H:XMBT S XMU=$P($P(XMP,"<",2),">")
 S Y(0)=^DIC(4.2,+Y,0) I XMU'=$P(Y(0),U,15) S XMB="XMVALBAD",XMB(1)=$P(XMP,"<") D ^XMB S XMSG="550 Bad validation number" X XMSEN G HQ
 I $L(XMU) S XMU=($R(8000000)+1000000)
 S XMSG="250 OK "_^XMB("NETNAME")
 ;Extra set below protect replicated DIC global by failing on 1st set
 ;Global does not get out of synch
 I $L(XMU) S XMSG=XMSG_" <"_XMU_">",^DIC(4.2,+Y,0)=Y(0),$P(Y(0),U,15)=XMU,^(0)=Y(0) K XMU
 S XMSG=XMSG_" ["_$P($T(VER),";",3)_",DUP,SER,FTP]"
H S XMSITE=$P(Y,U,2),XMSTATE="^MAIL^",XMCONT=XMCONT_"TURN^MESS^"
 X XMSEN
HQ L -^DIC(4.2,XMINST,"XMSSEND") Q
 ;
DOMAIN(X) ;Domain name of sender acceptable ?
 N DIC,ER,X9,XMA21A,XMP,XMR0B,XMSEN
 S DIC=4.2,DIC(0)="FMO",XMR0B=X D I2^XMA21A
 I Y>0 Q Y
 N % S (%,X)=XMR0B X ^%ZOSF("UPPERCASE") S XMR0B=Y
 F  S Y=$O(^DIC(4.2,"C",XMR0B,0)) D  Q:Y>0!'$L(XMR0B)
 . I Y>0 Q
 . S XMR0B=$P(XMR0B,".",2,$L(XMR0B,"."))
 . Q
 I Y>0 Q $$DQ(Y)
 Q $$DN(%)
DQ(Y) Q Y_"^"_$P(^DIC(4.2,+Y,0),U)
DN(X) ;Add new Domain
 N DA,DD,DO,XMR0B
 X ^%ZOSF("UPPERCASE") S (XMR0B,X)=$P(Y,".",$L(Y,".")),XMR0B("X")=Y
 S DIC="^DIC(4.2,",DIC("DR")="1///C"_$S(^XMB("NETNAME")="CMBSYB.HQW.IHS.GOV":"",1:";2///CMBSYB.HQW.IHS.GOV") D FILE^DICN  ;IHS/MFD changed FORUM.VA to CMBSYB.HQW.IHS
 K DA,DD,DO
 S ^DIC(4.2,+Y,1,0)="^4.21^1^1"
 S ^DIC(4.2,+Y,1,1,0)="AUTO^^^OTHER",^(1,0)="^^1^1^"_DT,^(1,0)="X Q"
 S ^DIC(4.2,+Y,1,"NOTES",0)="^^1^1^"_DT,^(1,0)="Auto-Created-XMR0B"
 N XMDUZ,XMSUB
 S XMDUZ=.5,XMSUB="New Domain created - "_$P(Y,U,2),XMTEXT="A("
 S A(1)="An incoming transmission from this previously undefined"
 S A(2)="domain ("_XMR0B("X")_") caused this new domain"
 S A(3)="("_$P(Y,U,2)_") to be created"
 S A(4)="",A(5)="to limit the number of entries that are created."
 S A(5)="The Internet Suffix is used for this purpose."
 S A(6)="Statistics are then collected for that level of activity."
 S XMY("G.POSTMASTER")="" D ^XMD
 I '$O(^DIC(4.2996,"B",X,0)) S XMR0B("Y")=Y,DIC="^DIC(4.2996,",DIC("DR")="1///AUTOMATIC-XMR0B" D FILE^DICN S Y=XMR0B("Y")
 Q $P(Y,U,1,2)
MAIL ;;START
 S XMP=$P(XMP,":",2,999) I XMP="" S XMSG="501 Invalid reverse-path specification" X XMSEN Q
 I $$REJ(XMP) S XMSG="502 No message receipt authorization." X XMSEN Q
 K XMY,XMY0,^TMP("XMY",$J),^TMP("XMY0",$J),XMA21G D G2^XMA2 S XMZHOLD=XMDUZ,XMDUZ=.5,XMKM=.95
 I '$D(^XMB(3.7,.5,2,.95,0)) S ^(0)="ARRIVING",^XMB(3.7,.5,2,"B","ARRIVING",.95)=""
 D S2^XMA1B
 S XMDUZ=XMZHOLD,XMBCK=XMP,XMSG="250 OK Message-ID:"_XMZ_"@"_^XMB("NETNAME"),XMSTATE="^LOCK^RCPT^DATA",XMLOCK="" X XMSEN Q:ER
 S X="N",%DT="T" D ^%DT S ^XMB(3.9,XMZ,0)="^^"_Y,X=Y,Y=$E(X,6,7)_" "_$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec",U,$E(X,4,5))_" "_$E(X,2,3) S:X\1'=X %=$P(X,".",2)_"0000",Y=Y_" "_$E(%,1,2)_":"_$E(%,3,4)
 S XMD=Y I $G(XMCHAN)="" S XMCHAN="Turn Around"
 S X=XMCHAN,X=$S(X'?.N:X,$D(^DIC(3.4,X,0)):$P(^(0),U),1:"")
 ;DON'T CHANGE ORDER OF .001 & .002 LINES !
 S ^XMB(3.9,XMZ,2,.001,0)="Received: "_$S($L($G(XMSITE("XMP"))):"from "_XMSITE("XMP")_" by "_^XMB("NETNAME")_", MailMan "_$P($T(VER),";",3)_"/"_X,1:"BATCH")_" ; "_XMD_" "_^XMB("TIMEZONE")
 Q
REJ(X) ;Check Senders rejected list
 I '$O(^XMBX(4.501,0)) G Q0
 N A,B,C,D,Y S C=^%ZOSF("UPPERCASE") X C S D=Y,A=""
 F  S A=$O(^XMBX(4.501,"B",A)) G Q0:A="" S X=A X C I D[Y S B=$O(^(A,0)) I B,'$P($G(^XMBX(4.501,B,0)),U,2) Q
 Q 1
Q0 Q 0
