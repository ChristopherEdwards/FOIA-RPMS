BQI23P4 ;VNGT/HS/ALA-Install Program v 2.3 Patch 4 ; 25 May 2011  7:31 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
PRE ; Pre-install
 NEW DA,DIK
 S DIK="^BQI(90506,",DA=0
 F  S DA=$O(^BQI(90506,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.3,",DA=0
 F  S DA=$O(^BQI(90506.3,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.5,",DA=0
 F  S DA=$O(^BQI(90506.5,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.9,",DA=0
 F  S DA=$O(^BQI(90506.9,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.71,",DA=0
 F  S DA=$O(^BQI(90506.71,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90507.1,",DA=0
 F  S DA=$O(^BQI(90507.1,DA)) Q:'DA  D ^DIK
 S DA=0,DIK="^BQI(90509.9,"
 F  S DA=$O(^BQI(90509.9,DA)) Q:'DA  D ^DIK
 ;
PF ; Fix 90506.4
 NEW DDATA
 S DDATA=$P($G(^DD(90509.4,.02,0)),U,3)
 I DDATA["M:MAIL" D
 . S N=0
 . F  S N=$O(^BQI(90509.4,N)) Q:'N  D
 .. I $P(^BQI(90509.4,N,0),U,3)="M" S $P(^BQI(90509.4,N,0),U,3)="L"
 .. I $P(^BQI(90509.4,N,0),U,2)="M" S $P(^BQI(90509.4,N,0),U,2)="L"
 ;
 Q
 ;
POS ; Post-Install
 ;
 ;Set the version number
 NEW DA
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="2.3.4.0"
 S BQIUPD(90508,DA_",",.09)="2.3.4.0"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW TAX,TXN,BQIUP
 S TAX="BQI PNUEMOCOCCAL DXS"
 S TXN=$O(^ATXAX("B",TAX,"")) I TXN'="" D
 . S BQIUP(9002226,TXN_",",.01)="BQI PNEUMOCOCCAL DXS"
 . D FILE^DIE("","BQIUP","ERROR")
 ;
 D ^BQIIPCFX
 ;
GLS ;EP Update glossary
 NEW GN,GNM,GSN,BQIUPD
 S GN=0
 F  S GN=$O(^BQI(90509.9,GN)) Q:'GN  D
 . S GNM=$P(^BQI(90509.9,GN,0),U,1)
 . S GSN=$O(^BQI(90508.2,"B",GNM,"")) Q:GSN=""
 . S BQIUPD(90508.2,GSN_",",1)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . M ^BQI(90508.2,GSN,1)=^BQI(90509.9,GN,1)
 ;
 ; Set BUSARPC into BQIRPC
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BUSARPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 ;
 ; Find divisions
 D FND^BQISYDIV
 ; Clean out immunizations
 NEW DA,DIK
 S DA=0,DA(1)=8,DIK="^BQI(90506.5,"_DA(1)_",10,"
 F  S DA=$O(^BQI(90506.5,8,10,DA)) Q:'DA  D ^DIK
 ;
 ; Set up immunizations
 NEW BN,CT,CD
 S BN=0,CT=0
 F  S BN=$O(^AUTTIMM(BN)) Q:'BN  D
 . I $P(^AUTTIMM(BN,0),U,7)=1 Q
 . S NM=$P(^AUTTIMM(BN,0),U,2)
 . S CT=CT+1
 . S CD="I_"_$E("0000",$L(CT),2)_CT
 . S ^BQI(90506.5,8,10,CT,0)=CD_"^8^"_NM_U_BN_"^D^D^^A"
 . S ^BQI(90506.5,8,10,"B",CD,CT)=""
 ;
 S ^BQI(90506.5,8,10,0)="^90506.51^"_CT_U_CT
 ;
 D ^BQI23PU3
 ;
HP ; Change HPV back to Cervical
 NEW IEN,BQIUPD
 F IEN=16 S BQIUPD(90621,IEN_",",.1)=2
 D FILE^DIE("","BQIUPD","ERROR")
 NEW IEN,EVT,BQIUPD
 F EVT=16 D
 . S IEN=""
 . F  S IEN=$O(^BTPWQ("B",EVT,IEN)) Q:IEN=""  S BQIUPD(90629,IEN_",",.13)=2
 . F  S IEN=$O(^BTPWP("B",EVT,IEN)) Q:IEN=""  S BQIUPD(90620,IEN_",",.12)=2
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
MU ; Run MU Provider data for first Monthly periods
 NEW CDTM,CURR,BI
 S CURR=$P($G(^BQI(90508,1,9)),U,3)
 I CURR="" D
 . ; Clean up old data
 . S PRV=0 F  S PRV=$O(^BQIPROV(PRV)) Q:'PRV  K ^BQIPROV(PRV,10),^BQIPROV(PRV,20),^BQIPROV(PRV,40),^BQIPROV("AC")
 . S FAC=$$HME^BQIGPUTL() I FAC'="" K ^BQIFAC(FAC,10),^BQIFAC(FAC,20),^BQIFAC(FAC,40),^BQIFAC("AC")
 . ;
 . D
 .. S ^XTMP("BQIMMONP",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Month list"
 .. S CDTM=$E(DT,4,5)
 .. I $E(DT,1,3)=313 F BI=1:1:CDTM S ^XTMP("BQIMMONP","313"_$S(BI<10:"0"_BI,1:BI)_"01")="" Q
 .. I $E(DT,1,3)=314 D
 ... F BI=1:1:12 S ^XTMP("BQIMMONP","313"_$S(BI<10:"0"_BI,1:BI)_"01")=""
 ... F BI=1:1:CDTM S ^XTMP("BQIMMONP","314"_$S(BI<10:"0"_BI,1:BI)_"01")=""
 . D EN^BQIMUUPD
 ; Fix CQ data by division
 D P3^BQIMUUPD
 ; update any missing months
 NEW PROV,DTN,BQDATE,ID
 S PROV=0
 F  S PROV=$O(^BQIPROV(PROV)) Q:'PROV  D
 . S DTN=0 F  S DTN=$O(^BQIPROV(PROV,50,DTN)) Q:'DTN  D
 .. S BQDATE=$P(^BQIPROV(PROV,50,DTN,0),"^",1),ID=$O(^BQIPROV(PROV,50,DTN,1,1))
 .. I $G(^XTMP("BQIMMON",0))="" S ^XTMP("BQIMMON",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Month list"
 .. I 'ID S ^XTMP("BQIMMON",BQDATE)=""
 ;
RSC ; Remove the scheduled tasks
 NEW RPC,OPTN,OPN,LIST,ZTSK
 F RPC="BQI UPDATE MEAN USE 1 YEAR","BQI UPDATE MEAN USE 90 DAYS" D
 . S OPTN=$$FIND^BQISCHED(RPC)
 . I OPTN'>0 Q
 . S OPN=$O(^DIC(19.2,"B",OPTN,""))
 . I OPN'="" D
 .. NEW DA,DIK
 .. S DIK="^DIC(19.2,",DA=OPN D ^DIK
 . NEW DA,DIK
 . S DA=OPTN,DIK="^DIC(19," D ^DIK
 . K LIST
 . D OPTION^%ZTLOAD(RPC,.LIST)
 . S ZTSK=""
 . F  S ZTSK=$O(@LIST@(ZTSK)) Q:ZTSK=""  D
 .. D PCLEAR^%ZTLOAD(ZTSK)
 .. D KILL^%ZTLOAD
 S $P(^BQI(90508,1,12),"^",4)=0,$P(^BQI(90508,1,12),"^",6)=""
 D NJBY^BQINIGH3
 ;
 ; Turn on and export MU data
 S BQIUPD(90508,"1,",.07)="@"
 S BQIUPD(90508,"1,",.25)=1
 D FILE^DIE("","BQIUPD","ERROR")
 D EN^BQIMUEXP(1)
 D HOS^BQIMUEXP(1)
 ;I '$$PROD^XUPROD() D
 ;. S BQIUPD(90508,"1,",.07)=1
 ;. D FILE^DIE("","BQIUPD","ERROR")
 ;
PER ; Check for Persistent
 NEW BI,OPT,OPTION,OPTN,DA
 F BI=1:1 S OPT=$P($T(TSK+BI^BQISCHED)," ;;",2,99) Q:OPT=""  D
 . S OPTION=$P(OPT,U,1) I OPTION'["UPDATE" Q
 . S OPTN=$$FIND^BQISCHED(OPTION) Q:OPTN'>0
 . S DA=$O(^DIC(19.2,"B",OPTN,"")) I DA'="" D  Q
 .. I $P(^DIC(19.2,DA,0),U,9)'="SP" Q
 .. S BQIUPD(19.2,DA_",",9)="P"
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
CLN ; Clean up old notifications greater than 2 years old
 NEW DZ,DIK,DA,NN,DATE,NDATE
 S DZ=0,DATE=$$DATE^BQIUL1("T-24M")
 F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  D
 . S NN=0
 . F  S NN=$O(^BQICARE(DZ,3,NN)) Q:'NN  D
 .. S NDATE=$P(^BQICARE(DZ,3,NN,0),U,1)\1
 .. I NDATE>DATE Q
 .. S DA(1)=DZ,DA=NN,DIK="^BQICARE("_DA(1)_",3," D ^DIK
 ;
TX ; Fix iCare NDC taxonomies to point to 50.67 instead of 2
 NEW TAX,DA,BQUP
 F TAX="BKM TB MED NDCS","BKMV EI MED NDCS","BKMV II MED NDCS","BKMV MAC PROPH MED NDCS" D UP
 F TAX="BKMV NNRTI MED NDCS","BKMV NRTI COMBO MED NDCS","BKMV NRTI MED NDCS","BKMV NRTI/NNRTI MED NDCS" D UP
 F TAX="BKMV PCP PROPH MED NDCS","BKMV PI BOOSTER MED NDCS","BKMV PI MED NDCS","BQI STATIN NDC" D UP
 D FILE^DIE("","BQUP","ERROR")
 ;
APT ; Update Appointment to APRANGE
 NEW DZ,PL,PN,MN,QFL,NVALUE
 S DZ=0
 F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  D
 . ; Update MU view
 . NEW MUV,NMV
 . S MUV=$$GET1^DIQ(90505,DZ_",",.16,"I")
 . S NMV=$$FIND1^DIC(90506.71,,"X",MUV,"B","","ERROR")
 . S BQIUPD(90505,DZ_",",14.01)=$S(NMV'=0:NMV,1:"@")
 . S PL=0
 . F  S PL=$O(^BQICARE(DZ,1,PL)) Q:'PL  D
 .. S SOURCE=$P(^BQICARE(DZ,1,PL,0),U,11)
 .. I SOURCE["APPT" D
 ... S PN=$O(^BQICARE(DZ,1,PL,10,"B","APRANGE","")) I PN'="" Q
 ... S PN=$O(^BQICARE(DZ,1,PL,10,"B","RFROM","")) D
 .... I PN="" Q
 .... S PN1=PN,PN2=$O(^BQICARE(DZ,1,PL,10,"B","RTHRU","")) I PN2="" Q
 .... NEW DA,IENS,VN,DA,IENS2,VALUE2
 .... S DA(2)=DZ,DA(1)=PL,DA=PN1,IENS=$$IENS^DILF(.DA)
 .... S VALUE=$$GET1^DIQ(90505.02,IENS,.02,"E")
 .... I VALUE'["T-",VALUE'="T",VALUE'["T+" Q
 .... S DA(2)=DZ,DA(1)=PL,DA=PN2,IENS2=$$IENS^DILF(.DA)
 .... S VALUE2=$$GET1^DIQ(90505.02,IENS2,.02,"E")
 .... S VN=""
 .... F  S VN=$O(^BQI(90506.9,"F",VALUE,VN)) Q:VN=""  D
 ..... I '$D(^BQI(90506.9,VN,1,"B","APRANGE")) Q
 ..... I $P(^BQI(90506.9,VN,0),"^",3)'=VALUE!($P(^(0),"^",4)'=VALUE2) Q
 ..... S BQIUPD(90505.02,IENS,.01)="APRANGE"
 ..... S BQIUPD(90505.02,IENS,.02)=$P(^BQI(90506.9,VN,0),U,1)
 .... S DA(2)=DZ,DA(1)=PL,DA=PN2
 .... S DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",10,"
 .... D ^DIK
 ... I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 .. I SOURCE["ASSIGN" D
 ... S PN=$O(^BQICARE(DZ,1,PL,10,"B","PTMFRAME",""))
 ... I PN'="" D
 .... NEW DA,IENS,VN
 .... S DA(2)=DZ,DA(1)=PL,DA=PN,IENS=$$IENS^DILF(.DA)
 .... S VALUE=$$GET1^DIQ(90505.02,IENS,.02,"E") I VALUE'["T-",VALUE'["T+",VALUE'="T" Q
 .... S VN=$O(^BQI(90506.9,"E",VALUE,"")) I VN="" Q
 .... S BQIUPD(90505.02,IENS,.02)=$P(^BQI(90506.9,VN,0),U,1)
 ... S PN=$O(^BQICARE(DZ,1,PL,10,"B","PSTMFRAM",""))
 ... I PN'="" D
 .... NEW DA,IENS,VN
 .... S DA(2)=DZ,DA(1)=PL,DA=PN,IENS=$$IENS^DILF(.DA)
 .... S VALUE=$$GET1^DIQ(90505.02,IENS,.02,"E") I VALUE'["T-",VALUE'["T+",VALUE'="T" Q
 .... S VN=$O(^BQI(90506.9,"E",VALUE,"")) I VN="" Q
 .... S BQIUPD(90505.02,IENS,.02)=$P(^BQI(90506.9,VN,0),U,1)
 ... S PN=$O(^BQICARE(DZ,1,PL,10,"B","SPEC",""))
 ... I PN'="" D
 .... I $P(^BQICARE(DZ,1,PL,10,PN,0),U,2)'="",$P(^(0),U,3)="" S $P(^BQICARE(DZ,1,PL,10,PN,0),U,3)=$P(^(0),U,2)
 . ;
 . S MN=0
 . F  S MN=$O(^BQICARE(DZ,7,MN)) Q:'MN  D
 .. S PN=0
 .. F  S PN=$O(^BQICARE(DZ,7,MN,10,PN)) Q:'PN  D
 ... I $P(^BQICARE(DZ,7,MN,10,PN,0),U,1)'="TMFRAME" Q
 ... S VALUE=$P(^BQICARE(DZ,7,MN,10,PN,0),U,2) I VALUE'["T-",VALUE'["T+",VALUE'="T" Q
 ... S TN="",QFL=0 F  S TN=$O(^BQI(90506.9,"C","TMFRAME",TN)) Q:TN=""  D  Q:QFL
 .... I $P(^BQI(90506.9,TN,0),U,3)=VALUE S NVALUE=$P(^BQI(90506.9,TN,0),U,1),QFL=1
 .... ;S NVALUE=$P(^BQI(90506.9,TN,0),U,3),QFL=1
 ... NEW DA,IENS
 ... S DA(2)=DZ,DA(1)=MN,DA=PN,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.08,IENS,.02)=NVALUE
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 NEW DA,BI,WORD
 S DA=$O(^BQI(90508,0))
 K ^BQI(90508,DA,5),^BQI(90508,DA,6),^BQI(90508,DA,7)
 F BI=1:1 S TEXT=$P($T(TP5+BI),";;",2) Q:TEXT=""  S WORD(BI)=TEXT
 D WP^DIE(90508,DA_",",5,"","WORD","ERROR") K WORD
 F BI=1:1 S TEXT=$P($T(TP6+BI),";;",2) Q:TEXT=""  S WORD(BI)=TEXT
 D WP^DIE(90508,DA_",",6,"","WORD","ERROR") K WORD
 F BI=1:1 S TEXT=$P($T(TP7+BI),";;",2) Q:TEXT=""  S WORD(BI)=TEXT
 D WP^DIE(90508,DA_",",7,"","WORD","ERROR") K WORD
 ;
 D PDESC
 Q
 ;
UP ;EP
 S DA=$O(^ATXAX("B",TAX,"")) I DA="" Q
 S BQUP(9002226,DA_",",.15)=50.57
 Q
 ;
PDESC ;EP - Regenerate Panel Descriptions
 NEW USER,PLIEN
 S USER=0 F  S USER=$O(^BQICARE(USER)) Q:'USER  D
 . S PLIEN=0 F  S PLIEN=$O(^BQICARE(USER,1,PLIEN)) Q:'PLIEN  D
 .. NEW DESC,DA,IENS
 .. S DA(1)=USER,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. D DESC^BQIPDSCM(USER,PLIEN,.DESC)
 .. D WP^DIE(90505.01,IENS,5,"","DESC")
 .. K DESC
 Q
 ;
TP5 ;tooltip update
 ;;Weekly Job: Preset to run search logic once a week.  Applies search logic
 ;;to all RPMS patients data.
 ;; 
 ;;Nightly Job: Preset to run search logic each night on any new RPMS
 ;;visit data.
 ;; 
 ;;Monthly Job: Preset to run every month. Currently this would be around
 ;;the first of the month and the jobs are started by the Nightly Job.
 ;; 
 ;;The Site Manager can change the frequency and time for any background
 ;;Job except the Monthly jobs.
 Q
 ;
TP6 ;tooltip update
 ;;IPC Update: Calculates the IPC measures for all primary care providers
 ;;for a one month timeframe.
 ;; 
 ;;MU Clinical Quality: Calculates the MU Clinical Quality Measure for
 ;;providers who have been identified in the MU Site Parameters for a one
 ;;month timeframe.
 ;; 
 ;;MU Performance: Calculates the MU Performance Measures for providers
 ;;who have been identified in the MU Site Parameters for a one month
 ;;timeframe.
 ;; 
 ;;Best Practice Prompts: Identifies appropriate Best Practice Prompts for
 ;;patients.
 ;; 
 ;;Best Practice Prompts: Identifies appropriate Best Practice Prompts for
 ;;patients.
 ;; 
 ;;Care Mgmt: Updates Allergy, COPD, and Diabetes data for the Care Mgmt tab
 ;;for all patients.
 ;; 
 ;;CMET Data Mining: Finds all CMET events and puts them in the 'Pending'
 ;;queue.
 ;; 
 ;;Comm Alerts: Identifies patients who have a specific condition.
 ;; 
 ;;DX Tags: Identifies ("tags") patients with key chronic condition
 ;;categories.
 ;; 
 ;;Flags: Identifies any of 4 alerts related to Abnormal Labs, ER visits and
 ;;hospitalization for all patients.
 ;; 
 ;;Natl Measures: Updates status of GPRA and other National performance
 ;;measures for all patients.
 ;; 
 ;;Panel Autopopulate: Updates all panels who have been identified as
 ;;Automatic nightly updates.  This is the final portion of the Nightly
 ;;Job. It locks those panels until completed.
 ;; 
 ;;Reminders: Updates PCC Health Maintenance, EHR Clinical Reminders and
 ;;other key care management (HMS and CMET) Reminders due/overdue data for
 ;;all patients.
 Q
 ;
TP7 ;tooltip update
 ;;The End date and time of the most recent job type.
 ;; 
 ;;If the End date is older than the Start date, the job may still be
 ;;running, OR it may have "errored out", OR the system may have been
 ;;restarted.  You may need to consult your Site Manager to check the
 ;;error log to make sure there is no error.
 Q
