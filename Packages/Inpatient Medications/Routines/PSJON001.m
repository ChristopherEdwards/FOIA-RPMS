PSJON001 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",73,0)
 ;;=PSJ OR PAT OE^Inpatient Medications^^O^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",73,1,0)
 ;;=^^3^3^2920625^^^^
 ;;^UTILITY(U,$J,"PRO",73,1,1,0)
 ;;=  This protocol allows the entry of Unit Dose and non-fluid IV orders
 ;;^UTILITY(U,$J,"PRO",73,1,2,0)
 ;;=through the Order Entry/Results Reporting package.  This protocol assumes
 ;;^UTILITY(U,$J,"PRO",73,1,3,0)
 ;;=that the patient has been selected prior to this protocol being selected.
 ;;^UTILITY(U,$J,"PRO",73,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",73,20)
 ;;=D ^PSJORA
 ;;^UTILITY(U,$J,"PRO",73,99)
 ;;=56004,58413
 ;;^UTILITY(U,$J,"PRO",74,0)
 ;;=PSJU OR PAT PR^Unit Dose Medications Profile^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",74,1,0)
 ;;=^^6^6^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",74,1,1,0)
 ;;=  This allows a user to print to any device a profile (list) of a patient's
 ;;^UTILITY(U,$J,"PRO",74,1,2,0)
 ;;=Unit Dose orders for the patient's current or last (if patient has been
 ;;^UTILITY(U,$J,"PRO",74,1,3,0)
 ;;=discharged) admission.  If the user's terminal is selected as the printing
 ;;^UTILITY(U,$J,"PRO",74,1,4,0)
 ;;=device, this option will allow the user to select any of the printed orders
 ;;^UTILITY(U,$J,"PRO",74,1,5,0)
 ;;=to be shown in complete detail, including the activity logs, if any.
 ;;^UTILITY(U,$J,"PRO",74,1,6,0)
 ;;=  This protocol assumes that a patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",74,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",74,20)
 ;;=D ENOR^PSGPR
 ;;^UTILITY(U,$J,"PRO",74,99)
 ;;=56004,58413
 ;;^UTILITY(U,$J,"PRO",75,0)
 ;;=PSJ OR PAT MENU^Inpatient Medications Patient Reports^^Q^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",75,1,0)
 ;;=^^3^3^2931001^^^^
 ;;^UTILITY(U,$J,"PRO",75,1,1,0)
 ;;=  This contains Inpatient (Unit Dose and IV) Medications reports for use
 ;;^UTILITY(U,$J,"PRO",75,1,2,0)
 ;;=with the OE/RR package.  These reports assume that the patient has been
 ;;^UTILITY(U,$J,"PRO",75,1,3,0)
 ;;=selected prior to the protocol being selected.
 ;;^UTILITY(U,$J,"PRO",75,4)
 ;;=40
 ;;^UTILITY(U,$J,"PRO",75,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",75,10,0)
 ;;=^101.01PA^9^9
 ;;^UTILITY(U,$J,"PRO",75,10,1,0)
 ;;=74^
 ;;^UTILITY(U,$J,"PRO",75,10,1,"^")
 ;;=PSJU OR PAT PR
 ;;^UTILITY(U,$J,"PRO",75,10,2,0)
 ;;=87^
 ;;^UTILITY(U,$J,"PRO",75,10,2,"^")
 ;;=PSJ OR PAT PR
 ;;^UTILITY(U,$J,"PRO",75,10,3,0)
 ;;=83^
 ;;^UTILITY(U,$J,"PRO",75,10,3,"^")
 ;;=PSJU OR PAT AP-1
 ;;^UTILITY(U,$J,"PRO",75,10,4,0)
 ;;=84^
 ;;^UTILITY(U,$J,"PRO",75,10,4,"^")
 ;;=PSJU OR PAT AP-2
 ;;^UTILITY(U,$J,"PRO",75,10,5,0)
 ;;=90^
 ;;^UTILITY(U,$J,"PRO",75,10,5,"^")
 ;;=PSJU OR PAT 14D MAR
 ;;^UTILITY(U,$J,"PRO",75,10,6,0)
 ;;=91^
 ;;^UTILITY(U,$J,"PRO",75,10,6,"^")
 ;;=PSJU OR PAT 7D MAR
 ;;^UTILITY(U,$J,"PRO",75,10,7,0)
 ;;=86^
 ;;^UTILITY(U,$J,"PRO",75,10,7,"^")
 ;;=PSJU OR PAT DS
 ;;^UTILITY(U,$J,"PRO",75,10,8,0)
 ;;=85^
 ;;^UTILITY(U,$J,"PRO",75,10,8,"^")
 ;;=PSJU OR PAT VBW
 ;;^UTILITY(U,$J,"PRO",75,10,9,0)
 ;;=76^
 ;;^UTILITY(U,$J,"PRO",75,10,9,"^")
 ;;=PSJI OR PAT PR
 ;;^UTILITY(U,$J,"PRO",75,99)
 ;;=56014,31762
 ;;^UTILITY(U,$J,"PRO",76,0)
 ;;=PSJI OR PAT PR^IV Medications Profile^^A^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",76,1,0)
 ;;=^^4^4^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",76,1,1,0)
 ;;=  This will allow a patient's IV profile to be sent to a printer.
 ;;^UTILITY(U,$J,"PRO",76,1,2,0)
 ;;=With each profile printed, a view of each order within the profile can
 ;;^UTILITY(U,$J,"PRO",76,1,3,0)
 ;;=also be printed.  This protocol assumes that a patient has been selected
 ;;^UTILITY(U,$J,"PRO",76,1,4,0)
 ;;=prior to this protocol being selected.
 ;;^UTILITY(U,$J,"PRO",76,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",76,20)
 ;;=D ENOR^PSIVPR
 ;;^UTILITY(U,$J,"PRO",76,99)
 ;;=56004,58414
 ;;^UTILITY(U,$J,"PRO",77,0)
 ;;=PSJU OR VBW^Non-Verified Orders (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",77,1,0)
 ;;=^^7^7^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",77,1,1,0)
 ;;=  This allows the user to verify (or take other actions) on non-verified
 ;;^UTILITY(U,$J,"PRO",77,1,2,0)
 ;;=Unit Dose orders for patients.  If the user is a pharmacist, this protocol
 ;;^UTILITY(U,$J,"PRO",77,1,3,0)
 ;;=will show all orders not verified by a pharmacist for a ward group, ward, or
 ;;^UTILITY(U,$J,"PRO",77,1,4,0)
 ;;=single patient, as the user chooses.  If the user is a nurse, this protocol
 ;;^UTILITY(U,$J,"PRO",77,1,5,0)
 ;;=will show all orders not verified by a nurse.  If the user is ward staff,
