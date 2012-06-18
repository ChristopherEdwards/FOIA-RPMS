BQIDCUTL ;VNGT/HS/ALA-Definition Utility ; 12 Sep 2008  1:43 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
LAB(BQDFN,TEST) ;EP - Check for most recent result of a specified Lab test
 ;
 ; Input
 ;   BQDFN   - Patient internal entry number
 ;   TEST    - Lab Test IEN to search
 ;
 NEW LIEN,QFL,RES,TIEN,VALUE,VIEN,VSDTM,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^TMP("BQIVLAB",UID)) K @TEMP
 S LIEN="",QFL=0,RES=0
 F  S LIEN=$O(^AUPNVLAB("AC",BQDFN,LIEN),-1) Q:LIEN=""  D  Q:QFL
 . S TIEN=$P($G(^AUPNVLAB(LIEN,0)),U,1) I TIEN="" Q
 . I TIEN'=TEST Q
 . S VALUE=$P(^AUPNVLAB(LIEN,0),U,4) I VALUE="" Q
 . S VIEN=$P(^AUPNVLAB(LIEN,0),U,3) I VIEN="" Q
 . S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 . ; quit if deleted flag
 . I $P(^AUPNVSIT(VIEN,0),U,11)=1 Q
 . S @TEMP@(VSDTM,VIEN,LIEN)=VALUE
 ;
 S VSDTM=$O(@TEMP@(""),-1)
 I VSDTM'="" D
 . S VIEN=$O(@TEMP@(VSDTM,""),-1)
 . S LIEN=$O(@TEMP@(VSDTM,VIEN,""),-1)
 . S VALUE=@TEMP@(VSDTM,VIEN,LIEN)
 . S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_VSDTM,QFL=1
 K @TEMP
 Q RES
 ;
MEAS(BQDFN,MEAS) ;EP - Find most recent value for a measurement
 ;
 ; Input
 ;   BQDFN   - Patient internal entry number
 ;   MEAS    - Measurement IEN to search
 ;
 NEW LIEN,QFL,RES,TIEN,VALUE,VIEN,VSDTM,TEMP,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^TMP("BQIVMSR",UID)) K @TEMP
 ;
 I MEAS'?.N S MEAS=$$FIND1^DIC(9999999.07,,"MX",MEAS)
 I MEAS=0 Q 0
 S LIEN="",QFL=0,RES=0
 F  S LIEN=$O(^AUPNVMSR("AC",BQDFN,LIEN),-1) Q:LIEN=""  D
 . S TIEN=$P($G(^AUPNVMSR(LIEN,0)),U,1) I TIEN="" Q
 . I TIEN'=MEAS Q
 . ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 . I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,LIEN_",",2,"I")=1
 . S VALUE=$P(^AUPNVMSR(LIEN,0),U,4) I VALUE="" Q
 . S VIEN=$P(^AUPNVMSR(LIEN,0),U,3) I VIEN="" Q
 . S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 . ; quit if deleted flag
 . I $P(^AUPNVSIT(VIEN,0),U,11)=1 Q
 . S @TEMP@(VSDTM,VIEN,LIEN)=VALUE
 ;
 S VSDTM=$O(@TEMP@(""),-1)
 I VSDTM'="" D
 . S VIEN=$O(@TEMP@(VSDTM,""),-1)
 . S LIEN=$O(@TEMP@(VSDTM,VIEN,""),-1)
 . S VALUE=@TEMP@(VSDTM,VIEN,LIEN)
 . S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN_U_VSDTM
 K @TEMP
 Q RES
 ;
HMEAS(BQDFN,MEAS) ;EP - Find highest value for a measurement
 ;
 ; Input
 ;   BQDFN   - Patient internal entry number
 ;   MEAS    - Measurement IEN to search
 ;
 NEW LIEN,QFL,RES,TIEN,VALUE,VIEN,VSDTM,TEMP,UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^TMP("BQIVMSR",UID)) K @TEMP
 I MEAS'?.N S MEAS=$$FIND1^DIC(9999999.07,,"MX",MEAS)
 I MEAS=0 Q 0
 S LIEN="",QFL=0,RES=0
 F  S LIEN=$O(^AUPNVMSR("AC",BQDFN,LIEN),-1) Q:LIEN=""  D
 . S TIEN=$P($G(^AUPNVMSR(LIEN,0)),U,1) I TIEN="" Q
 . I TIEN'=MEAS Q
 . ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 . I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,LIEN_",",2,"I")=1
 . S VALUE=$P(^AUPNVMSR(LIEN,0),U,4) I VALUE="" Q
 . S VIEN=$P(^AUPNVMSR(LIEN,0),U,3) I VIEN="" Q
 . S VSDTM=$$GET1^DIQ(9000010,VIEN_",",.01,"I")\1 I VSDTM=0 Q
 . ; quit if deleted flag
 . I $P(^AUPNVSIT(VIEN,0),U,11)=1 Q
 . S @TEMP@(VALUE,VSDTM,VIEN,LIEN)=""
 ;
 S VALUE=$O(@TEMP@(""),-1)
 I VALUE'="" D
 . S VSDTM=$O(@TEMP@(VALUE,""),-1)
 . S VIEN=$O(@TEMP@(VALUE,VSDTM,""),-1)
 . S LIEN=$O(@TEMP@(VALUE,VSDTM,VIEN,""),-1)
 . ;S VALUE=@TEMP@(VALUE,VSDTM,VIEN,LIEN)
 . S RES=1_U_$$FMTE^BQIUL1(VSDTM)_U_VALUE_U_VIEN_U_LIEN
 K @TEMP
 Q RES
 ;
