BQICALRN ;GDIT/HS/ALA-Expanded Community Alerts ; 13 Oct 2011  3:42 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;
FND ;EP - Find alerts
 ; Get the lab taxonomies for Community Alerts
 NEW LIST,LNC,TAX,TREF,TX,IEN
 D CA^BQITAXCK
 D EN^BQITAXCK(.LIST)
 I $G(X)="^" Q
 ;
 NEW DIR,ARRAY
 S ARRAY(1)="**Warning**  Missing entries in lab taxonomies could result in non-identified"
 S ARRAY(2)="             information."
 S ARRAY(3)=" "
 S ARRAY(4)="             Please quit and update lab taxonomies via Taxonomy Maintenance"
 S ARRAY(5)="             before completing the export."
 S ARRAY(6)="  "
 D EN^DDIOL(.ARRAY)
 S DIR(0)="E" D ^DIR
 I X="^"!($G(DTOUT)'="") Q
 NEW DA,DIK,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;
 ; Find clinics for primary care
 NEW TREF,TAX,PREF,TMFRAME,STDT,ENDT,ALRT,BGDA,BGI,BGPC,BGPCI,A,DATA
 NEW ATIEN,CM,TY,PT,DTE,DXN,DXCC,CIEN,DIEN,RIEN,XIEN,E,EXEC,G,IEN,CCT
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
 NEW TDATA
 S TDATA=$NA(^TMP("BQIALRTTMP",UID))
 S DATA=$NA(^TMP("BQIALERT",UID))
 K @TDATA,@DATA
 K ^XTMP("BQICAVAL")
 ;
 NEW DA,IENS,BQIH,BQI,TX,QFL,REP,TME,HAS
 S BQIH=$$SPM^BQIGPUTL(),BQIN=0
 F  S BQIN=$O(^BQI(90508,BQIH,15,BQIN)) Q:'BQIN  D
 . NEW DA,IENS
 . S DA(1)=BQIH,DA=BQIN,IENS=$$IENS^DILF(.DA)
 . S TMFRAME="T-"_$$GET1^DIQ(90508,"1,",.24,"E")
 . S TY=$$GET1^DIQ(90508.015,IENS,.01,"E")
 . S ENDT=DT,STDT=$$DATE^BQIUL1(TMFRAME)
 . S TYP(TY)=ENDT_U_STDT
 S TY=""
 F  S TY=$O(TYP(TY)) Q:TY=""  D
 . S BGDT=$P(TYP(TY),U,2)-.0001,ENDT=$P(TYP(TY),U,1),STDT=$P(TYP(TY),U,2)
 . F  S BGDT=$O(^AUPNVSIT("B",BGDT)) Q:BGDT=""!(BGDT\1>ENDT)  D  S CCT=$G(CCT)+1 W:CCT#100=0 "."
 .. S VISIT=""
 .. F  S VISIT=$O(^AUPNVSIT("B",BGDT,VISIT)) Q:VISIT=""  D
 ... I $P(^AUPNVSIT(VISIT,0),U,11)=1 Q
 ... ; Check for primary clinic
 ... S VCLIN=$P(^AUPNVSIT(VISIT,0),U,8)
 ... I VCLIN'="",'$D(@PREF@(VCLIN)) Q
 ... S VCAT=$P(^AUPNVSIT(VISIT,0),U,7)  I "AH"']VCAT Q
 ... S DFN=$P(^AUPNVSIT(VISIT,0),U,5) I DFN="" Q
 ... S EXEC="S OK=$$ACTUPAP^"_BQIROU_"("_DFN_","_STDT_","_ENDT_","""")"
 ... X EXEC I 'OK Q
 ... S VDATE=$P($G(^AUPNVSIT(VISIT,0)),U,1)\1 I VDATE=0 Q
 ... S @TDATA@("PT",DFN,VISIT)=VDATE
 ;
 ; For each community alert, set up temporary
 S PT=""
 F  S PT=$O(@TDATA@("PT",PT)) Q:PT=""  D  S CCT=$G(CCT)+1 W:CCT#100=0 "."
 . S ALRT=0
 . F  S ALRT=$O(^BQI(90507.8,ALRT)) Q:'ALRT  D
 .. S TY=$P($G(^BQI(90507.8,ALRT,2)),U,1)
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
 D EN^BQICAVAL
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
 .. S ^XTMP("BQICAVAL",DFN,ALRT,"DX",VSDTM,IEN)=TIEN_U_"9000010.07"
 Q
