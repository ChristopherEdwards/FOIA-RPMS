BQILYUPD ;GDIT/HS/ALA-Update Layout Source ; 03 Jun 2014  8:27 AM
 ;;2.4;ICARE MANAGEMENT SYSTEM;;Apr 01, 2015;Build 41
 ;
 ;
LAY ; Add new patient entries to 90506.1
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL,TTEXT,BJJ
 F BI=1:1 S TEXT=$P($T(ARR+BI),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y
 ... S DIC(0)="LQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)=VAL Q
 .. I ND=5 S BQIUPD(90506.1,IEN_",",5)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90506.1,IEN_",",BN)="@"
 ... ;
 ... S TTEXT=$T(TIP+BI) Q:TTEXT=" Q"  D
 .... S TTEXT=$P(TTEXT,";;",2) I TTEXT="" Q
 .... F BJJ=1:1:$L(TTEXT,"~") D
 ..... S NDATA=$P(TTEXT,"~",BJJ) I NDATA="" Q
 ..... S ^BQI(90506.1,IEN,4,BJJ,0)=NDATA
 ..... S ^BQI(90506.1,IEN,4,0)="^^"_BJJ_"^"_BJJ
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Re-Index File
 K ^BQI(90506.1,"AC"),^BQI(90506.1,"AD")
 NEW DIK
 S DIK="^BQI(90506.1,",DIK(1)=3.01
 D ENALL^DIK
 S BQIUPD(90506.5,36_",",.1)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
