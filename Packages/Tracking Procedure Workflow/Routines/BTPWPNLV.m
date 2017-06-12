BTPWPNLV ;VNGT/HS/ALA-CMET Panel ; 03 Aug 2009  4:07 PM
 ;;1.1;CARE MANAGEMENT EVENT TRACKING;;Apr 01, 2015;Build 25
 ;
EN(DATA,OWNR,PLIEN,VIEW,STATE,PLIST,CMLST,PARMS) ;EP - BTPW GET EVENTS BY PANEL
 ;
 ; Input
 ;   OWNR  - Owner
 ;   PLIEN - Panel IEN
 ;   VIEW  - (Q)ueued, (T)racked, (N) Planned
 ;   STATE - State or status
 ;   PLIST - List of DFNs to include
 ;   CMLST - List of file IENs to include (optional)
 ;   PARMS - List of panel filters - Event Type Only (See BTPWPEVF for details)
 ;
 NEW UID,II,STATUS,BDT,EDT,CATLST,COMM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPNLV",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPNLV D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S STATE=$G(STATE,"")
 ;
 ;Define filter variables
 I $G(VIEW)="Q" D FINIT^BTPWPEVF(.STATUS,.BDT,.EDT,.CATLST,.COMM,.PARMS)
 ;
 ;Check for IEN List
 I $G(CMLST)]"" D
 . N I,IEN
 . F I=1:1:$L(CMLST,$C(29)) S IEN=$P(CMLST,$C(29),I) I IEN]"" S CMLST(IEN)=""
 ;
 ; If a list of CMIENs, process them instead of entire panel
 I $O(CMLST(""))]"" D  G DONE
 . N CIEN
 . S CIEN="" F  S CIEN=$O(CMLST(CIEN)) Q:CIEN=""  D
 .. ;
 .. ;Get DFN
 .. I VIEW="Q" S DFN=$$GET1^DIQ(90629,CIEN_",",".02","I")
 .. E  S DFN=$$GET1^DIQ(90620,CIEN_",",".02","I")
 .. Q:DFN=""
 .. I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 .. D PAT(.DATA,OWNR,PLIEN,STATE,DFN,.CMLST)
 ; 
 ; If a list of DFNs, process them instead of entire panel
 I $D(PLIST)>0 D  G DONE
 . N BN,BQI
 . I $D(PLIST)>1 D
 .. S LIST="",BN=""
 .. F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 .. K PLIST S PLIST=LIST
 . F BQI=1:1 S DFN=$P(PLIST,$C(28),BQI) Q:DFN=""  D
 .. I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 .. D PAT(.DATA,OWNR,PLIEN,STATE,DFN,.CMLST)
 ;
 S DFN=0
 I $O(^BQICARE(OWNR,1,PLIEN,40,DFN))="" D PAT(.DATA,OWNR,PLIEN,STATE,"",.CMLST) G DONE
 ;
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D
 . I $P($G(^BQICARE(OWNR,1,PLIEN,40,DFN,0)),"^",2)="R" Q
 . D PAT(.DATA,OWNR,PLIEN,STATE,DFN,.CMLST)
 ;
