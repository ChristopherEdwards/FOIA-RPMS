IBINI032	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(351.1,0,"GL")
	;;=^IBE(351.1,
	;;^DIC("B","IB CONTINUOUS PATIENT",351.1)
	;;=
	;;^DIC(351.1,"%D",0)
	;;=0^^9^9^2940214^^^^
	;;^DIC(351.1,"%D",1,0)
	;;=This file was created as part of v1.5 of Integrated Billing, in
	;;^DIC(351.1,"%D",2,0)
	;;=conjunction with the automation of Means Test/Category C billing.
	;;^DIC(351.1,"%D",3,0)
	;;=This file contains a list of all continuous Hospital or Nursing
	;;^DIC(351.1,"%D",4,0)
	;;=Home Care patients since 7/1/86 who may be subject to Category C
	;;^DIC(351.1,"%D",5,0)
	;;=billing.  These patients are exempt from the co-payment charges,
	;;^DIC(351.1,"%D",6,0)
	;;=but not the per diem charges.  Patients who change their level of care must
	;;^DIC(351.1,"%D",7,0)
	;;=be manually unflagged.
	;;^DIC(351.1,"%D",8,0)
	;;= 
	;;^DIC(351.1,"%D",9,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(351.1,0)
	;;=FIELD^^.06^6
	;;^DD(351.1,0,"DDA")
	;;=N
	;;^DD(351.1,0,"IX","B",351.1,.01)
	;;=
	;;^DD(351.1,0,"NM","IB CONTINUOUS PATIENT")
	;;=
	;;^DD(351.1,.01,0)
	;;=PATIENT^RP2'^DPT(^0;1^Q
	;;^DD(351.1,.01,1,0)
	;;=^.1^^-1
	;;^DD(351.1,.01,1,1,0)
	;;=351.1^B
	;;^DD(351.1,.01,1,1,1)
	;;=S ^IBE(351.1,"B",$E(X,1,30),DA)=""
	;;^DD(351.1,.01,1,1,2)
	;;=K ^IBE(351.1,"B",$E(X,1,30),DA)
	;;^DD(351.1,.01,3)
	;;=Enter the name of the patient who has been a continuous inpatient since July 1, 1986.
	;;^DD(351.1,.01,21,0)
	;;=^^2^2^2911104^^
	;;^DD(351.1,.01,21,1,0)
	;;=This field contains the DFN of the patient who has been a continuous
	;;^DD(351.1,.01,21,2,0)
	;;=inpatient since July 1, 1986.
	;;^DD(351.1,.01,"DT")
	;;=2911101
	;;^DD(351.1,.02,0)
	;;=DISCHARGE DATE^D^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.1,.02,3)
	;;=Enter the date on which the patient is no longer a continuous patient.
	;;^DD(351.1,.02,21,0)
	;;=^^2^2^2920415^^^^
	;;^DD(351.1,.02,21,1,0)
	;;=This is the date on which the patient has been discharged from the hospital
	;;^DD(351.1,.02,21,2,0)
	;;=or nursing home after a continuous stay since July 1,1986.
	;;^DD(351.1,.02,"DT")
	;;=2911101
	;;^DD(351.1,.03,0)
	;;=USER ADDING ENTRY^P200'^VA(200,^0;3^Q
	;;^DD(351.1,.03,9)
	;;=^
	;;^DD(351.1,.03,21,0)
	;;=^^1^1^2911104^^^
	;;^DD(351.1,.03,21,1,0)
	;;=This is the person who is adding the entry to the file.
	;;^DD(351.1,.03,"DT")
	;;=2911008
	;;^DD(351.1,.04,0)
	;;=DATE ENTRY ADDED^D^^0;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.1,.04,9)
	;;=^
	;;^DD(351.1,.04,21,0)
	;;=^^1^1^2911008^^
	;;^DD(351.1,.04,21,1,0)
	;;=This is the date/time that the entry was added to the file.
	;;^DD(351.1,.04,"DT")
	;;=2911008
	;;^DD(351.1,.05,0)
	;;=USER LAST UPDATING^P200'^VA(200,^0;5^Q
	;;^DD(351.1,.05,21,0)
	;;=^^1^1^2940209^^^^
	;;^DD(351.1,.05,21,1,0)
	;;=This is the last user who has edited this entry.
	;;^DD(351.1,.05,"DT")
	;;=2911008
	;;^DD(351.1,.06,0)
	;;=DATE LAST UPDATED^D^^0;6^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(351.1,.06,21,0)
	;;=^^1^1^2911008^
	;;^DD(351.1,.06,21,1,0)
	;;=This is the last date/time that the entry was edited.
	;;^DD(351.1,.06,"DT")
	;;=2911008
