BQI2POST ;PRXM/HC/ALA-Version 2.0 Post-Install ; 01 Nov 2007  3:15 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ; Entry point
 ;
 NEW VISIT
 S VISIT=$G(^XTMP("BQICARE","VISIT"))
 I VISIT'="" S $P(^BQI(90508,1,"VISIT"),U,1)=VISIT
 I VISIT="" S $P(^BQI(90508,1,"VISIT"),U,1)=$O(^AUPNVSIT("A"),-1)
 S $P(^BQI(90508,1,"VISIT"),U,2)=$O(^AUPNPROB("A"),-1)
 ;  Set up the parameters file with the default location
 NEW BGPHOME,BGPHN,BQIDA,FD,BGDATA,IDIN,BQDA,PADA,RP
 S BGPHN=$O(^BGPSITE(0)) S:BGPHN BGPHOME=$P($G(^BGPSITE(BGPHN,0)),U,1)
 Q:$G(BGPHOME)=""
 S BQIDA=1
 S BQIUPD(90508,BQIDA_",",.01)=BGPHOME
 ; Clean up development start and stop times
 F FLD=3.01:.01:3.09,3.1,3.11:.01:3.19,3.2,3.21,4.01:.01:4.09,4.1,4.11,4.12 D
 . S BQIUPD(90508,BQIDA_",",FLD)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 I $G(^XTMP("BQICARE",3))'="" S ^BQI(90508,1,3)=^XTMP("BQICARE",3)
 I $G(^XTMP("BQICARE",4))'="" S ^BQI(90508,1,4)=^XTMP("BQICARE",4)
 ;
 ; If no versions of iCare have ever been installed
 I $O(^XPD(9.7,"B","ICARE MANAGEMENT SYSTEM 1.0",""))="",$O(^XPD(9.7,"B","ICARE MANAGEMENT SYSTEM 1.1",""))="" D INI^BQI2POSI
 ;
 ; If version 1.0 has been installed
 I $O(^XPD(9.7,"B","ICARE MANAGEMENT SYSTEM 1.0",""))'="",$O(^XPD(9.7,"B","ICARE MANAGEMENT SYSTEM 1.1",""))="" D ONE^BQI2POSI
 ;
 ; Make sure that the new style cross-references are set
 NEW DIK
 S DIK="^BQI(90506.1,",DIK(1)="3.01"
 D ENALL^DIK
 ;
 ; Set up iCare Program Manager
 NEW USER,DIRUT,DIR,Y,X
 S DIR(0)=$S($O(^BQICARE(0))'="":"P^90505:LEMZ",1:"P^200:EMZ")
 S DIR("A")="Select iCare Package Manager"
 S DIR("A",1)="Select person who is to be designated as the iCare Package Manager."
 S DIR("?")="Select the designated iCare Package Manager"
 I DIR(0)["200" S DIR("S")="I +$P($G(^(0)),U,11)'>0,$P(^(0),U,11)'>DT"
 D ^DIR
 S USER=+Y
 I $G(DIRUT)=1 S USER=DUZ
 D UPD^BQISYKEY(.DATA,USER,"BQIZMGR="_"Y")
 ;
 ; Update default patient view from text 'C' to pointer
 NEW USR
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . I $G(^BQICARE(USR,0))="" K ^BQICARE(USR) Q
 . I $P(^BQICARE(USR,0),U,7)="C" S $P(^BQICARE(USR,0),U,7)=1
 ;
 ; If special HIV provider categories exist in BDP DESG SPEC PROV CATEGORY,
 ; move HMS record data into BDPRECN
 NEW HCSMR,HPRV,IEN,BQDFN,HIVIEN,BKMCMGR,BKMPRV
 S HCSMR=$O(^BDPTCAT("B","HIV CASE MANAGER",""))
 S HPRV=$O(^BDPTCAT("B","HIV PROVIDER",""))
 S HIVIEN=$$HIVIEN^BKMIXX3()
 S IEN=0
 F  S IEN=$O(^BKM(90451,IEN)) Q:'IEN  D
 . S BQDFN=$P(^BKM(90451,IEN,0),U,1)
 . NEW DA,IENS
 . S DA(1)=IEN,DA=HIVIEN,IENS=$$IENS^DILF(.DA)
 . S BKMCMGR=$$GET1^DIQ(90451.01,IENS,6.5,"I")
 . S BKMPRV=$$GET1^DIQ(90451.01,IENS,6,"I")
 . I BKMCMGR'=""&(HCSMR'="") D AEDAP^BDPAPI(BQDFN,BKMCMGR,"HIV CASE MANAGER",.RESULT)
 . I BKMPRV'=""&(HPRV'="") D AEDAP^BDPAPI(BQDFN,BKMPRV,"HIV PROVIDER",.RESULT)
 ;
 ;Set STATE HIV REPORT REQUIRED to YES
 NEW BKMDA,BKMUPD
 S BKMDA=1
 S BKMUPD(90450,BKMDA_",",12.5)=1
 D FILE^DIE("","BKMUPD","ERROR")
 ;
