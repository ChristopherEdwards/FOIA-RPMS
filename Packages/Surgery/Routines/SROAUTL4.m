SROAUTL4 ;BIR/ADM-Risk Assessment Utility ; [ 01/12/95  7:41 PM ]
 ;;3.0; Surgery ;**38,71,95**;24 Jun 93
 S SRZ=0 F  S SRZ=$O(SRY(130,SRTN,SRZ)) Q:'SRZ  D
 .I SRY(130,SRTN,SRZ,"I")="" D TR S X=$T(@SRP),SRFLD=$P(X,";;",2),SRX(SRZ)=$P(SRFLD,"^",2)
 .I SRY(130,SRTN,SRZ,"I")="NS" D TR S X=$T(@SRP),SRFLD=$P(X,";;",2),SRDT=$P(SRFLD,"^",4) S:SRDT'="" SRLR(SRDT)=""
 S SRDT=0 F  S SRDT=$O(SRLR(SRDT)) Q:'SRDT  K SRX(SRDT)
 Q
TR S SRP=SRZ,SRP=$TR(SRP,"1234567890.","ABCDEFGHIJP")
 Q
GET S X=$T(@J)
 Q
PBB ;;.22^Time the Operation Began^Date/Time Operation Began^
PBC ;;.23^Time the Operation Ended^Date/Time Operation Ended^
BCF ;;236^Patient's Height^Height^
BCG ;;237^Patient's Weight^Weight^
CDF ;;346^Diabetes^Diabetes^
BJC ;;203^History of COPD (Y/N)^COPD^
CDG ;;347^FEV1^FEV1^
BJI ;;209^Cardiomegaly on Chest X-Ray (Y/N)^Cardiomegaly (X-ray)^
CDH ;;348^Pulmonary Rales (Y/N)^Pulmonary Rales^
BJB ;;202^Current Smoker within 2 Weeks prior to Surgery (Y/N)^Current Smoker^
BBC ;;223^Preoperative Serum Creatinine (mg/dl)^Creatinine^290
CDI ;;349^Active Endocarditis (Y/N)^Active Endocarditis^
CEJ ;;350^Resting ST Depression (Y/N)^Resting ST Depression^
BDJ ;;240^Functional Health Status^Functional Status^
CEA ;;351^PTCI Status^PTCI^
BJE ;;205^Prior Myocardial Infarction^Prior MI^
CEB ;;352^Prior Heart Surgery (Y/N)^Prior Heart Surgery^
BFE ;;265^Peripheral Vascular Disease (Y/N)^Peripheral Vascular Disease^
BFD ;;264^Cerebral Vascular Disease (Y/N)^Cerebral Vascular Disease^
BFG ;;267^Angina (use NYHA Functional Class)^Angina (use CCS Class)^
BJG ;;207^Congestive Heart Failure (use NYHA Functional Class)^CHF (use NYHA Class)^
CEC ;;353^Current Diuretic Use (Y/N)^Current Diuretic Use^
CED ;;354^Current Digoxin Use (Y/N)^Current Digoxin Use^
CEE ;;355^IV NTG within 48 Hours Preceding Surgery (Y/N)^IV NTG within 48 Hours^
CEF ;;356^Preoperative use of IABP (Y/N)^Preop Use of IABP^
CEG ;;357^Left Ventricular End-Diastolic Pressure^LVEDP^
CEH ;;358^Aortic Systolic Pressure^Aortic Systolic Pressure^
CEI ;;359^PA Systolic Pressure^*PA Systolic Pressure^
CFJ ;;360^PAW Mean Pressure^*PAW Mean Pressure^
CFA ;;361^Left Main Stenosis^Left Main Stenosis^
CFBPA ;;362.1^Left Anterior Descending (LAD) Stenosis^LAD Stenosis^
CFBPB ;;362.2^Right Coronary Artery Stenosis^Right Coronary Stenosis^
CFBPC ;;362.3^Circumflex Coronary Artery Stenosis^Circumflex Stenosis^
CFC ;;363^LV Contraction Grade^LV Contraction Grade  (from contrast or radionuclide angiogram or 2D echo^
DAE ;;415^Mitral Regurgitation^Mitral Regurgitation^
CFD ;;364^Physician's Preoperative Estimate of Operative Mortality^Physician's Preoperative Estimate of Operative Mortality^
CFDPA ;;364.1^Date/Time of Estimate of Operative Mortality^Date/Time of Estimate of Operative Mortality^
APAC ;;1.13^ASA Class^ASA Classification^
DAD ;;414^Cardiac Surgical Priority^Surgical Priority^
DADPA ;;414.1^Date/Time of Cardiac Surgical Priority^Date/Time of Cardiac Surgical Priority^
CHD ;;384^Operative Death (Y/N)^Operative Death^
CFE ;;365^CABG Distal Anastomoses with Vein^^
CFF ;;366^CABG Distal Anastomoses with IMA^^
CFG ;;367^Aortic Valve Replacement (Y/N)^Aortic Valve Replacement^
CFH ;;368^Mitral Valve Replacement (Y/N)^Mitral Valve Replacement^
CFI ;;369^Tricuspid Valve Replacement (Y/N)^Tricuspid Valve Replacement^
CGJ ;;370^Valve Repair (Y/N)^Valve Repair^
CGA ;;371^LV Aneurysmectomy (Y/N)^LV Aneurysmectomy^
CGB ;;372^Great Vessel Repair, requiring CPB (Y/N)^Great Vessel Repair (Req CPB)^
CGC ;;373^Cardiac Transplant (Y/N)^Cardiac Transplant^
CGD ;;374^Electrophysiologic Procedure (Y/N)^Electrophysiologic Procedure^
CGE ;;375^Miscellaneous Cardiac Procedures^Miscellaneous Cardiac Procedures^
CGF ;;376^ASD Repair (Y/N)^ASD Repair^
CHJ ;;380^VSD Repair (Y/N)^VSD Repair^
CGG ;;377^Myxoma Resection (Y/N)^Myxoma Resection^
CHA ;;381^Foreign Body Removal (Y/N)^Foreign Body Removal^
CGH ;;378^Myectomy for IHSS (Y/N)^Myectomy for IHSS^
CHB ;;382^Pericardiectomy (Y/N)^Pericardiectomy^
CGI ;;379^Other Tumor Resection (Y/N)^Other Tumor Resection^
CHC ;;383^Other Procedures (Y/N)^Other Procedure(s)^
CHCPA ;;383.1^Other Procedure(s) Requiring Cardiopulmonary Bypass (List)^Other Procedures (List)^
DAF ;;416^CABG Distal Anastomoses with Other Conduit^^
DDB ;;442^Employment Status
BAI ;;219^Preoperative Hemoglobin^^239
BCI ;;239^Preoperative Hemoglobin Date
BBE ;;225^Preoperative Serum Albumin^^292
BIB ;;292^Preoperative Serum Albumin Date
BIJ ;;290^Creatinine Date
DEJ ;;450^Total Ischemic Time
DDA ;;441^Minimally Invasive Procedure Technique Used Y/N
DEA ;;451^Total CPB Time
DDJ ;;440^Cardiac Catheterization Date
DAH ;;418^Hospital Admission Date And Time
DAI ;;419^Hospital Discharge Date And Time
DCI ;;439^Batista Procedure Used
DFC ;;463^Hypertension^
DFD ;;464^Number with Radial Artery^
DFE ;;465^Number with Other Artery^
DFH ;;468^Incision Type^
DFI ;;469^Covert From Off Pump to CPB
DGJ ;;470^Date and Time Patient Extubated
DGA ;;471^Date and Time Patient Discharged from ICU
DGB ;;472^Cardiac Surgery to NON-VA Facility
PBJE ;;.205^Time Patient In OR
PBCB ;;.232^Time Patient Out OR
