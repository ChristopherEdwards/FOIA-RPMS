IBINI05H	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.17,1,2,"DT")
	;;=2930824
	;;^DD(356,.17,3)
	;;=Enter the date the autobiller will first try and create a bill for this visit.  Delete this date if the visit is not billable.
	;;^DD(356,.17,5,1,0)
	;;=356^.18^3
	;;^DD(356,.17,5,2,0)
	;;=356^1.01^1
	;;^DD(356,.17,5,3,0)
	;;=356^.11^2
	;;^DD(356,.17,5,4,0)
	;;=356^.12^3
	;;^DD(356,.17,5,5,0)
	;;=356^.19^3
	;;^DD(356,.17,5,6,0)
	;;=356^.2^2
	;;^DD(356,.17,21,0)
	;;=^^15^15^2940213^^^^
	;;^DD(356,.17,21,1,0)
	;;=This is the earliest date that this visit can be automatically billed.
	;;^DD(356,.17,21,2,0)
	;;=The automatic billing software will use this date when searching for events
	;;^DD(356,.17,21,3,0)
	;;=to bill.  All events with an Earliest Auto Bill Date on or before the run
	;;^DD(356,.17,21,4,0)
	;;=date of the automatic biller will be considered for inclusion on a bill.
	;;^DD(356,.17,21,5,0)
	;;= 
	;;^DD(356,.17,21,6,0)
	;;=This field may be set in one of two ways.  If AUTOMATE BILLING is on for
	;;^DD(356,.17,21,7,0)
	;;=the Event Type then this field will be automatically set when apparently
	;;^DD(356,.17,21,8,0)
	;;=billable events are added to the claims tracking module.
	;;^DD(356,.17,21,9,0)
	;;=This field can also be directly set by a user, AUTOMATE BILLING does not
	;;^DD(356,.17,21,10,0)
	;;=need to be on for the Event Type.  When the automated biller runs it will
	;;^DD(356,.17,21,11,0)
	;;=attempt to add the event to a bill.
	;;^DD(356,.17,21,12,0)
	;;= 
	;;^DD(356,.17,21,13,0)
	;;=This date should be deleted if the event turns out not to be suitable for
	;;^DD(356,.17,21,14,0)
	;;=a reimbursable insurance bill.  This field will automatically be deleted
	;;^DD(356,.17,21,15,0)
	;;=if the event is added to a bill or a reason not-billable is entered.
	;;^DD(356,.17,22)
	;;=
	;;^DD(356,.17,23,0)
	;;=^^13^13^2940213^^^^
	;;^DD(356,.17,23,1,0)
	;;=If and only if this field is set will the event be considered by the 
	;;^DD(356,.17,23,2,0)
	;;=automatic biller.  This will be set to the date the event was entered
	;;^DD(356,.17,23,3,0)
	;;=into claims tracking plus the number of days delay for the event type.
	;;^DD(356,.17,23,4,0)
	;;= 
	;;^DD(356,.17,23,5,0)
	;;=Setting of this field may be automatic, ie. all by triggers, if automated
	;;^DD(356,.17,23,6,0)
	;;=billing is turned on for the event type.  Initially set by triggers on
	;;^DD(356,.17,23,7,0)
	;;=Event  Type (.18) and Date Entered (1.01).
	;;^DD(356,.17,23,8,0)
	;;= 
	;;^DD(356,.17,23,9,0)
	;;=This may also be set by user.
	;;^DD(356,.17,23,10,0)
	;;= 
	;;^DD(356,.17,23,11,0)
	;;=There is no checking to determine if the event is actually billable when
	;;^DD(356,.17,23,12,0)
	;;=the date is added.  Instead, if one of the fields that makes an event not
	;;^DD(356,.17,23,13,0)
	;;=billable is entered this field is deleted.
	;;^DD(356,.17,"DT")
	;;=2930824
	;;^DD(356,.18,0)
	;;=EVENT TYPE^P356.6'^IBE(356.6,^0;18^Q
	;;^DD(356,.18,1,0)
	;;=^.1
	;;^DD(356,.18,1,1,0)
	;;=356^EVNT
	;;^DD(356,.18,1,1,1)
	;;=S ^IBT(356,"EVNT",$E(X,1,30),DA)=""
	;;^DD(356,.18,1,1,2)
	;;=K ^IBT(356,"EVNT",$E(X,1,30),DA)
	;;^DD(356,.18,1,1,"DT")
	;;=2930820
	;;^DD(356,.18,1,2,0)
	;;=356^ANABD3^MUMPS
	;;^DD(356,.18,1,2,1)
	;;=S:$P(^IBT(356,DA,0),U,20)&($P(^(0),U,19)="")&($P(^(0),"^",17)) ^IBT(356,"ANABD",X,$P(^(0),U,17),DA)=""
	;;^DD(356,.18,1,2,2)
	;;=K ^IBT(356,"ANABD",X,+$P(^IBT(356,DA,0),U,17),DA)
	;;^DD(356,.18,1,2,"%D",0)
	;;=^^2^2^2930709^
	;;^DD(356,.18,1,2,"%D",1,0)
	;;=Cross reference of all active, billable events by event type and next
	;;^DD(356,.18,1,2,"%D",2,0)
	;;=auto bill date.