TXNAME ; Rename taxonomy names
 NEW I,TEXT,FILNM,FILIEN,OLD,NEW,SHORT,TAXUPD,TXUPD,TXIEN
 F I=1:1 S TEXT=$T(TAX+I) Q:TEXT=""  D
 . S TEXT=$P(TEXT,";",2,99)
 . S FILNM=$P(TEXT,";"),FILIEN=+$P(@("^"_FILNM_"(0)"),"^",2)
 . S OLD=$P(TEXT,";",2),NEW=$P(TEXT,";",3),SHORT=$P(TEXT,";",4)
 . S TXIEN=$O(@("^"_FILNM_"(""B"","""_OLD_""","""")")) Q:TXIEN=""
 . S TAXUPD(FILIEN,TXIEN_",",.01)=NEW
 . I SHORT'="" S TAXUPD(FILIEN,TXIEN_",",.02)=SHORT
 S FILIEN="" F  S FILIEN=$O(TAXUPD(FILIEN)) Q:FILIEN=""  D
 . M TXUPD(FILIEN)=TAXUPD(FILIEN)
 . D FILE^DIE("","TXUPD","ERROR")
 . K TXUPD
 ;
 ; Delete taxonomies that are no longer used
 NEW TAX,DA,DIK
 F TAX="BKM BCG IZ CPTS","BKM BCG IZ CVX CODES","BKM BCG IZ PROCEDURE" D
 . S DA=$O(^ATXAX("B",TAX,"")) Q:DA=""
 . S DIK="^ATXAX("
 . D ^DIK
 ;
 ; Add new taxonomies OR update existing ones
 D ^BQIBTX
 ;
 ; Add new BGP SMOKER CPTS and update BQI KNOWN CVD-1 PROCEDURES
 D ^BQIHTX
 ;
 ;Pre-define the HIV tags as 'proposed' or appropriate if they are in the register
 NEW BQIDFN,HRIEN,HIVIEN,PSTAT,PCAT
 S HIVIEN=$$HIVIEN^BKMIXX3()
 S BQIDFN=""
 F  S BQIDFN=$O(^BQIPAT("AB",3,BQIDFN)) Q:BQIDFN=""  D
 . S DATE=$P($G(^BQIPAT(BQIDFN,20,3,0)),U,2)
 . S HRIEN=$O(^BKM(90451,"B",BQIDFN,""))
 . ; If the tagged person is in the register
 . I HRIEN'="" D  Q
 .. NEW DA,IENS
 .. S DA(1)=HRIEN,DA=HIVIEN,IENS=$$IENS^DILF(.DA)
 .. S PSTAT=$$GET1^DIQ(90451.01,IENS,.5,"I")
 .. S PCAT=$$GET1^DIQ(90451.01,IENS,2.3,"I")
 .. ; if the HMS Dx category is null or HIV or AIDS
 .. I PCAT=""!(PCAT="H")!(PCAT="A") D  Q
 ... ; if register status is active, deceased or transient then tag is accepted
 ... I PSTAT="A"!(PSTAT="D")!(PSTAT="T") D EN^BQITDPRC(.DATA,BQIDFN,3,"A",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT) Q
 ... ; else tag is proposed
 ... D EN^BQITDPRC(.DATA,BQIDFN,3,"P",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT) Q
 .. ; if HMS dx category is 'At Risk'
 .. D EN^BQITDPRC(.DATA,BQIDFN,3,"P",DATE,"POST INSTALL JOB",8,"Register status is "_PSTAT)
 . ;
 . ; If the tagged person is NOT in the register
 . D EN^BQITDPRC(.DATA,BQIDFN,3,"P",DATE,"POST INSTALL JOB",5)
 ;
 ; Update Panels for Diagnostic Tags
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . S PLN=0
 . F  S PLN=$O(^BQICARE(USR,1,PLN)) Q:'PLN  D
 .. I $O(^BQICARE(USR,1,PLN,15,0))="" Q
 .. D ASC
 ;
 ; New Asthma taxonomies if BJPC v 2.0 has been installed
 I $$VERSION^XPDUTL("BJPC")>1.0 D
 . NEW DA,DIK,DIC,X,DLAYGO,IENS,BQIUPD,TIEN,NDA,NTAX,SITE,BI
 . S NDA=84
 . F BI=1:1 S TEXT=$T(AST+BI) Q:TEXT[" Q"  D
 .. S NTAX=$P($P(TEXT,";;",2),U,1),SITE=$P($P(TEXT,";;",2),U,2)
 .. S TIEN=$O(^ATXAX("B",NTAX,"")) I TIEN="" Q
 .. S DA(1)=$O(^BQI(90508,0)),DIK="^BQI(90508,"_DA(1)_",10,"
 .. S DA=NDA F  S DA=$O(^BQI(90508,DA(1),10,DA)) Q:'DA  D ^DIK
 .. S DA(1)=$O(^BQI(90508,0)),X=NTAX
 .. S DIC(0)="L",DIC="^BQI(90508,"_DA(1)_",10,",DLAYGO=90508.03
 .. K DO,DD D FILE^DICN
 .. S DA=+Y I DA'=-1 S NDA=DA
 .. I DA=-1 S NDA=NDA+1,DA=NDA
 .. S IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90508.03,IENS,.01)=NTAX
 .. D FILE^DIE("E","BQIUPD","ERROR")
 .. S BQIUPD(90508.03,IENS,.02)=TIEN_";ATXAX("
 .. S BQIUPD(90508.03,IENS,.03)=4
 .. S BQIUPD(90508.03,IENS,.04)=$G(SITE)
 .. S BQIUPD(90508.03,IENS,.05)="M"
 .. D FILE^DIE("I","BQIUPD","ERROR")
 . K BQIUPD
 ;
