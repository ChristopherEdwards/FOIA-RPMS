IBCU3	;ALB/AAS - BILLING UTILITY ROUTINE (CONTINUED)  ;12-FEB-90
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;MAP TO DGCRU3
SC(DFN)	; returns 1 if service connection indicated, 0 otherwise (based on VAEL(3))
	N X,Y S (X,Y)=0 I '$G(DFN) G SCE
	I '$D(VAEL(3)) D ELIG^VADPT S Y=1
	S X=+VAEL(3) I Y K VAEL,VAERR
SCE	Q X
	;
APPT(DATE,DFN,DISP)	;Check date to see if patient has Sched. Appt., add/edit or Registration
	;input:   DATE - required, date to check for appointments
	;         DFN  - required, patient to check for appointments on date
	;         DISP - if true then error message will be printed before exit, if any
	;returns: 1 - if a scheduled visit date was found
	;         2 - if unscheduled/add/edit visit found
	;         3 - disposition found
	;         "0^error message" if no valid visit date found
	;
	N Y,X,X1,X2 S DATE=$P(DATE,".",1),Y="0^* Patient has no Visits for this date..."
	I 'DATE!'$D(^DPT(DFN,0)) S Y="0^Unable to check for appointments on this date!" G APPTE
	S X=DATE,X1=DATE+.9 F  S X=$O(^DPT(DFN,"S",X)) Q:'X!(X>X1)  I $P(^(X,0),"^",2)="" S Y=1
	I $D(^SDV("ADT",DFN,DATE)) S Y=2 G APPTE ; unscheduled appointments
	I $D(^DPT(DFN,"DIS"))>9 S X=(9999999-(DATE+.000001)\1),X1=X+.9 F  S X=$O(^DPT(DFN,"DIS",X)) Q:'X!(X>X1)  S X2=^(X,0) I $P(X2,".",1)=DATE,$P(X2,U,2)<2 S Y=3
APPTE	I +$G(DISP),'Y W !,?10,*7,$P(Y,U,2)
	Q Y
	;
BDT(DFN,DATE)	; returns primary bill defined for an event date, "" if none
	N X,Y S X="" I '$O(^DGCR(399,"C",+$G(DFN),0))!'$G(DATE) G BDTE
	S Y="",DATE=9999999-DATE F  S Y=$O(^DGCR(399,"APDT",+DFN,Y)) Q:'Y  D
	. I $O(^DGCR(399,"APDT",+DFN,Y,0))=DATE,'$P($G(^DGCR(399,Y,"S")),U,16) S X=$P($G(^DGCR(399,Y,0)),U,17) Q
BDTE	Q X
	;
BILLED(PTF)	;returns bill "IFN^^rate group" if PTF record is already associated with an uncancelled final bill
	;returns "bill IFN ^ bill date (stm to) ^ bill rate group" if inpatients interim with no final bill, 0 otherwise
	N IFN,Y,X S Y=0 I '$D(^DGCR(399,"APTF",+$G(PTF))) G BILLEDQ
	S IFN=0 F  S IFN=$O(^DGCR(399,"APTF",PTF,IFN)) Q:'IFN  D  I +Y,'$P(Y,U,2) Q
	. S X=$G(^DGCR(399,IFN,0)) I $P(X,U,13)=7 Q  ; bill cancelled
	. S Y=IFN_"^^"_$P(X,U,7) I $P(X,U,6)=2!($P(X,U,6)=3) S Y=IFN_"^"_$P($G(^DGCR(399,IFN,"U")),U,2)_"^"_$P(X,U,7)
BILLEDQ	Q Y
	;
FTN(FT)	;returns name of the form type passed in, "" if not defined
	N X S X=$P($G(^IBE(353,+$G(FT),0)),U,1)
	Q X
	;
FT(IFN)	;return a bills form type, based on current (399,.19), default (350.9,1.26), and ins co (36,.14) form types
	N X,Y,FTC,FTN,FTD,FTI,INS S X="",IFN=+$G(IFN),Y=$G(^DGCR(399,IFN,0)),FTC=$P(Y,U,19)
	I +FTC,$E($$FTN(FTC),1,3)'="UB-" S X=FTC G FTQ ; not a UB bill, don't change
	; otherwise use the ins co default, then site's default, then current, then UB-82
	S INS=+$G(^DGCR(399,IFN,"M")),FTD=$P($G(^IBE(350.9,1,1)),U,26),FTI=$P($G(^DIC(36,+INS,0)),U,14)
	I 'FTC S X=$S(+FTI:FTI,+FTD:FTD,1:1) G FTQ
	I $E($$FTN(FTI),1,2)="UB" S X=FTI
	I 'X,$E($$FTN(FTD),1,2)="UB" S X=FTD
	I 'X S X=FTC I 'X S X=1
FTQ	Q X
	;
FNT(FTN)	;returns the ifn of the form type name passed in, must be exact match, 0 if none found
	N X,Y S X=0 I $G(FTN)'="" S X=$O(^IBE(353,"B",FTN,0))
	Q X
	;
BILLDEV(IFN,PRT)	;returns the default device for a bill's form type, if PRT is passed as true then returns the AR follow up device, otherwise the billing device
	N X,Y S X=0 I $D(^DGCR(399,+$G(IFN),0)) S PRT=$S(+$G(PRT):3,1:2),Y=$$FT(IFN),X=$P($G(^IBE(353,+Y,0)),U,PRT)
	Q X
	;
RXDUP(RX,DATE,IFN,DISP,DFN,RTG)	;returns bill ifn if rx # exists on another bill
	;input:  rx # - required, rx # to check for
	;        date - required, date of refill
	;ifn, dfn, rtg are optional - if not passed then not used to specify rx
	;(if ifn not passed then returns true if on any bill same or dfn and rtgetc.)
	;if ifn passed the dfn and rtg do not need to be
	N X,LN,RIFN,BIFN,RLN,BLN S (RIFN,X)=0,DATE=$G(DATE),RX=$G(RX),IFN=$G(IFN) I RX=""!('DATE) G RXDUPE
	S LN=$G(^DGCR(399,+IFN,0)),DFN=$S(+$G(DFN):DFN,1:+$P(LN,U,2)),RTG=$S(+$G(RTG):RTG,1:+$P(LN,U,7))
	F  S RIFN=$O(^IBA(362.4,"B",RX,RIFN)) Q:'RIFN  S RLN=$G(^IBA(362.4,+RIFN,0)) I +DATE=+$P(RLN,U,3) D  Q:+X
	. S BIFN=+$P(RLN,U,2),BLN=$G(^DGCR(399,BIFN,0)) Q:(BLN="")!(BIFN=+$G(IFN))
	. I $P(BLN,U,13)=7 Q  ; bill cancelled
	. I +DFN,$P(BLN,U,2)'=DFN Q  ; different patient
	. I +RTG,+RTG'=$P(BLN,U,7) Q  ; different rate group
	. S X=BIFN_"^A "_$P($G(^DGCR(399.3,+$P(BLN,U,7),0)),U,1)_" bill ("_$P(BLN,U,1)_") exists for Rx # "_RX_" and refill date "_$$DAT1^IBOUTL(DATE)_"."
RXDUPE	I +$G(DISP),+X W !,?10,$P(X,U,2)
	Q X
