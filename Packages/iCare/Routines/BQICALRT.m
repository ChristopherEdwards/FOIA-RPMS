BQICALRT ;GDIT/HS/ALA-Expanded Community Alerts ; 13 Oct 2011  3:42 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1,2**;Apr 18, 2012;Build 14
 ;
FND ;EP - Find alerts
 NEW DA,DIK,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 ; Clear out existing Community Alerts before recalculating them
 S DA=0,DIK="^BQI(90507.6,"
 F  S DA=$O(^BQI(90507.6,DA)) Q:'DA  D ^DIK
 I $D(^BQI(90507.6,-1)) K ^BQI(90507.6,-1)
 ;
 ; Find clinics for primary care
 NEW TREF,TAX,PREF,TMFRAME,STDT,ENDT,ALRT,BGDA,BGI,BGPC,BGPCI,A,DATA
 NEW ATIEN,CM,TY,PT,DTE,DXN,DXCC,CIEN,DIEN,RIEN,XIEN,E,EXEC,G,IEN
 NEW OK,PCL,SIEN,V,VISIT,VSDTM,X,Y,COMM,DFN,DOD,DTY,ATY,SDATA,AIEN
 NEW LBT,VCLIN,BDT,BDXX,BGDT,BQIN,BSXX,CT,DEXEC,EDT,EXP,FILE,FLAG,I
 NEW N,OPER,OPER2,OVALUE,RES,RES2,RN,TIEN,TYP,VCAT,VDATE,VFL,X,Y,ZZ
 ; Need to get the program for the GPRA year to check active population
 NEW BGPHOME,BQIH,BQIINDF,BQIINDG,BQIMEASF,BQIMEASG,BQIY,BQIYR,BQIROU
 D INP^BQINIGHT
 I $G(BQIROU)="" Q
 I BQIROU["D10" S BQIROU=$E(BQIROU,1,$L(BQIROU)-1)
 I $T(@("ACTUPAP^"_BQIROU))="" Q
 ;
 I $G(DT)="" D DT^DICRW
 ; Get primary clinic list
 ;S PREF=$NA(^TMP("BQIPRCR",UID))
 ;K @PREF
 ;S BGDA=$O(^BGPCTRL("B",BQIYR,"")) I BGDA="" Q
 ;S BGI=0
 ;F  S BGI=$O(^BGPCTRL(BGDA,12,BGI)) Q:'BGI  D
 ;. S BGPC=$P(^BGPCTRL(BGDA,12,BGI,0),U,1)
 ;. S BGPCI=$O(^DIC(40.7,"C",BGPC,"")) I BGPCI="" Q
 ;. S @PREF@(BGPCI)=BGPC
 ; Add Emergency and Urgent Care to clinic list
 ;S BGPCI=$O(^DIC(40.7,"C",30,"")) I BGPCI'="" S @PREF@(BGPCI)=30
 ;S BGPCI=$O(^DIC(40.7,"C",80,"")) I BGPCI'="" S @PREF@(BGPCI)=80
 ;
 ; Set the alert temporary global
 NEW TDATA
 S TDATA=$NA(^TMP("BQIALRTTMP",UID)),DATA=$NA(^TMP("BQIALERT",UID))
 K @TDATA,@DATA
 ;
 NEW DA,IENS,BQIH,BQI,TX,QFL,REP,TME,HAS
 S BQIH=$$SPM^BQIGPUTL(),BQIN=0
 F  S BQIN=$O(^BQI(90508,BQIH,15,BQIN)) Q:'BQIN  D
 . NEW DA,IENS
 . S DA(1)=BQIH,DA=BQIN,IENS=$$IENS^DILF(.DA)
 . S TMFRAME="T-"_$$GET1^DIQ(90508.015,IENS,.03,"E")
 . S TY=$$GET1^DIQ(90508.015,IENS,.01,"E")
 . S ENDT=DT,STDT=$$DATE^BQIUL1(TMFRAME)
 . S TYP(TY)=ENDT_U_STDT
 S TY=""
 F  S TY=$O(TYP(TY)) Q:TY=""  D
 . S BGDT=$P(TYP(TY),U,2)-.0001,ENDT=$P(TYP(TY),U,1),STDT=$P(TYP(TY),U,2)
 . F  S BGDT=$O(^AUPNVSIT("B",BGDT)) Q:BGDT=""!(BGDT\1>ENDT)  D
 .. S VISIT=""
 .. F  S VISIT=$O(^AUPNVSIT("B",BGDT,VISIT)) Q:VISIT=""  D
 ... I $P(^AUPNVSIT(VISIT,0),U,11)=1 Q
 ... ; Check for primary clinic
 ... ;S VCLIN=$P(^AUPNVSIT(VISIT,0),U,8)
 ... ;I VCLIN'="",'$D(@PREF@(VCLIN)) Q
 ... S VCAT=$P(^AUPNVSIT(VISIT,0),U,7)
 ... I VCAT'="A",VCAT'="C",VCAT'="H",VCAT'="T" Q
 ... S DFN=$P(^AUPNVSIT(VISIT,0),U,5) I DFN="" Q
 ... ;S EXEC="S OK=$$ACTUPAP^"_BQIROU_"("_DFN_","_STDT_","_ENDT_","""")"
 ... ;X EXEC I 'OK Q
 ... S VDATE=$P($G(^AUPNVSIT(VISIT,0)),U,1)\1 I VDATE=0 Q
 ... S @TDATA@("PT",DFN,VISIT)=VDATE
 ;
 ; For each community alert, set up temporary to check for duplicates
 S PT=""
 F  S PT=$O(@TDATA@("PT",PT)) Q:PT=""  D
 . S COMM=$$GET1^DIQ(9000001,PT_",",1117,"I")
 . I COMM="" S COMM="Not identified"
 . S ALRT=0
 . F  S ALRT=$O(^BQI(90507.8,ALRT)) Q:'ALRT  D
 .. S TY=$P($G(^BQI(90507.8,ALRT,2)),U,1)
 .. S DEXEC=$G(^BQI(90507.8,ALRT,31))
 .. I DEXEC'="" D
 ... X DEXEC
 .. S EXP=+$P($G(^BQI(90507.8,ALRT,2)),U,6) I EXP S EXEC=$G(^BQI(90507.8,ALRT,30))
 .. I EXP D
 ... X EXEC
 ... I $G(RES(1))=0 Q
 ... S DTY=$P(^BQI(90507.8,ALRT,0),U,1),ATY=$P($G(^BQI(90507.8,ALRT,2)),U,1)
 ... S N=0 F  S N=$O(RES(N)) Q:N=""  D
 .... S SDATA=RES(N)
 .... S VISIT=$P(SDATA,U,4),VSDTM=$P(SDATA,U,2),IEN=$P(SDATA,U,5),FILE=$P(SDATA,U,7),TIEN=$P(SDATA,U,6)
 .... S ZZ=$S(FILE=9000010.01:"MS",FILE=9000010.12:"SK",1:"LB")
 .... S @DATA@(COMM,ALRT,PT,ZZ,VSDTM,TIEN)=VISIT_U_IEN_U_FILE
 .. I $G(DEXEC)'="" Q
 .. ; Check for taxonomies
 .. S TX=0,QFL=0 K TAX
 .. F  S TX=$O(^BQI(90507.8,ALRT,11,TX)) Q:'TX  D
 ... S TAX=$P(^BQI(90507.8,ALRT,11,TX,0),U,1)
 ... S TREF=$NA(^TMP("BQITAX",UID))
 ... K @TREF
 ... D BLD^BQITUTL(TAX,TREF)
 ... I '$D(@TREF) Q
 ... S ATIEN=0,QFL=1
 ... F  S ATIEN=$O(@TREF@(ATIEN)) Q:ATIEN=""  D SRN(ATIEN,PT)
 .. Q:QFL
 .. ; Check for ICD codes
 .. S ATIEN=""
 .. F  S ATIEN=$O(^BQI(90507.8,ALRT,10,"B",ATIEN)) Q:ATIEN=""  D
 ... D SRN(ATIEN,PT)
 ;
 ; Check for duplicates
 NEW LDTE
 S (CM,TY,PT)=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . F  S TY=$O(@DATA@(CM,TY)) Q:TY=""  D
 .. F  S PT=$O(@DATA@(CM,TY,PT)) Q:PT=""  D
 ... S DTE=$O(@DATA@(CM,TY,PT,"DX",""),-1) Q:DTE=""
 ... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ... F  S DTE=$O(@DATA@(CM,TY,PT,"DX",DTE),-1) Q:DTE=""  D
 .... ; Only one alert type per patient per 30 day period should be included
 .... I DTE>LDTE K @DATA@(CM,TY,PT,"DX",DTE) Q
 .... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ... S DTE=$O(@DATA@(CM,TY,PT,"LB",""),-1) Q:DTE=""
 ... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ... F  S DTE=$O(@DATA@(CM,TY,PT,"LB",DTE),-1) Q:DTE=""  D
 .... I DTE>LDTE K @DATA@(CM,TY,PT,"LB",DTE) Q
 .... S LDTE=$$FMADD^XLFDT(DTE,-30)
 ;
 S CM=""
 F  S CM=$O(@DATA@(CM)) Q:CM=""  D
 . S TY=""
 . F  S TY=$O(@DATA@(CM,TY)) Q:TY=""  D
 .. S DTY=$P(^BQI(90507.8,TY,0),U,1),ATY=$P($G(^BQI(90507.8,TY,2)),U,1)
 .. S REP=$P($G(^BQI(90507.8,TY,2)),U,5)
 .. ;
 .. S TME=$S(REP=1:"T-61",REP=2:"T-183",REP=3:"T-365",1:"")
 .. K TAX
 .. S TX=0,QFL=0
 .. F  S TX=$O(^BQI(90507.8,TY,11,TX)) Q:'TX  D
 ... S TAX=$P(^BQI(90507.8,TY,11,TX,0),U,1)
 .. S PT=""
 .. F  S PT=$O(@DATA@(CM,TY,PT)) Q:PT=""  D
 ... I $G(TAX)'="" S HAS=$$TAX^BQICAUTL(TME,TAX,2,PT,9000010.07,1,0)
 ... I $G(TAX)="" D
 .... S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 .... S N=0
 .... F  S N=$O(^BQI(90507.8,TY,10,N)) Q:'N  D
 ..... S IEN=$P(^BQI(90507.8,TY,10,N,0),U,1),COD=$P(^(0),U,2),@TREF@(IEN)=COD
 .... S HAS=$$TAX^BQICAUTL(TME,"",2,PT,9000010.07,0,0,.TREF)
 ... S DTE=""
 ... F  S DTE=$O(@DATA@(CM,TY,PT,"DX",DTE)) Q:DTE=""  D
 .... S DXN=""
 .... F  S DXN=$O(@DATA@(CM,TY,PT,"DX",DTE,DXN)) Q:DXN=""  D
 ..... I $T(ICDDX^ICDCODE)'="" S DXCC=$$ICD9^BQIUL3(DXN,DTE\1,2) ; Code set versioning
 ..... I $T(ICDDX^ICDCODE)="" S DXCC=$$GET1^DIQ(80,DXN_",",.01,"E")
 ..... I DXCC="" Q
 ..... S VISIT=$P(@DATA@(CM,TY,PT,"DX",DTE,DXN),U,1)
 ..... I $P(HAS,U,1)=1 Q
 ..... D NFILE(CM,DTY,DXCC,DTE,VISIT,PT,ATY,@DATA@(CM,TY,PT,"DX",DTE,DXN))
 ... S DTE=""
 ... F  S DTE=$O(@DATA@(CM,TY,PT,"LB",DTE)) Q:DTE=""  D
 .... S LBT=""
 .... F  S LBT=$O(@DATA@(CM,TY,PT,"LB",DTE,LBT)) Q:LBT=""  D
 ..... S VISIT=$P(@DATA@(CM,TY,PT,"LB",DTE,LBT),U,1)
 ..... D NLAB(CM,DTY,VISIT,PT,ATY,LBT,@DATA@(CM,TY,PT,"LB",DTE,LBT))
 ;
 K @DATA,@TDATA
 Q
 ;
NFILE(COMM,DCAT,DXC,DATE,VISIT,PT,ATYP,SDATA) ;
 ; Input
 ;   COMM  - Community
 ;   DCAT  - Diagnosis Category
 ;   DXC   - Diagnosis Code
 ;   DATE  - Event Date
 ;   PT    - DFN
 ;   ATYP  - Passed Alert Type
 ;   SDATA - Data
 ;
 NEW DIC,DA,D,NFLG
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
 . ;S X(1)=DXC,X(2)=DATE,X(3)=VISIT,D="D"
 . D IX^DIC
 S (RIEN,DA)=+Y,NFLG=+$P(Y,U,3)
 ;S $P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,RIEN,0),U,4)=PT
 ;S $P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,RIEN,0),U,5)=9000010
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.6111,IENS,.02)=DTE
 S BQIUPD(90507.6111,IENS,.03)=$P(SDATA,U,2)
 S BQIUPD(90507.6111,IENS,.04)=PT
 S BQIUPD(90507.6111,IENS,.05)=$P(SDATA,U,3)
 S BQIUPD(90507.6111,IENS,.06)=VISIT
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 NEW DIK
 S DIK=DIC,DIK(1)=.04
 D ENALL^DIK
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
 . S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 . I COMM="" S COMM="Not identified"
 . S @DATA@(COMM,ALRT,DFN,"DX",VSDTM,TIEN)=VISIT_U_IEN_U_"9000010"
 Q
 ;
SUP ; File Supporting Data
 K X,DA
 S X=$S($P(SDATA,U,7)=9000010.01:"Measurement",1:"Lab")
 S DA(4)=CIEN,DA(3)=AIEN,DA(2)=DIEN,DA(1)=RIEN,DIC(0)="LN"
 S DIC="^BQI(90507.6,"_DA(4)_",1,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",1,"
 I $G(^BQI(90507.6,DA(4),1,DA(3),1,DA(2),1,DA(1),1,0))="" S ^BQI(90507.6,DA(4),1,DA(3),1,DA(2),1,DA(1),1,0)="^90507.61111^^"
 D FILE^DICN
 S (SIEN,DA)=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.61111,IENS,.04)=$P(SDATA,U,7)
 S BQIUPD(90507.61111,IENS,.02)=$P(SDATA,U,2)
 S BQIUPD(90507.61111,IENS,.03)=$P(SDATA,U,5)
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
NLAB(COMM,DCAT,VISIT,PT,ATYP,LIEN,SDATA) ;
 ; Input
 ;   COMM  - Community
 ;   DCAT  - Diagnosis Category
 ;   VISIT - Visit IEN
 ;   PT    - DFN
 ;   ATYP  - Passed Alert Type
 ;   LIEN  - Lab Test IEN
 ;   SDATA - Information
 ;
 NEW DIC,DA,D,NFLG
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
 ;  Set the Lab
 S DA(3)=CIEN,DA(2)=AIEN,DA(1)=DIEN,X=LIEN,DIC(0)="LMN"
 S DIC="^BQI(90507.6,"_DA(3)_",1,"_DA(2)_",1,"_DA(1)_",2,"
 I $G(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),2,0))="" S ^BQI(90507.6,DA(3),1,DA(2),1,DA(1),2,0)="^90507.6112^^"
 D FILE^DICN
 S DA=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.6112,IENS,.02)=DTE
 S BQIUPD(90507.6112,IENS,.03)=$P(SDATA,U,2)
 S BQIUPD(90507.6112,IENS,.04)=PT
 S BQIUPD(90507.6112,IENS,.05)=$P(SDATA,U,3)
 S BQIUPD(90507.6112,IENS,.06)=VISIT
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
SRN(TIEN,DFN) ; Search through all records
 S VISIT=""
 F  S VISIT=$O(@TDATA@("PT",DFN,VISIT)) Q:VISIT=""  D
 . ;  For each entry TIEN
 . S IEN="",VSDTM=@TDATA@("PT",DFN,VISIT)
 . F  S IEN=$O(^AUPNVPOV("AD",VISIT,IEN),-1) Q:IEN=""  D
 .. ;  if a bad record (no zero node), quit
 .. I $G(^AUPNVPOV(IEN,0))="" Q
 .. I $P(^AUPNVPOV(IEN,0),U,1)'=TIEN Q
 .. S @DATA@(COMM,ALRT,DFN,"DX",VSDTM,TIEN)=VISIT_U_IEN_U_"9000010.07"
 Q
