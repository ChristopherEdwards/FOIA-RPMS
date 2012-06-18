IBINI0AH	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,151,1,3,"CREATE VALUE")
	;;=S X=+^DGCR(399,DA,"U"),X=$E(X,2,3)+$S($E(X,4,5)<10:0,1:1)
	;;^DD(399,151,1,3,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,151,1,3,"DT")
	;;=2931018
	;;^DD(399,151,1,3,"FIELD")
	;;=FISCAL YEAR 1
	;;^DD(399,151,3)
	;;=Enter the beginning service date of the period included on this bill.
	;;^DD(399,151,21,0)
	;;=^^3^3^2940208^^^^
	;;^DD(399,151,21,1,0)
	;;=This is the beginning service date of the period covered by this bill.
	;;^DD(399,151,21,2,0)
	;;=A bills date range may not cross either the fiscal or calendar years.
	;;^DD(399,151,21,3,0)
	;;=The date range for inpatient interim bills should not be overlapped.
	;;^DD(399,151,"DT")
	;;=2931018
	;;^DD(399,152,0)
	;;=STATEMENT COVERS TO^RDX^^U;2^S %DT="ETP" D ^%DT S X=Y K:Y<1 X I $D(X) D DDAT1^IBCU4 K IB00
	;;^DD(399,152,1,0)
	;;=^.1
	;;^DD(399,152,1,1,0)
	;;=^^TRIGGER^399^165
	;;^DD(399,152,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,0),U,5)<3 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"U")):^("U"),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X=DIV S X=$$LOS1^IBCU64(DA) X ^DD(399,152,1,1,1.4)
	;;^DD(399,152,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"U")):^("U"),1:""),DIV=X S $P(^("U"),U,15)=DIV,DIH=399,DIG=165 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,152,1,1,2)
	;;=Q
	;;^DD(399,152,1,1,"%D",0)
	;;=^^1^1^2931018^
	;;^DD(399,152,1,1,"%D",1,0)
	;;=Sets Length of Stay based on PTF record and date range of bill.  (Inpatient only.)
	;;^DD(399,152,1,1,"CREATE CONDITION")
	;;=I $P(^DGCR(399,DA,0),U,5)<3
	;;^DD(399,152,1,1,"CREATE VALUE")
	;;=S X=$$LOS1^IBCU64(DA)
	;;^DD(399,152,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,152,1,1,"DT")
	;;=2931018
	;;^DD(399,152,1,1,"FIELD")
	;;=LENGTH OF STAY
	;;^DD(399,152,1,2,0)
	;;=399^AREV3^MUMPS
	;;^DD(399,152,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399,152,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399,152,1,2,"%D",0)
	;;=^^2^2^2940214^
	;;^DD(399,152,1,2,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399,152,1,2,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399,152,3)
	;;=Enter the ending service date of period covered by this bill.
	;;^DD(399,152,21,0)
	;;=^^3^3^2940208^^^
	;;^DD(399,152,21,1,0)
	;;=This is the ending service date of the period covered by this bill.
	;;^DD(399,152,21,2,0)
	;;=A bills date range may not cross either the fiscal or calendar years.
	;;^DD(399,152,21,3,0)
	;;=The date range for inpatient interim bills should not be overlapped.
	;;^DD(399,152,"DT")
	;;=2931018
	;;^DD(399,153,0)
	;;=POWER OF ATTORNEY COMPLETED?^RFOX^^U;3^I $D(X) D YN^IBCU
	;;^DD(399,153,2)
	;;=S Y(0)=Y S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,153,2.1)
	;;=S Y=$S(Y:"YES",Y=0:"NO",1:"")
	;;^DD(399,153,3)
	;;=Enter 'Yes' or '1' if Power of Attorney has been completed, 'No' or '0' if Power of Attorney has not been completed.
	;;^DD(399,153,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,153,21,1,0)
	;;=This identifies whether or not the power of attorney forms (if necessary)
	;;^DD(399,153,21,2,0)
	;;=have been signed.
	;;^DD(399,153,"DT")
	;;=2880607
	;;^DD(399,154,0)
	;;=WHOSE EMPLOYMENT INFO.?^RS^p:PATIENT;s:SPOUSE;^U;4^Q
	;;^DD(399,154,3)
	;;=Enter the code which indicates whether the employment information given applies to the patient or to the patient's spouse.
	;;^DD(399,154,21,0)
	;;=^^2^2^2880901^
	;;^DD(399,154,21,1,0)
	;;=This indicates whether the employment information give applies to the
	;;^DD(399,154,21,2,0)
	;;=patient or to the patient's spouse.
	;;^DD(399,154,"DT")
	;;=2880523
	;;^DD(399,155,0)
	;;=IS THIS A SENSITIVE RECORD?^RFOX^^U;5^I $D(X) D YN^IBCU
