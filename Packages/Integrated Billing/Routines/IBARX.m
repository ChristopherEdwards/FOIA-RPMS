IBARX	;ALB/AAS - INTEGRATED BILLING, PHARMACY COPAY INTERFACE ; 14-FEB-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
XTYPE	; - tag XTYPE - returns array of billable action types for service
	;  - see IBARXDOC for documentation
	;
X1	K Y D INSTAL I '$T S Y=-1 Q
	N I,J,X1,X2,DA,DFN S Y=1,IBSAVX=X,IBTAG=1,IBWHER=5
	;
	D CHKX^IBAUTL G:+Y<1 XTYPEQ
	;
	I '$D(^IBE(350.1,"ANEW",IBSERV,1,1)) D  S Y=-1 G XTYPEQ
	.I '$D(ZTQUEUED) W !!,*7,"WARNING: Pharmacy Copay not working,",!,"         Check IB SERVICE/SECTION in Pharmacy Site File.",!!
	.D E3^IBAERR
	;
	N X D ELIG^VADPT,INP^VADPT,DOM S Y=1
	F I=0:0 S I=$O(^IBE(350.1,"ANEW",IBSERV,1,I)) Q:'I  I $D(^IBE(350.1,I,40)) S DA=I X ^IBE(350.1,DA,40) S Y(DA,X)=I_"^"_X1_"^"_X2
	;
XTYPEQ	K X1,X2,IBSERV,VAEL,VA,VAERR,IBDOM,VAIN,IBSAVX,IBTAG,IBWHER
	Q
	;
DOM	S IBDOM=0 I $D(VAIN(4)),$D(^DIC(42,+VAIN(4),0)),$P(^(0),"^",3)="D" S IBDOM=1
	Q
NEW	;  - process new/renew/refill rx for charges
	;  - see IBARXDOC for documentation
	;
N1	K Y,IBSAVX D INSTAL I '$T S Y=-1 Q
	N I,J,X1,X2,DA,DFN
	S IBWHER=1,IBSAVX=X,Y=1,IBTAG=2 D CHKX^IBAUTL I +Y<1 G NEWQ
	I $D(X)<11 S Y="-1^IB010" G NEWQ
	S J="" F  S J=$O(X(J)) Q:J=""  S IBSAVX(J)=X(J)
	D ARPARM^IBAUTL I +Y<1 G NEWQ
	;
	; -- check rx exemption incase refill is exempt
	; -- if exempt set amount to each rx and total to zero
	;    1= exempt, 0= non-exmept, -1=copay off (manilla)
	I +$$RXEXMT^IBARXEU0(DFN,DT)'=0 D  S Y="1^0" G NEWQ
	.S IBJ=""
	.F  S IBJ=$O(IBSAVX(IBJ)) Q:IBJ=""  S Y(IBJ)="^0^"
	.Q
	;
	S IBTOTL=0
	D BILLNO^IBAUTL I +Y<1 G NEWQ
	;
	S IBTOTL=0,IBJ="",IBSEQNO=$P(^IBE(350.1,IBATYP,0),"^",5) I 'IBSEQNO S Y="-1^IB023" G NEWQ
	F  S IBJ=$O(IBSAVX(IBJ)) Q:IBJ=""  S IBX=IBSAVX(IBJ) D RX^IBARX1
	I +Y<1 G NEWQ
	D ^IBAFIL
	S IBJ="" F  S IBJ=$O(IBSAVY(IBJ)) Q:IBJ=""  S Y(IBJ)=IBSAVY(IBJ)
	S:+Y>0 Y="1^"_IBTOTL S X=IBSAVX
	;
NEWQ	D:+Y<1 ^IBAERR
	D END
	Q
	;
INSTAL	I $S($D(^IBE(350.9,1,0)):1,$D(^IB(0)):1,1:0)
	Q
	;
CANCEL	;  - cancel charges for a rx
	;  - see IBARXDOC for documentation
	;
