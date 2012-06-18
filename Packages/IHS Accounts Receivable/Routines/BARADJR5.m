BARADJR5 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
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
 ;;136;;Failure to follow prior payer's coverage rules;;4;;736;;Failure to follow prior payer's coverage rules. (Use Group Code OA).
 ;;137;;Regulatory Surcharges/Assessments/Allowances/Health Related Taxes;;4;;141;;Regulatory Surcharges, Assessments, Allowances or Health Related Taxes.
 ;;138;;Appeal procedures not followed or time limits not met;;4;;738;;Appeal procedures not followed or time limits not met.
 ;;139;;Contracted funding agreement - Subscriber employed by the provider of services;;4;;739;;Contracted funding agreement - Subscriber is employed by the provider of services.
 ;;140;;Patient/Insured health identification number and name do not match;;4;;740;;Patient/Insured health identification number and name do not match.
 ;;141;;Claim spans eligible and ineligible periods of coverage;;4;;125;;Claim spans eligible and ineligible periods of coverage.
 ;;142;;Monthly Medicaid patient liability amount;;4;;742;;Monthly Medicaid patient liability amount.
 ;;143;;Portion of payment deferred;;21;;743;;Portion of payment deferred.
 ;;144;;Incentive adjustment, e.g. preferred product/service;;4;;744;;Incentive adjustment, e.g. preferred product/service.
 ;;145;;Premium payment withholding;;4;;745;;Premium payment withholding. Notes: Use Group Code CO and code 45.
 ;;146;;Diagnosis invalid for the date(s) of service reported;;4;;746;;Diagnosis was invalid for the date(s) of service reported.
 ;;147;;Provider contracted/negotiated rate expired or not on file;;4;;747;;Provider contracted/negotiated rate expired or not on file.
 ;;148;;Information from another provider was not provided or was insuff/incomplete;;4;;748;;Info from another provider was not provided or was insufficient/incomplete. At least 1 Remark Code must be provided (may be either NCPDP Rej Rsn Cd, or Remit Advice Remrk Cd that is not an ALERT.)
 ;;149;;Lifetime benefit maximum has been reached for this service/benefit category;;4;;749;;Lifetime benefit maximum has been reached for this service/benefit category.
 ;;150;;Payer deems the info submitted not support this level of service;;4;;754;;Payer deems the information submitted does not support this level of service.
 ;;151;;Pmt adjusted - payer deems the info submitted not support this many svcs;;4;;750;;Payment adjusted because the payer deems the information submitted does not support this many/frequency of services.
 ;;152;;Payer deems the info submitted not support this lgth of svc;;4;;751;;Payer deems the information submitted does not support this length of service. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;153;;Payer deems the info submitted not support this dosage;;4;;752;;Payer deems the information submitted does not support this dosage.
 ;;154;;Payer deems the info submitted not support this day's supply;;4;;753;;Payer deems the information submitted does not support this day's supply.
 ;;155;;Patient refused the service/procedure;;4;;755;;Patient refused the service/procedure.
 ;;156;;Flexible spending account payments;;22;;756;;Flexible spending account payments. Note: Use code 187.
 ;;157;;Service/procedure provided as a result of an act of war;;4;;757;;Service/procedure was provided as a result of an act of war.
 ;;158;;Service/procedure provided ou tside the United States;;4;;758;;Service/procedure was provided outside of the United States.
 ;;159;;Service/procedure provided as a result of terrorism;;4;;759;;Service/procedure was provided as a result of terrorism.
 ;;160;;Injury/illness result of activity that's a benefit exclusion;;4;;760;;Injury/illness was the result of an activity that is a benefit exclusion.
 ;;161;;Provider performance bonus;;16;;922;;Provider performance bonus.
 ;;162;;State-mandated requirment for property/casulty--see claim payment remark codes;;4;;762;;State-mandated Requirement for Property and Casualty, see Claim Payment Remarks code for specific explanation.
 ;;163;;Attachment regerenced on the claim was not received;;21;;763;;Attachment referenced on the claim was not received.
 ;;164;;Attachment regerenced on the claim was not received in a timely fashion;;4;;764;;Attachment referenced on the claim was not received in a timely fashion.
 ;;165;;Referral absent or exceeded;;15;;765;;Referral absent or exceeded.
 ;;166;;Svcs submitted after this payers resp for processing clms under this plan ended;;4;;766;;These services were submitted after this payers responsibility for processing claims under this plan ended.
 ;;167;;This (these) diagnosis(es) is (are) not covered;;4;;767;;This (these) diagnosis(es) is (are) not covered. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;168;;Svcs have been considerd under pts med plan. Benfts not avail under dental plan ;;4;;768;;Service(s) have been considered under the patient's medical plan. Benefits are not available under this dental plan.
 ;;169;;Alternate benefit has been provided;;4;;769;;Alternate benefit has been provided.
 ;;170;;Payment denied when performed/billed by this type of provider;;4;;770;;Payment is denied when performed/billed by this type of provider. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;171;;Paymt denied when performed/billed by this type of provider in this type of fac;;4;;771;;Payment is denied when performed/billed by this type of provider in this type of facility. Note: Refer to 835 Healthcare Policy Identification Segment (loop 2110 Service Pymt Info REF), if present.
 ;;172;;Payment adjusted when perfomed/billed by a provider of this specialty;;4;;772;;Payment is adjusted when performed/billed by a provider of this specialty. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;173;;Service was not prescribed by a physician;;4;;773;;Service was not prescribed by a physician.
 ;;174;;Service was not prescribed prior to delivery;;4;;774;;Service was not prescribed prior to delivery.
 ;;175;;Prescription is incomplete;;4;;775;;Prescription is incomplete.
 ;;176;;Prescription is not current;;4;;776;;Prescription is not current.
 ;;177;;Patient has not met the required eligibility requirements;;4;;777;;Patient has not met the required eligibility requirements.
 ;;178;;Patient has not met the required spend down requirements;;4;;778;;Patient has not met the required spend down requirements.
 ;;179;;Patient has not met the required waiting requirements;;4;;779;;Patient has not met the required waiting requirements. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;180;;Patient has not met the required residency requirements;;4;;780;;Patient has not met the required residency requirements.
 ;;181;;Procedure code invalid on the date of service;;4;;781;;Procedure code was invalid on the date of service.
 ;;182;;Procedure modifier was invalid on the date of service;;4;;782;;Procedure modifier was invalid on the date of service.
 ;;183;;Referring provider is not eligible to refer the services billed;;4;;783;;The referring provider is not eligible to refer the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;184;;Prescribing/ordering provider is not eligible to prescribe/order the svc billed;;4;;784;;The prescribing/ordering provider is not eligible to prescribe/order the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Pymt Info REF), if present.
 ;;185;;Rendering provider not eligibile to perform the service billed;;4;;785;;The rendering provider is not eligible to perform the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;186;;Level of care change adjustemnt;;4;;786;;Level of care change adjustment.
 ;;187;;Consumer Spending Acct pymts (incl Flex Spending, Hlth Savings, Hlth Reimburs);;22;;787;;Consumer Spending Account payments (includes but is not limited to Flexible Spending Account, Health Savings Account, Health Reimbursement Account, etc.).
 ;;188;;Product/procedure covered when used according to FDA recommendations;;4;;788;;This product/procedure is only covered when used according to FDA recommendations.
 ;;189;;'NOC' or 'unlisted' procedure code (CPT/HCPCS) billed when specific code exists ;;4;;789;;Not otherwise classified' or 'unlisted' procedure code (CPT/HCPCS) was billed when there is a specific procedure code for this procedure/service.
 ;;190;;Payment included in allowance for Skilled Nursing Facility (SNF) qualified stay;;4;;790;;Payment is included in the allowance for a Skilled Nursing Facility (SNF) qualified stay.
 ;;191;;Not a work related injury/illness and not the liability of the WC carrier;;4;;791;;Not a work related injury/illness and thus not the liability of the workers' compensation carrier. Note: See www.wpc-edi.com website for complete details.
 ;;192;;Non Standard adjustment code from paper remittance advice;;4;;792;;Non standard adjustment code from paper remittance. See www.wpc-edi.com website for complete details.
 ;;193;;Orig pymnt decision maintained - review determined claim was processed properly;;22;;793;;Original payment decision is being maintained. Upon review, it was determined that this claim was processed properly.
 ;;194;;Anesthesia perf by operating physician, assistant surgeon or attending physician;;4;;794;;Anesthesia performed by the operating physician, the assistant surgeon or the attending physician.
 ;;195;;Refund issued to erroneous priority payer for claim/service;;19;;795;;Refund issued to an erroneous priority payer for this claim/service.
 ;;196;;Claim/service denied based on prior payer's coverage detemination;;4;;796;;Claim/service denied based on prior payer's coverage determination. Notes: Use code 136.
 ;;197;;Precertification/authorization/notification absent;;4;;797;;Precertification/authorization/notification absent.
 ;;198;;Precertification/authorization exceeded;;4;;798;;Precertification/authorization exceeded.
 ;;199;;Revenue code and Procedure code do not match;;4;;799;;Revenue code and Procedure code do not match.
 ;;200;;Expenses incurred during lapse in coverage;;4;;930;;Expenses incurred during lapse in coverage.
 ;;201;;WC Case settled. Pt is responsible thru WC 'Medicare set aside arrang';;4;;931;;Workers Compensation case settled. Patient is responsible for amount of this claim/service through WC 'Medicare set aside arrangement' or other agreement. (Use group code PR).
 ;;202;;Non-covered personal comfort or convenience services;;4;;932;;Non-covered personal comfort or convenience services.
 ;;203;;Discontinued or reduced service;;4;;933;;Discontinued or reduced service.
 ;;204;;Service/equipment/drug not covered under the patient's current benefit plan;;4;;934;;This service/equipment/drug is not covered under the patient's current benefit plan.
 ;;205;;Pharmacy discount card processing fee;;3;;935;;Pharmacy discount card processing fee.
 ;;206;;National Provider Identifier - Missing;;21;;936;;National Provider Identifier - Missing.
 ;;207;;National Provider Identifier - Invalid format;;21;;937;;National Provider Identifier - Invalid format.
 ;;208;;National Provider Identifier - Not matched;;21;;938;;National Provider Identifier - Not matched.
 ;;209;;Amt may not be collect fr pt. Amt may be billed to subseq pyr. Ref to pt if coll;;4;;939;;Per regulatory or other agreement. The provider cannot collect this amt from patient. However, this amount may be billed to subsequent payer. Refund to the patient if collected. (Use Group code OA).
 ;;210;;Payment adjusted - Pre-cert/auth not received in a timely fashion;;4;;940;;Payment adjusted because pre-certification/authorization not received in a timely fashion.
 ;;211;;National Drug Codes (NDC) not eligible for rebate, are not covered;;4;;941;;National Drug Codes (NDC) not eligible for rebate, are not covered.
 ;;212;;Administrative surcharges are not covered;;4;;942;;Administrative surcharges are not covered.
 ;;213;;Non-compliance with physician self referral prohibition legislation/payer policy;;4;;943;;Non-compliance with the physician self referral prohibition legislation or payer policy.
 ;;214;;WC claim adjusted as noncompensable. Payer not liable for claim or service/treat;;4;;944;;Workers' Compensation claim adjudicated as non-compensable. This Payer not liable for claim or service/treatment. Note: See www.wpc-edi.com website for complete details.
 ;;215;;Based on subrogation of a third party settlement;;4;;945;;Based on subrogation of a third party settlement.
 ;;216;;Based on the findings of a review organization;;4;;946;;Based on the findings of a review organization.
 ;;217;;Based on payer reasonable and customary fees (WC only);;4;;947;;Based on payer reasonable and customary fees. No maximum allowable defined by legislated fee arrangement. (Note: To be used for Workers' Compensation only).
 ;;218;;Based on entitlement to benefits (WC only);;4;;948;;Based on entitlement to benefits. Note: See www.wpc-edi.com website for complete details.
 ;;219;;Based on extent of injury (WC only);;4;;949;;Based on extent of injury. Note: See www.wpc-edi.com website for complete details.
 ;;220;;Applicable fee schedule does not contain the billed code (WC only);;4;;950;;The applicable fee sched does not contain billed cd. Please resubmit a bill with appropriate fee sched cd(s) that best describe srvcs provided and supporting docs if req'd. (Note: Use for WC only).
 ;;221;;WC claim under investigation;;21;;951;;Workers' Compensation claim is under investigation. Note: See www.wpc-edi.com website for complete details.
 ;;222;;Exceeds contracted max number of hours/days/units by this provider/this period;;4;;952;;Exceeds contracted max. number of hrs/days/units by this provider for this period. This is not patient specific. Note: Refer to 835 Hlthcre Policy ID Sgmt (loop 2110 Srvc Pymt Info REF), if present.
 ;;END