TX ; Reset the variable pointer values for the taxonomies
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
 ;
 D PDSC ; Update generated description
 ;
 ;  Set up tagging program
 S ZTDESC="ICARE TAG UPDATE",ZTRTN="REG^BQI2POS1",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20"
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 ;
 D ^BQISCHED
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
ASC ; Update Panels with associated parameters for Diagnostic Tags
 I $O(^BQICARE(USR,1,PLN,15,"B","DXCAT",""))'="" D
 . S IEN=$O(^BQICARE(USR,1,PLN,15,"B","DXCAT",""))
 . ; Multiple parameter value
 . I $O(^BQICARE(USR,1,PLN,15,IEN,1,0))'="" D  Q
 .. S MDA=0
 .. F  S MDA=$O(^BQICARE(USR,1,PLN,15,IEN,1,MDA)) Q:'MDA  D
 ... I $D(^BQICARE(USR,1,PLN,15,IEN,1,MDA,2,"B","DXSTAT")) Q
 ... NEW DA,DIC,DLAYGO
 ... S DA(4)=USR,DA(3)=PLN,DA(2)=IEN,DA(1)=MDA,X="DXSTAT"
 ... S DLAYGO=90505.11512,DIC(0)="L",DIC("P")=DLAYGO
 ... S DIC="^BQICARE("_DA(4)_",1,"_DA(3)_",15,"_DA(2)_",1,"_DA(1)_",2,"
 ... I '$D(^BQICARE(DA(4),1,DA(3),15,DA(2),1,DA(1),2,0)) S ^BQICARE(DA(4),1,DA(3),15,DA(2),1,DA(1),2,0)="^90505.11512^^"
 ... K DO,DD D FILE^DICN
 ... S (DA,PADA)=+Y
 ... NEW DA,IENS,DIC,DLAYGO
 ... S DA(5)=USR,DA(4)=PLN,DA(3)=IEN,DA(2)=MDA,DA(1)=PADA
 ... S DLAYGO=90505.115121,DIC(0)="L",DIC("P")=DLAYGO
 ... I '$D(^BQICARE(DA(5),1,DA(4),15,DA(3),1,DA(2),2,DA(1),1,0)) S ^BQICARE(DA(5),1,DA(4),15,DA(3),1,DA(2),2,DA(1),1,0)="^90505.115121^^"
 ... S DIC="^BQICARE("_DA(5)_",1,"_DA(4)_",15,"_DA(3)_",1,"_DA(2)_",2,"_DA(1)_",1,"
 ... F ASVAL="P","A" D
 .... S X=ASVAL
 .... K DO,DD D FILE^DICN
 . ;
 . ; Singular parameter value
 . I $D(^BQICARE(USR,1,PLN,15,IEN,2,"B","DXSTAT")) Q
 . NEW DA,DIC,DLAYGO
 . S DA(3)=USR,DA(2)=PLN,DA(1)=IEN,X="DXSTAT"
 . S DLAYGO=90505.1152,DIC(0)="L",DIC("P")=DLAYGO
 . S DIC="^BQICARE("_DA(3)_",1,"_DA(2)_",15,"_DA(1)_",2,"
 . I '$D(^BQICARE(DA(3),1,DA(2),15,DA(1),2,0)) S ^BQICARE(DA(3),1,DA(2),15,DA(1),2,0)="^90505.1152^^"
 . K DO,DD D FILE^DICN
 . S (DA,PADA)=+Y
 . NEW DA,DIC,DLAYGO
 . S DA(4)=USR,DA(3)=PLN,DA(2)=IEN,DA(1)=PADA
 . S DLAYGO=90505.11521,DIC(0)="L",DIC("P")=DLAYGO
 . I '$D(^BQICARE(DA(4),1,DA(3),15,DA(2),2,DA(1),1,0)) S ^BQICARE(DA(4),1,DA(3),15,DA(2),2,DA(1),1,0)="^90505.11521^^"
 . S DIC="^BQICARE("_DA(4)_",1,"_DA(3)_",15,"_DA(2)_",2,"_DA(1)_",1,"
 . F ASVAL="P","A" D
 .. S X=ASVAL
 .. K DO,DD D FILE^DICN
 . ;
 . ; Send notification that panel definition has been updated
 . NEW SUBJECT,DA,IENS,USRNM
 . S DA(1)=USR,DA=PLN,IENS=$$IENS^DILF(.DA)
 . S USRNM=$$GET1^DIQ(200,USR_",",.01,"E")
 . S SUBJECT="Panel "_$$GET1^DIQ(90505.01,IENS,.01,"E")_"'s definition was updated with Diagnostic Tag statuses."
 . D ADD^BQINOTF("",USR,SUBJECT)
 Q
 ;
