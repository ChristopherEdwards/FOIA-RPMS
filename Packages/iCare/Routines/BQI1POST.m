BQI1POST    ;PRXM/HC/DLS - BQI Post Installation Routine ; 23 Mar 2006  4:10 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
 ;**Program Description**
 ;    This is the post-installation program to set up values for the
 ;    iCARE System
 ;
EN ;  EP - BQI Post Install
 ;
 ;  Set up the parameters file with the default location
 NEW BGPHOME,BGPHN,BQIDA,FD,BGDATA,IDIN
 S BGPHN=$O(^BGPSITE(0)) S:BGPHN BGPHOME=$P($G(^BGPSITE(BGPHN,0)),U,1)
 Q:$G(BGPHOME)=""
 S BQIDA=1
 S BQIUPD(90508,BQIDA_",",.01)=BGPHOME
 F FD=.02,.03,.04,.05,.06,.07,1.01,1.02 S BQIUPD(90508,BQIDA_",",FD)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ;  Add the GPRA information to the site parameters if 2007 has been installed
 ;  removed 3/15/2007 ALA
 ;I $$VERSION^XPDUTL("BGP")="7.0" D
 ;. D EN^BQIGPUPD("2007","90530.01","90530.02","BGP7D10",1)
 ;
VIS ;  Set the last visit IEN
 S BQIUPD(90508,BQIDA_",",1)=$O(^AUPNVSIT("A"),-1)
 D FILE^DIE("","BQIUPD","ERROR")
 ;
REM ; Set up the 'ALL REMINDERS' Patient Health Summary Definition
 I '$$FIND1^DIC(9001015,"","","ALL REMINDERS","B","","") D
 . N X,Y,DA,DR,DIC,DLAYGO,CMPNDX,REMNDX
 . ;
 . ; Create top level for 'ALL REMINDERS' Hlth Summary
 . S X="ALL REMINDERS",DIC(0)="LZ",DLAYGO=9001015,DIC="^APCHSCTL("
 . D FILE^DICN
 . ;
 . ; Build Sort Order Sub-File
 . N DIC,DA,DIE,DR,X,BQIUPD
 . S DLAYGO=9001015.01
 . S (DA(1),REMNDX)=+Y,DA=10,DIC(0)="LZ",DIC="^APCHSCTL("_DA(1)_",1,"
 . D FILE^DICN
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
 . D FILE^DICN
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
LTAX ;  Add Lab Taxonomies to ^ATXLAB
 NEW X,DIC,DLAYGO,DA,DR,DIE,Y,LTAX,D0,DINUM
 S DIC="^ATXLAB(",DIC(0)="L",DLAYGO=9002228
 ; Loop through the Taxonomies as stored in routine BKMVTAX4.
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
TAX ;  Set up the taxonomies
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
 . S PRGM=U_$P(^BQI(90508,BQIDA,10,IEN,0),U,6)
 . D @PRGM
 . S X=$P(^BQI(90508,BQIDA,10,IEN,0),U,1)
 . D STXPT(X,"N")
 ;
 ;  Set up tagging program
 S ZTDESC="ICARE TAG PROGRAM",ZTRTN="ENT^BQI1POJB",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20"
 D ^%ZTLOAD
 NEW DA,IENS
 S DA=BQIDA,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90508,IENS,.1)=ZTSK
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK,BQIGDA,N,ERROR
 K BQIINDG,BQIDA
 ;
JRN ; Turn off journaling for BQIPAT
 NEW %,DIR
 S %=$$NOJOURN^ZIBGCHAR("BQIPAT")
 I % D
 . W !!,"Attempt to turn off journaling for global ^BQIPAT failed because "
 . W !?5,$$ERR^ZIBGCHAR(%)
 . W !,"Please notify the OIT Help Desk for assistance."
 . S DIR(0)="E" D ^DIR
 Q
 ;
STXPT(TXNM,TYP) ;  Set taxonomy pointer into Site Parameter file
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
LDLAB(ARRAY) ;EP;Load site-populated Lab tests
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
