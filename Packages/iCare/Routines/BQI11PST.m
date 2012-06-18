BQI11PST ;PRXM/HC/ALA-Version 1.1 Post-Install ; 30 May 2007  5:19 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ;EP
 ;
 ;  Set up the parameters file with the default location
 NEW BGPHOME,BGPHN,BQIDA,FD,BGDATA,IDIN
 S BGPHN=$O(^BGPSITE(0)) S:BGPHN BGPHOME=$P($G(^BGPSITE(BGPHN,0)),U,1)
 Q:$G(BGPHOME)=""
 S BQIDA=1
 S BQIUPD(90508,BQIDA_",",.01)=BGPHOME
 S BQIUPD(90508,BQIDA_",",1)=$G(^XTMP("BQICARE","VISIT"))
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ; Check for missing node zeros from NPT^BQITASK error
 S BQIN=0
 F  S BQIN=$O(^BQIPAT(BQIN)) Q:'BQIN  I $G(^BQIPAT(BQIN,0))="" S ^BQIPAT(BQIN,0)=BQIN,^BQIPAT("B",BQIN,BQIN)=""
 ;
 ; if iCare hasn't been installed before, set up initial information
 I $G(^XTMP("BQICARE",0))=0 D
 . ; Reset all date started/stopped values
 . F FD=.02,.03,.04,.05,.06,.07,.15,.16,1.01,1.02,1.03,1.04,1.05,1.06,1.07,1.08 S BQIUPD(90508,BQIDA_",",FD)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . ;  Set the last visit IEN
 . S BQIUPD(90508,BQIDA_",",1)=$O(^AUPNVSIT("A"),-1)
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 . ; Set up the taxonomies
 . D LTAX
 . ; Set up the 'ALL REMINDERS' list
 . D REM
 . ;  Set up initial program to populate BQIPAT
 . S ZTDESC="ICARE TAG PROGRAM",ZTRTN="ENT^BQI1POJB",ZTIO=""
 . S JBNOW=$$NOW^XLFDT()
 . S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 . S ZTDTH=JBDATE_".20"
 . D ^%ZTLOAD
 . NEW DA,IENS
 . S DA=BQIDA,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90508,IENS,.1)=ZTSK
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK,BQIGDA,N,ERROR
 K BQIINDG,^XTMP("BQICARE")
 ;
 ; For Version 1.1
 D LTAX
 ; Add Taxonomy short descriptions
 NEW TEXT,TAX,DESC,TIEN,BQIUPD,ERROR
 F I=1:1 S TEXT=$P($T(TDSC+I),";;",1) Q:TEXT=""  D
 . S TAX=$P(TEXT,U,1),DESC=$P(TEXT,U,2)
 . S TIEN=$$FIND1^DIC(9002226,"","B",TAX,"","","ERROR")
 . S BQIUPD(9002226,TIEN_",",.02)=DESC
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; For existing sites
 I $O(^BQICARE(0))'="" D
 . D PDSC
 . ; Check for new CRS version
 . NEW BQIH,OBQIYR,NBQIYR
 . S BQIH=$$SPM^BQIGPUTL()
 . S OBQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 . D GCHK^BQIGPUPD(1)
 . S BQIH=$$SPM^BQIGPUTL()
 . S NBQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 . I OBQIYR=NBQIYR Q
 . ;  Set up TaskMan to reset GPRA data
 . NEW ZTDESC,ZTRTN,ZTIO,JBNOW,ZTDTH,ZTSK
 . S ZTDESC="ICARE RESET DATA",ZTRTN="FGP^BQI11PST",ZTIO=""
 . S JBNOW=$$NOW^XLFDT()
 . S ZTDTH=$$FMADD^XLFDT(JBNOW,,,3)
 . D ^%ZTLOAD
 ;
 ;Set the version number
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="1.1.29"
 S BQIUPD(90508,DA_",",.09)="1.1T29"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ; Update the reminders view entries
 D UPV
 ;
 ; Set up to initialize reminders
 S ZTDESC="ICARE REMINDERS CALCULATE",ZTRTN="EN^BQITASK1",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20"
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 ;
 ; Check if patch 1 was installed, if not, need to kill CVD tags
 ; and recalculate
 I '$$PATCH^XPDUTL("BQI*1.0*1") D
 . NEW DA,DIK,DFN
 . S DFN=0
 . F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 .. S DA(1)=DFN,DA=6,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 . ;
 . ; Set up task to run to regenerate Dx Categories
 . NEW ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 . S ZTDESC="ICARE DX CAT PROGRAM",ZTRTN="DXC^BQITASK2",ZTIO=""
 . S JBNOW=$$NOW^XLFDT()
 . S JBDATE=$S($E($P(JBNOW,".",2),1,2)<18:DT,1:$$FMADD^XLFDT(DT,+1))
 . S ZTDTH=JBDATE_".18"
 . D ^%ZTLOAD
 . K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 ;
 ; Set up TaskMan jobs, if they haven't already been set up
 D ^BQISCHED
 ;
