IBINI033	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(351.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(351.2,0,"GL")
	;;=^IBE(351.2,
	;;^DIC("B","SPECIAL INPATIENT BILLING CASES",351.2)
	;;=
	;;^DIC(351.2,"%D",0)
	;;=^^20^20^2940214^^^
	;;^DIC(351.2,"%D",1,0)
	;;=This file is used to track inpatient episodes for Category C veterans
	;;^DIC(351.2,"%D",2,0)
	;;=who have claimed exposure to Agent Orange, Ionizing Radiation, and
	;;^DIC(351.2,"%D",3,0)
	;;=Environmental Contaminants.
	;;^DIC(351.2,"%D",4,0)
	;;= 
	;;^DIC(351.2,"%D",5,0)
	;;=These episodes, which are normally billed automatically by the system,
	;;^DIC(351.2,"%D",6,0)
	;;=require individual review to determine if the care provided was related
	;;^DIC(351.2,"%D",7,0)
	;;=to the claimed exposure.  If the care was determined to be related to
	;;^DIC(351.2,"%D",8,0)
	;;=exposure, the patient should not be billed, but the case disposition 
	;;^DIC(351.2,"%D",9,0)
	;;=must be documented.
	;;^DIC(351.2,"%D",10,0)
	;;= 
	;;^DIC(351.2,"%D",11,0)
	;;=A case record will automatically be filed at admission for this special
	;;^DIC(351.2,"%D",12,0)
	;;=group of patients, and updated when the patient is discharged.  The
	;;^DIC(351.2,"%D",13,0)
	;;=site then has 45 days to disposition the case, i.e. determine if the
	;;^DIC(351.2,"%D",14,0)
	;;=care was related to the claimed exposure.  If the care was unrelated,
	;;^DIC(351.2,"%D",15,0)
	;;=and copayment and per diem charges are created in the Cancel/Edit/Add
	;;^DIC(351.2,"%D",16,0)
	;;=Patient Charges option, the case record will be automatically
	;;^DIC(351.2,"%D",17,0)
	;;=dispositioned.  If the patient is not going to be billed, the reason
	;;^DIC(351.2,"%D",18,0)
	;;=for not billing must be entered into this file.
	;;^DIC(351.2,"%D",19,0)
	;;= 
	;;^DIC(351.2,"%D",20,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(351.2,0)
	;;=FIELD^^2.04^13
	;;^DD(351.2,0,"DDA")
	;;=N
	;;^DD(351.2,0,"DT")
	;;=2930810
	;;^DD(351.2,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DGPM(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(405,.01,0),U,2) D Y^DIQ:Y]"" W "   Adm: ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(351.2,0,"ID",.03)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(351.2,.03,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,3)_"":"",2),$C(59),1)")
	;;^DD(351.2,0,"IX","AC",351.2,.02)
	;;=
	;;^DD(351.2,0,"IX","AD",351.2,.04)
	;;=
	;;^DD(351.2,0,"IX","B",351.2,.01)
	;;=
	;;^DD(351.2,0,"NM","SPECIAL INPATIENT BILLING CASES")
	;;=
	;;^DD(351.2,.01,0)
	;;=PATIENT^RP2'^DPT(^0;1^Q
	;;^DD(351.2,.01,1,0)
	;;=^.1
	;;^DD(351.2,.01,1,1,0)
	;;=351.2^B
	;;^DD(351.2,.01,1,1,1)
	;;=S ^IBE(351.2,"B",$E(X,1,30),DA)=""
	;;^DD(351.2,.01,1,1,2)
	;;=K ^IBE(351.2,"B",$E(X,1,30),DA)
	;;^DD(351.2,.01,3)
	;;=
	;;^DD(351.2,.01,21,0)
	;;=^^1^1^2930810^
	;;^DD(351.2,.01,21,1,0)
	;;=This is the patient whose inpatient episode must be tracked.
	;;^DD(351.2,.01,"DT")
	;;=2930810
	;;^DD(351.2,.02,0)
	;;=ADMISSION^P405'^DGPM(^0;2^Q
	;;^DD(351.2,.02,1,0)
	;;=^.1
	;;^DD(351.2,.02,1,1,0)
	;;=351.2^AC
	;;^DD(351.2,.02,1,1,1)
	;;=S ^IBE(351.2,"AC",$E(X,1,30),DA)=""
	;;^DD(351.2,.02,1,1,2)
	;;=K ^IBE(351.2,"AC",$E(X,1,30),DA)
	;;^DD(351.2,.02,1,1,"DT")
	;;=2930811
	;;^DD(351.2,.02,21,0)
	;;=^^2^2^2930810^
	;;^DD(351.2,.02,21,1,0)
	;;=This field points to the admission in the PATIENT MOVEMENT (#405)
	;;^DD(351.2,.02,21,2,0)
	;;=file which is being tracked.
	;;^DD(351.2,.02,"DT")
	;;=2930811
	;;^DD(351.2,.03,0)
	;;=PATIENT TYPE^S^1:AGENT ORANGE;2:IONIZING RADIATION;3:ENVIRONMENTAL CONTAMINANT;^0;3^Q
	;;^DD(351.2,.03,21,0)
	;;=^^3^3^2930810^
	;;^DD(351.2,.03,21,1,0)
	;;=This field is used to determine whether the patient has claimed
