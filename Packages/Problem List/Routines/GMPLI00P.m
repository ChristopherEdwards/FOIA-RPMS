GMPLI00P	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011,.08,12.1)
	;;=S DIC("S")="I $P(^(0),U,5)=$P(^AUPNPROB(DA,0),U,2)"
	;;^DD(9000011,.08,21,0)
	;;=^^1^1^2940111^^^
	;;^DD(9000011,.08,21,1,0)
	;;=This is the date this problem was entered into this file.
	;;^DD(9000011,.08,"DT")
	;;=2880307
	;;^DD(9000011,.12,0)
	;;=STATUS^RS^A:ACTIVE;I:INACTIVE;^0;12^Q
	;;^DD(9000011,.12,1,0)
	;;=^.1
	;;^DD(9000011,.12,1,1,0)
	;;=9000011^ACTIVE^MUMPS
	;;^DD(9000011,.12,1,1,1)
	;;=S:$P(^AUPNPROB(DA,0),U,2) ^AUPNPROB("ACTIVE",+$P(^(0),U,2),X,DA)=""
	;;^DD(9000011,.12,1,1,2)
	;;=K ^AUPNPROB("ACTIVE",+$P(^AUPNPROB(DA,0),U,2),X,DA)
	;;^DD(9000011,.12,1,1,"%D",0)
	;;=^^1^1^2930706^^
	;;^DD(9000011,.12,1,1,"%D",1,0)
	;;=Allows problem retrieval by patient and status, in order of entry.
	;;^DD(9000011,.12,1,1,"DT")
	;;=2930706
	;;^DD(9000011,.12,3)
	;;=Enter the current status of this problem, active or inactive.
	;;^DD(9000011,.12,10)
	;;=018/PRSTAT
	;;^DD(9000011,.12,21,0)
	;;=^^3^3^2930406^^
	;;^DD(9000011,.12,21,1,0)
	;;=This is the current activity status of this problem, whether active or
	;;^DD(9000011,.12,21,2,0)
	;;=inactive; if more detail is needed, a notation may be filed with this
	;;^DD(9000011,.12,21,3,0)
	;;=problem.
	;;^DD(9000011,.12,"DT")
	;;=2930706
	;;^DD(9000011,.13,0)
	;;=DATE OF ONSET^D^^0;13^S %DT="E" D ^%DT S X=Y K:DT<X!(1800000>X) X
	;;^DD(9000011,.13,3)
	;;=TYPE A DATE BETWEEN 1880 AND TODAY
	;;^DD(9000011,.13,21,0)
	;;=^^1^1^2930726^^^^
	;;^DD(9000011,.13,21,1,0)
	;;=This is the approximate date this problem appeared, as precisely as known.
	;;^DD(9000011,.13,"DT")
	;;=2930613
	;;^DD(9000011,1.01,0)
	;;=PROBLEM^P757.01'^GMP(757.01,^1;1^Q
	;;^DD(9000011,1.01,1,0)
	;;=^.1
	;;^DD(9000011,1.01,1,1,0)
	;;=9000011^C
	;;^DD(9000011,1.01,1,1,1)
	;;=S ^AUPNPROB("C",$E(X,1,30),DA)=""
	;;^DD(9000011,1.01,1,1,2)
	;;=K ^AUPNPROB("C",$E(X,1,30),DA)
	;;^DD(9000011,1.01,1,1,"DT")
	;;=2930728
	;;^DD(9000011,1.01,3)
	;;=Enter the problem observed for this patient.
	;;^DD(9000011,1.01,21,0)
	;;=^^2^2^2930908^^
	;;^DD(9000011,1.01,21,1,0)
	;;=This field contains the standardized text stored in the Clinical Lexicon
	;;^DD(9000011,1.01,21,2,0)
	;;=for this problem.
	;;^DD(9000011,1.01,"DT")
	;;=2930728
	;;^DD(9000011,1.02,0)
	;;=CONDITION^S^T:TRANSCRIBED;P:PERMANENT;H:HIDDEN;^1;2^Q
	;;^DD(9000011,1.02,21,0)
	;;=^^3^3^2930908^^^
	;;^DD(9000011,1.02,21,1,0)
	;;=This reflects the current condition of this entry, whether transcribed
	;;^DD(9000011,1.02,21,2,0)
	;;=by a clerk from the paper chart, entered or verified by a provider,
	;;^DD(9000011,1.02,21,3,0)
	;;=or marked as removed from the patient's list.
	;;^DD(9000011,1.02,23,0)
	;;=^^6^6^2930908^^
	;;^DD(9000011,1.02,23,1,0)
	;;=This flag is used internally by the DHCP Problem List; entries having
	;;^DD(9000011,1.02,23,2,0)
	;;=an H in this field have been "deleted" and are maintained for historical
	;;^DD(9000011,1.02,23,3,0)
	;;=use but are generally ignored.  If the parameter "Verify Transcribed
	;;^DD(9000011,1.02,23,4,0)
	;;=Entries" is turned on in File #125.99, entries made by a clerk will have
	;;^DD(9000011,1.02,23,5,0)
	;;=a T here, and a flag will appear on the clinician's display of the list.
	;;^DD(9000011,1.02,23,6,0)
	;;=P entries have been entered or verified by a provider.
	;;^DD(9000011,1.02,"DT")
	;;=2930726
	;;^DD(9000011,1.03,0)
	;;=ENTERED BY^P200'^VA(200,^1;3^Q
	;;^DD(9000011,1.03,3)
	;;=Enter the name of the current user.
	;;^DD(9000011,1.03,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011,1.03,21,1,0)
	;;=This is the user who actually entered this problem into this file.
