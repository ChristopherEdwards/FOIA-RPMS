FHINI0NG	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1440,10,1,0)
	;;=1434^OD
	;;^UTILITY(U,$J,"OPT",1440,10,1,"^")
	;;=FHORD1
	;;^UTILITY(U,$J,"OPT",1440,10,3,0)
	;;=1436^ON
	;;^UTILITY(U,$J,"OPT",1440,10,3,"^")
	;;=FHORD3
	;;^UTILITY(U,$J,"OPT",1440,10,4,0)
	;;=1437^PI
	;;^UTILITY(U,$J,"OPT",1440,10,4,"^")
	;;=FHORD4
	;;^UTILITY(U,$J,"OPT",1440,10,5,0)
	;;=1438^PH
	;;^UTILITY(U,$J,"OPT",1440,10,5,"^")
	;;=FHORD2
	;;^UTILITY(U,$J,"OPT",1440,10,8,0)
	;;=1454^OE
	;;^UTILITY(U,$J,"OPT",1440,10,8,"^")
	;;=FHOREL2
	;;^UTILITY(U,$J,"OPT",1440,10,9,0)
	;;=1455^XE
	;;^UTILITY(U,$J,"OPT",1440,10,9,"^")
	;;=FHOREL3
	;;^UTILITY(U,$J,"OPT",1440,10,13,0)
	;;=1452^OT
	;;^UTILITY(U,$J,"OPT",1440,10,13,"^")
	;;=FHORTF3
	;;^UTILITY(U,$J,"OPT",1440,10,14,0)
	;;=1456^XT
	;;^UTILITY(U,$J,"OPT",1440,10,14,"^")
	;;=FHORTF4
	;;^UTILITY(U,$J,"OPT",1440,10,17,0)
	;;=1461^PP
	;;^UTILITY(U,$J,"OPT",1440,10,17,"^")
	;;=FHORD9
	;;^UTILITY(U,$J,"OPT",1440,10,21,0)
	;;=1473^XN
	;;^UTILITY(U,$J,"OPT",1440,10,21,"^")
	;;=FHORD12
	;;^UTILITY(U,$J,"OPT",1440,10,23,0)
	;;=1483^OA
	;;^UTILITY(U,$J,"OPT",1440,10,23,"^")
	;;=FHORO1
	;;^UTILITY(U,$J,"OPT",1440,10,24,0)
	;;=1563^PF
	;;^UTILITY(U,$J,"OPT",1440,10,24,"^")
	;;=FHSEL3
	;;^UTILITY(U,$J,"OPT",1440,10,25,0)
	;;=1833^PA
	;;^UTILITY(U,$J,"OPT",1440,10,25,"^")
	;;=GMRA PATIENT A/AR EDIT
	;;^UTILITY(U,$J,"OPT",1440,10,26,0)
	;;=1823^EP
	;;^UTILITY(U,$J,"OPT",1440,10,26,"^")
	;;=FHMTKE
	;;^UTILITY(U,$J,"OPT",1440,15)
	;;=
	;;^UTILITY(U,$J,"OPT",1440,20)
	;;=S FHA1=3 D ^FHVER
	;;^UTILITY(U,$J,"OPT",1440,99)
	;;=56496,40778
	;;^UTILITY(U,$J,"OPT",1440,"U")
	;;=DIET ORDERS
	;;^UTILITY(U,$J,"OPT",1441,0)
	;;=FHORC6^List Ward Assignments^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1441,1,0)
	;;=^^2^2^2880717^^^
	;;^UTILITY(U,$J,"OPT",1441,1,1,0)
	;;=This option will list all Dietetic Wards and the assigned
	;;^UTILITY(U,$J,"OPT",1441,1,2,0)
	;;=clinician.
	;;^UTILITY(U,$J,"OPT",1441,25)
	;;=EN10^FHORC5
	;;^UTILITY(U,$J,"OPT",1441,"U")
	;;=LIST WARD ASSIGNMENTS
	;;^UTILITY(U,$J,"OPT",1442,0)
	;;=FHORC7^Enter/Edit Consult Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1442,1,0)
	;;=^^2^2^2880717^^^
	;;^UTILITY(U,$J,"OPT",1442,1,1,0)
	;;=This option allows for the creation/editing of consult types
	;;^UTILITY(U,$J,"OPT",1442,1,2,0)
	;;=in the Dietetic Consults file (119.5).
	;;^UTILITY(U,$J,"OPT",1442,25)
	;;=EN11^FHORC5
	;;^UTILITY(U,$J,"OPT",1442,"U")
	;;=ENTER/EDIT CONSULT TYPES
	;;^UTILITY(U,$J,"OPT",1443,0)
	;;=FHORC8^List Consult Types^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1443,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1443,1,1,0)
	;;=This option will print the various consult types contained in
	;;^UTILITY(U,$J,"OPT",1443,1,2,0)
	;;=the Dietetic Consults file (119.5) along with associated
	;;^UTILITY(U,$J,"OPT",1443,1,3,0)
	;;=data elements.
	;;^UTILITY(U,$J,"OPT",1443,25)
	;;=EN12^FHORC5
	;;^UTILITY(U,$J,"OPT",1443,"U")
	;;=LIST CONSULT TYPES
	;;^UTILITY(U,$J,"OPT",1444,0)
	;;=FHORC9^Re-Assign Active Consults^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1444,1,0)
	;;=^^4^4^2880717^
	;;^UTILITY(U,$J,"OPT",1444,1,1,0)
	;;=This option will allow re-assignments of all active consults
	;;^UTILITY(U,$J,"OPT",1444,1,2,0)
	;;=from one clinician to another. It is primarily used when a
	;;^UTILITY(U,$J,"OPT",1444,1,3,0)
	;;=clinician is reassigned to other duties, leaves, or will be
	;;^UTILITY(U,$J,"OPT",1444,1,4,0)
	;;=on leave for an extended period.
	;;^UTILITY(U,$J,"OPT",1444,25)
	;;=FHORC4
	;;^UTILITY(U,$J,"OPT",1444,"U")
	;;=RE-ASSIGN ACTIVE CONSULTS
	;;^UTILITY(U,$J,"OPT",1445,0)
	;;=FHORC10^Consult Statistics^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1445,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1445,1,1,0)
	;;=This option will, for any specified period of time, produce
	;;^UTILITY(U,$J,"OPT",1445,1,2,0)
	;;=an optional listing of all completed consults as well as
	;;^UTILITY(U,$J,"OPT",1445,1,3,0)
	;;='time units' by consult type and totals.
	;;^UTILITY(U,$J,"OPT",1445,25)
	;;=FHORC3
	;;^UTILITY(U,$J,"OPT",1445,"U")
	;;=CONSULT STATISTICS
	;;^UTILITY(U,$J,"OPT",1446,0)
	;;=FHORC2^Review Active Consults^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1446,1,0)
	;;=^^3^3^2880716^^
	;;^UTILITY(U,$J,"OPT",1446,1,1,0)
	;;=This option allows a clinician or supervisor to review all
	;;^UTILITY(U,$J,"OPT",1446,1,2,0)
	;;=active (e.g., not completed or cancelled) consults for
	;;^UTILITY(U,$J,"OPT",1446,1,3,0)
	;;=themselves or for all clinicians.
	;;^UTILITY(U,$J,"OPT",1446,25)
	;;=FHORC1
	;;^UTILITY(U,$J,"OPT",1446,"U")
	;;=REVIEW ACTIVE CONSULTS
	;;^UTILITY(U,$J,"OPT",1447,0)
	;;=FHORC3^Consult Inquiry^^R^^^^^^^^
	;;^UTILITY(U,$J,"OPT",1447,1,0)
	;;=^^2^2^2880716^^
	;;^UTILITY(U,$J,"OPT",1447,1,1,0)
	;;=This option displays the consult request, clinician assigned,
