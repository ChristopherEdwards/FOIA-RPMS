BEHOXQCV ;MSC/IND/DKM - Cover Sheet: Alerts ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**026001**;Mar 20, 2007
 ;=================================================================
 ; Return alerts according to FLG:
 ;  A = one patient, all users (default)
 ;  U = one patient, one user
 ;  P = all patients, one user
LIST(DATA,DFN,FLG) ;
 N GBL,LP,CNT,X,Y
 S DATA=$$TMPGBL^CIAVMRPC,GBL=$$TMPGBL^CIAVMRPC(1)
 S @DATA@(1)="^No notifications found.",(CNT,LP)=0,FLG=$G(FLG),DFN=+$G(DFN)
 D PATIENT^XQALERT(GBL,DFN):"A"[FLG,USER^XQALERT(GBL,DUZ):"UP"[FLG
 F  S LP=$O(@GBL@(LP)) Q:'LP  D
 .S X=@GBL@(LP),Y=$P(X,U,2)
 .Q:$P(Y,";")'["OR"
 .Q:"AU"[FLG&($P(Y,",",2)'=DFN)
 .S CNT=CNT+1,@DATA@(CNT)=Y_U_$P(X,U)_U_$P($P(Y,";"),",",2)
 K @GBL
 Q
 ; No alert detail for now
DETAIL(DATA,DFN,AID) ;
 S @DATA@(1)="Detail view not yet implemented."
 Q
