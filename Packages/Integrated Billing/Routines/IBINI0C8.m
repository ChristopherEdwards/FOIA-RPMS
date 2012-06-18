IBINI0C8	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.95)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(409.95,.07,1,0)
	;;=^.1
	;;^DD(409.95,.07,1,1,0)
	;;=409.95^H
	;;^DD(409.95,.07,1,1,1)
	;;=S ^SD(409.95,"H",$E(X,1,30),DA)=""
	;;^DD(409.95,.07,1,1,2)
	;;=K ^SD(409.95,"H",$E(X,1,30),DA)
	;;^DD(409.95,.07,1,1,"%D",0)
	;;=^^1^1^2930729^
	;;^DD(409.95,.07,1,1,"%D",1,0)
	;;=Used to track forms assigned to a clinic but not in current use.
	;;^DD(409.95,.07,1,1,"DT")
	;;=2930729
	;;^DD(409.95,.07,3)
	;;=Assign a form to this category if you don't want it to print for appointments.
	;;^DD(409.95,.07,21,0)
	;;=^^2^2^2930729^
	;;^DD(409.95,.07,21,1,0)
	;;=This category was created for clinics to assign new forms that are not yet
	;;^DD(409.95,.07,21,2,0)
	;;=complete without fear that they would be accidently printed.
	;;^DD(409.95,.07,"DT")
	;;=2930729
	;;^DD(409.95,1,0)
	;;=REPORT^409.9501IP^^1;0
	;;^DD(409.95,1,12)
	;;=Allows only package interfaces that print reports or other forms and that are available.
	;;^DD(409.95,1,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1"
	;;^DD(409.95,1,21,0)
	;;=^^4^4^2940216^^
	;;^DD(409.95,1,21,1,0)
	;;= 
	;;^DD(409.95,1,21,2,0)
	;;=This is a list of reports or forms that should be printed under certain
	;;^DD(409.95,1,21,3,0)
	;;=circumstances. The only types of forms or reports that can be printed are
	;;^DD(409.95,1,21,4,0)
	;;=ones that are defined in the Package Interface file.
	;;^DD(409.95,1,"DT")
	;;=2930520
	;;^DD(409.95,2,0)
	;;=EXCLUDED REPORT^409.9502P^^2;0
	;;^DD(409.95,2,12)
	;;=Allows only available package interfaces that print reports.
	;;^DD(409.95,2,12.1)
	;;=S DIC("S")="I $P($G(^(0)),U,6)=4,$P($G(^(0)),U,9)=1"
	;;^DD(409.95,2,21,0)
	;;=^^3^3^2940216^^^^
	;;^DD(409.95,2,21,1,0)
	;;=Used to override reports defined to print for the division. 
	;;^DD(409.95,2,21,2,0)
	;;=Reports defined to print for the division will not print if they are
	;;^DD(409.95,2,21,3,0)
	;;=excluded for the clinic.
	;;^DD(409.9501,0)
	;;=REPORT SUB-FIELD^^.02^2
	;;^DD(409.9501,0,"DT")
	;;=2931110
	;;^DD(409.9501,0,"IX","B",409.9501,.01)
	;;=
	;;^DD(409.9501,0,"NM","REPORT")
	;;=
	;;^DD(409.9501,0,"UP")
	;;=409.95
	;;^DD(409.9501,.01,0)
	;;=REPORT^M*P357.6'^IBE(357.6,^0;1^S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(409.9501,.01,1,0)
	;;=^.1
	;;^DD(409.9501,.01,1,1,0)
	;;=409.9501^B
	;;^DD(409.9501,.01,1,1,1)
	;;=S ^SD(409.95,DA(1),1,"B",$E(X,1,30),DA)=""
	;;^DD(409.9501,.01,1,1,2)
	;;=K ^SD(409.95,DA(1),1,"B",$E(X,1,30),DA)
	;;^DD(409.9501,.01,1,2,0)
	;;=409.95^A^MUMPS
	;;^DD(409.9501,.01,1,2,1)
	;;=I $P(^SD(409.95,DA(1),1,DA,0),U,2) S ^SD(409.95,"A",$P(^SD(409.95,DA(1),0),U),$P(^SD(409.95,DA(1),1,DA,0),U,2),X,DA(1),DA)=""
	;;^DD(409.9501,.01,1,2,2)
	;;=I $P(^SD(409.95,DA(1),1,DA,0),U,2) K ^SD(409.95,"A",$P(^SD(409.95,DA(1),0),U),$P(^SD(409.95,DA(1),1,DA,0),U,2),X,DA(1),DA)
	;;^DD(409.9501,.01,1,2,"%D",0)
	;;=^^6^6^2940216^
	;;^DD(409.9501,.01,1,2,"%D",1,0)
	;;= 
	;;^DD(409.9501,.01,1,2,"%D",2,0)
	;;=Allows all of the reports that should print under certain conditons for the
	;;^DD(409.9501,.01,1,2,"%D",3,0)
	;;=clinic to be found. The subscripts are ^SD(409.95,"A",<clinic ien>,<print
	;;^DD(409.9501,.01,1,2,"%D",4,0)
	;;=condition ien >, <package interface ien>, <clinic setup ien>, <report
	;;^DD(409.9501,.01,1,2,"%D",5,0)
	;;=multiple ien>). It is not necessary to re-index the A1 cross-reference on
	;;^DD(409.9501,.01,1,2,"%D",6,0)
	;;=the PRINT CONDITION field if this field is re-indexed.
	;;^DD(409.9501,.01,1,2,"DT")
	;;=2930518
	;;^DD(409.9501,.01,3)
	;;=You can choose reports and other forms to print under conditions that you specify.
