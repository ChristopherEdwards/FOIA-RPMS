ABMPT256 ; IHS/ASDST/LSL - 3P BILLING 2.5 Patch 6 POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR v2.5 p6 - 7/15/04 - Added code for two new error messages (201;202)
 ;     Other code mostly from v2.5 p5 but updated to check if codes already exist so they aren't
 ;     created again.
 ;
 Q
EN ; EP
 D ^ABMDPOST                 ; Just in case patch 2 not installed
 D ERRCD201                    ;Create 3P Error Code 201
 D ERRCD202                    ;Create 3P Error Code 202
 D ERRCD192                    ; Create 3P Error Code 192
 D ERRCD193                    ; Create 3P Error Code 193
 D CODES                        ;Update codes to be one character
 D QUES               ;make sure right questions are on 837 formats
 Q
 ;
ERRCD201 ;add error code 201
 K DIC,DIE
 S DIC="^ABMDERR("
 S DIC(0)="MQZXL"
 S DINUM=201
 S DLAYGO=9002274
 S X="TAXONOMY CODE MISSING FOR PERSON CLASS"
 K DD,DO
 D ^DIC
 I +Y<1 Q
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".02////Proceed to the 3P PROVIDER TAXONOMY CODE file in Fileman.  Choose the X12 Taxonomy code and add the person class to the PERSON CLASS field;.03////E"
 D ^DIE
 Q
ERRCD202 ; add error code 202
 K DIC,DIE
 S DIC="^ABMDERR("
 S DIC(0)="MQZXL"
 S DINUM=202
 S DLAYGO=9002274
 S X="PROVIDER CLASS NOT MAPPED TO TAXONOMY CODE"
 K DD,DO
 D ^DIC
 I +Y<1 Q
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".02////Proceed to the 3P PROVIDER TAXONOMY CODE file in Fileman.  Choose the X12 Taxonomy code and add the proivder class to the PROVIDER CLASS field;.03////E"
 D ^DIE
 Q
ERRCD192 ;
 ; Create 3P Error Code 192 - Imprecise Injury Date
 ; The code error for all 3 837 modes of export, else warning
 K DIC,DIE
 S DIC="^ABMDERR("
 S DIC(0)="MQZXL"
 S DINUM=192
 S DLAYGO=9002274
 S X="IMPRECISE INJURY DATE"
 K DD,DO
 D ^DIC
 I +Y<1 Q
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".02///If page 3 question ""Accident Related"" is yes, an exact date (mm/dd/yyyy) of injury is required"
 D ^DIE
 ;
 S IEN=DA
 D ERRSITE(IEN)
 F X=21,22,23 D EXPMODE(IEN,X)
 Q
ERRCD193 ;
 ; Create 3P Error Code 193 - Referring Provider Missing Person Class
 K DIC,DIE
 S DIC="^ABMDERR("
 S DIC(0)="MQZXL"
 S DINUM=193
 S DLAYGO=9002274
 S X="REFER. PROVIDER MISSING PIN/PERSON CLASS/PROV. CLASS/TAX. CODE"
 K DD,DO
 D ^DIC
 I +Y<1 Q
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".02///Edit Referring Physician on page 3 and add Referring Physician PIN and/or Referring Physician Person Class/Provider Class/Taxonomy Code"
 D ^DIE
 ;
 S IEN=DA
 D ERRSITE(IEN)
 F X=21,22,23 D EXPMODE(IEN,X)
 Q
 ;
ERRSITE(IEN) ;
 S ABMSITE=1
 K DIC,DIE
 F  S ABMSITE=$O(^ABMDPARM(ABMSITE)) Q:+ABMSITE=0  D
 . K DA,DIE,DIC,DR,Y,DINUM
 . S DLAYGO=9002274.04
 . S DA(1)=IEN
 . S DIC="^ABMDERR("_DA(1)_",31,"
 . S DINUM=ABMSITE,X="`"_ABMSITE
 . S DIC(0)="QXMLZ"
 . S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 . S DIC("DR")=".03///E"
 . K DD,DO
 . D ^DIC
 Q
 ;
