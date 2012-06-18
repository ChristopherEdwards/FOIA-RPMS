FHIPST1	; HISC/REL - Post-Init (Move Tubefeeds) ;11/24/92  09:25
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'$D(^FH(119.7))
INP	W !!,"Move Tubefeedings for Inpatients ..."
	S NX="" F  S NX=$O(^DPT("CN",NX)) Q:NX=""  F DFN=0:0 S DFN=$O(^DPT("CN",NX,DFN)) Q:DFN<1  S ADM=$G(^(DFN)) I ADM,$D(^FHPT(DFN,"A",ADM,"TF")) D TF
	Q
ALL	; Move TF for all patients
	W !!,"Move Tubefeedings for all patients ..."
	S CT=0 F DFN=0:0 S DFN=$O(^FHPT(DFN)) Q:DFN<1  F ADM=0:0 S ADM=$O(^FHPT(DFN,"A",ADM)) Q:ADM<1  S CT=CT+1 W:CT#1000=0 "." I $D(^FHPT(DFN,"A",ADM,"TF")) D TF
	Q
TF	F C=0:0 S C=$O(^FHPT(DFN,"A",ADM,"TF",C)) Q:C<1  I '$D(^FHPT(DFN,"A",ADM,"TF",C,"P")) D TF1
	Q
TF1	S Y=$P($G(^FHPT(DFN,"A",ADM,"TF",C,0)),"^",2,9) Q:'Y  S $P(^(0),"^",2,4)="^^",$P(^(0),"^",8,9)="^"
	S ^FHPT(DFN,"A",ADM,"TF",C,"P",0)="^115.1P^1^1"
	S ^FHPT(DFN,"A",ADM,"TF",C,"P",1,0)=$P(Y,"^",1,3)_"^"_$P(Y,"^",7,8)_"^"_$P(Y,"^",6)
	S ^FHPT(DFN,"A",ADM,"TF",C,"P","B",+Y,1)="" Q
