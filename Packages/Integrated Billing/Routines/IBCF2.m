IBCF2	;ALB/ARH - HCFA 1500 19-90 DATA (gather demographics) ; 12-JUN-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
DEV	; IBIFN required
	S %ZIS="Q",%ZIS("A")="Output Device: "
	S %ZIS("B")=$P($G(^IBE(353,+$P($G(^DGCR(399,IBIFN,0)),"^",19),0)),"^",2)
	D ^%ZIS G:POP Q
	I $D(IO("Q")) S ZTRTN="EN^IBCF2",ZTDESC="PRINT HCFA1500",ZTSAVE("IB*")="" D ^%ZTLOAD K IO("Q") D HOME^%ZIS G Q
	U IO D EN
Q	I '$D(ZTQUEUED) D ^%ZISC
	Q
	;
EN	;begin gathering data for printing of HCFA 1500
	;IBIFN must be defined
	K IBFLD
	S IB(0)=$G(^DGCR(399,IBIFN,0)) Q:IB(0)=""
	S DFN=+$P(IB(0),U,2) Q:'$D(^DPT(DFN,0))  D ARRAY
	S IBJ=1 S:'$D(IBPNT) IBPNT=0 S IBFLD(0,1)=$S(IBPNT=1:"",IBPNT=0:"*** COPY OF ORIGINAL BILL ***",IBPNT=2:"*** SECOND NOTICE ***",IBPNT=3:"*** THIRD NOTICE ***",1:""),IBJ=IBJ+1
MAIL	F IBI="M","M1" S IB(IBI)=$G(^DGCR(399,IBIFN,IBI))
	S IBFLD(0,IBJ)=$P(IB("M"),U,4),IBJ=IBJ+1
	F IBI=$P(IB("M"),U,5),$P(IB("M"),U,6),$P(IB("M1"),U,1) I IBI'="" S IBFLD(0,IBJ)=IBI S IBJ=IBJ+1
	S IBFLD(0,IBJ)=$P(IB("M"),U,7)_", "_$$STATE(+$P(IB("M"),U,8))_" "_$P(IB("M"),U,9)
	;
PAT	D DEM^VADPT
	S IBFLD("1A")=$P(VADM(2),U,2) ; ssn
	S IBFLD(2)=VADM(1) ; patient name
	S IBFLD("3D")=$$DATE(+VADM(3)) ; date of birth
	S IBFLD("3X")=$P(VADM(5),U,1) ; sex (m/f)
	S IBFLD("8M")=$S("146"[+VADM(10):"S","25"[+VADM(10):"M",1:"O") ;marital status
	K VADM,VA
	S X=+$P($G(^DPT(DFN,.311)),U,15),IBFLD("8E")=$S(",1,2,4,6,"[X:"E",1:"") ;employed?
	S IBSPE=+$P($G(^DPT(DFN,.25)),U,15),IBSPE=$S(",1,2,4,6,"[IBSPE:"E",1:"") ; spouse employed?
	;
PATADD	D ADD^VADPT
	S IBFLD(5,1)=VAPA(1)_" "_VAPA(2)_" "_VAPA(3) ;patient's street address
	S IBFLD(5,2)=VAPA(4),IBFLD(5,3)=$P(VAPA(11),U,2) ;patient's city, zip
	S IBFLD("5S")=$$STATE(+VAPA(5)) ; patient's state
	S IBFLD("5T")=VAPA(8) ; patients phone number
	K VAPA
	;
NEXT	D ^IBCF21 ; gather remaining data
	;
PRINT	D ^IBCF2P ; print
	;
END	;set print status
	S (DIC,DIE)=399,DA=IBIFN,DR="[IB STATUS]",IBYY=$S($P($G(^DGCR(399,IBIFN,"S")),U,12)="":"@92",1:"@94") D ^DIE K DIC,DIE,IBYY,DA,DR
	D BSTAT^IBCDC(IBIFN) ; remove from AB list
	;
	K DFN,IB,IBI,IBJ,IBX,IBY,IBSPE,IBFLD,IBDXI,X,Y,VAERR
	Q
	;
ARRAY	;
	F IBI=1:1:6 S IBFLD(0,IBI)=""
	F IBI=1:1:16,18:1:21,23:1:26,31:1:33 S IBFLD(IBI)=""
	F IBI=10,16,18 F IBJ="A","B" S IBFLD(IBI_IBJ)=""
	F IBI="10BS","10C","11AX","11B","11C","11D","1A","3D","3X","5S","5T","8E","8M","9A","9BD","9BX","9C","9D" S IBFLD(IBI)=""
	Q
	;
DATE(X)	; returns date in form format
	Q ($E(X,4,5)_" "_$E(X,6,7)_" "_$E(X,2,3))
	;
STATE(X)	; returns 2 letter abbreviation for state pointer
	Q $P($G(^DIC(5,+X,0)),U,2)
