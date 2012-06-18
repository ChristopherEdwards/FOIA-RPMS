XMCD1 ;PKE/ALBANY COMMUNICATIONS DIAGNOSTICS;1/10/85 ; 12 FEB 86  4:16 pm
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;5.01
 Q
VADATS ;VADATS EXTENDED DIAGNOSTIC
 W !,"This will will test VADATS link for 'Net Go Ahead'"
 I '$D(^XMB(1,1,0)) W !,*7,"No MailMan site parameters defined" Q
 S IO=$P(^(0),U,7) I IO="" W !,*7,"No VADATS device defined.  Use the SITE PARAMETERS option to define one." Q
 S IO=$P(^%ZIS(1,IO,0),U,1) W !,"Device ",IO," defined as the VADATS device."
 D DIAG X ^%ZIS("C") K XMNICK Q
 ;
DIAG O IO::0 I '$T W !,*7,"VADATS device is currently in use." Q
 W !,"Trying to open link to VADATS....."
 S IOP=IO D ^%ZIS Q:POP  S XMNCR=$C(13),XMNIME=30,XMNABT=0,X=0 U IO X ^%ZOSF("EOFF"),^%ZOSF("TYPE-AHEAD"),^%ZOSF("RM") S XMNICK=$P($H,",",2) D NETSHAK^XMNET2 U IO(0)
 I XMNABT W !,*7,"Unable to open device." Q
 W !,XMNANS,"   VADATS line OK     ",$P($H,",",2)-XMNICK W:$D(T) "  (",T,")"
GO ; 
 S XMNABT=0 U IO D NETRDY^XMNET2
 U IO(0) I XMNABT W !,*7,"Net go-ahead not recieved" Q
 W !,XMNANS,"   DHCP-MCTS link OK   ",$P($H,",",2)-XMNICK Q
 ;
DXHINQ Q  ;;;Q:'$D(DUZ)  S:'$D(DTIME) DTIME=30
 ;;;I $D(^XMB(3.8,"B","DGHINQ")) S N=0,N=$O(^("DGHINQ",N)) Q:N=""  F DGU=0:0 S DGU=$O(^XMB(3.8,N,1,"B",DGU)) Q:DGU=""  S XMY(DGU)=""
 K DGU
 W !,*7,*7,"WARNING this test may last up to 3 minutes"
 R !!,"Do you wish to continue ? NO// ",X:DTIME Q:"Yy"'[$E(X,1)  Q:'$L(X)
 S DFN=0,DFN=$O(^DPT(DFN)) Q:'+DFN
 S DGP="AAAA" D BYPASS^DGHINQ
 F Z=1:1:60 H 3 W "." I Z#30=0 S DGDUZ=DUZ,DUZ=236 D EN^XM,SCANNEW^XMA S DUZ=DGDUZ S:$D(XMDUZ) XMDUZ=DGDUZ I $D(XMR),XMR["Hinq" K DGDUZ Q
 Q
