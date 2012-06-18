BQI202PU ;VNGT/HS/ALA-2.0.2 Install Utility Program ; 07 May 2009  10:03 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
TPS ; Set tooltips
 NEW TEXT,BQIUPD,ERROR,BI,BJ,HELP,IEN
 F BI=1:1 S TEXT=$P($T(TIP+BI),";;",2) Q:TEXT=""  D
 . S CODE=$P(TEXT,"~",1)
 . S IEN=$O(^BQI(90506.1,"B",CODE,"")) I IEN="" Q
 . F BJ=1:1 S TXT=$P($T(@CODE+BJ),";;",2) Q:TXT=""  D
 .. S HELP(BJ)=TXT
 . D WP^DIE(90506.1,IEN_",",4,"","HELP","ERROR")
 . K HELP
 ;
TAX ; Update taxonomies
 ; Add new taxonomies OR update existing ones
 D ^BQIITX
 ;
TX ; Reset the variable pointer values for the taxonomies
 NEW BQIDA,N,X,IEN,VAL,BQIUPD,REG,RP,TIEN
 S BQIDA=1
 S N=0
 F  S N=$O(^BQI(90508,BQIDA,10,N)) Q:'N  D
 . S X=$P(^BQI(90508,BQIDA,10,N,0),U,1)
 . S IEN=N_","_BQIDA_","
 . I $P(^BQI(90508,BQIDA,10,N,0),U,5)="T" S VAL=$$STXPT(X,"L")
 . E  S VAL=$$STXPT(X,"N")
 . S BQIUPD(90508.03,IEN,.02)=VAL
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S REG=0
 F  S REG=$O(^BQI(90507,REG)) Q:'REG  D
 . S N=0
 . F  S N=$O(^BQI(90507,REG,10,N)) Q:'N  D
 .. S X=$P(^BQI(90507,REG,10,N,0),U,1)
 .. S IEN=N_","_REG_","
 .. I $P(^BQI(90507,REG,10,N,0),U,5)="T" S VAL=$$STXPT(X,"L")
 .. E  S VAL=$$STXPT(X,"N")
 .. S BQIUPD(90507.01,IEN,.02)=VAL
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . S RP=0
 . F  S RP=$O(^BQI(90507,REG,20,RP)) Q:'RP  D
 .. S N=0
 .. F  S N=$O(^BQI(90507,REG,20,RP,10,N)) Q:'N  D
 ... S X=$P(^BQI(90507,REG,20,RP,10,N,0),U,1)
 ... S IEN=N_","_RP_","_REG_","
 ... S TIEN=$O(^BQI(90507,REG,10,"B",X,""))
 ... I $P(^BQI(90507,REG,10,TIEN,0),U,5)="T" S VAL=$$STXPT(X,"L")
 ... E  S VAL=$$STXPT(X,"N")
 ... S BQIUPD(90507.03,IEN,.02)=VAL
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
CTX ; Set community taxonomies
 NEW DATA,DA,DIK
 S DA(1)=$$SPM^BQIGPUTL(),DA=0,DIK="^BQI(90508,"_DA(1)_",10,"
 F  S DA=$O(^BQI(90508,DA(1),10,DA)) Q:'DA  D
 . I $P(^BQI(90508,DA(1),10,DA,0),U,5)'="CM" Q
 . D ^DIK
 S DATA="TEST",II=0
 D COMMTX^BQIUTB(.DATA)
 K @DATA
 Q
 ;
