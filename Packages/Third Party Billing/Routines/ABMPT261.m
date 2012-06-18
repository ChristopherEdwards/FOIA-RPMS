ABMPT261 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 1 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 Q
EN ;EP
 D ECODES
 D QEXP29  ;add prior auth question (#28) to export mode 29
 Q
ECODES ;
 ;HEAT 6439
 Q:$D(^ABMDCODE("AC","W"))  ;PWK codes already entered
 K DIC,X
 F ABMI=1:1 S ABMLN=$P($T(ECODETXT+ABMI),";;",2) Q:ABMLN="END"  D
 .S ABMCODE=$P(ABMLN,U)
 .S ABMDESC=$P(ABMLN,U,2)
 .S DIC="^ABMDCODE("
 .S DIC(0)="ML"
 .S X=ABMCODE
 .S DIC("DR")=".02///W"
 .S DIC("DR")=DIC("DR")_";.03///"_ABMDESC
 .K DD,DO
 .D FILE^DICN
 Q
ECODETXT ;
 ;;77^Support Data for Verification (REFERRAL)
 ;;AS^Admission Summary
 ;;B2^Prescription
 ;;B3^Physician Order
 ;;B4^Referral Form
 ;;CT^Certification
 ;;DA^Dental Models
 ;;DG^Diagnostic Report
 ;;DS^Discharge Summary
 ;;EB^Explanation of Benefits (CoB or MSP)
 ;;MT^Models
 ;;NN^Nursing Notes
 ;;OB^Operative Note
 ;;OZ^Support Data for Claim
 ;;PN^Physical Therapy Notes
 ;;PO^Prosthetics or Orthotic Certification
 ;;PZ^Physical Therapy Certification
 ;;RB^Radiology Films
 ;;RR^Radiology Reports
 ;;RT^Report of Tests and Analysis Report
 ;;P6^Periodontal Chart
 ;;END
 Q
QEXP29 ;
 S ABMLIST=$P($G(^ABMDEXP(29,0)),U,8)
 S ABMLIST=ABMLIST_",28"
 S DIE="^ABMDEXP("
 S DA=29
 S DR=".08////"_ABMLIST
 D ^DIE
 Q
