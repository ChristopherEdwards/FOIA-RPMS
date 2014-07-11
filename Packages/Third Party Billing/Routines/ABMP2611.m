ABMP2611 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 11 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**11**;NOV 12, 2009;Build 133
 ;
 Q
POST ;
 D ICDEFFDT  ;re-populate ICD10 effective date with 10/1/14
 D ERRORCD  ;create new claim editor error codes
 D EXP34  ;add new export mode 34 ADA-2012
 D ECODES  ;add new 3P Codes entries
 D QUES28  ;add question 28 to export mode 27
 ;
 Q:(+$O(^ABMDCODE("AC","H","08",0))'=0)
 K DIC,X
 S DIC="^ABMDCODE("
 S DIC(0)="ML"
 S X="08"
 S DIC("DR")=".02///H"
 S DIC("DR")=DIC("DR")_";.03///TRIBAL 638 PROVIDER-BASED FACILITY"
 K DD,DO
 D FILE^DICN
 Q
ICDEFFDT ;
 D BMES^XPDUTL("Auto-populating ICD-10 EFFECTIVE DATE with 10/1/2014 for all insurers...")
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMNINS(DUZ(2))) Q:'DUZ(2)  D
 .S ABMDA=0
 .F  S ABMDA=$O(^ABMNINS(DUZ(2),ABMDA)) Q:'ABMDA  D
 ..S DIE="^ABMNINS("_DUZ(2)_","
 ..S DA=ABMDA
 ..S DR=".12////3141001"
 ..D ^DIE
 Q