DX ; Check diagnosis code pointers
 NEW CN,DN,DXC,DXN
 S CN=0
 F  S CN=$O(^BQI(90507.8,CN)) Q:'CN  D
 . S DN=0
 . F  S DN=$O(^BQI(90507.8,CN,10,DN)) Q:'DN  D
 .. S DXC=$P(^BQI(90507.8,CN,10,DN,0),U,2)_" "
 .. S DXN=$$FIND1^DIC(80,"","X",DXC,"BA","","ERROR")
 .. I $P(^BQI(90507.8,CN,10,DN,0),U,1)=DXN Q
 .. NEW DA,IENS
 .. S DA(1)=CN,DA=DN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90507.801,IENS,.01)=DXN
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
CAT ; Change NEW CATEGORY value
 NEW DIEN,TEXT
 F TEXT="DPCP","DCAT" D
 . S DIEN=$O(^BQI(90506.1,"B",TEXT,""))
 . S $P(^BQI(90506.1,DIEN,3),U,3)="Other Patient Data"
 F TEXT="LVD","LVPR","LVCL","LVDN","LVPN","NAPD","NAPC","NAPV","LVDTM","NAPDTM" D
 . S DIEN=$O(^BQI(90506.1,"B",TEXT,"")) I DIEN="" Q
 . S $P(^BQI(90506.1,DIEN,3),U,3)="Visit Related"
 F TEXT="MSTRT","MCTY","MSTAT","MZIP","HPHN","WPHN","OPHN" D
 . S DIEN=$O(^BQI(90506.1,"B",TEXT,"")) I DIEN="" Q
 . S $P(^BQI(90506.1,DIEN,3),U,3)="Address"
 F TEXT="PN","HRN","DOB","AGE","SX","CM","COM","MFLG","GPRM","PADD","DOD","UPOP","BEN" D
 . S DIEN=$O(^BQI(90506.1,"B",TEXT,""))
 . S $P(^BQI(90506.1,DIEN,3),U,3)="Demographics"
 . I TEXT="HRN" S $P(^BQI(90506.1,DIEN,0),U,8)="T00040HRN"
 Q
 ;
STXPT(TXNM,TYP) ;  Set taxonomy pointer
 ;
 ;Input
 ;  TXNM - Taxonomy name
 ;  TYP  - Taxonomy Type (L = LAB, N = Non Lab)
 NEW IEN,SIEN,DA,IENS,BQUPD,VALUE,GLB
 S VALUE=""
 I TYP="L" D
 . S IEN=$O(^ATXLAB("B",TXNM,"")),GLB="ATXLAB("
 . I IEN="" S TYP="N"
 I TYP="N" S IEN=$O(^ATXAX("B",TXNM,"")),GLB="ATXAX("
 I IEN="" S VALUE="@"
 I IEN'="" S VALUE=IEN_";"_GLB
 Q VALUE
 ;
PNLFX ; Loop through existing panels and fix layout related issues
 ;
 N CML,FLN,OWNR,PNL,SHR
 ;
 S OWNR=0 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PNL=0 F  S PNL=$O(^BQICARE(OWNR,1,PNL)) Q:'PNL  D
 .. ;
 .. ;Revert templates entries back to system default or customized
 .. K ^BQICARE(OWNR,1,PNL,4)
 .. ;
 .. ;Validate sub-file file numbers - Fix if needed
 .. S FLN=$P($G(^BQICARE(OWNR,1,PNL,20,0)),U,2) I FLN]"",FLN'="90505.05P" S $P(^BQICARE(OWNR,1,PNL,20,0),U,2)="90505.05P"
 .. S FLN=$P($G(^BQICARE(OWNR,1,PNL,22,0)),U,2) I FLN]"",FLN'="90505.122" S $P(^BQICARE(OWNR,1,PNL,22,0),U,2)="90505.122"
 .. S FLN=$P($G(^BQICARE(OWNR,1,PNL,25,0)),U,2) I FLN]"",FLN'="90505.125" S $P(^BQICARE(OWNR,1,PNL,25,0),U,2)="90505.125"
 .. S FLN=$P($G(^BQICARE(OWNR,1,PNL,23,0)),U,2) I FLN]"",FLN'="90505.123" S $P(^BQICARE(OWNR,1,PNL,23,0),U,2)="90505.123"
 .. S CML=0 F  S CML=$O(^BQICARE(OWNR,1,PNL,23,CML)) Q:'CML  S FLN=$P($G(^BQICARE(OWNR,1,PNL,23,CML,1,0)),U,2) I FLN]"",FLN'="90505.1231" S $P(^BQICARE(OWNR,1,PNL,23,CML,1,0),U,2)="90505.1231"
 .. ;
 .. ;Loop through shared user layouts
 .. S SHR=0 F  S SHR=$O(^BQICARE(OWNR,1,PNL,30,SHR)) Q:'SHR  D
 ... ;
 ... ;Revert shared user entries from templates to system default or customized
 ... K ^BQICARE(OWNR,1,PNL,30,SHR,4)
 ... ;
 ... ;Validate sub-file file number - Fix if needed
 ... S FLN=$P($G(^BQICARE(OWNR,1,PNL,30,SHR,20,0)),U,2) I FLN]"",FLN'="90505.06P" S $P(^BQICARE(OWNR,1,PNL,30,SHR,20,0),U,2)="90505.06P"
 ... S FLN=$P($G(^BQICARE(OWNR,1,PNL,30,SHR,22,0)),U,2) I FLN]"",FLN'="90505.322" S $P(^BQICARE(OWNR,1,PNL,30,SHR,22,0),U,2)="90505.322"
 ... S FLN=$P($G(^BQICARE(OWNR,1,PNL,30,SHR,25,0)),U,2) I FLN]"",FLN'="90505.325" S $P(^BQICARE(OWNR,1,PNL,30,SHR,25,0),U,2)="90505.325"
 ... S FLN=$P($G(^BQICARE(OWNR,1,PNL,30,SHR,23,0)),U,2) I FLN]"",FLN'="90505.323" S $P(^BQICARE(OWNR,1,PNL,30,SHR,23,0),U,2)="90505.323"
 ... S CML=0 F  S CML=$O(^BQICARE(OWNR,1,PNL,30,SHR,23,CML)) Q:'CML  S FLN=$P($G(^BQICARE(OWNR,1,PNL,30,SHR,23,CML,1,0)),U,2) I FLN]"",FLN'="90505.3231" S $P(^BQICARE(OWNR,1,PNL,30,SHR,23,CML,1,0),U,2)="90505.3231"
 ;
 Q
 ;
