IBINI062	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.05,1,3,"%D",0)
	;;=^^1^1^2930930^
	;;^DD(356.2,.05,1,3,"%D",1,0)
	;;=Trigger of Primary Health Insurance Policy.
	;;^DD(356.2,.05,1,3,"CREATE CONDITION")
	;;=#1.05=""
	;;^DD(356.2,.05,1,3,"CREATE VALUE")
	;;=S X=$P($$HIP^IBTRC3(DA),"^",1)
	;;^DD(356.2,.05,1,3,"DELETE VALUE")
	;;=@
	;;^DD(356.2,.05,1,3,"DT")
	;;=2930930
	;;^DD(356.2,.05,1,3,"FIELD")
	;;=#1.05
	;;^DD(356.2,.05,1,4,0)
	;;=356.2^ADFN^MUMPS
	;;^DD(356.2,.05,1,4,1)
	;;=S ^IBT(356.2,"ADFN"_X,+^IBT(356.2,DA,0),DA)=""
	;;^DD(356.2,.05,1,4,2)
	;;=K ^IBT(356.2,"ADFN"_X,+^IBT(356.2,DA,0),DA)
	;;^DD(356.2,.05,1,4,"%D",0)
	;;=^^1^1^2931207^^
	;;^DD(356.2,.05,1,4,"%D",1,0)
	;;=cross-reference used for speedy lookups.
	;;^DD(356.2,.05,1,4,"DT")
	;;=2931109
	;;^DD(356.2,.05,21,0)
	;;=^^1^1^2930729^
	;;^DD(356.2,.05,21,1,0)
	;;=Enter the patient that was contacted.  
	;;^DD(356.2,.05,"DT")
	;;=2931109
	;;^DD(356.2,.06,0)
	;;=PERSON CONTACTED^F^^0;6^K:$L(X)>30!($L(X)<3) X
	;;^DD(356.2,.06,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(356.2,.06,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,.06,21,1,0)
	;;=This is the name of the person you contacted.  This is a free text name
	;;^DD(356.2,.06,21,2,0)
	;;=that can be entered.  It is recommended that you use the format of
	;;^DD(356.2,.06,21,3,0)
	;;=Firstname MI Lastname, just as they would say it to you.
	;;^DD(356.2,.06,"DT")
	;;=2930610
	;;^DD(356.2,.07,0)
	;;=CONTACT PHONE #^F^^0;7^K:$L(X)>20!($L(X)<7) X
	;;^DD(356.2,.07,3)
	;;=Answer must be 7-20 characters in length.
	;;^DD(356.2,.07,21,0)
	;;=^^6^6^2930806^
	;;^DD(356.2,.07,21,1,0)
	;;=This is the phone number of the person you contacted.
	;;^DD(356.2,.07,21,2,0)
	;;= 
	;;^DD(356.2,.07,21,3,0)
	;;=If you contacted an insurance company and this number is not in the
	;;^DD(356.2,.07,21,4,0)
	;;=insurance company file, then you may want to enter it into that file
	;;^DD(356.2,.07,21,5,0)
	;;=as well.  The number entered here will only be seen when looking
	;;^DD(356.2,.07,21,6,0)
	;;=at this contact.
	;;^DD(356.2,.07,"DT")
	;;=2930610
	;;^DD(356.2,.08,0)
	;;=INSURANCE COMPANY CONTACTED^P36'^DIC(36,^0;8^Q
	;;^DD(356.2,.08,1,0)
	;;=^.1
	;;^DD(356.2,.08,1,1,0)
	;;=356.2^AIACT^MUMPS
	;;^DD(356.2,.08,1,1,1)
	;;=S:$P(^IBT(356.2,DA,0),U,11) ^IBT(356.2,"AIACT",X,+$P(^(0),U,11),DA)=""
	;;^DD(356.2,.08,1,1,2)
	;;=K ^IBT(356.2,"AIACT",X,+$P(^IBT(356.2,DA,0),U,11),DA)
	;;^DD(356.2,.08,1,1,"%D",0)
	;;=^^2^2^2930811^^
	;;^DD(356.2,.08,1,1,"%D",1,0)
	;;=Index of insurance contacts with actions by patient by action.
	;;^DD(356.2,.08,1,1,"%D",2,0)
	;;=Used primarily to find denials by patient.
	;;^DD(356.2,.08,1,1,"DT")
	;;=2930811
	;;^DD(356.2,.08,5,1,0)
	;;=356.2^1.05^1
	;;^DD(356.2,.08,9)
	;;=^
	;;^DD(356.2,.08,21,0)
	;;=^^2^2^2930729^
	;;^DD(356.2,.08,21,1,0)
	;;=This is the insurance company that is being contacted.  This is
	;;^DD(356.2,.08,21,2,0)
	;;=generally triggered by the HEALTH INSURANCE POLICY field.
	;;^DD(356.2,.08,"DT")
	;;=2930811
	;;^DD(356.2,.09,0)
	;;=CALL REFERENCE NUMBER^F^^0;9^K:$L(X)>15!($L(X)<3) X
	;;^DD(356.2,.09,3)
	;;=Answer must be 3-15 characters in length.
	;;^DD(356.2,.09,21,0)
	;;=^^4^4^2930806^
	;;^DD(356.2,.09,21,1,0)
	;;=If the company you called gave you a reference number for the call
	;;^DD(356.2,.09,21,2,0)
	;;=then enter that reference number here.  Many companies will issue
	;;^DD(356.2,.09,21,3,0)
	;;=reference numbers so that they can track their calls and allow
	;;^DD(356.2,.09,21,4,0)
	;;=reference back to them by others.
	;;^DD(356.2,.09,"DT")
	;;=2930610
	;;^DD(356.2,.1,0)
	;;=APPEAL STATUS^S^1:OPEN;2:PENDING;3:CLOSED;4:REFERED TO DISTRICT COUNSEL;^0;10^Q
