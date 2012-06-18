BQICALRT ;VNGT/HS/ALA-Community Alerts ; 03 Oct 2007  2:16 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
FND ;EP - Find alerts
 NEW DA,DIK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 ; Clear out existing Community Alerts before recalculating them
 S DA=0,DIK="^BQI(90507.6,"
 F  S DA=$O(^BQI(90507.6,DA)) Q:'DA  D ^DIK
 I $D(^BQI(90507.6,-1)) K ^BQI(90507.6,-1)
 ;
 ; Find clinics for primary care
 NEW TREF,TAX,PREF,TMFRAME,STDT,ENDT,ALRT,BGDA,BGI,BGPC,BGPCI,A
 NEW ATIEN,CM,TY,PT,DTE,DXN,DXCC,CIEN,DIEN,RIEN,XIEN,E,EXEC,G,IEN
 NEW OK,PCL,SIEN,V,VISIT,VSDTM,X,Y,COMM,DFN,DOD,DTY,ATY
 ; Need to get the program for the GPRA year to check active population
 NEW BGPHOME,BQIH,BQIINDF,BQIINDG,BQIMEASF,BQIMEASG,BQIY,BQIYR,BQIROU
 D INP^BQINIGHT
 I $G(DT)="" D DT^DICRW
 ; Get primary clinic list
 S PREF=$NA(^TMP("BQIPRCR",UID))
 K @PREF
 S BGDA=$O(^BGPCTRL("B",BQIYR,"")) I BGDA="" Q
 S BGI=0
 F  S BGI=$O(^BGPCTRL(BGDA,12,BGI)) Q:'BGI  D
 . S BGPC=$P(^BGPCTRL(BGDA,12,BGI,0),U,1)
 . S BGPCI=$O(^DIC(40.7,"C",BGPC,"")) I BGPCI="" Q
 . S @PREF@(BGPCI)=BGPC
 ;
 ; Set the alert temporary global
 NEW DATA
 S DATA=$NA(^TMP("BQIALRTTMP",UID))
 K @DATA
 ;
 NEW DA,IENS,BQIH,BQI,TX,QFL,REP,TME,HAS
 S BQIH=$$SPM^BQIGPUTL()
 ;
 ; For each community alert, set up temporary to check for duplicates
 S ALRT=0
 F  S ALRT=$O(^BQI(90507.8,ALRT)) Q:'ALRT  D
 . S TY=$P($G(^BQI(90507.8,ALRT,2)),U,1)
 . S BQI=$O(^BQI(90508,BQIH,15,"B",TY,""))
 . NEW DA,IENS
 . S DA(1)=BQIH,DA=BQI,IENS=$$IENS^DILF(.DA)
 . S TMFRAME="T-"_$$GET1^DIQ(90508.015,IENS,.03,"E")
 . S ENDT=DT,STDT=$$DATE^BQIUL1(TMFRAME)
 . ; Check for taxonomies
 . S TX=0,QFL=0
 . F  S TX=$O(^BQI(90507.8,ALRT,11,TX)) Q:'TX  D
 .. S TAX=$P(^BQI(90507.8,ALRT,11,TX,0),U,1)
 .. S TREF=$NA(^TMP("BQITAX",UID))
 .. K @TREF
 .. D BLD^BQITUTL(TAX,TREF)
 .. I '$D(@TREF) Q
 .. S ATIEN=0,QFL=1
 .. F  S ATIEN=$O(@TREF@(ATIEN)) Q:ATIEN=""  D SRC(ATIEN)
 . Q:QFL
 . ; Check for ICD codes
 . S ATIEN=""
 . F  S ATIEN=$O(^BQI(90507.8,ALRT,10,"B",ATIEN)) Q:ATIEN=""  D
 .. D SRC(ATIEN)
 ;
 ; Check for duplicates
 NEW LDTE
 S (CM,TY,PT)=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . F  S TY=$O(@DATA@(CM,TY)) Q:TY=""  D
 .. F  S PT=$O(@DATA@(CM,TY,PT)) Q:PT=""  D
 ... S DTE=$O(@DATA@(CM,TY,PT,""),-1) Q:DTE=""
 ... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ... F  S DTE=$O(@DATA@(CM,TY,PT,DTE),-1) Q:DTE=""  D
 .... ; Only one alert type per patient per 30 day period should be included
 .... I DTE>LDTE K @DATA@(CM,TY,PT,DTE) Q
 .... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ;
 S CM=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . S TY=""
 . F  S TY=$O(@DATA@(CM,TY)) Q:TY=""  D
 .. S DTY=$P(^BQI(90507.8,TY,0),U,1),ATY=$P($G(^BQI(90507.8,TY,2)),U,1)
 .. S REP=$P($G(^BQI(90507.8,TY,2)),U,5)
 .. S TME=$S(REP=1:"T-61",REP=2:"T-183",REP=3:"T-365",1:"")
 .. S TAX=$P($G(^BQI(90507.8,TY,11,1,0)),U,1)
 .. S PT=""
 .. F  S PT=$O(@DATA@(CM,TY,PT)) Q:PT=""  D
 ... I TAX'="" S HAS=$$TAX^BQICAUTL(TME,TAX,2,PT,9000010.07,1,0)
 ... I TAX="" D
 .... S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 .... S N=0
 .... F  S N=$O(^BQI(90507.8,TY,10,N)) Q:'N  S IEN=$P(^BQI(90507.8,TY,10,N,0),U,1),COD=$P(^(0),U,2),@TREF@(IEN)=COD
 .... S HAS=$$TAX^BQICAUTL(TME,"",2,PT,9000010.07,0,0,.TREF)
 ... S DTE=""
 ... F  S DTE=$O(@DATA@(CM,TY,PT,DTE)) Q:DTE=""  D
 .... S DXN=""
 .... F  S DXN=$O(@DATA@(CM,TY,PT,DTE,DXN)) Q:DXN=""  D
 ..... I $T(ICDDX^ICDCODE)'="" S DXCC=$$ICD9^BQIUL3(DXN,DTE\1,2) ; Code set versioning
 ..... I $T(ICDDX^ICDCODE)="" S DXCC=$$GET1^DIQ(80,DXN_",",.01,"E")
 ..... I DXCC="" Q
 ..... S VISIT=$P(@DATA@(CM,TY,PT,DTE,DXN),U,1)
 ..... I $P(HAS,U,1)=1 Q
 ..... D NFILE(CM,DTY,DXCC,DTE,VISIT,PT,ATY)
 ;
 ;K @DATA,DATA
 Q
 ;
