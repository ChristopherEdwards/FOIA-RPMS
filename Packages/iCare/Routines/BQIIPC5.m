BQIIPC5 ;GDIT/HS/ALA-IPC5 Measures ; 14 Oct 2014  9:54 AM
 ;;2.4;ICARE MANAGEMENT SYSTEM;;Apr 01, 2015;Build 41
 ;
 ;
IPC ; Set IPC4
 I $G(^BQI(90508,1,"GPRA"))'=2015 Q
 NEW TEXT,BQIUPD,ERROR,BI,BJ,HELP,IEN,X
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL
 S ^BQI(90508,1,22,2,0)="IPC4",^BQI(90508,1,22,2,"B","IPC4",1)=""
 S $P(^BQI(90508,1,11),"^",1)="IPC4"
 I '$D(^BQI(90508,1,22)) D
 . S ^BQI(90508,1,22,0)="^90508.022^2^2"
 . S ^BQI(90508,1,22,2,0)="IPC4",^BQI(90508,1,22,2,"B","IPC4",1)=""
 . S $P(^BQI(90508,1,22,2,5),U,1)="http://ipcreporting.improvingindianhealth.org/FilesDownload.aspx"
 . S $P(^BQI(90508,1,22,2,5),U,2)="http://ipcreporting.improvingindianhealth.org/FilesUpload.aspx"
 . S $P(^BQI(90508,1,22,2,4),U,1)="http://icare.spreadinnovation.com/FilesDownload.aspx"
 . S $P(^BQI(90508,1,22,2,4),U,2)="http://icare.spreadinnovation.com/FilesUpload.aspx"
 . S ^BQI(90508,1,22,2,1,0)="^90508.221I^60^60"
 ;
 F BI=1:1 S TEXT=$T(ARR+BI) Q:TEXT=" Q"  D
 . S TEXT=$P(TEXT,";;",2) I TEXT="" Q
 . S NDATA=$P(TEXT,"~",1)
 . S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 . I ND'=0 Q
 . I VAL="" Q
 . S CODE=$P(VAL,"^",1)
 . ;I $P(^BQI(90508,1,22,2,1,BI,ND),"^",1)=CODE Q
 . D UPD
 ;
 ;Check bundles
 F BI=1:1 S TEXT=$T(BUN+BI) Q:TEXT=" Q"  D
 . K ^BQI(90508,1,22,2,1,BI,2)
 . S TEXT=$P(TEXT,";;",2) I TEXT="" Q
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ) I NDATA="" Q
 .. S ^BQI(90508,1,22,2,1,BI,2,BJ,0)=NDATA
 . S ^BQI(90508,1,22,2,1,BI,2,0)="^90508.2212^"_BJ_"^"_BJ
 ;
 NEW DIK,DA
 S DIK="^BQI(90508,",DA=1
 D IXALL^DIK
 Q
 ;
UPD ; Update values
 NEW BJ,NDATA,VAL,OCODE,FC,PRV,IIEN
 S OCODE=$P(^BQI(90508,1,22,2,1,BI,ND),"^",1)
 ; Update providers and facility
 S FC=0
 F  S FC=$O(^BQIFAC(FC)) Q:'FC  D
 . S IIEN=$O(^BQIFAC(FC,30,"B",OCODE,"")) I IIEN="" Q
 . NEW DA,IENS
 . S DA(1)=FC,DA=IIEN,IENS=$$IENS^DILF(.DA)
 . S BQUP(90505.63,IENS,.01)=CODE
 ;
 S PRV=0
 F  S PRV=$O(^BQIPROV(PRV)) Q:'PRV  D
 . S IIEN=$O(^BQIPROV(PRV,30,"B",OCODE,"")) I IIEN="" Q
 . NEW DA,IENS
 . S DA(1)=PRV,DA=IIEN,IENS=$$IENS^DILF(.DA)
 . S BQUP(90505.43,IENS,.01)=CODE
 I $D(BQUP) D FILE^DIE("","BQUP","ERROR")
 ;
 F BJ=1:1:$L(TEXT,"~") D
 . S NDATA=$P(TEXT,"~",BJ)
 . S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 . I VAL="" Q
 . S ^BQI(90508,1,22,2,1,BI,ND)=VAL
 ;
 S TEXT=$T(TIP+BI) D
 . S TEXT=$P(TEXT,";;",2) I TEXT="" Q
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ) I NDATA="" Q
 .. S ^BQI(90508,1,22,2,1,BI,3,BJ,0)=NDATA
 . S ^BQI(90508,1,22,2,1,BI,3,0)="^90508.2213^"_BJ_"^"_BJ
 ;
 Q
 ;
