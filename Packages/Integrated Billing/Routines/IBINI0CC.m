IBINI0CC	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(409.96)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(409.961,.01,1,2,"DT")
	;;=2930518
	;;^DD(409.961,.01,3)
	;;=Enter the report or form that you want to print for the entire division.
	;;^DD(409.961,.01,12)
	;;=Allows only reports installed in the Package Interface file.
	;;^DD(409.961,.01,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=4,$P(^(0),U,9)=1"
	;;^DD(409.961,.01,21,0)
	;;=^^3^3^2930528^
	;;^DD(409.961,.01,21,1,0)
	;;= 
	;;^DD(409.961,.01,21,2,0)
	;;=A report that should print. Only reports contained in the Package
	;;^DD(409.961,.01,21,3,0)
	;;=Interface file can be printed by the print manager.
	;;^DD(409.961,.01,"DT")
	;;=2930520
	;;^DD(409.961,.02,0)
	;;=PRINT CONDITION^RP357.92'^IBE(357.92,^0;2^Q
	;;^DD(409.961,.02,1,0)
	;;=^.1
	;;^DD(409.961,.02,1,1,0)
	;;=409.96^A1^MUMPS
	;;^DD(409.961,.02,1,1,1)
	;;=S ^SD(409.96,"A",$P(^SD(409.96,DA(1),0),U),X,$P(^SD(409.96,DA(1),1,DA,0),U),DA(1),DA)=""
	;;^DD(409.961,.02,1,1,2)
	;;=K ^SD(409.96,"A",$P(^SD(409.96,DA(1),0),U),X,$P(^SD(409.96,DA(1),1,DA,0),U),DA(1),DA)
	;;^DD(409.961,.02,1,1,"%D",0)
	;;=^^6^6^2940216^
	;;^DD(409.961,.02,1,1,"%D",1,0)
	;;= 
	;;^DD(409.961,.02,1,1,"%D",2,0)
	;;=Allows all of the reports that should print under certain conditons for
	;;^DD(409.961,.02,1,1,"%D",3,0)
	;;=the division to be found. The subscripts are ^SD(409.96,"A",<division
	;;^DD(409.961,.02,1,1,"%D",4,0)
	;;=ien>,<print condition ien >, <package interface ien>, <division setup
	;;^DD(409.961,.02,1,1,"%D",5,0)
	;;=ien>, <report multiple ien>). It is not necessary to re-index the A
	;;^DD(409.961,.02,1,1,"%D",6,0)
	;;=cross-reference on the REPORT field if this field is re-indexed.
	;;^DD(409.961,.02,1,1,"DT")
	;;=2930518
	;;^DD(409.961,.02,3)
	;;=Under what condition do you want the report to print?
	;;^DD(409.961,.02,4)
	;;=D HELP6^IBDFU5A
	;;^DD(409.961,.02,21,0)
	;;=^^2^2^2930528^
	;;^DD(409.961,.02,21,1,0)
	;;= 
	;;^DD(409.961,.02,21,2,0)
	;;=The condition under which the report should print.
	;;^DD(409.961,.02,"DT")
	;;=2930518
