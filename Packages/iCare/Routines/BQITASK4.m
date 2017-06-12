BQITASK4 ;GDIT/HS/ALA-Update a diagnostic tag ; 29 Jan 2014  8:37 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
EN(TAG) ; EP
 NEW BQTN,BQDEF,BQEXEC,BQPRG,BQREF,BQGLB,PRGM,IEN,DFN
 S UID=$J
 S BQTN=$O(^BQI(90506.2,"B",TAG,"")) I BQTN="" Q
 I $$GET1^DIQ(90506.2,BQTN_",",.03,"I") Q
 I $$GET1^DIQ(90506.2,BQTN_",",.05,"I")=1 Q
 S BQDEF=$$GET1^DIQ(90506.2,BQTN_",",.01,"E")
 S BQEXEC=$$GET1^DIQ(90506.2,BQTN_",",1,"E")
 S BQPRG=$$GET1^DIQ(90506.2,BQTN_",",.04,"E")
 ;
 ; Set the taxonomy array from the file definition
 S BQREF="BQIRY" K @BQREF
 D ARY^BQITUTL(BQDEF,BQREF)
 S BQGLB=$NA(^TMP("BQIPOP",UID))
 K @BQGLB
 ;
 ; Call the populate category code
 S PRGM="POP^"_BQPRG_"(BQREF,BQGLB)"
 D @PRGM
 ;
 ; Check if patient tagged but not found in criteria anymore
 S IEN=""
 F  S IEN=$O(^BQIREG("B",BQTN,IEN)) Q:IEN=""  D
 . S DFN=$P(^BQIREG(IEN,0),U,2)
 . I '$D(@BQGLB@(DFN)) D
 .. D NCR^BQITDUTL(DFN,BQTN)
 .. ; Remove previous criteria
 .. NEW DA,DIK
 .. S DA(2)=DFN,DA(1)=BQTN,DA=0,DIK="^BQIPAT("_DA(2)_",20,"_DA(1)_",1,"
 .. F  S DA=$O(^BQIPAT(DFN,20,BQTN,1,DA)) Q:'DA  D ^DIK
 ; File the patients who met criteria
 S DFN=0
 F  S DFN=$O(@BQGLB@(DFN)) Q:DFN=""  D FIL^BQITASK(BQGLB,DFN)
 ;
 K @BQGLB,AGE,BQEXEC,BQDEF,BQPRG,@BQREF,BQREF,BQGLB,DFN,PRGM
 K SEX,TXDXCN,TXDXCT,TXT,Y,UID
 Q
 ;
JB ;EP - Task off the job
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BQIUPD
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="Update Pregnancy Tag",ZTIO=""
 S ZTRTN="EN^BQITASK4(""Pregnant"")"
 D ^%ZTLOAD
 Q
