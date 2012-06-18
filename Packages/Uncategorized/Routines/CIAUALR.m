CIAUALR ;MSC/IND/DKM - Send alert to user(s) via kernel or mail;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Send an alert.
 ;   XQAMSG = Message to send
 ;   CIAUSR  = A semicolon-delimited list of users to receive alert.
 ;=================================================================
ALERT(XQAMSG,CIAUSR) ;
 N XQA,XQAOPT,XQAFLG,XQAROU,XQADATA,XQAID
 S @$$TRAP^CIAUOS("EXIT^CIAUALR"),CIAUSR=$G(CIAUSR,"*"),XQAMSG=$TR(XQAMSG,U,"~")
 D ENTRY^CIAUUSR(CIAUSR,.XQA),SETUP^XQALERT:$D(XQA)
EXIT Q
 ;=================================================================
 ; Send a mail message
 ;   CIAMSG  = Message to send (single node or array)
 ;   XMY    = A semicolon-delimited list (or array) of users
 ;   XMSUB  = Subject line (optional)
 ;   XMDUZ  = DUZ of sender (optional)
 ;=================================================================
MAIL(CIAMSG,XMY,XMSUB,XMDUZ) ;
 N XMTEXT
 S:$D(CIAMSG)=1 CIAMSG(1)=CIAMSG
 S XMTEXT="CIAMSG(",@$$TRAP^CIAUOS("EXIT^CIAUALR"),XMY=$G(XMY)
 S:$G(XMSUB)="" XMSUB=CIAMSG
 S:$G(XMDUZ)="" XMDUZ=$G(DUZ)
 F  Q:'$L(XMY)  S X=$P(XMY,";"),XMY=$P(XMY,";",2,999) S:$L(X) XMY(X)=""
 D ^XMD:$D(XMY)>9
 Q
