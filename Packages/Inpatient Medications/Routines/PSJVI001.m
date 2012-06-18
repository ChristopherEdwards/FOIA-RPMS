PSJVI001 ;BIR/-APR-1994;
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",1553,0)
 ;;=PSJV MAN CREATE PD^Create Primary Drug (Manual)^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",1553,1,0)
 ;;=^^4^4^2920323^^^^
 ;;^UTILITY(U,$J,"OPT",1553,1,1,0)
 ;;=  This allows the user to create primary drugs and tie them to current
 ;;^UTILITY(U,$J,"OPT",1553,1,2,0)
 ;;=entries in the drug file.  Primary drugs are entries without a strength
 ;;^UTILITY(U,$J,"OPT",1553,1,3,0)
 ;;=or dose form, which are used in entering Medication orders by non-pharmacy
 ;;^UTILITY(U,$J,"OPT",1553,1,4,0)
 ;;=personnel.
 ;;^UTILITY(U,$J,"OPT",1553,25)
 ;;=PSJPRE4
 ;;^UTILITY(U,$J,"OPT",1553,"U")
 ;;=CREATE PRIMARY DRUG (MANUAL)
 ;;^UTILITY(U,$J,"OPT",1557,0)
 ;;=PSJV MGR^Inpatient Meds V4 Pre-Release Menu^^M^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",1557,1,0)
 ;;=^^3^3^2940301^^^^
 ;;^UTILITY(U,$J,"OPT",1557,1,1,0)
 ;;=  This is a set of options that allow a site to set up various parts of
 ;;^UTILITY(U,$J,"OPT",1557,1,2,0)
 ;;=the Inpatient Medications package so that the site can use the package
 ;;^UTILITY(U,$J,"OPT",1557,1,3,0)
 ;;=immediately after installing version 4 of the package.
 ;;^UTILITY(U,$J,"OPT",1557,10,0)
 ;;=^19.01PI^22^22
 ;;^UTILITY(U,$J,"OPT",1557,10,6,0)
 ;;=1553^
 ;;^UTILITY(U,$J,"OPT",1557,10,6,"^")
 ;;=PSJV MAN CREATE PD
 ;;^UTILITY(U,$J,"OPT",1557,10,9,0)
 ;;=1559^
 ;;^UTILITY(U,$J,"OPT",1557,10,9,"^")
 ;;=PSJV DRG PRINT
 ;;^UTILITY(U,$J,"OPT",1557,10,10,0)
 ;;=3751^
 ;;^UTILITY(U,$J,"OPT",1557,10,10,"^")
 ;;=PSJV ACP
 ;;^UTILITY(U,$J,"OPT",1557,10,11,0)
 ;;=3752^
 ;;^UTILITY(U,$J,"OPT",1557,10,11,"^")
 ;;=PSJV AC
 ;;^UTILITY(U,$J,"OPT",1557,10,13,0)
 ;;=3754^
 ;;^UTILITY(U,$J,"OPT",1557,10,14,0)
 ;;=3755^
 ;;^UTILITY(U,$J,"OPT",1557,10,14,"^")
 ;;=PSJV PRIMARY/IV DRUG PRINT
 ;;^UTILITY(U,$J,"OPT",1557,10,16,0)
 ;;=3757^^
 ;;^UTILITY(U,$J,"OPT",1557,10,16,"^")
 ;;=PSJV IV FLUID SOLUTIONS PRINT
 ;;^UTILITY(U,$J,"OPT",1557,10,17,0)
 ;;=3758^
 ;;^UTILITY(U,$J,"OPT",1557,10,17,"^")
 ;;=PSJV PD/DD PRINT
 ;;^UTILITY(U,$J,"OPT",1557,10,18,0)
 ;;=3829^^
 ;;^UTILITY(U,$J,"OPT",1557,10,18,"^")
 ;;=PSJV EDIT PROVIDER
 ;;^UTILITY(U,$J,"OPT",1557,10,19,0)
 ;;=3830^^
 ;;^UTILITY(U,$J,"OPT",1557,10,19,"^")
 ;;=PSJV PROVIDER PRINT
 ;;^UTILITY(U,$J,"OPT",1557,10,20,0)
 ;;=3831^
 ;;^UTILITY(U,$J,"OPT",1557,10,20,"^")
 ;;=PSJV SYNONYM MOVE
 ;;^UTILITY(U,$J,"OPT",1557,10,21,0)
 ;;=3832^
 ;;^UTILITY(U,$J,"OPT",1557,10,21,"^")
 ;;=PSJV NPU REPORT
 ;;^UTILITY(U,$J,"OPT",1557,10,22,0)
 ;;=4284
 ;;^UTILITY(U,$J,"OPT",1557,10,22,"^")
 ;;=PSJV ADDITIVE TYPE PRINT
 ;;^UTILITY(U,$J,"OPT",1557,99)
 ;;=55980,34688
 ;;^UTILITY(U,$J,"OPT",1557,"U")
 ;;=INPATIENT MEDS V4 PRE-RELEASE 
 ;;^UTILITY(U,$J,"OPT",1559,0)
 ;;=PSJV DRG PRINT^Drug Print^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",1559,1,0)
 ;;=^^3^3^2910820^^
 ;;^UTILITY(U,$J,"OPT",1559,1,1,0)
 ;;=  This prints the entries of the site's Drug file, grouped together as
 ;;^UTILITY(U,$J,"OPT",1559,1,2,0)
 ;;=the Create Primary Drug option would group them.  This print may help
 ;;^UTILITY(U,$J,"OPT",1559,1,3,0)
 ;;=the site in deciding their primary drugs.
 ;;^UTILITY(U,$J,"OPT",1559,25)
 ;;=PSJPRE45
 ;;^UTILITY(U,$J,"OPT",1559,"U")
 ;;=DRUG PRINT
 ;;^UTILITY(U,$J,"OPT",3751,0)
 ;;=PSJV ACP^Auto-Create Print^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3751,1,0)
 ;;=^^3^3^2910830^
 ;;^UTILITY(U,$J,"OPT",3751,1,1,0)
 ;;=  This allows the user to print the Unit Dose and IV entries from the local
 ;;^UTILITY(U,$J,"OPT",3751,1,2,0)
 ;;=Drug file and the Primary Drugs that will be created for these entries by
 ;;^UTILITY(U,$J,"OPT",3751,1,3,0)
 ;;=the auto-create option.
 ;;^UTILITY(U,$J,"OPT",3751,25)
 ;;=PSJPRE46
 ;;^UTILITY(U,$J,"OPT",3751,"U")
 ;;=AUTO-CREATE PRINT
 ;;^UTILITY(U,$J,"OPT",3752,0)
 ;;=PSJV AC^Auto-Create Primary Drug^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3752,1,0)
 ;;=^^3^3^2920323^^
 ;;^UTILITY(U,$J,"OPT",3752,1,1,0)
 ;;=  This allows the user to auto-create Primary Drugs for the Unit Dose and
 ;;^UTILITY(U,$J,"OPT",3752,1,2,0)
 ;;=IV entries in the user's Drug file.  The National Drug File must be on-
 ;;^UTILITY(U,$J,"OPT",3752,1,3,0)
 ;;=line in order for this to work.
 ;;^UTILITY(U,$J,"OPT",3752,25)
 ;;=PSJPRE47
 ;;^UTILITY(U,$J,"OPT",3752,"U")
 ;;=AUTO-CREATE PRIMARY DRUG
 ;;^UTILITY(U,$J,"OPT",3755,0)
 ;;=PSJV PRIMARY/IV DRUG PRINT^IV Drug Matched to Primary Drug Print^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3755,1,0)
 ;;=^^4^4^2911002^
 ;;^UTILITY(U,$J,"OPT",3755,1,1,0)
 ;;=  This prints IV additives and solutions, and the generic drug and primary