PDSC ; Load revised generated descriptions for all panels
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
SITEMED(BGPX,BGPNDCT) ; EP
 ; Automatically populate the site-defined medication taxonomies
 ; based on the corresponding NDC codes from the site's formulary
 ;
 N BGPTX,X,Y,DIK,TXIEN,LSTIEN,NDCIEN,MED,RESULT,NDC
 S BGPTX=$O(^ATXAX("B",BGPX,0))
 I 'BGPTX D
 . S X=BGPX,DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226
 . D ^DIC K DIC,DA,DIADD,DLAYGO,I
 . I Y=-1 Q  ;W !!,"ERROR IN CREATING ",BGPX," TAX" Q
 . S BGPTX=+Y,$P(^ATXAX(BGPTX,0),U,2)=BGPX,$P(^(0),U,8)=0,$P(^(0),U,9)=DT
 . S $P(^ATXAX(BGPTX,0),U,12)=173,$P(^(0),U,13)=0,$P(^(0),U,15)=50
 . I '$D(^ATXAX(BGPTX,21,0)) S ^ATXAX(BGPTX,21,0)="^9002226.02101A^0^0"
 I BGPTX S DA=BGPTX,DIK="^ATXAX(" D IX1^DIK
 I $G(BGPNDCT)]"" D
 . S TXIEN=0,LSTIEN=""
 . F  S TXIEN=$O(^ATXAX(BGPTX,21,TXIEN)) Q:TXIEN'=+TXIEN  S LSTIEN=TXIEN
 . S RESULT=1
 . ;
 . L +^ATXAX(BGPTX,0):1 E  S RESULT=0
 . Q:'RESULT
 . S ^ATXAX(BGPTX,21,0)="^9002226.02101A^"_LSTIEN_U_LSTIEN
 . S NDCIEN=$O(^ATXAX("B",BGPNDCT,0))
 . S MED=0
 . F  S MED=$O(^PSDRUG(MED)) Q:MED'=+MED  S NDC=$P($G(^PSDRUG(MED,2)),U,4) I NDC]"",$D(^ATXAX(NDCIEN,21,"B",NDC)) D
 .. Q:$D(^ATXAX(BGPTX,21,"B",MED))
 .. S LSTIEN=LSTIEN+1,^ATXAX(BGPTX,21,LSTIEN,0)=MED_U_MED
 . L -^ATXAX(BGPTX,0)
 ;
 I BGPTX S DA=BGPTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