ML ;EP - Check for bad pointers in Location file
 NEW LOC,AREA,SU,CT,XMY,XMZ,XMFROM
 K ^TMP("BQIMAIL",$J)
 S LOC=0,CT=0
 F  S LOC=$O(^AUTTLOC(LOC)) Q:'LOC  D
 . I $P(^AUTTLOC(LOC,0),"^",21)'="" Q
 . S AREA=$P(^AUTTLOC(LOC,0),"^",4)
 . S SU=$P(^AUTTLOC(LOC,0),"^",5)
 . I SU'="",$$GET1^DIQ(9999999.22,SU_",",.01,"E")="" D
 .. S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)="Location: "_$P(^DIC(4,LOC,0),U,1)_" has a bad Service Unit pointer."
 . I AREA'="",$$GET1^DIQ(9999999.21,AREA_",",.01,"E")="" D
 .. S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)="Location: "_$P(^DIC(4,LOC,0),U,1)_" has a bad Area pointer."
 ;
 I $D(^TMP("BQIMAIL",$J))>0 D
 . S CT=CT+1,^TMP("BQIMAIL",$J,CT,0)=" "
 . S XMSUB="iCare Install Problem",XMFROM="iCare Install"
 . S XMTEXT="^TMP(""BQIMAIL"",$J,"
 . I $G(DUZ)'="" S XMDUZ=DUZ,XMY(DUZ)=""
 . I $G(DUZ)="" S XMDUZ="iCare Install"
 . S XMY(DUZ)=""
 . I '$D(XMY) S XMY(.5)=""
 . D ^XMD
 . K XMSUB,XMTEXT,XMY,XMDUZ,XMZ,XMFROM
 Q
 ;
