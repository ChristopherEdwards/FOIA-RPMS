BQIGPUPD ;PRXM/HC/ALA-Update iCare with new GPRA ; 08 Oct 2007  2:24 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
GCHK(UPDATE) ;EP - Check CRS year
 NEW BGPYR,BQIYR,BGPIN,BQIN1,BQIN2,BQIN3,VER,BQIH,BQIMEASF,CODE,EXCEPT,DEF
 NEW GCLIN,GOAL,HDR,HELP,IEN,MDATA,MIEN,PDIR,RCAT,RCLIN,RCODE,SOURCE,TEXT,TPI
 NEW NSOURCE,LY
 S BGPYR=$O(^BGPCTRL("B",""),-1),BGPIN=$O(^BGPCTRL("B",BGPYR,0))
 S BQIH=$$SPM^BQIGPUTL()
 S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 ; If the CRS Year is the same as the current iCare year, then a new
 ; version has NOT been installed, so quit
 I BGPYR=BQIYR D UCHK(BQIYR,BQIH) Q
 ; A new version of CRS has been installed, need to update iCare
 S BQIN1=$$GET1^DIQ(90241.01,BGPIN_",",.06,"I")
 S BQIN2=$$GET1^DIQ(90241.01,BGPIN_",",.07,"I")
 S BQIN3=$$GET1^DIQ(90241.01,BGPIN_",",.05,"E")
 I BGPYR'=BQIYR S UPDATE=1
 D EN(BGPYR,BQIN1,BQIN2,BQIN3,$G(UPDATE))
 Q
 ;
