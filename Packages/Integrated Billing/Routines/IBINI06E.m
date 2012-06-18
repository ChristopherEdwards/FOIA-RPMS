IBINI06E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.3,0,"GL")
	;;=^IBE(356.3,
	;;^DIC("B","CLAIMS TRACKING SI/IS CATEGORIES",356.3)
	;;=
	;;^DIC(356.3,"%D",0)
	;;=5^^14^14^2940214^^^^
	;;^DIC(356.3,"%D",1,0)
	;;=This file contains the major categories of areas that are used to address
	;;^DIC(356.3,"%D",2,0)
	;;=the severity of illness and intensity of service.  Specific criteria for
	;;^DIC(356.3,"%D",3,0)
	;;=each category must be met to address appropriateness of admission to
	;;^DIC(356.3,"%D",4,0)
	;;=continued stay in and discharge from specialized units and general
	;;^DIC(356.3,"%D",5,0)
	;;=units.
	;;^DIC(356.3,"%D",6,0)
	;;= 
	;;^DIC(356.3,"%D",7,0)
	;;=Do Not add to or delete from this file without instructions from your
	;;^DIC(356.3,"%D",8,0)
	;;=ISC.  Editing this file may have significant impact on the QM national 
	;;^DIC(356.3,"%D",9,0)
	;;=roll-up of Utilization Review information.
	;;^DIC(356.3,"%D",10,0)
	;;= 
	;;^DIC(356.3,"%D",11,0)
	;;=The contents of this file are the general categories for Intesity of 
	;;^DIC(356.3,"%D",12,0)
	;;=Service and Severity of Illness from Interqual.
	;;^DIC(356.3,"%D",13,0)
	;;= 
	;;^DIC(356.3,"%D",14,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.3,0)
	;;=FIELD^^.03^3
	;;^DD(356.3,0,"DDA")
	;;=N
	;;^DD(356.3,0,"DT")
	;;=2930907
	;;^DD(356.3,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(356.3,0,"IX","B",356.3,.01)
	;;=
	;;^DD(356.3,0,"IX","C",356.3,.03)
	;;=
	;;^DD(356.3,0,"NM","CLAIMS TRACKING SI/IS CATEGORIES")
	;;=
	;;^DD(356.3,0,"PT",356.1,.04)
	;;=
	;;^DD(356.3,0,"PT",356.1,.05)
	;;=
	;;^DD(356.3,0,"PT",356.1,.08)
	;;=
	;;^DD(356.3,0,"PT",356.1,.09)
	;;=
	;;^DD(356.3,0,"PT",356.1,.12)
	;;=
	;;^DD(356.3,0,"PT",356.1,.13)
	;;=
	;;^DD(356.3,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.3,.01,1,0)
	;;=^.1
	;;^DD(356.3,.01,1,1,0)
	;;=356.3^B
	;;^DD(356.3,.01,1,1,1)
	;;=S ^IBE(356.3,"B",$E(X,1,30),DA)=""
	;;^DD(356.3,.01,1,1,2)
	;;=K ^IBE(356.3,"B",$E(X,1,30),DA)
	;;^DD(356.3,.01,3)
	;;=Answer must be 3-40 characters in length.
	;;^DD(356.3,.01,21,0)
	;;=^^4^4^2931128^
	;;^DD(356.3,.01,21,1,0)
	;;=This is the name of the Severity of Illness (SI) or Intensity of Service
	;;^DD(356.3,.01,21,2,0)
	;;=(IS) general category.  
	;;^DD(356.3,.01,21,3,0)
	;;= 
	;;^DD(356.3,.01,21,4,0)
	;;=Enter the name as it appears in the Interqual manual.
	;;^DD(356.3,.01,"DT")
	;;=2930610
	;;^DD(356.3,.02,0)
	;;=GENERAL OR SPECIAL UNIT^S^1:SPECIAL UNIT CODE;2:GENERAL UNIT;^0;2^Q
	;;^DD(356.3,.02,21,0)
	;;=^^5^5^2940213^^^^
	;;^DD(356.3,.02,21,1,0)
	;;=Enter whether this criteria is for general medical surgical ward or for
	;;^DD(356.3,.02,21,2,0)
	;;=a specialized unit as defined in the Interqual manual.  Specialized
	;;^DD(356.3,.02,21,3,0)
	;;=units include not only ICU's and CCU's but some other non-critical care
	;;^DD(356.3,.02,21,4,0)
	;;=units that one might not normally expect to see included in the list.
	;;^DD(356.3,.02,21,5,0)
	;;= 
	;;^DD(356.3,.02,"DT")
	;;=2930610
	;;^DD(356.3,.03,0)
	;;=CODE^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>2!($L(X)<2)!'(X?2N) X
	;;^DD(356.3,.03,1,0)
	;;=^.1
	;;^DD(356.3,.03,1,1,0)
	;;=356.3^C
	;;^DD(356.3,.03,1,1,1)
	;;=S ^IBE(356.3,"C",$E(X,1,30),DA)=""
	;;^DD(356.3,.03,1,1,2)
	;;=K ^IBE(356.3,"C",$E(X,1,30),DA)
	;;^DD(356.3,.03,1,1,"DT")
	;;=2930915
	;;^DD(356.3,.03,3)
	;;=Answer must be 2 characters in length.
	;;^DD(356.3,.03,21,0)
	;;=^^4^4^2931128^^
	;;^DD(356.3,.03,21,1,0)
	;;=Enter the 2 digit number to assist in looking up SI/IS criteria.
	;;^DD(356.3,.03,21,2,0)
	;;= 
	;;^DD(356.3,.03,21,3,0)
	;;=Do not edit this code as it will be used in the national roll-up of QM 