ARR ;  Measure definition
 ;;0|IPC_REVG^R^5^Revenue Generated Per Visit^^55^^Monthly_Data_Supplemental^L^K^18^^A~1|D EN^BQIIPRVG(BQDATE)
 ;;0|IPC_CCPR^R^2^Continuity of Care Primary Provider^^29^^Monthly_Data_Core^CU^CT^9^80%^A~1|D EN^BQIIPCCP(BQDATE)
 ;;0|IPC_PEMP^R^2^% of Pts Empanelled to a Primary Care Provider^^2^^Monthly_Data_Core^H^G^9^90%^A^F~1|D EN^BQIIPEMP(BQDATE)
 ;;0|IPC_CANC^R^2^Cancer Screening Bundle^B^18^^Monthly_Data_Core^AU^AT^1^70%~1|D EN^BQIIPBNL(CRN,MSN,BQDATE,CODE)
 ;;0|IPC_HRISK^R^2^Health Risk Screening Bundle^B^4^^Monthly_Data_Core^R^Q^3^80%~1|D EN^BQIIPBNL(CRN,MSN,BQDATE,CODE)
 ;;0|IPC_OUTC^R^2^Outcome Measures Bundle^B^22^^Monthly_Data_Core^BL^BK^4^70%~1|D EN^BQIIPOTC(BQDATE)
 ;;0|2015_2649^G^2^Pap Smear Rates 24-64^^20^^Monthly_Data_Core^BC^BB^1~1|
 ;;0|2015_1969^G^2^Mammogram Rates 52-64^^19^^Monthly_Data_Core^AY^AX^1~1|
 ;;0|2015_2027^G^2^Colorectal Cancer Screen 50-75^^21^^Monthly_Data_Core^BG^BF^1~1|
 ;;0|2015_60^G^2^DM: Comprehensive Care^^30^^Monthly_Data_Core^M^L^13^70%~1|
 ;;0|2015_127^G^5^DM: Dental Access^^57^^Monthly_Data_Supplemental^AF^AE^18^80%~1|
 ;;0|2015_1981^G^2^Topical Fluoride: 1-15^^53^^Monthly_Data_Supplemental^AJ^AI^14^50%~1|
 ;;0|2015_2092^G^5^Patients 5+:  Comprehensive Health Screening:  Physical Activity ^^56^^Monthly_Data_Supplemental^AA^Z^18^70%~1|
 ;;0|2015_2452^G^2^Self Mgmt Goal Set^^28^^Monthly_Data_Core^^CJ^7^70%~1|
 ;;0|IPC_DMCTRL^R^2^A1C in Control^B^23^^Monthly_Data_Core^BP^BO^4~1|D DM^BQIIPOTC(CRN,MSN,BQDATE,CODE,$G(DFN))
 ;;0|2015_1966^G^2^Alcohol Screen Females 15-44^^5^^Monthly_Data_Core^V^U^3~1|
 ;;0|2015_1965^G^2^DV/IPV Screen Females 15-40^^13^^Monthly_Data_Core^AL^AK^3~1|
 ;;0|2015_1964^G^2^Depression: Screening or Diagnosis 18+^^11^^Monthly_Data_Core^AH^AG^3~1|
 ;;0|2015_269^G^2^Tobacco Use/Exposure Assessment 5+^^15^^Monthly_Data_Core^AP^AO^3~1|
 ;;0|2015_530^G^2^BMI Assessed 2-74^^7^^Monthly_Data_Core^Z^Y^3~1|
 ;;0|2015_871^G^2^BP Assessed 18+^^9^^Monthly_Data_Core^AD^AC^3~1|
 ;;0|IPC_LDCTRL^R^2^LDL Assessed^B^25^^Monthly_Data_Core^BX^BW^4~1|D LD^BQIIPOTC(CRN,MSN,BQDATE,CODE,$G(DFN))
 ;;0|IPC_BPCTRL^R^2^BP in Control^B^24^^Monthly_Data_Core^BT^BS^4~1|D BP^BQIIPOTC(CRN,MSN,BQDATE,CODE,$G(DFN))
 ;;0|IPC_ERUR^R^5^ER/Urgent Care Visits^^54^^Monthly_Data_Supplemental^G^F^18^^A~1|D ERUR^BQIIPPRG(BQDATE)
 ;;0|2015_2450^G^2^Peds IZ 4:3:1:3:3:1:4 Active IMM^^52^^Monthly_Data_Supplemental^Q^P^14^90%~1|
 ;;0|2015_1878^G^2^Tobacco Cessation: Counseling, RX^^27^^Monthly_Data_Core^CF^CE^6^70%~1|
 ;;0|2015_270^G^2^Tobacco Use Prevalence 5+^^26^^Monthly_Data_Core^^CB^6~1|
 ;;0|IPC_TOTP^R^2^Total Patients in Microsystem^^1^^Monthly_Data_Core^C^^9^^A~1|D TOT^BQIIPPRG(BQDATE)
 ;;0|MU_5^M^2^Adult Weight Screening and Follow-Up (18-64)^^37^^Monthly_Data_Core^EC^EB^7^70%^A~1|
 ;;0|2015_55^G^2^Documented A1C^^31^^Monthly_Data_Core^^DI^13^~1|
 ;;0|2015_92^G^2^Documented BP^^32^^Monthly_Data_Core^^DL^13^~1|
 ;;0|2015_99^G^2^Documented LDL^^33^^Monthly_Data_Core^^DO^13^~1|
 ;;0|2015_110^G^2^Nephropathy Assessment^^34^^Monthly_Data_Core^^DR^13^~1|
 ;;0|2015_59^G^2^Retinal Screen^^35^^Monthly_Data_Core^^DU^13^~1|
 ;;0|2015_1275^G^2^Foot Exam^^36^^Monthly_Data_Core^^DX^13^~1|
 ;;0|2015_1956^G^2^HIV Screening for Pregnant Women^^41^^Monthly_Data_Core^EL^EK^14^80%~1|
 ;;0|2015_1510^G^2^Breastfeed Screen @ 2 mos.: exclusive/mostly^^43^^Monthly_Data_Core^EU^ET^14^80%~1|
 ;;0|2015_1511^G^2^Breastfeed Screen @ 6 mos.: exclusive/mostly^^44^^Monthly_Data_Core^EY^EX^14^80%~1|
 ;;0|2015_1318^G^2^Breastfeed Screening @ 2 mos.^^45^^Monthly_Data_Core^FC^FB^14^80%~1|
 ;;0|2015_1319^G^2^Breastfeed Screening @ 6 mos.^^46^^Monthly_Data_Core^FG^FF^14^80%~1|
 ;;0|2015_2072^G^5^CVD: Tobacco Use^^61^^Monthly_Data_Supplemental^^BA^17^~1|
 ;;0|MU_57^M^5^IVD: Use of Aspirin or other Antithrombotic^^66^^Monthly_Data_Supplemental^BR^BQ^16^80%^A~1|
 ;;0|MU_2^M^5^HTN: Controlling High Blood Pressure^^68^^Monthly_Data_Supplemental^BZ^BY^16^80%^A~1|
 ;;0|MU_55^M^5^IVD: Complete Lipid Panel^^69^^Monthly_Data_Supplemental^CH^CG^16^80%^A~1|
 ;;0|MU_56^M^5^IVD: LDL Control^^70^^Monthly_Data_Supplemental^CL^CK^16^80%^A~1|
 ;;0|MU_3^M^5^Preventive Care and Screening: Tobacco Use^^71^^Monthly_Data_Supplemental^CP^CO^16^80%^A~1|
 ;;0|2015_2070^G^5^CVD: BP Assessed^^62^^Monthly_Data_Supplemental^^BD^17^~1|
 ;;0|2015_2091^G^5^CVD: BMI Assessed^^63^^Monthly_Data_Supplemental^^BG^17^~1|
 ;;0|2015_2071^G^5^CVD: LDL Assessed^^64^^Monthly_Data_Supplemental^^BJ^17^~1|
 ;;0|2015_2073^G^5^CVD: Lifestyle Counseling^^65^^Monthly_Data_Supplemental^^BM^17^~1|
 ;;0|IPC_CVD^R^5^CVD Measure Bundle^B^60^^Monthly_Data_Supplemental^AX^AW^17^70%~1|D EN^BQIIPBNL(CRN,MSN,BQDATE,CODE)
 ;;0|2015_1237^G^2^Appropriate Testing for Pharyngitis (2-18)^^51^^Monthly_Data_Core^FQ^FP^14^80%~1|
 ;;0|MU_6^M^2^Weight Assessment & Counseling (2-16): BMI^^48^^^^^14^^A~1|
 ;;0|MU_7^M^2^Weight Assessment & Counseling (2-16): Nutrition^^49^^^^^14^^A~1|
 ;;0|MU_8^M^2^Weight Assessment & Counseling (2-16): Physical Activity^^50^^^^^14^^A~1|
 ;;0|IPC_WGT^R^2^Weight Assessment & Counseling (2-16)^B^47^^Monthly_Data_Core^FL^FK^14^80%^A~1|D EN^BQIIPBNL(CRN,MSN,BQDATE,CODE)
 ;;0|2015_514^G^2^Anti-Depressant Medication Mgmt 18+: Acute Phase^^39^^^^^7~1|
 ;;0|2015_515^G^2^Anti-Depressant Medication Mgmt 18+: Continuous Phase^^40^^^^^7~1|
 ;;0|IPC_ANTI^R^2^Anti-Depressant Medication Mgmt 18+^B^38^^Monthly_Data_Core^EG^EF^7^70%~1|D EN^BQIIPBNL(CRN,MSN,BQDATE,CODE)
 ;;0|2015_1317^G^2^Breastfeed Screen Rates^^42^^Monthly_Data_Core^EQ^EP^14~1|
 Q
 ;
