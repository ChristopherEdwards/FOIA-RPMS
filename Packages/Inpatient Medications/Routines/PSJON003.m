PSJON003 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",83,0)
 ;;=PSJU OR PAT AP-1^Action Profile #1 (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",83,1,0)
 ;;=^^5^5^2940720^^^^
 ;;^UTILITY(U,$J,"PRO",83,1,1,0)
 ;;=  This allows the user to print a profile of a patient's active Unit Dose
 ;;^UTILITY(U,$J,"PRO",83,1,2,0)
 ;;=orders for review by the physician.  It includes places for the physician
 ;;^UTILITY(U,$J,"PRO",83,1,3,0)
 ;;=to mark each order and sign the profile.  When possible, space is also
 ;;^UTILITY(U,$J,"PRO",83,1,4,0)
 ;;=included for new orders.  This protocol assumes that a patient has already
 ;;^UTILITY(U,$J,"PRO",83,1,5,0)
 ;;=been selected.
 ;;^UTILITY(U,$J,"PRO",83,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",83,20)
 ;;=D ENOR^PSGAP
 ;;^UTILITY(U,$J,"PRO",83,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",84,0)
 ;;=PSJU OR PAT AP-2^Action Profile #2 (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",84,1,0)
 ;;=^^5^5^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",84,1,1,0)
 ;;=  This allows the user to print a profile of a patient's active Unit Dose
 ;;^UTILITY(U,$J,"PRO",84,1,2,0)
 ;;=orders for review by the physician.  It includes places for the physician
 ;;^UTILITY(U,$J,"PRO",84,1,3,0)
 ;;=to mark each order and sign the profile.  When possible, space is also
 ;;^UTILITY(U,$J,"PRO",84,1,4,0)
 ;;=included for new orders.  This protocol assumes that a patient has already
 ;;^UTILITY(U,$J,"PRO",84,1,5,0)
 ;;=been selected.
 ;;^UTILITY(U,$J,"PRO",84,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",84,20)
 ;;=D ENOR^PSGCAP0
 ;;^UTILITY(U,$J,"PRO",84,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",85,0)
 ;;=PSJU OR PAT VBW^Non-Verified Orders (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",85,1,0)
 ;;=^^7^7^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",85,1,1,0)
 ;;=  This allows the user to verify (or take other actions) on non-verified
 ;;^UTILITY(U,$J,"PRO",85,1,2,0)
 ;;=Unit Dose orders for a patient.  If the user is a pharmacist, this protocol
 ;;^UTILITY(U,$J,"PRO",85,1,3,0)
 ;;=will show all orders not verified by a pharmacist for a selected patient.
 ;;^UTILITY(U,$J,"PRO",85,1,4,0)
 ;;=If the user is a nurse, this protocol will show all orders not verified by
 ;;^UTILITY(U,$J,"PRO",85,1,5,0)
 ;;=a nurse.  If the user is ward staff, this protocol will show the patient's
 ;;^UTILITY(U,$J,"PRO",85,1,6,0)
 ;;=orders not verified by a nurse, but not allow any action to be taken.
 ;;^UTILITY(U,$J,"PRO",85,1,7,0)
 ;;=  This protocol assumes that a patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",85,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",85,20)
 ;;=D ENOR^PSGVBW
 ;;^UTILITY(U,$J,"PRO",85,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",86,0)
 ;;=PSJU OR PAT DS^Discharge Summary (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",86,1,0)
 ;;=^^5^5^2940720^^^^
 ;;^UTILITY(U,$J,"PRO",86,1,1,0)
 ;;=  This gives the physician and/or Outpatient Pharmacy a report of the active
 ;;^UTILITY(U,$J,"PRO",86,1,2,0)
 ;;=Unit Dose medications for a patient about to be discharged or transferred to
 ;;^UTILITY(U,$J,"PRO",86,1,3,0)
 ;;=Authorized Absence, and allows the physician to mark the appropriate
 ;;^UTILITY(U,$J,"PRO",86,1,4,0)
 ;;=action deemed necessary for each medication.  This protocol assumes that a
 ;;^UTILITY(U,$J,"PRO",86,1,5,0)
 ;;=patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",86,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",86,20)
 ;;=D ENOR^PSGDS
 ;;^UTILITY(U,$J,"PRO",86,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",87,0)
 ;;=PSJ OR PAT PR^Inpatient Medications Profile^^A^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",87,1,0)
 ;;=^^2^2^2920121^^^^
 ;;^UTILITY(U,$J,"PRO",87,1,1,0)
 ;;=  This allows the user to print Inpatient Medications orders for a selected
 ;;^UTILITY(U,$J,"PRO",87,1,2,0)
 ;;=patient.  This protocol assumes that the patient has already been selected.
 ;;^UTILITY(U,$J,"PRO",87,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",87,20)
 ;;=D ENOR^PSJPR
 ;;^UTILITY(U,$J,"PRO",87,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",88,0)
 ;;=PSJU OR DS^Authorized Absence/Discharge Summary (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",88,1,0)
 ;;=^^4^4^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",88,1,1,0)
 ;;=  This gives the physician and/or Outpatient Pharmacy a report of the active
 ;;^UTILITY(U,$J,"PRO",88,1,2,0)
 ;;=Unit Dose medications for patients about to be discharged or transferred to
