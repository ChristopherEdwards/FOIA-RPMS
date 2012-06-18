BQI1POJB ;PRXM/HC/ALA-Ver 1.0 Post Install Task Job ; 02 Mar 2006  9:52 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
ENT ;EP - Entry point for all tagging
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB"
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 D FLG
 D DXC
 D GPR
 ;
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0))
 I 'DA Q
 S DR=".1///^S X=""@""",DIE=DIC D ^DIE
 K INSTALL,UID
 Q
 ;
FLG ;  Entry point to tag all users with flags
 ;   
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 I $G(DT)="" D DT^DICRW
 ;  Set the DATE/TIME FLAG STARTED field
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0))
 I 'DA Q
 S DR=".02///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 ;
 ; Find all flags for patients
 S INSTALL=1
 D FND^BQIFLG
 ;
 ;  Set the DATE/TIME FLAG STOPPED field
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0))
 I 'DA Q
 S DR=".03///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 Q
 ;
DXC ;  Tag the diagnosis categories
 ; Variables
 ;   BQDEF  - Diag Cat Definition Name
 ;   BQEXEC - Diag Cat special executable program
 ;   BQPRG  - Diag Cat standard executable program
 ;   BQREF  - Taxonomy array reference
 ;   BQGLBB  - Temporary global reference
 ;   BQORD  - Order that the category must be determined
 ;           (Some categories depend upon a patient not being
 ;            in another category)
 ;   BQTN   - Diag Cat internal entry number
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;   Set the DATE/TIME DXN CATEGORY STARTED field
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0)) I 'DA Q
 S DR=".06///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 ;
 NEW BQTN,BQDEF,BQORD
 S BQORD=""
 F  S BQORD=$O(^BQI(90506.2,"AC",BQORD)) Q:BQORD=""  D
 . S BQTN=0
 . F  S BQTN=$O(^BQI(90506.2,"AC",BQORD,BQTN)) Q:'BQTN  D
 .. ; If the category is marked as inactive, ignore it
 .. I $$GET1^DIQ(90506.2,BQTN_",",.03,"I") Q
 .. ; If the category is a subdefinition, ignore it
 .. I $$GET1^DIQ(90506.2,BQTN_",",.05,"I")=1 Q
 .. S BQDEF=$$GET1^DIQ(90506.2,BQTN_",",.01,"E")
 .. S BQEXEC=$$GET1^DIQ(90506.2,BQTN_",",1,"E")
 .. S BQPRG=$$GET1^DIQ(90506.2,BQTN_",",.04,"E")
 .. ;
 .. ; Set the taxonomy array from the file definition
 .. S BQREF="BQIRY" K @BQREF
 .. D ARY^BQITUTL(BQDEF,BQREF)
 .. S BQGLBB=$NA(^TMP("BQIPOP",UID))
 .. K @BQGLBB
 .. ;
 .. ; Call the populate category code
 .. S PRGM="POP^"_BQPRG_"(BQREF,BQGLBB)"
 .. D @PRGM
 .. ;
 .. ; File the returned patients
 .. S DFN=0
 .. F  S DFN=$O(@BQGLBB@(DFN)) Q:DFN=""  D FIL(BQGLBB)
 .. Q
 ;
 K @BQGLBB,AGE,BQEXEC,BQDEF,BQPRG,@BQREF,BQREF,BQGLBB,DFN,PRGM
 K SEX,TXDXCN,TXDXCT,TXT,Y
 ;
 ;  Set the DATE/TIME DXN CATEGORY STOPPED field
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0)) I 'DA Q
 S DR=".07///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 Q
 ;
