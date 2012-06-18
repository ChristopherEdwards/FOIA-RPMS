ABSPECP2 ; IHS/FCS/DRS - NO DESCRIPTION PROVIDED ;  [ 10/09/2002  8:02 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;
 ;---------------------------------
 ;IHS/SD/lwj 10/09/02 NCPDP 5.1 changes
 ; Needed to adjust the translation of the transaction code
 ; to account for 5.1 values.
 ;
 ;---------------------------------
 ;
 Q
 ; Lots of $$functions called from other ABSPECP*
 ; ABSPOS6G calls $$DUR
 ;
DUR(X) ;EP - DUR code
 I X="DA" Q "Drug-Allergy Alert"
 I X="DC" Q "Drug-Disease Conflicts"
 I X="DD" Q "Drug-Drug Interactions"
 I X="ER" Q "Excessive Utilization"
 I X="HD" Q "Excessive Drug Doses (Over Utilization)"
 I X="ID" Q "Therapeutic Duplication (Same Ingredients)"
 I X="LD" Q "Insufficient Drug Doses (Under Utilization)"
 I X="LR" Q "Underuse Precaution (Non-compliance)"
 I X="MC" Q "Drug Disease Alert (Drug/diagnosis matching)"
 I X="MX" Q "Excessive Duration Alert"
 I X="PA" Q "Drug-Age Conflicts"
 I X="PG" Q "Drug-Pregnancy Conflicts"
 I X="SX" Q "Drug-Gender Alert"
 I X="TD" Q "Therapeutic Duplications (Same Drug Class)"
DUR8 I X[" " S X=$P(X," ")_"<sp>"_$P(X," ",2,$L(X)) G DUR8
 Q "DUR code "_X_" ? "
OTHPHARM(X) ;EP - Other Pharmacy Indicator (within DUR data)
 I X=1 Q "Same Pharmacy"
 I X=2 Q "Different Pharmacy Same Chain"
 I X=3 Q "Different Pharmacy Different Chain"
 Q X
OTHPRESC(X) ;EP - Other Prescriber (within DUR data)
 I X=1 Q "Same Physician"
 I X=2 Q "Different Physician"
 Q X
TCODE(X) ;EP - Transaction code
 ;-----------------------------------------
 ;IHS/SD/lwj 10/08/02 NCPDP 5.1 changes
 ; For 5.1 the transaction code will be either B1 or B2
 ;-----------------------------------------
 I X'<1,X'>4 Q X_" prescription claim"_$S(X>1:"s",1:"")
 I (X=11)!(X="B2") Q "Claim Reversal"  ;IHS/SD/lwj 10/09/02
 I X="B1" Q X_" prescription claim"   ;IHS/SD/lwj 10/09/02
 Q "Unknown transaction code "_X
REIMB(X) ;EP - Basis of reimbursement
 I +X=0 Q "Not specified"
 I +X=1 Q "Ingredient cost paid as submitted"
 I +X=2 Q "Ingredient cost reduced to AWP pricing"
 I +X=3 Q "Ingredient cost reduced to AWP less %"
 I +X=4 Q "Usual and Customary paid as submitted"
 I +X=5 Q "Paid lower of ingredient cost plus fees versus usual and customary"
 I +X=6 Q "MAC Pricing - Ingredient cost paid at MAC price"
 I +X=7 Q "MAC Pricing - Ingredient cost reduced to MAC pricing"
 I +X=8 Q "Contract Pricing"
 Q X
DAW(X) ;EP -
 I X=0 Q "No product selection indicated."
 I X=1 Q "Substitution not allowed by prescriber."
 I X=2 Q "Substitution allowed - patient requested product dispensed."
 I X=3 Q "Substitution allowed - pharmacist selected product dispensed."
 I X=4 Q "Substitution allowed - generic not in stock."
 I X=5 Q "Substitution allowed - brand dispensed as generic."
 I X=6 Q "Override"
 I X=7 Q "Substitution not allowed - brand drug mandated by law."
 I X=8 Q "Substitution allowed - generic drug not available in marketplace."
 I X=9 Q "Unspecified"
 Q X
