BQINIGHT ;PRXM/HC/ALA-Nightly Background Job ; 05 Jan 2006  1:31 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
EN ;EP - Entry point
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB"
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 S BQIUPD(90508,"1,",24.01)=$G(ZTSK)
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 D EN^BQIMUMON("")
 D JBC
 D MEAS^BQINIGH1
 D FLG
 D CMA^BQINIGH2
 D DXC
 D CRS
 D NUM^BQIMUSIT
 D REM
 K DLAYGO
 D TRT
 D REG
 D AST^BQINIGH1
 ;Run IPC
 D EN^BQIIPMON("")
 ; Run CMET
 D EN^BTPWPFND("Nightly")
 ; Run Autopopulate
 D NGHT^BQINIGH2
 ;
 S BQIUPD(90508,"1,",24.01)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Clean up any remaining TMPs
 NEW BQTSK,TSK,TUID
 S TSK="BQI",BQTSK=TSK
 F  S BQTSK=$O(^TMP(BQTSK)) Q:$E(BQTSK,1,3)'=TSK  S TUID="" F  S TUID=$O(^TMP(BQTSK,TUID)) Q:TUID=""  I $E(TUID,1,1)="Z" K ^TMP(BQTSK,TUID)
 Q
 ;
FLG ;EP - Flag updates
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ;  Set the DATE/TIME FLAG STARTED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.01)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.03)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ; Find all flags for patients
 D FND^BQIFLG
 ;
 ;  Set the DATE/TIME FLAG STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.02)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.03)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Get a list of all patients who have had visits or problems
 ;  entered into RPMS since the last visit or problem IENs.
 ;  Set into temporary global XTMP. This list is the subset of
 ;  patients used to update.
 ; 
 NEW BQIDA,VLIEN,PRIEN,DFN,LMDT
 S BQIDA=$$SPM^BQIGPUTL()
 S VLIEN=$$GET1^DIQ(90508,BQIDA,1,"E")
 S PRIEN=$$GET1^DIQ(90508,BQIDA,3,"E")
 S BQIUPD(90508,BQIDA_",",1)=$O(^AUPNVSIT("A"),-1)
 S BQIUPD(90508,BQIDA_",",3)=$O(^AUPNPROB("A"),-1)
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 K ^XTMP("BQINIGHT")
 S ^XTMP("BQINIGHT",0)=$$FMADD^XLFDT(DT,1)_U_$$DT^XLFDT()
 F  S VLIEN=$O(^AUPNVSIT(VLIEN)) Q:'VLIEN  D
 . ; If visit has been deleted, don't include
 . I $P(^AUPNVSIT(VLIEN,0),U,11)=1 Q
 . Q:"DXCTI"[$P(^AUPNVSIT(VLIEN,0),U,7)
 . S DFN=$P(^AUPNVSIT(VLIEN,0),U,5) Q:DFN=""
 . S ^XTMP("BQINIGHT",DFN)=""
 ;
 F  S PRIEN=$O(^AUPNPROB(PRIEN)) Q:'PRIEN  D
 . S DFN=$P(^AUPNPROB(PRIEN,0),U,2)
 . I $P(^AUPNPROB(PRIEN,0),U,12)'="A" Q
 . S ^XTMP("BQINIGHT",DFN)=""
 ;
 ; Use new Date Last Modified cross-reference
 S LMDT=$$FMADD^XLFDT(DT,-1)-.005
 F  S LMDT=$O(^AUPNVSIT("ADLM",LMDT)) Q:LMDT=""  D
 . S VLIEN=""
 . F  S VLIEN=$O(^AUPNVSIT("ADLM",LMDT,VLIEN)) Q:VLIEN=""  D
 .. I $P(^AUPNVSIT(VLIEN,0),U,11)=1 Q
 .. Q:"DXCTI"[$P(^AUPNVSIT(VLIEN,0),U,7)
 .. S DFN=$P(^AUPNVSIT(VLIEN,0),U,5) Q:DFN=""
 .. S ^XTMP("BQINIGHT",DFN)=""
 Q
 ;
DXC ;EP - Update Diagnosis Categories
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ;  Set the DATE/TIME DXN CATEGORY STARTED field
 NEW DA,DATA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.04)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.06)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 S DFN=0
 F  S DFN=$O(^XTMP("BQINIGHT",DFN)) Q:'DFN  D
 . D PAT^BQITDPAT(.DATA,DFN)
 . Q
 ;
 I $G(BQGLB)'="" K @BQGLB,BQGLB
 I $G(BQPGLB)'="" K @BQPGLB,BQPGLB
 K AGE,BQEXEC,BQDEF,BQPRG,DFN,PRGM,SEX,TXDXCN,TXDXCT,TXT,Y
 ;
 ;  Set the DATE/TIME DXN CATEGORY STOPPED field
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.05)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.06)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 F BQTSK="BQIBMI","BQIBP","BQIPREG","BQITAX","BQITAX1","BQITDPRC","BQITMPO","BQITDPAT" K ^TMP(BQTSK,UID)
 Q
 ;
