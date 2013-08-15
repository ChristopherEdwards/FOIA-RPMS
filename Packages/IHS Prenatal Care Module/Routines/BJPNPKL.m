BJPNPKL ;GDIT/HS/BEE-Prenatal Care Module Pick List ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
LST(DATA,FAKE) ;EP - BJPN GET PICK LISTS
 ;
 ;This RPC returns top level entries from the BJPN PICK LISTS file (#90680.03)
 ;
 NEW UID,II,SORT,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010HIDDEN_PLIEN^T00030PICK_LISTS"_$C(30)
 ;
 S SORT="" F  S SORT=$O(^BJPN(90680.03,"AC",SORT)) Q:SORT=""  D
 . N IEN
 . ;
 . S IEN="" F  S IEN=$O(^BJPN(90680.03,"AC",SORT,IEN)) Q:IEN=""  D
 .. N CAT
 .. ;
 .. S CAT=$$GET1^DIQ(90680.03,IEN_",",".01","I") Q:CAT=""
 .. ;
 .. ;Skip Master_List
 .. Q:CAT="Master_List"
 .. ;
 .. S II=II+1,@DATA@(II)=IEN_U_CAT_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
SNO(DATA,DFN) ;EP - BJPN GET SNOMED TERMS
 ;
 ;This RPC returns entries from the BJPN SNOMED TERMS file (#90680.02)
 ;If the DFN is supplied, it returns whether the patient has that problem
 ;on their PIP
 ;
 ;Input: DFN (Optional) - Patient DFN
 ;
 S DFN=$G(DFN)
 ;
 NEW UID,II,PSTS,RFEDD,PREDD,ICD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010HIDDEN_PKIEN^T00150SNOMED_TERM^T00250FULL_NAME^T00025CONCEPT_ID^T00001PIP^T00010ICD"_$C(30)
 ;
 S TRM="" F  S TRM=$O(^BJPN(90680.02,"C",TRM)) Q:TRM=""  D
 . S IEN="" F  S IEN=$O(^BJPN(90680.02,"C",TRM,IEN)) Q:IEN=""  D
 .. NEW TRM,FSPNM,CAT,CIEN,IENS,CONC,FREQ,PIP,PLIEN,ICIEN
 .. ;
 .. ;SNOMED TERM
 .. S TRM=$$GET1^DIQ(90680.02,IEN_",",.02,"E") Q:TRM=""
 .. ;
 .. ;FULLY SPECIFIED NAME
 .. S FSPNM=$$GET1^DIQ(90680.02,IEN_",",3,"E")
 .. ;
 .. ;CONCEPT ID
 .. S CONC=$$GET1^DIQ(90680.02,IEN_",",.07,"E") Q:CONC=""
 .. ;
 .. ;Code on Problem List
 .. S PIP="N"
 .. I DFN]"" S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,IEN,PLIEN)) Q:PLIEN=""  D
 ... NEW DEL
 ... I $$GET1^DIQ(90680.01,PLIEN_",",2.01,"I")]"" Q
 ... S PIP="Y"
 .. ;
 .. ;Pull the ICD-9
 .. S ICD=""
 .. S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,IEN,1,ICIEN)) Q:'ICIEN  D
 ... ;
 ... NEW ICD9,ICDTP,DA,IENS
 ... S DA(1)=IEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 ... S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"E") Q:ICD9=""
 ... S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 ... S ICD=ICD_$S(ICD]"":";",1:"")_ICD9
 .. S:ICD="" ICD=".9999"
 .. ;
 .. S II=II+1,@DATA@(II)=IEN_U_TRM_U_FSPNM_U_CONC_U_PIP_U_ICD_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PICK(DATA,PLIEN,DFN) ;EP - BJPN GET PICK LIST
 ;
 ;This RPC returns entries from the BJPN PICK LISTS file (#90680.02).
 ;It will return all SNOMED entries for a particular Pick List Entry.
 ;
 ;If the DFN is supplied, it returns whether the patient has that problem
 ;
 ;Input: PLIEN (Optional) - Pick List IEN (Master if null)
 ;       DFN (Optional) - Patient DFN
 ;
 S DFN=$G(DFN)
 S PLIEN=$G(PLIEN)
 ;
 NEW UID,II,TRM,IEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 S II=0
 ;
 ;Data validation
 S:PLIEN="" PLIEN=$O(^BJPN(90680.03,"B","Master_List",""))
 I PLIEN="" G XPICK
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010HIDDEN_PKIEN^T00150SNOMED_TERM^T00250FULL_NAME^T00025CONCEPT_ID^I00010FREQ^T00001PIP^T00010ICD"_$C(30)
 ;
 ;Loop through BJPN PICK LISTS and return each problem
 S TRM="" F  S TRM=$O(^BJPN(90680.03,PLIEN,1,"B",TRM)) Q:TRM=""  D
 . S IEN="" F  S IEN=$O(^BJPN(90680.03,PLIEN,1,"B",TRM,IEN)) Q:IEN=""  D
 .. ;
 .. NEW DA,IENS,PKIEN,DNAME,FSPNMCONC,PIP,ICD,ICIEN,FREQ
 .. ;
 .. S DA(1)=PLIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 .. S PKIEN=$$GET1^DIQ(90680.031,IENS,".02","I") Q:PKIEN=""
 .. ;
 .. ;Pull Display Name
 .. S DNAME=$$GET1^DIQ(90680.031,IENS,".01","E")
 .. ;
 .. S FREQ=$$GET1^DIQ(90680.031,IENS,".03","I")
 .. ;
 .. ;SNOMED TERM - If no display name
 .. S:DNAME="" DNAME=$$GET1^DIQ(90680.02,PKIEN_",",.02,"E") Q:DNAME=""
 .. ;
 .. ;FULLY SPECIFIED NAME
 .. S FSPNM=$$GET1^DIQ(90680.02,PKIEN_",",3,"E")
 .. ;
 .. ;CONCEPT ID
 .. S CONC=$$GET1^DIQ(90680.02,PKIEN_",",.07,"E") Q:CONC=""
 .. ;
 .. ;Code on Problem List
 .. S PIP="N"
 .. I DFN]"" D
 ... NEW PLIEN
 ... S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,PKIEN,PLIEN)) Q:PLIEN=""  D
 .... NEW DEL
 .... I $$GET1^DIQ(90680.01,PLIEN_",",2.01,"I")]"" Q
 .... S PIP="Y"
 .. ;
 .. ;Pull the ICD-9
 .. S ICD=""
 .. S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,IEN,1,ICIEN)) Q:'ICIEN  D
 ... ;
 ... NEW ICD9,ICDTP,DA,IENS
 ... S DA(1)=IEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 ... S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"E") Q:ICD9=""
 ... S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 ... S ICD=ICD_$S(ICD]"":";",1:"")_ICD9
 .. S:ICD="" ICD=".9999"
 .. ;
 .. S II=II+1,@DATA@(II)=PKIEN_U_DNAME_U_FSPNM_U_CONC_U_FREQ_U_PIP_U_ICD_$C(30)
 ;