VISIT(BQDFN,FREF,TXRY,SERV,CLNRY,PRIM,TEMP) ; EP - Get Last Visit
 ;Input Parameters
 ;  BQDFN - Patient IEN
 ;  FREF  - V File Reference number
 ;  TXRY  - List of taxonomies whose entries are applicable
 ;  SERV  - Service Category (code separated by ;) e.g. A;H
 ;  CLNRY - List of locations where the visit is applicable
 ;  PRIM  - If one, value must be a primary diagnosis
 ;  TEMP  - Array to return the list of found visits
 ;
 NEW TREF,IEN,TAX,TIEN,VISIT,VSDTM,CLINIC,CLN,GREF,OPRM,VSERV
 S GREF=$$ROOT^DILFD(FREF,"",1),PRIM=$G(PRIM,0)
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TREF=$NA(^TMP("BQITAX",UID))
 K @TREF,TEMP
 ; Check for a list of taxonomies
 D
 . S TAX=""
 . F  S TAX=$O(TXRY(TAX)) Q:TAX=""  D BLD^BQITUTL(TAX,TREF)
 ;
 S IEN=""
 F  S IEN=$O(@GREF@("AC",BQDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(FREF,IEN,.01,"I") Q:TIEN=""
 . ; Check if the record has an applicable taxonomy entry
 . I '$D(@TREF@(TIEN)) Q
 . S VISIT=$$GET1^DIQ(FREF,IEN,.03,"I") Q:VISIT=""
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . ; If the V File reference is V POV and the primary diagnosis flag is defined
 . ; check if the value is a primary diagnosis
 . I FREF=9000010.07,PRIM,$P(@GREF@(IEN,0),U,12)'="P" S OPRM=0 D  Q:'OPRM
 .. I $O(@GREF@("AD",VISIT,""))=IEN S OPRM=1
 . S VSDTM=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VSDTM
 . ;I $G(TMFRAME)'="",VSDTM<ENDT Q
 . ; If service categories, check the visit for the service category
 . S VSERV=$$GET1^DIQ(9000010,VISIT,.07,"I")
 . I $G(SERV)'="",SERV'[VSERV Q
 . ; If locations, check the visit for a matching location
 . S CLN=$$GET1^DIQ(9000010,VISIT,.08,"I")
 . S CLINIC=$$GET1^DIQ(40.7,CLN_",",1,"E")
 . I CLINIC'="",$D(CLNRY),'$D(CLNRY(CLINIC)) Q
 . S TEMP(VSDTM,IEN)=VISIT
 Q
 ;
PROB(BQDFN,TXRY,TEMP) ; EP - Get Last Problem
 ;Input Parameters
 ;  BQDFN - Patient IEN
 ;  TXRY  - List of taxonomies whose entries are applicable
 ;  TEMP  - Array to return the list of found visits
 ;
 NEW TREF,IEN,TAX,TIEN,PRDTM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TREF=$NA(^TMP("BQITAX",UID))
 K @TREF,TEMP
 ; Check for a list of taxonomies
 D
 . S TAX=""
 . F  S TAX=$O(TXRY(TAX)) Q:TAX=""  D BLD^BQITUTL(TAX,TREF)
 ;
 S IEN=""
 F  S IEN=$O(^AUPNPROB("AC",BQDFN,IEN),-1) Q:IEN=""  D
 . S TIEN=$$GET1^DIQ(9000011,IEN,.01,"I") Q:TIEN=""
 . ; Check if the record has an applicable taxonomy entry
 . I '$D(@TREF@(TIEN)) Q
 . S PRDTM=$P(^AUPNPROB(IEN,0),U,8)
 . I PRDTM="" S PRDTM=$$PROB^BQIUL1(IEN)
 . I PRDTM="" Q
 . S TEMP(PRDTM,IEN)=""
 Q
 ;
HF(BQDFN,HFACT) ;EP - Find most recent value for a Health Factor
 ; Input
 ;   BQDFN   - Patient internal entry number
 ;   HFACT   - Health Factor to search for
 ;
 NEW VISIT,HIEN,VSDTM,TEMP,UID,RESULT,ATRDT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^TMP("BQIVHF",UID)) K @TEMP
 ;
 S RESULT=""
 I HFACT'?.N S HFACT=$$FIND1^DIC(9999999.64,,"MX",HFACT)
 I HFACT=0 Q RESULT
 ;
 D
 . S ATRDT=$O(^AUPNVHF("AA",BQDFN,HFACT,"")) I ATRDT="" Q
 . S HIEN=$O(^AUPNVHF("AA",BQDFN,HFACT,ATRDT,"")) I HIEN="" Q
 . S VISIT=$P(^AUPNVHF(HIEN,0),U,3) I VISIT="" Q
 . S VSDTM=$P(^AUPNVSIT(VISIT,0),U,1)\1 I VSDTM=0 Q
 . S RESULT=VSDTM_U_"9000010:"_VISIT
 Q RESULT
