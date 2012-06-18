BQIDCAH2 ;VNGT/HS/ALA-Ad Hoc Search continued ; 03 Apr 2009  3:56 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;**1**;Jul 28, 2011;Build 25
 ;
PROV(FGLOB,TGLOB,PROV) ;EP - Provider search
 I $G(TGLOB)="" Q
 I $G(PROV)="" Q
 ;
 NEW DFN,IEN,RIEN,VIS
 S IEN=0
 ;
 I $G(FGLOB)'="",$G(FROM)'="" D  Q
 . S DFN=""
 . F  S DFN=$O(@FGLOB@(DFN)) Q:DFN=""  D
 .. I '$D(@VODATA@(DFN,"PRV",PROV)) K @FGLOB@(DFN) Q
 .. ; Check for NUMVIS
 .. I $G(NUMVIS)'="" D  Q
 ... I @(@VODATA@(DFN,"PRV",PROV)_NUMVIS) S @TGLOB@(DFN)="" Q
 ... Q
 .. I $D(MPARMS("NUMVIS")) D  Q
 ... S VCRIT1=$O(MPARMS("NUMVIS","")),VCRIT2=$O(MPARMS("NUMVIS",VCRIT1))
 ... ; If criteria includes a "not" it is inclusive and both must be true
 ... I $E(VCRIT1)="'",@(@VODATA@(DFN,"PRV",PROV)_VCRIT1),@(@VODATA@(DFN,"PRV",PROV)_VCRIT2) S @TGLOB@(DFN)="" Q
 ... ; If criteria does not includes a "not" it is exclusive and one must be true
 ... I $E(VCRIT1)'="'",@(@VODATA@(DFN,"PRV",PROV)_VCRIT1_"!("_(@VODATA@(DFN,"PRV",PROV)_VCRIT2)_")") S @TGLOB@(DFN)="" Q
 ... Q
 .. S @TGLOB@(DFN)=""
 . K @FGLOB
 ;
 I $G(FGLOB)'="" D
 . S RIEN=""
 . F  S RIEN=$O(^AUPNVPRV("B",PROV,RIEN)) Q:'RIEN  D
 .. S DFN=$$GET1^DIQ(9000010.06,RIEN_",",.02,"I") I DFN="" Q
 .. I '$D(@FGLOB@(DFN)) Q
 .. S @TGLOB@(DFN)=""
 ;
 I $G(FGLOB)="" D
 . S RIEN=""
 . F  S RIEN=$O(^AUPNVPRV("B",PROV,RIEN)) Q:'RIEN  D
 .. S DFN=$$GET1^DIQ(9000010.06,RIEN_",",.02,"I") I DFN="" Q
 .. S @TGLOB@(DFN)=""
 Q
 ;
PRVS(TGLOB,PROV,FROM,THRU) ;EP
 ; this cross-reference does not really exist yet, it is a test to determine
 ; a more efficient cross-reference
 S FDT=FROM
 F  S FDT=$O(^AUPNVPRV("AF",PROV,FDT)) Q:FDT=""!(FDT\1>THRU)  D
 . S DFN=""
 . F  S DFN=$O(^AUPNVPRV("AF",PROV,FDT,DFN)) Q:DFN=""  S @TGLOB@(DFN)=""
 ;
 Q
 ;
ALGY(FGLOB,TGLOB,BEN,MPARMS) ;EP - Allergy search
 NEW ALGPT
 I $G(TGLOB)="" Q
 I $G(ALLERGY)]"" D ALGY1
 I $D(MPARMS("ALLERGY")) D
 . I ALLOP="!" D  Q
 .. S ALLERGY="" F  S ALLERGY=$O(MPARMS("ALLERGY",ALLERGY)) Q:ALLERGY=""  D ALGY1
 . I ALLOP="&" D
 .. S ALLERGY="",CT=0
 .. F  S ALLERGY=$O(MPARMS("ALLERGY",ALLERGY)) Q:ALLERGY=""  S CT=CT+1
 .. F  S ALLERGY=$O(MPARMS("ALLERGY",ALLERGY)) Q:ALLERGY=""  D ALGY1
 .. S AIEN=""
 .. F  S AIEN=$O(ALGPT(AIEN)) Q:AIEN=""   I ALLOP="&",ALGPT(AIEN)=CT S @TGLOB@(AIEN)=""
 K ALGPT
 Q
 ;
