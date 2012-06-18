IBINI069	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,1.05,1,1,"CREATE VALUE")
	;;=S X=+$$INSCO^IBTRC2(DA,$P(^IBT(356.2,DA,1),U,5))
	;;^DD(356.2,1.05,1,1,"DELETE VALUE")
	;;=@
	;;^DD(356.2,1.05,1,1,"FIELD")
	;;=#.08
	;;^DD(356.2,1.05,2)
	;;=S Y(0)=Y S Y=$$TRANS^IBTRC2(DA,Y)
	;;^DD(356.2,1.05,2.1)
	;;=S Y=$$TRANS^IBTRC2(DA,Y)
	;;^DD(356.2,1.05,3)
	;;=Select the policy for the insurance company that you contacted.
	;;^DD(356.2,1.05,4)
	;;=D DDHELP^IBTRC2(DA)
	;;^DD(356.2,1.05,5,1,0)
	;;=356.2^.05^3
	;;^DD(356.2,1.05,21,0)
	;;=^^2^2^2940213^^^^
	;;^DD(356.2,1.05,21,1,0)
	;;=Select the policy for this patient that you are contacting the insurance
	;;^DD(356.2,1.05,21,2,0)
	;;=company for.
	;;^DD(356.2,1.05,23,0)
	;;=^^4^4^2940213^^^
	;;^DD(356.2,1.05,23,1,0)
	;;=This field points to the patient insurance type field in the patient file.
	;;^DD(356.2,1.05,23,2,0)
	;;=It is used to do look-ups on the ins. type multiple and to display
	;;^DD(356.2,1.05,23,3,0)
	;;=help.  It is needed because a patient may have more than one entry with
	;;^DD(356.2,1.05,23,4,0)
	;;=the same ins. co. and same policy except for different effective dates.
	;;^DD(356.2,1.05,"DT")
	;;=2931108
	;;^DD(356.2,1.07,0)
	;;=DENY ENTIRE ADMISSION^*S^0:NO;1:YES;^1;7^Q
	;;^DD(356.2,1.07,3)
	;;=
	;;^DD(356.2,1.07,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,1.07,12)
	;;=An entire admission can only be authorized or denied once.
	;;^DD(356.2,1.07,12.1)
	;;=S DIC("S")="I $S(Y:$$DEA^IBTUTL4(DA,Y),1:1)"
	;;^DD(356.2,1.07,21,0)
	;;=^^8^8^2940127^^^
	;;^DD(356.2,1.07,21,1,0)
	;;=If the insurance company denies the entire admission for reimbursement
	;;^DD(356.2,1.07,21,2,0)
	;;=then enter YES.  You will then not asked to enter the Care Denied From
	;;^DD(356.2,1.07,21,3,0)
	;;=and Care Denied To questions for this admission.  If you want to enter
	;;^DD(356.2,1.07,21,4,0)
	;;=the dates care was denied from and to, then answer NO.
	;;^DD(356.2,1.07,21,5,0)
	;;= 
	;;^DD(356.2,1.07,21,6,0)
	;;=If this question is answered YES, then the days denied for this episode
	;;^DD(356.2,1.07,21,7,0)
	;;=will be the admission to discharge date and any report will use the portion
	;;^DD(356.2,1.07,21,8,0)
	;;=of the episode that falls within the date range of the report.   
	;;^DD(356.2,1.07,"DT")
	;;=2940127
	;;^DD(356.2,1.08,0)
	;;=AUTHORIZE ENTIRE ADMISSION^*S^0:NO;1:YES;^1;8^Q
	;;^DD(356.2,1.08,4)
	;;=D HELP^IBTUTL3(DA)
	;;^DD(356.2,1.08,12)
	;;= An entire admission can only be authorized or denied once.
	;;^DD(356.2,1.08,12.1)
	;;=S DIC("S")="I $S(Y:$$AEA^IBTUTL4(DA,Y),1:1)"
	;;^DD(356.2,1.08,21,0)
	;;=^^8^8^2940127^^
	;;^DD(356.2,1.08,21,1,0)
	;;=If the insurance company authorizes the entire admission for reimbursement
	;;^DD(356.2,1.08,21,2,0)
	;;=then enter YES.  You will then not asked to enter the Care Authorized From
	;;^DD(356.2,1.08,21,3,0)
	;;=and Care Authorized To questions for this admission.  If you want to enter
	;;^DD(356.2,1.08,21,4,0)
	;;=the dates care was authorized from and to, then answer NO.
	;;^DD(356.2,1.08,21,5,0)
	;;= 
	;;^DD(356.2,1.08,21,6,0)
	;;=If this question is answered YES, then the days authorized for this episode
	;;^DD(356.2,1.08,21,7,0)
	;;=will be the admission to discharge date and any report will use the portion
	;;^DD(356.2,1.08,21,8,0)
	;;=of the episode that falls within the date range of the report.
	;;^DD(356.2,1.08,"DT")
	;;=2940127
	;;^DD(356.2,11,0)
	;;=COMMENTS^356.211^^11;0
	;;^DD(356.2,11,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.2,11,21,1,0)
	;;=This field is used to store long textual information about the contact.
	;;^DD(356.2,11,21,2,0)
	;;=This may be used to document specific information that is not captured