NFILE(COMM,DCAT,DXC,DATE,VISIT,PT,ATYP) ;
 ; Input
 ;   COMM - Community
 ;   DCAT - Diagnosis Category
 ;   DXC  - Diagnosis Code
 ;   DATE - Event Date
 ;   PT   - DFN
 ;   ATYP - Passed Alert Type
 ;
 NEW DIC,DA,D,AIEN,NFLG
 ;  Set the community
 S DIC="^BQI(90507.6,",X="`"_COMM,DIC(0)="LMZ"
 D ^DIC
 S CIEN=+Y
 I CIEN=-1 S (X,DINUM)=COMM K DO,DD D FILE^DICN S CIEN=+Y
 ;  Set the Alert Type
 S DA(1)=CIEN,X=ATYP,DIC="^BQI(90507.6,"_DA(1)_",1,",DIC(0)="LMN"
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
 S $P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,RIEN,0),U,5)=9000010
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 NEW DIK
 S DIK=DIC,DIK(1)=.04
 D ENALL^DIK
 ;
 Q
 ;  Set the users
 NEW DA,DIC,DINUM,USR
 S USR=0
 F  S USR=$O(^BQICARE(USR)) Q:'USR  D
 . S DA(3)=CIEN,DA(2)=AIEN,DA(1)=DIEN,X=USR,DIC(0)="LMN",DINUM=X
 . S DIC="^BQI(90507.6,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",5,"
 . I $G(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),5,0))="" S ^BQI(90507.6,DA(3),1,DA(2),1,DA(1),5,0)="^90507.6115PA^^"
 . K DO,DD D FILE^DICN
 Q
 ;
SRC(TIEN) ; Search through all records
 ;  For each entry TIEN
 S IEN=""
 F  S IEN=$O(^AUPNVPOV("B",TIEN,IEN),-1) Q:IEN=""  D
 . ;  if a bad record (no zero node), quit
 . I $G(^AUPNVPOV(IEN,0))="" Q
 . ;  get patient record
 . S DFN=$P(^AUPNVPOV(IEN,0),U,2) Q:DFN=""
 . S VISIT=$P(^AUPNVPOV(IEN,0),U,3) I VISIT="" Q
 . I $G(^AUPNVSIT(VISIT,0))="" Q
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . S VSDTM=$P(^AUPNVSIT(VISIT,0),U,1)\1 I VSDTM=0 Q
 . S ENDT=DT,STDT=$$DATE^BQIUL1(TMFRAME)
 . I $G(TMFRAME)'="",VSDTM'>STDT Q
 . ;I $G(TMFRAME)'="",VSDTM<STDT Q
 . ; Check for primary clinic
 . S PCL=$P(^AUPNVSIT(VISIT,0),U,8) I PCL="" Q
 . I '$D(@PREF@(PCL)) Q
 . ;
 . I $G(BQIROU)="" Q
 . I BQIROU["D10" S BQIROU=$E(BQIROU,1,$L(BQIROU)-1)
 . I $T(@("ACTUPAP^"_BQIROU))="" Q
 . S EXEC="S OK=$$ACTUPAP^"_BQIROU_"("_DFN_","_STDT_","_ENDT_","""")"
 . X EXEC I 'OK Q
 . S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 . I COMM="" S COMM="Not identified"
 . S @DATA@(COMM,ALRT,DFN,VSDTM,TIEN)=VISIT_U_IEN
 Q
