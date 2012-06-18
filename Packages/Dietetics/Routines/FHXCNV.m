FHXCNV	; HISC/REL - Convert OE/RR to MAS 5 Admissions ;11/17/90  13:09
	;;5.0;Dietetics;;Oct 11, 1995
	S CUT="",ORIFN=$O(^OR(100,0)) I ORIFN>0 S CUT=$P($G(^OR(100,ORIFN,0)),"^",7)
	I CUT<1 W !!,"There do not appear to be any OE/RR orders. Conversion NOT necessary.",!! Q
	S Y=CUT,CUT=CUT\1 X ^DD("DD") W !!,"The first OE/RR order was entered ",Y
	W !,"Admissions not discharged before this date will be converted.",!
	F DFN=.9:0 S DFN=$O(^FHPT(DFN)) Q:DFN<1  F ADM=0:0 S ADM=$O(^FHPT(DFN,"A",ADM)) Q:ADM<1  D ADM
KIL	K CUT,DFN,ADM,FHDR,ORIFN,Y Q
ADM	S Y=$P($G(^DGPM(ADM,0)),"^",17) S:Y>0 Y=$P($G(^DGPM(+Y,0)),"^",1)
	I Y,Y<CUT Q
	S ORIFN=$P($G(^FHPT(DFN,"A",ADM,0)),"^",13) I ORIFN>0 D SET
	F FHDR=0:0 S FHDR=$O(^FHPT(DFN,"A",ADM,"DI",FHDR)) Q:FHDR<1  S ORIFN=$P($G(^(FHDR,0)),"^",14) I ORIFN>0 D SET
	F FHDR=0:0 S FHDR=$O(^FHPT(DFN,"A",ADM,"OO",FHDR)) Q:FHDR<1  S ORIFN=$P($G(^(FHDR,0)),"^",8) I ORIFN>0 D SET
	F FHDR=0:0 S FHDR=$O(^FHPT(DFN,"A",ADM,"EL",FHDR)) Q:FHDR<1  S ORIFN=$P($G(^(FHDR,0)),"^",7) I ORIFN>0 D SET
	F FHDR=0:0 S FHDR=$O(^FHPT(DFN,"A",ADM,"DR",FHDR)) Q:FHDR<1  S ORIFN=$P($G(^(FHDR,0)),"^",13) I ORIFN>0 D SET
	F FHDR=0:0 S FHDR=$O(^FHPT(DFN,"A",ADM,"TF",FHDR)) Q:FHDR<1  S ORIFN=$P($G(^(FHDR,0)),"^",14) I ORIFN>0 D SET
	Q
SET	I $D(^OR(100,ORIFN,4)) S $P(^(4),"^",1)=ADM
	Q