EN(BGPYR,BQIN1,BQIN2,BQIN3,INSTALL) ;EP
 ;
 ;Input parameters
 ;  BGPYR = Year of GPRA
 ;  BQIN1 = File number of the indicator file
 ;  BQIN2 = File number of the individual indicator file
 ;  BQIN3 = Program name
 ;  INSTALL = Is this a call from a post-install program?
 ;
 S INSTALL=$G(INSTALL,0)
 NEW BGPHOME,BGPHN,BQIDA,Y,X,IDIN,BQIINDG,BQIGDA,BGIN,BGDATA5,BGDATA4,BQIDFN
 S BGPHN=$O(^BQI(90508,0)) S:BGPHN BGPHOME=$P($G(^BQI(90508,BGPHN,0)),U,1)
 Q:$G(BGPHOME)=""
 S BQIDA=1
 NEW DA,IENS,DIC
 S DA(1)=BQIDA,X=BGPYR,DIC(0)="LMNZ",DIC="^BQI(90508,"_DA(1)_",20,"
 D ^DIC
 I +Y<1 Q
 S BQIGDA=+Y
 S DA=BQIGDA,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90508.01,IENS,.02)=BQIN1
 S BQIUPD(90508.01,IENS,.03)=BQIN2
 S BQIUPD(90508.01,IENS,.04)=BQIN3
 S BQIUPD(90508,BQIDA_",",2)=BGPYR
 S BQIINDG=$$ROOT^DILFD(BQIN2,"",1)
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Inactivate the indicators
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","G",IEN)) Q:IEN=""  D
 . S BQIUPD(90506.1,IEN_",",.1)=1
 . I $P(^BQI(90506.1,IEN,0),U,11)="" S BQIUPD(90506.1,IEN_",",.11)=DT
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Set the indicators
 S IDIN=0,SOURCE="G",RCAT="",RCLIN="",NSOURCE="Performance"
 S VER=$$VERSION^XPDUTL("BGP")
 ;
 F  S IDIN=$O(@BQIINDG@(IDIN)) Q:'IDIN  D
 . ; Get new values from the new file in BQIINDG
 . ; GCAT = NG:National GPRA;NN:Non-National;O:Other;ONM:Other National Measures
 . ; GCLIN = 
 . I VER>7.0 D
 .. S MDATA=$G(@BQIINDG@(IDIN,17)) I MDATA="" Q
 .. I +MDATA=0 Q
 .. S GCLIN=$$GET1^DIQ(BQIN2,IDIN_",",1701,"E")
 .. S GCATN=$$GET1^DIQ(BQIN2,IDIN_",",1706,"E")
 .. I GCATN="" S GCATN="OTHER"
 .. S GCATN=$$LOWER^VALM1(GCATN)
 .. I GCATN["National Gpra" S GCATN="National GPRA"
 .. S GCAT=$P(MDATA,U,6),TEXT=$P(MDATA,U,3)
 .. S EXCEPT=$P(MDATA,U,4),PDIR=$P(MDATA,U,5)
 .. ;
 .. S CODE=BGPYR_"_"_IDIN
 .. S HDR="T00003"_CODE
 .. D FILE
 . Q
 ;
 ;  Set all national gpra values to 'Default'
 NEW GCAT,GCATN
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","G",IEN)) Q:IEN=""  D
 . I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 . S GCAT=$$GET1^DIQ(90506.1,IEN_",",2.02,"I")
 . S GCATN=$$GET1^DIQ(90506.1,IEN_",",3.03,"E")
 . I GCATN'="National GPRA" Q
 . ;I '$$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG" Q
 . ;I $$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG1" Q
 . S BQIUPD(90506.1,IEN_",",.09)="D"
 . S BQIUPD(90506.1,IEN_",",3.04)="D"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Reset the GPRA year for the panels and clear out the views
 NEW USR,PNL,SHR,GVW
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . ; Remove templates
 . S LY=0
 . F  S LY=$O(^BQICARE(USR,15,LY)) Q:'LY  D
 .. I $P(^BQICARE(USR,15,LY,0),U,2)'="G" Q
 .. NEW DA,IENS
 .. S DA(1)=USR,DA=LY,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.015,IENS,.01)="@"
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 . ; For each panel
 . S PNL=0
 . F  S PNL=$O(^BQICARE(USR,1,PNL)) Q:'PNL  D
 .. NEW DA,IENS
 .. S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.01,IENS,3.3)=BGPYR
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 .. ; Delete template
 .. S LY=0
 .. F  S LY=$O(^BQICARE(USR,1,PNL,4,LY)) Q:'LY  D
 ... I $P(^BQICARE(USR,1,PNL,4,LY,0),U,2)'="G" Q
 ... NEW DA,DIK
 ... S DA(2)=USR,DA(1)=PNL,DA=LY,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",4,"
 ... D ^DIK
 .. ;  Delete owner's GPRA customized view
 .. S GVW=0
 .. F  S GVW=$O(^BQICARE(USR,1,PNL,25,GVW)) Q:'GVW  D
 ... NEW DA,DIK
 ... S DA(2)=USR,DA(1)=PNL,DA=GVW,DIK="^BQICARE("_DA(2)_",1,"_DA(1)_",25,"
 ... D ^DIK
 .. ;
 .. ;  Kill shared user's GPRA customized view
 .. S SHR=0
 .. F  S SHR=$O(^BQICARE(USR,1,PNL,30,SHR)) Q:'SHR  D
 ... ; Delete template
 ... S LY=0
 ... F  S LY=$O(^BQICARE(USR,1,PNL,30,SHR,4,LY)) Q:'LY  D
 .... I $P(^BQICARE(USR,1,PNL,30,SHR,4,LY,0),U,2)'="G" Q
 .... NEW DA,DIK
 .... S DA(3)=USR,DA(2)=PNL,DA(1)=SHR,DA=LY
 .... S DIK="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",4,"
 .... D ^DIK
 ... ; Delete customized
 ... S GVW=0
 ... F  S GVW=$O(^BQICARE(USR,1,PNL,30,SHR,25,GVW)) Q:'GVW  D
 .... NEW DA,DIK
 .... S DA(3)=USR,DA(2)=PNL,DA(1)=SHR,DA=GVW
 .... S DIK="^BQICARE("_DA(3)_",1,"_DA(2)_",30,"_DA(1)_",25,"
 .... D ^DIK
 ;
 S BQIDFN=0
 F  S BQIDFN=$O(^BQIPAT(BQIDFN)) Q:'BQIDFN  D
 . S $P(^BQIPAT(BQIDFN,0),U,2)=BGPYR
 ;
 I INSTALL D
 . D JB
 . NEW USERS,DZ,BTEXT
 . S USERS="",DZ=0
 . F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  S USERS=USERS_DZ_$C(28)
 . S BTEXT(1,0)="The RPMS Clinical Reporting System (CRS) has been updated on your"
 . S BTEXT(2,0)="facility's server.  This update may affect your iCare Natl Measures"
 . S BTEXT(3,0)="view, because of new or inactivated performance measures. Please"
 . S BTEXT(4,0)="review your Natl Measures layout and update as needed."
 . D ADD^BQINOTF("",USERS,"CRS Updated",.BTEXT,1)
 Q
 ;
