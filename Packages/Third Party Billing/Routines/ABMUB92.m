ABMUB92 ;IHS/ASDST/LSL - Update UB92 codes   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 05/22/00 - V2.4 Patch 1 - NOIS XAA-0500-200043
 ;     Created routine to update 3P CODE file with new UB codes.
 ;     Cannot send a new global (3P CODES) because site may have
 ;     already added codes.  The IEN's will not match.
 ;
 Q
START ;
 ; A = ADMISSION SOURCE
 ; B = BILL TYPE
 ; C = CONDITION
 ; D = DENIAL REASON
 ; H = HCFA POS
 ; I = SPECIAL PROGRAM
 ; N = NEWBORN
 ; O = OCCURANCE
 ; P = PATIENT DISCHARGE STATUS
 ; R = RELATIONSHIP TO INSURED
 ; S = OCCURANCE SPAN
 ; T = ADMISSION TYPE
 ; V = VALUE
 ; X = PSRO APRROVAL
 ;
 F ABM="A","B","C","D","H","I","N","O","P","R","S","T","V","X" D DETAIL
 K ABMCODE,DA,DR,DIK,DIE,ABM,DIC,ABMC,ABMCNT,X,DD,DO,ABMDESC
 Q
 ;
DETAIL ;
 ; If code is one digit numeric, place 0 before code
 S ABMCODE=0
 F  S ABMCODE=$O(^ABMDCODE("AC",ABM,ABMCODE)) Q:$L(ABMCODE)>1!(ABMCODE="")  D
 . Q:+ABMCODE<1                     ; Not numeric
 . S ABMDA=0
 . F  S ABMDA=$O(^ABMDCODE("AC",ABM,ABMCODE,ABMDA)) Q:'+ABMDA  D
 . . S ABMC="0"_ABMCODE
 . . S DA=ABMDA
 . . S DIE="^ABMDCODE("
 . . S DR=".01///"_ABMC
 . . D ^DIE
 . . S DA=ABMDA
 . . S DIK="^ABMDCODE("
 . . S DIK(1)=".02^AC"
 . . D EN1^DIK                      ; Set additional AC X-ref
 ;
 ; Add new codes to file
 S DIC="^ABMDCODE("
 S DIC(0)="L"
 S ABMCNT=0
 F  D  Q:$P($T(@ABM+ABMCNT),";;",2)="END"
 . S ABMCNT=ABMCNT+1
 . Q:$P($T(@ABM+ABMCNT),";;",2)="END"
 . S X=$P($T(@ABM+ABMCNT),";;",2)
 . S ABMDESC=$P($T(@ABM+ABMCNT),";;",3)
 . Q:$D(^ABMDCODE("AC",ABM,X))=10
 . S DIC("DR")=".02////"_ABM_";.03////"_$E(ABMDESC,1,70)
 . K DD,DO
 . D FILE^DICN
 K DIC
 Q
 ;
FIX ;
 ; Get x-ref on single digit numeric back
 F ABM="A","B","C","D","H","I","N","O","P","R","S","T","V","X" D
 . S ABMCODE=0
 . F  S ABMCODE=$O(^ABMDCODE("AC",ABM,ABMCODE)) Q:ABMCODE=""  D
 . . Q:$E(ABMCODE)'=0
 . . S ABMDA=0
 . . F  S ABMDA=$O(^ABMDCODE("AC",ABM,ABMCODE,ABMDA)) Q:'+ABMDA  D
 . . . S ^ABMDCODE("AC",ABM,+ABMCODE,ABMDA)=""
 Q
 ;
A ; Admission Source Codes
 ;;A;;Transfer from a Critical Assess Hospital
 ;;B;;Transfer from Another Home Health Agency
 ;;END
 ;
B ; Bill Type
 ;;END
 ;
