IBINI06Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.6,0,"GL")
	;;=^IBE(356.6,
	;;^DIC("B","CLAIMS TRACKING TYPE",356.6)
	;;=
	;;^DIC(356.6,"%D",0)
	;;=^^8^8^2940214^^^^
	;;^DIC(356.6,"%D",1,0)
	;;=This file contains the types of events that can be stored in Claims
	;;^DIC(356.6,"%D",2,0)
	;;=Tracking.  It also contains data on how the automated biller is to
	;;^DIC(356.6,"%D",3,0)
	;;=handle each type of event.  
	;;^DIC(356.6,"%D",4,0)
	;;= 
	;;^DIC(356.6,"%D",5,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.6,"%D",6,0)
	;;=from your ISC.
	;;^DIC(356.6,"%D",7,0)
	;;= 
	;;^DIC(356.6,"%D",8,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.6,0)
	;;=FIELD^^.01^7
	;;^DD(356.6,0,"DT")
	;;=2940309
	;;^DD(356.6,0,"IX","AC",356.6,.08)
	;;=
	;;^DD(356.6,0,"IX","ACODE",356.6,.03)
	;;=
	;;^DD(356.6,0,"IX","B",356.6,.01)
	;;=
	;;^DD(356.6,0,"NM","CLAIMS TRACKING TYPE")
	;;=
	;;^DD(356.6,0,"PT",356,.18)
	;;=
	;;^DD(356.6,.01,0)
	;;=NAME^RFI^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(356.6,.01,1,0)
	;;=^.1
	;;^DD(356.6,.01,1,1,0)
	;;=356.6^B
	;;^DD(356.6,.01,1,1,1)
	;;=S ^IBE(356.6,"B",$E(X,1,30),DA)=""
	;;^DD(356.6,.01,1,1,2)
	;;=K ^IBE(356.6,"B",$E(X,1,30),DA)
	;;^DD(356.6,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(356.6,.01,21,0)
	;;=^^6^6^2940213^^^^
	;;^DD(356.6,.01,21,1,0)
	;;=This is the name of the type of event that can be stored in Claims Tracking.
	;;^DD(356.6,.01,21,2,0)
	;;=Only certain types of events or visits are known to Claims Tracking.  Adding
	;;^DD(356.6,.01,21,3,0)
	;;=or deleting entries can have unwanted effects on the IB package.  Currently
	;;^DD(356.6,.01,21,4,0)
	;;=only inpatient, outpatient, prosthetics, and Rx Refill visits are known 
	;;^DD(356.6,.01,21,5,0)
	;;=to IB.  Future plans call for adding Fee Basis visits.  This is limited
	;;^DD(356.6,.01,21,6,0)
	;;=to those areas that we currently have legislative authority to bill.
	;;^DD(356.6,.01,"DT")
	;;=2930803
	;;^DD(356.6,.02,0)
	;;=ABBREVIATION^F^^0;2^K:$L(X)>8!($L(X)<3) X
	;;^DD(356.6,.02,3)
	;;=Answer must be 3-8 characters in length.
	;;^DD(356.6,.02,21,0)
	;;=^^2^2^2931128^
	;;^DD(356.6,.02,21,1,0)
	;;=Enter the 3-8 character abbreviation for this entry that will be used 
	;;^DD(356.6,.02,21,2,0)
	;;=on display screens and outputs.
	;;^DD(356.6,.02,"DT")
	;;=2930628
	;;^DD(356.6,.03,0)
	;;=TYPE CODE^SI^1:INPATIENT CARE;2:OUTPATIENT CARE;3:RX REFILL;4:PROSTHETICS;^0;3^Q
	;;^DD(356.6,.03,1,0)
	;;=^.1
	;;^DD(356.6,.03,1,1,0)
	;;=356.6^ACODE
	;;^DD(356.6,.03,1,1,1)
	;;=S ^IBE(356.6,"ACODE",$E(X,1,30),DA)=""
	;;^DD(356.6,.03,1,1,2)
	;;=K ^IBE(356.6,"ACODE",$E(X,1,30),DA)
	;;^DD(356.6,.03,1,1,"DT")
	;;=2930813
	;;^DD(356.6,.03,21,0)
	;;=^^2^2^2940202^^
	;;^DD(356.6,.03,21,1,0)
	;;=Enter the correct type code for this entry.  This type code is used
	;;^DD(356.6,.03,21,2,0)
	;;=internally by the Claims Tracking Module.  Do not edit this field.
	;;^DD(356.6,.03,"DT")
	;;=2930813
	;;^DD(356.6,.04,0)
	;;=AUTOMATE BILLING^S^1:YES;^0;4^Q
	;;^DD(356.6,.04,3)
	;;=Enter "YES" if this type of entry can be automatically billed.
	;;^DD(356.6,.04,21,0)
	;;=^^5^5^2931021^^^^
	;;^DD(356.6,.04,21,1,0)
	;;=This will control the automated creation of bills for each type of care.
	;;^DD(356.6,.04,21,2,0)
	;;= 
	;;^DD(356.6,.04,21,3,0)
	;;=If this is "Y"es then the Earliest Auto Bill date will be automatically
	;;^DD(356.6,.04,21,4,0)
	;;=added to billable events.  These events can then be added to bills by
	;;^DD(356.6,.04,21,5,0)
	;;=the automated biller.
