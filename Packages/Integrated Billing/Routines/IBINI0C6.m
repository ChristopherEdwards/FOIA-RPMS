IBINI0C6	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.95)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(409.95,0,"GL")
	;;=^SD(409.95,
	;;^DIC("B","PRINT MANAGER CLINIC SETUP",409.95)
	;;=
	;;^DIC(409.95,"%D",0)
	;;=^^6^6^2940307^^^^
	;;^DIC(409.95,"%D",1,0)
	;;=This file defines which encounter forms to use for a particular clinic.
	;;^DIC(409.95,"%D",2,0)
	;;= 
	;;^DIC(409.95,"%D",3,0)
	;;=Also, this file can be used to define other forms or reports to print,
	;;^DIC(409.95,"%D",4,0)
	;;=along with the encounter forms. The idea is that for each appointment a
	;;^DIC(409.95,"%D",5,0)
	;;=packet of forms can be printed, saving the effort of collating the forms
	;;^DIC(409.95,"%D",6,0)
	;;=manually.
	;;^DD(409.95,0)
	;;=FIELD^^2^9
	;;^DD(409.95,0,"DDA")
	;;=N
	;;^DD(409.95,0,"DT")
	;;=2930806
	;;^DD(409.95,0,"IX","A",409.9501,.01)
	;;=
	;;^DD(409.95,0,"IX","A1",409.9501,.02)
	;;=
	;;^DD(409.95,0,"IX","AE",409.9502,.01)
	;;=
	;;^DD(409.95,0,"IX","B",409.95,.01)
	;;=
	;;^DD(409.95,0,"IX","C",409.95,.02)
	;;=
	;;^DD(409.95,0,"IX","D",409.95,.03)
	;;=
	;;^DD(409.95,0,"IX","E",409.95,.04)
	;;=
	;;^DD(409.95,0,"IX","F",409.95,.05)
	;;=
	;;^DD(409.95,0,"IX","G",409.95,.06)
	;;=
	;;^DD(409.95,0,"IX","H",409.95,.07)
	;;=
	;;^DD(409.95,0,"NM","PRINT MANAGER CLINIC SETUP")
	;;=
	;;^DD(409.95,.01,0)
	;;=CLINIC^R*P44'^SC(^0;1^S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.01,1,0)
	;;=^.1^^-1
	;;^DD(409.95,.01,1,1,0)
	;;=409.95^B
	;;^DD(409.95,.01,1,1,1)
	;;=S ^SD(409.95,"B",$E(X,1,30),DA)=""
	;;^DD(409.95,.01,1,1,2)
	;;=K ^SD(409.95,"B",$E(X,1,30),DA)
	;;^DD(409.95,.01,3)
	;;=The clinic the print manager setup is for.
	;;^DD(409.95,.01,12)
	;;=Encounter forms are only for clinics.
	;;^DD(409.95,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""C"""
	;;^DD(409.95,.01,21,0)
	;;=^^2^2^2930804^^
	;;^DD(409.95,.01,21,1,0)
	;;= 
	;;^DD(409.95,.01,21,2,0)
	;;=The clinic that the setup is for.
	;;^DD(409.95,.01,"DT")
	;;=2930319
	;;^DD(409.95,.02,0)
	;;=BASIC DEFAULT ENCOUNTER FORM^*P357'^IBE(357,^0;2^S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.02,1,0)
	;;=^.1
	;;^DD(409.95,.02,1,1,0)
	;;=409.95^C
	;;^DD(409.95,.02,1,1,1)
	;;=S ^SD(409.95,"C",$E(X,1,30),DA)=""
	;;^DD(409.95,.02,1,1,2)
	;;=K ^SD(409.95,"C",$E(X,1,30),DA)
	;;^DD(409.95,.02,1,1,"DT")
	;;=2930209
	;;^DD(409.95,.02,3)
	;;=What form will be the default form printed with patient data for a patient with an appointment?
	;;^DD(409.95,.02,12)
	;;=Does not allow tool kit forms or forms of type other than encounter forms.
	;;^DD(409.95,.02,12.1)
	;;=S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1"
	;;^DD(409.95,.02,21,0)
	;;=^^2^2^2930806^^^
	;;^DD(409.95,.02,21,1,0)
	;;= 
	;;^DD(409.95,.02,21,2,0)
	;;=The encounter form that will be printed for every appointment.
	;;^DD(409.95,.02,"DT")
	;;=2930806
	;;^DD(409.95,.03,0)
	;;=SUPPLMNTL FORM - ESTBLSHED PT.^*P357'^IBE(357,^0;3^S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.95,.03,1,0)
	;;=^.1
	;;^DD(409.95,.03,1,1,0)
	;;=409.95^D
	;;^DD(409.95,.03,1,1,1)
	;;=S ^SD(409.95,"D",$E(X,1,30),DA)=""
	;;^DD(409.95,.03,1,1,2)
	;;=K ^SD(409.95,"D",$E(X,1,30),DA)
	;;^DD(409.95,.03,1,1,"DT")
	;;=2930209
	;;^DD(409.95,.03,3)
	;;=What supplemental form should be printed for patients that have been seen before?
	;;^DD(409.95,.03,12)
	;;=Does not allow tool kit forms or forms that are not of type encounter form.
	;;^DD(409.95,.03,12.1)
	;;=S DIC("S")="I '$P($G(^(0)),U,7),$P($G(^(0)),U,4)'>1"
	;;^DD(409.95,.03,21,0)
	;;=^^3^3^2930818^^^
	;;^DD(409.95,.03,21,1,0)
	;;= 
	;;^DD(409.95,.03,21,2,0)
	;;=This is a supplemental form that will print only for patients that have
