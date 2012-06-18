BARADJR3 ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE**20**;;OCT 26, 2005
 ; IHS/SD/SDR - v1.8 p20 - updated SARs
 ;
 ; *********************************************************************
EN ; EP
 D RPMSREA                   ; Create RPMS Reasons
 D STND                      ; Create new StanJdard Adj
 D CLAIM                     ; Create new Claim Status Codes
 D ^BARVKL0
 Q
 ; ********************************************************************
 ;
RPMSREA ;
 ; Create new Adjustment Reasons in A/R TABLE ENTRY
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Adding New Adjustment Reasons to A/R Table Entry file...")
 F  D RPMSREA2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
 ;
RPMSREA2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,4)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZE"
 S DINUM=$P(BARVALUE,BARD)
 S X=$P(BARVALUE,BARD,2)
 S DIC("DR")="2////^S X=$P(BARVALUE,BARD,3)"
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_"  "_$P(BARVALUE,BARD,2))
 D FILE^DICN
 Q
 ; ********************************************************************
CHNGREA ; EP
 ; Change category of these reasons to Non-Payment
 S BARD=";;"
 S BARCNT=0
 F  D CHNGREA2 Q:BARVALUE="END"
 Q
 ; ********************************************************************
CHNGREA2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,3)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DIE
 S DIE="^BARTBL("
 S DA=BARVALUE
 S DR="2////^S X=4"
 D ^DIE
 Q
 ; ********************************************************************
STND ;
 ; Create entries in A/R EDI STND CLAIM ADJ REASONS to accomodate
 ; Standard codes added between 6/02 and 9/03.
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Updating Standard Adjustment Reasons in A/R EDI STND CLAIM ADJ REASONS file...")
 F  D STND2 Q:BARVALUE="END"
 S BARCNT=0
 F  D STND2^BARADJR4 Q:BARVALUE="END"
 S BARCNT=0
 F  D STND2^BARADJR5 Q:BARVALUE="END"
 S BARCNT=0
 F  D STND2^BARADJR6 Q:BARVALUE="END"
 Q
 ; ********************************************************************
STND2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@2+BARCNT),BARD,2,6)
 Q:BARVALUE="END"
STND3 ;
 ;look for existing entry
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="M"
 S X=$P(BARVALUE,BARD)
 D ^DIC
 I +Y>0 D  Q  ;if existing entry found - edit it
 .D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 .K DIC,DIE
 .S DIE="^BARADJ("
 .S DA=+Y
 .S DR=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 .S DR=DR_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 .S DR=DR_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 .S DR=DR_";101///^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 .D ^DIE
 ;create new entry if none found
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ; Stnd Code
 S DIC("DR")=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 S DIC("DR")=DIC("DR")_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 S DIC("DR")=DIC("DR")_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 S DIC("DR")=DIC("DR")_";101///^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 D FILE^DICN
 Q
 ; ********************************************************************
CLAIM ;
 ; Populate A/R EDI CLAIM STATUS CODES to accomodate new codes added
 ; between 6/02 and 9/03. Inactivate necessary codes.
 S BARCNT=0
 F  D CLAIM2 Q:BARVALUE="END"
 S BARCNT=0
 F BARVALUE=8,10,11,13,14,28,69,70 D CLAIM3
 Q
 ; ********************************************************************
CLAIM2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,4)
 Q:BARVALUE="END"
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                        ;Status Cd
 S DIC("DR")="11///^S X=$P(BARVALUE,BARD,2)"  ;Description
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
CLAIM3 ;
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="XZQ"
 S X=BARVALUE
 K DD,DO
 D ^DIC
 Q:+Y<1
 K DA,DIE,DR
 S DA=+Y
 S DIE=DIC
 S DR=".02///Y"
 D ^DIE
 Q
 ; ********************************************************************
MODIFY ; EP
 ; Change PENDING to NON PAYMENT
 S BARD=";;"
 S BARCNT=0
 F  D MODIFY2 Q:BARVALUE="END"
 Q
 ; *********************************************************************
MODIFY2 ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,2)
 Q:BARVALUE="END"
 K DIC,DA,X,Y,DR
 S DIC="^BARADJ("
 S DIC(0)="Z"
 S X=$P(BARVALUE,BARD)  ;Stnd Code
 K DD,DO
 D ^DIC
 Q:'+Y
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".03////^S X=4"
 D ^DIE
 Q
 ;
 ; *********************************************************************
 ; IEN;;NAME;;TABLE TYPE
 ; *********************************************************************
