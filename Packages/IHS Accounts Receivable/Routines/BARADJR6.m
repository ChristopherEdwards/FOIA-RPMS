BARADJR6 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE**20**;;OCT 26, 2005
 ; IHS/SD/SDR - v1.8 p20 - updated SARs
 ;
 ; *********************************************************************
STND2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@2+BARCNT),BARD,2,6)
 Q:BARVALUE="END"
 D STND3^BARADJR3
 Q
2 ;; A/R EDI STND Claim Adj Reasons file - Adds
 ;;223;;Adjust code for mandated fed/state/local law/reg not covered by another code;;4;;953;;Adjustment code for mandated federal, state, or local law/regulation that is not already covered by another code and is mandated before a new code can be created.
 ;;224;;Pt ID compromised by identity theft. ID verf req for processing this/future clms;;4;;954;;Patient identification compromised by identity theft. Identity verification required for processing this and future claims.
 ;;225;;Penalty for interest payment by payer;;15;;919;;Penalty or Interest Payment by Payer (Only used for plan to plan encounter reporting within the 837).
 ;;226;;Info req from billing/rend provider not provided or insuff/incomplete;;4;;956;;Info requested from Billing/Rendering Prvder was not provided or insufficient/incomplete. At least 1 Rmrk Cd must be provided (may be either NCPDP Rej Rsn Cd, or Remit Advice Rmrk Cd, not an ALERT.)
 ;;227;;Info req from pt/insured/resp party not provided or insuff/incomplete;;4;;957;;Info requested from pt/insured/resp. party was not provided or insufficient/incomplete. At least one Rmrk Cd must be provided (may be either NCPDP Rej Rsn Cd, or Remit Advice Rmrk Cd, not an ALERT.)
 ;;228;;Denied - This/another prov/subscriber failed to supply req info to prev payer;;4;;958;;Denied for failure of this provider, another provider or the subscriber to supply requested information to a previous payer for their adjudication.
 ;;229;;Partial charge amt not considered by Medicare due to the initial claim TOB 12X;;4;;959;;Partial charge amount not considered by Medicare due to initial clm Type of Bill 12X. Note: See www.wpc-edi.com website for complete details.
 ;;230;;No available/correlating CPT/HCPCS to describe this service;;4;;960;;No available or correlating CPT/HCPCS code to describe this service. Note: Used only by Property and Casualty.
 ;;231;;Mutually exclusive procedures cannot be done in same day/setting;;4;;961;;Mutually exclusive procedures cannot be done in the same day/setting. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;232;;Institutional transfer amount;;4;;962;;"Institutional Transfer Amount. Note - Applies to institutional claims only and explains the DRG amount difference when the patient care crosses multiple institutions."
 ;;233;;Services/chrgs related to treatment of hosp-acquired cond or preventable med err;;4;;963;;"Services/charges related to the treatment of a hospital-acquired condition or preventable medical error."
 ;;234;;This procedure is not paid separately;;4;;964;;This procedure is not paid separately. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;235;;Sales tax;;4;;965;;Sales Tax.
 ;;A0;;Patient refund amount;;19;;800;;Patient refund amount.
 ;;A1;;Claim denied charges;;4;;801;;Claim/Service denied. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;A2;;Contractual adjustment;;4;;802;;Contractual adjustment. Notes: Use Code 45 with Group Code 'CO' or use another appropriate specific adjustment code.
 ;;A3;;Medicare Secondary Payer liability met;;4;;803;;Medicare Secondary Payer liability met.
 ;;A4;;Medicare Claim PPS Capital Day Outlier Amount;;4;;804;;Medicare Claim PPS Capital Day Outlier Amount.
 ;;A5;;Medicare Claim PPS Capital Cost Outlier Amount;;4;;805;;Medicare Claim PPS Capital Cost Outlier Amount.
 ;;A6;;Prior hospitalization or 30 day transfer requirement not met;;4;;806;;Prior hospitalization or 30 day transfer requirement not met.
 ;;A7;;Presumptive Payment Adjustment;;4;;807;;Presumptive Payment Adjustment.
 ;;A8;;Ungroupable DRG;;4;;808;;Ungroupable DRG.
 ;;B1;;Non-covered visits;;4;;851;;Non-covered visits.
 ;;B2;;Covered visits;;4;;852;;Covered visits.
 ;;B3;;Covered charges;;4;;853;;Covered charges.
 ;;B4;;Late filing penalty;;15;;854;;Late filing penalty.
 ;;B5;;Coverage/program guidelines were not met or were exceeded;;4;;855;;Coverage/program guidelines were not met or were exceeded.
 ;;B6;;Payment adj when performed/billed by type prv/type prv in type fac/prv specialty;;4;;856;;This payment is adjusted when performed/billed by this type of provider, by this type of provider in this type of facility, or by a provider of this specialty.
 ;;B7;;Provider not certified/eligible to be paid for proc/service on date of service;;4;;857;;This provider was not certified/eligible to be paid for this procedure/service on this date of service. Note: Refer to 835 Hlthcre Policy ID Sgmt (loop 2110 Srvc Pymt Info REF), if present.
 ;;B8;;Alternative services available and should have been utilized;;4;;858;;Alternative services were available, and should have been utilized. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;B9;;Patient is enrolled in a Hospice;;4;;859;;Patient is enrolled in a Hospice.
 ;;B10;;Allowed amount reduced-a component of the basic procedure/test was paid;;4;;860;;Allowed amount has been reduced because a component of the basic procedure/test was paid. The beneficiary is not liable for more than the charge limit for the basic procedure/test.
 ;;B11;;Claim/svc transferred to proper payer/processor. Claim/svc not covered;;4;;861;;The claim/service has been transferred to the proper payer/processor for processing. Claim/service not covered by this payer/processor.
 ;;B12;;Services not documented in patients' medical records;;4;;862;;Services not documented in patients' medical records.
 ;;B13;;Previously paid. Payment for claim/service provided in a previous payment;;4;;863;;Previously paid. Payment for this claim/service may have been provided in a previous payment.
 ;;B14;;Payment denied-only one visit or consultation per physician per day is covered;;4;;864;;Only one visit or consultation per physician per day is covered.
 ;;B15;;Service/procedure req that a qualifying service/proc be received and covered;;4;;865;;This srvc/proc requires that a qualifying srvc/proc be rec'd/covered. The qualifying other srvc/procedure has not been rec'd/adjudicated. Note: See www.wpc-edi.com website for complete details.
 ;;B16;;`New Patient' qualifications were not met;;4;;866;;`New Patient' qualifications were not met.
 ;;B17;;Pymt adjust-svc not prescribed by physician/prior to deliv, RX incomp/not curr;;4;;867;;Payment adjusted because this service was not prescribed by a physician, not prescribed prior to delivery, the prescription is incomplete, or the prescription is not current.
 ;;B18;;Procedure code and modifier invalid on date of service;;4;;868;;This procedure code and modifier was invalid on the date of service.
 ;;B19;;Claim/service adjusted because of the finding of a Review Organization;;4;;869;;Claim/service adjusted because of the finding of a Review Organization.
 ;;B20;;Procedure/service partially/fully furnished by another provider;;4;;870;;Procedure/service was partially or fully furnished by another provider.
 ;;B21;;Charges reduced - service/care partially furnished by another physician;;4;;871;;The charges were reduced because the service/care was partially furnished by another physician.
 ;;B22;;This payment is adjused based on the diagnosis;;4;;872;;This payment is adjused based on the diagnosis.
 ;;B23;;Proc billed not authorized per CLIA proficiency test;;4;;873;;Procedure billed is not authorized per your Clinical Laboratory Improvement Amendment (CLIA) proficiency test.
 ;;D1;;Claim/service denied. Level of subluxation is missing or inadequate;;4;;901;;Claim/service denied. Level of subluxation is missing or inadequate. Notes: Use code 16 and remark codes if necessary.
 ;;D2;;Claim lacks the name, strength, or dosage of the drug furnished;;4;;902;;Claim lacks the name, strength, or dosage of the drug furnished. Notes: Use code 16 and remark codes if necessary.
 ;;D3;;Clm/srvc denied - info indicating pat own equip requiring part/supply missing;;4;;903;;Claim/service denied because information to indicate if the patient owns the equipment that requires the part or supply was missing. Notes: Use code 16 and remark codes if necessary.
 ;;D4;;Claim/service does not indicate the period of time for which this will be needed;;4;;904;;Claim/service does not indicate the period of time for which this will be needed. Notes: Use code 16 and remark codes if necessary.
 ;;D5;;Claim/service denied - claim lacks individual lab codes included in the test;;4;;905;;Claim/service denied. Claim lacks individual lab codes included in the test. Notes: Use code 16 and remark codes if necessary.
 ;;D6;;Clm/service denied - claim not include patient's medical record for the service;;4;;906;;Claim/service denied. Claim did not include patient's medical record for the service. Notes: Use code 16 and remark codes if necessary.
 ;;D7;;Claim/service denied - claim lacks date of patient's most recent physician visit;;4;;907;;Claim/service denied. Claim lacks date of patient's most recent physician visit. Notes: Use code 16 and remark codes if necessary.
 ;;D8;;Claim/service denied - claim lacks indicator that `x-ray is available for review;;4;;908;;Claim/service denied. Claim lacks indicator that `x-ray is available for review'. Notes: Use code 16 and remark codes if necessary.
 ;;D9;;Claim/svc denied - need inv/stat cert act cost lens-disc/type intraocular lens;;4;;909;;Claim/service denied. Claim lacks invoice or statement certifying the actual cost of the lens, less discounts or the type of intraocular lens used. Notes: Use code 16 and remark codes if necessary.
 ;;D10;;Claim/svc denied - Completed phys financial relationship form not on file;;4;;910;;Claim/service denied. Completed physician financial relationship form not on file. Notes: Use code 17.
 ;;D11;;Claim lacks completed pacemaker registration form;;4;;911;;Claim lacks completed pacemaker registration form. Notes: Use code 17.
 ;;D12;;Claim/svc denied - need ident who performed the purchased diag test/amt charged;;4;;912;;Claim/service denied. Claim does not identify who performed the purchased diagnostic test or the amount you were charged for the test. Notes: Use code 17.
 ;;D13;;Clm/svc denied - performed by fac/supplier where order/refer phys has finan int;;4;;913;;Claim/service denied. Performed by a facility/supplier in which the ordering/referring physician has a financial interest. Notes: Use code 17.
 ;;D14;;Claim lacks indication that plan of treatment is on file;;4;;914;;Claim lacks indication that plan of treatment is on file. Notes: Use code 17.
 ;;D15;;Claim lacks indication that service was supervised or evaluated by a physician;;4;;915;;Claim lacks indication that service was supervised or evaluated by a physician. Notes: Use code 17.
 ;;D16;;Claim lacks prior payment information;;4;;900;;Claim lacks prior payer payment information. Notes: Use code 16 with appropriate claim payment remark code [N4].
 ;;D17;;Claim/service has invalide non-covered days;;4;;927;;Claim/Service has invalid non-covered days. Notes: Use code 16 with appropriate claim payment remark code.
 ;;D18;;Claim/service has missing diagnosis information;;4;;928;;Claim/Service has missing diagnosis information. Notes: Use code 16 with appropriate claim payment remark code.
 ;;D19;;Claim/service lacks physician/operative or other supporting documentation;;4;;929;;Claim/Service lacks Physician/Operative or other supporting documentation. Notes: Use code 16 with appropriate claim payment remark code.
 ;;D20;;Claim/service missing service/product information;;4;;970;;Claim/Service missing service/product information. Notes: Use code 16 with appropriate claim payment remark code.
 ;;D21;;This (these) diagnosis(es) is/are missing or are invalid;;4;;971;;This (these) diagnosis(es) is (are) missing or are invalid.
 ;;D22;;Reimbursement adjust-reasons to be porvided in separate correspondence (WC only);;4;;972;;Reimbursement was adjusted for the reasons to be provided in separate correrspondence. (Note: To be used for Workers' Compensation only).
 ;;D23;;Dual elig pt covered by Medicare Part D per Medicare Retro-Eligibility;;4;;973;;This dual elig pt is covered by Medicare Part D per Medicare Retro-Eligibility. At least 1 Rmrk Code must be provided (may be either NCPDP Rej Rsn Cd, or Remit Advice Rmrk Cd that is not an ALERT.)
 ;;W1;;WC State fee schedule adjustment/WC jursidication fee schedule adjustment;;3;;15;;Workers Compensation State Fee Schedule Adjustment. Workers' compensation jurisdictional fee schedule adjustment. Note: See www.wpc-edi.com website for complete details. 
 ;;W2;;Payment reduced/denied - WC jursidictional regulations or payment policies;;4;;822;;Pymt reduced or denied based on workers' compensation jurisdictional regulations or payment policies, use only if no other code is applicable. Note: See www.wpc-edi.com website for complete details.
 ;;END
