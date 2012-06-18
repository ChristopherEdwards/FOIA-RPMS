IBINI034	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(351.2,.03,21,2,0)
	;;=exposure to Agent Orange, Ionizing Radiation, or Environmental
	;;^DD(351.2,.03,21,3,0)
	;;=Contaminants.
	;;^DD(351.2,.03,"DT")
	;;=2930810
	;;^DD(351.2,.04,0)
	;;=BILLING EVENT^P350'^IB(^0;4^Q
	;;^DD(351.2,.04,1,0)
	;;=^.1
	;;^DD(351.2,.04,1,1,0)
	;;=351.2^AD
	;;^DD(351.2,.04,1,1,1)
	;;=S ^IBE(351.2,"AD",$E(X,1,30),DA)=""
	;;^DD(351.2,.04,1,1,2)
	;;=K ^IBE(351.2,"AD",$E(X,1,30),DA)
	;;^DD(351.2,.04,1,1,"DT")
	;;=2930811
	;;^DD(351.2,.04,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,.04,21,1,0)
	;;=This field points to the event record in the INTEGRATED BILLING ACTION
	;;^DD(351.2,.04,21,2,0)
	;;=(#350) file which may be used to reference all charges associated with
	;;^DD(351.2,.04,21,3,0)
	;;=the admission.
	;;^DD(351.2,.04,"DT")
	;;=2930811
	;;^DD(351.2,.05,0)
	;;=PATIENT STATUS^S^1:ADMITTED;2:DISCHARGED;^0;5^Q
	;;^DD(351.2,.05,21,0)
	;;=^^3^3^2940209^^^
	;;^DD(351.2,.05,21,1,0)
	;;=This field indicates whether the patient is admitted or has been
	;;^DD(351.2,.05,21,2,0)
	;;=discharged.  The field is used to determine if monitoring of the
	;;^DD(351.2,.05,21,3,0)
	;;=billing case should begin.
	;;^DD(351.2,.05,"DT")
	;;=2930810
	;;^DD(351.2,.06,0)
	;;=DATE DISCHARGE ENTERED^D^^0;6^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.2,.06,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,.06,21,1,0)
	;;=This field contains the date that the patient's discharge movement
	;;^DD(351.2,.06,21,2,0)
	;;=was entered into the system.  The date is used as the starting date
	;;^DD(351.2,.06,21,3,0)
	;;=in the 45-day period in which this case must be dispositioned.
	;;^DD(351.2,.06,"DT")
	;;=2930810
	;;^DD(351.2,.07,0)
	;;=CARE RELATED TO CONDITION?^S^0:NO;1:YES;^0;7^Q
	;;^DD(351.2,.07,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,.07,21,1,0)
	;;=This field indicates whether this patient's inpatient episode of
	;;^DD(351.2,.07,21,2,0)
	;;=care has any component at all which is related to the patient's
	;;^DD(351.2,.07,21,3,0)
	;;=claimed exposure.
	;;^DD(351.2,.07,"DT")
	;;=2930810
	;;^DD(351.2,.08,0)
	;;=CASE DISPOSITIONED?^S^0:NO;1:YES;^0;8^Q
	;;^DD(351.2,.08,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,.08,21,1,0)
	;;=This field indicates whether this billing case has been fully
	;;^DD(351.2,.08,21,2,0)
	;;=dispositioned.  Once the case has been dispositioned, then it
	;;^DD(351.2,.08,21,3,0)
	;;=will no longer be monitored by the nightly billing job.
	;;^DD(351.2,.08,"DT")
	;;=2930810
	;;^DD(351.2,1,0)
	;;=REASON FOR NON-BILLING^F^^1;1^K:$L(X)>80!($L(X)<1) X
	;;^DD(351.2,1,3)
	;;=Answer must be 1-80 characters in length.
	;;^DD(351.2,1,21,0)
	;;=^^2^2^2930810^
	;;^DD(351.2,1,21,1,0)
	;;=This field allows the user to enter a free-text comment explaining why
	;;^DD(351.2,1,21,2,0)
	;;=this inpatient episode of care was not billed.
	;;^DD(351.2,1,"DT")
	;;=2930810
	;;^DD(351.2,2.01,0)
	;;=USER ADDING ENTRY^P200'^VA(200,^2;1^Q
	;;^DD(351.2,2.01,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,2.01,21,1,0)
	;;=This field contains a pointer to the user who caused this entry to
	;;^DD(351.2,2.01,21,2,0)
	;;=be created.  This would normally be the user who enters the admission
	;;^DD(351.2,2.01,21,3,0)
	;;=movement for the patient.
	;;^DD(351.2,2.01,"DT")
	;;=2930810
	;;^DD(351.2,2.02,0)
	;;=DATE/TIME ENTRY CREATED^D^^2;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.2,2.02,21,0)
	;;=^^1^1^2930810^
	;;^DD(351.2,2.02,21,1,0)
	;;=This is the date/time that the entry was created.
	;;^DD(351.2,2.02,"DT")
	;;=2930810
	;;^DD(351.2,2.03,0)
	;;=USER LAST UPDATING^P200'^VA(200,^2;3^Q
	;;^DD(351.2,2.03,21,0)
	;;=^^1^1^2930810^
	;;^DD(351.2,2.03,21,1,0)
	;;=This field is a pointer to the user who last updated the entry.
