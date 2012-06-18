FHINI0LB	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(116.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(116.2,8,1,2,2)
	;;=D SET^FHORDR
	;;^DD(116.2,8,1,2,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(116.2,8,1,2,"%D",1,0)
	;;=This cross-reference rebuilds the 'AR' decoding string whenever
	;;^DD(116.2,8,1,2,"%D",2,0)
	;;=the tally order is changed.
	;;^DD(116.2,8,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99
	;;^DD(116.2,8,21,0)
	;;=^^5^5^2880717^
	;;^DD(116.2,8,21,1,0)
	;;=In recoding diets, this is the order in which the clinical
	;;^DD(116.2,8,21,2,0)
	;;='default production diets' will be matched against this
	;;^DD(116.2,8,21,3,0)
	;;=production diet. Recoding will occur as soon as a match
	;;^DD(116.2,8,21,4,0)
	;;=occurs. Therefore, this field can be conceptualized as
	;;^DD(116.2,8,21,5,0)
	;;=representing the relative importance of the production diet.
	;;^DD(116.2,8,"DT")
	;;=2870714
	;;^DD(116.2,10,0)
	;;=IS THIS A COMBO DIET?^RS^Y:YES;N:NO;^0;4^Q
	;;^DD(116.2,10,21,0)
	;;=^^7^7^2891006^^
	;;^DD(116.2,10,21,1,0)
	;;=This field, when answered YES, indicates that this production
	;;^DD(116.2,10,21,2,0)
	;;=diet is a combination of other production diets (e.g., both
	;;^DD(116.2,10,21,3,0)
	;;=low sodium and calorie restricted). Since ALL production diets
	;;^DD(116.2,10,21,4,0)
	;;=in a combo must match the 'default production diets' of a 
	;;^DD(116.2,10,21,5,0)
	;;=clinical order, such combo production diets should have a tally
	;;^DD(116.2,10,21,6,0)
	;;=order less than any of the individual production diets
	;;^DD(116.2,10,21,7,0)
	;;=contained in the combo.
	;;^DD(116.2,10,"DT")
	;;=2891006
	;;^DD(116.2,11,0)
	;;=SINGULAR PRODUCTION DIETS^116.211P^^R;0
	;;^DD(116.2,11,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.2,11,21,1,0)
	;;=This multiple contains a list of the production diets which
	;;^DD(116.2,11,21,2,0)
	;;=constitute the combo production diet.
	;;^DD(116.2,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(116.2,99,1,0)
	;;=^.1
	;;^DD(116.2,99,1,1,0)
	;;=116.2^AC^MUMPS
	;;^DD(116.2,99,1,1,1)
	;;=K:X'="Y" ^FH(116.2,DA,"I")
	;;^DD(116.2,99,1,1,2)
	;;=K ^FH(116.2,DA,"I")
	;;^DD(116.2,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(116.2,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(116.2,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(116.2,99,1,1,"DT")
	;;=2920703
	;;^DD(116.2,99,1,2,0)
	;;=116.2^AD^MUMPS
	;;^DD(116.2,99,1,2,1)
	;;=D SET^FHORDR
	;;^DD(116.2,99,1,2,2)
	;;=D SET^FHORDR
	;;^DD(116.2,99,1,2,"%D",0)
	;;=^^3^3^2940818^
	;;^DD(116.2,99,1,2,"%D",1,0)
	;;=This cross-reference does not alter the global contents but
	;;^DD(116.2,99,1,2,"%D",2,0)
	;;=rather invokes a routine which removes inactive production
	;;^DD(116.2,99,1,2,"%D",3,0)
	;;=diets from the recording scheme.
	;;^DD(116.2,99,1,2,"DT")
	;;=2931105
	;;^DD(116.2,99,21,0)
	;;=^^2^2^2940701^^^
	;;^DD(116.2,99,21,1,0)
	;;=This field, when answered YES, will prohibit further selection
	;;^DD(116.2,99,21,2,0)
	;;=of this Production Diet.
	;;^DD(116.2,99,"DT")
	;;=2931105
	;;^DD(116.211,0)
	;;=SINGULAR PRODUCTION DIETS SUB-FIELD^^.01^1
	;;^DD(116.211,0,"IX","B",116.211,.01)
	;;=
	;;^DD(116.211,0,"NM","SINGULAR PRODUCTION DIETS")
	;;=
	;;^DD(116.211,0,"UP")
	;;=116.2
	;;^DD(116.211,.01,0)
	;;=SINGULAR PRODUCTION DIETS^M*P116.2'^FH(116.2,^0;1^S DIC("S")="I $P(^(0),""^"",4)'=""Y""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(116.211,.01,1,0)
	;;=^.1
	;;^DD(116.211,.01,1,1,0)
	;;=116.211^B
	;;^DD(116.211,.01,1,1,1)
	;;=S ^FH(116.2,DA(1),"R","B",$E(X,1,30),DA)=""
	;;^DD(116.211,.01,1,1,2)
	;;=K ^FH(116.2,DA(1),"R","B",$E(X,1,30),DA)
	;;^DD(116.211,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(116.211,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the SINGULAR PRODUCTION DIETS field.
	;;^DD(116.211,.01,1,2,0)
	;;=116.2^AR1^MUMPS
	;;^DD(116.211,.01,1,2,1)
	;;=D SET^FHORDR
	;;^DD(116.211,.01,1,2,2)
	;;=D SET^FHORDR
	;;^DD(116.211,.01,1,2,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(116.211,.01,1,2,"%D",1,0)
	;;=This cross-reference will rebuild the 'AR' decoding string whenever
	;;^DD(116.211,.01,1,2,"%D",2,0)
	;;=a change is made to a combination production diet.
	;;^DD(116.211,.01,12)
	;;=Can only select singular production diets.
	;;^DD(116.211,.01,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",4)'=""Y"""
	;;^DD(116.211,.01,21,0)
	;;=^^2^2^2880717^
	;;^DD(116.211,.01,21,1,0)
	;;=This is a production diet that is to be contained in the combo
	;;^DD(116.211,.01,21,2,0)
	;;=production diet. It itself must not also be a combo production diet.
	;;^DD(116.211,.01,"DT")
	;;=2870714
