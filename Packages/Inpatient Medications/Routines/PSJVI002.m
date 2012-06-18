PSJVI002 ;BIR/-APR-1994;
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",3755,1,2,0)
 ;;=drug linked to them. This print may be run for all additives and solutions, 
 ;;^UTILITY(U,$J,"OPT",3755,1,3,0)
 ;;=or only those linked to a generic drug that has been matched to a primary 
 ;;^UTILITY(U,$J,"OPT",3755,1,4,0)
 ;;=drug. This report may help in matching primary drugs to IV drugs.
 ;;^UTILITY(U,$J,"OPT",3755,25)
 ;;=ENPD^PSJPRE48
 ;;^UTILITY(U,$J,"OPT",3755,99)
 ;;=55115,52388
 ;;^UTILITY(U,$J,"OPT",3755,"U")
 ;;=IV DRUG MATCHED TO PRIMARY DRU
 ;;^UTILITY(U,$J,"OPT",3757,0)
 ;;=PSJV IV FLUID SOLUTIONS PRINT^IV Fluid Solutions Print^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3757,1,0)
 ;;=^^3^3^2911002^
 ;;^UTILITY(U,$J,"OPT",3757,1,1,0)
 ;;=  This print lists solutions and the USED IN IV FLUID ORDER ENTRY field.
 ;;^UTILITY(U,$J,"OPT",3757,1,2,0)
 ;;=This report may be run to list all solutions, or only those marked for
 ;;^UTILITY(U,$J,"OPT",3757,1,3,0)
 ;;=use when entering IV Fluid orders through OE/RR.
 ;;^UTILITY(U,$J,"OPT",3757,25)
 ;;=ENSOL^PSJPRE48
 ;;^UTILITY(U,$J,"OPT",3757,"U")
 ;;=IV FLUID SOLUTIONS PRINT
 ;;^UTILITY(U,$J,"OPT",3758,0)
 ;;=PSJV PD/DD PRINT^Primary Drug/Dispense Drug Report^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3758,1,0)
 ;;=^^4^4^2911002^
 ;;^UTILITY(U,$J,"OPT",3758,1,1,0)
 ;;=  Allows the user to print primary drugs and the dispense drugs tied to
 ;;^UTILITY(U,$J,"OPT",3758,1,2,0)
 ;;=them.  The report can be sorted by primary drug or dispense drug.  The
 ;;^UTILITY(U,$J,"OPT",3758,1,3,0)
 ;;=report can also show exceptions - dispense drugs not yet tied to a primary
 ;;^UTILITY(U,$J,"OPT",3758,1,4,0)
 ;;=drug.
 ;;^UTILITY(U,$J,"OPT",3758,25)
 ;;=PSJPRE40
 ;;^UTILITY(U,$J,"OPT",3758,"U")
 ;;=PRIMARY DRUG/DISPENSE DRUG REP
 ;;^UTILITY(U,$J,"OPT",3829,0)
 ;;=PSJV EDIT PROVIDER^Edit Provider Fields in New Person File^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3829,1,0)
 ;;=^^4^4^2920319^^^^
 ;;^UTILITY(U,$J,"OPT",3829,1,1,0)
 ;;= Allows editing of the AUTHORIZED TO WRITE MED ORDERS and INACTIVE DATE 
 ;;^UTILITY(U,$J,"OPT",3829,1,2,0)
 ;;=(Pharmacy) fields of the NEW PERSON file (200). Only providers who are 
 ;;^UTILITY(U,$J,"OPT",3829,1,3,0)
 ;;=marked as AUTHORIZED TO WRITE MED ORDERS in the NEW PERSON file are 
 ;;^UTILITY(U,$J,"OPT",3829,1,4,0)
 ;;=selectable through Inpatient Medications version 4.0.
 ;;^UTILITY(U,$J,"OPT",3829,25)
 ;;=ENE^PSJPRE49
 ;;^UTILITY(U,$J,"OPT",3829,"U")
 ;;=EDIT PROVIDER FIELDS IN NEW PE
 ;;^UTILITY(U,$J,"OPT",3830,0)
 ;;=PSJV PROVIDER PRINT^Active Provider Report^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3830,1,0)
 ;;=^^11^11^2920319^^
 ;;^UTILITY(U,$J,"OPT",3830,1,1,0)
 ;;=  This lists all active providers in the PROVIDER File (6). The report
 ;;^UTILITY(U,$J,"OPT",3830,1,2,0)
 ;;=includes the following fields:
 ;;^UTILITY(U,$J,"OPT",3830,1,3,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",3830,1,4,0)
 ;;=     NAME (From the NEW PERSON File)
 ;;^UTILITY(U,$J,"OPT",3830,1,5,0)
 ;;=     INACTIVATION DATE (From the PROVIDER File)
 ;;^UTILITY(U,$J,"OPT",3830,1,6,0)
 ;;=     INACTIVE DATE (For Pharmacy, from the NEW PERSON File)
 ;;^UTILITY(U,$J,"OPT",3830,1,7,0)
 ;;=     AUTHORIZED TO WRITE MED ORDERS (From the NEW PERSON File)
 ;;^UTILITY(U,$J,"OPT",3830,1,8,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",3830,1,9,0)
 ;;=  Only providers who are marked as AUTHORIZED TO WRITE MED ORDERS in the
 ;;^UTILITY(U,$J,"OPT",3830,1,10,0)
 ;;=NEW PERSON File (200) are selectable through Inpatient Medications
 ;;^UTILITY(U,$J,"OPT",3830,1,11,0)
 ;;=version 4.0
 ;;^UTILITY(U,$J,"OPT",3830,25)
 ;;=ENP^PSJPRE49
 ;;^UTILITY(U,$J,"OPT",3830,"U")
 ;;=ACTIVE PROVIDER REPORT
 ;;^UTILITY(U,$J,"OPT",3831,0)
 ;;=PSJV SYNONYM MOVE^Synonym Move From Drug File To Primary Drug File^^R^^^^^^^^PSJV
 ;;^UTILITY(U,$J,"OPT",3831,1,0)
 ;;=^^5^5^2920323^^
 ;;^UTILITY(U,$J,"OPT",3831,1,1,0)
 ;;=  This allows the user to copy the synonyms in the Drug file to the Primary
 ;;^UTILITY(U,$J,"OPT",3831,1,2,0)
 ;;=Drug file for those items in the Drug file that have a Primary drug.  Only
 ;;^UTILITY(U,$J,"OPT",3831,1,3,0)
 ;;=synonyms that have been marked as TRADE NAMES are copied.  This should not
 ;;^UTILITY(U,$J,"OPT",3831,1,4,0)
 ;;=be run until the Primary Drug Manual Create option has been run to
 ;;^UTILITY(U,$J,"OPT",3831,1,5,0)
 ;;=completion.
 ;;^UTILITY(U,$J,"OPT",3831,25)
 ;;=ENSYN^PSJPRE41
 ;;^UTILITY(U,$J,"OPT",3831,"U")
 ;;=SYNONYM MOVE FROM DRUG FILE TO
