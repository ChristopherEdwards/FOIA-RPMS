IBINI02N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.9)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.9,2.06,21,0)
	;;=^^1^1^2920204^
	;;^DD(350.9,2.06,21,1,0)
	;;=This is the phone number for the agent cashier.
	;;^DD(350.9,2.06,"DT")
	;;=2920204
	;;^DD(350.9,2.07,0)
	;;=CANCELLATION REMARK FOR FISCAL^F^^2;7^K:$L(X)>75!($L(X)<3)!'(X?1A.E) X
	;;^DD(350.9,2.07,3)
	;;=Enter the remark (reason for cancellation) which will be sent to Fiscal Service every time a bill is cancelled in MAS.  Answer must be 3-75 characters in length.
	;;^DD(350.9,2.07,21,0)
	;;=^^6^6^2940209^^
	;;^DD(350.9,2.07,21,1,0)
	;;=This is the remark which will be sent to Fiscal every time a bill is
	;;^DD(350.9,2.07,21,2,0)
	;;=cancelled in MAS.  This remark will explain to Fiscal why the IFCAP
	;;^DD(350.9,2.07,21,3,0)
	;;=billing record is being amended or cancelled.  The generic remark,
	;;^DD(350.9,2.07,21,4,0)
	;;="BILL CANCELLED IN MAS" will be transmitted to Fiscal Service if no
	;;^DD(350.9,2.07,21,5,0)
	;;=remark is entered in this field.  The site may enter any remark which
	;;^DD(350.9,2.07,21,6,0)
	;;=is meaningful to MAS and Fiscal.
	;;^DD(350.9,2.07,"DT")
	;;=2920204
	;;^DD(350.9,3.01,0)
	;;=*CONVERSION LAST BILL DATE^D^^3;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.01,21,0)
	;;=^^10^10^2940127^^^
	;;^DD(350.9,3.01,21,1,0)
	;;=This field will only be used for the Means Test conversion which is part
	;;^DD(350.9,3.01,21,2,0)
	;;=of the Integrated Billing v1.5 post init.  The field will be deleted
	;;^DD(350.9,3.01,21,3,0)
	;;=with the next version of Integrated Billing.
	;;^DD(350.9,3.01,21,4,0)
	;;= 
	;;^DD(350.9,3.01,21,5,0)
	;;=This field is updated during the IB v1.5 post init.  The value of this
	;;^DD(350.9,3.01,21,6,0)
	;;=field designates the last day through which Means Test charges will be
	;;^DD(350.9,3.01,21,7,0)
	;;=created during the conversion.
	;;^DD(350.9,3.01,21,8,0)
	;;= 
	;;^DD(350.9,3.01,21,9,0)
	;;=Please note that this field has been starred for deletion in IB v2.0.
	;;^DD(350.9,3.01,21,10,0)
	;;=This field will be deleted in the version of IB which follows v2.0.
	;;^DD(350.9,3.01,"DT")
	;;=2940127
	;;^DD(350.9,3.02,0)
	;;=*CONVERSION BREAK DATE^D^^3;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.9,3.02,3)
	;;=
	;;^DD(350.9,3.02,21,0)
	;;=^^17^17^2940209^^^^
	;;^DD(350.9,3.02,21,1,0)
	;;=This field will only be used for the Means Test conversion which is part
	;;^DD(350.9,3.02,21,2,0)
	;;=of the Integrated Billing v1.5 post init.  The field will be deleted
	;;^DD(350.9,3.02,21,3,0)
	;;=with the next version of Integrated Billing.
	;;^DD(350.9,3.02,21,4,0)
	;;= 
	;;^DD(350.9,3.02,21,5,0)
	;;=This field is updated during the IB v1.5 post init.  The value of this
	;;^DD(350.9,3.02,21,6,0)
	;;=field is used by the conversion when creating Hospital/NHCU per diem
	;;^DD(350.9,3.02,21,7,0)
	;;=charges.  If a patient owes the per diem on this date, and has
	;;^DD(350.9,3.02,21,8,0)
	;;=accumulated other charges prior to this date, a charge is filed for
	;;^DD(350.9,3.02,21,9,0)
	;;=all previous charges up through the date.  The intent of "splitting"
	;;^DD(350.9,3.02,21,10,0)
	;;=charges in this manner is to allow facilities to select a "final" date
	;;^DD(350.9,3.02,21,11,0)
	;;=through which Means Test billing will have been completed
	;;^DD(350.9,3.02,21,12,0)
	;;=manually so that charges created by the conversion may
	;;^DD(350.9,3.02,21,13,0)
	;;=easily be passed to the Accounts Receivable package (and thus billed
	;;^DD(350.9,3.02,21,14,0)
	;;=to the patient).
	;;^DD(350.9,3.02,21,15,0)
	;;= 
	;;^DD(350.9,3.02,21,16,0)
	;;=Please note that this field has been starred for deletion in IB v2.0.