CRS ;EP - Find all GPRA indicators
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ; Check if new version of CRS has been loaded
 D GCHK^BQIGPUPD()
 ;
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.07)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.09)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW DFN,GPMEAS,CT
 S BQIGREF=$NA(^TMP("BQIGPRA",UID))
 K @BQIGREF
 S BQIDATA=$NA(^BQIPAT)
 ;
 D INP
 ;  If the routine is not defined, quit
 I $G(BQIROU)="" Q
 ;
 ;  If the tag is not defined, quit
 I $T(@("BQI^"_BQIROU))="" Q
 ;
 ;  Initialize GPRA variables
 NEW VER,BQX,XN
 S VER=$$VERSION^XPDUTL("BGP")
 ;I VER<8.0 D
 ;. S X=0 F  S X=$O(@BQIINDG@("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
 ;
 I VER>7.0 D
 . S BQX=""
 . F  S BQX=$O(^BQI(90506.1,"AC","G",BQX)) Q:BQX=""  D
 .. I $P(^BQI(90506.1,BQX,0),U,10)=1 Q
 .. S X=$P(^BQI(90506.1,BQX,0),U,1),XN=$P(X,"_",2)
 .. S X=$P($G(@BQIMEASG@(XN,0)),U,1) I X'="" S BGPIND(X)=""
 ;
 ; Define the time frame for the patient
 S BGPBD=$$DATE^BQIUL1("T-12M"),BGPED=DT
 S BGPBBD="300"_$E(BGPBD,4,7),BGPBED="300"_$E(BGPED,4,7)
 S BGPPBD=$$DATE^BQIUL1("T-24M"),BGPPED=$$DATE^BQIUL1("T-12M")
 S BGPPER=$E($$DT^XLFDT(),1,3)_"0000"
 S BGPQTR=$S(BGPBD>($E(BGPBD,1,3)_"0101")&(BGPBD<($E(BGPBD,1,3)_"0331")):1,BGPBD>($E(BGPBD,1,3)_"0401")&(BGPBD<($E(BGPBD,1,3)_"0630")):2,BGPBD>($E(BGPBD,1,3)_"0701")&(BGPBD<($E(BGPBD,1,3)_"0930")):3,1:4)
 S BGPRTYPE=4,BGPRPT=4
 S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 S BGPP3YE=$$FMADD^XLFDT(BGPPED,-1096)
 S BGPB3YE=$$FMADD^XLFDT(BGPBED,-1096)
 ;
 S DFN=0
 F  S DFN=$O(^XTMP("BQINIGHT",DFN)) Q:'DFN  D
 . ; Remove any previous GPRA data
 . K @BQIDATA@(DFN,30)
 . S @BQIDATA@(DFN,30,0)="^90507.53^^"
 . ; If patient is deceased, don't calculate
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . I '$$VTHR^BQIUL1(DFN) Q
 . ; If new patient add to BQIPAT
 . I $G(^BQIPAT(DFN,0))="" D NPT^BQITASK(DFN)
 . S BQIPUP(90507.5,DFN_",",.02)=BQIYR
 . S BQIPUP(90507.5,DFN_",",.03)=BGPBD
 . S BQIPUP(90507.5,DFN_",",.04)=BGPED
 . S BQIPUP(90507.5,DFN_",",.05)=$$NOW^XLFDT()
 . D FILE^DIE("","BQIPUP","ERROR")
 . K BQIPUP
 . D @("BQI^"_BQIROU_"(DFN,.BQIGREF)")
 . ;
 . NEW DA
 . S DA(1)=DFN,DA=0,DIK="^BQIPAT("_DA(1)_",30,"
 . F  S DA=$O(@BQIDATA@(DFN,30,DA)) Q:'DA  D ^DIK
 . ;
 . ; if the patient doesn't meet any GPRA logic, quit
 . I '$D(@BQIGREF@(DFN)) Q
 . ;
 . I '$D(@BQIDATA@(DFN,30,0)) S @BQIDATA@(DFN,30,0)="^90507.53^^"
 . ;
 . S SIND="",CT=0
 . F  S SIND=$O(^BQI(90506.1,"AC","G",SIND)) Q:SIND=""  D
 .. S CT=CT+1
 .. I $P(^BQI(90506.1,SIND,0),U,10)=1 Q
 .. S @BQIDATA@(DFN,30,CT,0)=$P(^BQI(90506.1,SIND,0),U,1)
 .. S @BQIDATA@(DFN,30,"B",$P(^BQI(90506.1,SIND,0),U,1),CT)=""
 . ;
 . S IND=0
 . F  S IND=$O(@BQIGREF@(DFN,IND)) Q:IND=""  D
 .. S MEAS=0
 .. F  S MEAS=$O(@BQIGREF@(DFN,IND,MEAS)) Q:MEAS=""  D
 ... ;Q:'$$SUM^BQIGPUTL(BQIYR,MEAS)
 ... S GPMEAS=BQIYR_"_"_MEAS
 ... S MCT=$O(^BQIPAT(DFN,30,"B",GPMEAS,"")) I MCT="" Q
 ... S $P(@BQIDATA@(DFN,30,MCT,0),U,2)=$P(@BQIGREF@(DFN,IND),U,2)
 ... S $P(@BQIDATA@(DFN,30,MCT,0),U,3)=$P(@BQIGREF@(DFN,IND,MEAS),U,2)
 ... S $P(@BQIDATA@(DFN,30,MCT,0),U,4)=$P(@BQIGREF@(DFN,IND,MEAS),U,3)
 . K @BQIGREF
 . NEW DA,DIK
 . S DA=DFN,DIK="^BQIPAT(" D IX1^DIK
 ;
 ; Compile Main view data
 D COMP^BQIGPRA5
 ;
 ; Set the DATE/TIME GPRA STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.08)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.09)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 K MEAS,DFN,IND,BGPIND,BGPBD,BGPED,BGPBBD,BGPBED,BGPPBD,BGPPED
 K BGPQTR,BGPRTYPE,BGPRPT,BGP3YE,BGPP3YE,BGPB3YE,BGPHOME,BHM
 K BQIDATA,BQIH,BQIINDF,BQIINDG,BQIMEASF,BQIMEASG,BQIROU,BQIY,BQIYR
 K @BQIGREF,BQIUPD,MCT,SIND,VLIEN,VOK,X,BQIGREF,BGPPER
 ;
 Q
 ;
