IBINI068	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356.2,.28,1,1,"DT")
	;;=2930729
	;;^DD(356.2,.28,3)
	;;=Answer must be 3-18 characters in length.
	;;^DD(356.2,.28,21,0)
	;;=6^^6^6^2940213^
	;;^DD(356.2,.28,21,1,0)
	;;=Enter the treatment authorization number that the insurance company gave
	;;^DD(356.2,.28,21,2,0)
	;;=you during this contact.
	;;^DD(356.2,.28,21,3,0)
	;;= 
	;;^DD(356.2,.28,21,4,0)
	;;=The data in this field if it exists will be considered the Treatment
	;;^DD(356.2,.28,21,5,0)
	;;=Authorization code for this care and will automatically used by the
	;;^DD(356.2,.28,21,6,0)
	;;=billing module.
	;;^DD(356.2,.28,"DT")
	;;=2931220
	;;^DD(356.2,.29,0)
	;;=FINAL OUTCOME OF APPEAL^S^1:APPROVED;2:DENIED;3:PARITIAL APPROVAL;^0;29^Q
	;;^DD(356.2,.29,21,0)
	;;=^^5^5^2930825^
	;;^DD(356.2,.29,21,1,0)
	;;=Enter the final outcome of this appeal.  Did the insurance company
	;;^DD(356.2,.29,21,2,0)
	;;=approve, partially approve or deny this appeal?
	;;^DD(356.2,.29,21,3,0)
	;;= 
	;;^DD(356.2,.29,21,4,0)
	;;=If the appeal was approved or partially approved you may enter the
	;;^DD(356.2,.29,21,5,0)
	;;=dates that it was approved for.
	;;^DD(356.2,.29,"DT")
	;;=2930825
	;;^DD(356.2,1.01,0)
	;;=DATE ENTERED^D^^1;1^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.2,1.01,21,0)
	;;=^^3^3^2930806^
	;;^DD(356.2,1.01,21,1,0)
	;;=This is the date this contact was entered into the computer.  It is
	;;^DD(356.2,1.01,21,2,0)
	;;=generated when the contact is entered and is not editable by the 
	;;^DD(356.2,1.01,21,3,0)
	;;=user.
	;;^DD(356.2,1.01,22)
	;;=
	;;^DD(356.2,1.01,"DT")
	;;=2930610
	;;^DD(356.2,1.02,0)
	;;=ENTERED BY^P200'^VA(200,^1;2^Q
	;;^DD(356.2,1.02,21,0)
	;;=^^4^4^2930806^
	;;^DD(356.2,1.02,21,1,0)
	;;=This is the user who was signed on to the computer system when this
	;;^DD(356.2,1.02,21,2,0)
	;;=contact was created.  If this contact was created automatically by the
	;;^DD(356.2,1.02,21,3,0)
	;;=computer from an admission or discharge, then this might be a user from
	;;^DD(356.2,1.02,21,4,0)
	;;=IRM, MAS, or other service.
	;;^DD(356.2,1.02,"DT")
	;;=2930610
	;;^DD(356.2,1.03,0)
	;;=DATE LAST EDITED^D^^1;3^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
	;;^DD(356.2,1.03,21,0)
	;;=^^3^3^2940213^^
	;;^DD(356.2,1.03,21,1,0)
	;;=This is the date that this contact was last edited by a user using
	;;^DD(356.2,1.03,21,2,0)
	;;=the input options.  After every editing sequence the files are checked
	;;^DD(356.2,1.03,21,3,0)
	;;=for changes.  If any are noted then this field is updated.
	;;^DD(356.2,1.03,"DT")
	;;=2930610
	;;^DD(356.2,1.04,0)
	;;=LAST EDITED BY^P200'^VA(200,^1;4^Q
	;;^DD(356.2,1.04,21,0)
	;;=^^1^1^2930806^
	;;^DD(356.2,1.04,21,1,0)
	;;=This is the user that last edited this contact using the input screens.
	;;^DD(356.2,1.04,"DT")
	;;=2930610
	;;^DD(356.2,1.05,0)
	;;=HEALTH INSURANCE POLICY^RFXO^^1;5^K:$L(X)>30!($L(X)<1) X D:$D(X) DD^IBTRC2(X,DA)
	;;^DD(356.2,1.05,1,0)
	;;=^.1
	;;^DD(356.2,1.05,1,1,0)
	;;=^^TRIGGER^356.2^.08
	;;^DD(356.2,1.05,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y X ^DD(356.2,1.05,1,1,1.1) X ^DD(356.2,1.05,1,1,1.4)
	;;^DD(356.2,1.05,1,1,1.1)
	;;=S X=DIV S X=+$$INSCO^IBTRC2(DA,$P(^IBT(356.2,DA,1),U,5))
	;;^DD(356.2,1.05,1,1,1.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,8)=DIV,DIH=356.2,DIG=.08 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356.2,1.05,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356.2,D0,0)):^(0),1:"") S X=$P(Y(1),U,8),X=X S DIU=X K Y S X="" X ^DD(356.2,1.05,1,1,2.4)
	;;^DD(356.2,1.05,1,1,2.4)
	;;=S DIH=$S($D(^IBT(356.2,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,8)=DIV,DIH=356.2,DIG=.08 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