FGP ;EP - Fix the GPRA layouts in existing panels
 NEW OWNR,PLIEN,LIEN,VAL,NVAL,SHR,DFN
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 .. NEW DA,IENS,BQIYR,BQIH,BQIY
 .. S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. S BQIYR=$$GET1^DIQ(90505.01,IENS,3.3,"E")
 .. S BQIH=$$SPM^BQIGPUTL()
 .. I BQIYR="" S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 .. S LIEN=0
 .. F  S LIEN=$O(^BQICARE(OWNR,1,PLIEN,25,LIEN)) Q:'LIEN  D
 ... S VAL=$P(^BQICARE(OWNR,1,PLIEN,25,LIEN,0),U,1)
 ... I VAL'?.N Q
 ... S NVAL=BQIYR_"_"_VAL
 ... S DA(2)=OWNR,DA(1)=PLIEN,DA=LIEN,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.125,IENS,.01)=NVAL
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 .. ;
 .. ;  Fix existing GPRA layouts for Share users
 .. S SHR=0
 .. F  S SHR=$O(^BQICARE(OWNR,1,PLIEN,30,SHR)) Q:'SHR  D
 ... S LIEN=0
 ... F  S LIEN=$O(^BQICARE(OWNR,1,PLIEN,30,SHR,25,LIEN)) Q:'LIEN  D
 .... S VAL=$P(^BQICARE(OWNR,1,PLIEN,30,SHR,25,LIEN,0),U,1)
 .... I VAL'?.N Q
 .... S NVAL=BQIYR_"_"_VAL
 .... S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=SHR,DA=LIEN,IENS=$$IENS^DILF(.DA)
 .... S BQIUPD(90505.325,IENS,.01)=NVAL
 ... D FILE^DIE("","BQIUPD","ERROR")
 ... K BQIUPD
 ;
 ;  Fix patient's GPRA references
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  D
 . S BQIYR=$P(^BQIPAT(DFN,0),U,2)
 . I BQIYR="" D
 .. S BQIH=$$SPM^BQIGPUTL()
 .. S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 . S IEN=0
 . F  S IEN=$O(^BQIPAT(DFN,30,IEN)) Q:'IEN  D
 .. S VAL=$P(^BQIPAT(DFN,30,IEN,0),U,1)
 .. I VAL'?.N Q
 .. S DA(1)=DFN,DA=IEN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90507.53,IENS,.01)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 ;
 Q
 ;
PDSC ;EP - Load revised generated descriptions for all panels
 ;
 NEW OWNR,PLIEN
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . S PLIEN=0
 . F  S PLIEN=$O(^BQICARE(OWNR,1,PLIEN)) Q:'PLIEN  D
 .. NEW DA,IENS
 .. S DA(1)=OWNR,DA=PLIEN,IENS=$$IENS^DILF(.DA)
 .. K DESC
 .. D PEN^BQIPLDSC(OWNR,PLIEN,.DESC)
 .. D WP^DIE(90505.01,IENS,5,"","DESC")
 .. K DESC,BMXSEC
 Q
 ;
UPV ;EP - Update the pointers for reminder views
 NEW IEN,NAME,CODE,HIEN,HTAG,BQIUPD,IMN,TAG,NCODE,INAME
 S IEN=""
RM ; EP
 S IEN=$O(^BQI(90506.1,"AC","R",IEN)) G EXT:IEN=""
 S NAME=$P(^BQI(90506.1,IEN,0),"^",3)
 S CODE=$P(^BQI(90506.1,IEN,0),"^",1)
 S HIEN=$P(CODE,"_",2),HTAG=$P(CODE,"_",1)
 ;
 ; If it's an immunization
 I HTAG="AUTTIMM" D IMM G RM
 ; If it's not an immunization
 S IMN=$O(^APCHSURV("B",NAME,"")) I IMN="" G RM
 S TAG=$P($P(^APCHSURV(IMN,0),"^",2),";",1)
 I HIEN=IMN,HTAG=TAG D  G RM
 . I $P(^APCHSURV(IMN,0),"^",3)'=1 D INA
 S NCODE=HTAG_"_"_IMN
 S BQIUPD(90506.1,IEN_",",.01)=NCODE
 I $P(^APCHSURV(IMN,0),"^",3)'=1 D INA
 G RM
 ;
INA ;EP - Inactivate
 S BQIUPD(90506.1,IEN_",",.1)=1
 S BQIUPD(90506.1,IEN_",",.11)=DT
 Q
 ;
EXT ;EP - Store updates
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;D CHK^BQIRMDR
 Q
 ;
IMM ;EP - Fix Immunization Reminders
 S INAME=$P($G(^AUTTIMM(HIEN,0)),"^",2)
 I INAME=NAME Q
 S IMN=$O(^AUTTIMM("AC",NAME,"")) Q:IMN=""
 S NCODE=HTAG_"_"_IMN
 S BQIUPD(90506.1,IEN_",",.01)=NCODE
 I $G(BQIUPD(90506.1,IEN_",",.1))=1 K BQIUPD(90506.1,IEN_",",.1),BQIUPD(90506.1,IEN_",",.11)
 Q
 ;