REM ;EP - Find any new reminders
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ; Set the DATE/TIME REMINDERS STARTED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.1)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.12)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ; Re-evaluate reminders
 D CHK^BQIRMDR("Nightly")
 ; Check for new CMET followups and recalculate their reminders
 NEW CMDT,IEN,BKDFN
 S CMDT=$$FMADD^XLFDT(DT,-1)-.005
 F  S CMDT=$O(^BTPWP("AU",CMDT)) Q:CMDT=""  D
 . S IEN=""
 . F  S IEN=$O(^BTPWP("AU",CMDT,IEN)) Q:IEN=""  D
 .. S BKDFN=$P(^BTPWP(IEN,0),U,2),^XTMP("BQINIGHT",BKDFN)=""
 ; Check for DUZ
 D DZ^BQITASK1
 ;
 ; Reset Reminders
 NEW BKDFN
 S BKDFN=0,ERRCNT=0
 F  S BKDFN=$O(^XTMP("BQINIGHT",BKDFN)) Q:'BKDFN  D  Q:ERRCNT>100
 . I $G(^BQIPAT(BKDFN,0))="" D NPT^BQITASK(BKDFN)
 . D PAT^BQIRMDR(BKDFN)
 ;
 ; Set the DATE/TIME REMINDERS STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.11)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.12)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD,ERRCNT
 Q
 ;
