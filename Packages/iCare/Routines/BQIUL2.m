BQIUL2 ;PRXM/HC/ALA-Miscellaneous BQI utilities ; 01 Nov 2007  2:20 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
STC(FIL,FLD,VAL) ; EP - Find a value for a set of codes code
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Code Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",2) I VAL=$P(VEVL,":",1) S VEQFL=1
 ;
 Q VALUE
 ;
STCC(FIL,FLD,VAL) ; EP - Find a value for a set of codes code
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Code Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . I VAL=$P(VEVL,":",1) S VALUE=$P(VEVL,":",2),VEQFL=1 Q
 . I VAL=$P(VEVL,":",2) S VALUE=$P(VEVL,":",1),VEQFL=1
 ;
 Q VALUE
 ;
PTR(FIL,FLD,VVAL,VPEC) ;EP - Find alternate value for a pointer
 ;
 ;  Input Parameters
 ;    FIL = FileMan File #
 ;    FLD = FileMan Field #
 ;    VAL = Data Value
 ;    VPEC = Field from pointed to file, defaults to .01 if not defined
 ;
 NEW ARR1,VEDATA,VFILN,VEHDTA,VVALUE,VEPAR,ARR,PEC
 I $G(VPEC)="" S VPEC=.01
 ;
 I $G(VVAL)="" Q ""
 ;  Get the Pointer Global Reference
 D FIELD^DID(FIL,FLD,"","POINTER","VEPAR")
 S VEDATA=$G(VEPAR("POINTER")),VEHDTA="^"_VEDATA_"0)"
 S VFILN=$P($G(@VEHDTA),U,2),VFILN=$$UP^XLFSTR(VFILN)
 S VFILN=$$STRIP^XLFSTR(VFILN,"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 K VEPAR
 ;
 D FIELD^DID(VFILN,VPEC,"N","GLOBAL SUBSCRIPT LOCATION","ARR")
 S ARR1=ARR("GLOBAL SUBSCRIPT LOCATION")
 ;
 I VVAL'="" S VEHDTA="^"_VEDATA_VVAL_","_$P(ARR1,";",1)_")"
 ;
 S PEC=$P(ARR1,";",2)
 I VVAL'="" S VVALUE=$P($G(@VEHDTA),U,PEC)
 Q VVALUE
 ;
PRIMVPRV(PXUTVST) ; EP - Returns the primary provider if there is one
 ; for the passed visit otherwise returns 0.
 N PXCATEMP
 S PXCATEMP=$$PRIMSEC(PXUTVST,"^AUPNVPRV",0,4)
 Q $S(PXCATEMP>0:$P(^AUPNVPRV(PXCATEMP,0),"^"),1:0)
 ;
PRIMVPOV(PXUTVST) ; EP - Returns the primary diagnosis if there is one
 ; for the passed visit otherwise returns 0.
 N PXCATEMP
 S PXCATEMP=$$PRIMSEC(PXUTVST,"^AUPNVPOV",0,12)
 Q $S(PXCATEMP>0:$P(^AUPNVPOV(PXCATEMP,0),"^"),1:0)
 ;
PRIMSEC(PXUTVST,PXUTAUPN,PXUTNODE,PXUPIECE) ; EP - Returns ien of the primary one
 ; if there is one for the passed visit otherwise returns 0.
 ; Parameters:
 ;   PXUTVST   Pointer to the visit
 ;   PXUTAUPN  V-File global e.g. "^AUPNVPRV"
 ;   PXUTNODE  The node that the Primary/Secondary field is on
 ;   PXUPIECE  The piece of the Primary/Secondary field
 ;
 N PXUTPRIM
 S PXUTPRIM=0
 F  S PXUTPRIM=$O(@(PXUTAUPN_"(""AD"",PXUTVST,PXUTPRIM)")) Q:PXUTPRIM'>0  I "P"=$P(@(PXUTAUPN_"(PXUTPRIM,PXUTNODE)"),"^",PXUPIECE) Q
 Q +PXUTPRIM
 ;
SCD(STRNG,VAL) ;EP - find a description for a code
 NEW VEQFL,I,VEVL,VALUE
 S VEQFL=0
 F I=1:1 S VEVL=$P(STRNG,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",2) I $P(VEVL,":",1)=VAL S VEQFL=1
 ;
 Q VALUE
 ;
MCD(DFN) ;EP - Medicaid Number
 NEW IEN,RESULT,MCDN,MN,STATE
 S IEN="",RESULT=""
 F  S IEN=$O(^AUPNMCD("B",DFN,IEN)) Q:IEN=""  D
 . S MCDN=$$GET1^DIQ(9000004,IEN_",",.03,"E")
 . S STATE=$$GET1^DIQ(9000004,IEN_",",.04,"I")
 . S MN=0
 . F  S MN=$O(^AUPNMCD(IEN,11,MN)) Q:'MN  D
 .. NEW DA,IENS,EFF,EXP
 .. S DA(1)=IEN,DA=MN,IENS=$$IENS^DILF(.DA)
 .. S EFF=$$GET1^DIQ(9000004.11,IENS,.01,"I")
 .. S EXP=$$GET1^DIQ(9000004.11,IENS,.02,"I")
 .. I '$$ISACTIVE^BQIPTINS(EFF,EXP) Q
 .. S RESULT=MCDN_" ("_$$PTR^BQIUL2(9000004,.04,STATE,1)_")"
 Q RESULT
 ;
NSC(DFN,TMFRAME,TYP) ;EP - Number of no shows and patient cancels
 NEW BDT,NSC,PCC,STAT
 I $G(TMFRAME)="" S BDT=$E(DT,1,3)_"0101"
 I $G(TMFRAME)'="" S BDT=$$DATE^BQIUL1(TMFRAME)
 S NSC=0,PCC=0
 F  S BDT=$O(^DPT(DFN,"S",BDT)) Q:BDT=""  D
 . S STAT=$P(^DPT(DFN,"S",BDT,0),"^",2)
 . S NCDT=$P(^DPT(DFN,"S",BDT,0),"^",14) I NCDT="" Q
 . I (NCDT\1)>DT Q
 . S:STAT="N" NSC=NSC+1 S:STAT="PC" PCC=PCC+1
 Q $S(TYP="NS":NSC,TYP="PC":PCC,1:(NSC+PCC))
 ;
OTRIB(DFN) ;EP - List of other tribes
 NEW BQTRIB,OTHER,TN,OTRIB
 S OTHER=""
 S TN=0
 F  S TN=$O(^AUPNPAT(DFN,43,"B",TN)) Q:TN=""  D
 . S BQTRIB=$P($G(^AUPNPAT(DFN,11)),U,8)
 . I BQTRIB'="",BQTRIB=TN Q
 . S OTRIB=$P($G(^AUTTTRI(TN,0)),U,1) I OTRIB="" Q
 . S OTHER=OTHER_OTRIB_$C(10)_$C(13)
 S OTHER=$$TKO^BQIUL1(OTHER,$C(10)_$C(13))
 Q OTHER
 ;
LAVD(DFN) ;EP -- Get patient's last AMBULATORY visit
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW VIEN,LVISIT,QFL,LVSDT
 S VIEN="",LVISIT="",QFL=0,LVSDT=""
 S LVSDT=$O(^AUPNVSIT("AA",DFN,LVSDT)) I LVSDT="" Q LVISIT
 S LVSDT=""
 F  S LVSDT=$O(^AUPNVSIT("AA",DFN,LVSDT)) Q:LVSDT=""  D  Q:QFL
 . F  S VIEN=$O(^AUPNVSIT("AA",DFN,LVSDT,VIEN)) Q:VIEN=""  D  Q:QFL
 .. I $$GET1^DIQ(9000010,VIEN,.11,"I")=1 Q
 .. I $G(^AUPNVSIT(VIEN,0))="" Q
 .. I $P(^AUPNVSIT(VIEN,0),U,7)'="A" Q
 .. I $P(^AUPNVSIT(VIEN,0),U,9)=1 Q
 .. ; Check for Primary Care clinic
 .. S CLN=$P(^AUPNVSIT(VIEN,0),U,8)
 .. I CLN'="" D  Q:QFL
 ... I $P($G(^DIC(40.7,CLN,9999999)),"^",2)'=1 S QFL=1
 .. S LVISIT=VIEN,QFL=1
 Q LVISIT
 ;
LAVDT(DFN) ;EP -- Get patient's last AMBULATORY visit date/time
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW VIEN
 S VIEN=$$LAVD(.DFN)
 I VIEN="" Q ""
 Q $$FMTE^BQIUL1($$GET1^DIQ(9000010,VIEN_",",.01,"I")\1)
 ;
LAVC(DFN) ;EP -- Get patient's last AMBULATORY visit clinic
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,CST
 S VIEN=$$LAVD(.DFN)
 I VIEN="" Q ""
 S CST=$$GET1^DIQ(9000010,VIEN_",",.08,"I")
 I CST="" Q ""
 Q $$GET1^DIQ(9000010,VIEN_",",.08,"E")_" "_$$GET1^DIQ(40.7,CST_",",1,"E")
 ;
LALC(DFN) ;EP -- Get patient's last AMBULATORY visit location
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,CST
 S VIEN=$$LAVD(.DFN)
 I VIEN="" Q ""
 S CST=$$GET1^DIQ(9000010,VIEN_",",.06,"E")
 I CST="" Q "UNKNOWN"
 Q CST
 ;
LAVP(DFN) ;EP -- Get patient's last AMBULATORY visit primary provider
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,PRV
 S VIEN=$$LAVD(.DFN)
 I VIEN="" Q ""
 S PRV=$$PRIMVPRV^PXUTL1(VIEN)
 I PRV=0 Q ""
 Q $$GET1^DIQ(200,PRV_",",.01,"E")
 ;
LAVDN(DFN) ;EP -- Get patient's last AMBULATORY visit POV narratives
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,TEXT,IEN,POVN
 S VIEN=$$LAVD(.DFN),TEXT="",IEN=""
 I VIEN="" Q ""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S POVN=$$GET1^DIQ(9000010.07,IEN_",",".019","E")
 . I $L(TEXT)+$L(POVN)>250 Q
 . S TEXT=TEXT_POVN_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,$C(13)_$C(10))
 ;
LAVPN(DFN) ;EP -- Get patient's last AMBULATORY visit provider narratives
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,TEXT,IEN,PRVN
 S VIEN=$$LAVD(.DFN),TEXT="",IEN=""
 I VIEN="" Q ""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S PRVN=$$GET1^DIQ(9000010.07,IEN_",",".04","E")
 . I $L(TEXT)+$L(PRVN)>250 Q
 . S TEXT=TEXT_PRVN_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,$C(13)_$C(10))
