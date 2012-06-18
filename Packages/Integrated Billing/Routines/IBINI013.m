IBINI013	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350,0,"GL")
	;;=^IB(
	;;^DIC("B","INTEGRATED BILLING ACTION",350)
	;;=
	;;^DIC(350,"%D",0)
	;;=^^25^25^2940214^^^^
	;;^DIC(350,"%D",1,0)
	;;=DO NOT delete entries in this file.  DO NOT edit data in this file with
	;;^DIC(350,"%D",2,0)
	;;=VA File Manager.
	;;^DIC(350,"%D",3,0)
	;;= 
	;;^DIC(350,"%D",4,0)
	;;=Entries in this file are created by other applications calling approved
	;;^DIC(350,"%D",5,0)
	;;=application specific routines.  This file is the link between Accounts
	;;^DIC(350,"%D",6,0)
	;;=Receivable and an application.  Integrated billing will attempt to
	;;^DIC(350,"%D",7,0)
	;;=aggregate charges where possible to reduce the number of account 
	;;^DIC(350,"%D",8,0)
	;;=entries necessary.  Resolution of charges from Accounts Receivable would
	;;^DIC(350,"%D",9,0)
	;;=then be accomplished through Integrated Billing.
	;;^DIC(350,"%D",10,0)
	;;= 
	;;^DIC(350,"%D",11,0)
	;;=Entries in this file will not be deleted or edited (except for the
	;;^DIC(350,"%D",12,0)
	;;=status field, cancellation reasons filed, last updated field, and
	;;^DIC(350,"%D",13,0)
	;;=user last updating field).  Rather than deleting an entry, an entry
	;;^DIC(350,"%D",14,0)
	;;=is "reversed" by creating an additional entry with the IB ACTION TYPE
	;;^DIC(350,"%D",15,0)
	;;=entry that cancels the original entry.  An entry is edited by creating
	;;^DIC(350,"%D",16,0)
	;;=the cancellation entry and then adding an updated new entry.  All entries
	;;^DIC(350,"%D",17,0)
	;;=related to the original entry will be related by the PARENT LINK field.
	;;^DIC(350,"%D",18,0)
	;;= 
	;;^DIC(350,"%D",19,0)
	;;=There is also an IB ACTION type that is an event, which may include
	;;^DIC(350,"%D",20,0)
	;;=Hospital admissions, NHCU admissions, and outpatient visits.  All of
	;;^DIC(350,"%D",21,0)
	;;=the charges associated with an event will be related to that event by
	;;^DIC(350,"%D",22,0)
	;;=the EVENT LINK field.
	;;^DIC(350,"%D",23,0)
	;;= 
	;;^DIC(350,"%D",24,0)
	;;= 
	;;^DIC(350,"%D",25,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350,0)
	;;=FIELD^^15^23
	;;^DD(350,0,"DIK")
	;;=IBXA
	;;^DD(350,0,"DT")
	;;=2930823
	;;^DD(350,0,"IX","ABIL",350,.11)
	;;=
	;;^DD(350,0,"IX","AC",350,.05)
	;;=
	;;^DD(350,0,"IX","ACT",350,.05)
	;;=
	;;^DD(350,0,"IX","ACT1",350,.16)
	;;=
	;;^DD(350,0,"IX","ACVA",350,.02)
	;;=
	;;^DD(350,0,"IX","ACVA1",350,15)
	;;=
	;;^DD(350,0,"IX","AD",350,.09)
	;;=
	;;^DD(350,0,"IX","AE",350,.03)
	;;=
	;;^DD(350,0,"IX","AF",350,.16)
	;;=
	;;^DD(350,0,"IX","AFDT",350,.02)
	;;=
	;;^DD(350,0,"IX","AFDT1",350,.17)
	;;=
	;;^DD(350,0,"IX","AH",350,.05)
	;;=
	;;^DD(350,0,"IX","AH1",350,.02)
	;;=
	;;^DD(350,0,"IX","AI",350,.05)
	;;=
	;;^DD(350,0,"IX","AI1",350,.02)
	;;=
	;;^DD(350,0,"IX","APDT",350,.09)
	;;=
	;;^DD(350,0,"IX","APDT1",350,12)
	;;=
	;;^DD(350,0,"IX","APTDT",350,.02)
	;;=
	;;^DD(350,0,"IX","APTDT1",350,12)
	;;=
	;;^DD(350,0,"IX","AT",350,.12)
	;;=
	;;^DD(350,0,"IX","B",350,.01)
	;;=
	;;^DD(350,0,"IX","C",350,.02)
	;;=
	;;^DD(350,0,"IX","D",350,12)
	;;=
	;;^DD(350,0,"NM","INTEGRATED BILLING ACTION")
	;;=
	;;^DD(350,0,"PT",52,106)
	;;=
	;;^DD(350,0,"PT",52.1,9)
	;;=
	;;^DD(350,0,"PT",350,.09)
	;;=
	;;^DD(350,0,"PT",350,.16)
	;;=
	;;^DD(350,0,"PT",351.2,.04)
	;;=
	;;^DD(350,0,"PT",351.3,.02)
	;;=
	;;^DD(350,.01,0)
	;;=REFERENCE NUMBER^RNJ12,0I^^0;1^K:+X'=X!(X>999999999999)!(X<1000)!(X?.E1"."1N.N) X
	;;^DD(350,.01,1,0)
	;;=^.1
	;;^DD(350,.01,1,1,0)
	;;=350^B
	;;^DD(350,.01,1,1,1)
	;;=S ^IB("B",$E(X,1,30),DA)=""
	;;^DD(350,.01,1,1,2)
	;;=K ^IB("B",$E(X,1,30),DA)
	;;^DD(350,.01,3)
	;;=Type a Number between 1000 and 999999999999, 0 Decimal Digits