ALGY1 ;EP
 NEW IEN,ALGTX,AN,DFN
 I $G(FGLOB)'="" D  Q
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:'IEN  D
 .. S AN=""
 .. F  S AN=$O(^GMR(120.8,"B",IEN,AN)) Q:AN=""  D
 ... I $$GET1^DIQ(120.8,AN_",",22,"I")=1 Q
 ... S ALGTX=$$GET1^DIQ(120.8,AN_",",.02,"E")
 ... I $E(ALGTX,$L(ALGTX),$L(ALGTX))=" " S ALGTX=$$STRIP^BQIUL1(ALGTX," ")
 ... I ALGTX=ALLERGY D
 .... I ALLOP="!" S @TGLOB@(IEN)="" Q
 .... S ALGPT(IEN)=$G(ALGPT(IEN))+1
 .. I ALLOP="&",ALGPT(IEN)'=CT K ALGPT(IEN)
 ;
 I $L(ALLERGY)'>30 D
 . NEW ALGTX,TXT
 . S IEN=""
 . F  S IEN=$O(^GMR(120.8,"C",ALLERGY,IEN)) Q:IEN=""  D ALCK
 . S ALGTX=$O(^GMR(120.8,"C",ALLERGY)),TXT=ALLERGY_" "
 . I ALGTX=TXT D
 .. F  S IEN=$O(^GMR(120.8,"C",ALGTX,IEN)) Q:IEN=""  D ALCK
 ;
 I $L(ALLERGY)>30 D
 . S TALLG=ALLERGY
 . F  S TALLG=$O(^GMR(120.8,"C",TALLG)) Q:TALLG=""!($E(ALLERGY,1,30)'=$E(TALLG,1,30))  D
 .. S IEN=""
 .. F  S IEN=$O(^GMR(120.8,"C",TALLG,IEN)) Q:IEN=""  D ALCK
 Q
 ;
ALCK ;EP
 I $$GET1^DIQ(120.8,IEN_",",22,"I")=1 Q
 S DFN=$$GET1^DIQ(120.8,IEN_",",.01,"I")
 I ALLOP="!" S @TGLOB@(DFN)="" Q
 S ALGPT(DFN)=$G(ALGPT(DFN))+1
 Q
 ;
VIS(FGLOB,TGLOB,FDT,TDT,MAPARMS) ;EP - Visit search
 I $G(TGLOB)="" Q
 ;
 ;NEW DFN,IEN,RIEN,CLNFLG,PRVFLG,VCLIN,PRIEN,VPRV,OK,NOVST
 ;
 ; Clinic only data
 S VDCLIN=$NA(^TMP("BQIVISCLN",UID))
 S VNDATA=$NA(^TMP("BQINOVIS",UID))
 ; Patient only data
 S VDDATA=$NA(^TMP("BQIVISONLY",UID))
 ; Clinic and provider data
 S VDCLPR=$NA(^TMP("BQIVISCLPR",UID))
 ; Provider only data
 S VDPROV=$NA(^TMP("BQIVISPRV",UID))
 ; 'AND' data
 S VDAND=$NA(^TMP("BQIVISAND",UID))
 K @VDCLIN,@VNDATA,@VDCLPR,@VDDATA,@VDAND
 ;
 S FDT=$S(FDT'="":FDT-.001,1:FDT),TDT=$S(TDT'="":TDT,1:DT)
 F  S FDT=$O(^AUPNVSIT("B",FDT)) Q:FDT=""!(FDT\1>TDT)  D
 . S RIEN=""
 . F  S RIEN=$O(^AUPNVSIT("B",FDT,RIEN)) Q:'RIEN  D
 .. ; If the visit is deleted, quit
 .. I $$GET1^DIQ(9000010,RIEN_",",.11,"I")=1 Q
 .. S DFN=$$GET1^DIQ(9000010,RIEN_",",.05,"I") I DFN="" Q
 .. S @VDDATA@(DFN)=$G(@VDDATA@(DFN))+1
 .. S VCLIN=$$GET1^DIQ(9000010,RIEN_",",.08,"I")
 .. I VCLIN'="" D
 ... S @VDCLIN@(VCLIN,DFN)=$G(@VDCLIN@(VCLIN,DFN))+1
 ... S @VDCLIN@(VCLIN)=$G(@VDCLIN@(VCLIN))+1
 .. ;Find associated providers
 .. S PRIEN="" F  S PRIEN=$O(^AUPNVPRV("AD",RIEN,PRIEN)) Q:PRIEN=""  D
 ... S VPRV=$$GET1^DIQ(9000010.06,PRIEN_",",.01,"I") Q:VPRV=""
 ... I VCLIN'="" D
 .... S @VDCLPR@(VCLIN,VPRV,DFN)=$G(@VDCLPR@(VCLIN,VPRV,DFN))+1
 .... S @VDCLPR@(VCLIN,VPRV)=$G(@VDCLPR@(VCLIN,VPRV))+1
 ... S @VDPROV@(VPRV,DFN)=$G(@VDPROV@(VPRV,DFN))+1
 ;
 I $D(MAPARMS) D
 . S MN="",TOT=0
 . F  S MN=$O(MAPARMS(MN)) Q:MN=""  D
 .. S NUMVIS=$G(MAPARMS(MN,"NUMVIS")),CLIN=$G(MAPARMS(MN,"CLIN")),PROV=$G(MAPARMS(MN,"PROV"))
 .. D CALB(NUMVIS,CLIN,PROV,VISOP)
 ;
 I '$D(MAPARMS) D
 . S TOT=0
 . I $D(APARMS) D
 .. S NUMVIS=""
 .. F  S NUMVIS=$O(APARMS("NUMVIS",NUMVIS)) Q:NUMVIS=""  D
 ... S PROV=$G(APARMS("NUMVIS",NUMVIS,"PROV"))
 ... S CLIN=$G(APARMS("NUMVIS",NUMVIS,"CLIN"))
 ... D CALB($G(NUMVIS),$G(CLIN),$G(PROV),$G(VISOP))
 ;
 ;no visits, so if have visits, exclude
 I $D(@VNDATA) S IEN="" F  S IEN=$O(^AUPNPAT(IEN)) Q:'IEN  I '$D(@VNDATA@(IEN)),$G(^AUPNPAT(IEN,0))'="" S @TGLOB@(IEN)=""
 ;
 I VISOP="&" D
 . S IEN="" F  S IEN=$O(@VDAND@(IEN)) Q:IEN=""  I @VDAND@(IEN)'=TOT K @VDAND@(IEN)
 . S IEN="" F  S IEN=$O(@VDAND@(IEN)) Q:IEN=""  S @TGLOB@(IEN)=""
 Q
 ;
CALC(NUMVIS,CLIN,PROV) ; EP
 ; Single numvis value, not inclusive or exclusive
 I NUMVIS'["~" D
 . I $G(FGLOB)'="" D
 .. I CLIN="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  I @(@VDDATA@(IEN)_NUMVIS) S @TGLOB@(IEN)=""
 .. I CLIN="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  I @(@VDPROV@(PROV,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 ... S IEN=""
 .. I CLIN'="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  I @(@VDCLIN@(CLIN,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 .. I CLIN'="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  I @(@VDCLPR@(CLIN,PROV,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 . I $G(FGLOB)="" D
 .. I CLIN="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDDATA@(IEN)) Q:IEN=""  I @(@VDDATA@(IEN)_NUMVIS) S @TGLOB@(IEN)=""
 .. I CLIN="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDPROV@(PROV,IEN)) Q:IEN=""  I @(@VDPROV@(PROV,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 .. I CLIN'="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDCLIN@(CLIN,IEN)) Q:IEN=""  I @(@VDCLIN@(CLIN,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 .. I CLIN'="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDCLPR@(CLIN,PROV,IEN)) Q:IEN=""  I @(@VDCLPR@(CLIN,PROV,IEN)_NUMVIS) S @TGLOB@(IEN)=""
 ;
 I NUMVIS["~" D
 . S VCRIT1=$P(NUMVIS,"~",1),VCRIT2=$P(NUMVIS,"~",2)
 . I $G(FGLOB)'="" D
 .. I CLIN="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDDATA@(IEN)_VCRIT1),@(@VDDATA@(IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDDATA@(IEN)_VCRIT1_"!("_(@VDDATA@(IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDPROV@(PROV,IEN)_VCRIT1),@(@VDPROV@(PROV,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDPROV@(PROV,IEN)_VCRIT1_"!("_(@VDPROV@(PROV,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN'="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1),@(@VDCLIN@(CLIN,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1_"!("_(@VDCLIN@(CLIN,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN'="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1),@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1_"!("_(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 . ;
 . I $G(FGLOB)="" D
 .. I CLIN="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDDATA@(IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDDATA@(IEN)_VCRIT1),@(@VDDATA@(IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDDATA@(IEN)_VCRIT1_"!("_(@VDDATA@(IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDPROV@(PROV,IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDPROV@(PROV,IEN)_VCRIT1),@(@VDPROV@(PROV,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDPROV@(PROV,IEN)_VCRIT1_"!("_(@VDPROV@(PROV,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN'="",PROV="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDCLIN@(CLIN,IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1),@(@VDCLIN@(CLIN,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1_"!("_(@VDCLIN@(CLIN,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 .. I CLIN'="",PROV'="" D
 ... S IEN=""
 ... F  S IEN=$O(@VDCLPR@(CLIN,PROV,IEN)) Q:IEN=""  D
 .... ; If criteria includes a "not" it is inclusive and both must be true
 .... I $E(VCRIT1)="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1),@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2) S @TGLOB@(IEN)="" Q
 .... ; If criteria does not includes a "not" it is exclusive and one must be true
 .... I $E(VCRIT1)'="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1_"!("_(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2)_")") S @TGLOB@(IEN)="" Q
 Q
 ;
CALB(NUMVIS,CLIN,PROV,VISOP) ;EP
 S TOT=TOT+1,NOVST=0
 I NUMVIS="=0"!(NUMVIS="<0")!(NUMVIS="<1")!(NUMVIS="'>0") S NOVST=1
 I NUMVIS["~" S VCRIT1=$P(NUMVIS,"~",1),VCRIT2=$P(NUMVIS,"~",2)
 I NUMVIS'["~" S VCRIT1="",VCRIT2=""
 I $G(FGLOB)'="" D
 . S IEN=""
 . F  S IEN=$O(@FGLOB@(IEN)) Q:IEN=""  D
 .. I CLIN="",PROV="" D VDD
 .. I CLIN'="",PROV="" D VDC
 .. I CLIN="",PROV'="" D VDP
 .. I CLIN'="",PROV'="" D VDBT
 ;
 I $G(FGLOB)="" D
 . I CLIN="",PROV="" S IEN="" F  S IEN=$O(@VDDATA@(IEN)) Q:IEN=""  D VDD
 . I CLIN'="",PROV="" S IEN="" F  S IEN=$O(@VDCLIN@(CLIN,IEN)) Q:IEN=""  D VDC
 . I CLIN="",PROV'="" S IEN="" F  S IEN=$O(@VDPROV@(PROV,IEN)) Q:IEN=""  D VDP
 . I CLIN'="",PROV'="" S IEN="" F  S IEN=$O(@VDCLPR@(CLIN,PROV,IEN)) Q:IEN=""  D VDBT
 Q
 ;
VDD ; Visit Only
 I NOVST,$D(@VDDATA@(IEN)) S @VNDATA@(IEN)="" Q
 I '$D(@VDDATA@(IEN)) Q
 I VCRIT1="" D  Q
 . I @(@VDDATA@(IEN)_NUMVIS) D
 .. I VISOP="!" S @TGLOB@(IEN)="" Q
 .. I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria includes a "not" it is inclusive and both must be true
 I $E(VCRIT1)="'",@(@VDDATA@(IEN)_VCRIT1),@(@VDDATA@(IEN)_VCRIT2) D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria does not includes a "not" it is exclusive and one must be true
 I $E(VCRIT1)'="'",@(@VDDATA@(IEN)_VCRIT1_"!("_(@VDDATA@(IEN)_VCRIT2)_")") D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 Q
 ;
VDC ; Clinic Only
 I NOVST,$D(@VDCLIN@(CLIN,IEN)) S @VNDATA@(IEN)="" Q
 I '$D(@VDCLIN@(CLIN,IEN)) Q
 I VCRIT1="" D  Q
 . I @(@VDCLIN@(CLIN,IEN)_NUMVIS) D
 .. I VISOP="!" S @TGLOB@(IEN)="" Q
 .. I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria includes a "not" it is inclusive and both must be true
 I $E(VCRIT1)="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1),@(@VDCLIN@(CLIN,IEN)_VCRIT2) D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria does not includes a "not" it is exclusive and one must be true
 I $E(VCRIT1)'="'",@(@VDCLIN@(CLIN,IEN)_VCRIT1_"!("_(@VDCLIN@(CLIN,IEN)_VCRIT2)_")") D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 Q
 ;
VDP ; Provider Only
 I NOVST,$D(@VDPROV@(PROV,IEN)) S @VNDATA@(IEN)="" Q
 I '$D(@VDPROV@(PROV,IEN)) Q
 I VCRIT1="" D  Q
 . I @(@VDPROV@(PROV,IEN)_NUMVIS) D
 .. I VISOP="!" S @TGLOB@(IEN)="" Q
 .. I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria includes a "not" it is inclusive and both must be true
 I $E(VCRIT1)="'",@(@VDPROV@(PROV,IEN)_VCRIT1),@(@VDPROV@(PROV,IEN)_VCRIT2) D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria does not includes a "not" it is exclusive and one must be true
 I $E(VCRIT1)'="'",@(@VDPROV@(PROV,IEN)_VCRIT1_"!("_(@VDPROV@(PROV,IEN)_VCRIT2)_")") D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 Q
 ;
VDBT ; Clinic and Provider
 I NOVST,$D(@VDCLPR@(CLIN,PROV,IEN)) S @VNDATA@(IEN)="" Q
 I '$D(@VDCLPR@(CLIN,PROV,IEN)) Q
 I VCRIT1="" D  Q
 . I @(@VDCLPR@(CLIN,PROV,IEN)_NUMVIS) D
 .. I VISOP="!" S @TGLOB@(IEN)=""
 .. I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria includes a "not" it is inclusive and both must be true
 I $E(VCRIT1)="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1),@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2) D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 ; If criteria does not includes a "not" it is exclusive and one must be true
 I $E(VCRIT1)'="'",@(@VDCLPR@(CLIN,PROV,IEN)_VCRIT1_"!("_(@VDCLPR@(CLIN,PROV,IEN)_VCRIT2)_")") D
 . I VISOP="!" S @TGLOB@(IEN)="" Q
 . I VISOP="&" S @VDAND@(IEN)=$G(@VDAND@(IEN))+1
 Q