C1	K Y,IBSAVX N I,J,X1,X2,DA,DFN
	S IBWHER=1,IBSAVX=X,Y=1,IBTAG=3 D CHKX^IBAUTL I +Y<1 G CANQ
	I $D(X)<11 S Y="-1^IB010" G CANQ
	S J="" F  S J=$O(X(J)) Q:J=""  S IBSAVX(J)=X(J)
	D ARPARM^IBAUTL I +Y<1 G CANQ
	;
	S IBJ="",IBTOTL=0
	F  S IBJ=$O(IBSAVX(IBJ)) Q:IBJ=""  S IBX=IBSAVX(IBJ) D CANRX^IBARX1 I +IBY(IBJ)'<1 D ^IBAFIL I +Y<1 S IBY(IBJ)=Y
	I +Y<1 S IBT="",IBY=Y,IBM="" F  S IBM=$O(IBY(IBM)) Q:IBM=""  I +IBY(IBM)<1 S Y=IBY(IBM) D ^IBAERR S Y(IBM)=IBY(IBM),Y=IBY
CANQ	D:+Y<1 ^IBAERR:('$D(IBT))
	S X=IBSAVX
	D END
	Q
	;
UPDATE	;  - will cancel current open charge and create updated entry
	;  - see IBARXDOC for documentation
	;
U1	K Y,IBSAVX N I,J,X1,X2,DA,DFN
	S IBWHER=1,IBSAVX=X,Y=1,IBTAG=4 D CHKX^IBAUTL I +Y<1 G UPDQ
	S IBSAVXU=IBSAVX
	I $D(X)<11 S Y="-1^IB010" G UPDQ
	S J="" F  S J=$O(X(J)) Q:J=""  S IBSAVXU(J)=X(J),X(J)=$P(X(J),"^",3,4)
	;
	D CANCEL
U2	K X
	S X=IBSAVXU S J="" F  S J=$O(IBSAVXU(J)) Q:J=""  S X(J)=$P(IBSAVXU(J),"^",1,3)
	S IBSAVX=X,Y=1,IBTAG=4 D CHKX^IBAUTL I +Y<1 G UPDQ
	D ARPARM^IBAUTL I +Y<1 G UPDQ
	;
	; -- check rx exemption incase refill is exempt
	; -- if exempt set amount to each rx and total to zero
	I +$$RXEXMT^IBARXEU0(DFN,DT)'=0 D  S Y="1^0" G UPDQ
	.S IBJ=""
	.F  S IBJ=$O(IBSAVXU(IBJ)) Q:IBJ=""  S Y(IBJ)="^0^"
	.Q
	;
	S IBATYP=$P(^IBE(350.1,+IBATYP,0),"^",7) I '$D(^IBE(350.1,+IBATYP,0)) S Y="-1^IB008" G UPDQ ;update type action
	;
	D BILLNO^IBAUTL G:+Y<1 UPDQ
	S IBTOTL=0,IBNOS="",IBSEQNO=$P(^IBE(350.1,IBATYP,0),"^",5) I 'IBSEQNO S Y="-1^IB023" G UPDQ
	S IBJ="" F  S IBJ=$O(IBSAVXU(IBJ)) Q:IBJ=""  S IBX=IBSAVXU(IBJ) D UCHPAR,RX^IBARX1:'$D(IBSAVY(IBJ))
	D ^IBAFIL
	S IBJ="" F  S IBJ=$O(IBSAVY(IBJ)) Q:IBJ=""  S Y(IBJ)=IBSAVY(IBJ) S:+Y(IBJ)<1 Y=Y(IBJ)
	S:+Y>0 Y="1^"_IBTOTL S X=IBSAVXU
	;
UPDQ	D:+Y<1 ^IBAERR
	K IBSAVXU
END	K %,%H,%I,K,X1,X2,X3,IBSERV,IBATYP,IBAFY,IBDUZ,IBNOW,IBSAVX,IBTOTL,IBX,IBT,IBCHRG,IBDESC,IBFAC,IBIL,IBN,IBNOS,IBSEQNO,IBSITE,IBTAG,IBTRAN,IBCRES,IBJ,IBLAST,IBND,IBY,IBPARNT,IBUNIT,IBJ,IBARTYP,IBI,IBSAVY,IBWHER
	Q
UCHPAR	; Check that IB action and its parent exist.
	S IBPARNT=$P(IBX,"^",3)
	I '$D(^IB(+IBPARNT,0)) S IBSAVY(IBJ)="-1^IB021" G UCHPARQ
	S IBPARNT=$P(^IB(+IBPARNT,0),"^",9)
	I '$D(^IB(+IBPARNT,0)) S IBSAVY(IBJ)="-1^IB027"
UCHPARQ	Q
