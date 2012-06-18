IBDEI01H	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.6,2.11,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.11,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.11,21,1,0)
	;;= 
	;;^DD(358.6,2.11,21,2,0)
	;;=A descriptive name fo the 6th field returned by the interface routine.
	;;^DD(358.6,2.11,"DT")
	;;=2930726
	;;^DD(358.6,2.12,0)
	;;=PIECE 6 MAXIMUM LENGTH^NJ3,0^^2;12^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.12,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.12,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(358.6,2.12,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.12,21,1,0)
	;;= 
	;;^DD(358.6,2.12,21,2,0)
	;;=The maximum length of the 6th field returned by the interface routine.
	;;^DD(358.6,2.12,"DT")
	;;=2930726
	;;^DD(358.6,2.13,0)
	;;=PIECE 7 DESCRIPTIVE NAME^F^^2;13^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.13,.1)
	;;=WHAT IS THE SEVENTH PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(358.6,2.13,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.13,21,0)
	;;=^^3^3^2930528^
	;;^DD(358.6,2.13,21,1,0)
	;;= 
	;;^DD(358.6,2.13,21,2,0)
	;;=A descriptive name for the 7th field returned by the package interface
	;;^DD(358.6,2.13,21,3,0)
	;;=routine.
	;;^DD(358.6,2.13,"DT")
	;;=2930726
	;;^DD(358.6,2.14,0)
	;;=PIECE 7 MAXIMUM LENGTH^NJ3,0^^2;14^K:+X'=X!(X>210)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.14,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.14,3)
	;;=Type a Number between 1 and 210, 0 Decimal Digits
	;;^DD(358.6,2.14,21,0)
	;;=^^2^2^2930528^
	;;^DD(358.6,2.14,21,1,0)
	;;= 
	;;^DD(358.6,2.14,21,2,0)
	;;=The maximum length of the 7th field returned by the interface routine.
	;;^DD(358.6,2.14,"DT")
	;;=2930726
	;;^DD(358.6,2.17,0)
	;;=IS PIECE 1 DISPLAYABLE?^S^0:NO;1:YES;^2;17^Q
	;;^DD(358.6,2.17,.1)
	;;=CAN THIS FIELD BE DISPLAYED TO THE USER?
	;;^DD(358.6,2.17,3)
	;;=The first piece of the returned record is reserved for the unique id of the selection. Enter no if it should not be displayed, for example, if is a pointer.
	;;^DD(358.6,2.17,21,0)
	;;=^^3^3^2930811^^^^
	;;^DD(358.6,2.17,21,1,0)
	;;=This is used only for selection type interfaces. If NO, the the value can
	;;^DD(358.6,2.17,21,2,0)
	;;=not be displayed to the encounter form.
	;;^DD(358.6,2.17,21,3,0)
	;;=The first piece is reserved for the unique id of the selection.
	;;^DD(358.6,2.17,"DT")
	;;=2930810
	;;^DD(358.6,2.18,0)
	;;=ARE SELECTIONS EXPORTABLE?^S^0:NO;1:YES;^2;18^Q
	;;^DD(358.6,2.18,"DT")
	;;=2931203
	;;^DD(358.6,3,0)
	;;=USER LOOKUP^F^^3;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>240!($L(X)<1) X
	;;^DD(358.6,3,.1)
	;;=LIST OF WORDS TO MAKE LOOK-UPS EASIER
	;;^DD(358.6,3,1,0)
	;;=^.1
	;;^DD(358.6,3,1,1,0)
	;;=358.6^D^KWIC
	;;^DD(358.6,3,1,1,1)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2,^DD("KWIC")'[I S ^IBE(358.6,"D",I,DA)=""
	;;^DD(358.6,3,1,1,2)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2 K ^IBE(358.6,"D",I,DA)
	;;^DD(358.6,3,1,1,"%D",0)
	;;=^^3^3^2930409^^
	;;^DD(358.6,3,1,1,"%D",1,0)
	;;= 
	;;^DD(358.6,3,1,1,"%D",2,0)
	;;=This index is meant to assist the user in locating the correct package
	;;^DD(358.6,3,1,1,"%D",3,0)
	;;=interface needed to display a particular item of data to a form.
	;;^DD(358.6,3,1,1,"DT")
	;;=2930309
	;;^DD(358.6,3,3)
	;;=Enter words separated with spaces. They will be indexed to assist in lookup.
	;;^DD(358.6,3,4)
	;;=D LOOKUP^IBDF16
	;;^DD(358.6,3,21,0)
	;;=^^4^4^2930726^^^
	;;^DD(358.6,3,21,1,0)
	;;= 
	;;^DD(358.6,3,21,2,0)
	;;=This field is used to create a KWIC index for this file. The purpose is to