C ; Condition codes
 ;;09;;Neither Patient Nor Spouse Is Employed
 ;;10;;Patient/Spouse is Employed by NO Employee Group Health Plan Exists
 ;;11;;Disables Beneficiary but NO LGHP
 ;;17;;Patient is Homeless
 ;;19;;Child Retains Mother's Name
 ;;20;;Beneficiary Requested Billing
 ;;21;;Billing for Denial Notice
 ;;22;;Patient on Multiple Drug Regimen
 ;;23;;Home Caregiver Available
 ;;24;;Home IV Patient Also Receiving HHA Services
 ;;25;;Patient is Non-US Resident
 ;;26;;VA Eligible Patient Chooses to Rec Svcs in a Medicare Certified Fac
 ;;27;;Patient Ref to a Sole Community Hospital for a Diagnostic Lab Test
 ;;28;;Patient and/or Spouse's EGHP is Secondary to Medicare
 ;;29;;Disabled Beneficiary and/or Family Member's LGHP is 2nd to Medicare
 ;;37;;Ward Accomodation - Patient Request
 ;;38;;Semi-Private Room Not Available
 ;;39;;Private Room Medically Necessity
 ;;41;;Partial Hospitalization
 ;;42;;Continuing Care Not Related to Inpatient Admission
 ;;43;;Continuing Care Not Provided Within Prescribed Post-Discharge Window
 ;;46;;Non-Availability Statement on File
 ;;48;;Psychiatirc Residential Tx Centers for Children & Adolescents (RTC)
 ;;55;;SNF Bed Not Available
 ;;56;;Medical Appropriateness
 ;;57;;SNF Readmission
 ;;60;;Day Outlier
 ;;61;;Cost Outlier
 ;;66;;Provider Does not Wish Cost Outlier Payment
 ;;67;;Beneficiary Elects not to use Life Time Reserve (LTR) Days
 ;;68;;Beneficiary Elects to use Life Time Reserve (LTR) Days
 ;;69;;IME Payment Only Bill
 ;;70;;Self-Administered EPO
 ;;71;;Full Care in Unit
 ;;72;;Self-Care in Unit
 ;;73;;Self-Care Training
 ;;74;;Home
 ;;75;;Home - 100% Reimbursement
 ;;76;;Back-up in Facility Dialysis
 ;;77;;Provider Accepts Payment by a Primary Payer as Payment in Full
 ;;78;;New Coverage Not Implemented by HMO
 ;;79;;CORF Services Provided Offsite
 ;;END
 ;
D ; Denial Reasons
 ;;END
 ;
H ; HCFA POS
 ;;END
 ;
I ; Special Program
 ;;END
 ;         
N ; Newborn
 ;;END
 ;
O ; Occurance Codes
 ;;09;;Start of Infertility Treatment Cycle
 ;;12;;Date of Onset Dependent Individual
 ;;17;;Date Outpatient Occupational Therapy Plan Established/Last Reviewed
 ;;27;;Date Home Health Plan Established or Last Reviewed
 ;;28;;Date Comprehensive Outpatient Rehab Plan Established/Last Reviewed
 ;;29;;Date Outpatient Physical Therapy Plan Established/Last Reviewed
 ;;30;;Date Outpatient Plan Established or Last Reviewed
 ;;31;;Date Beneficiary Notified of Intent to Bill Accomodations
 ;;32;;Date Beneficiary Notified of Intent to Bill Procedures or Treatments
 ;;33;;1st Date of Medicare Coordination period for ESRD Ben Covered by EGHP
 ;;34;;Date of Election of Extended Care Facilities
 ;;35;;Date Treatment started for PT
 ;;36;;Date of Inpatient Hospital Discharge for Covered Transplant Patients
 ;;37;;Date of Inpt Hospital Discharge for Non-Covered Transplant Patient
 ;;43;;Scheduled Date of Cancelled Surgery
 ;;44;;Date Treatment started for OT
 ;;45;;Date Treatment started for ST
 ;;46;;Date Treatment started for Cardiac Rehab
 ;;47;;Date Cost Outlier Status Begins
 ;;A1;;Birthdate - Insured A
 ;;A2;;Effective Date - Insured A Policy
 ;;A3;;Benefits Exhausted
 ;;B1;;Birthdate - Insured B
 ;;B2;;Effective Date - Insured B Policy
 ;;B3;;Benefits Exhausted
 ;;C1;;Birthdate - Insured C
 ;;C2;;Effective Date - Insured C Policy
 ;;C3;;Benefits Exhausted
 ;;E1;;Birthdate - Insured D
 ;;E2;;Effective Date - Insured D Policy
 ;;E3;;Benefits Exhausted
 ;;F1;;Birthdate - Insured E
 ;;F2;;Effective Date - Insured E Policy
 ;;F3;;Benefits Exhausted
 ;;G1;;Birthdate - Insured F
 ;;G2;;Effective Date - Insured F Policy
 ;;G3;;Benefits Exhausted
 ;;END
 ;
