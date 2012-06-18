IBINI083	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,.01,1,2,"DT")
	;;=2930409
	;;^DD(357.6,.01,3)
	;;=Answer must be 3-40 characters in length. All entries with Action Type other than PRINT REPORT must be be prefixed with the namespace of the package that is responsible for the data.
	;;^DD(357.6,.01,21,0)
	;;=^^3^3^2940110^^^
	;;^DD(357.6,.01,21,1,0)
	;;= 
	;;^DD(357.6,.01,21,2,0)
	;;=The name of the Package Interface. For interfaces returning data the name
	;;^DD(357.6,.01,21,3,0)
	;;=should be preceded with the namespace of the package.
	;;^DD(357.6,.01,"DT")
	;;=2930409
	;;^DD(357.6,.02,0)
	;;=ENTRY POINT^RF^^0;2^K:$L(X)>8!($L(X)<1) X
	;;^DD(357.6,.02,3)
	;;=What entry point into the routine does this package interface use?
	;;^DD(357.6,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.6,.02,21,1,0)
	;;= 
	;;^DD(357.6,.02,21,2,0)
	;;=The entry point in the routine that should be called.
	;;^DD(357.6,.02,"DT")
	;;=2921125
	;;^DD(357.6,.03,0)
	;;=ROUTINE^F^^0;3^K:$L(X)>8!($L(X)<1) X
	;;^DD(357.6,.03,3)
	;;=What routine does this package interface use?
	;;^DD(357.6,.03,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.6,.03,21,1,0)
	;;= 
	;;^DD(357.6,.03,21,2,0)
	;;=The routine that should be called.
	;;^DD(357.6,.03,"DT")
	;;=2921125
	;;^DD(357.6,.04,0)
	;;=CUSTODIAL PACKAGE^F^^0;4^K:$L(X)>20!($L(X)<3) X
	;;^DD(357.6,.04,1,0)
	;;=^.1
	;;^DD(357.6,.04,1,1,0)
	;;=357.6^C
	;;^DD(357.6,.04,1,1,1)
	;;=S ^IBE(357.6,"C",$E(X,1,30),DA)=""
	;;^DD(357.6,.04,1,1,2)
	;;=K ^IBE(357.6,"C",$E(X,1,30),DA)
	;;^DD(357.6,.04,1,1,"DT")
	;;=2921229
	;;^DD(357.6,.04,3)
	;;=For Package Interfaces that return data the Custodial Package is the package that is providing the data. For Package Interfaces that print reports it is the package that is providing the report.
	;;^DD(357.6,.04,21,0)
	;;=^^2^2^2940217^
	;;^DD(357.6,.04,21,1,0)
	;;=This is a free text pointer to the package file. It serves only to
	;;^DD(357.6,.04,21,2,0)
	;;=document the custodial package of the data.
	;;^DD(357.6,.04,"DT")
	;;=2930726
	;;^DD(357.6,.05,0)
	;;=VARIABLE DATA?^S^0:NO;1:YES;^0;5^Q
	;;^DD(357.6,.05,.1)
	;;=DOES THE DATA VARY FROM PATIENT TO PATIENT?
	;;^DD(357.6,.05,3)
	;;=Enter YES if the data returned is variable, NO if the data is always the same.
	;;^DD(357.6,.05,21,0)
	;;=^^3^3^2930726^^^
	;;^DD(357.6,.05,21,1,0)
	;;=This field is used in the batch printing of encounter forms. The purpose
	;;^DD(357.6,.05,21,2,0)
	;;=is to avoid recomputing fields whose data does not change from patient to
	;;^DD(357.6,.05,21,3,0)
	;;=patient.
	;;^DD(357.6,.05,"DT")
	;;=2931124
	;;^DD(357.6,.06,0)
	;;=ACTION TYPE^RS^1:INPUT ROUTINE;2:OUTPUT ROUTINE;3:SELECTION ROUTINE;4:PRINT REPORT;^0;6^Q
	;;^DD(357.6,.06,3)
	;;=Is this package interface for displaying data to the form, for inputing data, or for creating a list that will appear on the form?
	;;^DD(357.6,.06,21,0)
	;;=^^8^8^2940217^
	;;^DD(357.6,.06,21,1,0)
	;;= 
	;;^DD(357.6,.06,21,2,0)
	;;=Enter 1 for INPUT ROUTINE if the routine accepts data input from the user
	;;^DD(357.6,.06,21,3,0)
	;;=and transmits the data to the appropriate package. Enter 2 for OUTPUT
	;;^DD(357.6,.06,21,4,0)
	;;=ROUTINE if the routine gets data from another package. Enter 3 for
	;;^DD(357.6,.06,21,5,0)
	;;=SELECTION ROUTINE if the routine allows the user to select items from a
	;;^DD(357.6,.06,21,6,0)
	;;=table belonging to another package. If the ACTION TYPE is SELECTION ROUTINE
	;;^DD(357.6,.06,21,7,0)
	;;=then the data type must be record and the first piece must be the ID passed
	;;^DD(357.6,.06,21,8,0)
	;;=by the other package.
	;;^DD(357.6,.06,"DT")
	;;=2930518