REM ;EP - Set up the 'ALL REMINDERS' Patient Health Summary Definition
 I '$$FIND1^DIC(9001015,"","","ALL REMINDERS","B","","") D
 . N X,Y,DA,DR,DIC,DLAYGO,CMPNDX,REMNDX
 . ;
 . ; Create top level for 'ALL REMINDERS' Hlth Summary
 . S X="ALL REMINDERS",DIC(0)="LZ",DLAYGO=9001015,DIC="^APCHSCTL("
 . K DO,DD D FILE^DICN
 . ;
 . ; Build Sort Order Sub-File
 . N DIC,DA,DIE,DR,X,BQIUPD
 . S DLAYGO=9001015.01
 . S (DA(1),REMNDX)=+Y,DA=10,DIC(0)="LZ",DIC="^APCHSCTL("_DA(1)_",1,"
 . K DO,DD D FILE^DICN
 . ;
 . ; Add Component IEN for Reminders (from 9001016) to Hlth Summary
 . S CMPNDX=$$FIND1^DIC(9001016,"","","HEALTH MAINTENANCE REMINDERS","B","","")
 . Q:'CMPNDX
 . S DA(1)=REMNDX,DA=10,DIE=DIC
 . S DR=".01///"_DA_";1////"_CMPNDX
 . D ^DIE
 . ;
 . ; Build Health Summary nodes.
 . N DIC,DA,NDX,NDX2,RMNDR,X,Y,DR
 . S DA(1)=REMNDX,DLAYGO=9001015.06,DIC(0)="LZ"
 . S DIC="^APCHSCTL("_DA(1)_",5,"
 . K DO,DD D FILE^DICN
 . S NDX=""
 . F  S NDX=$O(^APCHSURV("AC",NDX)) Q:NDX=""  D
 .. S RMNDR=""
 .. F  S RMNDR=$O(^APCHSURV("AC",NDX,RMNDR)) Q:RMNDR=""  D
 ... I $$GET1^DIQ(9001018,RMNDR,.03,"I")'="D" D
 .... S (DA,NDX2)=(NDX*100)+RMNDR,DIE=DIC
 .... S DR=".01///"_NDX2_";1////"_RMNDR
 .... D ^DIE
 .... Q
 ;
LTAX ;EP - Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX,D0,DINUM
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies
 D LDLAB(.LTAX)
 F BJ=1:1 Q:'$D(LTAX(BJ))  S X=LTAX(BJ) D
 . I $D(^ATXLAB("B",X)) D STXPT(X,"L") Q  ; Skip pre-existing Lab taxonomies
 . D ^DIC S DA=+Y
 . I DA<1 Q
 . S BQTXUP(9002228,DA_",",.02)=$P(X," ",2,999)
 . S BQTXUP(9002228,DA_",",.05)=DUZ
 . S BQTXUP(9002228,DA_",",.06)=DT
 . S BQTXUP(9002228,DA_",",.09)=60
 . D FILE^DIE("I","BQTXUP")
 . S BQTXUP(9002228,DA_",",.08)="B"
 . D FILE^DIE("E","BQTXUP")
 . D STXPT(X,"L")
 ;
 K DA,BJ,BQTXUP,DIC,DLAYGO,DINUM,D0,DR,X,Y
 ;