P ; Patient Discharge Status
 ;;08;;Discharged/Transferred to home under care of Home IV Provider
 ;;09;;Admitted as an inpatient to this hospital
 ;;40;;Expired at home
 ;;41;;Expired in a medical facility
 ;;42;;Expired - Place Unknown
 ;;50;;Hospice - Home
 ;;51;;Hospice - Medical Facility
 ;;61;;Discharged/Transferred to Swing Bed (In house)
 ;;71;;Discharged/Transferred to another facility for Outpatient Services
 ;;72;;Discharged/Transferred/Referred to this Facility for Outpatient Svcs
 ;;END
 ;
R ; Relationship to Insured
 ;;END
 ;
S ; Occurance Span codes
 ;;77;;Provider Liability Period
 ;;78;;SNF Prior Stay Dates
 ;;M0;;PRO/UR Approved Stay Dates
 ;;M1;;Provider Liability - No Utilization
 ;;M2;;Inpatient Respite Dates
 ;;END
 ;
T ; Admission Type
 ;;END
 ;
V ; Value codes
 ;;37;;Pints of Blood Furnished
 ;;38;;Blood Deductible
 ;;39;;Pints of Blood Replaced
 ;;41;;Black Lung
 ;;42;;VA
 ;;43;;Disabled Beneficiary Under Age 65 with LGHP
 ;;45;;Accident Hour
 ;;46;;Number of Grace Days
 ;;47;;Any Liability
 ;;48;;Hemoglobin Reading
 ;;49;;Hematocrit Reading
 ;;50;;Physical Therapy Visit
 ;;51;;Occupational Therapy Visit
 ;;52;;Speech Therapy Visit
 ;;53;;Cardiac Rehab Visits
 ;;56;;Skilled Nurse - Home Visit Hours (HHA only)
 ;;57;;Home Health Aide - Home Visit Hours (HHA only)
 ;;58;;Arterial Blood Gas (PO2/PA2)
 ;;59;;Oxygen Saturaton
 ;;60;;HHA Branch
 ;;61;;Location Where Service is Furnished (HHA and Hospice)
 ;;67;;Peritoneal Dialysis
 ;;68;;EPO-Drug
 ;;73;;Drug Deductible
 ;;74;;Drug Coinsurance
 ;;A1;;Deductible Payer A
 ;;A2;;Coinsurance Payer A
 ;;A3;;Estimated Responsibility Payer A
 ;;A4;;Covered Self-Administrable Drugs - Emergency
 ;;A5;;Covered Self-Administrable Drugs - Not Self-Administrable
 ;;A6;;Covered Self-Administrable Drugs - Diagnostic Study and Other
 ;;B1;;Deductible Payer B
 ;;B2;;Coinsurance Payer B
 ;;B3;;Estimated Responsibility Payer B
 ;;C1;;Deductible Payer C
 ;;C2;;Coinsurance Payer C
 ;;C3;;Estimated Responsibility Payer C
 ;;D3;;Patient Estimated Responsibility
 ;;E1;;Deductible Payer D
 ;;E2;;Coinsurance Payer D
 ;;E3;;Estimated Responsibility Payer D
 ;;F1;;Deductible Payer E
 ;;F2;;Coinsurance Payer E
 ;;F3;;Estimated Responsibility Payer E
 ;;G1;;Deductible Payer F
 ;;G2;;Coinsurance Payer F
 ;;G3;;Estimated Responsibility Payer F
 ;;END
 ;
X ; PSRO Approval
 ;;C1;;Approved as Billed
 ;;C2;;Automatic Approval as Billed Based on Focused Review
 ;;C3;;Partial Approval
 ;;C4;;Admission/Services Denied
 ;;C5;;Post Payment Review Applicable
 ;;C6;;Admission Preauthorization
 ;;C7;;Extended Authorization
 ;;END
