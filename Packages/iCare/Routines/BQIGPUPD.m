BQIGPUPD ;PRXM/HC/ALA-Update iCare with new GPRA ; 08 Oct 2007  2:24 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
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
 NEW BQIGSCH
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
 ;  Reset the GPRA year for the panels and convert the views
 NEW USR,PNL,SHR,GVW,MSN,MEAS,NMEAS
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . ; Convert templates
 . S LY=0
 . F  S LY=$O(^BQICARE(USR,15,LY)) Q:'LY  D
 .. I $P(^BQICARE(USR,15,LY,0),U,2)'="G" Q
 .. S MSN=0
 .. F  S MSN=$O(^BQICARE(USR,15,LY,1,MSN)) Q:'MSN  D
 ... S MEAS=$P(^BQICARE(USR,15,LY,1,MSN,0),U,1)
 ... I MEAS'["_" Q
 ... I $P(MEAS,"_",1)'=BQIYR Q
 ... S NMEAS=$$CONV(MEAS)
 ... NEW DA,IENS
 ... S DA(2)=USR,DA(1)=LY,DA=MSN,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.151,IENS,.01)=NMEAS
 . ; For each panel
 . S PNL=0
 . F  S PNL=$O(^BQICARE(USR,1,PNL)) Q:'PNL  D
 .. NEW DA,IENS
 .. S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90505.01,IENS,3.3)=BGPYR
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 .. ;  Convert owner's GPRA customized view
 .. S GVW=0
 .. F  S GVW=$O(^BQICARE(USR,1,PNL,25,GVW)) Q:'GVW  D
 ... S MEAS=$P(^BQICARE(USR,1,PNL,25,GVW,0),U,1)
 ... I $P(MEAS,"_",1)'=BQIYR Q
 ... S NMEAS=$$CONV(MEAS)
 ... NEW DA,IENS
 ... S DA(2)=USR,DA(1)=PNL,DA=GVW,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.125,IENS,.01)=NMEAS
 .. ;
 .. ;  Convert shared user's GPRA customized view
 .. S SHR=0
 .. F  S SHR=$O(^BQICARE(USR,1,PNL,30,SHR)) Q:'SHR  D
 ... ; Convert customized
 ... S GVW=0
 ... F  S GVW=$O(^BQICARE(USR,1,PNL,30,SHR,25,GVW)) Q:'GVW  D
 .... S MEAS=$P(^BQICARE(USR,1,PNL,30,SHR,25,GVW,0),U,1)
 .... I $P(MEAS,"_",1)'=BQIYR Q
 .... S NMEAS=$$CONV(MEAS)
 .... NEW DA,IENS
 .... S DA(3)=USR,DA(2)=PNL,DA(1)=SHR,DA=GVW,IENS=$$IENS^DILF(.DA)
 .... S BQIUPD(90505.325,IENS,.01)=NMEAS
 ; Update Site Templates
 NEW TMPN,MSN
 S TMPN=0
 F  S TMPN=$O(^BQI(90508.1,TMPN)) Q:'TMPN  D
 . I $P(^BQI(90508.1,TMPN,0),U,2)'="G" Q
 . S MSN=0
 . F  S MSN=$O(^BQI(90508.1,TMPN,10,MSN)) Q:'MSN  D
 .. S MEAS=$P(^BQI(90508.1,TMPN,10,MSN,0),U,1)
 .. I $P(MEAS,"_",1)'=BQIYR Q
 .. S NMEAS=$$CONV(MEAS)
 .. NEW DA,IENS
 .. S DA(1)=TMPN,DA=MSN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90508.11,IENS,.01)=NMEAS
 ;
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 ;  Update IPC
 NEW CRIPC,CRN,IDN,MEAS,NMEAS,BDN,PRV,PRN,FAC,FCN
 ; Get current IPC
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 S IDN=0
 F  S IDN=$O(^BQI(90508,1,22,CRN,1,IDN)) Q:'IDN  D
 . S MEAS=$P(^BQI(90508,1,22,CRN,1,IDN,0),U,1)
 . I $P(MEAS,"_",1)'=BQIYR D BUN Q
 . S NMEAS=$$CONV(MEAS)
 . NEW DA,IENS
 . S DA(2)=1,DA(1)=CRN,DA=IDN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90508.221,IENS,.01)=NMEAS
 . S PRV=0
 . F  S PRV=$O(^BQIPROV(PRV)) Q:'PRV  D
 .. S PRN=$O(^BQIPROV(PRV,30,"B",MEAS,"")) Q:PRN=""  D
 ... NEW DA,IENS
 ... S DA(1)=PRV,DA=PRN,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.43,IENS,.01)=NMEAS
 . S FAC=0
 . F  S FAC=$O(^BQIFAC(FAC)) Q:'FAC  D
 .. S FCN=$O(^BQIFAC(FAC,30,"B",MEAS,"")) Q:FCN=""  D
 ... NEW DA,IENS
 ... S DA(1)=FAC,DA=FCN,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90505.63,IENS,.01)=NMEAS
 . D BUN
 D FILE^DIE("","BQIUPD","ERROR")
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
 . S BTEXT(5,0)="  "
 . S BTEXT(6,0)="CRS UPDATE job scheduled to run "_$$FMTE^BQIUL1(BQIGSCH)_"."
 . S BTEXT(7,0)="Your Natl Measures data will not be up-to-date until this job"
 . S BTEXT(8,0)="has completed."
 . D ADD^BQINOTF("",USERS,"CRS Updated",.BTEXT,1)
 Q
 ;
JB ;  Set up task to run to repopulate GPRA for all patients
 NEW ZTDESC,ZTRTN,ZTIO,JBNOW,JBDATE,ZTDTH,ZTSK
 S ZTDESC="ICARE GPRA UPDATE",ZTRTN="GPR^BQITASK2",ZTIO=""
 S JBNOW=$$NOW^XLFDT()
 S JBDATE=$S($E($P(JBNOW,".",2),1,2)<20:DT,1:$$FMADD^XLFDT(DT,+1))
 S ZTDTH=JBDATE_".20",BQIGSCH=ZTDTH
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
 . ;S GCAT=$$GET1^DIQ(90506.1,IEN_",",2.02,"I")
 . S GCATN=$$GET1^DIQ(90506.1,IEN_",",3.03,"E")
 . ;I '$$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG" Q
 . ;I $$PATCH^XPDUTL("BGP*8.0*2"),GCAT'="NG1" Q
 . I GCATN'="National GPRA" Q
 . ;S BQIUPD(90506.1,IEN_",",.09)="D"
 . S BQIUPD(90506.1,IEN_",",3.04)="D"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
CONV(MSR) ;EP - Convert the Measure
 NEW NM
 S NM=BGPYR_"_"_$P(MSR,"_",2)
 Q NM
 ;
BUN ; Bundles
 S BDN=0
 F  S BDN=$O(^BQI(90508,1,22,CRN,1,IDN,2,BDN)) Q:'BDN  D
 . S MEAS=$P(^BQI(90508,1,22,CRN,1,IDN,2,BDN,0),U,1)
 . I $P(MEAS,"_",1)'=BQIYR Q
 . S NMEAS=$$CONV(MEAS)
 . NEW DA,IENS
 . S DA(3)=1,DA(2)=CRN,DA(1)=IDN,DA=BDN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90508.2212,IENS,.01)=NMEAS
 Q
