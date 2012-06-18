IBINI02T	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,6.01,21,8,0)
	;;=does not affect the entries that may be added to claims tracking using
	;;^DD(350.9,6.01,21,9,0)
	;;=the add tracking entry action on the main claims tracking screen.
	;;^DD(350.9,6.01,"DT")
	;;=2930804
	;;^DD(350.9,6.02,0)
	;;=INPATIENT CLAIMS TRACKING^S^0:OFF;1:INSURED AND UR ONLY;2:ALL PATIENTS;^6;2^Q
	;;^DD(350.9,6.02,21,0)
	;;=^^13^13^2940209^^^^
	;;^DD(350.9,6.02,21,1,0)
	;;=This field determines what inpatients will automatically be added to
	;;^DD(350.9,6.02,21,2,0)
	;;=the claims tracking module.  If this parameter is set to "OFF" then
	;;^DD(350.9,6.02,21,3,0)
	;;=no new patients will be added.  If this is set to "INSURED AND UR ONLY"
	;;^DD(350.9,6.02,21,4,0)
	;;=then only the insured patients and random sample patients will be added.
	;;^DD(350.9,6.02,21,5,0)
	;;=If this is set to "ALL PATIENTS" then a record of all admissions will
	;;^DD(350.9,6.02,21,6,0)
	;;=be created.
	;;^DD(350.9,6.02,21,7,0)
	;;= 
	;;^DD(350.9,6.02,21,8,0)
	;;=If a patient is not insured then each record will be so annotated 
	;;^DD(350.9,6.02,21,9,0)
	;;=automatically on creation and no follow-up will be required.  The
	;;^DD(350.9,6.02,21,10,0)
	;;=advantage of tracking all patients is that you can determine the
	;;^DD(350.9,6.02,21,11,0)
	;;=percentage of billable cases and make necessary adjustments if the
	;;^DD(350.9,6.02,21,12,0)
	;;=patients are later found to have insurance.  The disadvantage is that
	;;^DD(350.9,6.02,21,13,0)
	;;=additional capacity is used.
	;;^DD(350.9,6.02,"DT")
	;;=2930804
	;;^DD(350.9,6.03,0)
	;;=OUTPATIENT CLAIMS TRACKING^S^0:OFF;1:INSURED ONLY;2:ALL PATIENTS;^6;3^Q
	;;^DD(350.9,6.03,3)
	;;=
	;;^DD(350.9,6.03,21,0)
	;;=^^8^8^2940130^^
	;;^DD(350.9,6.03,21,1,0)
	;;=This field determines if outpatient visit dates will automatically be
	;;^DD(350.9,6.03,21,2,0)
	;;=entered into the claims tracking module.  If this is answered "OFF"
	;;^DD(350.9,6.03,21,3,0)
	;;=then no entries will be entered.  If this is answered "INSURED ONLY"
	;;^DD(350.9,6.03,21,4,0)
	;;=then only outpatient visits for insured patients will be added.
	;;^DD(350.9,6.03,21,5,0)
	;;=If this parameter is set to ALL PATIENTS then the outpatient visits
	;;^DD(350.9,6.03,21,6,0)
	;;=for all patients will be added to claims tracking.
	;;^DD(350.9,6.03,21,7,0)
	;;= 
	;;^DD(350.9,6.03,21,8,0)
	;;=Initially we recommend this parameter be set to INSURED ONLY.
	;;^DD(350.9,6.03,"DT")
	;;=2930804
	;;^DD(350.9,6.04,0)
	;;=PRESCRIPTION CLAIMS TRACKING^S^0:OFF;1:INSURED ONLY;2:ALL PATIENTS;^6;4^Q
	;;^DD(350.9,6.04,3)
	;;=
	;;^DD(350.9,6.04,21,0)
	;;=^^11^11^2940130^^
	;;^DD(350.9,6.04,21,1,0)
	;;=This field determines if prescriptions will automatically be entered
	;;^DD(350.9,6.04,21,2,0)
	;;=into the claims tracking module.  If this is answered "OFF" then
	;;^DD(350.9,6.04,21,3,0)
	;;=no prescriptions or refills will be entered.  If this is answered 
	;;^DD(350.9,6.04,21,4,0)
	;;="INSURED ONLY", then only prescriptions and refills will be added if
	;;^DD(350.9,6.04,21,5,0)
	;;=the patient is insured.  If all is choose then an entry for all
	;;^DD(350.9,6.04,21,6,0)
	;;=prescriptions will be entered.
	;;^DD(350.9,6.04,21,7,0)
	;;= 
	;;^DD(350.9,6.04,21,8,0)
	;;=If a prescription or refill does not appear to be billable, that is it
	;;^DD(350.9,6.04,21,9,0)
	;;=may be for SC care, or there is a visit date associated with that
	;;^DD(350.9,6.04,21,10,0)
	;;=prescription or refill, this will be so noted in the reason not billable.
	;;^DD(350.9,6.04,21,11,0)
	;;= 
	;;^DD(350.9,6.04,"DT")
	;;=2930804