GPR ;  Entry point to get GPRA values for all users
 ;
 ;Variables
 ;  BQIGREF - Temporary global reference that returns the raw GPRA data
 ;  BQIDATA - Global reference for iCare Patients.
 ;  
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 NEW BGP3YE,BGPB3YE,BGPBBD,BGPBD,BGPBED,BGPED,BGPIND,BGPP3YE,BGPPBD,BGPPED
 NEW BGPQTR,BGPRPT,BGPRTYPE,BQIDATA,BQIGREF,BQIH,BQIINDG,BQIPUP,BQIROU,BQIY
 NEW BQIYR,IND,MCT,MEAS,SIND,BGPPER,BQIDFN
 NEW DIC,DIE,DR,DA
 ;
 ; Set the DATE/TIME GPRA STARTED field
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0)) I 'DA Q
 S DR=".04///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 ;
 NEW DFN
 S BQIGREF=$NA(^TMP("BQIGPRA",UID))
 K @BQIGREF
 S BQIDATA=$NA(^BQIPAT)
 ;
 ;  Initialize data
 D INP^BQINIGHT
 ;  If the routine is not defined, quit
 I $G(BQIROU)="" G EXIT
 ;
 ;  If the tag is not defined, quit
 I $T(@("BQI^"_BQIROU))="" G EXIT
 ;
 ;  Initialize GPRA variables
 S X=0 F  S X=$O(@BQIINDG@("GPRA",1,X)) Q:X'=+X  S BGPIND(X)=""
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
 ;  For every patient in the database, call the GPRA API
 S BQIDFN=0
 F  S BQIDFN=$O(^AUPNPAT(BQIDFN)) Q:'BQIDFN  D
 . ; If patient is deceased, don't calculate
 . I $P($G(^DPT(BQIDFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(BQIDFN) Q
 . ; If patient has no visits in 3 years, quit
 . I '$$VTHR^BQIUL1(BQIDFN) Q
 . ;
 . D @("BQI^"_BQIROU_"(BQIDFN,.BQIGREF)")
 . ;
 . ;  if the patient doesn't already exist in the iCare Patient file, add them
 . I $G(^BQIPAT(BQIDFN,0))="" D
 .. NEW DIC,X,DINUM,DLAYGO
 .. S (X,DINUM)=BQIDFN,DLAYGO=90507.5,DIC="^BQIPAT(",DIC(0)="L"
 .. K DO,DD D FILE^DICN
 . ; Remove any previous GPRA data
 . K @BQIDATA@(BQIDFN,30)
 . S @BQIDATA@(BQIDFN,30,0)="^90507.53^^"
 . ;
 . ; if the patient doesn't meet any GPRA logic, quit
 . I '$D(@BQIGREF@(BQIDFN)) Q
 . ;
 . ;  set the year of the GPRA and the begin/end dates
 . S BQIPUP(90507.5,BQIDFN_",",.02)=BQIYR
 . S BQIPUP(90507.5,BQIDFN_",",.03)=BGPBD
 . S BQIPUP(90507.5,BQIDFN_",",.04)=BGPED
 . S BQIPUP(90507.5,BQIDFN_",",.05)=$$NOW^XLFDT()
 . D FILE^DIE("","BQIPUP","ERROR")
 . K BQIPUP
 . ;
 . ;  initialize the summary indicators for the patient
 . S CT=0,SIND=""
 . F  S SIND=$O(^BQI(90506.1,"AC","G",SIND)) Q:SIND=""  D
 .. S CT=CT+1
 .. I $P(^BQI(90506.1,SIND,0),U,10)=1 Q
 .. S @BQIDATA@(BQIDFN,30,CT,0)=$P(^BQI(90506.1,SIND,0),U,1)
 .. S @BQIDATA@(BQIDFN,30,"B",$P(^BQI(90506.1,SIND,0),U,1),CT)=""
 . ;
 . S IND=0
 . F  S IND=$O(@BQIGREF@(BQIDFN,IND)) Q:IND=""  D
 .. S MEAS=0
 .. F  S MEAS=$O(@BQIGREF@(BQIDFN,IND,MEAS)) Q:MEAS=""  D
 ... S GPMEAS=BQIYR_"_"_MEAS
 ... S MCT=$O(^BQIPAT(BQIDFN,30,"B",GPMEAS,"")) I MCT="" Q
 ... S $P(@BQIDATA@(BQIDFN,30,MCT,0),U,2)=$P(@BQIGREF@(BQIDFN,IND),U,2)
 ... S $P(@BQIDATA@(BQIDFN,30,MCT,0),U,3)=$P(@BQIGREF@(BQIDFN,IND,MEAS),U,2)
 ... S $P(@BQIDATA@(BQIDFN,30,MCT,0),U,4)=$P(@BQIGREF@(BQIDFN,IND,MEAS),U,3)
 . K @BQIGREF
 . ; reindex the patient record
 . NEW DA,DIK
 . S DA=BQIDFN,DIK="^BQIPAT(" D IX1^DIK
 ;
EXIT ; Set the DATE/TIME GPRA STOPPED
 NEW DIC,DIE,DR,DA
 S DIC="^BQI(90508,",DA=$O(^BQI(90508,0)) I 'DA Q
 S DR=".05///^S X="_$$NOW^XLFDT(),DIE=DIC D ^DIE
 Q
 ;
FIL(BQGLBB) ;EP - File diagnosis category
 NEW DA,IENS,DIC,X,DLAYGO,DINUM,EVN,TXN,TYP
 ; Exclude deceased patients
 I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 ;  if the patient doesn't already exist in the iCare Patient file, add them
 I $G(^BQIPAT(DFN,0))="" D
 . NEW DIC,X,DINUM,DLAYGO
 . S (X,DINUM)=DFN,DLAYGO=90507.5,DIC="^BQIPAT(",DIC(0)="L"
 . K DO,DD D FILE^DICN
 ;
 S DA(1)=DFN
 I '$D(^BQIPAT(DFN,20,0)) S ^BQIPAT(DFN,20,0)="^90507.52P^^"
 S (X,DINUM)=BQTN,DIC(0)="L",DIC="^BQIPAT("_DA(1)_",20,",DLAYGO=90507.52
 K DO,DD D FILE^DICN
 S DA=+Y,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.52,IENS,.02)=$$NOW^XLFDT()
 S BQIUPD(90507.5,DFN_",",.06)=$$NOW^XLFDT()
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ;  Remove previous criteria
 NEW DA,DIK
 S DA(2)=DFN,DA(1)=BQTN,DA=0,DIK="^BQIPAT("_DA(2)_",20,"_DA(1)_",1,"
 F  S DA=$O(^BQIPAT(DFN,20,BQTN,1,DA)) Q:'DA  D ^DIK
 ;
 ;  Add the criteria on why patient met diagnosis category
 S TXT=""
 F  S TXT=$O(@BQGLBB@(DFN,"CRITERIA",TXT)) Q:TXT=""  D
 . I '$D(^BQIPAT(DFN,20,BQTN,1,0)) S ^BQIPAT(DFN,20,BQTN,1,0)="^90507.521^^"
 . NEW DA
 . S DA(2)=DFN,DA(1)=BQTN,X=TXT,DIC(0)="L"
 . S DIC="^BQIPAT("_DA(2)_",20,"_DA(1)_",1,",DLAYGO=90507.521
 . K DO,DD D FILE^DICN
 . S TXN=+Y
 . I '$D(^BQIPAT(DFN,20,BQTN,1,TXN,1,0)) S ^BQIPAT(DFN,20,BQTN,1,TXN,1,0)="^90507.5211^^"
 . F TYP="P" S EVN="" D
 .. F  S EVN=$O(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN)) Q:EVN=""  D
 ... NEW DA,IENS
 ... S DA(3)=DFN,DA(2)=BQTN,DA(1)=TXN,DIC(0)="L",DLAYGO=90507.5211,X=TYP_EVN
 ... S DIC="^BQIPAT("_DA(3)_",20,"_DA(2)_",1,"_DA(1)_",1,"
 ... D ^DIC
 ... S DA=+Y,IENS=$$IENS^DILF(.DA)
 ... S BQIUPD(90507.5211,IENS,.02)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,1)
 ... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,2)'="" S BQIUPD(90507.5211,IENS,.03)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,2)
 ... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,3)'="" S BQIUPD(90507.5211,IENS,.04)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,3)
 ... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,4)'="" S BQIUPD(90507.5211,IENS,.05)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN),U,4)
 ... D FILE^DIE("","BQIUPD","ERROR")
 ... K BQIUPD
 . F TYP="V" S EVN="" D
 .. F  S EVN=$O(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN)) Q:EVN=""  D
 ... S MEVN=""
 ... F  S MEVN=$O(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN)) Q:MEVN=""  D
 .... NEW DA,IENS
 .... S DA(3)=DFN,DA(2)=BQTN,DA(1)=TXN,DIC(0)="L",DLAYGO=90507.5211,X=TYP_EVN
 .... S DIC="^BQIPAT("_DA(3)_",20,"_DA(2)_",1,"_DA(1)_",1,"
 .... D ^DIC
 .... I $P(Y,U,3)'=1 D
 ..... I Y=-1 K DO,DD D FILE^DICN Q
 ..... I $P(^BQIPAT(DFN,20,BQTN,1,TXN,1,+Y,0),U,4)'=MEVN K DO,DD D FILE^DICN
 .... S DA=+Y,IENS=$$IENS^DILF(.DA)
 .... S BQIUPD(90507.5211,IENS,.02)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,1)
 .... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,2)'="" S BQIUPD(90507.5211,IENS,.03)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,2)
 .... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,3)'="" S BQIUPD(90507.5211,IENS,.04)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,3)
 .... I $P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,4)'="" S BQIUPD(90507.5211,IENS,.05)=$P(@BQGLBB@(DFN,"CRITERIA",TXT,TYP,EVN,MEVN),U,4)
 .... D FILE^DIE("","BQIUPD","ERROR")
 .... K BQIUPD
 Q
 ;
ERR ;  Error trapping
 S BQIUPD(90508,"1,",.1)="@"
 S BQIUPD(90508,"1,",.14)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 D ^%ZTER
 Q
