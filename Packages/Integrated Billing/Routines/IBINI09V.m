IBINI09V	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,.01,1,7,"%D",2,0)
	;;=when the bill is created.
	;;^DD(399,.01,1,7,"CREATE CONDITION")
	;;=FORM TYPE=""
	;;^DD(399,.01,1,7,"CREATE VALUE")
	;;=S X=$P($G(^IBE(350.9,1,1)),U,26)
	;;^DD(399,.01,1,7,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(399,.01,1,7,"DT")
	;;=2930608
	;;^DD(399,.01,1,7,"FIELD")
	;;=FORM TYPE
	;;^DD(399,.01,3)
	;;=Enter the "unique" bill number for this billing episode [6 characters].
	;;^DD(399,.01,4)
	;;=
	;;^DD(399,.01,21,0)
	;;=^^8^8^2940317^^^^
	;;^DD(399,.01,21,1,0)
	;;=This is the "unique" bill number assigned to this billing episode.
	;;^DD(399,.01,21,2,0)
	;;=A bill numbers consist of 6 characters.  Beginning with MAS 
	;;^DD(399,.01,21,3,0)
	;;=version 4.7 bill numbers will be determined by the Accounts Receivable
	;;^DD(399,.01,21,4,0)
	;;=module of IFCAP and returned to MCCR.  This is to provide consistency
	;;^DD(399,.01,21,5,0)
	;;=in bill numbering between the sites and CALM.  The bill numbers
	;;^DD(399,.01,21,6,0)
	;;=will be determined from entries in the AR BILL NUMBER file.  They
	;;^DD(399,.01,21,7,0)
	;;=will be in the format of PAT (Pending Account Transaction) numbers
	;;^DD(399,.01,21,8,0)
	;;=and may be used in Accounts Receivable for PAT numbers.
	;;^DD(399,.01,"DT")
	;;=2930608
	;;^DD(399,.02,0)
	;;=PATIENT NAME^RP2'I^DPT(^0;2^Q
	;;^DD(399,.02,1,0)
	;;=^.1
	;;^DD(399,.02,1,1,0)
	;;=399^C
	;;^DD(399,.02,1,1,1)
	;;=S ^DGCR(399,"C",$E(X,1,30),DA)=""
	;;^DD(399,.02,1,1,2)
	;;=K ^DGCR(399,"C",$E(X,1,30),DA)
	;;^DD(399,.02,3)
	;;=Enter the name of the patient for whom this bill is being generated.
	;;^DD(399,.02,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,.02,21,1,0)
	;;=This is the name of the patient for whom this bill is being generated.
	;;^DD(399,.02,"DT")
	;;=2880526
	;;^DD(399,.03,0)
	;;=EVENT DATE^RDX^^0;3^S %DT="ETP",%DT(0)="-0" D ^%DT S X=Y K:Y<1 X I $D(X),'$D(IBNWBL) W !?4,"Event date can no longer be edited...cancel and submit a new bill if necessary." K X
	;;^DD(399,.03,1,0)
	;;=^.1
	;;^DD(399,.03,1,1,0)
	;;=399^D
	;;^DD(399,.03,1,1,1)
	;;=S ^DGCR(399,"D",$E(X,1,30),DA)=""
	;;^DD(399,.03,1,1,2)
	;;=K ^DGCR(399,"D",$E(X,1,30),DA)
	;;^DD(399,.03,1,2,0)
	;;=399^APDT^MUMPS
	;;^DD(399,.03,1,2,1)
	;;=S IBN=$P(^DGCR(399,DA,0),"^",2) S:$D(IBN) ^DGCR(399,"APDT",IBN,DA,9999999-X)="" K IBN
	;;^DD(399,.03,1,2,2)
	;;=S IBN=$P(^DGCR(399,DA,0),"^",2) I $D(IBN) K ^DGCR(399,"APDT",IBN,DA,9999999-X),IBN
	;;^DD(399,.03,1,2,"%D",0)
	;;=^^1^1^2940214^^
	;;^DD(399,.03,1,2,"%D",1,0)
	;;=Cross-reference of bills by patient and event date.
	;;^DD(399,.03,1,3,0)
	;;=399^ABNDT^MUMPS
	;;^DD(399,.03,1,3,1)
	;;=S ^DGCR(399,"ABNDT",DA,9999999-X)=""
	;;^DD(399,.03,1,3,2)
	;;=K ^DGCR(399,"ABNDT",DA,9999999-X)
	;;^DD(399,.03,1,3,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399,.03,1,3,"%D",1,0)
	;;=Cross-reference of bills by inverse event date.
	;;^DD(399,.03,3)
	;;=Enter the date of admission for inpatient episodes of care. For outpatient visits, enter the date of the initial outpatient visit.
	;;^DD(399,.03,21,0)
	;;=^^3^3^2940214^^
	;;^DD(399,.03,21,1,0)
	;;=This is the date on which care was originated. For inpatient episodes of
	;;^DD(399,.03,21,2,0)
	;;=care, this is the admission date. For outpatient visits, this is the date
	;;^DD(399,.03,21,3,0)
	;;=of the initial outpatient visit.
	;;^DD(399,.03,"DT")
	;;=2920220
	;;^DD(399,.04,0)
	;;=LOCATION OF CARE^RS^1:HOSPITAL (INCLUDES CLINIC) - INPT. OR OPT.;2:SKILLED NURSING (NHCU);7:CLINIC (WHEN INDEPENDENT OR SATELLITE);^0;4^Q
	;;^DD(399,.04,.1)
	;;=TYPE OF BILL (1ST DIGIT)
	;;^DD(399,.04,3)
	;;=Enter the code which identifies the type of facility at which care was administered.
