IBINI01M	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.21)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.21,0,"GL")
	;;=^IBE(350.21,
	;;^DIC("B","IB ACTION STATUS",350.21)
	;;=
	;;^DIC(350.21,"%D",0)
	;;=^^20^20^2940214^^^
	;;^DIC(350.21,"%D",1,0)
	;;=This new file for Integrated Billing version 2.0 has been implemented
	;;^DIC(350.21,"%D",2,0)
	;;=to replace the set of codes for the STATUS (#.05) field of the
	;;^DIC(350.21,"%D",3,0)
	;;=INTEGRATED BILLING ACTION (#350) file.  The file holds new statuses
	;;^DIC(350.21,"%D",4,0)
	;;=which are introduced in v2.0, display and abbreviated names for the
	;;^DIC(350.21,"%D",5,0)
	;;=status, and classification-type fields for each status which is
	;;^DIC(350.21,"%D",6,0)
	;;=used for processing in the Integrated Billing module.
	;;^DIC(350.21,"%D",7,0)
	;;= 
	;;^DIC(350.21,"%D",8,0)
	;;=To convert to the use of this new file, it was necessary to change
	;;^DIC(350.21,"%D",9,0)
	;;=the field type of the STATUS field from a "set-of-codes" field to
	;;^DIC(350.21,"%D",10,0)
	;;=a pointer field (pointing to this file).  Thus, the internal entry
	;;^DIC(350.21,"%D",11,0)
	;;=numbers for the statuses in this file MUST MATCH the codes established
	;;^DIC(350.21,"%D",12,0)
	;;=for the statuses in the old set-of-codes definition.  The entries in this
	;;^DIC(350.21,"%D",13,0)
	;;=file will be precisely set in the IB version 2.0 post initialization.
	;;^DIC(350.21,"%D",14,0)
	;;= 
	;;^DIC(350.21,"%D",15,0)
	;;=ENTRIES IN THIS FILE SHOULD NOT BE EDITED OR DELETED.  IF YOU LOSE
	;;^DIC(350.21,"%D",16,0)
	;;=ENTRIES IN THIS FILE DUE TO SYSTEM FAILURE, THEY MUST BE RE-SET USING
	;;^DIC(350.21,"%D",17,0)
	;;=THE CORRECT INTERNAL ENTRY NUMBERS.  If you have any questions about
	;;^DIC(350.21,"%D",18,0)
	;;=re-setting entries in this file, please contact your supporting ISC.
	;;^DIC(350.21,"%D",19,0)
	;;= 
	;;^DIC(350.21,"%D",20,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.21,0)
	;;=FIELD^^.06^6
	;;^DD(350.21,0,"DDA")
	;;=N
	;;^DD(350.21,0,"DT")
	;;=2930810
	;;^DD(350.21,0,"IX","B",350.21,.01)
	;;=
	;;^DD(350.21,0,"NM","IB ACTION STATUS")
	;;=
	;;^DD(350.21,0,"PT",350,.05)
	;;=
	;;^DD(350.21,.01,0)
	;;=STATUS^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(350.21,.01,1,0)
	;;=^.1
	;;^DD(350.21,.01,1,1,0)
	;;=350.21^B
	;;^DD(350.21,.01,1,1,1)
	;;=S ^IBE(350.21,"B",$E(X,1,30),DA)=""
	;;^DD(350.21,.01,1,1,2)
	;;=K ^IBE(350.21,"B",$E(X,1,30),DA)
	;;^DD(350.21,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(350.21,.01,21,0)
	;;=^^5^5^2930810^
	;;^DD(350.21,.01,21,1,0)
	;;=The value of the STATUS field matches the name of the code from
	;;^DD(350.21,.01,21,2,0)
	;;=STATUS (#.05) field of the INTEGRATED BILLING ACTION (#350) file
	;;^DD(350.21,.01,21,3,0)
	;;=prior to Integrated Billing version 2.0.
	;;^DD(350.21,.01,21,4,0)
	;;= 
	;;^DD(350.21,.01,21,5,0)
	;;=This field should not be edited!
	;;^DD(350.21,.01,"DT")
	;;=2930810
	;;^DD(350.21,.02,0)
	;;=PRINT NAME^F^^0;2^K:$L(X)>25!($L(X)<3) X
	;;^DD(350.21,.02,3)
	;;=Answer must be 3-25 characters in length.
	;;^DD(350.21,.02,21,0)
	;;=^^2^2^2930810^
	;;^DD(350.21,.02,21,1,0)
	;;=This field contains a displayable status name which may be used
	;;^DD(350.21,.02,21,2,0)
	;;=in reports.
	;;^DD(350.21,.02,"DT")
	;;=2930810
	;;^DD(350.21,.03,0)
	;;=ABBREVIATION^F^^0;3^K:$L(X)>8!($L(X)<2) X
	;;^DD(350.21,.03,3)
	;;=Answer must be 2-8 characters in length.
	;;^DD(350.21,.03,21,0)
	;;=^^2^2^2930810^
	;;^DD(350.21,.03,21,1,0)
	;;=The abbreviation is a short-hand notation for the status which may
	;;^DD(350.21,.03,21,2,0)
	;;=be used for display in space-limited outputs.