DONE ;
 I II=0,'$D(@DATA) D PAT(.DATA,OWNR,PLIEN,STATE,"",.CMLST)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PAT(DATA,OWNR,PLIEN,STATE,DFN,CMLST) ;EP - Build record by patient
 ; Get standard display
 NEW IEN,HDR,HEADR,SENS,HDOB,Y,STVW,TEXT,ORD,GMET,GHDR,RGIEN,CRIEN,CARE,CTYP
 NEW GIEN,CIEN,SVALUE,VALUE,VAL
 S VALUE="",RGIEN="",STATE=$G(STATE,"")
 I DFN'="" S Y=$$GET1^DIQ(9000001,DFN_",",1102.2,"I"),HDOB=$$FMTE^BQIUL1(Y)
 I DFN'="" S SVALUE=DFN_U_$$SENS^BQIULPT(DFN)_U_$$FLG^BQIULPT(OWNR,PLIEN,DFN)_U_$$CALR^BQIULPT(DFN)_U_$$MFLAG^BQIULPT(OWNR,PLIEN,DFN)_U_HDOB_U
 S HEADR="I00010HIDE_DFN^T00001SENS_FLAG^T00001FLAG_INDICATOR^T00001COMM_FLAG^T00001HIDE_MANUAL^D00030HIDE_DOB^I00010HIDE_CMET_IEN^"
 S HEADR=HEADR_"I00010HIDE_VISIT_IEN^I00010HIDE_EVENTTYPE_IEN^"
 ;
 ;Custom Header
 I VIEW="Q" S HEADR=HEADR_"T00060HIDE_BTPWQENM^D00015HIDE_BTPWQEDT^T00020HIDE_BTPWQSTS^"
 E  S HEADR=HEADR_"T00060HIDE_BTPWTENM^D00015HIDE_BTPWTEDT^T00015HIDE_BTPWTSTA^T00010HIDE_PREVIOUS_EVENT^"
 ;
 S CARE="Event Tracking"
 I VIEW="Q" S CARE="Events"
 I VIEW="T" S CARE="Tracked Events"
 I VIEW="N" S CARE="Followup Events"
 S CRIEN=$O(^BQI(90506.5,"B",CARE,"")),CTYP=$P(^BQI(90506.5,CRIEN,0),U,2)
 ;
 I DFN="" D FND Q
 ;
 I VIEW="Q" D
 . N QIEN,TIEN
 . S (QIEN,TIEN)=""
 . ;
 . ;Process individual (input) events
 . I $O(CMLST(""))]"" D  Q
 .. F  S QIEN=$O(CMLST(QIEN)) Q:QIEN=""  D
 ... ;
 ... ;Panel Filters
 ... Q:'$$PEFIL^BTPWPEVF(STATUS,BDT,EDT,.CATLST,.COMM,QIEN)
 ... ;
 ... S TIEN=$P($G(^BTPWQ(QIEN,0)),U,14)
 ... ;
 ... ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATUS
 ... S VALUE=SVALUE_QIEN_U_$$GET1^DIQ(90629,QIEN_",",".04","I")_U_$$GET1^DIQ(90629,QIEN_",",".01","I")
 ... S VALUE=VALUE_U_$$GET1^DIQ(90629,QIEN_",",".01","E")
 ... S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90629,QIEN_",",".03","I"))_U_$$GET1^DIQ(90629,QIEN_",",".08","E")_U
 ... ;
 ... D FND
 . ;
 . ;Process entire panel
 . I STATE'="" F  S QIEN=$O(^BTPWQ("AE",DFN,STATE,QIEN)) Q:QIEN=""  D
 .. ;
 .. ;Panel Filters
 .. Q:'$$PEFIL^BTPWPEVF(STATUS,BDT,EDT,.CATLST,.COMM,QIEN)
 .. ;
 .. S TIEN=$P($G(^BTPWQ(QIEN,0)),U,14)
 .. ;
 .. ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATUS
 .. S VALUE=SVALUE_QIEN_U_$$GET1^DIQ(90629,QIEN_",",".04","I")_U_$$GET1^DIQ(90629,QIEN_",",".01","I")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90629,QIEN_",",".01","E")
 .. S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90629,QIEN_",",".03","I"))_U_$$GET1^DIQ(90629,QIEN_",",".08","E")_U
 .. ;
 .. D FND
 . I STATE="" F  S QIEN=$O(^BTPWQ("AD",DFN,QIEN)) Q:QIEN=""  D
 .. ;
 .. ;Panel Filters
 .. Q:'$$PEFIL^BTPWPEVF(STATUS,BDT,EDT,.CATLST,.COMM,QIEN)
 .. ;
 .. S TIEN=$P($G(^BTPWQ(QIEN,0)),U,14)
 .. ;
 .. ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATUS
 .. S VALUE=SVALUE_QIEN_U_$$GET1^DIQ(90629,QIEN_",",".04","I")_U_$$GET1^DIQ(90629,QIEN_",",".01","I")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90629,QIEN_",",".01","E")
 .. S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90629,QIEN_",",".03","I"))_U_$$GET1^DIQ(90629,QIEN_",",".08","E")_U
 .. ;
 .. D FND
 ;
 I VIEW="T"!(VIEW="N") D
 . N QIEN,TIEN,STATUS
 . S (QIEN,TIEN)=""
 . ;
 . ;Process individual (input) events
 . I $O(CMLST(""))]"" D  Q
 .. F  S TIEN=$O(CMLST(TIEN)) Q:TIEN=""  D
 ... ;
 ... ; Don't show 'future' records
 ... I $P($G(^BTPWP(TIEN,1)),U,1)="F",VIEW'="N" Q
 ... I $P($G(^BTPWP(TIEN,1)),U,1)'="F",VIEW="N" Q
 ... S QIEN=$P($G(^BTPWP(TIEN,0)),U,14)
 ... ;
 ... ;Status Check - Must be Tracked
 ... I QIEN]"" S STATUS=$$GET1^DIQ(90629,QIEN_",",.08,"I") I STATUS'="",STATUS'="T" Q
 ... ;
 ... ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATE, PREVIOUS EVENT
 ... S VALUE=SVALUE_TIEN_U_$$GET1^DIQ(90620,TIEN_",",".04","I")_U_$$GET1^DIQ(90620,TIEN_",",".01","I")
 ... S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".01","E")
 ... S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90620,TIEN_",",".03","I"))_U_$$GET1^DIQ(90620,TIEN_",","1.01","E")
 ... S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".11","I")_U
 ... ;
 ... D FND
 . ;
 . ;Process entire panel
 . I STATE'="" F  S TIEN=$O(^BTPWP("AE",DFN,STATE,TIEN)) Q:TIEN=""  D
 .. ;
 .. S QIEN=$P($G(^BTPWP(TIEN,0)),U,14)
 .. ;
 .. ;Status Check - Must be Tracked
 .. I QIEN]"" S STATUS=$$GET1^DIQ(90629,QIEN_",",.08,"I") I STATUS'="",STATUS'="T" Q
 .. ;
 .. ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATE
 .. S VALUE=SVALUE_TIEN_U_$$GET1^DIQ(90620,TIEN_",",".04","I")_U_$$GET1^DIQ(90620,TIEN_",",".01","I")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".01","E")
 .. S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90620,TIEN_",",".03","I"))_U_$$GET1^DIQ(90620,TIEN_",","1.01","E")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".11","I")_U
 .. ;
 .. D FND
 . I STATE="" F  S TIEN=$O(^BTPWP("AD",DFN,TIEN)) Q:TIEN=""  D
 .. ;
 .. ; Don't show 'future' records
 .. I $P($G(^BTPWP(TIEN,1)),U,1)="F",VIEW'="N" Q
 .. I $P($G(^BTPWP(TIEN,1)),U,1)'="F",VIEW="N" Q
 .. S QIEN=$P($G(^BTPWP(TIEN,0)),U,14)
 .. ;
 .. ;Status Check - Must be Tracked
 .. I QIEN]"" S STATUS=$$GET1^DIQ(90629,QIEN_",",.08,"I") I STATUS'="",STATUS'="T" Q
 .. ;
 .. ;Tack on CMET IEN, VISIT IEN, CATEGORY IEN, TICKLER_INDICATOR, EVENT NAME, EVENT DATE, STATE
 .. S VALUE=SVALUE_TIEN_U_$$GET1^DIQ(90620,TIEN_",",".04","I")_U_$$GET1^DIQ(90620,TIEN_",",".01","I")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".01","E")
 .. S VALUE=VALUE_U_$$FMTE^BQIUL1($$GET1^DIQ(90620,TIEN_",",".03","I"))_U_$$GET1^DIQ(90620,TIEN_",","1.01","E")
 .. S VALUE=VALUE_U_$$GET1^DIQ(90620,TIEN_",",".11","I")_U
 .. ;
 .. D FND
 Q
 ;
