BQI22POS ;VNGT/HS/ALA-Version 2.2 Post-Install ; 24 Feb 2011  11:45 AM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 ;
EN ;EP - Entry point
 ;
 ; Save off definitions (just in case need to restore)
 NEW NODE,OWNR,PLIEN
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 .. F NODE=0,3,5,10,15 M ^ZBQICARE(OWNR,1,PLIEN,NODE)=^BQICARE(OWNR,1,PLIEN,NODE)
 ;
GLS ; Update glossary
 NEW GN,GNM,GSN,BQIUPD
 S GN=0
 F  S GN=$O(^BQI(90509.9,GN)) Q:'GN  D
 . S GNM=$P(^BQI(90509.9,GN,0),U,1)
 . S GSN=$O(^BQI(90508.2,"B",GNM,"")) Q:GSN=""
 . S BQIUPD(90508.2,GSN_",",1)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . M ^BQI(90508.2,GSN,1)=^BQI(90509.9,GN,1)
 ;
 ;Set the version number
 NEW DA,BJ
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="2.2.0.16"
 S BQIUPD(90508,DA_",",.09)="2.2.0T16"
 F BJ=.15,.16,.17,.18 S BQIUPD(90508,DA_",",BJ)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;Set up User Classes
 NEW DIC,DLAYGO,DA,X,Y
 S DA=$O(^BQI(90508,0))
 I $G(^BQI(90508,DA,13,0))="" S ^BQI(90508,DA,13,0)="^90508.013P^^"
 S DA(1)=DA,DIC(0)="LNZ",DLAYGO=90508.013,DIC="^BQI(90508,"_DA(1)_",13,",DIC("P")=DLAYGO
 F X="PHYSICIAN","PHYSICIAN ASSISTANT","NURSE PRACTITIONER" D
 . D ^DIC
 . I Y=-1 K DO,DD D FILE^DICN
 ;
 ; Set up providers
 D EN^DDIOL("Finding MU Providers","","!!?15")
 NEW BQIMPROV,PRV,DATE,PROV,DATE,VISIT,PIEN,NUM,CNT
 S DATE=3110101-.0001
 F  S DATE=$O(^AUPNVSIT("B",DATE)) Q:DATE=""!(DATE\1>DT)  D  D EN^DDIOL(".","","?0")
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",DATE,VISIT)) Q:VISIT=""  D
 .. S PIEN=""
 .. F  S PIEN=$O(^AUPNVPRV("AD",VISIT,PIEN)) Q:PIEN=""  D
 ... S PROV=$P($G(^AUPNVPRV(PIEN,0)),"^",1) I PROV="" Q
 ... S BQIMPROV(PROV)=$G(BQIMPROV(PROV))+1
 S PRV="" F  S PRV=$O(BQIMPROV(PRV)) Q:PRV=""  I '$D(^XUSEC("ORES",PRV)) K BQIMPROV(PRV)
 ;
 S PRV="" F  S PRV=$O(BQIMPROV(PRV)) Q:PRV=""  S NUM=BQIMPROV(PRV),PROV(NUM,PRV)=""
 S NUM="",CNT=0
 F  S NUM=$O(PROV(NUM),-1) Q:NUM=""!(CNT=50)  D
 . S PRV=""
 . F  S PRV=$O(PROV(NUM,PRV)) Q:PRV=""!(CNT=50)  D
 .. NEW DA,DIC,X,Y,DLAYGO
 .. S DA=$O(^BQI(90508,0))
 .. I $G(^BQI(90508,DA,14,0))="" S ^BQI(90508,DA,14,0)="^90508.014P^^"
 .. S DA(1)=DA,DIC(0)="LNZ",DLAYGO=90508.013,DIC="^BQI(90508,"_DA(1)_",14,",DIC("P")=DLAYGO
 .. S X=$P($G(^VA(200,PRV,0)),U,1) I X="" Q
 .. D ^DIC
 .. I Y=-1 K DO,DD D FILE^DICN
 .. S CNT=CNT+1
 ;
 ; Set BTPWRPC into BQIRPC
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BTPWRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 ;
 ; Convert Panel Definitions
 NEW NDZ,PN,PR,PAR,VAL,PDA
 I $D(^BQICARE(.5)) K ^BQICARE(.5)
 S NDZ=0
 F  S NDZ=$O(^BQICARE(NDZ)) Q:'NDZ  D
 . S PN=0
 . F  S PN=$O(^BQICARE(NDZ,1,PN)) Q:'PN  D
 .. S PR=0
 .. F  S PR=$O(^BQICARE(NDZ,1,PN,15,PR)) Q:'PR  D
 ... S PAR=$P(^BQICARE(NDZ,1,PN,15,PR,0),U,1),VAL=$P(^(0),U,2)
 ... I PAR'="DEC" Q
 ... ; If value was 'Living', set deceased to No, add LIV as yes and INAC as no
 ... I VAL="L" D
 .... S $P(^BQICARE(NDZ,1,PN,15,PR,0),U,2)="N"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"LIV")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="Y"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"INAC")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="N"
 ... ; If value was 'Both', set deceased to Yes, add LIV as yes and INAC as no
 ... I VAL="B" D
 .... S $P(^BQICARE(NDZ,1,PN,15,PR,0),U,2)="Y"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"LIV")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="Y"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"INAC")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="N"
 ... ; If value was Deceased, add LIV as no and INAC as no
 ... I VAL="D" D
 .... S $P(^BQICARE(NDZ,1,PN,15,PR,0),U,2)="Y"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"LIV")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="N"
 .... S PDA=$$ANF^BQIPLFL1(NDZ,PN,"INAC")
 .... I PDA'=-1 S $P(^BQICARE(NDZ,1,PN,15,PDA,0),U,2)="N"
 .. NEW OWNR,PLIEN
 .. S OWNR=NDZ,PLIEN=PN
 .. D DSC^BQIPLFL
 ;
 ; Convert any visit detail data
 D ^BQI22PSC
 ;Convert 90505 DEFAULT VIEW (.02) field to pointer to 90506.7 file
 N BUSER
 S BUSER=0 F  S BUSER=$O(^BQICARE(BUSER)) Q:'BUSER  D
 . N DA,BQIUPD,DFVW,NDFVW,ERROR
 . ;
 . ;Pull existing entry. Cannot use $$GET1^DIQ as current value may not be
 . ;a pointer to 90506.7 yet.
 . S DFVW=$P($G(^BQICARE(BUSER,0)),U,2) I DFVW?1N.N Q
 . S:DFVW="" DFVW="L"
 . S NDFVW=$O(^BQI(90506.7,"B",DFVW,"")) Q:NDFVW=""
 . S DA=BUSER,BQIUPD(90505,DA_",",.02)=NDFVW
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD,ERROR
 K BUSER
 ;
