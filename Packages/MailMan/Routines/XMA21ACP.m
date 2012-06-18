XMA21A ;(WASH ISC)/CAP-MailMan name server (CONT) ;07/10/96  10:04 [ 12/06/96  4:51 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**4,30**;Jun 02, 1994
 Q
INST ;Check domain
 S:$E(X)="<" X=$E(X,2,999) S X=$P(X,">"),X1=X,%Z=""
 F %="INFO:","I:","CC:" I X[% S %Z=%,X=$P(X,%,2)
 I "G."=$E(X,1,2)!($E(X,1,2)="g.") S XMR=$S($D(XMR):XMR,'$D(XMZ):"",$D(^XMB(3.9,XMZ,0)):^(0),1:"") I $S($D(XMDUZ):XMDUZ,1:DUZ)'=$P(XMR,U,2),$P(XMR,U,7)["P",'$D(XMCHAN) K %Z G ER^XMA21G
 S X1=X,X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),X=$P(X,"@",2)
2 I X'=^XMB("NETNAME") S X1=%Z_X1 G 3
 S Y=^XMB("NUM")
 I $P(X1,"@")'["%" S X1=%Z_X1 G LOCAL
 S X1=$TR(X1,"._+",", .")
 S Y=$P(X1,"@"),X=$P(Y,"%",$L(Y,"%")),X1=$P(Y,"%",1,$L(Y,"%")-1)_"@"_X
 G 2
3 S DIC="^DIC(4.2,",DIC(0)="ZM"_$E("E",$D(XMLOC)) D I2 Q:Y<0  S $P(Y(0),U)=$S('$D(X9):$P(X,"@",2),$L(X9):X9_"."_X,1:$P(Y,U,2)) K X9
 I $P(X1,"@")="" S XMMG="Missing recipient name" S Y=-1 Q
 I '$D(^XMB("NUM")) S XMMG="This domain not christened" S Y=-1 Q
 I $L(X1,".")=1 D IHS I Y=-1 Q  ;IHS/MFD added line and IHS subroutine
 I +Y=^XMB("NUM") G LOCAL
 I '$D(XMDF),$P(Y(0),U,2)["C",$P(Y(0),U,2)'["S" S XMMG="MailMan access to "_$P(Y,U,2)_" closed." S Y=-1 Q
 I '$D(XMDF),$P(Y(0),U,11)'="",'$D(^XUSEC($P(Y(0),U,11),DUZ)) S XMMG="You don't hold this domain's KEY.",Y=-1 Q
 I '$D(XMDF),$P(Y(0),U,2)["N" S XMMG="NO forwarding to this domain.",Y=-1 Q
 S %=$P(Y(0),U)
 I $TR(%,"()<>@,;:\[]"_$C(34),"")'=% S XMMG="Domain name must not contain punctuation other than hyphens or dots.",Y=-1 Q
 I %'?1A.E1AN S XMMG="Domain name must begin with a letter and end with a letter or number.",Y=-1 Q
 I $G(XMZ),$$NO(XMZ) W:'$D(ZTQUEUED) *7 S XMMG="<< Messages longer than "_$$NO(XMZ)_" lines may NOT be sent across the network. >>",Y=-1 Q
 ;
 S Y1=$P(X1,"@")_"@"_%
 I $L(Y1)>104!($L($P(Y1,"@")_Y(0,0))>103) S Y=-1,XMMG="Address parsing unsuccessful !" Q
 G I:$G(XMN)
 ;Add RCPT (XMN is either zero or undefined)
 D PSP^XMA210 S ^TMP("XMY",$J,$S('$D(^DIC(4.2,"C",$P(Y1,"@",2))):Y1,1:$P(Y1,"@")_"@"_Y(0,0)))=+Y
 I '$D(XMA21G) S ^TMP("XMY0",$J,Y1)=""
 Q:$D(XMCHAN)
 ;
 ;Display for interactive users (XMCHAN not defined above)
 S XMMG="via "_$P(^DIC(4.2,+Y,0),U)_$S($P(^(0),U,2)["S":"",1:" (Queued)")
 S XMQ(+Y)="" Q
 ;Remove RCPT
I Q:'$D(^TMP("XMY",$J,Y1))  K ^TMP("XMY",$J,Y1),^TMP("XMY0",$J,Y1) W "  Deleted."
 Q
I2 S X9="",XMA21A=^XMB("NUM") I $L(X,".")>1!$D(XMCHAN) S %Z=$P(X,".",$L(X,".")) I %Z="MIL"!(%Z="DE") S DIC(0)=DIC(0)_"MXO"
 F  D ^DIC Q:$S(Y-XMA21A=0&'$L(X9):1,Y-XMA21A'=0&(Y>0):1,1:0)  D  Q:'$D(XMA21A)
 . I X=^XMB("NETNAME") D  Q
 . . S Y=-1,XMDOMLK=1  ; XMDOMLK is checked only by ^XMR.
 . . S XMMG="Sub-Domain '"_X9_"' not found."
 . . K XMA21A
 . S X9=X9_$S($L(X9):".",1:"")_$P(X,".")
 . S X=$P(X,".",2,999)
 . I X="" K XMA21A S:$E(X9)'="#" XMMG="Domain not found." Q
 . ;I $L(X9,".")>1,X'?.E1".".E,DIC(0)'["X" S DIC(0)=DIC(0)_"X" ; *** WHY?
 I '$D(XMA21A),$E(X9)="#" G I3
 Q
 ;X400 ADDRESSING
I3 S X="#" D ^DIC I Y>0 K X9 S X=X1 Q
 S XMMG="X.400 DOMAIN not found. MUST HAVE '#' as it's SYNONYM" Q
LOCAL ;Recipient is local
 ;Recipient name
 S X=$P(X1,"@")
 ;Call Local Name Server Y>0=success
 D W3 S X=$P(X1,"@")
 Q:$S(Y>0:1,".D.G.S.d.g.s."[$E(X_" ",1,2):1,X'[".":1,1:0)
 ;If not successful first time, convert first "," to "." - try again
 S X=$TR(X,"._+",", ."),XMMG=""
 G W3GO
W3 N %,XMA21AL S %=X1,XMA21AL=1 N X1 S X1=%
W3GO N XMLOCQ S XMLOCQ="QUIT" D W3^XMA21
 Q
NO(X) ;Do not allow message to be sent across network if too long
 ;according to field 8.3 of file 4.3
 I $S($D(XMCHAN):1,$D(XMDF):1,$D(^XUSEC("XMMGR",DUZ)):1,1:0) Q 0
 N % S %=$P($G(^XMB(1,1,"NETWORK-LIMIT")),U),%=$S(%:%,1:2000)
 I $P($G(^XMB(3.9,X,2,0)),U,4)>% Q %
 Q 0
IHS ; IHS/MFD screen out addressing to just user@COM, etc.
 N XBIHS F XBIHS="COM","GOV","ARPA","NET","ORG","UK","BITNET","UUCP","FI","ZA","CA","MIL" I X=XBIHS S XMMG="No addressing to "_X_" domain." S Y=-1 Q  ;IHS/MFD
