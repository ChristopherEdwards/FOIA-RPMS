DGHNYXFR ; IHS/ADC/PDW/ENM - HONEYWELL TRANSFER ROUTINE 15:19 ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;
EN Q  ;will be obsolete with v5
 S H=$P($H,",",2),H=DT+(H\3600/100)+(H\60#60/10000),P=$S($D(^DPT(DFN,0)):^(0),1:"") Q:P=""
LOCK L ^HNY(43.2,H):1 I '$T!$D(^HNY(43.2,H)) L  S H=H+.00001 G LOCK
 S (R,^HNY(43.2,H,0))=$P(P,"^",1)_"^"_$P(P,"^",9),^(1)=H_"^"_DUZ,^HNY(43.2,"B",$P(P,"^",1),H)="",^HNY(43.2,"C",H,H)="",^(0)=$P(^HNY(43.2,0),"^",1,2)_"^"_H_"^"_($P(^(0),"^",4)+1),^DISV(DUZ,"^HNY(43.2,")=H L
 D @DGHNYT K DGHNYT,DGHNOSSN Q
1 ; NEW REGISTRATION
 S ^HNY(43.2,H,0)=R_"^^^^1" Q
2 ; ADMISSION
 S A=^DPT(DFN,"DA",DA,0),W=$S($D(^DIC(42,+$P(A,"^",4),0)):$P(^(0),"^",1),1:""),^HNY(43.2,H,0)=R_"^"_W_"^"_$P(A,"^",10)_"^1^2" Q
3 ; TRANSFER
 S T=$S($D(^DPT(DFN,"DA",DFN1,2,DFN2,0)):^(0),1:"") Q:'T  S W=$S($D(^DIC(42,+$P(T,"^",4),0)):$P(^(0),"^",1),1:""),B='(DGTY=1!(DGTY=2)!(DGTY=3))
 S:W="" W=$S($D(^DPT(DFN,.1)):^(.1),1:"") S ^HNY(43.2,H,0)=R_"^"_W_"^"_$P(T,"^",10)_"^"_B_"^3" Q
4 ; DISCHARGE
 S ^HNY(43.2,H,0)=R_"^^^^4" Q
5 ; CLINIC DISCHARGE
 S ^HNY(43.2,H,0)=R_"^^^^5" Q
6 ; NAME CHANGE
 K ^HNY(43.2,"B",$P(R,"^",1),H) S ^HNY(43.2,H,0)=X_"^"_$P(R,"^",2)_"^^^^6^^"_$P(R,"^",1),^HNY(43.2,"B",X,H)="" Q
7 ; SSN CHANGE
 S ^HNY(43.2,H,0)=$P(R,"^",1)_"^"_DGHNOSSN_"^^^^7^"_$P(R,"^",2) Q
8 ; BED CHANGE
 S ^HNY(43.2,H,0)=R_"^"_$S($D(^DPT(DFN,.1)):^(.1),1:"")_"^"_$S($D(^(.101)):^(.101),1:"")_"^1^8" Q
9 ; DELETED ADMISSION
 S ^HNY(43.2,H,0)=R_"^^^^9" Q
10 ; DELETED DISCHARGE
 S ^HNY(43.2,H,0)=R_"^"_$S($D(^DPT(DFN,.1)):^(.1),1:"")_"^"_$S($D(^(.101)):^(.101),1:"")_"^1^10" Q
