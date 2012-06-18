IBINI016	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.05,1,3,2.1)
	;;=S X=DIV S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
	;;^DD(350,.05,1,3,2.4)
	;;=S DIH=$S($D(^IB(DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,4)=DIV,DIH=350,DIG=14 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350,.05,1,3,"CREATE VALUE")
	;;=NOW
	;;^DD(350,.05,1,3,"DELETE VALUE")
	;;=NOW
	;;^DD(350,.05,1,3,"FIELD")
	;;=#14
	;;^DD(350,.05,1,4,0)
	;;=350^ACT^MUMPS
	;;^DD(350,.05,1,4,1)
	;;=I X=1,$D(^IB(DA,0)),$P($G(^IBE(350.1,+$P(^(0),"^",3),0)),"^")'["ADMISSION",$P(^IB(DA,0),"^",16) S ^IB("ACT",$P(^(0),"^",16),DA)=""
	;;^DD(350,.05,1,4,2)
	;;=I $D(^IB(DA,0)),$P(^(0),"^",16) K ^IB("ACT",$P(^(0),"^",16),DA)
	;;^DD(350,.05,1,4,"%D",0)
	;;=^^11^11^2920115^^^^
	;;^DD(350,.05,1,4,"%D",1,0)
	;;=Cross-reference of all IB ACTIONS for Means Test/Category C charges
	;;^DD(350,.05,1,4,"%D",2,0)
	;;=which have a status of INCOMPLETE (cross-referenced by the parent event
	;;^DD(350,.05,1,4,"%D",3,0)
	;;=(#.16) field).
	;;^DD(350,.05,1,4,"%D",4,0)
	;;= 
	;;^DD(350,.05,1,4,"%D",5,0)
	;;=This is a temporary cross-reference which is used to locate per diem
	;;^DD(350,.05,1,4,"%D",6,0)
	;;=and co-payment charges, for an inpatient/NHCU admission, which are
	;;^DD(350,.05,1,4,"%D",7,0)
	;;=established, but not yet passed to AR.  The cross-reference is set
	;;^DD(350,.05,1,4,"%D",8,0)
	;;=whenever the status of a billable charge is changed to 1 (INCOMPLETE),
	;;^DD(350,.05,1,4,"%D",9,0)
	;;=and killed whenever the parent event (#.16) field is defined.  The
	;;^DD(350,.05,1,4,"%D",10,0)
	;;="ACT1" cross-reference on the parent event field is the companion
	;;^DD(350,.05,1,4,"%D",11,0)
	;;=to this cross-reference.
	;;^DD(350,.05,1,4,"DT")
	;;=2911106
	;;^DD(350,.05,1,5,0)
	;;=350^AH^MUMPS
	;;^DD(350,.05,1,5,1)
	;;=I X=8,$P(^IB(DA,0),U,2) S ^IB("AH",$P(^IB(DA,0),U,2),DA)=""
	;;^DD(350,.05,1,5,2)
	;;=I $P(^IB(DA,0),U,2) K ^IB("AH",$P(^IB(DA,0),U,2),DA)
	;;^DD(350,.05,1,5,"%D",0)
	;;=^^1^1^2920427^^^
	;;^DD(350,.05,1,5,"%D",1,0)
	;;=All mt bills in a hold status.
	;;^DD(350,.05,1,5,"DT")
	;;=2920302
	;;^DD(350,.05,1,6,0)
	;;=350^AI^MUMPS
	;;^DD(350,.05,1,6,1)
	;;=I X=99,$P(^IB(DA,0),U,2) S ^IB("AI",$P(^IB(DA,0),U,2),DA)=""
	;;^DD(350,.05,1,6,2)
	;;=I $P(^IB(DA,0),U,2) K ^IB("AI",$P(^IB(DA,0),U,2),DA)
	;;^DD(350,.05,1,6,"%D",0)
	;;=^^1^1^2920427^^^
	;;^DD(350,.05,1,6,"%D",1,0)
	;;=ALL MT BILLS IN CONVERTED STATUS
	;;^DD(350,.05,1,6,"DT")
	;;=2920427
	;;^DD(350,.05,3)
	;;=
	;;^DD(350,.05,21,0)
	;;=^^19^19^2930823^^^^
	;;^DD(350,.05,21,1,0)
	;;=This is the current status of this entry.  The IB routines will maintain
	;;^DD(350,.05,21,2,0)
	;;=this field.  An entry will be incomplete when it is created, complete
	;;^DD(350,.05,21,3,0)
	;;=when all data needed to pass to AR is there, and Billed after passing to
	;;^DD(350,.05,21,4,0)
	;;=AR and the bill number and/or transaction number have been added.
	;;^DD(350,.05,21,5,0)
	;;= 
	;;^DD(350,.05,21,6,0)
	;;=If the entry represents a billable inpatient/NHCU admission (event), the
	;;^DD(350,.05,21,7,0)
	;;=status will be Incomplete while the patient is admitted, and then
	;;^DD(350,.05,21,8,0)
	;;=Complete when the patient has been discharged.  All entries created
	;;^DD(350,.05,21,9,0)
	;;=during the Means Test conversion will have the status Converted Record.
	;;^DD(350,.05,21,10,0)
	;;= 
	;;^DD(350,.05,21,11,0)
	;;=With Integrated Billing version 2.0, this field is changed from a set
	;;^DD(350,.05,21,12,0)
	;;=of codes field to a pointer which points to the IB ACTION STATUS
	;;^DD(350,.05,21,13,0)
	;;=(#350.21) file.  This change will allow new action statuses to be
