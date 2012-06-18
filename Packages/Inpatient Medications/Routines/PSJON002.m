PSJON002 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",77,1,6,0)
 ;;=this protocol will show patients with orders not verified by a nurse, but
 ;;^UTILITY(U,$J,"PRO",77,1,7,0)
 ;;=not allow any action to be taken.
 ;;^UTILITY(U,$J,"PRO",77,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",77,20)
 ;;=D ^PSGVBW
 ;;^UTILITY(U,$J,"PRO",77,99)
 ;;=56004,58414
 ;;^UTILITY(U,$J,"PRO",78,0)
 ;;=PSJ OR MENU^Inpatient Medications Ward Reports^^Q^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",78,1,0)
 ;;=^^2^2^2920121^^^^
 ;;^UTILITY(U,$J,"PRO",78,1,1,0)
 ;;=  This contains Inpatient (Unit Dose and IV) Medications reports that may be
 ;;^UTILITY(U,$J,"PRO",78,1,2,0)
 ;;=run by ward personnel through the OE/RR package.
 ;;^UTILITY(U,$J,"PRO",78,4)
 ;;=40
 ;;^UTILITY(U,$J,"PRO",78,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",78,10,0)
 ;;=^101.01PA^9^9
 ;;^UTILITY(U,$J,"PRO",78,10,1,0)
 ;;=77^
 ;;^UTILITY(U,$J,"PRO",78,10,1,"^")
 ;;=PSJU OR VBW
 ;;^UTILITY(U,$J,"PRO",78,10,2,0)
 ;;=82^
 ;;^UTILITY(U,$J,"PRO",78,10,2,"^")
 ;;=PSJU OR 14D MAR
 ;;^UTILITY(U,$J,"PRO",78,10,3,0)
 ;;=81^
 ;;^UTILITY(U,$J,"PRO",78,10,3,"^")
 ;;=PSJU OR 7D MAR
 ;;^UTILITY(U,$J,"PRO",78,10,4,0)
 ;;=79^
 ;;^UTILITY(U,$J,"PRO",78,10,4,"^")
 ;;=PSJU OR AP-1
 ;;^UTILITY(U,$J,"PRO",78,10,5,0)
 ;;=80^
 ;;^UTILITY(U,$J,"PRO",78,10,5,"^")
 ;;=PSJU OR AP-2
 ;;^UTILITY(U,$J,"PRO",78,10,6,0)
 ;;=88^
 ;;^UTILITY(U,$J,"PRO",78,10,6,"^")
 ;;=PSJU OR DS
 ;;^UTILITY(U,$J,"PRO",78,10,7,0)
 ;;=89^
 ;;^UTILITY(U,$J,"PRO",78,10,7,"^")
 ;;=PSJU OR PR
 ;;^UTILITY(U,$J,"PRO",78,10,8,0)
 ;;=93^
 ;;^UTILITY(U,$J,"PRO",78,10,8,"^")
 ;;=PSJ OR PR
 ;;^UTILITY(U,$J,"PRO",78,10,9,0)
 ;;=94^
 ;;^UTILITY(U,$J,"PRO",78,10,9,"^")
 ;;=PSJI OR PR
 ;;^UTILITY(U,$J,"PRO",78,99)
 ;;=56097,51057
 ;;^UTILITY(U,$J,"PRO",79,0)
 ;;=PSJU OR AP-1^Action Profile #1^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",79,1,0)
 ;;=^^4^4^2940803^^^^
 ;;^UTILITY(U,$J,"PRO",79,1,1,0)
 ;;=  This allows the user to print a profile of patients' active Unit Dose
 ;;^UTILITY(U,$J,"PRO",79,1,2,0)
 ;;=orders for review by the physician.  It includes places for the physician
 ;;^UTILITY(U,$J,"PRO",79,1,3,0)
 ;;=to mark each order and sign the profile.  When possible, space is also
 ;;^UTILITY(U,$J,"PRO",79,1,4,0)
 ;;=included for new orders.
 ;;^UTILITY(U,$J,"PRO",79,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",79,20)
 ;;=D ^PSGAP
 ;;^UTILITY(U,$J,"PRO",79,99)
 ;;=56097,50997
 ;;^UTILITY(U,$J,"PRO",80,0)
 ;;=PSJU OR AP-2^Action Profile #2^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",80,1,0)
 ;;=^^4^4^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",80,1,1,0)
 ;;=  This allows the user to print a profile of patients' active Unit Dose
 ;;^UTILITY(U,$J,"PRO",80,1,2,0)
 ;;=orders for review by the physician.  It includes places for the physician
 ;;^UTILITY(U,$J,"PRO",80,1,3,0)
 ;;=to mark each order and sign the profile.  When possible, space is also
 ;;^UTILITY(U,$J,"PRO",80,1,4,0)
 ;;=included for new orders.
 ;;^UTILITY(U,$J,"PRO",80,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",80,20)
 ;;=D ^PSGCAP
 ;;^UTILITY(U,$J,"PRO",80,99)
 ;;=56097,51057
 ;;^UTILITY(U,$J,"PRO",81,0)
 ;;=PSJU OR 7D MAR^7 Day MAR (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",81,1,0)
 ;;=^^4^4^2940308^^^^
 ;;^UTILITY(U,$J,"PRO",81,1,1,0)
 ;;=  This allows the user to print selected patients' Unit Dose orders on a
 ;;^UTILITY(U,$J,"PRO",81,1,2,0)
 ;;=Medication Administration Record (MAR) for the charting of the
 ;;^UTILITY(U,$J,"PRO",81,1,3,0)
 ;;=administration of the orders over a seven day period.  It is designed to
 ;;^UTILITY(U,$J,"PRO",81,1,4,0)
 ;;=replace the manual Continuing Medication Record (CMR).
 ;;^UTILITY(U,$J,"PRO",81,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",81,20)
 ;;=D EN7^PSGMMAR
 ;;^UTILITY(U,$J,"PRO",81,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",82,0)
 ;;=PSJU OR 14D MAR^14 Day MAR (Unit Dose)^^A^^^^^^^^UNIT DOSE MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",82,1,0)
 ;;=^^4^4^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",82,1,1,0)
 ;;=  This allows the user to print selected patients' Unit Dose orders on a
 ;;^UTILITY(U,$J,"PRO",82,1,2,0)
 ;;=Medication Administration Record (MAR) for the charting of the
 ;;^UTILITY(U,$J,"PRO",82,1,3,0)
 ;;=administration of the orders over a fourteen day period.  It is designed to
 ;;^UTILITY(U,$J,"PRO",82,1,4,0)
 ;;=replace the manual Continuing Medication Record (CMR).
 ;;^UTILITY(U,$J,"PRO",82,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",82,20)
 ;;=D EN14^PSGMMAR
 ;;^UTILITY(U,$J,"PRO",82,99)
 ;;=56004,58415
