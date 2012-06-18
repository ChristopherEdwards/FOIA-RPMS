IBCD3	;ALB/ARH - AUTOMATED BILLER (ADD NEW BILL - CREATE BILL ENTRY)  ; 9/5/93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
	N IBI,IBX,IBY,I,X,IBAC K IBDR S IBAC=1
	S X=$P($T(WHERE),";;",2) F I=0:0 S I=$O(IB(I)) Q:'I  S X1=$P($E(X,$F(X,I)+1,999),";",1) I $D(IB(I))=1 S $P(IBDR($P(X1,"^",1)),"^",$P(X1,"^",2))=IB(I)
	F I=0,"C","M","M1","S","U","U1" I $D(IBDR(I)) S ^DGCR(399,IBIFN,I)=IBDR(I)
	S $P(^DGCR(399,0),"^",3)=IBIFN,$P(^(0),"^",4)=$P(^(0),"^",4)+1
	S DIK="^DGCR(399,",DA=IBIFN D IX1^DIK K DA,DIK ; set cross-references
	;
RX	; file rx refills, add default CPT and Dx if defined
	I $D(IB(362.4))>2 D  G END
	. S IBRX=0 F  S IBRX=$O(IB(362.4,IBRX)) Q:'IBRX  S IBY=0 F  S IBY=$O(IB(362.4,IBRX,IBY)) Q:'IBY  D
	.. S IBX=IB(362.4,IBRX,IBY) Q:IBX=""
	.. S DIC="^IBA(362.4,",DIC(0)="L",X=$P(IBX,U,1) K DD,DO D FILE^DICN K DA,DINUM,DO,DD
	.. I Y>0 S DIE=DIC,DA=+Y,DR=".02////"_IBIFN_";.03////"_$P(IBX,U,4)_";.04////"_$P(IBX,U,2)_";.05////"_+IBRX_";.06////"_$P(IBX,U,3)_";.07////"_$P(IBX,U,5)_";.08////"_$P(IBX,U,6) D ^DIE K DIE,DIC,DA,DR
	. ;
	. D DEFAULT^IBCSC5C(IBIFN)
	;
OUTPT	;file outpatient visit dates and find/store outpatient procedures and diagnosis
	I IB(.05)>2 D  G END
	. I $D(IB(43))>2 D
	.. S ^DGCR(399,IBIFN,"OP",0)="^399.043DA^" S IBX=0 F  S IBX=$O(IB(43,IBX)) Q:'IBX  D
	... S DIC="^DGCR(399,"_IBIFN_",""OP"",",DIC(0)="L",DA(1)=IBIFN,(DINUM,X)=IBX K DD,DO D FILE^DICN K DIC,DA,DINUM,DO,DD
	. ;
	. D VST^IBCCPT I $D(^UTILITY($J,"CPT-CNT")) D
	.. S ^DGCR(399,IBIFN,"CP",0)="^399.0304AVI^"
	.. S IBY=0 F  S IBY=$O(^UTILITY($J,"CPT-CNT",IBY)) Q:'IBY  S IBX=^(IBY) D
	... S DIC="^DGCR(399,"_IBIFN_",""CP"",",DIC(0)="L",DA(1)=IBIFN,X=+IBX_";ICPT(" K DD,DO D FILE^DICN
	... I Y>0 S DIE=DIC,DA=+Y,DR="1////"_$P(IBX,U,2)_$S(+$P(IBX,U,4):";5////"_$P(IBX,U,5),1:"") D ^DIE K DIE,DIC,DA,DINUM,DO,DD
	. K DGCNT,V,IBOPV1,IBOPV2,I,DGDIV,I1,DGNOD,DGCPTS,I7,I2,DGCPT,^UTILITY($J,"CPT-CNT")
	. ;
	. D OPTDX^IBCSC4D(DFN,IB(151),IB(152),.IBDX) I +IBDX D  K IBDX
	.. S IBY=0 F  S IBY=$O(IBDX(IBY)) Q:IBY=""  S IBX=IBDX(IBY) D
	... S DIC="^IBA(362.3,",DIC(0)="L",X=+IBX K DD,DO D FILE^DICN
	... I Y>0 S DIE=DIC,DA=+Y,DR=".02////"_IBIFN D ^DIE K DIE,DIC,DA,DINUM,DO,DD
	;
	;store inpatient diagnosis and procedures
INPT	I IB(.05)<3 D  G END
	. I $G(^TMP("IBDX",$J))=IB(.08) D  K ^TMP("IBDX",$J)
	.. S (IBI,IBX)=0 F  S IBX=$O(^TMP("IBDX",$J,IBX)) Q:'IBX  S IBI=IBI+1 D
	... S DIC="^IBA(362.3,",DIC(0)="L",X=+IBX K DD,DO D FILE^DICN
	... I Y>0 S DIE=DIC,DA=+Y,DR=".02////"_IBIFN_";.03////"_IBI D ^DIE K DIE,DIC,DA,DINUM,DO,DD
	. ;
	. D IPRC^IBCD4(+IB(.08),IB(151),IB(152)) I $D(^TMP("IBIPRC",$J)) D  K ^TMP("IBIPRC",$J)
	.. S ^DGCR(399,IBIFN,"CP",0)="^399.0304AVI^"
	.. S IBX=0 F  S IBX=$O(^TMP("IBIPRC",$J,IBX)) Q:'IBX  D
	... S IBY=^TMP("IBIPRC",$J,IBX) F IBI=1:1 S IBZ=$P(IBY,U,IBI) Q:'IBZ  D
	.... S DIC="^DGCR(399,"_IBIFN_",""CP"",",DIC(0)="L",DA(1)=IBIFN,X=+IBZ_";ICD0(" K DD,DO D FILE^DICN
	.... I Y>0 S DIE=DIC,DA=+Y,DR="1////"_IBX D ^DIE K DIE,DIC,DA,DINUM,DO,DD
	;
END	S IBX="1^Billing Record #"_$P(^DGCR(399,+IBIFN,0),"^",1)_" established for "_$P($G(^DPT(IBDFN,0)),U,1)
	;
	S IBAUTO=1,DGPTUPDT="" D ^IBCU6 ; auto calculate/store revenue codes
	;
Q	K %,%DT,IBDR,X1,X2,X3,X4,Y,DGDIRA,DGDIRB,DGDIR0,DIR,DGRVRCAL,DIC,DA,DINUM,DGPTUPDT,DGXRF1,IBCHK,IBINDT
	Q
	;
WHERE	;;.01^0^1;.02^0^2;.03^0^3;.04^0^4;.05^0^5;.06^0^6;.07^0^7;.08^0^8;.09^0^9;.11^0^11;.17^0^17;.16^0^16;.18^0^18;.19^0^19;.2^0^20;112^M^12;151^U^1;152^U^2;155^U^5;101^M^1;158^U^8;159^U^9;160^U^10;161^U^11;162^U^12;