GPR ;Set up to compile GPRA for main view
 NEW DATA,II
 S II=0,DATA=$NA(^XTMP("BQIGPTOT")) K @DATA
 S @DATA@(II)=$$FMADD^XLFDT(DT,2)_U_$$DT^XLFDT()_U_"CRS Aggregate",II=II+1
 S @DATA@(II)="T00025REPORT_PERIOD^I00010TOTAL_PATIENTS^T00030CATEGORY^T00030CLIN_GROUP^I00010MEAS_IEN^"
 S @DATA@(II)=@DATA@(II)_"T00010NATIONAL_CURRENT^T00010YEAR_CURRENT^T00040INDICATOR^I00010NUMERATOR^"
 S @DATA@(II)=@DATA@(II)_"I00010DENOMINATOR^N00010PERCENT^T00001EXCEPTION^T00030HP_GOAL_2020"_$C(30)
 NEW X,Y,%DT
 S %DT="AEFR",%DT("A")="Enter Time to start Site CRS Aggregation Job: "
 ;S %DT("B")=$$FMTE^XLFDT(DT_".20")
 S %DT("B")="NOW"
 D ^%DT
 I X="NOW" S ZTDTH=$$FMADD^XLFDT(Y,,,3)
 E  S ZTDTH=Y
 S ZTDESC="CRS Aggregation",ZTRTN="COMP^BQIGPRA5",ZTIO=""
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,ZTDTH,ZTSK
 ;
 D ^BQISCHED
 ;
 ; Add new patient entries to 90506.1
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL
 F BI=1:1 S TEXT=$P($T(DEM+BI),";;",2) Q:TEXT=""  D
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
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90506.1,IEN_",",BN)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Re-Index File
 K ^BQI(90506.1,"AC"),^BQI(90506.1,"AD")
 NEW DIK
 S DIK="^BQI(90506.1,",DIK(1)=3.01
 D ENALL^DIK
 ;
