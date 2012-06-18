IBINI0C7	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.95)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(409.95,.03,21,3,0)
	;;=been seen in the clinic previously.
	;;^DD(409.95,.03,"DT")
	;;=2930818
	;;^DD(409.95,.04,0)
	;;=SUPPLMNTL FORM - FIRST VISIT^*P357'^IBE(357,^0;4^S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.04,1,0)
	;;=^.1
	;;^DD(409.95,.04,1,1,0)
	;;=409.95^E
	;;^DD(409.95,.04,1,1,1)
	;;=S ^SD(409.95,"E",$E(X,1,30),DA)=""
	;;^DD(409.95,.04,1,1,2)
	;;=K ^SD(409.95,"E",$E(X,1,30),DA)
	;;^DD(409.95,.04,1,1,"DT")
	;;=2930209
	;;^DD(409.95,.04,3)
	;;=What supplemental form should be printed for first time patients?
	;;^DD(409.95,.04,12)
	;;=Does not allow tool kit forms or forms that are not of type encounter form.
	;;^DD(409.95,.04,12.1)
	;;=S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1"
	;;^DD(409.95,.04,21,0)
	;;=^^3^3^2940216^
	;;^DD(409.95,.04,21,1,0)
	;;= 
	;;^DD(409.95,.04,21,2,0)
	;;=This is a supplemental for that will print only for patients that have
	;;^DD(409.95,.04,21,3,0)
	;;=not been seen previously at the clinic.
	;;^DD(409.95,.04,"DT")
	;;=2930806
	;;^DD(409.95,.05,0)
	;;=FORM W/O PATIENT DATA^*P357'^IBE(357,^0;5^S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.05,.1)
	;;=FORM TO PRINT WITH NO PATIENT DATA
	;;^DD(409.95,.05,1,0)
	;;=^.1
	;;^DD(409.95,.05,1,1,0)
	;;=409.95^F
	;;^DD(409.95,.05,1,1,1)
	;;=S ^SD(409.95,"F",$E(X,1,30),DA)=""
	;;^DD(409.95,.05,1,1,2)
	;;=K ^SD(409.95,"F",$E(X,1,30),DA)
	;;^DD(409.95,.05,1,1,"DT")
	;;=2930209
	;;^DD(409.95,.05,3)
	;;=Enter the form that should print in cases where you do not want patient data printed on the form.
	;;^DD(409.95,.05,12)
	;;=Does not allow tool kit forms or forms that are not of type encounter form.
	;;^DD(409.95,.05,12.1)
	;;=S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1"
	;;^DD(409.95,.05,21,0)
	;;=^^4^4^2940216^^^^
	;;^DD(409.95,.05,21,1,0)
	;;= 
	;;^DD(409.95,.05,21,2,0)
	;;=This is the encounter form that should be printed for unscheduled visits.
	;;^DD(409.95,.05,21,3,0)
	;;=It may have a space in the top left hand corner for imprinting the
	;;^DD(409.95,.05,21,4,0)
	;;=embossed patient card or space to write in the name, ssn, etc.
	;;^DD(409.95,.05,"DT")
	;;=2930910
	;;^DD(409.95,.06,0)
	;;=SUPPLMNTL FORM - ALL PATIENTS^*P357'^IBE(357,^0;6^S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.06,1,0)
	;;=^.1
	;;^DD(409.95,.06,1,1,0)
	;;=409.95^G
	;;^DD(409.95,.06,1,1,1)
	;;=S ^SD(409.95,"G",$E(X,1,30),DA)=""
	;;^DD(409.95,.06,1,1,2)
	;;=K ^SD(409.95,"G",$E(X,1,30),DA)
	;;^DD(409.95,.06,1,1,"%D",0)
	;;=^^1^1^2930719^
	;;^DD(409.95,.06,1,1,"%D",1,0)
	;;=Used to find all clinics using this form as a supplemental form for all patients.
	;;^DD(409.95,.06,1,1,"DT")
	;;=2930719
	;;^DD(409.95,.06,3)
	;;=You may require a supplemental form to be used for all appointments for this clinic.
	;;^DD(409.95,.06,12)
	;;=Does not allow tool kit forms or forms that are not of type encounter form.
	;;^DD(409.95,.06,12.1)
	;;=S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1"
	;;^DD(409.95,.06,21,0)
	;;=^^4^4^2940216^^
	;;^DD(409.95,.06,21,1,0)
	;;= 
	;;^DD(409.95,.06,21,2,0)
	;;=This is a supplemental form to be used by all patients of the clinic. A
	;;^DD(409.95,.06,21,3,0)
	;;=form in this category should not also be in one of the other categories
	;;^DD(409.95,.06,21,4,0)
	;;=for supplemental forms, else it will be printed twice.
	;;^DD(409.95,.06,"DT")
	;;=2930806
	;;^DD(409.95,.07,0)
	;;=RESERVED FOR FUTURE USE^P357'^IBE(357,^0;7^Q