ARR ;
 ;;0|PGCURR^99^Currently Pregnant?^^^^^T00003PGCURR~1|S VAL=$$CURR^BQIRGPG(DFN)~3|36^^^D^1~5|
 ;;0|PGEDD^99^Estimated Delivery Date^^^^^D00015PGEDD~1|S VAL=$$EDD^BQIRGPG(DFN)~3|36^^^R^2~5|
 ;;0|PGEGA^2^Estimated Gestational Age^^^^^T00025PGEGA~1|S VAL=$$EGA^BQIRGPG(DFN)~3|36^^^D^3~5|
 ;;0|PGHRISK^99^High Risk^^^^^T00001PGHRISK~1|S VAL=$$HGH^BQIRGPG(DFN)~3|36^^^R^4~5|
 ;;0|LIMMN^^Last Immunization Notification^^^^^T00025LIMMN~1|S VAL=$$LIMM^BQINOTR(DFN)~3|1^^Other Patient Data^O^46~5|
 ;;0|LRNOT^^Last Reminder Notification^^^^^T00020LRNOT~1|S VAL=$$LNOT^BQINOTR(DFN)~3|1^^Other Patient Data^O^45~5|
 ;;0|BDM3BP^^Last 3 BP (non ER)^^^^^T00040BDM3BP~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^10~5|S VAL=$$BP^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMA1C^^HbA1c^^^^^T00030BDMA1C~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^28~5|S VAL=$$A1C^BQIRGDMS(DFN),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMACE^^On ACE Inhibitor?^^^^^T00030BDMACE~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^8~5|S VAL=$$ACE^BQIRGDMS(DFN),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMASP^^Aspirin Use/Anti-platelet^^^^^T00030BDMASP~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^9~5|S VAL=$$ASP^BQIRGDMS(DFN),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMBMI^^BMI^^^^^T00030BDMBMI~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^4~5|S VAL=$$MSR^BQIRGDMS(DFN,"BMI"),OTHER="",VISIT="",DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMCHEST^^Last Chest Xray^^^^^T00030BDMCHEST~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^23~5|S VAL=$$RAD^BQIRGDMS(DFN,"CHEST"),OTHER="",VISIT="",DATE=""
 ;;0|BDMCREAT^^Creatinine^^^^^T00030BDMCREAT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^33~5|S VAL=$$NEP^BQIRGDMS(DFN,"CREAT"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMCVD^^CVD Diagnosed?^^^^^T00030BDMCVD~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^40~5|S VAL=$$UP^XLFSTR($P($$CVD^BDMDA12(DFN,DT),"  ",2,999)),OTHER="",VISIT="",DATE=""
 ;;0|BDMDENT^^Dental Exam^^^^^T00030BDMDENT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^14~5|S VAL=$$EXM^BQIRGDMS(DFN,"DEN"),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMDEPRS^^Depression^^^^^T00030BDMDEPRS~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^11~5|S VAL=$$DEP^BQIRGDMS(DFN),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMDIET^^Last Dietician Visit^^^^^T00030BDMDIET~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^18~5|S VAL=$$DIET^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMEKG^^Last EKG^^^^^T00030BDMEKG^^1^3140429~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^22~5|S VAL=$$RAD^BQIRGDMS(DFN,"EKG"),OTHER="",VISIT="",DATE=""
 ;;0|BDMEYE^^DM Eye Exam^^^^^T00030BDMEYE~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^13~5|S VAL=$$EXM^BQIRGDMS(DFN,"EYE"),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMFLU^^Seasonal Flu^^^^^T00030BDMFLU~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^19~5|S VAL=$$FLU^BQIRGDMS(DFN),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMFOOT^^DM Foot Exam^^^^^T00030BDMFOOT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^12~5|S VAL=$$EXM^BQIRGDMS(DFN,"FT"),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMGFR^^Estimated GFR^^^^^T00030BDMGFR~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^34~5|S VAL=$$NEP^BQIRGDMS(DFN,"GFR"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMHDL^^HDL Cholesterol^^^^^T00030BDMHDL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^37~5|S VAL=$$NEP^BQIRGDMS(DFN,"HDL"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMHEPB^^Hep B Series Complete^^^^^T00003BDMHEPB~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^39~5|S VAL=$$HEPB^BQIRGDMS(DFN)
 ;;0|BDMHTN^^HTN Diagnosed?^^^^^T00030BDMHTN~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^7~5|S VAL=$$UP^XLFSTR($$HTN^BDMS9B1(DFN)),OTHER="",VISIT="",DATE=""
 ;;0|BDMLDL^^LDL Cholesterol^^^^^T00030BDMLDL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^36~5|S VAL=$$NEP^BQIRGDMS(DFN,"CHOL"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMLHT^^Last Height^^^^^T00030BDMLHT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^2~5|S VAL=$$MSR^BQIRGDMS(DFN,"HT"),OTHER="",VISIT="",DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMLPPD^^Last PPD^^^^^T00030BDMLPPD^^1^3140429~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^25~5|S VAL=$$PPD^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMLTB^^Last TB Test^^^^^T00030BDMLTB~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^26~5|S VAL=$$PPD^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMLTBHF^^Last TB Health Factor^^^^^T00030BDMLTBHF~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^27~5|S VAL=$$TBHF^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMLWC^^Last Waist Circumference^^^^^T00030BDMLWC~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^5~5|S VAL=$$MSR^BQIRGDMS(DFN,"WC"),OTHER="",VISIT="",DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMLWT^^Last Weight^^^^^T00030BDMLWT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^3~5|S VAL=$$MSR^BQIRGDMS(DFN,"WT"),OTHER="",VISIT="",DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMMAM^^Last Mammogram^^^^^T00030BDMMAM~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^17~5|S VAL=$$SEX^BQIRGDMS(DFN,"MAM"),OTHER="",VISIT="",DATE=""
 ;;0|BDMMICRO^^Microalbuminuria^^^^^T00030BDMMICRO^^1^3140429~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^31~5|S VAL=$$NEP^BQIRGDMS(DFN,"MIC"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMNA1C^^Previous HbA1c^^^^^T00030BDMNA1C~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^29~5|S VAL=$$NA1C^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMNHDL^^Non-HDL Cholesterol^^^^^T00030BDMNHDL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^41~5|S VAL=$$NEP^BQIRGDMS(DFN,"NHDL"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMONSET^^DM Onset^^^^^T00030BDMONSET~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^1~5|S VAL=$$DOO^BQIRGDMS(DFN),OTHER="",VISIT=""
 ;;0|BDMPAP^^Last Pap Smear^^^^^T00030BDMPAP~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^16~5|S VAL=$$SEX^BQIRGDMS(DFN,"PAP"),OTHER="",VISIT="",DATE=""
 ;;0|BDMPNEU^^Pneumovax^^^^^T00040BDMPNEU~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^20~5|S VAL=$$VAX^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMPPDS^^PPD Status^^^^^T00030BDMPPDS~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^O^24~5|S VAL=$$PPDS^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMRATIO^^UACR (Quant A/C Ratio)^^^^^T00030BDMRATIO~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^32~5|S VAL=$$NEP^BQIRGDMS(DFN,"RATIO"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMSMBG^^Self Monitoring (SMBG)^^^^^T00030BDMSMBG^^1^3140429~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^15~5|S VAL=$$EXM^BQIRGDMS(DFN,"SMB"),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMTCHOL^^Total Cholesterol^^^^^T00030BDMTCHOL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^35~5|S VAL=$$NEP^BQIRGDMS(DFN,"TCHOL"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMTDTEN^^TD (10 yrs)^^^^^T00030BDMTDTEN~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^21~5|S VAL=$$TD^BQIRGDMS(DFN),OTHER="",VISIT="",DATE=""
 ;;0|BDMTOB^^Tobacco Use Assessed^^^^^T00030BDMTOB~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^6~5|S VAL=$$TOB^BQIRGDMS(DFN),OTHER="",VISIT="",DATE="",VAL=$P(VAL,U,2)
 ;;0|BDMTRIG^^Triglycerides^^^^^T00030BDMTRIG~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^38~5|S VAL=$$NEP^BQIRGDMS(DFN,"TRIG"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|BDMURINP^^Urine Protein^^^^^T00030BDMURINP^^1^3140429~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|7^^^D^30~5|S VAL=$$NEP^BQIRGDMS(DFN,"UR"),OTHER="",VISIT=$P(VAL,U,2),DATE=$P(VAL,U,4),VAL=$P(VAL,U,1)
 Q
 ;
TIP ;
 ;;Value is taken from the Reproductive Factors file.~
 ;;The estimated delivery date of this patient.~
 ;;The Estimated Gestational Age measurement (EGA) from the V Measurement ~file.~
 ;;Value is "YES" if patient has any prenatal problems that are a High ~priority.~
 ;;The last immunization reminder notification logged for this patient.~
 ;;The date and type of the most recent reminder notification to this ~patient.~
 ;;The last three blood pressure measures for this patient.~
 ;;The most recent HbA1c test result for this patient.~
 ;;Did the patient have an active ACE Inhibitor/ARB medication in the past~year.~
 ;;Patient had an active aspirin/anti-platelet medication in the past year.~
 ;;This is the value of the BMI calculated from the most recent height and ~weight measurements for the patient.~
 ;;Date of the last Chest xray for the patient.~
 ;;The most recent Creatinine lab test for this patient.~
 ;;Has the patient been diagnosed with CVD.~
 ;;Has the patient had a dental exam in the past year.~
 ;;If the patient has Depression on the Problem List, no depression ~screening is needed.  Otherwise has the patient had a depression screening~in the past year.~
 ;;The date of the patient's last visit to a dietician.~
 ;;Date of the last EKG exam for the patient.~
 ;;Has the patient had an eye exam in the past year.~
 ;;Returns the last recorded FLU.~
 ;;Has the patient had a foot exam in the past year.~
 ;;The most recent Estimated GFR lab test for this patient.~
 ;;The most recent HDL Cholesterol lab test for this patient.~
 ;;If the patient has completed the Hep B series of immunizations.~
 ;;Has the patient been diagnosed with Hypertension?~
 ;;The most recent LDL Cholesterol lab test for this patient.~
 ;;The last height measurement taken for this patient.~
 ;;
 ;;Last TB test for this patient.~
 ;;Last tobacco health factor enter for the patient.~
 ;;This is the most recent waist circumference measurement taken for this ~patient.~
 ;;The most recent weight measurement taken for this patient.~
 ;;If applicable, the date of the patient's last mammogram.~
 ;;
 ;;The previous result from the most recent HbA1c lab test for this patient.~
 ;;The most recent non-HDL Cholesterol lab test. ~
 ;;The date of the onset of Diabetes for this patient and where the date is ~documented.~
 ;;If applicable, the date of the patient's last pap smear.~
 ;;The last pneumovax immunization for this patient.~
 ;;The status of a PPD test for the patient.~
 ;;The most recent UACR (Quant A/C Ratio) lab test for this patient.~
 ;;Has the patient had self-monitoring blood glucose evidence in the past ~year.~
 ;;The most recent Total Cholesterol lab test for this patient.~
 ;;The last TD in the past 10 years.~
 ;;Was tobacco Use assessed in the last year for this patient.~CRS measure,Tobacco Use/Exposure Assessment 5+.~
 ;;The most recent Triglyceride lab test for this patient.~
 ;;The most recent urine protein test for this patient.~
 Q