BUN ; Bundles
 ;;
 ;;
 ;;
 ;;2015_2027~2015_2649~2015_1969~
 ;;2015_1966~2015_1965~2015_1964~2015_269~2015_530~2015_871~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;2015_2633~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;2015_907^1~2015_871^1~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;2015_2072~2015_2070~2015_2091~2015_2071~2015_2073~
 ;;
 ;;
 ;;
 ;;
 ;;MU_6~MU_7~MU_8~
 ;;
 ;;
 ;;2015_514~2015_515~
 ;;
 Q
 ;
TIP ;  Tooltips
 ;;Numerator: Total revenue generated by the microsystem provider during the ~specified month.~ ~Denominator: Number of visits to the microsystem provider during the ~specified month.~
 ;;% of patients with a primary care visit in the last month who saw THEIR~OWN DPCP.~
 ;;% of patients with a visit to any clinic in the last 3 years that have a ~DPCP listed in RPMS. ~ ~See glossary for details.~
 ;;% of patients in the microsystem who are up to date on their age- and ~gender-appropriate breast, cervical, and colorectal cancer screenings.~ ~See glossary for specific definitions.~
 ;;% of patients in the microsystem that have had age- and ~gender-appropriate screening  in the last year for alcohol use, ~depression, domestic violence/IPV, tobacco use, and BMI.~ ~See glossary for specific definitions.~
 ;;Patients in the microsystem diagnosed with DM, and/or CVD, and/or HTN ~that have controlled levels of HbA1c, and/or BP and/or LDL Assessed ~within the last year.~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;Patients who have documentation that they have set a goal during the last ~year.~
 ;;Patients in the microsystem diagnosed with DM with HbA1c<8.0 within the ~last year.~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;Patients in the microsystem diagnosed with DM and or CVD with a LDL ~assessed.~
 ;;Patients in the microsystem diagnosed with DM,and/or CVD,and/or HTN~with a controlled BP (Patients with DM,BP <140/90, patients with CVD,~BP <140/90, for HTN only: age 60 and older with HTN, BP <150/90 and~age 18 to 59 with HTN <140/90).~
 ;;Number of ER/Urgent Care visits during the past month.~
 ;;
 ;;
 ;;
 ;;Represents total patients assigned to the provider as a DPCP.~
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 Q
