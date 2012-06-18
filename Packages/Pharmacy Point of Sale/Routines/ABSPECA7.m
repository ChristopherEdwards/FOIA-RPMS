ABSPECA7 ; IHS/FCS/DRS - Parse Claim Response ;   [ 09/12/2002  9:58 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Determine if the duplicate record has been paid or captured
 ;Returns:  0 if Captured
 ;          1 if PAID
 ;----------------------------------------------------------------------
PAID(TEXT) ;EP - from ABSPCA4
 N X,CHARS
 S CHARS="ABCDEFGHIJKLMNOPQR{}"
 S X=$E(TEXT,1,30)
 Q:'($E(X,1,5)?5N) 0
 Q:'($E(X,7,11)?5N) 0
 Q:'($E(X,13,17)?5N) 0
 Q:'($E(X,19,23)?5N) 0
 Q:'($E(X,25,29)?5N) 0
 Q:'(CHARS[$E(X,6)) 0
 Q:'(CHARS[$E(X,12)) 0
 Q:'(CHARS[$E(X,18)) 0
 Q:'(CHARS[$E(X,24)) 0
 Q:'(CHARS[$E(X,30)) 0
 Q 1
 ;----------------------------------------------------------------------
 ; This is not called from anywhere, as far as I can tell
PARSETXT(DA,DA1,TEXT) ;
 S $P(^ABSPR(DA,1000,DA1,500),U,1)="P"
 S $P(^ABSPR(DA,1000,DA1,500),U,5)=$E(TEXT,1,6)
 S $P(^ABSPR(DA,1000,DA1,500),U,6)=$E(TEXT,7,12)
 S $P(^ABSPR(DA,1000,DA1,500),U,7)=$E(TEXT,13,18)
 S $P(^ABSPR(DA,1000,DA1,500),U,8)=$E(TEXT,19,24)
 S $P(^ABSPR(DA,1000,DA1,500),U,9)=$E(TEXT,25,30)
 S $P(^ABSPR(DA,1000,DA1,500),U,3)=$E(TEXT,31,44)
 S $P(^ABSPR(DA,1000,DA1,500),U,4)=$E(TEXT,45,$L(TEXT))
 Q
