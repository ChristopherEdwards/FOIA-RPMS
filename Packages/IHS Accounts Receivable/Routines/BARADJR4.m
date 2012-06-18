BARADJR4 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
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
 ;;31;;Patient cannot be identified as insured;;4;;166;;Patient cannot be identified as our insured.
 ;;32;;Our records indicate that dependent is not eligible dependent as defined;;4;;632;;Our records indicate that this dependent is not an eligible dependent as defined.
 ;;33;;Insured has no dependent coverage;;4;;633;;Insured has no dependent coverage.
 ;;34;;Insured has no coverage for newborns;;4;;17;;Insured has no coverage for newborns.
 ;;35;;Lifetime benefit maximum has been reached;;4;;167;;Lifetime benefit maximum has been reached.
 ;;36;;Balance does not exceed co-payment amount;;4;;636;;Balance does not exceed co-payment amount.
 ;;37;;Balance does not exceed deductible;;4;;637;;Balance does not exceed deductible.
 ;;38;;Services not provided or authorized by designated (network) providers;;4;;638;;Services not provided or authorized by designated (network/primary care) providers.
 ;;39;;Services denied at the time authorization/pre-certification was requested;;4;;639;;Services denied at the time authorization/pre-certification was requested.
 ;;40;;Charges do not meet qualifications for emergent/urgent care;;4;;640;;Charges do not meet qualifications for emergent/urgent care. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;41;;Discount agreed to in Preferred Provider contract;;4;;168;;Discount agreed to in Preferred Provider contract.
 ;;42;;Charges exceed our fee schedule or maximum allowable amount;;4;;21;;"Charges exceed our fee schedule or maximum allowable amount. (Use CARC 45)".
 ;;43;;Gramm-Rudman reduction;;4;;643;;Gramm-Rudman reduction.
 ;;44;;Prompt-pay discount;;4;;644;;Prompt-pay discount.
 ;;45;;Charges exceed fee schedule/max allow or contracted/legislated fee arrangement;;4;;645;;Charges exceed fee schedule/maximum allowable or contracted/legislated fee arrangement. (Use Group Codes PR or CO depending upon liability).
 ;;46;;This (these) service(s) is (are) not covered;;4;;122;;This (these) service(s) is (are) not covered. Notes: Use code 96.
 ;;47;;This (these) diagnosis(es) is (are) not covered, missing, or are invalid;;4;;647;;This (these) diagnosis(es) is (are) not covered, missing, or are invalid.
 ;;48;;This (these) procedure(s) is (are) not covered;;4;;648;;This (these) procedure(s) is (are) not covered. Notes: Use code 96.
 ;;49;;Non-covered services-routine exam/screening proc in conj w/routine exam;;4;;20;;These are non-covered srvcs because this is rtn exam or screening procedure done in conj. with rtn exam. Note: Refer to 835 Healthcare Policy Iden. Segment (loop 2110 Srvc Pymt Info REF), if present.
 ;;50;;Non-covered services-not deemed a `medical necessity' by the payer;;4;;169;;These are non-covered services because this is not deemed a 'medical necessity' by the payer. Note: Refer to 835 Healthcare Policy Identification Segment (loop 2110 Srvc Pymt Info REF), if present.
 ;;51;;Non-covered services-pre-existing condition;;4;;19;;These are non-covered services because this is a pre-existing condition. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;52;;Ref/prescrib/render/Prv not eligible to ref/prescrib/order/perform svc billed;;4;;178;;The referring/prescribing/rendering provider is not eligible to refer/prescribe/order/perform the service billed.
 ;;53;;Services by an immediate relative/member of the same household are not covered;;4;;653;;Services by an immediate relative or a member of the same household are not covered.
 ;;54;;Multiple physicians/assistants are not covered in this case;;4;;654;;Multiple physicians/assistants are not covered in this case. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;55;;Claim/svc denied-proc/trtmnt deemed experimental/investigational by the payer;;4;;655;;Procedure/treatment is deemed experimental/investigational by the payer. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;56;;Claim/svc denied-proc/trtmnt not deemed `proven to be effective' by the payer;;4;;656;;Procedure/treatment has not been deemed 'proven to be effective' by the payer. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;57;;Payment denied/reduced-doc not support level/#/length of svc/dosage/day's supply;;4;;657;;Pymt denied/reduced because payer deems info submitted does not support this lvl of srvc/many srvcs/lgth of srvc, this dosage, or this day's supply. Note: Split into codes 150,151,152,153,and 154.
 ;;58;;Payment adjusted-trtmnt rendered in inappropriate/invalid place of svc;;4;;658;;Treatment was deemed by payer to have been rendered in inappropriate/invalid place of service. Note: Refer to 835 Healthcare Policy Identification Segment (loop 2110 Srvc Pymt Info REF), if present.
 ;;59;;Charges adjusted- multiple surgery rules/concurrent anesthesia rules;;4;;659;;Processed based on multi/concurrent proc rules. (e.g., multi-surgery or diag. imaging, concurrent anes.) Note: Refer to 835 Healthcare Policy ID Segment (loop 2110 Srvc Pymt Info REF), if present.
 ;;60;;Charges for outpat svcs w/this proximity to inpat svcs not covered;;4;;660;;Charges for outpatient services are not covered when performed within a period of time prior to or after inpatient services.
 ;;61;;Charges adjusted-penalty for failure to obtain second surgical opinion;;21;;661;;Penalty for failure to obtain second surgical opinion. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;62;;Payment denied/reduced-absence of/exceeded, pre-certification/authorization;;15;;662;;Payment denied/reduced for absence of, or exceeded, pre-certification/authorization.
 ;;63;;Correction to a prior claim;;4;;663;;Correction to a prior claim.
 ;;64;;Denial reversed per Medical Review;;22;;664;;Denial reversed per Medical Review.
 ;;65;;Procedure code was incorrect. This payment reflects the correct code;;4;;665;;Procedure code was incorrect. This payment reflects the correct code.
 ;;66;;Blood Deductible;;13;;666;;Blood Deductible.
 ;;67;;Lifetime reserve days;;4;;667;;Lifetime reserve days. (Handled in QTY, QTY01=LA).
 ;;68;;DRG weight;;16;;93;;DRG weight. (Handled in CLP12).
 ;;69;;Day outlier amount;;4;;669;;Day outlier amount.
 ;;70;;Cost outlier - Adjustment to compensate for additonal costs;;4;;670;;Cost outlier - Adjustment to compensate for additonal costs.
 ;;71;;Primary Payer amount;;4;;165;;Primary Payer amount. Notes: Use code 23.
 ;;72;;Coinsurance day;;14;;672;;Coinsurance day. (Handled in QTY, QTY01=CD).
 ;;73;;Administrative days;;4;;673;;Administrative days.
 ;;74;;Indirect Medical Education Adjustment;;4;;674;;Indirect Medical Education Adjustment.
 ;;75;;Direct Medical Education Adjustment;;4;;675;;Direct Medical Education Adjustment.
 ;;76;;Disproportionate Share Adjustment;;4;;676;;Disproportionate Share Adjustment.
 ;;77;;Covered days;;4;;677;;Covered days. (Handled in QTY, QTY01=CA).
 ;;78;;Non-Covered days/Room charge adjustment;;4;;678;;Non-Covered days/Room charge adjustment.
 ;;79;;Cost Report days;;4;;679;;Cost Report days. (Handled in MIA15).
 ;;80;;Outlier days;;4;;680;;Outlier days. (Handled in QTY, QTY01=OU).
 ;;81;;Discharges;;4;;681;;Discharges.
 ;;82;;PIP days;;4;;682;;PIP days.
 ;;83;;Total visits;;4;;683;;Total visits.
 ;;84;;Capital Adjustment;;4;;684;;Capital Adjustment. (Handled in MIA).
 ;;85;;Patient interest amount;;4;;685;;Patient Interest Adjustment (Use Only Group code PR). Notes: Only use when the payment of interest is the responsibility of the patient.
 ;;86;;Statutory Adjustment;;4;;686;;Statutory Adjustment. Notes: Duplicative of code 45.
 ;;87;;Transfer amount;;4;;687;;Transfer amount.
 ;;88;;Adj amt represents collection against receivable created in prior overpayment;;21;;688;;Adjustment amount represents collection against receivable created in prior overpayment.
 ;;89;;Professional fees removed from charges;;4;;689;;Professional fees removed from charges.
 ;;90;;Ingredient cost adjustment;;4;;690;;Ingredient cost adjustment. Note: To be used for pharmaceuticals only.
 ;;91;;Dispensing fee adjustment;;3;;691;;Dispensing fee adjustment.
 ;;92;;Claim Paid in full;;22;;692;;Claim Paid in full.
 ;;93;;No Claim level Adjustments;;22;;693;;No Claim level Adjustments. Notes: As of 004010, CAS at the claim level is optional.
 ;;94;;Processed in Excess of charges;;16;;694;;Processed in Excess of charges.
 ;;95;;Plan procedures not followed;;4;;695;;Plan procedures not followed.
 ;;96;;Non-covered charge(s);;4;;696;;Non-cov'd chg(s). At least 1 Rmk Cd must be provided (may be NCPDP Rej Rsn Cd, or Remit Advc Rmrk Cd, not ALERT.) Note: Refer to 835 Hlthcre Policy ID Sgmt (loop 2110 Srvc Pymt Info REF), if present.
 ;;97;;Benefit included in the pymt/allow for another service/procedure already adjud;;4;;697;;The benft for this srvc is incl. in pymt/allowance for another srvc/procedure that has already been adjudicated. Note: Refer to 835 Hlthcre Policy ID Sgmt (loop 2110 Srvc Pymt Info REF), if present.
 ;;98;;Hospital must file Medicare claim for this inpatient non-physician service;;21;;698;;The hospital must file the Medicare claim for this inpatient non-physician service.
 ;;99;;Medicare Secondary Payer Adjustment Amount;;4;;699;;Medicare Secondary Payer Adjustment Amount.
 ;;100;;Payment made to patient/insured/responsible party/employer;;4;;23;;Payment made to patient/insured/responsible party/employer.
 ;;101;;Predetermination: anticipate payment upon completion of svcs/claim adjudication;;21;;701;;Predetermination: anticipated payment upon completion of services or claim adjudication.
 ;;102;;Major Medical Adjustment;;4;;702;;Major Medical Adjustment.
 ;;103;;Provider promotional discount (e.g., Senior citizen discount);;4;;703;;Provider promotional discount (e.g., Senior citizen discount).
 ;;104;;Managed care withholding;;4;;704;;Managed care withholding.
 ;;105;;Tax withholding;;4;;705;;Tax withholding.
 ;;106;;Patient payment option/election not in effect;;4;;706;;Patient payment option/election not in effect.
 ;;107;;Related or qualifying claim/service not identified on claim;;4;;707;;The related or qualifying claim/service was not identified on this claim. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;108;;Rent/purchase guidelines were not met;;4;;708;;Rent/purchase guidelines were not met. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;109;;Claim not covered by payer/contractor. Send claim to correct payer/contractor;;4;;709;;Claim not covered by this payer/contractor. You must send the claim to the correct payer/contractor.
 ;;110;;Billing date predates service date;;4;;710;;Billing date predates service date.
 ;;111;;Not covered unless the provider accepts assignment;;4;;711;;Not covered unless the provider accepts assignment.
 ;;112;;Payment adjusted as not furnished directly to the patient and/or not documented;;4;;180;;Service not furnished directly to the patient and/or not documented.
 ;;113;;Payment denied-service/procedure provided outside the US or as a result of war;;4;;713;;Payment denied because service/procedure was provided outside the United States or as a result of war. Notes: Use Codes 157, 158, or 159.
 ;;114;;Procedure/product not approved by the Food and Drug Administration;;4;;714;;Procedure/product not approved by the Food and Drug Administration.
 ;;115;;Procedure postponed or canceled;;4;;715;;Procedure postponed, canceled, or delayed.
 ;;116;;Advance indemnification notice signed by patient did not comply w/requirements;;4;;716;;The advance indemnification notice signed by the patient did not comply with requirements.
 ;;117;;Transport only covered closest facility that can provide necessary care;;4;;717;;Transportation is only covered to the closest facility that can provide the necessary care.
 ;;118;;ESRD network support adjustment;;4;;718;;ESRD network support adjustment.
 ;;119;;Benefit maximum for this time period or occurrence has been reached;;4;;719;;Benefit maximum for this time period or occurrence has been reached.
 ;;120;;Patient is covered by a managed care plan;;4;;720;;Patient is covered by a managed care plan. Notes: Use code 24.
 ;;121;;Indemnification adjustment;;4;;721;;Indemnification adjustment - compensation for outstanding member responsibility.
 ;;122;;Psychiatric reduction;;4;;722;;Psychiatric reduction.
 ;;123;;Payer refund due to overpayment;;22;;723;;Payer refund due to overpayment.
 ;;124;;Payer refund amount - not our patient;;22;;724;;Payer refund amount - not our patient. Notes: Refer to implementation guide for proper handling of reversals.
 ;;125;;Submission/billing error(s);;4;;725;;Submission/billing error(s). At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;126;;Deductible -- Major Medical;;13;;726;;Deductible -- Major Medical. Notes: Use Group Code PR and code 1.
 ;;127;;Coinsurance -- Major Medical;;14;;727;;Coinsurance -- Major Medical. Notes: Use Group Code PR and code 2.
 ;;128;;Newborn's services are covered in the mother's Allowance;;4;;728;;Newborn's services are covered in the mother's Allowance.
 ;;129;;Prior processing information appears incorrect;;4;;164;;Prior processing information appears incorrect.
 ;;130;;Claim submission fee;;4;;730;;Claim submission fee.
 ;;131;;Claim specific negotiated discount;;4;;731;;Claim specific negotiated discount.
 ;;132;;Prearranged demonstration project adjustment;;4;;732;;Prearranged demonstration project adjustment.
 ;;133;;The disposition of this claim/service is pending further review;;21;;733;;The disposition of this claim/service is pending further review.
 ;;134;;Technical fees removed from charges;;4;;734;;Technical fees removed from charges.
 ;;135;;Interim bills cannot be processed;;4;;735;;Interim bills cannot be processed.
 ;;END
