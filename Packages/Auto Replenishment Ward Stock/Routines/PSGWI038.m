PSGWI038 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",191,"U")
 ;;=ENTER AMIS DATA FOR ALL DRUGS/
 ;;^UTILITY(U,$J,"OPT",192,0)
 ;;=PSGW PRINT AMIS WORKSHEET^Print AMIS Worksheet (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",192,1,0)
 ;;=^^3^3^2891019^^^
 ;;^UTILITY(U,$J,"OPT",192,1,1,0)
 ;;=This option prints a worksheet to be used in classifying AR/WS
 ;;^UTILITY(U,$J,"OPT",192,1,2,0)
 ;;=drugs for AMIS.  The print order is by "type", and within type
 ;;^UTILITY(U,$J,"OPT",192,1,3,0)
 ;;=the drug listing is alphabetical.
 ;;^UTILITY(U,$J,"OPT",192,25)
 ;;=PSGWPAW
 ;;^UTILITY(U,$J,"OPT",192,"U")
 ;;=PRINT AMIS WORKSHEET (80 COLUM
 ;;^UTILITY(U,$J,"OPT",193,0)
 ;;=PSGW PRINT DATA FOR AMIS STATS^Data for AMIS Stats - Print (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",193,1,0)
 ;;=^^2^2^2890410^^^
 ;;^UTILITY(U,$J,"OPT",193,1,1,0)
 ;;=This report will show the current data stored in the Drug File which
 ;;^UTILITY(U,$J,"OPT",193,1,2,0)
 ;;=will affect AR/WS AMIS statistics.
 ;;^UTILITY(U,$J,"OPT",193,25)
 ;;=PSGWADP
 ;;^UTILITY(U,$J,"OPT",193,"U")
 ;;=DATA FOR AMIS STATS - PRINT (1
 ;;^UTILITY(U,$J,"OPT",194,0)
 ;;=PSGW AOU RETURNS & AMIS COUNT^Identify AOU Returns & AMIS Count^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",194,1,0)
 ;;=^^8^8^2930622^^^^
 ;;^UTILITY(U,$J,"OPT",194,1,1,0)
 ;;=For AMIS purposes, the system must know how to credit returns.
 ;;^UTILITY(U,$J,"OPT",194,1,2,0)
 ;;=This option allows the user to identify the "usual" method of
 ;;^UTILITY(U,$J,"OPT",194,1,3,0)
 ;;=drug distribution to be credited for each AOU.  ALL returns
 ;;^UTILITY(U,$J,"OPT",194,1,4,0)
 ;;=from the AOU will be credited to this method.
 ;;^UTILITY(U,$J,"OPT",194,1,5,0)
 ;;=For AMIS purposes, the system must know if the inventories for
 ;;^UTILITY(U,$J,"OPT",194,1,6,0)
 ;;=each AOU are to be counted in the AR/WS Stats File.
 ;;^UTILITY(U,$J,"OPT",194,1,7,0)
 ;;=MOST AOUs will count on AMIS, however, an AOU used for internal
 ;;^UTILITY(U,$J,"OPT",194,1,8,0)
 ;;=inventory purposes within the pharmacy should not.
 ;;^UTILITY(U,$J,"OPT",194,25)
 ;;=PSGWAOU
 ;;^UTILITY(U,$J,"OPT",194,"U")
 ;;=IDENTIFY AOU RETURNS & AMIS CO
 ;;^UTILITY(U,$J,"OPT",195,0)
 ;;=PSGW AOU RET/AMIS CT PRINT^Show AOU Status for AMIS (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",195,1,0)
 ;;=^^3^3^2890706^^^^
 ;;^UTILITY(U,$J,"OPT",195,1,1,0)
 ;;=This option shows the method of distribution credited for RETURNS
 ;;^UTILITY(U,$J,"OPT",195,1,2,0)
 ;;=for each AOU, and if the AOU is to be counted in AMIS stats.
 ;;^UTILITY(U,$J,"OPT",195,1,3,0)
 ;;=This option also displays the INPATIENT SITE designation for the AOU.
 ;;^UTILITY(U,$J,"OPT",195,25)
 ;;=PSGWRAC
 ;;^UTILITY(U,$J,"OPT",195,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",195,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",195,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",195,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",195,"U")
 ;;=SHOW AOU STATUS FOR AMIS (80 C
 ;;^UTILITY(U,$J,"OPT",196,0)
 ;;=PSGW AMIS^AR/WS AMIS Report^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",196,1,0)
 ;;=^^2^2^2890126^^^^
 ;;^UTILITY(U,$J,"OPT",196,1,1,0)
 ;;=Main option for clearing exceptions, printing, and recalculating
 ;;^UTILITY(U,$J,"OPT",196,1,2,0)
 ;;=the AMIS report.
 ;;^UTILITY(U,$J,"OPT",196,10,0)
 ;;=^19.01PI^3^3
 ;;^UTILITY(U,$J,"OPT",196,10,1,0)
 ;;=197^^1
 ;;^UTILITY(U,$J,"OPT",196,10,1,"^")
 ;;=PSGW CLEAR AMIS EXCEPTIONS
 ;;^UTILITY(U,$J,"OPT",196,10,2,0)
 ;;=198^^3
 ;;^UTILITY(U,$J,"OPT",196,10,2,"^")
 ;;=PSGW RECALCULATE AMIS
 ;;^UTILITY(U,$J,"OPT",196,10,3,0)
 ;;=199^^2
 ;;^UTILITY(U,$J,"OPT",196,10,3,"^")
 ;;=PSGW PRINT AMIS REPORT
 ;;^UTILITY(U,$J,"OPT",196,99)
 ;;=55612,32989
 ;;^UTILITY(U,$J,"OPT",196,"U")
 ;;=AR/WS AMIS REPORT
 ;;^UTILITY(U,$J,"OPT",197,0)
 ;;=PSGW CLEAR AMIS EXCEPTIONS^Incomplete AMIS Data^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",197,1,0)
 ;;=^^7^7^2910304^^^^
 ;;^UTILITY(U,$J,"OPT",197,1,1,0)
 ;;=This option loops through the "AEX" - exceptions cross-reference in the
 ;;^UTILITY(U,$J,"OPT",197,1,2,0)
 ;;=AR/WS Stats File - 58.5.  Drugs in this cross-reference had data
 ;;^UTILITY(U,$J,"OPT",197,1,3,0)
 ;;=missing from the Drug file at the time the quantity was dispensed,