FND ; Check for template
 NEW DA,IENS,TEMPL,LYIEN,DOR,LIST
 S TEMPL=""
 I OWNR'=DUZ D
 . S DA=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,4,"C",CTYP,""))
 . I DA="" Q
 . S DA(3)=OWNR,DA(2)=PLIEN,DA(1)=DUZ,IENS=$$IENS^DILF(.DA)
 . S TEMPL=$$GET1^DIQ(90505.34,IENS,.01,"E")
 I OWNR=DUZ D
 . S DA=$O(^BQICARE(OWNR,1,PLIEN,4,"C",CTYP,""))
 . I DA="" Q
 . S DA(2)=OWNR,DA(1)=PLIEN,IENS=$$IENS^DILF(.DA)
 . S TEMPL=$$GET1^DIQ(90505.14,IENS,.01,"E")
 ;
 ; If template, use it
 I TEMPL'="" D  G FIN
 . ;S LYIEN=$$DEF^BQILYUTL(OWNR,"M")
 . S LYIEN=$$TPN^BQILYUTL(DUZ,TEMPL)
 . I LYIEN="" Q
 . S DOR=""
 . F  S DOR=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR)) Q:DOR=""  D
 .. S IEN=""
 .. F  S IEN=$O(^BQICARE(DUZ,15,LYIEN,1,"C",DOR,IEN)) Q:IEN=""  D
 ... S CODE=$P(^BQICARE(DUZ,15,LYIEN,1,IEN,0),U,1)
 ... S GIEN=$O(^BQI(90506.1,"B",CODE,"")) I GIEN="" Q
 ... S STVW=GIEN
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 ; If no template, check for customized
 I OWNR=DUZ D
 . S CIEN=$O(^BQICARE(OWNR,1,PLIEN,23,"B",CARE,""))
 . I CIEN'="" D
 .. S IEN=0
 .. I $O(^BQICARE(OWNR,1,PLIEN,23,CIEN,1,IEN))="" D DEF Q
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,23,CIEN,1,IEN)) Q:'IEN  D
 ... S GIEN=$P(^BQICARE(OWNR,1,PLIEN,23,CIEN,1,IEN,0),"^",1) Q:GIEN=""
 ... ;S STVW=GIEN
 ... S STVW=$O(^BQI(90506.1,"B",GIEN,"")) Q:STVW=""
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . ;
 . ; If no customized, use default
 . I CIEN="" D DEF
 ;
 I OWNR'=DUZ D
 . S CIEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,"B",CARE,""))
 . I CIEN'="" D
 .. S IEN=0
 .. F  S IEN=$O(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,CIEN,1,IEN)) Q:'IEN  D
 ... S GIEN=$P(^BQICARE(OWNR,1,PLIEN,30,DUZ,23,CIEN,1,IEN,0),"^",1)
 ... ;S STVW=GIEN
 ... S STVW=$O(^BQI(90506.1,"B",GIEN,"")) Q:STVW=""
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 . I CIEN="" D DEF
 ;
