IBINI044	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(354.4,0,"GL")
	;;=^IBA(354.4,
	;;^DIC("B","BILLING ALERTS",354.4)
	;;=
	;;^DIC(354.4,"%D",0)
	;;=^^17^17^2940214^^^^
	;;^DIC(354.4,"%D",1,0)
	;;=This file will only be populated if a site chooses to use the
	;;^DIC(354.4,"%D",2,0)
	;;=Alert functionality available in Kernel v7 instead of receiving 
	;;^DIC(354.4,"%D",3,0)
	;;=mail messages  This is determined by the field USE ALERTS in the
	;;^DIC(354.4,"%D",4,0)
	;;=IB SITE PARAMETERS file.
	;;^DIC(354.4,"%D",5,0)
	;;= 
	;;^DIC(354.4,"%D",6,0)
	;;=The entries will contain the name of the alert and after it has been
	;;^DIC(354.4,"%D",7,0)
	;;=resolved, who resolved the alert.  The entries in this file will
	;;^DIC(354.4,"%D",8,0)
	;;=automatically be deleted by the nightly background job, IB MT NIGHT COMP.
	;;^DIC(354.4,"%D",9,0)
	;;=Resolved alerts will be deleted after 30 days, unresolved alerts will be
	;;^DIC(354.4,"%D",10,0)
	;;=deleted after 60 days.
	;;^DIC(354.4,"%D",11,0)
	;;= 
	;;^DIC(354.4,"%D",12,0)
	;;=The data in the file is automatically entered by the system when
	;;^DIC(354.4,"%D",13,0)
	;;=either a detectable error occurs or when an action occurs that
	;;^DIC(354.4,"%D",14,0)
	;;=requires automatic notification for fiscal integrity (such as
	;;^DIC(354.4,"%D",15,0)
	;;=giving a hardship notification).
	;;^DIC(354.4,"%D",16,0)
	;;= 
	;;^DIC(354.4,"%D",17,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(354.4,0)
	;;=FIELD^^.04^4
	;;^DD(354.4,0,"DDA")
	;;=N
	;;^DD(354.4,0,"DT")
	;;=2930204
	;;^DD(354.4,0,"IX","AC",354.4,.02)
	;;=
	;;^DD(354.4,0,"IX","B",354.4,.01)
	;;=
	;;^DD(354.4,0,"NM","BILLING ALERTS")
	;;=
	;;^DD(354.4,0,"PT",354.1,.09)
	;;=
	;;^DD(354.4,.01,0)
	;;=BILLING ALERT^RP354.5'^IBE(354.5,^0;1^Q
	;;^DD(354.4,.01,1,0)
	;;=^.1
	;;^DD(354.4,.01,1,1,0)
	;;=354.4^B
	;;^DD(354.4,.01,1,1,1)
	;;=S ^IBA(354.4,"B",$E(X,1,30),DA)=""
	;;^DD(354.4,.01,1,1,2)
	;;=K ^IBA(354.4,"B",$E(X,1,30),DA)
	;;^DD(354.4,.01,3)
	;;=
	;;^DD(354.4,.01,21,0)
	;;=^^2^2^2930204^
	;;^DD(354.4,.01,21,1,0)
	;;=This is a pointer to the type of Billing Alert associated with this
	;;^DD(354.4,.01,21,2,0)
	;;=Alert.
	;;^DD(354.4,.01,"DT")
	;;=2930204
	;;^DD(354.4,.02,0)
	;;=DATE/TIME OF ALERT^D^^0;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(354.4,.02,1,0)
	;;=^.1
	;;^DD(354.4,.02,1,1,0)
	;;=354.4^AC
	;;^DD(354.4,.02,1,1,1)
	;;=S ^IBA(354.4,"AC",$E(X,1,30),DA)=""
	;;^DD(354.4,.02,1,1,2)
	;;=K ^IBA(354.4,"AC",$E(X,1,30),DA)
	;;^DD(354.4,.02,1,1,"%D",0)
	;;=^^2^2^2930209^
	;;^DD(354.4,.02,1,1,"%D",1,0)
	;;=Cross reference by date, used by purge.  Will purge all entries over
	;;^DD(354.4,.02,1,1,"%D",2,0)
	;;=60 days old and resolved entries over 30 days old.
	;;^DD(354.4,.02,1,1,"DT")
	;;=2930209
	;;^DD(354.4,.02,21,0)
	;;=^^1^1^2930204^
	;;^DD(354.4,.02,21,1,0)
	;;=This is the date time the alert occured.
	;;^DD(354.4,.02,"DT")
	;;=2930209
	;;^DD(354.4,.03,0)
	;;=RESOLVED BY^P200'^VA(200,^0;3^Q
	;;^DD(354.4,.03,21,0)
	;;=^^1^1^2930204^^
	;;^DD(354.4,.03,21,1,0)
	;;=This is the person who resolved the alert.
	;;^DD(354.4,.03,"DT")
	;;=2930204
	;;^DD(354.4,.04,0)
	;;=WHEN RESOLVED^D^^0;4^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(354.4,.04,21,0)
	;;=^^1^1^2930210^^
	;;^DD(354.4,.04,21,1,0)
	;;=This is the date/time when the alert was resolved.
	;;^DD(354.4,.04,"DT")
	;;=2930204
