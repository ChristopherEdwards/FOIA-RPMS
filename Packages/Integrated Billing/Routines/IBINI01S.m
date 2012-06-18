IBINI01S	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.41)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.41,0,"GL")
	;;=^IBE(350.41,
	;;^DIC("B","UPDATE BILLABLE AMBULATORY SURGICAL CODE",350.41)
	;;=
	;;^DIC(350.41,"%D",0)
	;;=^^8^8^2940214^^^^
	;;^DIC(350.41,"%D",1,0)
	;;=Contains updates to the ambulatory surgery procedures that can be billed.
	;;^DIC(350.41,"%D",2,0)
	;;=The data comes from HCFA in a WP file that is uploaded and entered into
	;;^DIC(350.41,"%D",3,0)
	;;=this file, generally once a year.
	;;^DIC(350.41,"%D",4,0)
	;;=The new billing procedures or billing group updates are activated only after
	;;^DIC(350.41,"%D",5,0)
	;;=the data in this file is transferred to 350.4.  This file should be empty
	;;^DIC(350.41,"%D",6,0)
	;;=except during the loading and transferring of the HCFA updates.
	;;^DIC(350.41,"%D",7,0)
	;;= 
	;;^DIC(350.41,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.41,0)
	;;=FIELD^^.08^8
	;;^DD(350.41,0,"DDA")
	;;=N
	;;^DD(350.41,0,"DT")
	;;=2911125
	;;^DD(350.41,0,"ID",.02)
	;;=W "   ",$E($P(^(0),U,2),4,5)_"-"_$E($P(^(0),U,2),6,7)_"-"_$E($P(^(0),U,2),2,3)
	;;^DD(350.41,0,"IX","B",350.41,.01)
	;;=
	;;^DD(350.41,0,"NM","UPDATE BILLABLE AMBULATORY SURGICAL CODE")
	;;=
	;;^DD(350.41,.01,0)
	;;=PROCEDURE^RP81'^ICPT(^0;1^Q
	;;^DD(350.41,.01,1,0)
	;;=^.1
	;;^DD(350.41,.01,1,1,0)
	;;=350.41^B
	;;^DD(350.41,.01,1,1,1)
	;;=S ^IBE(350.41,"B",$E(X,1,30),DA)=""
	;;^DD(350.41,.01,1,1,2)
	;;=K ^IBE(350.41,"B",$E(X,1,30),DA)
	;;^DD(350.41,.01,3)
	;;=
	;;^DD(350.41,.01,21,0)
	;;=^^4^4^2911113^^^^
	;;^DD(350.41,.01,21,1,0)
	;;=The ambulatory procedure to be added to or updated in 350.4.
	;;^DD(350.41,.01,21,2,0)
	;;=It is not necessary that this procedure already have entries in either 350.4 or
	;;^DD(350.41,.01,21,3,0)
	;;=409.71 but it is required that the procedure already be active 
	;;^DD(350.41,.01,21,4,0)
	;;=in 81.
	;;^DD(350.41,.01,"DT")
	;;=2911113
	;;^DD(350.41,.02,0)
	;;=DATE EFFECTIVE^RD^^0;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.41,.02,21,0)
	;;=^^1^1^2911113^
	;;^DD(350.41,.02,21,1,0)
	;;=The date that this procedure entry becomes effective for billing.
	;;^DD(350.41,.02,"DT")
	;;=2911113
	;;^DD(350.41,.03,0)
	;;=OLD RATE GROUP^P350.1'^IBE(350.1,^0;3^Q
	;;^DD(350.41,.03,21,0)
	;;=^^2^2^2911113^
	;;^DD(350.41,.03,21,1,0)
	;;=This is the rate group that the procedure belongs to before this entry
	;;^DD(350.41,.03,21,2,0)
	;;=is activated, as defined by the HCFA document.
	;;^DD(350.41,.03,"DT")
	;;=2911113
	;;^DD(350.41,.04,0)
	;;=NEW RATE GROUP^P350.1'^IBE(350.1,^0;4^Q
	;;^DD(350.41,.04,21,0)
	;;=^^1^1^2911113^
	;;^DD(350.41,.04,21,1,0)
	;;=The rate group for this procedure after this entry is activated.
	;;^DD(350.41,.04,"DT")
	;;=2911113
	;;^DD(350.41,.05,0)
	;;=DATE LOADED^D^^0;5^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.41,.05,21,0)
	;;=^^1^1^2920415^^
	;;^DD(350.41,.05,21,1,0)
	;;=The date the HCFA information was loaded into this file.
	;;^DD(350.41,.05,"DT")
	;;=2911113
	;;^DD(350.41,.06,0)
	;;=UPDATE ACTION^S^1:CREATED;2:ACTIVATED;3:CHANGED GROUPS;4:DEACTIVATED;^0;6^Q
	;;^DD(350.41,.06,3)
	;;=
	;;^DD(350.41,.06,21,0)
	;;=^^1^1^2911113^^
	;;^DD(350.41,.06,21,1,0)
	;;=The result caused by this entry on the procedure.
	;;^DD(350.41,.06,"DT")
	;;=2911113
	;;^DD(350.41,.07,0)
	;;=STATUS^S^0:NOT TRANSFERED;1:TRANSFERED;^0;7^Q
	;;^DD(350.41,.07,21,0)
	;;=^^3^3^2940209^^
	;;^DD(350.41,.07,21,1,0)
	;;=A flag indicating if this entry has been successfully transferred to the
	;;^DD(350.41,.07,21,2,0)
	;;=billing file 350.4 (and therefore activated).  If this is null then the 
	;;^DD(350.41,.07,21,3,0)
	;;=transfer program has not yet processed this procedure (entry).