TIP ;  Tooltips
 ;;ASACON
 ;;ASACT
 ;;ASAQC
 ;;ASCNTRL
 ;;ASFHX
 ;;ASFLU
 ;;ASIHSD
 ;;ASLADM
 ;;ASLBPF
 ;;ASLEUV
 ;;ASLFD
 ;;ASLFEV
 ;;ASLHSV
 ;;ASLPF
 ;;ASLV
 ;;ASRLVR
 ;;ASSEV
 ;;ASSTAT
 ;;ASTBHF
 ;;ASTRIG
 ;;DPCP
 Q
 ;
ASACON ;
 ;;Asthma Control: Most recent Control value from Measurements file.  The 
 ;;visit date will display if your cursor hovers over the cell.
 Q
 ;
ASACT ;
 ;;Asthma Action Plan: Date of most recent Action Plan provided to this 
 ;;patient.  Action Plans are available from the PCC Patient Wellness 
 ;;Handout menus or from the iCare Patient Record.
 Q
 ;
ASAQC ;
 ;;Asthma Quality of Care: If this patient has an Active Asthma diagnostic 
 ;;tag (Proposed or Accepted), are ALL of the following key elements 
 ;;documented:  Asthma Severity value ever; Asthma Control and Peak Flow or 
 ;;FEV1 measurement and Asthma Action Plan and Flu Shot in past year; and 
 ;;current Controller medication prescription if Severity is Persistent (2,3 ~or 4).
 ;;"N/A" will display if this patient does not have an active Asthma 
 ;;diagnostic tag. 
 Q
 ;
ASCNTRL ;
 ;;On Controller Meds?  Is this patient currently prescribed with Asthma 
 ;;Controller medications?  
 ;;"N/A" will display if this patient does not have an active Asthma 
 ;;diagnostic tag.  Open this patient's record to PCC/Medications tab to 
 ;;view specific asthma-related medications list.
 Q
 ;
ASFHX ;
 ;;Asthma Family History: "Y" indicates this patient has at least one Family 
 ;;History entry for asthma.  Detailed asthma FHX data will display if your 
 ;;cursor hovers over the cell. 
 ;;Open this patient's record to FHX tab to view, add or edit any Family 
 ;;History. 
 Q
 ;
