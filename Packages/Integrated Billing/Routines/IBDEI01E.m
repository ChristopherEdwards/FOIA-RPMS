IBDEI01E	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.6,.02,"DT")
	;;=2921125
	;;^DD(358.6,.03,0)
	;;=ROUTINE^F^^0;3^K:$L(X)>8!($L(X)<1) X
	;;^DD(358.6,.03,3)
	;;=What routine does this package interface use?
	;;^DD(358.6,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.6,.03,21,1,0)
	;;= 
	;;^DD(358.6,.03,21,2,0)
	;;=The routine that should be called.
	;;^DD(358.6,.03,"DT")
	;;=2921125
	;;^DD(358.6,.04,0)
	;;=CUSTODIAL PACKAGE^F^^0;4^K:$L(X)>20!($L(X)<3) X
	;;^DD(358.6,.04,1,0)
	;;=^.1
	;;^DD(358.6,.04,1,1,0)
	;;=358.6^C
	;;^DD(358.6,.04,1,1,1)
	;;=S ^IBE(358.6,"C",$E(X,1,30),DA)=""
	;;^DD(358.6,.04,1,1,2)
	;;=K ^IBE(358.6,"C",$E(X,1,30),DA)
	;;^DD(358.6,.04,1,1,"DT")
	;;=2921229
	;;^DD(358.6,.04,3)
	;;=For Package Interfaces that return data the Custodial Package is the package that is providing the data. For Package Interfaces that print reports it is the package that is providing the report.
	;;^DD(358.6,.04,21,0)
	;;=^^1^1^2930726^^^^
	;;^DD(358.6,.04,21,1,0)
	;;=This is a free text pointer to the package file.
	;;^DD(358.6,.04,"DT")
	;;=2930726
	;;^DD(358.6,.05,0)
	;;=PATIENT VARIABLE DATA^S^0:NO;1:YES;^0;5^Q
	;;^DD(358.6,.05,.1)
	;;=DOES THE DATA VARY FROM PATIENT TO PATIENT?
	;;^DD(358.6,.05,3)
	;;=Enter YES if the data returned is variable, NO if the data is always the same.
	;;^DD(358.6,.05,21,0)
	;;=^^3^3^2930726^^^
	;;^DD(358.6,.05,21,1,0)
	;;=This field is used in the batch printing of encounter forms. The purpose
	;;^DD(358.6,.05,21,2,0)
	;;=is to avoid recomputing fields whose data does not change from patient to
	;;^DD(358.6,.05,21,3,0)
	;;=patient.
	;;^DD(358.6,.05,"DT")
	;;=2930726
	;;^DD(358.6,.06,0)
	;;=ACTION TYPE^RS^1:INPUT ROUTINE;2:OUTPUT ROUTINE;3:SELECTION ROUTINE;4:PRINT REPORT;^0;6^Q
	;;^DD(358.6,.06,3)
	;;=Is this package interface for displaying data to the form, for inputing data, or for creating a list that will appear on the form?
	;;^DD(358.6,.06,21,0)
	;;=^^8^8^2930518^^^^
	;;^DD(358.6,.06,21,1,0)
	;;= 
	;;^DD(358.6,.06,21,2,0)
	;;=Enter 1 for INPUT ROUTINE if the routine accepts data input from the user
	;;^DD(358.6,.06,21,3,0)
	;;=and transmits the data to the appropriate package. Enter 2 for OUTPUT
	;;^DD(358.6,.06,21,4,0)
	;;=ROUTINE if the routine gets data from another package. Enter 3 for
	;;^DD(358.6,.06,21,6,0)
	;;=table belonging to a foreign package If the ACTION TYPE is SELECTION ROUTINE then
	;;^DD(358.6,.06,21,7,0)
	;;=the data type must be record and the first piece must be the ID passed
	;;^DD(358.6,.06,21,8,0)
	;;=by the other package.
	;;^DD(358.6,.06,"DT")
	;;=2930518
	;;^DD(358.6,.07,0)
	;;=DATA TYPE^S^1:SINGLE VALUE;2:RECORD;3:LIST OF SINGLE VALUES;4:LIST OF RECORDS;5:WORD PROCESSING;^0;7^Q
	;;^DD(358.6,.07,.1)
	;;=WHAT FORMAT WILL THE DATA BE IN?
	;;^DD(358.6,.07,3)
	;;=What format will the data be in?
	;;^DD(358.6,.07,21,0)
	;;=^^8^8^2930527^
	;;^DD(358.6,.07,21,1,0)
	;;=This should only be defined for interfaces that transfer data. It is the
	;;^DD(358.6,.07,21,2,0)
	;;=type of format the data should be in.
	;;^DD(358.6,.07,21,3,0)
	;;= 
	;;^DD(358.6,.07,21,4,0)
	;;=A single value is a string without pieces. A record is a set of strings
	;;^DD(358.6,.07,21,6,0)
	;;=indefinite number of values, each numbered, each containing the same type
	;;^DD(358.6,.07,21,7,0)
	;;=of information. A word processing data type will be in FM format.
	;;^DD(358.6,.07,21,8,0)
	;;=If the ACTION TYPE is SELECTION ROUTINE then the data type must be record.
	;;^DD(358.6,.07,"DT")
	;;=2930726
	;;^DD(358.6,.08,0)
	;;=PRINT COMPLETE^S^0:NO;1:YES;^0;8^Q
	;;^DD(358.6,.08,3)
	;;=If there is insufficient room on the form to print the data, should it be re-printed in full on a separate page?
