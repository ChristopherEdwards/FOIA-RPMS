IBCVA1	;ALB/MJB - SET MCCR VARIABLES CONT.  ;09 JUN 88 14:49
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRVA1
	;
	Q
4	;Event variables set
	D 1234^IBCVA
	Q:'$D(IBBT)
EN4	I $E(IBBT,2)>2 G OCC
INP	D INP^IBCSC4
	;NOTE (12/1/93): IBDI AND IBDIN ARRAYS WERE NOT UPDATED WITH NEW DX LOCATIONS BECAUSE THEY DO NOT SEEM TO BE USED ANYWHERE
OCC	I $D(^DGCR(399,IBIFN,"C")) F I=14:1:18 S IBDI(I)=$P(^DGCR(399,IBIFN,"C"),"^",I) Q:IBDI(I)=""  S IBDIN(I)=IBDI(I),IBDI(I)=$P(^ICD9(IBDI(I),0),"^",3)
	K IBO S:'$D(^DGCR(399,IBIFN,"OC")) IBO="" G:$D(IBO) COND S IBNO=$P(^DGCR(399,IBIFN,"OC",0),"^",3),IBOC=0
	S C=0 F I=0:1 S IBOC=$O(^DGCR(399,IBIFN,"OC",I)) Q:IBOC'?1N.N!(C=5)  I $D(^DGCR(399,IBIFN,"OC",I)) S C=C+1 D SOCC
	;
COND	S IBCC=0,D=0 F I=0:0 S IBCC=$O(^DGCR(399,IBIFN,"CC",IBCC)) Q:IBCC=""!(D=5)  I $D(^DGCR(399,IBIFN,"CC",IBCC,0)) S D=D+1,IBCC(D)=$P(^DGCR(399,IBIFN,"CC",IBCC,0),"^",1) D CONDN
	;
	D PROC
	;
	;Q:'$D(^DGCR(399,IBIFN,"C"))  F I=0,"C" S IB(I)=$S($D(^DGCR(399,IBIFN,I)):^(I),1:"")
	;I $P(IB(0),"^",9)=4 F I=1:1:3 S:$P(IB("C"),"^",I)'="" IBCPT(I)=$P(IB("C"),"^",I)
	;I $P(IB(0),"^",9)=9 F I=4:1:6 S:$P(IB("C"),"^",I)'="" IBICD(I)=$P(IB("C"),"^",I)
	;I $P(IB(0),"^",9)=5 F I=7:1:9 S:$P(IB("C"),"^",I)]"" IBHC(I)=$P(IB("C"),"^",I),IBHCN(I)=$S($D(^ICPT(IBHC(I),0)):$P(^(0),"^",1),1:"")
	Q
	;
5	;Billing variables set
	D 123^IBCVA
EN5	I '$D(IBIP) G REVC
	S IBLS=$S($P(IB("U"),U,15)]"":$P(IB("U"),U,15),1:0),IBBS=$S($P(IB("U"),U,11)]"":$P(IB("U"),U,11),1:IBU) I IBBS'=IBU S IBBS=$P(^DGCR(399.1,IBBS,0),"^",1)
REVC	S IBREV=0 F I=1:1 S IBREV=$O(^DGCR(399,IBIFN,"RC",IBREV)) Q:IBREV'?1.N  S IBREVC(I)=^DGCR(399,IBIFN,"RC",IBREV,0)
	S IBTF=$P(IB(0),U,6),IBTF=$S(IBTF=1:"ADMIT THRU DISCHARGE",IBTF=2:"FIRST CLAIM",IBTF=3:"CONTINUING CLAIM",IBTF=4:"LAST CLAIM",IBTF=5:"LATE CHARGE(S)",IBTF=6:"ADJUSTMENT",IBTF=7:"REPLACEMENT",IBTF=0:"ZERO CLAIM",1:"")
	Q
SOCC	S IBO(C)=$P(^DGCR(399,IBIFN,"OC",IBOC,0),"^",1),IBO(C)=$P(^DGCR(399.1,IBO(C),0),"^",2)
	S IBOCN(C)=$P(^(0),"^",1),IBOCD(C)=$P(^DGCR(399,IBIFN,"OC",IBOC,0),"^",2),IBOCD2(C)=$P(^DGCR(399,IBIFN,"OC",IBOC,0),"^",4) Q
	Q
	;
CONDN	S IBCCN(D)=$S(IBCC(D)="02":"CONDITION IS EMPLOYMENT RELATED",IBCC(D)="03":"PATIENT COVERED BY INSURANCE NOT REFLECTED HERE",IBCC(D)="05":"LIEN HAS BEEN FILED",1:"")
	I IBCCN(D)="" S IBCCN(D)=$S(IBCC(D)="06":"ESRD PATIENT IN 1ST YEAR OF ENTITLEMENT",IBCC(D)=17:"PATIENT IS OVER 100 YRS. OLD",1:"MAIDEN NAME RETAINED")
	Q
	;
PROC	;  -build array of procedures in IBPROC
	K IBPROC S IBPROC=0
	I '$D(IB("C")) S IB("C")=$G(^DGCR(399,IBIFN,"C"))
	S:'$D(IB(0)) IB(0)=$G(^DGCR(399,IBIFN,0)) S J=$P($G(IB(0)),"^",9)
	I IB("C")'="" F I=1:1:9 I $P(IB("C"),"^",I)'="" S IBPROC(I)=$P(IB("C"),"^",I)_";"_$S(I<4:"ICPT(",I<7:"ICD0(",1:"ICPT(")_"^"_$P(IB("C"),"^",$S(I#3:10+(I#3),1:13)),IBPROC=IBPROC+1
	I $D(^DGCR(399,IBIFN,"CP")) S X=0 F I=100:1 S X=$O(^DGCR(399,IBIFN,"CP",X)) Q:'X  S X1=$G(^(X,0)) Q:'X1  D
	. S IBPROC($S($P(X1,"^",4):$P(X1,"^",4),1:I))=X1,IBPROC=IBPROC+1
PROCQ	Q
	;
VC	;returns a bills value codes, IBIFN must be defined: IBVC=count,IBVC(VIFN)=CODE ^ NAME ^ VALUE ^ $$?
	N IBY,IBX,IBZ S IBVC=0 Q:'$D(^DGCR(399,IBIFN,"CV"))
	S IBX=0 F  S IBX=$O(^DGCR(399,IBIFN,"CV",IBX)) Q:'IBX  S IBY=$G(^DGCR(399,IBIFN,"CV",IBX,0)) I +IBY D
	. S IBVC=IBVC+1,IBZ=$G(^DGCR(399.1,+IBY,0)) Q:IBZ=""
	. S IBVC(+IBY)=$P(IBZ,U,2)_U_$P(IBZ,U,1)_U_$S(+$P(IBZ,U,12):$J($P(IBY,U,2),0,2),1:$P(IBY,U,2))_U_$P(IBZ,U,12)
	Q
	;IBCVA1