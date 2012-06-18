PSJON004 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",88,1,3,0)
 ;;=Authorized Absence, and allows the physician to mark the appropriate
 ;;^UTILITY(U,$J,"PRO",88,1,4,0)
 ;;=action deemed necessary for each medication.
 ;;^UTILITY(U,$J,"PRO",88,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",88,20)
 ;;=D ^PSGDS
 ;;^UTILITY(U,$J,"PRO",88,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",89,0)
 ;;=PSJU OR PR^Patient Profile (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",89,1,0)
 ;;=^^7^7^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",89,1,1,0)
 ;;=  This allows a user to print to any device a profile (list) of patients'
 ;;^UTILITY(U,$J,"PRO",89,1,2,0)
 ;;=Unit Dose orders for the patient's current or last (if patient has been
 ;;^UTILITY(U,$J,"PRO",89,1,3,0)
 ;;=discharged) admission.  If the user's terminal is selected as the printing
 ;;^UTILITY(U,$J,"PRO",89,1,4,0)
 ;;=device, this protocol will allow the user to select any of the printed
 ;;^UTILITY(U,$J,"PRO",89,1,5,0)
 ;;=orders to be shown in complete detail, including the activity logs, if any.
 ;;^UTILITY(U,$J,"PRO",89,1,6,0)
 ;;=The user may print patients' profiles for a single patient, or for an entire
 ;;^UTILITY(U,$J,"PRO",89,1,7,0)
 ;;=ward group or an entire ward.
 ;;^UTILITY(U,$J,"PRO",89,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",89,20)
 ;;=D ^PSGPR
 ;;^UTILITY(U,$J,"PRO",89,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",90,0)
 ;;=PSJU OR PAT 14D MAR^14 Day MAR (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",90,1,0)
 ;;=^^5^5^2940323^^^^
 ;;^UTILITY(U,$J,"PRO",90,1,1,0)
 ;;=  This allows the user to print a selected patient's Unit Dose orders on a
 ;;^UTILITY(U,$J,"PRO",90,1,2,0)
 ;;=Medication Administration Record (MAR) for the charting of the
 ;;^UTILITY(U,$J,"PRO",90,1,3,0)
 ;;=administration of the orders over a fourteen day period.  It is designed to
 ;;^UTILITY(U,$J,"PRO",90,1,4,0)
 ;;=replace the manual Continuing Medication Record (CMR).  This protocol
 ;;^UTILITY(U,$J,"PRO",90,1,5,0)
 ;;=assumes that a patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",90,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",90,20)
 ;;=S PSGMARDF=14 D ENOR^PSGMMAR
 ;;^UTILITY(U,$J,"PRO",90,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",91,0)
 ;;=PSJU OR PAT 7D MAR^7 Day MAR (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",91,1,0)
 ;;=^^5^5^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",91,1,1,0)
 ;;=  This allows the user to print a selected patient's Unit Dose orders on a
 ;;^UTILITY(U,$J,"PRO",91,1,2,0)
 ;;=Medication Administration Record (MAR) for the charting of the
 ;;^UTILITY(U,$J,"PRO",91,1,3,0)
 ;;=administration of the orders over a seven day period.  It is designed to
 ;;^UTILITY(U,$J,"PRO",91,1,4,0)
 ;;=replace the manual Continuing Medication Record (CMR).  This protocol
 ;;^UTILITY(U,$J,"PRO",91,1,5,0)
 ;;=assumes that a patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",91,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",91,20)
 ;;=S PSGMARDF=7 D ENOR^PSGMMAR
 ;;^UTILITY(U,$J,"PRO",91,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",92,0)
 ;;=PSJ OR PAT PR MENU^Inpatient Medications Profiles^^M^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",92,1,0)
 ;;=^^3^3^2920625^^^^
 ;;^UTILITY(U,$J,"PRO",92,1,1,0)
 ;;=  These are Inpatient Medications profiles for use with the OE/RR package.
 ;;^UTILITY(U,$J,"PRO",92,1,2,0)
 ;;=These protocols all assume that the patient has already been selected 
 ;;^UTILITY(U,$J,"PRO",92,1,3,0)
 ;;=through the OE/RR package.
 ;;^UTILITY(U,$J,"PRO",92,4)
 ;;=40
 ;;^UTILITY(U,$J,"PRO",92,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",92,10,0)
 ;;=^101.01PA^4^4
 ;;^UTILITY(U,$J,"PRO",92,10,1,0)
 ;;=87^^97
 ;;^UTILITY(U,$J,"PRO",92,10,1,"^")
 ;;=PSJ OR PAT PR
 ;;^UTILITY(U,$J,"PRO",92,10,2,0)
 ;;=74^^96
 ;;^UTILITY(U,$J,"PRO",92,10,2,"^")
 ;;=PSJU OR PAT PR
 ;;^UTILITY(U,$J,"PRO",92,10,3,0)
 ;;=76^^95
 ;;^UTILITY(U,$J,"PRO",92,10,3,"^")
 ;;=PSJI OR PAT PR
 ;;^UTILITY(U,$J,"PRO",92,10,4,0)
 ;;=82^
 ;;^UTILITY(U,$J,"PRO",92,10,4,"^")
 ;;=PSJU OR 14D MAR
 ;;^UTILITY(U,$J,"PRO",92,26)
 ;;=
 ;;^UTILITY(U,$J,"PRO",92,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",93,0)
 ;;=PSJ OR PR^Inpatient Medications Profile^^A^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",93,1,0)
 ;;=^^2^2^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",93,1,1,0)
 ;;=  This allows the user to print Inpatient Medications orders for selected
 ;;^UTILITY(U,$J,"PRO",93,1,2,0)
 ;;=patients.  Profiles can be printed by patient, ward, or ward group.