TRT ;EP - Update treatment prompts
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ; Set the DATE/TIME TREATMENT STARTED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.13)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.15)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 NEW BKDFN
 S BKDFN=0
 F  S BKDFN=$O(^XTMP("BQINIGHT",BKDFN)) Q:'BKDFN  D
 . I $G(^BQIPAT(BKDFN,0))="" D NPT^BQITASK(BKDFN)
 . D PAT^BQITRMT(BKDFN)
 ; Set the DATE/TIME TREATMENT STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.14)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.15)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
INP ;EP - Initialize GPRA variables
 NEW DA,IENS
 I $G(U)="" D DT^DICRW
 ;
 ; Get the internal entry value from the site parameters
 S BQIH=$$SPM^BQIGPUTL()
 S BGPHOME=$$HME^BQIGPUTL()
 ;
 ;  get the current year for CRS
 S BQIYR=$$GET1^DIQ(90508,BQIH,2,"E")
 I BQIYR="" S BQIYR=$P($$FMTE^XLFDT(DT,7),"/",1)
 S BQIY=$$LKP^BQIGPUTL(BQIYR)
 ;  if the current year is not defined yet, get the previous year
 I BQIY=-1 S BQIYR=BQIYR-1,BQIY=$$LKP^BQIGPUTL(BQIYR) I BQIY=-1 Q
 ;
 ;  get the global references for the corresponding CRS year
 S DA(1)=BQIH,DA=BQIY
 S IENS=$$IENS^DILF(.DA)
 S BQIINDF=$$GET1^DIQ(90508.01,IENS,.02,"E")
 S BQIINDG=$$ROOT^DILFD(BQIINDF,"",1)
 S BQIMEASF=$$GET1^DIQ(90508.01,IENS,.03,"E")
 S BQIMEASG=$$ROOT^DILFD(BQIMEASF,"",1)
 S BQIROU=$$GET1^DIQ(90508.01,IENS,.04,"E")
 Q
 ;