JB ;  Set up task to run to repopulate GPRA for all patients
 NEW ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 S ZTDESC="ICARE GPRA UPDATE",ZTRTN="GPR^BQITASK2",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20"
 D ^%ZTLOAD
 NEW DA,IENS
 S DA=BQIDA,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90508,IENS,.1)=ZTSK
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
FILE ;File record
 NEW DA,X,DIC,DLAYGO
 S DIC="^BQI(90506.1,",DIC(0)="L",X=CODE
 S DA=$O(^BQI(90506.1,"B",CODE,""))
 I DA="" D  Q:$G(ERROR)=1
 . K DO,DD D FILE^DICN
 . S DA=+Y I DA=-1 S ERROR=1
 . S INSTALL=1
 S BQIUPD(90506.1,DA_",",.03)=TEXT
 ;S BQIUPD(90506.1,DA_",",2.01)=SOURCE
 ;S BQIUPD(90506.1,DA_",",2.02)=GCAT
 ;S BQIUPD(90506.1,DA_",",2.03)=RCAT
 ;S BQIUPD(90506.1,DA_",",2.05)=RCLIN
 ;S BQIUPD(90506.1,DA_",",2.06)=GCLIN
 S BQIUPD(90506.1,DA_",",.08)=HDR
 S BQIUPD(90506.1,DA_",",.09)=$S($G(DEF)=1:"D",1:"O")
 S BQIUPD(90506.1,DA_",",.14)=PDIR
 S BQIUPD(90506.1,DA_",",.15)=90
 S BQIUPD(90506.1,DA_",",.1)="@"
 S BQIUPD(90506.1,DA_",",.11)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 S BQIUPD(90506.1,DA_",",3.01)=NSOURCE
 S BQIUPD(90506.1,DA_",",3.02)=GCLIN
 S BQIUPD(90506.1,DA_",",3.03)=GCATN
 S BQIUPD(90506.1,DA_",",3.04)=$S($G(DEF)=1:"Default",1:"Optional")
 D FILE^DIE("E","BQIUPD","ERROR")
 Q
 ;
UCHK(BQIGYR,BQIDA) ; EP - Check for any updates
 NEW BQIYDA,BQIMEASF,BQIINDF
 S BQIYDA=$$LKP^BQIGPUTL(BQIGYR)
 D GFN^BQIGPUTL(BQIDA,BQIYDA)
 S BQIINDG=$$ROOT^DILFD(BQIMEASF,"",1)
 S VER=$$VERSION^XPDUTL("BGP"),INSTALL=0
 ; Inactivate the indicators
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","G",IEN)) Q:IEN=""  D
 . S CODE=$P(^BQI(90506.1,IEN,0),U,1)
 . I VER<8.0,$P(CODE,"_",1)=BQIGYR Q
 . S BQIUPD(90506.1,IEN_",",.1)=1
 . I $P(^BQI(90506.1,IEN,0),U,11)="" S BQIUPD(90506.1,IEN_",",.11)=DT
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Set the indicators
 S IDIN=0,SOURCE="G",RCAT="",RCLIN="",NSOURCE="Performance"
 ;
 F  S IDIN=$O(@BQIINDG@(IDIN)) Q:'IDIN  D
 . ; Get new values from the new file in BQIINDG
 . ; GCAT = NG:National GPRA;NN:Non-National;O:Other;ONM:Other National Measures
 . ; GCLIN = 
 . I VER>7.0 D
 .. S MDATA=$G(@BQIINDG@(IDIN,17)) I MDATA="" Q
 .. I +MDATA=0 Q
 .. S GCLIN=$$GET1^DIQ(BQIMEASF,IDIN_",",1701,"E")
 .. S GCATN=$$GET1^DIQ(BQIMEASF,IDIN_",",1706,"E")
 .. I GCATN="" S GCATN="OTHER"
 .. S GCATN=$$LOWER^VALM1(GCATN)
 .. I GCATN["National Gpra" S GCATN="National GPRA"
 .. S GCAT=$P(MDATA,U,6),TEXT=$P(MDATA,U,3)
 .. S EXCEPT=$P(MDATA,U,4),PDIR=$P(MDATA,U,5)
 .. I GCAT["NG" S GCATN="National GPRA"
 .. ;
 .. S CODE=BGPYR_"_"_IDIN
 .. S HDR="T00003"_CODE
 .. D FILE
 . Q
 ;
 ; If new measures identified, job off GPRA update job and send notification
 ; about new measures
 I INSTALL D
 . D JB
 . NEW USERS,DZ,BTEXT
 . S USERS="",DZ=0
 . F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  S USERS=USERS_DZ_$C(28)
 . S BTEXT(1,0)="The RPMS Clinical Reporting System (CRS) has been updated on your"
 . S BTEXT(2,0)="facility's server.  This update may affect your iCare Natl Measures"
 . S BTEXT(3,0)="view, because of new or inactivated performance measures. Please"
 . S BTEXT(4,0)="review your Natl Measures layout and update as needed."
 . D ADD^BQINOTF("",USERS,"CRS Updated",.BTEXT,1)
 ;
 ;  Set all national gpra values to 'Default'
 NEW GCAT
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","G",IEN)) Q:IEN=""  D
 . I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 . S CODE=$P(^BQI(90506.1,IEN,0),U,1)
 . I VER<8.0,$P(CODE,"_",1)=BQIGYR Q
 . S GCAT=$$GET1^DIQ(90506.1,IEN_",",2.02,"I")
 . S GCATN=$$GET1^DIQ(90506.1,IEN_",",3.03,"E")
 . ;I '$$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG" Q
 . ;I $$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG1" Q
 . I GCATN'="National GPRA" Q
 . S BQIUPD(90506.1,IEN_",",.09)="D"
 . S BQIUPD(90506.1,IEN_",",3.04)="D"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
