IBRBUL	;ALB/CJM - CAT C HOLD CHARGE BULLETIN ; 02-MAR-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	; This bulletin is sent even if the local site has chosen
	; not to hold Cat C charges. In that case, IBHOLDP should be set = 0.
	; requires: IBDD() = internal node in patient file of valid ins.
	;           DUZ
	;           X = 0 node of IB BILLING ACTION
	;           IBHOLDP = 1 if charge on hold, = 0 otherwise
	;           IBSEQNO = 1 if the charges are new, 3 if updated
BULL	N IBT,IBC,XMSUB,XMY,XMDUZ,XMTEXT,IBX,IBDUZ,IBNAME,IBPID,IBBID,IBAGE,DFN
	S IBC=1,IBX=X,IBDUZ=DUZ
	D PAT,HDR,PATLINE,CHRG,INS,MAIL^IBAERR1
	Q
MAIL	; for testing
	; W !,XMSUB
	; F IBC=1:1 Q:'$D(IBT(IBC))  W !,IBT(IBC)
	Q
HDR	; formated for held charges
	N T,U,SL S T=$S('IBHOLDP:"NOT ON HOLD",1:"ON HOLD"),U=$S(IBSEQNO=1:"NEW ",IBSEQNO=3:"UPDATED ",1:"")
	; if the parent event should have the soft-link that is needed to find
	; the division
	S SL=$P(X,"^",16) S:SL SL=$G(^IB(SL,0)) S:'SL SL=X S SL=$P(SL,"^",4)
	S XMSUB=$E(IBNAME,1,8)_"("_IBBID_")"_"CATC CHRG W/INS"_"-"_$E($$DIV(SL),1,11)
	S IBT(IBC)="The following patient has active insurance and "_U_"Cat C charges "_T_".",IBC=IBC+1
	S IBT(IBC)="You need to immediately process the charges to the insurance company.",IBC=IBC+1
	Q
PAT	; gets patient demographic data
	N VAERR,VADM,X
	S DFN=+$P(IBX,"^",2) D DEM^VADPT I VAERR K VADM
	S IBNAME=$$PR($G(VADM(1)),26),IBAGE=$$PR($G(VADM(4)),3),IBPID=$G(VA("PID")),IBBID=$G(VA("BID"))
	Q
PATLINE	; sets up lines with patient data 
	S IBT(IBC)="",IBC=IBC+1,IBT(IBC)="Name: "_IBNAME_"   Age    : "_IBAGE_"       Pt. ID: "_IBPID,IBC=IBC+1
	Q
CHRG	; gets charge data and sets up charge lines
	N TP,FR,TO
	S Y=$P(IBX,"^",14) D:Y DD^%DT S FR=Y
	S Y=$P(IBX,"^",15) D:Y DD^%DT S TO=Y
	S TP=$P(IBX,"^",3) S:TP TP=$P($G(^IBE(350.1,TP,0)),"^",3) S:TP TP=$P($$CATN^PRCAFN(TP),"^",2)
	S IBT(IBC)="Type: "_$$PR(TP,28)_" Amount : $"_+$P(IBX,"^",7),IBC=IBC+1
	S IBT(IBC)="From: "_$$PR(FR,28)_" To     : "_TO,IBC=IBC+1
	Q
INS	; gets insurance data and sets up insurance lines
	N I,CO,P,G,GNB,W,E,Y,C
	S IBT(IBC)="",IBC=IBC+1,IBT(IBC)="INSURANCE INFORMATION:",IBC=IBC+1
	S I="" F  S I=$O(IBDD(I)) Q:'I  D
	.S CO=$P(IBDD(I),"^",1),CO=$P(^DIC(36,CO,0),"^",1),CO=$$PR(CO,25)
	.S P=$$PR($P(IBDD(I),"^",2),21)
	.S Y=$P(IBDD(I),"^",6),C=$P(^DD(2.312,6,0),"^",2) D Y^DIQ S W=$$PR(Y,25)
	.S Y=$P(IBDD(I),"^",4) D:Y DD^%DT S E=Y
	.S G=$$PR($P(IBDD(I),"^",15),25)
	.S GNB=$P(IBDD(I),"^",3)
	.S IBT(IBC)="Company: "_CO_" Policy#: "_P,IBC=IBC+1
	.S IBT(IBC)="Whose  : "_W_" Expires: "_E,IBC=IBC+1
	.S IBT(IBC)="Group  : "_G_" Group# : "_GNB,IBC=IBC+1
	.S IBT(IBC)="",IBC=IBC+1
	Q
PR(STR,LEN)	; pad right
	N B S STR=$E(STR,1,LEN),$P(B," ",LEN-$L(STR))=" "
	Q STR_$G(B)
DIV(SL)	; returns the division with the softlink as input
	N IBDIV,IBWARD,IBFILE,IBIEN
	S:SL[";" SL=$P(SL,";",1)
	S IBFILE=$P(SL,":",1),IBIEN=$P(SL,":",2)
	S IBDIV=""
	I IBFILE=409.68,IBIEN S IBDIV=$P($G(^SCE(IBIEN,0)),"^",11)
	I IBFILE=44,IBIEN S IBDIV=$P($G(^SC(IBIEN,0)),"^",15)
	I IBFILE=405,IBIEN S IBWARD=$P($G(^DGPM(IBIEN,0)),"^",6) I IBWARD S IBDIV=$P($G(^DIC(42,IBWARD,0)),"^",11)
	I IBDIV S IBDIV=$P($G(^DG(40.8,IBDIV,0)),"^",1)
	I IBDIV="" S IBDIV="DIV UNKNWN"
	Q IBDIV
