IBEFUNC	;ALB/RLW - EXTRINSIC FUNCTION ; 12-JUN-92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ETXT(X)	; -- output error message text from 350.8
	; -- input error message code
	N Y S Y=X
	I X="" G ETXTQ
	S Y=$P($G(^IBE(350.8,+$O(^IBE(350.8,"AC",X,0)),0)),"^",2)
ETXTQ	Q Y
	;
IGN(X,Y)	; ignore means test? for appointment type on dates
	; -- input x = mas appointment type
	;          y = date of appointment
	;    output  = true if this appointment type should not be billed for
	;              Cat C Means test billing (352.1,.04) for given date
	;
	I '$G(X)!('$G(Y)) Q 1
	Q +$P($G(^IBE(352.1,+$O(^(+$O(^IBE(352.1,"AIVDT",+X,-(Y+.1))),0)),0)),"^",4)
	;
DSP(X,Y)	; display on input screen?
	; --    input X = mas appointment type (P409.1)
	;             Y = date
	;       output  = true if appointment type X (352.1,.02) should be displayed as a
	;                 potential billable visit (352.1,.06) on the given date Y (352.1,.03)
	;
	I '$G(X)!('$G(Y)) Q 0
	Q +$P($G(^IBE(352.1,+$O(^(+$O(^IBE(352.1,"AIVDT",+X,-(Y+.1))),0)),0)),"^",6)
	;
RPT(X,Y)	; print on report?
	; -- input X = mas appointment type (P409.1)
	;          Y = date
	;    output  = true if appointment type X (352.1,.02) should be printed on 'Vets w/ Ins and Opt
	;               Visits' report (352.1,.05) on the given date Y (352.1,.06)
	;
	I '$G(X)!('$G(Y)) Q 0
	Q +$P($G(^IBE(352.1,+$O(^(+$O(^IBE(352.1,"AIVDT",+X,-(Y+.1))),0)),0)),"^",5)
	;
NBDIS(X,Y)	; Is this disposition non-billable?
	; -- input X = disposition (P37)
	;          Y = date of appointment
	;    output  = true (1) if this disposition should be ignored for
	;              Means test billing (352.2,.03) for the given date
	;
	I '$G(X)!('$G(Y)) Q 0
	Q +$P($G(^IBE(352.2,+$O(^(+$O(^IBE(352.2,"AIVDT",+X,-(Y+.1))),0)),0)),"^",3)
	;
NBCSC(X,Y)	; Is this clinic stop code non-billable?
	; -- input X = clinic stop code (P40.7)
	;          Y = date of appointment
	;    output  = true (1) if this clinic stop code should be ignored for
	;              Means test billing (352.3,.03) for the given date
	;
	I '$G(X)!('$G(Y)) Q 0
	Q +$P($G(^IBE(352.3,+$O(^(+$O(^IBE(352.3,"AIVDT",+X,-(Y+.1))),0)),0)),"^",3)
	;
NBCL(X,Y)	; Is this clinic non-billable?
	; -- input X = clinic (P44)
	;          Y = date of appointment
	;    output  = true (1) if this clinic should be ignored for
	;              Means test billing (352.4,.03) for the given date
	;
	I '$G(X)!('$G(Y)) Q 0
	Q +$P($G(^IBE(352.4,+$O(^(+$O(^IBE(352.4,"AIVDT",+X,-(Y+.1))),0)),0)),"^",3)
	;
PT(DFN)	;returns (patient name^long patient id^short patient id) or null if not found
	N X S X="" I $D(DFN) S X=$G(^DPT(+DFN,0)) I X'="" S X=$P(X,"^",1)_"^"_$P($G(^DPT(DFN,.36)),"^",3,4)
	Q X
	;
EXSET(X,D0,D1)	;returns external value of a set in file D0, field D1
	N Y,Z S Y="" I $G(X)'="",+$G(D0),+$G(D1) S Z=$G(^DD(+D0,+D1,0)) I $P(Z,U,2)["S" S X=X_":",Y=$P($P(Z,X,2),";",1)
	; *****  S Y=X,C=$P(^DD(+D0,+D1,0),"^",2) D Y^DIQ K C  ******
	Q Y
	;
BABCSC(DFN,IBDT)	; -- is there any billable stop codes in the encounter file for patient
	;  -- Input  dfn = patient,
	;           ibdt = date
	;     output     = 1 if any billable stop on date OR 0 if none
	;
	N IBX,IBOE,IBOEDATA,IBY S IBX=0
	I '$G(DFN)!('$G(IBDT)) G BABQ
	S IBY=IBDT\1-.00001 F  S IBY=$O(^SCE("ADFN",DFN,IBY)) Q:'IBY!(IBY>(IBDT+.24))  D  Q:IBX
	.S IBOE=$O(^SCE("ADFN",DFN,IBY,0))
	.Q:'IBOE
	.S IBOEDATA=$G(^SCE(IBOE,0))
	.I $P(IBOEDATA,"^",3),$P(IBOEDATA,"^",12)=2,'$$NBCSC($P(IBOEDATA,"^",3),IBY) S IBX=1
	.Q
BABQ	Q IBX
