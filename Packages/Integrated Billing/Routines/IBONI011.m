IBONI011	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",824,1,1,0)
	;;=Allows the user to exit the system without quitting through the hierarchy of
	;;^UTILITY(U,$J,"PRO",824,1,2,0)
	;;=screens, or the user can exit to the previous screen.
	;;^UTILITY(U,$J,"PRO",824,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",824,2,1,0)
	;;=EX
	;;^UTILITY(U,$J,"PRO",824,2,"B","EX",1)
	;;=
	;;^UTILITY(U,$J,"PRO",824,10,0)
	;;=^101.01PA^0^0
	;;^UTILITY(U,$J,"PRO",824,20)
	;;=D FASTEXIT^IBDFU3
	;;^UTILITY(U,$J,"PRO",824,99)
	;;=55852,54047
	;;^UTILITY(U,$J,"PRO",825,0)
	;;=IBDF EDIT HEADER BLOCK^Form Header^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",825,1,0)
	;;=^^1^1^2930211^
	;;^UTILITY(U,$J,"PRO",825,1,1,0)
	;;=Allows the form header to be edited
	;;^UTILITY(U,$J,"PRO",825,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",825,2,1,0)
	;;=FH
	;;^UTILITY(U,$J,"PRO",825,2,"B","FH",1)
	;;=
	;;^UTILITY(U,$J,"PRO",825,20)
	;;=D EDITHDR^IBDF9C
	;;^UTILITY(U,$J,"PRO",825,99)
	;;=55852,54045
	;;^UTILITY(U,$J,"PRO",826,0)
	;;=IBDF PRINT SAMPLE FORM^Print Sample Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",826,1,0)
	;;=^^1^1^2930915^^^
	;;^UTILITY(U,$J,"PRO",826,1,1,0)
	;;=Allows a sample form, without patient information, to be printed.
	;;^UTILITY(U,$J,"PRO",826,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",826,2,1,0)
	;;=PF
	;;^UTILITY(U,$J,"PRO",826,2,"B","PF",1)
	;;=
	;;^UTILITY(U,$J,"PRO",826,15)
	;;=
	;;^UTILITY(U,$J,"PRO",826,20)
	;;=D PRINT^IBDF1C
	;;^UTILITY(U,$J,"PRO",826,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",827,0)
	;;=IBDF DELETE FORM^Delete Unused Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",827,1,0)
	;;=^^6^6^2930224^
	;;^UTILITY(U,$J,"PRO",827,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",827,1,2,0)
	;;=Allows the user to delete a form. Deletion is not allowed if the form is
	;;^UTILITY(U,$J,"PRO",827,1,3,0)
	;;=in use by any clinic. In that case the form must first be deleted from the
	;;^UTILITY(U,$J,"PRO",827,1,4,0)
	;;=clinic setup, and then actually deleted using this action. This two step
	;;^UTILITY(U,$J,"PRO",827,1,5,0)
	;;=process is used to be on the safe side, since a form may be in use by more
	;;^UTILITY(U,$J,"PRO",827,1,6,0)
	;;=than one clinic.
	;;^UTILITY(U,$J,"PRO",827,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",827,2,1,0)
	;;=DF
	;;^UTILITY(U,$J,"PRO",827,2,"B","DF",1)
	;;=
	;;^UTILITY(U,$J,"PRO",827,20)
	;;=D DELFORM^IBDF6A
	;;^UTILITY(U,$J,"PRO",827,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",828,0)
	;;=IBDF CREATE EMPTY BLOCK^New Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",828,1,0)
	;;=^^2^2^2930322^
	;;^UTILITY(U,$J,"PRO",828,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",828,1,2,0)
	;;=Allows the user to add a new empty block to the form.
	;;^UTILITY(U,$J,"PRO",828,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",828,2,1,0)
	;;=NB
	;;^UTILITY(U,$J,"PRO",828,2,"B","NB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",828,20)
	;;=D NEWBLOCK^IBDF5C
	;;^UTILITY(U,$J,"PRO",828,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",829,0)
	;;=IBDF TEXT AREA^Text Area^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",829,1,0)
	;;=^^3^3^2930326^
	;;^UTILITY(U,$J,"PRO",829,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",829,1,2,0)
	;;=Allows the user to specify text and a rectangular area on the block that
	;;^UTILITY(U,$J,"PRO",829,1,3,0)
	;;=the text should appear in.
	;;^UTILITY(U,$J,"PRO",829,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",829,2,1,0)
	;;=TA
	;;^UTILITY(U,$J,"PRO",829,2,"B","TA",1)
	;;=
	;;^UTILITY(U,$J,"PRO",829,20)
	;;=D TEXT^IBDF9E
	;;^UTILITY(U,$J,"PRO",829,99)
	;;=55852,54050
	;;^UTILITY(U,$J,"PRO",830,0)
	;;=IBDF CHANGE CLINIC^Change Clinic^^A^^^^^^^^INTEGRATED BILLING
