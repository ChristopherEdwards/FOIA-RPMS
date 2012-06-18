FHIPST3	; HISC/REL - Move Delivery Points ;6/8/94  12:22
	;;5.0;Dietetics;;Oct 11, 1995
	K DP Q:$D(^FH(119.71,1,0))
	W !!,"Create Facility File entries ..."
	K DO,DD S DIC="^FH(119.71,",DIC(0)="L",X="MAIN KITCHEN",DIC("DR")="1///T" D FILE^DICN S PF=+Y
	K DO,DD S DIC="^FH(119.73,",DIC(0)="L",X="COMMUNICATION OFFICE",DIC("DR")="1///T" D FILE^DICN S CF=+Y
	K DD,DO S DIC="^FH(119.74,",DIC(0)="L",X="SUPPLEMENTAL FEEDINGS",DIC("DR")="1///S FDGS;2////^S X=PF" D FILE^DICN S SF=+Y
	S ^FH(119.73,CF,1)=$G(^FH(119.9,1,1)),^FH(119.73,CF,2)=$G(^FH(119.9,1,2))
	S X=$G(^FH(119.9,1,0)),$P(^FH(119.73,CF,2),"^",7,10)=$P(X,"^",5)_"^"_$P(X,"^",7)_"^"_$P(X,"^",9)_"^"_$P(X,"^",10)
	S $P(^FH(119.74,SF,0),"^",4,5)=$P(X,"^",20)_"^"_$P(X,"^",21)
	S $P(X,"^",12)="" S $P(^FH(119.71,PF,0),"^",2,7)=$P(X,"^",11,16)
	F KKK=0:0 S KKK=$O(^FH(119.7,KKK)) Q:KKK<1  S X=$G(^(KKK,0)) D SET
	S X=$G(^FH(119.9,1,0)),SP=$P(X,"^",4)_"^"_$P(X,"^",3)
	F KKK=0:0 S KKK=$O(^FH(119.6,KKK)) Q:KKK<1  S X=$G(^(KKK,0)) D UPD
	Q
SET	S NAM=$P(X,"^",1),NAM=$E(NAM,1,27),SVC=$P(X,"^",4),DP(KKK,"PF")=PF,DP(KKK,"CF")=CF,DP(KKK,"S")=SF,DRSVC=$P(X,"^",5)
	F X="T","C","D" S DP(KKK,X)=""
	I SVC["T" K DD,DO S DIC="^FH(119.72,",DIC(0)="L",X=NAM_" TL",DIC("DR")="1///T;2////^S X=PF" D FILE^DICN S DP(KKK,"T")=+Y D PER
	I SVC["C" K DD,DO S DIC="^FH(119.72,",DIC(0)="L",X=NAM_" CF",DIC("DR")="1///C;2////^S X=PF" D FILE^DICN S DP(KKK,"C")=+Y D PER
	I SVC["D" S DP(KKK,"D")=1
	S ^FH(119.7,KKK,4)=DP(KKK,"T")_"^"_DP(KKK,"C")_"^"_DP(KKK,"D")_"^"_DRSVC D ADD Q
PER	Q:$O(^FH(119.7,KKK,"A",0))=""  S LLL=+Y
	S %X="^FH(119.7,KKK,""A"",",%Y="^FH(119.72,LLL,""A""," D %XY^%RCR
	S $P(^FH(119.72,LLL,"A",0),"^",2)="119.7211P" Q
ADD	Q:$O(^FH(119.7,KKK,"B",0))=""  S LLL=$S(SVC["C":"C",1:"T"),LLL=DP(KKK,LLL) Q:'LLL
	S %X="^FH(119.7,KKK,""B"",",%Y="^FH(119.72,LLL,""B""," D %XY^%RCR
	S $P(^FH(119.72,LLL,"B",0),"^",2)="119.721P" Q
UPD	; Update Dietetic Wards
	S DP=+$P(X,"^",3) S:'$D(DP(DP)) DP="" S $P(^FH(119.6,KKK,0),"^",15,16)=SP
	I DP S SVC="" S:DP(DP,"T") SVC=SVC_"T" S:DP(DP,"C") SVC=SVC_"C" S:DP(DP,"D") SVC=SVC_"D"
	I DP S $P(^FH(119.6,KKK,0),"^",5,10)=DP(DP,"T")_"^"_DP(DP,"C")_"^"_DP(DP,"D")_"^"_DP(DP,"CF")_"^"_DP(DP,"S")_"^"_SVC
	S $P(^FH(119.6,KKK,0),"^",11,14)="3^7^14^3" Q
