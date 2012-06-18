IBINI087	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,2.14,"DT")
	;;=2930726
	;;^DD(357.6,2.17,0)
	;;=IS PIECE 1 DISPLAYABLE?^S^0:NO;1:YES;^2;17^Q
	;;^DD(357.6,2.17,.1)
	;;=CAN THIS FIELD BE DISPLAYED TO THE USER?
	;;^DD(357.6,2.17,3)
	;;=The first piece of the returned record is reserved for the unique id of the selection. Enter no if it should not be displayed, for example, if it is a pointer.
	;;^DD(357.6,2.17,21,0)
	;;=^^3^3^2940217^
	;;^DD(357.6,2.17,21,1,0)
	;;=This is used only for selection type interfaces. If NO, then the value can
	;;^DD(357.6,2.17,21,2,0)
	;;=not be displayed to the encounter form.  The first piece must contain the
	;;^DD(357.6,2.17,21,3,0)
	;;=unique id of the selection.
	;;^DD(357.6,2.17,"DT")
	;;=2930810
	;;^DD(357.6,2.18,0)
	;;=ARE SELECTIONS EXPORTABLE?^S^0:NO;1:YES;^2;18^Q
	;;^DD(357.6,2.18,3)
	;;=Enter NO if the ID returned by the PACKAGE INTERFACE is not constant between sites, for example, if it is a pointer. Otherwise answer YES.
	;;^DD(357.6,2.18,21,0)
	;;=^^6^6^2930823^^^
	;;^DD(357.6,2.18,21,1,0)
	;;=Applies only to selection routines. Determines whether selections appearing
	;;^DD(357.6,2.18,21,2,0)
	;;=on selection lists that are populated via the package interface will
	;;^DD(357.6,2.18,21,3,0)
	;;=be exported along with the form that they appear on. The import/export
	;;^DD(357.6,2.18,21,4,0)
	;;=utility will not resolve pointers, so if the id returned by the package
	;;^DD(357.6,2.18,21,5,0)
	;;=interface (piece 1) is a pointer that differs between sites this field
	;;^DD(357.6,2.18,21,6,0)
	;;=should contain NO.
	;;^DD(357.6,2.18,"DT")
	;;=2930811
	;;^DD(357.6,3,0)
	;;=USER LOOKUP^F^^3;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>240!($L(X)<1) X
	;;^DD(357.6,3,.1)
	;;=LIST OF WORDS TO MAKE LOOK-UPS EASIER
	;;^DD(357.6,3,1,0)
	;;=^.1
	;;^DD(357.6,3,1,1,0)
	;;=357.6^D^KWIC
	;;^DD(357.6,3,1,1,1)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2,^DD("KWIC")'[I S ^IBE(357.6,"D",I,DA)=""
	;;^DD(357.6,3,1,1,2)
	;;=S %1=1 F %=1:1:$L(X)+1 S I=$E(X,%) I "(,.?! '-/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1 I $L(I)>2 K ^IBE(357.6,"D",I,DA)
	;;^DD(357.6,3,1,1,"%D",0)
	;;=^^3^3^2930409^^
	;;^DD(357.6,3,1,1,"%D",1,0)
	;;= 
	;;^DD(357.6,3,1,1,"%D",2,0)
	;;=This index is meant to assist the user in locating the correct package
	;;^DD(357.6,3,1,1,"%D",3,0)
	;;=interface needed to display a particular item of data to a form.
	;;^DD(357.6,3,1,1,"DT")
	;;=2930309
	;;^DD(357.6,3,3)
	;;=Enter words separated with spaces. They will be indexed to assist in lookup.
	;;^DD(357.6,3,4)
	;;=D LOOKUP^IBDF16
	;;^DD(357.6,3,21,0)
	;;=^^4^4^2940217^
	;;^DD(357.6,3,21,1,0)
	;;= 
	;;^DD(357.6,3,21,2,0)
	;;=This field is used to create a KWIC index for this file. The purpose is to
	;;^DD(357.6,3,21,3,0)
	;;=assist the user in locating the package interface he needs to display a
	;;^DD(357.6,3,21,4,0)
	;;=particular item of data to a form.
	;;^DD(357.6,3,"DT")
	;;=2930726
	;;^DD(357.6,4.01,0)
	;;=ENTRY ACTION^K^^4;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(357.6,4.01,3)
	;;=This is Standard MUMPS code.
	;;^DD(357.6,4.01,9)
	;;=@
	;;^DD(357.6,4.01,21,0)
	;;=^^3^3^2930527^
	;;^DD(357.6,4.01,21,1,0)
	;;= 
	;;^DD(357.6,4.01,21,2,0)
	;;=This code will be executed after the PROTECTED VARIABLES are newed, but
	;;^DD(357.6,4.01,21,3,0)
	;;=before the interface routine is called.
	;;^DD(357.6,4.01,"DT")
	;;=2930521
	;;^DD(357.6,5.01,0)
	;;=EXIT ACTION^K^^5;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(357.6,5.01,3)
	;;=This is Standard MUMPS code.
	;;^DD(357.6,5.01,9)
	;;=@
