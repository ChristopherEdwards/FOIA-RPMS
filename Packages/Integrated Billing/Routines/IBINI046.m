IBINI046	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.5,.05,21,2,0)
	;;=notification. Enter 'R' if the user is to take a follow-up action
	;;^DD(354.5,.05,21,3,0)
	;;=after viewing this notification. 
	;;^DD(354.5,.05,21,4,0)
	;;= 
	;;^DD(354.5,.05,21,5,0)
	;;=This is a mandatory flag used to regulate processing in the alert
	;;^DD(354.5,.05,21,6,0)
	;;=software.  No additional action will be allowed after viewing
	;;^DD(354.5,.05,21,7,0)
	;;=information only alerts.
	;;^DD(354.5,.05,"DT")
	;;=2930204
	;;^DD(354.5,.06,0)
	;;=ENTRY POINT^F^^0;6^K:$L(X)>8!($L(X)<1) X
	;;^DD(354.5,.06,3)
	;;=Answer must be 1-8 characters in length.  This will be concatentated with the routine name.
	;;^DD(354.5,.06,21,0)
	;;=^^3^3^2930210^
	;;^DD(354.5,.06,21,1,0)
	;;=This is the entry point in a routine that will be run when the alert
	;;^DD(354.5,.06,21,2,0)
	;;=is processed.  It is used to build the variable XQAROU.  This field
	;;^DD(354.5,.06,21,3,0)
	;;=represents the TAG in tag^routine.
	;;^DD(354.5,.06,"DT")
	;;=2930204
	;;^DD(354.5,.07,0)
	;;=ROUTINE NAME^F^^0;7^K:$L(X)>8!($L(X)<2) X
	;;^DD(354.5,.07,3)
	;;=Answer must be 2-8 characters in length.
	;;^DD(354.5,.07,21,0)
	;;=^^3^3^2930210^
	;;^DD(354.5,.07,21,1,0)
	;;=This is the routine name that will be called by the alert software when
	;;^DD(354.5,.07,21,2,0)
	;;=processing the alert.  The variable XQAROU will be defined as tag^routine
	;;^DD(354.5,.07,21,3,0)
	;;=where this is the routine.  (ie xqarou=$p(^ibe(354.4,n,0),"^",6,7)
	;;^DD(354.5,.07,"DT")
	;;=2930204
	;;^DD(354.5,2,0)
	;;=RECIPIENT GROUPS^354.52PA^^2;0
	;;^DD(354.5,2,21,0)
	;;=^^1^1^2930210^
	;;^DD(354.5,2,21,1,0)
	;;=These are mail groups that this alert should be sent to.
	;;^DD(354.5,3,0)
	;;=PROCESSING FLAG^S^D:DISABLED;E:ENABLED;M:MANDATORY;^3;1^Q
	;;^DD(354.5,3,21,0)
	;;=^^3^3^2930210^
	;;^DD(354.5,3,21,1,0)
	;;=This field is used to regulate the alert processing.  Notifications flagged
	;;^DD(354.5,3,21,2,0)
	;;=as "D" will indicate the alert is disabled and will not be processed.  A
	;;^DD(354.5,3,21,3,0)
	;;=flag of "M" indicates the alert is enabled and mandatory.
	;;^DD(354.5,3,"DT")
	;;=2930204
	;;^DD(354.5,200,0)
	;;=RECIPIENT USERS^354.5002PA^^200;0
	;;^DD(354.5,200,21,0)
	;;=^^1^1^2930210^
	;;^DD(354.5,200,21,1,0)
	;;=These are users who have been determined to need to see this alert.
	;;^DD(354.5002,0)
	;;=RECIPIENT USERS SUB-FIELD^^.01^1
	;;^DD(354.5002,0,"DT")
	;;=2930204
	;;^DD(354.5002,0,"IX","B",354.5002,.01)
	;;=
	;;^DD(354.5002,0,"NM","RECIPIENT USERS")
	;;=
	;;^DD(354.5002,0,"UP")
	;;=354.5
	;;^DD(354.5002,.01,0)
	;;=RECIPIENT USERS^MP200'^VA(200,^0;1^Q
	;;^DD(354.5002,.01,1,0)
	;;=^.1
	;;^DD(354.5002,.01,1,1,0)
	;;=354.5002^B
	;;^DD(354.5002,.01,1,1,1)
	;;=S ^IBE(354.5,DA(1),200,"B",$E(X,1,30),DA)=""
	;;^DD(354.5002,.01,1,1,2)
	;;=K ^IBE(354.5,DA(1),200,"B",$E(X,1,30),DA)
	;;^DD(354.5002,.01,21,0)
	;;=^^1^1^2930210^
	;;^DD(354.5002,.01,21,1,0)
	;;=These are users who have been determined to need to see this alert.
	;;^DD(354.5002,.01,"DT")
	;;=2930204
	;;^DD(354.52,0)
	;;=RECIPIENT GROUPS SUB-FIELD^^.01^1
	;;^DD(354.52,0,"DT")
	;;=2930204
	;;^DD(354.52,0,"IX","B",354.52,.01)
	;;=
	;;^DD(354.52,0,"NM","RECIPIENT GROUPS")
	;;=
	;;^DD(354.52,0,"UP")
	;;=354.5
	;;^DD(354.52,.01,0)
	;;=RECIPIENT GROUPS^MP3.8'^XMB(3.8,^0;1^Q
	;;^DD(354.52,.01,1,0)
	;;=^.1
	;;^DD(354.52,.01,1,1,0)
	;;=354.52^B
	;;^DD(354.52,.01,1,1,1)
	;;=S ^IBE(354.5,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(354.52,.01,1,1,2)
	;;=K ^IBE(354.5,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(354.52,.01,21,0)
	;;=^^2^2^2930210^
	;;^DD(354.52,.01,21,1,0)
	;;=Enter the name of a mail group.  The alert will be sent to all
