PSJVI003 ;BIR/-APR-1994;
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",3832,0)
 ;;=PSJV NPU REPORT^New Person User Report^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3832,1,0)
 ;;=^^5^5^2920322^
 ;;^UTILITY(U,$J,"OPT",3832,1,1,0)
 ;;=  This shows the sites how version 4 of the Inpatient Medications package
 ;;^UTILITY(U,$J,"OPT",3832,1,2,0)
 ;;=will see users - as a pharmacist, nurse, pharmacy technician or ward clerk.
 ;;^UTILITY(U,$J,"OPT",3832,1,3,0)
 ;;=This report will also show users that version 4 will see as valid medication
 ;;^UTILITY(U,$J,"OPT",3832,1,4,0)
 ;;=providers.  Users not listed on the report will be seen by version 4 as
 ;;^UTILITY(U,$J,"OPT",3832,1,5,0)
 ;;=ward clerks.
 ;;^UTILITY(U,$J,"OPT",3832,25)
 ;;=ENTOUR^PSJPRE41
 ;;^UTILITY(U,$J,"OPT",3832,"U")
 ;;=NEW PERSON USER REPORT
 ;;^UTILITY(U,$J,"OPT",4284,0)
 ;;=PSJV ADDITIVE TYPE PRINT^IV Additive Type Print^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",4284,1,0)
 ;;=^^4^4^2940301^^
 ;;^UTILITY(U,$J,"OPT",4284,1,1,0)
 ;;=  This print lists IV additives and the additive type, if one has been
 ;;^UTILITY(U,$J,"OPT",4284,1,2,0)
 ;;=entered. This report may be run to list all additives, or only those
 ;;^UTILITY(U,$J,"OPT",4284,1,3,0)
 ;;=assigned a type. This may be helpful when identifying additives as
 ;;^UTILITY(U,$J,"OPT",4284,1,4,0)
 ;;=multivitamins or electrolytes for use in IV Fluid order entry.
 ;;^UTILITY(U,$J,"OPT",4284,25)
 ;;=ENAD^PSJPRE48
 ;;^UTILITY(U,$J,"OPT",4284,"U")
 ;;=IV ADDITIVE TYPE PRINT
 ;;^UTILITY(U,$J,"PKG",172,0)
 ;;=PSJV^PSJV^INPATIENT MEDS 4.5 VIRGIN INSTALL OPTIONS
 ;;^UTILITY(U,$J,"PKG",172,1,0)
 ;;=^^4^4^2940426^^^^
 ;;^UTILITY(U,$J,"PKG",172,1,1,0)
 ;;=This is a set of utilities to create data for use with version 4.5 of the 
 ;;^UTILITY(U,$J,"PKG",172,1,2,0)
 ;;=Inpatient Medications package. By installing this package and running the 
 ;;^UTILITY(U,$J,"PKG",172,1,3,0)
 ;;=options, the site can have the data ready for version 4.5. This will allow
 ;;^UTILITY(U,$J,"PKG",172,1,4,0)
 ;;=the site to run version 4.5 immediately after it is installed.
 ;;^UTILITY(U,$J,"PKG",172,4,0)
 ;;=^9.44PA^^0
 ;;^UTILITY(U,$J,"PKG",172,22,0)
 ;;=^9.49I^2^2
 ;;^UTILITY(U,$J,"PKG",172,22,1,0)
 ;;=4.5T1^2940301
 ;;^UTILITY(U,$J,"PKG",172,22,2,0)
 ;;=4.5T3^2940426
 ;;^UTILITY(U,$J,"PKG",172,22,"B","4.5T1",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",172,22,"B","4.5T3",2)
 ;;=
 ;;^UTILITY(U,$J,"PKG",172,"M",0)
 ;;=^9.495^1^1
 ;;^UTILITY(U,$J,"PKG",172,"M",1,0)
 ;;=PSJV MGR^3752
 ;;^UTILITY(U,$J,"PKG",172,"M","B","PSJV MGR",1)
 ;;=
