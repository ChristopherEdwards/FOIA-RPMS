ABMPT266 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 5 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**6**;NOV 12, 2009
 ;
 Q
PRE ;
 S DIK="^ABMDEXP("
 S DA=23
 D ^DIK
 S DA=24
 D ^DIK
 S DA=32
 D ^DIK
 S DIK="^ABMPSTAT("
 S DA=20
 D ^DIK
 S DA=24
 D ^DIK
 Q
EN ;EP
 D ERRCODES  ;new error codes
 D ECODES ; new 3P Codes
 D QUES  ;3P PAGE3 QUESTIONS
 D CASHCK  ;check cashiering sessions for .01 field being populated
 Q
ERRCODES ;
 ;235 - Facility NPI missing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=235
 S X="Facility NPI missing"
 S DIC("DR")=".02///Add NPI for facility"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(235)
 ;236 - Subscriber Primary Identifier missing
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=236
 S X="Subscriber Primary Identifier missing"
 S DIC("DR")=".02///Populate subscriber number"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(236)
 ;237 - Special Program code not supported by 837 5010 format
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=237
 S X="Special Program code not supported by 837 5010 format"
 S DIC("DR")=".02///Use 5010 or different special program code"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(237)
 ;238 - Only one disability date populated
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=238
 S X="Only one disability date populated"
 S DIC("DR")=".02///Populated both dates if possible"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(238)
 ;239 - No Prescription Number
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=239
 S X="Prescription Number missing"
 S DIC("DR")=".02///Populated Prescription Number"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(239)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////"_$S(DA(1)=237!(DA(1)=238):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
ECODES ;
 K DIC,X
 F ABMI=1:1 S ABMLN=$P($T(ECODETXT+ABMI),";;",2) Q:ABMLN="END"  D
 .S ABMCODE=$P(ABMLN,U)
 .I $D(^ABMDCODE("AC",$P(ABMLN,U,2),ABMCODE)) D  Q
 ..S DA=$O(^ABMDCODE("AC",$P(ABMLN,U,2),ABMCODE,0))
 ..S $P(^ABMDCODE(DA,0),U,2)=$P(ABMLN,U,2),$P(^(0),U,3)=$P(ABMLN,U,3)
 .S ABMDESC=$P(ABMLN,U,3)
 .S DIC="^ABMDCODE("
 .S DIC(0)="ML"
 .S X=ABMCODE
 .S DIC("DR")=".02///"_$P(ABMLN,U,2)
 .S DIC("DR")=DIC("DR")_";.03///"_ABMDESC
 .K DD,DO
 .D FILE^DICN
 ;
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="05"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///INDIAN HEALTH SERVICE FREE-STANDING FACILITY"
 K DD,DO
 D FILE^DICN
 ;
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="06"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///INDIAN HEALTH SERVICE PROVIDER-BASED FACILITY"
 K DD,DO
 D FILE^DICN
 Q
ECODETXT ;
 ;;09^I^Second Opinion or Surgery
 ;;15^U^NATURAL DISASTER
 ;;10^U^ADMINISTRATION DELAY IN THE PRIOR APPROVAL PROCESS
 ;;11^U^OTHER
 ;;01^U^PROOF OF ELIGIBILITY UNKNOWN OR UNAVALABLE
 ;;02^U^LITIGATION
 ;;03^U^AUTHORIZATION DELAYS
 ;;04^U^DELAY IN CERTIFYING PROVIDER
 ;;05^U^DELAY IN SUPPLYING BILLING FORM
 ;;06^U^DELAY IN DELIVERY OF CUSTOM-MADE APPLIANCES
 ;;07^U^THIRD PARTY PROCESSING DELAY
 ;;08^U^DELAY IN ELIGIBILITY DETERMINATION
 ;;09^U^ORIGINAL CLAIM REJECTED DENIED UNRELATED TO LIMITATION RULES
 ;;03^W^Report Justifying Treatment Beyond Utilization Guidelines
 ;;04^W^Drugs Administered
 ;;05^W^Treatment Diagnosis
 ;;06^W^Initial Assessment
 ;;07^W^Functional Goals
 ;;08^W^Plan of Treatment
 ;;09^W^Progress Report
 ;;10^W^Continued Treatment
 ;;11^W^Chemical Analysis
 ;;13^W^Certified Test Report
 ;;15^W^Justification for Admission
 ;;21^W^Recovery Plan
 ;;A3^W^Allergies/Sensitivities Document
 ;;A4^W^Autopsy Report
 ;;AM^W^Ambulance Certification
 ;;BR^W^Benchmark Testing Results
 ;;BS^W^Baseline
 ;;BT^W^Blanket Test Results
 ;;CB^W^Chiropractic Justification
 ;;CK^W^Consent Form(s)
 ;;D2^W^Drug Profile Document
 ;;DB^W^Durable Medical Equipment Prescription
 ;;DJ^W^Discharge Monitoring Report
 ;;HC^W^Health Certificate
 ;;HR^W^Health Clinic Records
 ;;I5^W^Immunization Record
 ;;IR^W^State School Immunization Records
 ;;LA^W^Laboratory Results
 ;;M1^W^Medical Record Attachment
 ;;OC^W^Oxygen Content Averaging Report
 ;;OD^W^Orders and Treatments Document
 ;;OE^W^Objective Physical Examination (including vital signs) Document
 ;;OX^W^Oxygen Therapy Certification
 ;;P4^W^Pathology Report
 ;;P5^W^Patient Medical History Document
 ;;PE^W^Parenteral or Enteral Certification
 ;;PQ^W^Paramedical Results
 ;;PY^W^Physician's Report
 ;;RX^W^Renewable Oxygen Content Averaging Report
 ;;SG^W^Symptoms Document
 ;;V5^W^Death Notification
 ;;XP^W^Photographs
 ;;END
