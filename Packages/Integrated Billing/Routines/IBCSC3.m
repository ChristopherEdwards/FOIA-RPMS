IBCSC3	;ALB/MJB - MCCR SCREEN 3 (PAYER/MAILING ADDRESS)  ;27 MAY 88 10:15
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRSC3
	;
EN	I $D(DGRVRCAL) D ^IBCU6 K DGRVRCAL
	D ^IBCSCU S IBSR=3,IBSR1="",IBV1="000" I IBV S IBV1="111"
	D H^IBCSCU,3^IBCVA0
	F I=0,"M","M1","U" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):(^(I)),1:"")
	S IBOUTP=2,IBINDT=$S(+$G(IB("U")):+IB("U"),1:DT)
	S Z=1,IBW=1 X IBWW W " Rate Type  : ",$S($P(IB(0),U,7)']"":IBU,$D(^DGCR(399.3,$P(IB(0),U,7),0)):$P(^(0),U),1:IBUN)
	I +$P($G(^IBE(350.9,1,1)),U,22) W ?45,"Form Type: ",$P($G(^IBE(353,+$P(IB(0),U,19),0)),U,1)
	W !?4,"Payer      : ",$S($P(IB(0),U,11)']"":IBU,$P(IB(0),U,11)="p":"PATIENT",$P(IB(0),U,11)="i":"INSURER",1:"OTHER")
	I $P(IB(0),U,11)']"" G MAIL
	I $P(IB(0),U,11)="p" G MAIL
	I $P(IB(0),U,11)="o" W !?4,"Inst. Name : ",$S($P(IB("M"),U,11)']"":IBU,$D(^DIC(4,$P(IB("M"),U,11),0)):$P(^(0),U,1),1:"UNKNOWN INSTITUTION") G MAIL
	I $P(IB(0),U,11)="i" I $D(IBDD)>1,$D(^DGCR(399,IBIFN,"AIC")) G SHW
	D UP G LST:$D(IBDD)>1 W !?4,"Insurance : NO REIMBURSABLE INSURANCE INFORMATION ON FILE",!?17,"[Add Insurance Information by entering '1' at the prompt below]" G MAIL
	;W !?4,"Insurance Carrier",?40,"Whose",?66,"Relationship" S X="",$P(X,"=",81)="" W !,X
LST	W ! D HDR^IBCNS
	S IBX="" F  S IBX=$O(IBDD(IBX)) Q:IBX=""  S IBINS=$G(IBDD(IBX,0)) D D1^IBCNS
	;I $D(IBDDI)>1 W !,"Not currently Selectable:" S IBX="" F  S IBX=$O(IBDDI(IBX)) Q:IBX=""  S IBINS=IBDDI(IBX) D D1^IBCNS
	G MAIL
LST1	W !?4,$S($D(^DIC(36,+IBDD(IBX,0),0)):$E($P(^(0),"^",1),1,20),1:"UNKNOWN") S X=$P(IBDD(IBX,0),"^",6) W ?26,$S(X="v":"VETERAN",X="s":"SPOUSE",1:"OTHER") S X=$P(IBDD(IBX,0),"^",16)
	S X=$S(+X=1:"PATIENT",+X=2:"SPOUSE",+X=3:"CHILD",+X=8:"EMPLOYEE",+X=11:"ORGAN DONOR",+X=18:"PARENT",+X=15:"PLANTIFF",1:"UNKNOWN")
	I X="UNKNOWN" S X1=$S($D(IBDD(IBX,0)):$P(IBDD(IBX,0),"^",6),1:""),X=$S(X1="v":"PATIENT",X1="s":"SPOUSE",1:X)
	W ?37,X,?49 S Y=$P(IBDD(IBX,0),"^",8) X ^DD("DD") W Y,?64 S Y=$P(IBDD(IBX,0),"^",4) X ^DD("DD") W Y
	Q
SHW	I $D(IBDD) S I="" F  S I=$O(IBDD(I)) Q:'I  D SHW1
MAIL	S IB("M")=$S($D(^DGCR(399,IBIFN,"M")):^("M"),1:""),IB("M1")=$S($D(^DGCR(399,IBIFN,"M1")):^("M1"),1:""),IB(0)=^DGCR(399,IBIFN,0)
	S Z=2,IBW=1 W ! X IBWW W " Primary Provider #  : ",$P(IB("M1"),U,2),!?4,"Secondary Provider #: ",$P(IB("M1"),U,3),?45,"Tertiary Provider#: ",$P(IB("M1"),U,4)
	S Z=3,IBW=1 W ! X IBWW
	W ?4,"Mailing Address : " S X="" I IB("M")]"" F I=4:1:9 Q:X]""  S X=$P(IB("M"),"^",I)
	I X']"" W !?4,"NO MAILING ADDRESS HAS BEEN SPECIFIED!",!?4,"Send Bill to PAYER listed above." G ^IBCSCP
	S X=IB("M") W !,?4,$S($P(X,"^",4)]"":$P(X,"^",4),1:"'MAIL TO' PERSON/PLACE UNSPECIFIED"),!?4,$S($P(X,"^",5)]"":$P(X,"^",5),1:"STREET ADDRESS UNSPECIFIED") W:$P(X,"^",6)]"" ", ",$P(X,"^",6) W ! W:$P(IB("M1"),"^",1)]"" ?4,$P(IB("M1"),"^",1),", "
	W ?4,$S($P(X,"^",7)]"":$P(X,"^",7),1:"CITY UNSPECIFIED"),", ",$S($D(^DIC(5,+$P(X,"^",8),0)):$P(^(0),"^",2),1:"STATE UNSPECIFIED"),"  ",$S($P(X,"^",9)]"":$P(X,"^",9),1:"ZIP UNSPECIFIED")
	K IBADI,IBDD,IBOUTP,IBINDT,I,X,X1
	G ^IBCSCP
SHW1	W !?4,"Insurance ",I,": " S X=IBDD(I,0),Z=$S($D(^DIC(36,+X,0)):$P(^(0),"^",1),1:IBU) W $E(Z,1,25) W ?45,"Policy #: ",$S($P(X,"^",2)]"":$P(X,"^",2),1:IBU)
	W !?4,"Group #",?15,": ",$S($P(X,"^",3)]"":$P(X,"^",3),1:IBU),?45,"Group Name: ",$S($P(X,"^",15)]"":$P(X,"^",15),1:IBU)
	W !?4,"Whose",?15,": ",$S($P(X,"^",6)="v":"VETERAN",$P(X,"^",6)="s":"SPOUSE",1:"OTHER")
	W ?45,"Sex of Insured: ",$S($D(IBISEX(I)):IBISEX(I),1:IBU),!?4,"Insured",?15,": ",$P(X,"^",17),?45,"Rel. to Insured: ",IBIR(I),!
	Q
	;
UP	K IBDD D ALL^IBCNS1(DFN,"IBDD",1,IBINDT)
	Q
	;IBCSC3