TAX ;EP - Set up the taxonomies
 ;
 D ^BQITX
 D ^BQIATX
 ;
 ; Reset the variable pointer values for the taxonomies
 S N=0
 F  S N=$O(^BQI(90508,BQIDA,10,N)) Q:'N  D
 . S X=$P(^BQI(90508,BQIDA,10,N,0),U,1)
 . I $P(^BQI(90508,BQIDA,10,N,0),U,3)=5 D STXPT(X,"L") Q
 . D STXPT(X,"N")
 ;
 ; Reindex the site parameter file
 NEW DIK
 S DIK="^BQI(90508," D IXALL^DIK
 ;
 ; Check taxonomies
 NEW IEN,PRGM,X
 S IEN=0
 F  S IEN=$O(^BQI(90508,BQIDA,10,IEN)) Q:'IEN  D
 . I $P(^BQI(90508,BQIDA,10,IEN,0),U,2)'="" Q
 . I $P(^BQI(90508,BQIDA,10,IEN,0),U,3)=5 Q
 . S PRGM=U_$P(^BQI(90508,BQIDA,10,IEN,0),U,6) I PRGM="^" Q
 . D @PRGM
 . S X=$P(^BQI(90508,BQIDA,10,IEN,0),U,1)
 . D STXPT(X,"N")
 ;
JRN ; EP - Turn off journaling for BQIPAT
 NEW %,DIR
 S %=$$NOJOURN^ZIBGCHAR("BQIPAT")
 I % D
 . W !!,"Attempt to turn off journaling for global ^BQIPAT failed because "
 . W !?5,$$ERR^ZIBGCHAR(%)
 . W !,"Please notify the OIT Help Desk for assistance."
 . S DIR(0)="E" D ^DIR
 Q
 ;
STXPT(TXNM,TYP) ; EP - Set taxonomy pointer into Site Parameter file
 ;
 ;Input
 ;  TXNM - Taxonomy name
 ;  TYP  - Taxonomy Type (L = LAB, N = Non Lab)
 NEW IEN,SIEN,DA,IENS,BQUPD,VALUE,GLB
 I TYP="L" D
 . S IEN=$O(^ATXLAB("B",TXNM,"")),GLB="ATXLAB("
 . I IEN="" S TYP="N"
 I TYP="N" S IEN=$O(^ATXAX("B",TXNM,"")),GLB="ATXAX("
 I IEN="" S VALUE="@"
 I IEN'="" S VALUE=IEN_";"_GLB
 S SIEN=$O(^BQI(90508,BQIDA,10,"B",TXNM,""))
 S DA(1)=BQIDA,DA=SIEN,IENS=$$IENS^DILF(.DA)
 S BQUPD(90508.03,IENS,.02)=VALUE
 D FILE^DIE("","BQUPD","ERROR")
 Q
 ;
LDLAB(ARRAY) ;EP - Load site-populated Lab tests
 NEW I,TEXT
 F I=1:1 S TEXT=$P($T(LAB+I),";;",2) Q:TEXT=""  S ARRAY(I)=TEXT
 Q
 ;
LAB ;EP;LAB TESTS (SITE-POPULATED)
 ;;BGP GPRA ESTIMATED GFR TAX
 ;;DM AUDIT CHOLESTEROL TAX
 ;;DM AUDIT CREATININE TAX
 ;;DM AUDIT HDL TAX
 ;;DM AUDIT LDL CHOLESTEROL TAX
 ;;DM AUDIT TRIGLYCERIDE TAX
 ;;DM AUDIT FASTING GLUCOSE TESTS
 ;;
 ;
TDSC ; Fix Taxonomy Descriptions
 ;;BQI KNOWN CVD-1 CPTS^1 only identifies Known CVD
 ;;BQI KNOWN CVD-MULT CPTS^Multiple identify Known CVD
 ;;BQI HYPERLIPIDEMIA DXS^Hyperlipidemia Dxs
 ;;BQI IHD DXS^Ischemic Heart Disease Dxs
 ;;BQI KNOWN CVD-1 DXS^1 only identifies Known CVD
 ;;BQI KNOWN CVD-MULT DXS^Multiple identify Known CVD
 ;;BQI KNOWN CVD-1 PROCEDURES^1 only identifies Known CVD
 ;;BQI KNOWN CVD-MULT PROCEDURES^Multiple identify Known CVD
 ;;BQI STATIN NDC^Statin med NDCs
 ;;BQI STATIN MEDS CLASS^Statin med Class Codes
 ;;