QUES ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=36,X="HEARING/VISION RX DATE"
 S DIC("DR")=".02////W36;.03////ABMDE301;.04////36;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=37,X="Start/End Disability Dates"
 S DIC("DR")=".02////W37;.03////ABMDE301;.04////37;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=38,X="Assumed/Relinquished Care Date"
 S DIC("DR")=".02////W38;.03////ABMDE301;.04////38;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=39,X="Prop/Casualty Date 1st Contact"
 S DIC("DR")=".02////W39;.03////ABMDE301;.04////39;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=40,X="Patient Paid Amount"
 S DIC("DR")=".02////W40;.03////ABMDE301;.04////40;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=41,X="Spinal Manipulation Cond Code"
 S DIC("DR")=".02////W41;.03////ABMDE301;.04////41;1////ABMDE3C"
 K DD,DO
 D ^DIC
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMQUES("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S DINUM=42,X="Vision Condition Info"
 S DIC("DR")=".02////W42;.03////ABMDE301;.04////42;1////ABMDE3C"
 K DD,DO
 D ^DIC
CASHCK ;
 ;
 D BMES^XPDUTL("Checking UFMS Cashiering Sessions for .01 field....")
 S ABMLOC=0
 S ABMBFLG=0
 F  S ABMLOC=$O(^ABMUCASH(ABMLOC)) Q:'ABMLOC  D
 .S ABMUSER=0
 .F  S ABMUSER=$O(^ABMUCASH(ABMLOC,10,ABMUSER)) Q:'ABMUSER  D
 ..S ABMSESS=0
 ..F  S ABMSESS=$O(^ABMUCASH(ABMLOC,10,ABMUSER,20,ABMSESS)) Q:'ABMSESS  D
 ...I $P($G(^ABMUCASH(ABMLOC,10,ABMUSER,20,ABMSESS,0)),U)="" D
 ....S ABMBFLG=1
 ....S ABMAFLG=$$ACTIVCK^ABMUUTL(ABMLOC,ABMSESS,ABMUSER)
 ....D BMES^XPDUTL(ABMLOC_"  "_ABMUSER_"  "_ABMSESS_$S(ABMAFLG=1:" *",1:""))
 .S ABMUSER=0
 .F  S ABMUSER=$O(^ABMUCASH(ABMLOC,20,ABMUSER)) Q:'ABMUSER  D
 ..S ABMSESS=0
 ..F  S ABMSESS=$O(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSESS)) Q:'ABMSESS  D
 ...I $P($G(^ABMUCASH(ABMLOC,20,ABMUSER,20,ABMSESS,0)),U)="" D
 ....S ABMBFLG=1
 ....S ABMAFLG=$$ACTIVCK^ABMUUTL(ABMLOC,ABMSESS,ABMUSER)
 ....D BMES^XPDUTL(ABMLOC_"  "_ABMUSER_"  "_ABMSESS_$S(ABMAFLG=1:" *",1:""))
 I ABMBFLG=1 D BMES^XPDUTL("Sessions found.  Please contact OIT with above list")
 I ABMBFLG=0 D BMES^XPDUTL("Sessions checked out ok.")
 Q