ERRORCD ;
 ;HEAT81017
 ;244 - No providers on claim
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=244
 S X="No Providers on claim"
 S DIC("DR")=".02///Add some type of provider"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(244)
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
 .S DIC("DR")=".03////"_$S(ABMX=243:"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
EXP34 ;
 K DIC,DR,DINUM,DLAYGO,DIE
 S DIC="^ABMDEXP("
 S DIC(0)="LM"
 S DLAYGO=9002274
 S X="ADA-2012",DINUM=34
 K DD,DO
 D ^DIC
 Q:Y<0
 S DA=+Y
 S DIE="^ABMDEXP("
 S DR=".04////ABMDF34;.05////ABMDF34X;.06///C;.07///ADA Claim Form dated 2012;.08///1,2,3,4,9,32,33;.11////ABMDES4;.15///H"
 D ^DIE
 Q
QUES28 ;EP
 S ABMQUES=$P($G(^ABMDEXP(27,0)),U,8)
 S DIE="^ABMDEXP("
 S DA=27
 S DR=".08////"_ABMQUES_",28"
 D ^DIE
 Q
ECODES ;
 K DIC,X
 F ABMI=1:1 S ABMLN=$P($T(ECODETXT+ABMI),";;",2) Q:ABMLN="END"  D
 .S ABMCODE=$P(ABMLN,U)
 .I $D(^ABMDCODE("AC",$P(ABMLN,U,2),ABMCODE)) D  Q
 ..S DA=$O(^ABMDCODE("AC",$P(ABMLN,U,2),ABMCODE,0))
 ..S $P(^ABMDCODE(DA,0),U,2)=$P(ABMLN,U,2),$P(^(0),U,3)=$P(ABMLN,U,3),$P(^(0),U,4)=$P(ABMLN,U,4)
 .S ABMDESC=$P(ABMLN,U,3)
 .S ABMINAC=$P(ABMLN,U,4)
 .S DIC="^ABMDCODE("
 .S DIC(0)="ML"
 .S X=ABMCODE
 .S DIC("DR")=".02///"_$P(ABMLN,U,2)
 .S DIC("DR")=DIC("DR")_";.03///"_ABMDESC
 .S DIC("DR")=DIC("DR")_";.04///"_ABMINAC
 .K DD,DO
 .D FILE^DICN
VALUE23 ;
 ;now check for duplicate entries for value code 23
 S ABM=0
 F ABMI=0:1 S ABM=$O(^ABMDCODE("AC","V",23,ABM))  Q:'ABM
 I ABMI<2 Q
 S DA=9999
 S ABMI=ABMI-1
 F ABM=1:1:ABMI D
 .S DIE="^ABMDCODE("
 .S DA=$O(^ABMDCODE("AC","V",23,DA),-1)
 .S DR=".04////1"
 .D ^DIE
 ;
 Q
ECODETXT ;
 ;;03^H^SCHOOL
 ;;05^N^BORN INSIDE THIS HOSPITAL
 ;;06^N^BORN OUTSIDE THIS HOSPITAL
 ;;5^T^TRAUMA
 ;;01^N^NORMAL BIRTH^1
 ;;02^N^PREMARTURE BIRTH^1
 ;;03^N^SICK BABY^1
 ;;04^N^EXTRAMURAL BIRTH^1
 ;;1^A^NON-HEALTH CARE FACILITY POINT OF ORIGIN
 ;;2^A^CLINIC OR PHYSICIAN'S OFFICE
 ;;3^A^HMO REFERRAL^1	
 ;;5^A^TRANSFER FROM SKILLED NURSING/INTERMEDIATE CARE/ASSISTING LIVING FAC
 ;;7^A^EMERGENCY ROOM^1
 ;;9^A^INFORMATION NOT AVAILABLE
 ;;A^A^Transfer from a Critical Access Hospital
 ;;B^A^Transfer from Another Home Health Agency
 ;;D^A^TRANSFER FROM ONE UNIT TO ANOTHER, SAME HOSP, SEPARATE CLAIM TO PAYER
 ;;E^A^TRANSFER FROM AMBULATORY SURGERY CENTER
 ;;F^A^TRANSFER FROM HOSPICE FACILITY
 ;;10^P^DISCHARGED TO MENTAL HEALTH FACILITY
 ;;30^P^Still Patient
 ;;43^P^Discharged/transferred to a Federal Health Care Facility
 ;;51^P^Hospice - Medical Facility (Certified) Providing Hospice Level of Care
 ;;61^P^Discharged/transferred to a Hospital-Based Medicare Approved Swing Bed
 ;;62^P^Discharged/transf to IRF incl Rehab Distinct Part Units of a Hospital
 ;;63^P^Discharged/transf to a Medicare Certified Long Term Care Hosp (LTCH)
 ;;64^P^Discharged/transf to a Nursing Fac Cert under Medicaid, not Medicare
 ;;65^P^Discharged/transf to a Psych Hosp or Psych Distinct Part Unit of Hosp
 ;;66^P^Discharged/transf to a Critical Access Hospital (CAH)
 ;;70^P^Discharged/transf to another Type of Health Care Inst not Defined
 ;;72^P^Discharged/Transferred/Referred to this Facility for Outpatient Svcs^1
 ;;01^P^Discharged to Home or Self Care (Routine Discharge)
 ;;02^P^Discharged/transferred to a Short-Term General Hospital for Inpt Care
 ;;03^P^Dischrgd/trans to SNF with Medicare Cert, Anticipation of Skilled Care
 ;;04^P^Discharged/transf to Facility that Provides Custodial/Supportive Care
 ;;05^P^Discharged/transf to a Designated Cancer Center or Children's Hospital
 ;;06^P^Discharged/transf to Home Under Care of an Org Home Hlth Svc Org
 ;;07^P^Left Against medical Advice or Discontinued Care
 ;;08^P^Discharged/Transferred to home under care of Home IV Provider^1
 ;;04^C^Information Only Bill
 ;;06^C^ESRD Patient in 1st 30 Months of Entitlement Cov by Employer Grp Ins
 ;;08^C^Beneficiary wouldn't Provide Information Concerning Other Ins Coverage
 ;;10^C^Patient/Spouse is Employed but NO Employee Group Health Plan Exists
 ;;11^C^Disabled Beneficiary but NO LGHP
 ;;30^C^Qualifying Clinical Trials
 ;;37^C^Ward Accommodation - Patient Request
 ;;44^C^Inpatient Admission Changed to Outpatient
 ;;45^C^Ambiguous Gender Category
 ;;48^C^Psychiatric Residential Tx Centers for Children & Adolescents (RTC)
 ;;47^C^Transfer from another Home Health Agency
 ;;49^C^Product Replacement within Product Lifecycle
 ;;50^C^Product Replacement for Known Recall of Product
 ;;51^C^Attestation of Unrelated Outpatient Nondiagnostic services
 ;;52^C^Out of Hospice Service Area
 ;;55^C^SNF Bed Not Available^1
 ;;58^C^Terminated Medicare Advantage Enrollee
 ;;59^C^Non-primary ESRD Facility
 ;;78^C^New Coverage not Implemented by Managed Care Plan
 ;;80^C^Home Dialysis - Nursing Facility
 ;;A7^C^INDUCED ABORTION DANGER TO LIFE^1
 ;;A8^C^INDUCED ABORTION VICTIM RAPE/INCEST^1
 ;;AA^C^Abortion Performed due to Rape
 ;;AB^C^Abortion Performed due to Incest
 ;;AC^C^Abortion Performed-Serious Fetal Genetic Defect/Deformity/Abnormality
 ;;AD^C^Abortion Performed due to Life Endangering Physical Condition
 ;;AE^C^Abortion Performed-Physical Health of Mother not Life Endangering
 ;;AF^C^Abortion Performed-Emotional/psychological Health of the Mother
 ;;AG^C^Abortion Performed due to Social or Economic Reasons
 ;;AH^C^Elective Abortion
 ;;AI^C^Sterilization
 ;;AJ^C^Payer Responsible for Co-Payment
 ;;AK^C^Air Ambulance Required
 ;;AL^C^Specialized Treatment/bed Unavailable - Alternate Facility Transport
 ;;AM^C^Non-emergency Medically Necessary Stretcher Transport Required
 ;;AN^C^Preadmission Screening not Required
 ;;B0^C^Medicare Coordinated Care Demonstration Claim
 ;;B1^C^Beneficiary is Ineligible for Demonstration Program
 ;;B2^C^Critical Access Hospital Ambulance Attestation
 ;;B3^C^Pregnancy Indicator
 ;;B4^C^Admission Unrelated to Discharge on Same Day
 ;;BP^C^Gulf Oil Spill of 2010
 ;;D4^C^CHANGE IN CLINICAL CODES (ICD) FOR DIAGNOSIS AND/OR PROCEDURE
 ;;DR^C^Disaster Related
 ;;H0^C^Delayed Filing-Statement of Intent Submitted
 ;;H2^C^Discharge by a Hospice Provider for Cause
 ;;H3^C^Reoccurrence of GI Bleed Comorbid Category
 ;;H4^C^Reoccurrence of Pneumonia Comorbid Category
 ;;H5^C^Reoccurrence of Pericarditis Comorbid Category
 ;;P1^C^Do Not Resuscitate Order (DNR)
 ;;P7^C^Direct Inpatient Admission from Emergency Room
 ;;W0^C^United Mine Workers of America (UMWA) Demonstration Indicator
 ;;W2^C^Duplicate of Original Bill
 ;;W3^C^Level I Appeal
 ;;W4^C^Level II Appeal
 ;;W5^C^Level III Appeal
 ;;01^O^Accident/Medical Coverage
 ;;04^O^ACCIDENT/EMPLOYMENT RELATED
 ;;05^O^Accident/No Medical or Liability Coverage
 ;;16^O^Date of Last Therapy
 ;;31^O^Date Beneficiary Notified Of Intent To Bill Accommodations
 ;;38^O^Date Treatment Started for Home IV Therapy
 ;;39^O^Date Discharged on a Continuous Course of IV Therapy
 ;;50^O^Assessment Date
 ;;51^O^Date of Last Kt/V Reading
 ;;52^O^Medical Certification/recertification Date
 ;;54^O^Physician Follow-Up date
 ;;55^O^Date of Death
 ;;A4^O^Split Bill Date
 ;;E1^O^Birthdate-Insured D^1
 ;;E2^O^Effective Date-Insured D Policy^1
 ;;E3^O^Benefits Exhausted^1
 ;;F1^O^Birthdate - Insured E^1
 ;;F2^O^Effective Date - Insured E Policy^1
 ;;F3^O^Benefits Exhausted^1
 ;;G1^O^Birthdate - Insured F^1
 ;;G2^O^Effective Date - Insured F Policy^1
 ;;G3^O^Benefits Exhausted^1
 ;;79^S^Payer Code
 ;;80^S^Prior Same-SNF Stay Date for Payment Ban Purposes
 ;;81^S^Antepartum Days at Reduced Level of Care
 ;;M3^S^ICF Level of Care
 ;;M4^S^Residential Level of Care
 ;;04^V^Professional Component Charges which are Combined Billed
 ;;07^V^MEDICARE PART A CASH DEDUCTIBLE^1
 ;;21^V^CATASTROPHIC
 ;;25^V^Offset to the Patient-Payment Amount - Prescription Drugs
 ;;26^V^Offset to the Patient-Payment Amount - Hearing and Ear Services
 ;;27^V^Offset to the Patient-Payment Amount - Vision and Eye Services
 ;;28^V^Offset to the Patient-Payment Amount - Dental Services
 ;;29^V^Offset to the Patient-Payment Amount - Chiropractic Services
 ;;33^V^Offset to the Patient-Payment Amount - Podiatric Services
 ;;34^V^Offset to the Patient-Payment Amount - Other Medical Service
 ;;35^V^Offset to the Patient-Payment Amount - Health Insurance Premiums
 ;;37^V^Units of Blood Furnished
 ;;39^V^Units of Blood Replaced
 ;;44^V^Amt Prov Agreed to Accept fr 1st Payer, Amt < Chrgs Higher than Pymnt
 ;;54^V^Newborn Birth Weight in Grams
 ;;55^V^Eligibility Threshold for Charity Care
 ;;59^V^Oxygen Saturation 
 ;;66^V^Medicaid Spend Down Amount
 ;;69^V^State Charity Care Percent
 ;;73^V^Drug Deductible^1
 ;;74^V^Drug Coinsurance^1
 ;;81^V^NON-COVERED DAYS
 ;;510^V^OUTPATIENT FACILITY CHARGE^1
 ;;636^V^JCODES^1
 ;;A0^V^Special ZIP Code Reporting
 ;;A7^V^Co-payment Payer A
 ;;A8^V^Patient Weight
 ;;A9^V^Patient Height
 ;;AA^V^Regulatory Surcharges/Assessments/Allow/Hlth Cre Related Taxes Payer A
 ;;AB^V^Other Assessments or Allowance (e.g., Medical Education) Payer A
 ;;B7^V^Co-Payment Payer B
 ;;BA^V^Regulatory Surcharges/Assessments/Allow/Hlth Cre Related Taxes Payer B
 ;;BB^V^Other Assessments or Allowance (e.g., Medical Education) Payer B
 ;;C7^V^Co-Payment Payer C
 ;;CA^V^Regulatory Surcharges/Assessments/Allow/Hlth Cre Related Taxes Payer C
 ;;CB^V^Other Assessments or Allowance (e.g., Medical Education) Payer C
 ;;D4^V^Clinical Trial Number Assigned by NLM/NIH
 ;;D5^V^Last Kt/V Reading
 ;;E1^V^Deductible Payer D^1
 ;;E2^V^Coinsurance Payer D^1
 ;;E3^V^Estimated Responsibility Payer D^1
 ;;F1^V^Deductible Payer E^1
 ;;F2^V^Coinsurance Payer E^1
 ;;F3^V^Estimated Responsibility Payer E^1
 ;;FC^V^Patient Paid Amount
 ;;FD^V^Credit Received from the Manufacturer for a Replaced Medical Device
 ;;G1^V^Deductible Payer F^1
 ;;G2^V^Coinsurance Payer F^1
 ;;G3^V^Estimated Responsibility Payer F^1
 ;;G8^V^Facility where Inpatient Hospice Service is Delivered
 ;;Y1^V^Part A Demonstration Payment
 ;;Y2^V^Part B Demonstration Payment
 ;;Y3^V^Part B Coinsurance
 ;;Y4^V^Conventional Provider Payment Amount for Non-Demonstration Claims
 ;;END