XPICK S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PPRV(VIEN) ;EP - Retrieve Visit Primary Provider
 ;
 NEW PPRV,IEN
 ;
 I $G(VIEN)="" Q ""
 ;
 S (PPRV,IEN)="" F  S IEN=$O(^AUPNVPRV("AD",VIEN,IEN)) Q:'IEN  D  Q:PPRV]""
 . NEW PTYPE
 . S PTYPE=$$GET1^DIQ(9000010.06,IEN_",",.04,"I") Q:PTYPE'="P"
 . S PPRV=$$GET1^DIQ(9000010.06,IEN_",",.01,"I")
 Q PPRV
 ;
DEL(DATA,VIEN,PKIEN,DCODE,DRSN) ;BJPN PICK LIST PRB DELETE
 ;
 ;Delete prenatal problem from PIP (and remove from V OB)
 ;
 ;Input:
 ; VIEN - Visit IEN
 ; PKIEN - Pointer to 90680.02 SNOMED TERM entry
 ; DCODE - Delete Code
 ; DRSN - Delete Reason (if Other)
 ;
 NEW UID,II,%,NOW,PRUPD,ERROR,RSLT,DFN,PROC,DTTM,VFL,VPUPD,DFN,PIPIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00010RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XDEL
 I $G(PKIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PKIEN"_$C(30) G XDEL
 S DCODE=$G(DCODE,""),DRSN=$G(DRSN,"")
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I")
 ;
 ;Locate PIPIEN
 S PIPIEN=""
 I DFN]"" D
 . NEW PLIEN
 . S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,PKIEN,PLIEN)) Q:PLIEN=""  D  Q:PIPIEN]""
 .. NEW DEL
 .. I $$GET1^DIQ(90680.01,PLIEN_",",2.01,"I")]"" Q
 .. S PIPIEN=PLIEN
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^COULD NOT FIND PROBLEM ON PIP"_$C(30) G XDEL
 ;
 ;
 ;Check for latest note
 I $$GET1^DIQ(90680.01,PIPIEN_",",3,"E")]"" S II=II+1,@DATA@(II)="-1^PROBLEMS WITH NOTES CANNOT BE DELETED"_$C(30) G XDEL
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Technical Note
 S VFL("TNOTE")="Problem Deleted From PIP"
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I") I DFN="" S II=II+1,@DATA@(II)="-1^INVALID VISIT"_$C(30) G XDEL
 ;
 ;Mark as deleted
 S RSLT="1"
 S PRUPD(90680.01,PIPIEN_",",2.01)=DUZ
 S PRUPD(90680.01,PIPIEN_",",2.02)=NOW
 S PRUPD(90680.01,PIPIEN_",",2.03)=DCODE
 S PRUPD(90680.01,PIPIEN_",",2.04)=DRSN
 ;
 I $D(PRUPD) D FILE^DIE("","PRUPD","ERROR")
 I $D(ERROR) S RSLT="-1^DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30) G XDEL
 ;
 ;Mark all V PRENATAL entries as deleted
 S DTTM="" F  S DTTM=$O(^AUPNVOB("AE",DFN,PIPIEN,DTTM)) Q:DTTM=""  D
 . NEW VPIEN
 . S VPIEN="" F  S VPIEN=$O(^AUPNVOB("AE",DFN,PIPIEN,DTTM,VPIEN)) Q:VPIEN=""  D
 .. ;
 .. ;Quit if already deleted
 .. Q:($$GET1^DIQ(9000010.43,VPIEN_",",2.01,"I")]"")
 .. ;
 .. Q:$D(PROC(VPIEN))
 .. S PROC(VPIEN)=""
 .. ;
 .. S VPUPD(9000010.43,VPIEN_",",2.01)=DUZ
 .. S VPUPD(9000010.43,VPIEN_",",2.02)=NOW
 .. S VPUPD(9000010.43,VPIEN_",",2.03)=DCODE
 .. S VPUPD(9000010.43,VPIEN_",",2.04)=DRSN
 .. I $D(VPUPD) D FILE^DIE("","VPUPD","ERROR")
 .. I $D(ERROR) S RSLT="-1^V OB DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30)
 ;
 ;Create final V OB visit entry to record the delete
 S VFL("DFN")=DFN
 S VFL("VIEN")=VIEN
 S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I") ;Priority
 S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I") ;Scope
 S VFL("PTEXT")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I") ;Provider Text
 S VFL("STATUS")=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I") ;Status
 S VFL("DEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I") ;Definitive EDD
 S VFL("OEDT")=NOW
 S VFL("OEBY")=DUZ
 S VFL("LMDT")=NOW
 S VFL("LMBY")=DUZ
 S VFL("DEBY")=DUZ
 S VFL("DEDT")=NOW
 S VFL("DECD")=DCODE
 S VFL("DERN")=DRSN
 S VFL("TNOTE",2.01)=""
 S VFL("TNOTE",2.02)=""
 I DCODE]"" S VFL("TNOTE",2.03)=""
 I DRSN]"" S VFL("TNOTE",2.04)=""
 S VFL("TNOTE",1218)=""
 S VFL("TNOTE",1219)=""
 ;
 ;Log V OB entry
 S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^V OB SAVE FAILED"
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XDEL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
