ABMMUDEF ;IHS/SD/SDR - MU Patient Volume DEF Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7**;NOV 12, 2009
 ;
 S ABMQ("RC")="COMPUTE^ABMMUDEF"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMMUDEF"
 D ^ABMDRDBQ
 Q
COMPUTE ;
 Q
PRINT ;
 W !!,"Definitions used in this Report:"
 W !!,$$EN^ABMVDF("HIN"),"CONTINUOUS 90-DAY PERIOD:",$$EN^ABMVDF("HIF")," Any rolling 90-day period within the reporting year."
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"MINIMUM PATIENT VOLUME:",$$EN^ABMVDF("HIF")," Medicaid or Needy Volume greater than or equal to 30%"
 W !?3," for EPs and 20% Pediatricians"
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"Participation year:",$$EN^ABMVDF("HIF")," The calendar year (Jan. 01 - Dec. 31) in which the EP is"
 W !?3,"participating in the Medicaid EHR Incentive program."
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"Qualification year:",$$EN^ABMVDF("HIF")," The calendar year (Jan. 01 - Dec. 31) immediately prior to"
 W !?3,"the Participation year.  Patient Volume is calculated on encounters that"
 W !?3,"occurred during the Qualification Year."
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"MEDICAID PATIENT VOLUME ENCOUNTERS:",$$EN^ABMVDF("HIF")
 W " Medicaid encounters include all patient"
 W !?3,"visits paid for by Medicaid or an 1115 waiver program. For states where a"
 W !?3,"single payment is made to a facility without regard to the number of"
 W !?3,"encounters a patient has during a single day, each EP who has an encounter"
 W !?3,"with the patient that day will have the encounter included in their Patient"
 W !?3,"Volume calculation."
 W !
 ;
 I (IOST["C") D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 W !,$$EN^ABMVDF("HIN"),"MEDICAID INDIVIDUALS:",$$EN^ABMVDF("HIF")
 W " Medicaid individuals are patients where Medicaid or a"
 W !?3,"Medicaid demonstration project paid for part or all of any of the following:"
 W !?3,"Service, Premiums, Co-payments and/or cost sharing."
 W !?3,"They may be:"
 W !?5,"1. Individuals enrolled in Medicaid, or"
 W !?5,"2. Individuals enrolled in a Medicaid managed care plan, which includes"
 W !?5,"patients enrolled in Managed Care Organizations (MCO's), Prepaid Inpatient"
 W !?5,"Health Plans (PIHPs), or Prepaid Ambulatory Health Plans (PAHPs)."
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"NEEDY INDIVIDUAL PATIENT VOLUME ENCOUNTERS:",$$EN^ABMVDF("HIF")
 W " The Needy Individual Patient Volume"
 W !?3,"will be used for EPs who work predominately at an FQHC or RHC.  An EP is"
 W !?3,"considered to work predominantly at an FQHC or RHC when the FQHC/RHC is the"
 W !?3,"clinical location for over 50% of all of the provider's total encounters for"
 W !?3,"six (6) months in the most recent calendar year.  FQHCs and RHCs use the"
 W !?3,"Needy Individual encounter definition (expanded from the basic Medicaid"
 W !?3,"encounter) for their encounters."
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"NEEDY INDIVIDUALS:",$$EN^ABMVDF("HIF")," Needy Individual encounters include all patient encounters"
 W !?3,"paid for by:"
 W !?5,"1. Medicaid-insurance type 'D' (includes 1115 Waivers)"
 W !?5,"2. CHIP-insurance type 'K' billed as either Medicaid or Private Insurance"
 W !?5,"3. Discounted (sliding scale) encounters"
 W !?5,"4. Uncompensated care"
 W !
 ;
 W !,$$EN^ABMVDF("HIN"),"Note on Discounted Sliding Scale Encounters:",$$EN^ABMVDF("HIF"),"  Discounted (sliding scale)"
 W !?3,"encounters are not included in this version of the report, as they are not"
 W !?3,"currently captured in RPMS."
 W !,$$EN^ABMVDF("HIN"),"Note on Uncompensated Care:",$$EN^ABMVDF("HIF"),"  Uncompensated care includes all unpaid encounters."
 W !?3,"Unpaid Encounters = Encounters which were billed, but for which no payment"
 W !?3,"was received for the report period. Unpaid Encounters are not affected by"
 W !?3,"beneficiary status."
 Q
