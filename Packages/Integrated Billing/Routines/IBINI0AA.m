IBINI0AA	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,64,21,1,0)
	;;=This is the first ICD diagnosis code associated with this billing episode.
	;;^DD(399,64,23,0)
	;;=^^2^2^2931117^
	;;^DD(399,64,23,1,0)
	;;=Replaced by a diagnosis file (362.3) with IB v2.0.  "*" for deletion
	;;^DD(399,64,23,2,0)
	;;=on 11/10/93.
	;;^DD(399,64,"DT")
	;;=2931110
	;;^DD(399,65,0)
	;;=*ICD DIAGNOSIS CODE (2)^P80'^ICD9(^C;15^Q
	;;^DD(399,65,.1)
	;;=ICD DIAGNOSIS CODE (2)
	;;^DD(399,65,3)
	;;=Enter the ICD diagnosis code which pertains to this billing episode.
	;;^DD(399,65,21,0)
	;;=^^1^1^2931117^^
	;;^DD(399,65,21,1,0)
	;;=This is the second ICD diagnosis code associated with this billing episode.
	;;^DD(399,65,23,0)
	;;=^^2^2^2931117^
	;;^DD(399,65,23,1,0)
	;;=Replaced by a diagnosis file (362.3) with IB v2.0.  "*" for deletion
	;;^DD(399,65,23,2,0)
	;;=on 11/10/93.
	;;^DD(399,65,"DT")
	;;=2931110
	;;^DD(399,66,0)
	;;=*ICD DIAGNOSIS CODE (3)^P80'^ICD9(^C;16^Q
	;;^DD(399,66,.1)
	;;=ICD DIAGNOSIS CODE (3)
	;;^DD(399,66,3)
	;;=Enter the ICD diagnosis code which pertains to this billing episode.
	;;^DD(399,66,21,0)
	;;=^^1^1^2931117^^
	;;^DD(399,66,21,1,0)
	;;=This is the third ICD diagnosis code associated with this billing episode.
	;;^DD(399,66,23,0)
	;;=^^2^2^2931117^
	;;^DD(399,66,23,1,0)
	;;=Replaced by a diagnosis file (362.3) with IB v2.0.  "*" for deletion
	;;^DD(399,66,23,2,0)
	;;=on 11/10/93.
	;;^DD(399,66,"DT")
	;;=2931110
	;;^DD(399,67,0)
	;;=*ICD DIAGNOSIS CODE (4)^P80'^ICD9(^C;17^Q
	;;^DD(399,67,.1)
	;;=ICD DIAGNOSIS CODE (4)
	;;^DD(399,67,3)
	;;=Enter the ICD diagnosis code which pertains to this billing episode.
	;;^DD(399,67,21,0)
	;;=^^1^1^2931117^^
	;;^DD(399,67,21,1,0)
	;;=This is the fourth ICD diagnosis code associated with this billing episode.
	;;^DD(399,67,23,0)
	;;=^^2^2^2931117^
	;;^DD(399,67,23,1,0)
	;;=Replaced by a diagnosis file (362.3) with IB v2.0.  "*" for deletion
	;;^DD(399,67,23,2,0)
	;;=on 11/10/93.
	;;^DD(399,67,"DT")
	;;=2931110
	;;^DD(399,68,0)
	;;=*ICD DIAGNOSIS CODE (5)^P80'^ICD9(^C;18^Q
	;;^DD(399,68,.1)
	;;=ICD DIAGNOSIS CODE (5)
	;;^DD(399,68,3)
	;;=Enter the ICD diagnosis code which pertains to this billing episode.
	;;^DD(399,68,21,0)
	;;=^^1^1^2931117^^
	;;^DD(399,68,21,1,0)
	;;=This is the fifth ICD diagnosis code associated with this billing episode.
	;;^DD(399,68,23,0)
	;;=^^2^2^2931117^
	;;^DD(399,68,23,1,0)
	;;=Replaced by a diagnosis file (362.3) with IB v2.0.  "*" for deletion
	;;^DD(399,68,23,2,0)
	;;=on 11/10/93.
	;;^DD(399,68,"DT")
	;;=2931110
	;;^DD(399,101,0)
	;;=PRIMARY INSURANCE CARRIER^R*P36'X^DIC(36,^M;1^D DD^IBCNS S DIC("S")="I $D(IBDD(+Y)),'$D(^DGCR(399,DA,""AIC"",+Y))" D ^DIC K DIC,IBDD S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,101,1,0)
	;;=^.1
	;;^DD(399,101,1,1,0)
	;;=399^AI1^MUMPS
	;;^DD(399,101,1,1,1)
	;;=D MAILA^IBCU5
	;;^DD(399,101,1,1,2)
	;;=Q
	;;^DD(399,101,1,1,"%D",0)
	;;=^^9^9^2931220^^^^
	;;^DD(399,101,1,1,"%D",1,0)
	;;= - calls MAILA to set mailing address (399,104-109,121) to primary
	;;^DD(399,101,1,1,"%D",2,0)
	;;=   insurer's address
	;;^DD(399,101,1,1,"%D",3,0)
	;;= 
	;;^DD(399,101,1,1,"%D",4,0)
	;;=NOTE: I1 and AIC x-refs now set by field 112.
	;;^DD(399,101,1,1,"%D",5,0)
	;;=If X is one of the patients active/valid insurance companies:
	;;^DD(399,101,1,1,"%D",6,0)
	;;= - sets the node "I1" to detailed data on the insurance company 
	;;^DD(399,101,1,1,"%D",7,0)
	;;=   (2,.312, entire node .01-17)
	;;^DD(399,101,1,1,"%D",8,0)
	;;= - sets x-ref "AIC": subfile x-ref of insurance carriers (399,101-103)
	;;^DD(399,101,1,1,"%D",9,0)
	;;= 
	;;^DD(399,101,1,1,"DT")
	;;=2931220
	;;^DD(399,101,1,2,0)
	;;=399^AREV4^MUMPS