FIN ; Finish
 S HEADR=$$TKO^BQIUL1(HEADR,"^")
 S VALUE=$$TKO^BQIUL1(VALUE,"^")
 ;
 I DFN="" S VALUE=""
 ;
 I II=0 S @DATA@(II)=HEADR_$C(30)
 I VALUE'="" D
 . I $P($G(@DATA@(II)),$C(30),1)'=VALUE S II=II+1,@DATA@(II)=VALUE_$C(30)
 Q
 ;
CVAL ; Get demographic values
 ;Parameters
 ;  FIL  = FileMan file number
 ;  FLD  = FileMan field number
 ;  EXEC = If an executable is needed to determine value
 ;  HDR  = Header value
 ;the executable expects the value to be returned in variable VAL
 NEW FIL,FLD,EXEC,RCODE,RGIEN,RIEN,RHDR,MVALUE,CODE
 S FIL=$$GET1^DIQ(90506.1,STVW_",",.05,"E")
 S FLD=$$GET1^DIQ(90506.1,STVW_",",.06,"E")
 S EXEC=$$GET1^DIQ(90506.1,STVW_",",1,"E")
 S HDR=$$GET1^DIQ(90506.1,STVW_",",.08,"E")
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" X EXEC Q
 I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 Q
 ;
 S RCODE=$$GET1^DIQ(90506.1,STVW_",",.01,"E")
 S RGIEN=$O(^BQI(90506.3,"AC",CRIEN,"")),VAL=""
 I RGIEN'="" D  Q:VAL'=""
 . S RIEN=$O(^BQI(90506.3,RGIEN,10,"AC",RCODE,""))
 . I RIEN'="",$P($G(^BQI(90506.3,RGIEN,10,RIEN,1)),U,1)="M" D  Q
 .. S RHDR=$P(^BQI(90506.3,RGIEN,10,RIEN,0),U,2),MVALUE=""
 .. NEW SNAME,SRIEN,SORD,SXREF,SIEN
 .. S SNAME=$P(^BQI(90506.3,RGIEN,10,RIEN,0),U,1)
 .. S SRIEN=$O(^BQI(90506.3,"B",SNAME,"")) I SRIEN="" Q
 .. S SORD="",SXREF=$S($D(^BQI(90506.3,SRIEN,10,"AF")):"AF",1:"C")
 .. F  S SORD=$O(^BQI(90506.3,SRIEN,10,SXREF,SORD)) Q:SORD=""  D
 ... S SIEN=""
 ... F  S SIEN=$O(^BQI(90506.3,SRIEN,10,SXREF,SORD,SIEN)) Q:SIEN=""  D
 .... I $P(^BQI(90506.3,SRIEN,10,SIEN,0),U,4)'="S" Q
 .... S CODE=$P(^BQI(90506.3,SRIEN,10,SIEN,0),U,7) I CODE="" Q
 .... S STVW=$O(^BQI(90506.1,"B",CODE,"")) I STVW="" Q
 .... I $$GET1^DIQ(90506.1,STVW_",",.1,"I")=1 Q
 .... NEW FIL,FLD,EXEC
 .... S FIL=$$GET1^DIQ(90506.1,STVW_",",.05,"E")
 .... S FLD=$$GET1^DIQ(90506.1,STVW_",",.06,"E")
 .... S EXEC=$$GET1^DIQ(90506.1,STVW_",",1,"E")
 .... S HDR=RHDR
 .... I $G(DFN)="" S VAL="" Q
 .... ;
 .... I $G(EXEC)'="" X EXEC S VAL=VAL_$S(VAL'="":$C(10),1:"") Q
 .... I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 .... S VALUE=VALUE_VAL_$S(VAL'="":$C(10),1:"")
 .... S VAL=VALUE
 ... S MVALUE=MVALUE_$$TKO^BQIUL1(VAL,$C(10))
 ... ;S MVALUE=MVALUE_VAL
 .. S VAL=MVALUE
 ;
 I FIL'="",FLD'="" S VAL=$$GET1^DIQ(FIL,DFN_",",FLD,"E")
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEF ; Default list of fields
 NEW CRIEN,TYP,ORD,IEN,STVW,DEFF
 ; Check for any alternate display order which trumps source display order
 S CRIEN=$$FIND1^DIC(90506.5,"","B",CARE,"","","ERROR")
 S TYP=$P(^BQI(90506.5,CRIEN,0),U,2)
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AF",TYP,ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AF",TYP,ORD,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVW=IEN
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 S TYP="D",ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD",TYP,ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD",TYP,ORD,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVW=IEN
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 ;
 NEW CRIEN,TYP,ORD,IEN,STVW
 S CRIEN=$$FIND1^DIC(90506.5,"","B",CARE,"","","ERROR")
 S TYP=$P(^BQI(90506.5,CRIEN,0),U,2)
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD",TYP,ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD",TYP,ORD,IEN)) Q:IEN=""  D
 .. I $$GET1^DIQ(90506.1,IEN_",",.1,"I")=1 Q
 .. I $$GET1^DIQ(90506.1,IEN_",",3.04,"I")'="O" D
 ... S STVW=IEN
 ... D CVAL
 ... S VALUE=VALUE_VAL_"^"
 ... S HEADR=HEADR_HDR_"^"
 Q
 ;