ASFLU ;
 ;;Last Flu Shot: Date of most recent Influenza immunization.
 Q
 ;
ASIHSD ;
 ;;On Inhaled Steroids?  Is this patient currently prescribed with Inhaled 
 ;;Steroid medications?  
 ;;"N/A" will display if this patient does not have an active Asthma 
 ;;diagnostic tag.  Open this patient's record to PCC/Medications tab to 
 ;;view specific asthma-related medications list.
 Q
 ;
ASLADM ;
 ;;Asthma Work/School Days Missed: Value of most recent Work/School Missed.  
 ;;Available values are 0-14 (days), documented in V Measurements.  The 
 ;;visit date will display if your cursor hovers over the cell.
 Q
 ;
ASLBPF ;
 ;;Best Peak Flow: Most recent Best Peak Flow value from Measurements file.  
 ;;BPF is the highest PEF the patient is able to achieve over a 2 to 3 week 
 ;;period of using the peak flow meter while asthma is under control.
 ;;The visit date will display if your cursor hovers over the cell.
 Q
 ;
ASLEUV ;
 ;;Last Asthma ER/UC Visit: Date of most recent visit to the ER or Urgent 
 ;;Care (clinic codes 80 or 30) with Asthma as the primary POV.
 Q
 ;
ASLFD ;
 ;;Asthma Symptom Free Days: Value of most recent Symptom Free Days.  
 ;;Available values are 0-14 (days), documented in V Measurements.  The 
 ;;visit date will display if your cursor hovers over the cell.
 Q
 ;
ASLFEV ;
 ;;FEV1/FVC: Most recent FEV1/FVC values from Measurements file, obtained 
 ;;from spirometry measurements during a visit.  The visit date will display 
 ;;if your cursor hovers over the cell.
 Q
 ;
ASLHSV ;
 ;;Last Asthma Hospital Visit: Date of most recent hospitalization (service 
 ;;category H) with Asthma as the primary POV.
 Q
 ;
ASLPF ;
 ;;Peak Flow: Most recent Peak Flow value from Measurements file, obtained 
 ;;from a peak flow meter during a visit.  If multiple PFs were documented 
 ;;on the same date, the value displayed is the highest.  
 ;;The visit date will display if your cursor hovers over the cell.
 Q
 ;
ASLV ;
 ;;Last Asthma Visit: Date of most recent Asthma visit, defined as a 
 ;;face-to-face visit with ANY of the following asthma-related data elements 
 ;;documented: Severity, Control, Symptom Free Days, Work/School Missed, 
 ;;and/or Patient Education. 
 ;;Click the date to link directly to the Visit Record.
 Q
 ;
ASRLVR ;
 ;;On Reliever Meds?  Is this patient currently prescribed with Asthma 
 ;;Reliever medications?  
 ;;"N/A" will display if this patient does not have an active Asthma 
 ;;diagnostic tag.  Open this patient's record to PCC/Medications tab to 
 ;;view specific asthma-related medications list.
 Q
 ;
ASSEV ;
 ;;Asthma Severity: Most recent Severity, documented in Problem List 
 ;;Classification field. Values are: 1-Intermittent; 2-Mild Persistent; 
 ;;3-Moderate Persistent; 4-Severe Persistent.
 Q
 ;
ASSTAT ;
 ;;Asthma Diagnostic Tag Status: Most recent diagnostic tag status for 
 ;;Asthma only, if any.  Open this patient's record to DX Tag tab to view a 
 ;;complete history of all diagnostic tags.
 Q
 ;
ASTBHF ;
 ;;Last Tobacco Health Factor: Most recent Tobacco Health Factor.  The visit 
 ;;date will display if your cursor hovers over the cell.
 Q
 ;
ASTRIG ;
 ;;Asthma Triggers List: A list of the most recent of ANY Asthma Triggers 
 ;;(Health Factors) documented ever for this patient.  The visit date(s) 
 ;;will display if your cursor hovers over the cell.
 Q
 ;
DPCP ;
 ;;Designated Primary Care Provider (DPCP): Name of this patient's
 ;;DPCP, if any.
 Q
