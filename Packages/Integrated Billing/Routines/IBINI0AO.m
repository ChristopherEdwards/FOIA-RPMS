IBINI0AO	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,301,23,0)
	;;=^^4^4^2930622^
	;;^DD(399,301,23,1,0)
	;;=Set by trigger on Primary Insurance Carrier (399,101) and at UPDT^IBSCSE.
	;;^DD(399,301,23,2,0)
	;;=This node is a duplicate of the insurance's node in the patient file.
	;;^DD(399,301,23,3,0)
	;;=^DGCR(399,IBIFN,"I1")=^DPT(DFN,.312,X)
	;;^DD(399,301,23,4,0)
	;;=      where +^DPT(DFN,.312,X)=(399,101)  primary insurer
	;;^DD(399,301,"DT")
	;;=2900129
	;;^DD(399,302,0)
	;;=SECONDARY NODE^RF^^I2;E1,240^K:$L(X)>240!($L(X)<1) X
	;;^DD(399,302,3)
	;;=This is the information pertaining to the secondary insurance carrier which is associated with this bill.
	;;^DD(399,302,21,0)
	;;=^^2^2^2930622^^
	;;^DD(399,302,21,1,0)
	;;=This is the information pertaining to the secondary insurance carrier which 
	;;^DD(399,302,21,2,0)
	;;=is associated with this bill.
	;;^DD(399,302,23,0)
	;;=^^4^4^2930622^
	;;^DD(399,302,23,1,0)
	;;=Set by trigger on Secondary Insurance Carrier (399,102) and by UPDT^IBCSCE.
	;;^DD(399,302,23,2,0)
	;;=This node is a duplicate of the insurance's node in the patient file.
	;;^DD(399,302,23,3,0)
	;;=^DGCR(399,IBIFN,"I2")=^DPT(DFN,.312,X)
	;;^DD(399,302,23,4,0)
	;;=      where +^DPT(DFN,.312,X)=(399,102)  secondary insurer for bill
	;;^DD(399,302,"DT")
	;;=2900129
	;;^DD(399,303,0)
	;;=TERTIARY NODE^RF^^I3;E1,240^K:$L(X)>240!($L(X)<1) X
	;;^DD(399,303,3)
	;;=This is the information pertaining to the tertiary insurance carrier associated with this bill.
	;;^DD(399,303,21,0)
	;;=^^1^1^2940214^^
	;;^DD(399,303,21,1,0)
	;;=This is the information pertaining to the tertiary insurance carrier associated with this bill.
	;;^DD(399,303,"DT")
	;;=2900129
	;;^DD(399,304,0)
	;;=PROCEDURES^399.0304IAV^^CP;0
	;;^DD(399,304,21,0)
	;;=^^1^1^2940214^^^^
	;;^DD(399,304,21,1,0)
	;;=These are ICD or CPT procedures that are associated with this bill.
	;;^DD(399,304,23,0)
	;;=^^1^1^2940120^^^^
	;;^DD(399,304,23,1,0)
	;;= 
	;;^DD(399,304,"DT")
	;;=2911101
	;;^DD(399,400,0)
	;;=BLOCK 31^F^^UF2;1^K:$L(X)>63!($L(X)<3) X
	;;^DD(399,400,3)
	;;=Answer must be 3-63 characters in length.
	;;^DD(399,400,21,0)
	;;=^^4^4^2940310^^
	;;^DD(399,400,21,1,0)
	;;=Entry will be printed in block 31 of the HCFA 1500.  This block is 3 lines
	;;^DD(399,400,21,2,0)
	;;=of 21 characters each.
	;;^DD(399,400,21,3,0)
	;;= 
	;;^DD(399,400,21,4,0)
	;;=Set up for the physicians name and number.
	;;^DD(399,400,"DT")
	;;=2940310
	;;^DD(399,450,0)
	;;=FORM LOCATOR 2^F^^UF3;1^K:$L(X)>59!($L(X)<3) X
	;;^DD(399,450,3)
	;;=Answer must be 3-59 characters in length.
	;;^DD(399,450,21,0)
	;;=^^3^3^2931216^^^^
	;;^DD(399,450,21,1,0)
	;;=FORM LOCATOR 2 ON THE UB-92.
	;;^DD(399,450,21,2,0)
	;;=Printed in Form Locator 2 on the UB-92.  If more than 30 characters are
	;;^DD(399,450,21,3,0)
	;;=entered this will be printed on two lines.
	;;^DD(399,450,23,0)
	;;=^^4^4^2931216^^^
	;;^DD(399,450,23,1,0)
	;;=Unlabled Form Locator 2 on the UB-92.  On the form the block is two lines
	;;^DD(399,450,23,2,0)
	;;=of 29 and 30 characters, with the upper line optional.  Therefore, if
	;;^DD(399,450,23,3,0)
	;;=string is longer than 30 characters it must be split and printed on both
	;;^DD(399,450,23,4,0)
	;;=lines.
	;;^DD(399,450,"DT")
	;;=2931216
	;;^DD(399,451,0)
	;;=FORM LOCATOR 11^F^^UF3;2^K:$L(X)>25!($L(X)<3) X
	;;^DD(399,451,3)
	;;=Answer must be 3-25 characters in length.
	;;^DD(399,451,21,0)
	;;=^^2^2^2931216^^^^
	;;^DD(399,451,21,1,0)
	;;=Printed in Form Locator 11 on the UB-92.  If more than 13 characters are
	;;^DD(399,451,21,2,0)
	;;=entered this will be printed on two lines.