AST ; Asthma Taxonomy List
 ;;BAT ASTHMA SHRT ACT RELV MEDS^1
 ;;BAT ASTHMA SHRT ACT RELV NDC^
 ;;BAT ASTHMA SHRT ACT INHLR MEDS^1
 ;;BAT ASTHMA SHRT ACT INHLR NDC^
 ;;BAT ASTHMA CONTROLLER NDC^
 ;;BAT ASTHMA INHLD STEROIDS NDC^
 ;;BAT ASTHMA LEUKOTRIENE MEDS^1
 ;;BAT ASTHMA LEUKOTRIENE NDC^
 Q
 ;
TAX ;File Type;Original Taxonomy name;New Taxonomy name;Short name
 ;ATXLAB;BKM CD4 ABS TESTS TAX;BKMV CD4 ABS TESTS TAX;
 ;ATXLAB;BKM HEP C EIA TAX;BKM HEP C SCREENING TAX;HEP C SCREENING TAX
 ;ATXLAB;BKM HEP C RIBA TAX;BKM HEP C CONFIRMATORY TAX;HEP C CONFIRMATORY TAX
 ;ATXAX;BKM HEP C EIA LOINC CODES;BKM HEP C SCREEN LOINC CODES;HEP C SCREEN LOINC CODES
 ;ATXAX;BKM HEP C EIA TESTS CPTS;BKM HEP C SCREEN TESTS CPTS;HEP C SCREEN TESTS CPTS
 ;ATXAX;BKM HEP C RIBA LOINC CODES;BKM HEP C CONFIRM LOINC CODES;HEP C CONFIRM LOINC CODES
 ;ATXAX;BKM HEP C RIBA TESTS CPTS;BKM HEP C CONFIRM TESTS CPTS;Hepatitis C test (Confirm)
 ;ATXAX;BKMV FI MED NDCS;BKMV EI MED NDCS;EI MED NDCS
 ;ATXAX;BKMV FI MEDS;BKMV EI MEDS;BKMV EI MEDS;