EXPMODE(IEN,X) ;
 Q:'+IEN
 K DA,DIE,DIC,DR,Y,DINUM
 S DLAYGO=9002274.04
 S DA(1)=IEN
 S DIC="^ABMDERR("_DA(1)_",21,"
 S DINUM=X
 S DIC(0)="QXMLZ"
 S DIC("P")=$P(^DD(9002274.04,21,0),U,2)
 K DD,DO
 D ^DIC
 Q
CODES ; change admission type and admission source codes to 1-digit codes
 K DIC,DIE
 S DIE="^ABMDCODE("
 F ABMT="A","T" D
 .S ABMCD=""
 .F  S ABMCD=$O(^ABMDCODE("AC",ABMT,ABMCD)) Q:ABMCD=""  D
 ..Q:$L(ABMCD)=1
 ..S ABMIEN=""
 ..F  S ABMIEN=$O(^ABMDCODE("AC",ABMT,ABMCD,ABMIEN)) Q:ABMIEN=""  D
 ...S DA=ABMIEN
 ...S DR=".01///"_+ABMCD
 ...D ^DIE
 K ABMT,ABMIEN
 ;
 ; add new codes with category Type of Service
 F ABMI=1:1 S ABMLN=$P($T(CODETOS+ABMI),";;",2) Q:ABMLN="END"  D
 .S ABMCD=$P(ABMLN,"^")
 .S ABMDESC=$P(ABMLN,"^",2)
 .I $D(^ABMDCODE("C",$E(ABMDESC,1,30))),$D(^ABMDCODE("B",ABMCD)) Q  ;entry already exists
 .K DIC,DIE
 .S DIC="^ABMDCODE("
 .S DIC(0)="LM"
 .S X=$P(^ABMDCODE(0),U,3)+1
 .S DIC("DR")=".02////K;.03////"_ABMDESC
 .S DIC("DR")=DIC("DR")_";.01////"_ABMCD
 .K DD,DO
 .D ^DIC
 Q
QUES ;  verify questions for 837 export modes
 K DIE
 S DIE="^ABMDEXP("
 F DA=21,22,23 D
 .I DA=21 S DR=".08////1,2,3,4,5,8,14,19,21,22,23,24,28"
 .I DA=22 S DR=".08////1,2,3,4B,5,6,7,9,10,11,12B,14,15,19,20,25,26,28,29,30"
 .I DA=23 S DR=".08////1,2,3,4B,5,14,16,17,18,19,28"
 .D ^DIE
 Q
CODETOS ;
 ;;0^WHOLE BLOOD
 ;;1^MEDICAL CARE
 ;;2^SURGERY
 ;;3^CONSULATION
 ;;4^DIAGNOSTIC RADIOLOGY
 ;;5^DIAGNOSTIC LABORATORY
 ;;6^THERAPEUTIC RADIOLOGY
 ;;7^ANESTHESIA
 ;;8^ASSISTANT AT SURGERY
 ;;9^OTHER MEDICAL ITEMS OR SERVICES
 ;;A^USED DME
 ;;B^HIGH RISK SCREENING MAMMOGRAPHY
 ;;C^LOW RISK SCREENING MAMMOGRAPHY
 ;;D^AMBULANCE
 ;;E^ENTERAL/PARENTERAL NUTRIENTS/SUPPLIES
 ;;F^AMBULATORY SURGICAL CENTER
 ;;G^IMMUNOSUPPRESSIVE DRUGS
 ;;H^HOSPICE
 ;;J^DIABETIC SHOES
 ;;K^HEARING ITEMS AND SERVICES
 ;;L^ESRD SUPPLIES
 ;;M^MONTHLY CAPITATION PAYMENT FOR DIALYSIS
 ;;N^KIDNEY DONOR
 ;;P^LUMP SUM PURCHASE OF DME, PROSTHETICS, ORTHOTICS
 ;;Q^VISION ITEMS OR SERVICES
 ;;R^RENTAL OF DME
 ;;S^SURGICAL DRESSINGS OR OTHER MEDICAL SUPPLIES
 ;;T^OUTPATIENT MENTAL HEALTH TREATMENT LIMITATION
 ;;U^OCCUPATIONAL THERAPY
 ;;V^PNEUMOCOCCAL/FLU VACCINE
 ;;W^PHYSICAL THERAPY
 ;;END
