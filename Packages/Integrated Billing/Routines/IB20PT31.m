IB20PT31	;ALB/CPM - IB V2.0 POST INIT, RESOLVE TABLE POINTERS ; 02-SEP-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;
NEWAT	; Add new IB Action Types into file #350.1
	W !!,">>> Adding new IB Action Types into file #350.1..."
	F IBI=1:1 S IBCR=$P($T(NAT+IBI),";;",2) Q:IBCR="QUIT"  D
	.S X=$P(IBCR,"^")
	.I $O(^IBE(350.1,"B",X,0)) W !," >> '",X,"' is already on file..." Q
	.K DD,DO S DIC="^IBE(350.1,",DIC(0)="" D FILE^DICN Q:Y<0
	.S ^(0)=^IBE(350.1,+Y,0)_"^"_$P(IBCR,"^",2,11) S DIK=DIC,DA=+Y D IX1^DIK
	.W !," >> '",$P(IBCR,"^"),"' has been filed..."
	K DA,DIC,DIE,DR,IBI,IBCR,X,Y
	Q
	;
NAT	; Action Types to add into file #350.1
	;;CHAMPVA SUBSISTENCE LIMIT^CVA LIM^^^82^^^CHAMPVA LIMIT
	;;DG CHAMPVA PER DIEM NEW^CVA PD^^^1^^^CHAMPVA SUBSISTENCE^^^6
	;;DG CHAMPVA PER DIEM CANCEL^CAN CPD^^^2
	;;DG CHAMPVA PER DIEM UPDATE^UPD CPD^^^3
	;;QUIT
	;
NEWAC	; Add new IB Action Charges into file #350.2
	W !!,">>> Adding new IB Action Charges into file #350.2..."
	F IBI=1:1 S IBCR=$P($T(NAC+IBI),";;",2) Q:IBCR="QUIT"  D
	.S X=$P(IBCR,"^"),IBF=$O(^IBE(350.2,"B",X,0))
	.I IBF S IBT=0 D  Q:IBT
	..S IBG=0 F  S IBG=$O(^IBE(350.2,"B",X,IBG)) Q:'IBG  D  Q:IBT
	...I $P($G(^IBE(350.2,IBG,0)),"^",2)=$P(IBCR,"^",2) S IBT=1 W !," >> '",X,"' for ",$$DAT1^IBOUTL($P(IBCR,"^",2))," is already on file..." Q
	.;
	.K DD,DO S DIC="^IBE(350.2,",DIC(0)="" D FILE^DICN Q:Y<0
	.S DIE=DIC,DA=+Y,DR=".02////"_$P(IBCR,"^",2)_";.04////"_$P(IBCR,"^",4) D ^DIE
	.W !," >> '",$P(IBCR,"^"),"' has been filed..."
	K DA,DIC,DIE,DR,IBF,IBG,IBI,IBCR,IBT,X,Y
	Q
	;
NAC	; Action Charges to add into file #350.2
	;;CHAMPVA SUBSISTENCE LIMIT^2911001^^25
	;;CHAMPVA PER DIEM^2911001^^8.95
	;;CHAMPVA PER DIEM^2921001^^9.30
	;;QUIT
	;
ATAC	; Resolve pointers to #350.1 from #350.2
	W !!,">>> Updating pointers to file #350.1 from file #350.2 ... "
	F IBI=1:1 S IBX=$P($T(CHG+IBI),";;",2,99) Q:IBX=""  D
	.S IBATYP=$O(^IBE(350.1,"B",$P(IBX,"^",2),0))
	.S IBJ=0 F  S IBJ=$O(^IBE(350.2,"B",$P(IBX,"^"),IBJ)) Q:'IBJ  D
	..S DIE="^IBE(350.2,",DA=IBJ,DR=".03////"_IBATYP
	..D ^DIE K DA,DR,DIE W "."
	K DA,DR,DIE,IBATYP,IBI,IBJ,IBX
	Q
	;
	;
