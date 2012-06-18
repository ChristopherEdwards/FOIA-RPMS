PSJON005 ; ; 06-OCT-1994
 ;;4.5; Inpatient Medications ;;7 Oct 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",93,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",93,20)
 ;;=D ^PSJPR
 ;;^UTILITY(U,$J,"PRO",93,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",94,0)
 ;;=PSJI OR PR^IV Medications Profile^^A^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",94,1,0)
 ;;=^^3^3^2920122^^^^
 ;;^UTILITY(U,$J,"PRO",94,1,1,0)
 ;;=  This will allow a patient's IV profile to be sent to a printer.
 ;;^UTILITY(U,$J,"PRO",94,1,2,0)
 ;;=With each profile printed, a view of each order within the profile can
 ;;^UTILITY(U,$J,"PRO",94,1,3,0)
 ;;=also be printed. 
 ;;^UTILITY(U,$J,"PRO",94,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",94,20)
 ;;=D ^PSIVXU Q:$D(XQUIT)  D ^PSIVPR,ENIVKV^PSGSETU K J,N2,ORIFN,P17
 ;;^UTILITY(U,$J,"PRO",94,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",95,0)
 ;;=PSJ OR PAT ADT^Inpatient Medications Actions on Patient ADT^^A^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",95,1,0)
 ;;=^^4^4^2940720^^^^
 ;;^UTILITY(U,$J,"PRO",95,1,1,0)
 ;;=  This takes the appropriate action on a patient's Inpatient
 ;;^UTILITY(U,$J,"PRO",95,1,2,0)
 ;;=Medication orders whenever the patient is Admitted, Discharged, or
 ;;^UTILITY(U,$J,"PRO",95,1,3,0)
 ;;=Transferred (ADT).  This is an action protocol to be used within the DG
 ;;^UTILITY(U,$J,"PRO",95,1,4,0)
 ;;=MOVEMENT EVENTS protocol.
 ;;^UTILITY(U,$J,"PRO",95,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",95,20)
 ;;=D ^PSJADT
 ;;^UTILITY(U,$J,"PRO",95,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",96,0)
 ;;=PSJI OR PAT FLUID OE^IV Fluids^^O^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",96,1,0)
 ;;=^^3^3^2931001^^^^
 ;;^UTILITY(U,$J,"PRO",96,1,1,0)
 ;;=  This allows entry of IV fluids orders through OE/RR.  This protocol
 ;;^UTILITY(U,$J,"PRO",96,1,2,0)
 ;;=assumes that a patient has been selected prior to this protocol being
 ;;^UTILITY(U,$J,"PRO",96,1,3,0)
 ;;=selected.
 ;;^UTILITY(U,$J,"PRO",96,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",96,20)
 ;;=D ^PSIVORA
 ;;^UTILITY(U,$J,"PRO",96,99)
 ;;=56004,58415
 ;;^UTILITY(U,$J,"PRO",106,0)
 ;;=PSJI OR PAT HYPERAL OE^IV Hyperal^^A^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",106,1,0)
 ;;=^^1^1^2920124^^^^
 ;;^UTILITY(U,$J,"PRO",106,1,1,0)
 ;;=  This allows limited processing of IV Hyperal orders through OE/RR.
 ;;^UTILITY(U,$J,"PRO",106,5)
 ;;=
 ;;^UTILITY(U,$J,"PRO",106,20)
 ;;=D ^PSIVORH
 ;;^UTILITY(U,$J,"PRO",106,99)
 ;;=56004,58416
 ;;^UTILITY(U,$J,"PRO",235,0)
 ;;=PSJI OR PAT FLUID OE MENU^IV FLUIDS...^^Q^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",235,1,0)
 ;;=^^1^1^2931014^^^^
 ;;^UTILITY(U,$J,"PRO",235,1,1,0)
 ;;=Placeholder, possible replacement: PSJI OR PAT FLUID OE
 ;;^UTILITY(U,$J,"PRO",235,10,0)
 ;;=^101.01PA^1^3
 ;;^UTILITY(U,$J,"PRO",235,10,3,0)
 ;;=96^
 ;;^UTILITY(U,$J,"PRO",235,10,3,"^")
 ;;=PSJI OR PAT FLUID OE
 ;;^UTILITY(U,$J,"PRO",235,20)
 ;;=
 ;;^UTILITY(U,$J,"PRO",235,99)
 ;;=56004,58434
 ;;^UTILITY(U,$J,"PRO",370,0)
 ;;=PSJ OR PAT OE MENU^Inpatient Medications^^Q^^^^^^^^INPATIENT MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",370,1,0)
 ;;=^^3^3^2931001^^^^
 ;;^UTILITY(U,$J,"PRO",370,1,1,0)
 ;;=  This is a menu that allows the entry of Unit Dose and non-fluid IV orders
 ;;^UTILITY(U,$J,"PRO",370,1,2,0)
 ;;=through OE/RR.  This menu should contain the Inpatients Medications order
 ;;^UTILITY(U,$J,"PRO",370,1,3,0)
 ;;=entry protocol and any Inpatient Medications quick order protocols.
 ;;^UTILITY(U,$J,"PRO",370,10,0)
 ;;=^101.01PA^2^2
 ;;^UTILITY(U,$J,"PRO",370,10,1,0)
 ;;=73^^2
 ;;^UTILITY(U,$J,"PRO",370,10,1,"^")
 ;;=PSJ OR PAT OE
 ;;^UTILITY(U,$J,"PRO",370,10,2,0)
 ;;=652^^^^^INFUSE TEST
 ;;^UTILITY(U,$J,"PRO",370,10,2,"^")
 ;;=PSJQ4 AMY
 ;;^UTILITY(U,$J,"PRO",370,99)
 ;;=56151,53640
 ;;^UTILITY(U,$J,"PRO",652,0)
 ;;=PSJQ4 AMY^AMY^^O^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",652,20)
 ;;=D PROCESS^PSJQSET(4)
 ;;^UTILITY(U,$J,"PRO",652,99)
 ;;=56151,53546
 ;;^UTILITY(U,$J,"PRO",653,0)
 ;;=PSJQ5 MAI^MAI^^O^^^^^^^^IV MEDICATIONS
 ;;^UTILITY(U,$J,"PRO",653,20)
 ;;=D PROCESS^PSJQSET(5)
 ;;^UTILITY(U,$J,"PRO",653,99)
 ;;=56155,31327