TLT ;EP - Fix tooltips
 NEW TEXT,BQIUPD,ERROR,BI,BJ,HELP,IEN
 S IEN=1
 F BI=1:1 S TEXT=$P($T(JTIP+BI),";;",2) Q:TEXT=""  D
 . S HELP(BI)=TEXT
 D WP^DIE(90508,IEN_",",5,"","HELP","ERROR")
 K HELP
 F BI=1:1 S TEXT=$P($T(TTIP+BI),";;",2) Q:TEXT=""  D
 . S HELP(BI)=TEXT
 D WP^DIE(90508,IEN_",",6,"","HELP","ERROR")
 K HELP
 Q
 ;
JTIP ;
 ;;Weekly Job: Preset to run search logic once a week.  Applies search logic
 ;;for all search types to all RPMS patient data.
 ;; 
 ;;Nightly Job: Preset to run search logic each night on any new RPMS
 ;;visit data.
 ;; 
 ;;A Blank Job: Is a job that is recommended to be run at least once a
 ;;month or quarterly.
 ;; 
 ;;The Site Manager can change the frequency and time for any background
 ;;job.
 Q
TTIP ;
 ;;DX Tags: Identifies ("tags") patients with key chronic condition
 ;;categories.
 ;; 
 ;;Flags: Identifies any of 4 alerts related to Abnormal Labs, ER visits and
 ;;hospitalization for all patients.
 ;; 
 ;;Natl Measures: Updates status of GPRA and other National performance
 ;;measures for all patients.
 ;; 
 ;;Reminders: Updates PCC Health Maintenance and other key care management
 ;;(register) Reminder due/overdue data for all patients.
 ;; 
 ;;TX Prompts: Identifies appropriate Treatment Prompts for all patients.
 ;; 
 ;;Care Mgmt: At this time only Allergy data is updated for all patients.
 ;; 
 ;;CMET Data Mining:  Finds all CMET events and puts them in the 'Pending'
 ;;queue.
 ;; 
 ;;MU Performance:  Updates the MU Performance hospital and provider
 ;;measures.
 ;; 
 ;;MU Clinical Quality:  Updates the MU Clinical Quality provider measures
 ;;and later will update hospital measures.
 Q
 ;
DEM ;
 ;;0|BQETH^^Ethnicity^^^^^T00030BQETH~1|S VAL=$P($$ETHN^BQIPTDMG(DFN,.01),$C(28),2)~3|1^^Demographics^O^38~5|
 ;;0|BQRACE^^Race^^^^^T00030BQRACE~1|S VAL=$P($$RCE^BQIPTDMG(DFN,.01),$C(28),2)~3|1^^Demographics^O^37~5|
 ;;0|HMLOC^85^Location of Home^O^^^^T01024HMLOC^O^^^O^O~1|S VAL=$$HMLOC^BQIPTDDG(DFN)~3|1^^Address^O^41~5|
 ;;0|INSCOV^^Active Insurance Coverage^^^^^T01024INSCOV^^^^^^^125~1|S VAL=$$LYO^BQIPTINS(DFN)~3|1^^Other Patient Data^O^40~5|
 ;;0|ALGY^^Allergies^^^^^T01024ALGY^^^^^^^125~1|S VAL=$$ALG^BQIPTALG(DFN)~3|1^^Other Patient Data^O^39~5|
