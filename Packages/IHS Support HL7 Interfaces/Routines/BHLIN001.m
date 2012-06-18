BHLIN001 ; ; 7-JUL-1997
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"BUL",94,0)
 ;;=BHLBPS RX-PCC LINK DATA ERROR^Rx => PCC DATA ERROR
 ;;^UTILITY(U,$J,"BUL",94,1,0)
 ;;=^^31^31^2961002^^^
 ;;^UTILITY(U,$J,"BUL",94,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,2,0)
 ;;=This is a message to inform you that a data error was detected while
 ;;^UTILITY(U,$J,"BUL",94,1,3,0)
 ;;=processing an HL7 message from the COTS Pharmacy system.  Depending on
 ;;^UTILITY(U,$J,"BUL",94,1,4,0)
 ;;=the type of error that was detected, inaccurate data may have been entered
 ;;^UTILITY(U,$J,"BUL",94,1,5,0)
 ;;=into the PCC database, and it may be necessary to correct one or more
 ;;^UTILITY(U,$J,"BUL",94,1,6,0)
 ;;=items in the PCC database.  After noting the errors listed below, refer
 ;;^UTILITY(U,$J,"BUL",94,1,7,0)
 ;;=to the IHS HL7 technical manual for information on how to correct each
 ;;^UTILITY(U,$J,"BUL",94,1,8,0)
 ;;=error.
 ;;^UTILITY(U,$J,"BUL",94,1,9,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,10,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,11,0)
 ;;=DATA RECEIVED:
 ;;^UTILITY(U,$J,"BUL",94,1,12,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,13,0)
 ;;= PCC patient name:       |1|
 ;;^UTILITY(U,$J,"BUL",94,1,14,0)
 ;;= Pharmacy patient name:  |2|
 ;;^UTILITY(U,$J,"BUL",94,1,15,0)
 ;;= Patient's chart number: |3|
 ;;^UTILITY(U,$J,"BUL",94,1,16,0)
 ;;= Drug name:              |4|
 ;;^UTILITY(U,$J,"BUL",94,1,17,0)
 ;;= Drug dispense date:     |5|
 ;;^UTILITY(U,$J,"BUL",94,1,18,0)
 ;;= Ordering provider:      |6|
 ;;^UTILITY(U,$J,"BUL",94,1,19,0)
 ;;= PCC provider name:      |7|
 ;;^UTILITY(U,$J,"BUL",94,1,20,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,21,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,22,0)
 ;;=ERRORS DETECTED:
 ;;^UTILITY(U,$J,"BUL",94,1,23,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,24,0)
 ;;= |8|
 ;;^UTILITY(U,$J,"BUL",94,1,25,0)
 ;;= |9|
 ;;^UTILITY(U,$J,"BUL",94,1,26,0)
 ;;= |10|
 ;;^UTILITY(U,$J,"BUL",94,1,27,0)
 ;;= |11|
 ;;^UTILITY(U,$J,"BUL",94,1,28,0)
 ;;= |12|
 ;;^UTILITY(U,$J,"BUL",94,1,29,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",94,1,30,0)
 ;;=For detailed information on how to correct these errors, see the IHS HL7
 ;;^UTILITY(U,$J,"BUL",94,1,31,0)
 ;;=technical manual.
 ;;^UTILITY(U,$J,"BUL",94,3,0)
 ;;=^^2^2^2961002^^^^
 ;;^UTILITY(U,$J,"BUL",94,3,1,0)
 ;;=This bulletin is sent when a rx is passed from the COTS Pharmacy
 ;;^UTILITY(U,$J,"BUL",94,3,2,0)
 ;;=system and a data error or mismatch is detected.
 ;;^UTILITY(U,$J,"BUL",94,4,0)
 ;;=^3.64A^1^1
 ;;^UTILITY(U,$J,"BUL",94,4,1,0)
 ;;=1
 ;;^UTILITY(U,$J,"BUL",95,0)
 ;;=BHLBPS RX-PCC MESSAGE ERROR^Rx => PCC MESSAGE ERROR
 ;;^UTILITY(U,$J,"BUL",95,1,0)
 ;;=^^10^10^2961003^
 ;;^UTILITY(U,$J,"BUL",95,1,1,0)
 ;;=This is a message to inform you that a message from the COTS pharmacy
 ;;^UTILITY(U,$J,"BUL",95,1,2,0)
 ;;=system could not be processed due to an error condition.  The specific
 ;;^UTILITY(U,$J,"BUL",95,1,3,0)
 ;;=error is listed below.  The pharmacy message was rejected and the COTS
 ;;^UTILITY(U,$J,"BUL",95,1,4,0)
 ;;=pharmacy system was notified of the error via an HL7 Application Error
 ;;^UTILITY(U,$J,"BUL",95,1,5,0)
 ;;=message.  After noting the error listed below, please refer to the
 ;;^UTILITY(U,$J,"BUL",95,1,6,0)
 ;;=IHS HL7 technical manual for information on how to resolve the error.
 ;;^UTILITY(U,$J,"BUL",95,1,7,0)
 ;;= 
 ;;^UTILITY(U,$J,"BUL",95,1,8,0)
 ;;=Error Message: |1|
 ;;^UTILITY(U,$J,"BUL",95,1,9,0)
 ;;=Error Data:    |2|
 ;;^UTILITY(U,$J,"BUL",95,1,10,0)
 ;;=Message IEN:   |3|
 ;;^UTILITY(U,$J,"BUL",95,3,0)
 ;;=^^3^3^2961003^^^^
 ;;^UTILITY(U,$J,"BUL",95,3,1,0)
 ;;=This bulletin is sent when a message from the COTS pharmacy system
 ;;^UTILITY(U,$J,"BUL",95,3,2,0)
 ;;=is rejected for processing by the BHLBPS pharmacy application due to
 ;;^UTILITY(U,$J,"BUL",95,3,3,0)
 ;;=an error condition.
 ;;^UTILITY(U,$J,"PKG",237,0)
 ;;=IHS SUPPORT FOR HL7 INTERFACES^BHL^This package is utilized for the electronic exchange of data
 ;;^UTILITY(U,$J,"PKG",237,22,0)
 ;;=^9.49I^1^1
 ;;^UTILITY(U,$J,"PKG",237,22,1,0)
 ;;=1.0^2970707
 ;;^UTILITY(U,$J,"PKG",237,22,"B","1.0",1)
 ;;=