CHG	;Action Charge (#350.2)^Action Type (#350.1)
	;;CHAMPVA SUBSISTENCE LIMIT^CHAMPVA SUBSISTENCE LIMIT
	;;CHAMPVA PER DIEM^DG CHAMPVA PER DIEM NEW
	;
	; - others that may need to be updated
	;
	;;RX1^PSO NSC RX COPAY NEW
	;;RX2^PSO SC RX COPAY NEW
	;;RX3^PSO NSC RX COPAY CANCEL
	;;RX4^PSO NSC RX COPAY UPDATE
	;;RX5^PSO SC RX COPAY CANCEL
	;;RX6^PSO SC RX COPAY UPDATE
	;;MEDICARE 1^IB OPT MEDICARE RATE 1
	;;MEDICARE 2^IB OPT MEDICARE RATE 2
	;;MEDICARE 3^IB OPT MEDICARE RATE 3
	;;MEDICARE 4^IB OPT MEDICARE RATE 4
	;;MEDICARE 5^IB OPT MEDICARE RATE 5
	;;MEDICARE 6^IB OPT MEDICARE RATE 6
	;;MEDICARE 7^IB OPT MEDICARE RATE 7
	;;MEDICARE 8^IB OPT MEDICARE RATE 8
	;;MEDICARE 9^IB OPT MEDICARE RATE 9
	;;INPT PER DIEM^DG INPT PER DIEM NEW
	;;NHCU PER DIEM^DG NHCU PER DIEM NEW
	;;MEDICARE DEDUCTIBLE^MEDICARE DEDUCTIBLE
	;
	;
ATUT	; Resolve pointers to #350.1 from #399.1
	W !!,">>> Updating pointers to file #350.1 from file #399.1 ... "
	F IBI=1:1 S IBX=$P($T(UTL+IBI),";;",2,99) Q:IBX=""  D
	.S IBUTL=$O(^DGCR(399.1,"B",$P(IBX,"^"),0))
	.S IBCP=$O(^IBE(350.1,"B",$P(IBX,"^",2),0))
	.S IBPD=$O(^IBE(350.1,"B",$P(IBX,"^",3),0))
	.S DIE="^DGCR(399.1,",DA=IBUTL,DR=".14////"_IBCP_";.15////"_IBPD
	.D ^DIE K DA,DR,DIE W "."
	;
	; - repoint outpatient copay pointer
	S DA=$O(^DGCR(399.1,"B","OUTPATIENT VISIT",0))
	S IBCP=$O(^IBE(350.1,"B","DG OPT COPAY NEW",0))
	I DA,IBCP S DIE="^DGCR(399.1,",DR=".14////"_IBCP D ^DIE W "."
	K DA,DR,DIE,IBI,IBX,IBUTL,IBCP,IBPD
	Q
	;
UTL	;Utility (#399.1)^Copay Action (#350.1)^Per Diem Action (#350.1)
	;;ALCOHOL AND DRUG TREATMENT^DG INPT COPAY (ALC) NEW^DG INPT PER DIEM NEW
	;;BLIND REHABILITATION^DG INPT COPAY (BLI) NEW^DG INPT PER DIEM NEW
	;;GENERAL MEDICAL CARE^DG INPT COPAY (MED) NEW^DG INPT PER DIEM NEW
	;;INTERMEDIATE CARE^DG INPT COPAY (INT) NEW^DG INPT PER DIEM NEW
	;;NEUROLOGY^DG INPT COPAY (NEU) NEW^DG INPT PER DIEM NEW
	;;NURSING HOME CARE^DG NHCU COPAY NEW^DG NHCU PER DIEM NEW
	;;PSYCHIATRIC CARE^DG INPT COPAY (PSY) NEW^DG INPT PER DIEM NEW
	;;REHABILITATION MEDICINE^DG INPT COPAY (REH) NEW^DG INPT PER DIEM NEW
	;;SPINAL CORD INJURY CARE^DG INPT COPAY (SPI) NEW^DG INPT PER DIEM NEW
	;;SURGICAL CARE^DG INPT COPAY (SUR) NEW^DG INPT PER DIEM NEW
	;