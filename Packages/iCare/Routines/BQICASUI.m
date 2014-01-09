BQICASUI ;PRXM/HC/ALA-Find Community Suicides ; 11 Oct 2007  2:10 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;
FND ; EP - Find Suicides
 NEW DATA,ENDT,STDT,DATE,VC,VCIEN,VCODE,RIEN,IEN,CIEN,CM,COMM,DFN,DIEN
 NEW DTC,DTE,DTY,E1,E2,E3,PT,SIEN,TAX,TIEN,TREF,VISIT,VSDTM,X,XIEN,Y
 NEW FILE
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ; Set the alert temporary global
 S DATA=$NA(^TMP("BQISUICTMP",UID))
 K @DATA
 ;
 NEW DA,IENS,BQIH,BQI,TMFRAME,ENDT,DATE,STDT,VC,VCODE,RIEN,IEN,VCIEN
 NEW DFN,COMM,TREF,VISIT,VSDTM,DTY,E1,E2,E3,CM,PT
 S BQIH=$$SPM^BQIGPUTL()
 S BQI=$O(^BQI(90508,BQIH,15,"B","Suicidal Behavior",""))
 S DA(1)=BQIH,DA=BQI,IENS=$$IENS^DILF(.DA)
 S TMFRAME=$$GET1^DIQ(90508.015,IENS,.03,"E") S:TMFRAME="" TMFRAME=30
 S TMFRAME="T-"_TMFRAME
 S ENDT=DT,STDT=$$DATE^BQIUL1(TMFRAME),DATE=STDT_".24"
 ;
 ; Set up the visit codes
 F VC=39,40,41 S VCIEN=$O(^AMHPROB("B",VC,"")) Q:VCIEN=""  D
 . S VCODE(VCIEN)=$P(^AMHPROB(VCIEN,0),U,5)
 . S:VC=39 $P(VCODE(VCIEN),U,2)="Ideation"
 . S:VC=40 $P(VCODE(VCIEN),U,2)="Attempt"
 . S:VC=41 $P(VCODE(VCIEN),U,2)="Completion"
 ;
 ; Check in the MHSS files
 F  S DATE=$O(^AMHREC("B",DATE)) Q:DATE=""!(DATE\1>ENDT)  D
 . S RIEN=""
 . F  S RIEN=$O(^AMHREC("B",DATE,RIEN)) Q:RIEN=""  D
 .. S IEN=""
 .. F  S IEN=$O(^AMHRPRO("AD",RIEN,IEN),-1) Q:IEN=""  D
 ... S VCIEN=$P(^AMHRPRO(IEN,0),U,1)
 ... I '$D(VCODE(VCIEN)) Q
 ... S DFN=$P(^AMHRPRO(IEN,0),U,2) I DFN="" S DFN="Not identified"
 ... S FILE=9002011.01
 ... S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 ... I COMM="" S COMM="Not identified"
 ... S @DATA@(COMM,DFN,$P(VCODE(VCIEN),U,2),DATE\1,$P(VCODE(VCIEN),U,1))=RIEN_U_IEN_U_FILE_U
 ;
 ; Check for a Suicide Form
 NEW DTACT,RIEN,STY,TYPE,FILE,DFN,COMM,ICD
 S DTACT=$$DATE^BQIUL1("T-30"),DTACT=DTACT-.001
 F  S DTACT=$O(^AMHPSUIC("AD",DTACT)) Q:DTACT=""  D
 . S RIEN=""
 . F  S RIEN=$O(^AMHPSUIC("AD",DTACT,RIEN)) Q:RIEN=""  D
 .. S FILE=9002011.65
 .. S DFN=$P(^AMHPSUIC(RIEN,0),U,4),TYPE=$$GET1^DIQ(9002011.65,RIEN_",",.13,"I")
 .. I TYPE="" Q
 .. S STY=$S(TYPE=1:"Ideation",TYPE=2!(TYPE=4)!(TYPE=6)!(TYPE=7):"Attempt",1:"Completion")
 .. S ICD=$S(STY="Ideation":"V62.84",STY="Attempt":300.9,1:798.1)
 .. S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 .. I COMM="" S COMM="Not identified"
 .. S @DATA@(COMM,DFN,STY,DTACT\1,ICD)=RIEN_U_U_FILE
 ; Check in PCC
 S TREF=$NA(^TMP("BQITAX",UID))
 K @TREF
 D BLDSV^BQITUTL(80,"V62.84 ",TREF)
 ;D BLDSV^BQITUTL(80,"798.1 ",TREF)
 S TIEN=0 F  S TIEN=$O(@TREF@(TIEN)) Q:'TIEN  D
 . S IEN=""
 . F  S IEN=$O(^AUPNVPOV("B",TIEN,IEN),-1) Q:IEN=""  D
 .. ;  if a bad record (no zero node), quit
 .. I $G(^AUPNVPOV(IEN,0))="" Q
 .. ;  get patient record
 .. S DFN=$$GET1^DIQ(9000010.07,IEN,.02,"I") Q:DFN=""
 .. S VISIT=$$GET1^DIQ(9000010.07,IEN,.03,"I") Q:VISIT=""
 .. ;  if the visit is deleted, quit
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:VSDTM=0
 .. S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 .. S FILE=9000010
 .. I COMM="" S COMM="Not identified"
 .. I $G(TMFRAME)'="",VSDTM'>STDT Q
 .. ;I $G(TMFRAME)'="",VSDTM<STDT Q
 .. S DTY=$S(@TREF@(TIEN)["V62.84":"Ideation",1:"Completion")
 .. ;I '$D(@DATA@(COMM,DFN,DTY,VSDTM)) S @DATA@(COMM,DFN,DTY,VSDTM,@TREF@(TIEN))=VISIT_U_U_$S(@TREF@(TIEN)["V62.84":"Ideation",1:"Completion")_U_FILE Q
 .. I '$D(@DATA@(COMM,DFN,DTY,VSDTM)) S @DATA@(COMM,DFN,DTY,VSDTM,@TREF@(TIEN))=VISIT_U_U_FILE Q
 ; Look for ECODES
 K @TREF
 S TAX="APCL INJ SUICIDE"
 D BLD^BQITUTL(TAX,TREF)
 ;S DATE=STDT
 S DATE=STDT_".24"
 F  S DATE=$O(^AUPNVSIT("B",DATE)) Q:DATE=""!(DATE\1>ENDT)  D
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",DATE,VISIT)) Q:VISIT=""  D
 .. S IEN=""
 .. F  S IEN=$O(^AUPNVPOV("AD",VISIT,IEN)) Q:IEN=""  D
 ... S E1=$P(^AUPNVPOV(IEN,0),U,9)
 ... S E2=$P(^AUPNVPOV(IEN,0),U,18)
 ... S E3=$P(^AUPNVPOV(IEN,0),U,19)
 ... I E1="",E2="",E3="" Q
 ... I E1'="",$D(@TREF@(E1)) D STOR(E1)
 ... I E2'="",$D(@TREF@(E2)) D STOR(E2)
 ... I E3'="",$D(@TREF@(E3)) D STOR(E3)
 ;
 ; Check for duplicates
 NEW LDTE
 S (CM,DTY,PT)=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . F  S PT=$O(@DATA@(CM,PT)) Q:PT=""  D
 .. F  S DTY=$O(@DATA@(CM,PT,DTY)) Q:DTY=""  D
 ... S DTE=$O(@DATA@(CM,PT,DTY,""),-1) Q:DTE=""
 ... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ... F  S DTE=$O(@DATA@(CM,PT,DTY,DTE),-1) Q:DTE=""  D
 .... ; Only one suicide type per patient per 30 day period should be included
 .... I DTE>LDTE K @DATA@(CM,PT,DTY,DTE) Q
 .... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ;
 S CM=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . S PT=""
 . F  S PT=$O(@DATA@(CM,PT)) Q:PT=""  D
 .. S DTY=""
 .. F  S DTY=$O(@DATA@(CM,PT,DTY)) Q:DTY=""  D
 ... S DTE=""
 ... F  S DTE=$O(@DATA@(CM,PT,DTY,DTE)) Q:DTE=""  D
 .... S DTC=""
 .... F  S DTC=$O(@DATA@(CM,PT,DTY,DTE,DTC)) Q:DTC=""  D
 ..... S VISIT=$P(@DATA@(CM,PT,DTY,DTE,DTC),U,1)
 ..... S FILE=$P(@DATA@(CM,PT,DTY,DTE,DTC),U,3)
 ..... D NFILE(CM,DTY,DTC,DTE,VISIT,PT,FILE)
 ;
 K @TREF,@DATA
 Q
 ;
NFILE(COMM,DCAT,DXC,DATE,VISIT,PT,FILE) ;
 ; Input
 ;   COMM  - Community
 ;   DCAT  - Diagnosis Category
 ;   DXC   - Diagnosis Code
 ;   DATE  - Event Date
 ;   VISIT - Visit to make it unique
 ;   PT    - DFN
 ; Assumed that the Alert Type is Suicidal Behavior
 NEW DIC,DA,AIEN,CIEN,DIEN,RIEN,NFLG,USR
 ;  Set the community
 S DIC="^BQI(90507.6,",X="`"_COMM,DIC(0)="LMZ"
 D ^DIC
 S CIEN=+Y
 I CIEN=-1 S (X,DINUM)=COMM K DO,DD D FILE^DICN S CIEN=+Y
 ;  Set the Alert Type
 S DA(1)=CIEN,X="Suicidal Behavior",DIC="^BQI(90507.6,"_DA(1)_",1,",DIC(0)="LMN"
 I $G(^BQI(90507.6,DA(1),1,0))="" S ^BQI(90507.6,DA(1),1,0)="^90507.61A^^"
 D ^DIC
 S AIEN=+Y
 ;  Set the DX Category
 S DA(2)=CIEN,DA(1)=AIEN,X=DCAT,DIC(0)="LMN"
 S DIC="^BQI(90507.6,"_DA(2)_",1,"_DA(1)_",1,"
 I $G(^BQI(90507.6,DA(2),1,DA(1),1,0))="" S ^BQI(90507.6,DA(2),1,DA(1),1,0)="^90507.611A^^"
 D ^DIC
 S DIEN=+Y
 ;  Set the Dx Code
 K X
 ;S DA(3)=CIEN,DA(2)=AIEN,DA(1)=DIEN,X(1)=DXC,X(2)=DATE,X(3)=VISIT,DIC(0)="LN",D="C"
 S DA(3)=CIEN,DA(2)=AIEN,DA(1)=DIEN,X(1)=PT,X(2)=DATE,X(3)=VISIT,DIC(0)="LN",D="D"
 S DIC="^BQI(90507.6,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",1,"
 I $G(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,0))="" S ^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,0)="^90507.6111A^^"
 D IX^DIC
 I Y=-1 D
 . K X,D
 . S X(1)=DXC,X(2)=DATE,X(3)=VISIT,D="C"
 . D IX^DIC
 S RIEN=+Y,NFLG=+$P(Y,U,3)
 S $P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,RIEN,0),U,4)=PT
 S $P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,RIEN,0),U,5)=FILE
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 NEW DIK
 S DIK=DIC,DIK(1)=.04
 D ENALL^DIK
 ;
 Q
 ;  Set the users
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . S DA(3)=CIEN,DA(2)=AIEN,DA(1)=DIEN,X=USR,DIC(0)="LMN",DINUM=X
 . S DIC="^BQI(90507.6,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",5,"
 . I $G(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),5,0))="" S ^BQI(90507.6,DA(3),1,DA(2),1,DA(1),5,0)="^90507.6115PA^^"
 . K DO,DD D FILE^DICN
 Q
 ;
STOR(TIEN) ;
 NEW DFN,COMM,FILE
 S DFN=$$GET1^DIQ(9000010.07,IEN,.02,"I") Q:DFN=""
 S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 S FILE=9000010
 I COMM="" S COMM="Not identified"
 I '$D(@DATA@(COMM,DFN,"Not Categorized",VSDTM)) S @DATA@(COMM,DFN,"Not Categorized",VSDTM,@TREF@(TIEN))=VISIT_U_U_FILE Q
 Q