REG ;EP - Check for register updates and apply in iCare
 ; Process register records into tags
 NEW REGIEN,RDATA,TAG,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD
 NEW DFN,RIEN,QFL,DATE,TGNM,PSTAT,DATA
 S REGIEN=0
 F  S REGIEN=$O(^BQI(90507,REGIEN)) Q:'REGIEN  D
 . S RDATA=^BQI(90507,REGIEN,0)
 . ; If the register is inactive, quit
 . I $P(RDATA,U,8)=1 Q
 . ; Check if register is associated with a tag, if there isn't one, quit
 . S TAG=$O(^BQI(90506.2,"AD",REGIEN,"")) I TAG="" Q
 . S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 . S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 . S SUBREG=$P(RDATA,U,9)
 . S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 . S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 . I GLBNOD="" Q
 . ;
 . I '$D(@GLBNOD@(0)) Q
 . ;
 . S DFN=""
 . F  S DFN=$O(@GLBREF@(DFN)) Q:DFN=""  D
 .. ; If patient is deceased, quit
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. ;
 .. I $G(SUBREG)'="" S QFL=0 D  Q:'QFL
 ... Q:FILE'=9002241
 ... S RIEN=""
 ... F  S RIEN=$O(@GLBREF@(DFN,RIEN)) Q:RIEN=""  D
 .... I $P($G(@GLBNOD@(RIEN,0)),U,5)=SUBREG S QFL=1,IENS=RIEN
 .. ; Check register status
 .. I $G(SUBREG)="" S IENS=$O(@GLBREF@(DFN,""))
 .. I STEX'="" X STEX Q:'$D(IENS)
 .. S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 .. S DATE=$P($G(^BQIPAT(DFN,20,TAG,0)),U,2)
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 .. I PSTAT="U"!(PSTAT="") D  Q
 ... ; If patient is already tagged, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))'="" Q
 ... ; else build a "proposed" record
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. I PSTAT="D" Q
 .. I PSTAT="I" D  Q
 ... ; If the patient was not tagged and is inactive on register, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))="" Q
 ... ; If the patient was tagged and is inactive on register
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. D EN^BQITDPRC(.DATA,DFN,TAG,"A",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT)
 .. ; Remove any temporary BQIPAT data
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 Q
 ;
JBC ;EP - Check on MU jobs
 NEW ZTSK,NJOB,YJOB,NXDT
 S NJOB=$P($G(^BQI(90508,1,12)),U,5)
 ;S YJOB=$P($G(^BQI(90508,1,12)),U,6)
 ;
 ; check on ninety day job
 I NJOB'="" D  Q
 . S ZTSK=NJOB D STAT^%ZTLOAD
 . I $G(ZTSK(2))'="Active: Pending" D
 .. I $G(ZTSK(2))="Active: Running" Q
 .. I $G(ZTSK(2))="Inactive: Finished" S $P(^BQI(90508,1,12),U,5)="" D  Q
 ... NEW BMDT
 ... S BMDT=$P(^BQI(90508,1,12),U,9),BMDT=$$FMADD^XLFDT(BMDT,1)
 ... I $D(^XTMP("BQIMMON",BMDT)) K ^XTMP("BQIMMON",BMDT)
 ... I $O(^XTMP("BQIMMON",""),-1)="" K ^XTMP("BQIMMON") Q
 ... D NJB
 .. I $G(ZTSK(2))="Inactive: Interrupted"!($G(ZTSK(2))="Undefined") D
 ... S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 ... S ZTDESC="MU CQ Continue Compile",ZTRTN="NIN^BQITASK6",ZTIO=""
 ... D ^%ZTLOAD
 ... S BQIUPD(90508,"1,",12.05)=ZTSK
 ... D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; If both job do not have a task number, quit
 I NJOB="" D NJB Q
 Q
 ;
 ; check on year job
 ;I YJOB'="" D
 ;. S ZTSK=YJOB D STAT^%ZTLOAD
 ;. I $G(ZTSK(2))'="Active: Pending" D
 ;.. I $G(ZTSK(2))="Active: Running" Q
 ;.. I $G(ZTSK(2))="Inactive: Finished" S $P(^BQI(90508,1,12),U,6)="" Q
 ;.. I $G(ZTSK(2))="Inactive: Interrupted"!($G(ZTSK(2))="Undefined") D
 ;... S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 ;... S ZTDESC="MU CQM Continue Compile",ZTRTN="CQM^BQITASK5",ZTIO=""
 ;... D ^%ZTLOAD
 ;... S BQIUPD(90508,"1,",12.06)=ZTSK
 ;... D FILE^DIE("","BQIUPD","ERROR")
 ;
 Q
 ;
NJB ;EP - Next job
 I $P($G(^BQI(90508,1,12)),U,3)=0 D
 . ; Check if aggregation needed
 . ;D EN^BQIMUAGG
 . ; Get next date to process
 . S NXDT=$O(^XTMP("BQIMMON",""),-1) I 'NXDT Q
 . D EN^BQIMUMON(NXDT)
 Q