1 ;; A/R Table Entry file - Adds
 ;;662;;Pymt Den/Reducd No Precrt Auth;;15
 ;;763;;Clm/Svc Adj No Attachment Rec;;21
 ;;764;;Clm/Svc Adj Attach not Timely;;4
 ;;765;;Pymt Den/Red No/Exceed Referr;;15
 ;;765;;Pymt Den/Red No/Exceed Referr;;15
 ;;766;;Payer Resp for Processing Over;;4
 ;;767;;DX is Not Covered;;4
 ;;768;;Benefits Not Avail by Dental Plan;;4
 ;;769;;Pymt Adj Alternate Ben Provd;;4
 ;;769;;Pymt Adj Alternate Ben Provd;;4
 ;;770;;Pymt Den Type of Provider;;4
 ;;771;;Pymt Den Type Provider/Fac;;4
 ;;772;;Pymt Adj Specialty Provider;;4
 ;;773;;Pymt Adj Not Prescr by MD;;4
 ;;774;;Pymt Den Not Prsc B4 Deliv;;4
 ;;775;;Pymt Den RX Incomplete;;4
 ;;776;;Pymt Den RX Not Current;;4
 ;;777;;Pymt Den PT Not Met Reqrmts;;4
 ;;778;;Pymt Adj Pt Spend Dn Not Met;;4
 ;;779;;Pymt Adj Pt Waiting Req Not Met;;4
 ;;780;;Pymt Adj Pt Residency Req Not;;4
 ;;781;;Pymt Adj Proc Code Inv DOS;;4
 ;;782;;Pymt Adj Modifier Inv DOS;;4
 ;;783;;Ref Prov not Elig to Refer;;4
 ;;784;;Order Prov not Elig to Order;;4
 ;;785;;Rend Prov not Elig to Prvd Svc;;4
 ;;786;;Pymt Adj Level of Care Chg;;4
 ;;787;;Health Savings Account Payments;;22
 ;;788;;Proc Cov Only for FDA Rec;;4
 ;;789;;NOC/Unlisted Proc Code Used;;4
 ;;790;;Pymt Incl in SNF Qual Stay;;4
 ;;791;;Clm Den Not Work Related No WC;;4
 ;;792;;Non Std ADJ Code Paper RA;;4
 ;;793;;Clm Properly Proc First Time;;22
 ;;794;;Pymt Adj Anes Performed by Prov;;4
 ;;795;;Pymt Adj Err Refund iss oth pyr;;19
 ;;796;;Clm/Svc Den Prior Payor Determ;;4
 ;;797;;Precert/Auth/Notif Absent;;4
 ;;798;;Precert/Auth Exceeded;;4
 ;;799;;Rev/Proc Code do not match;;4
 ;;822;;WC Pymt Den, no other code app;;4
 ;;900;;Clm Lacks Prior Pymt Info;;4
 ;;919;;Penalty/Interest Amt;;15
 ;;922;;Provider Performance Bonus;;16
 ;;927;;Clm/Svc invld noncoverd days;;4
 ;;928;;Clm/Svc missing DX info;;4
 ;;929;;Clm Lacks Supporting Dcmnt;;4
 ;;930;;Expnse Incrrd Coverag Lapse;;4
 ;;931;;Pt Resp. WC Case Settled;;4
 ;;932;;Non Cov Srv Persnal/Convenient;;4
 ;;933;;Discontinued/Reduced Srvc;;4
 ;;934;;Srvc Not Cov Under Ben Plan;;4
 ;;935;;Pharm Disc Card Proc Fee;;3
 ;;936;;NPI Missing;;21
 ;;937;;NPI Invalid Format;;21
 ;;938;;NPI Not Matched;;21
 ;;939;;Pt Resp. Bill Other Ins.;;4
 ;;940;;Pymt Adj Precert Not Timely;;4
 ;;941;;NDC not elg for rebat not cov;;4
 ;;942;;Admin Surcharge Not Covered;;4
 ;;943;;Non Compliant with Policy;;4
 ;;944;;Work Comp Non-Compensable;;4
 ;;945;;Subrogation of TP Settlement;;4
 ;;946;;Findings of Review Org.;;4
 ;;947;;Work Comp over UCR;;4
 ;;948;;Work Comp entitlement to ben.;;4
 ;;949;;Work Comp extent of injury;;4
 ;;950;;Work Comp - Bill with Code;;4
 ;;951;;Work Comp - Clm Under Invest;;21
 ;;952;;Max Time/Hours for Provider;;4
 ;;953;;Mandatory Fed/State/Local Reg;;4
 ;;954;;Pt ID compromised by ID theft;;4
 ;;956;;Pymt Adj Prvdr Info Incmplt;;4
 ;;957;;Pymt Adj Pat. Infor Incmplt;;4
 ;;958;;Info not Provided to Prev Pyr;;4
 ;;959;;Partial Chg Unall due to TOB;;4
 ;;960;;No CPT/HCPCS to describe svc;;4
 ;;961;;Proc not allowed same day/set;;4
 ;;961;;Proc not allowed same day/set;;4
 ;;962;;Institutional Trnsfr Amnt;;4
 ;;963;;Hosp Aqrd/Medical Error;;4
 ;;964;;Proc Not Pd Separately;;4
 ;;965;;Sales Tax;;4
 ;;970;;Clm/Svc miss svc/prod info;;4
 ;;971;;DX(s) missing or invalid;;4
 ;;972;;WC Pymt Adj Reason issue separ;;4
 ;;973;;Other primary coverage;;4
 ;;END
 ;
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;
 ;;1;;Deductible Amount;;13;;29;;Deductible Amount.
 ;;2;;Coinsurance Amount;;14;;602;;Coinsurance Amount.
 ;;3;;Co-payment Amount;;14;;27;;Co-payment Amount.
 ;;4;;Procedure code inconsistent w/modifier or modifier missing;;4;;604;;The procedure code is inconsistent with the modifier used or a required modifier is missing. Note: Refer to 835 Healthcare Policy Identification Segment (loop 2110 Service Pymt Info REF), if present.
 ;;5;;Procedure code/bill type inconsistent with place of service;;4;;605;;The procedure code/bill type is inconsistent with the place of service. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;6;;Procedure/Revenue code inconsistent with patient's age;;4;;606;;The procedure/revenue code is inconsistent with the patient's age. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;7;;Procedure/Revenue code inconsistent with patient's gender;;4;;607;;The procedure/revenue code is inconsistent with the patient's gender. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;8;;Procedure code inconsistent with provider type/specialty (taxonomy);;4;;608;;The procedure code is inconsistent with the provider type/specialty (taxonomy). Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;9;;Diagnosis inconsistent with patient's age;;4;;609;;The diagnosis is inconsistent with the patient's age. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;10;;Diagnosis inconsistent with patient's gender;;4;;610;;The diagnosis is inconsistent with the patient's gender. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;11;;Diagnosis inconsistent with procedure;;4;;611;;The diagnosis is inconsistent with the procedure. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;12;;Diagnosis inconsistent with provider type;;4;;612;;The diagnosis is inconsistent with the provider type. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;13;;The date of death precedes the date of service;;4;;613;;The date of death precedes the date of service.
 ;;14;;The date of birth follows the date of service;;4;;614;;The date of birth follows the date of service.
 ;;15;;Auth # missing, invalid, or does not apply to billed svc or prv;;4;;615;;The authorization number is missing, invalid, or does not apply to the billed services or provider.
 ;;16;;Claim/service lacks info needed for adjudication;;4;;616;;Clm/srvc lacks info needed for adjudication. At least one Remark Code must be provided (may be comprised of either NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;17;;Requested info not provided or insufficient/incomplete;;4;;617;;Requested info was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either Remittance Advice Remark code or NCPDP Reject Reason Code).
 ;;18;;Duplicate claim/service;;3;;135;;Duplicate claim/service.
 ;;19;;Work related injury/illness-liability of Work Comp Carrier;;4;;619;;This is a work-related injury/illness and thus the liability of the Worker's Compensation Carrier.
 ;;20;;Injury/illness is covered by the liability carrier;;4;;620;;This injury/illness is covered by the liability carrier.
 ;;21;;Injury/illness is the liability of the no-fault carrier;;4;;621;;This injury/illness is the liability of the no-fault carrier.
 ;;22;;Care may be covered by another payer per coord of benefits;;4;;622;;This care may be covered by another payer per coordination of benefits.
 ;;23;;The impact of prior payer(s) adjudication including payments and/or adjustments;;4;;623;;The impact of prior payer(s) adjudication including payments and/or adjustments.
 ;;24;;Charges covered under cap agreemnt/managed care;;4;;624;;Charges are covered under a capitation agreement/managed care plan.
 ;;25;;Payment denied. Stop loss deductible has not been met;;4;;625;;Payment denied. Your Stop loss deductible has not been met.
 ;;26;;Expenses incurred prior to coverage;;4;;626;;Expenses incurred prior to coverage.
 ;;27;;Expenses incurred after coverage terminated;;4;;627;;Expenses incurred after coverage terminated.
 ;;28;;Coverage not in effect at the time the service was provided;;4;;628;;Coverage not in effect at the time the service was provided. Notes: Redundant to codes 26 & 27.
 ;;29;;The time limit for filing has expired;;4;;134;;The time limit for filing has expired.
 ;;30;;Payment adjusted-patient not met required elig, spend down, wait, or res reqmnts;;4;;630;;Payment adjusted because the patient has not met the required eligibility, spend down, waiting, or residency requirements.
 ;;END
 ;
 ; ********************************************************************
 ; CLAIM STATUS CODE ;; DESCRIPTION
 ; ********************************************************************
3 ;; - A/R EDI Claim Status Codes file - Adds
 ;;END
 ;
 ; ********************************************************************
 ; STANDARD CODE ;; RPMS REASON
 ; ********************************************************************
4 ;;A/R Table Entry file - Edits
 ;;END;;END
