ABMP2614 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 14 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**14**;NOV 12, 2009;Build 238
 ;IHS/SD/SDR - 2.6*14 - CR3165 - Changed 3P Error Codes entry 155 from error to warning
 ;
 Q
POST ;
 D ICDEFFDT  ;Change ICD-10 Effective date to 10/1/2015 for all insurers
 D ERRORCD  ;create new claim editor error codes
 D PCCST  ;new 3P PCC VISIT BILLING STATUS entry
 D CCREASON  ;new cancelled claim reason
 D FEEINDX  ;re-index fee table
 D ADA12Q  ;add to ADA-2012 questions
 ;
 Q
ICDEFFDT ;
 D MES^XPDUTL("Auto-populating ICD-10 EFFECTIVE DATE with 10/1/2015 for all insurers...")
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMNINS(DUZ(2))) Q:'DUZ(2)  D
 .S ABMDA=0
 .F  S ABMDA=$O(^ABMNINS(DUZ(2),ABMDA)) Q:'ABMDA  D
 ..K DIC,DIE,DIR,X,Y,DA,DR
 ..S DIE="^ABMNINS("_DUZ(2)_","
 ..S DA=ABMDA
 ..S DR=".12////3151001"
 ..D ^DIE
 S DUZ(2)=ABMHOLD
 Q
ERRORCD ;
 ;ICD10 002F
 ;245 - Active Insurer requires ICD-9 codes, not ICD-10
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=245
 S X="Active Insurer requires ICD-9 codes, not ICD-10"
 S DIC("DR")=".02///Review codes on claim using View Option"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(245)
 ;246 - Active Insurer requires ICD-10 codes, not ICD-9
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=246
 S X="Active Insurer requires ICD-10 codes, not ICD-9"
 S DIC("DR")=".02///Review codes on claim using View Option"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(246)
 ;247 - Multiple ICD code sets used on claim
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=247
 S X="Multiple ICD code sets used on claim"
 S DIC("DR")=".02///Review codes on claim using View Option"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(247)
 ;248 - Uncoded Procedure code on the claim
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=248
 S X="Uncoded Procedure code on the claim"
 S DIC("DR")=".02///Review codes on claim using View Option"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(248)
 ;249 - Service Dates cross over ICD-10 Effective Date
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=249
 S X="Service Dates cross over ICD-10 Effective Date"
 S DIC("DR")=".02///Consider splitting claim, one for ICD-9 and one for ICD-10"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(249)
 ;250 - DOS after ICD Indicator Date
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=250
 S X="DOS after ICD Indicator Date"
 S DIC("DR")=".02///ICD-10 codes required for billing"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(250)
 ;251 - Wrong DX coding version used
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=251
 S X="Wrong Diagnosis Coding Version Used"
 S DIC("DR")=".02///Review code set on page 5"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(251)
 ;252 - Insurer file missing Entry named Veterans Medical Benefit
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=252
 S X="INSURER FILE MISSING ENTRY NAMED VETERANS MEDICAL BENEFIT"
 S DIC("DR")=".02///Through the Insurer Maintenance Menu Option add an Insurer named VETERANS MEDICAL BENEFIT"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(252)
 ;253 - This is a VA Claim with Medicare/Medicaid
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=253
 S X="This is a VA Claim with Medicare/Medicaid"
 S DIC("DR")=".02///This is a VA Claim with Medicare/Medicaid"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(253)
 ;254 - This is a VA Claim with Pharmacy charges in PCC
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=254
 S X="This is a VA Claim with Pharmacy charges in PCC"
 S DIC("DR")=".02///This is a VA Claim with Pharmacy charges in PCC"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(254)
 ;155 - Change existing code from error to warning due to page 9A displaying more frequently
 K DIC,X
 S DIE="^ABMDERR("
 S DA=155
 S DR=".03////W"
 D ^DIE
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDERR(155,31,DUZ(2))) Q:'DUZ(2)  D
 .S DA(1)=155
 .S DA=DUZ(2)
 .S DIE="^ABMDERR("_DA(1)_",31,"
 .S DR=".03////W"
 .D ^DIE
 Q
 ;
SITE(ABMX) ;
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S("^247^248^249^250^251^253^254^"[("^"_ABMX_"^"):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
 ;
PCCST ;new 3P PCC VIST BILLING STATUS entry
 K DIC,X,DINUM
 S DIC="^ABMDCS("
 S DINUM=63
 S X="VMBP COVERAGE; VISIT OUTSIDE ELIGIBILITY DATES (NE)"
 S DIC(0)="ML"
 K DD,DO
 D FILE^DICN
 Q
CCREASON ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="UNBILLABLE CLAIM; Patient Incarcerated"
 D ^DIC
 Q
FEEINDX ;EP
 S DIK="^ABMDFEE("
 D ENALL^DIK
 Q
ADA12Q ;
 S DIE="^ABMDEXP("
 S DA=34
 S DR=".08////1,2,3,4,16,17,18,32,33"
 D ^DIE
 Q
