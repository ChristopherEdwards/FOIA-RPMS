BJPNPRL ;GDIT/HS/BEE-Prenatal Care Module Problem List ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
HDR(DATA,DFN) ;EP - BJPN GET PRLIST HDR
 ;
 ;This RPC returns header information pertaining to the prenatal problem list
 ;
 ;Input:  DFN - Patient IEN
 ;
 NEW UID,II,PSTS,RFEDD,PREDD,PKIEN,PLIEN,PENT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 I $G(DFN)="" G DONE
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00001PREGNANCY_STATUS^D00015DEFINITIVE_EDD^D00015PRLIST_EDD^T00010PIP_ENTRIES"_$C(30)
 ;
 ;Currenty Pregnant?
 S PSTS=$$GET1^DIQ(9000017,DFN_",",1101,"I")
 ;
 ;Definitive EDD
 S RFEDD=$$FMTE($$GET1^DIQ(9000017,DFN_",",1311,"I"))
 ;
 ;Problem List EDD - Pull from first non-deleted entry
 S PREDD="",PENT=0
 S PKIEN="" F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:PKIEN=""  D  Q:PREDD]""
 . S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,PKIEN,PLIEN)) Q:PLIEN=""  D  Q:PREDD]""
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,PLIEN_",",2.01,"I") Q:DEL]""
 .. ;
 .. ;Definitive EDD
 .. S PREDD=$$FMTE($$GET1^DIQ(90680.01,PLIEN_",",.09,"I"))
 .. Q:PREDD=""
 .. S PENT=1
 ;
 S II=II+1,@DATA@(II)=PSTS_U_RFEDD_U_PREDD_U_PENT_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
VLOCK(DATA,VIEN) ;EP - BJPN VISIT LOCK CHK
 ;
 ;This RPC returns whether a particular visit has been locked for editing
 ;
 ;Input:  VIEN - Visit IEN
 ;
 NEW UID,II,LOCK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 I $G(VIEN)="" G XVLCK
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00001VISIT_LOCKED"_$C(30)
 ;
 ;Check for visit lock
 S LOCK=$$ISLOCKED^BEHOENCX(VIEN)
 S LOCK=$S(LOCK:1,1:0)
 ;
 S II=II+1,@DATA@(II)=LOCK_$C(30)
 ;
XVLCK S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PIP(DATA,DFN,VIEN,PIPLST) ;EP - BJPN GET PIP
 ;
 ;This RPC returns the patient PIP (PREGNANCY ISSUES AND PROBLEMS)
 ;
 ;Input:  DFN - Patient IEN
 ;       VIEN (optional) - Visit IEN
 ;     PIPLST (optional) - List of specific entries to return ($c(28) separated)
 ;
 NEW UID,II,DEDD,DEL,ILMBY,IPRI,IPRVT,ISCO,ISTS,LMDT,NOTE,PKIEN,PLIEN,POV
 NEW SNTRM,XLMBY,XPRI,XPRVT,XSCO,XSTS,ICD,ICIEN,PPLST,I,PC,PRV,XPRV,ICDINT,SNIEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Set up Header
 S @DATA@(II)="I00010PIPIEN^I00010HIDE_PKIEN^T00175SNOMED_TERM^T00160PROVIDER_TEXT^T00012PRIORITY"
 S @DATA@(II)=@DATA@(II)_"^T00001SCOPE^T00001STATUS^D00015DEFINITIVE_EDD^D00015LM_DT^T00050LM_BY"
 S @DATA@(II)=@DATA@(II)_"^T00120ICD^T00120HIDE_ICD^T00001POV^I00010HIDE_PRV^T00035PRV^T00160CURRENT_NOTE"_$C(30)
 ;
 I $G(DFN)="" G XPIP
 S VIEN=$G(VIEN,"")
 ;
 ;Assemble Specific PIP List
 S PIPLST=$G(PIPLST,"") F I=1:1:$L(PIPLST,$C(28)) S PC=$P(PIPLST,$C(28),I) I PC]"" S PPLST(PC)=""
 ;
 ;Loop through problems for patient
 I $G(DFN)]"" D
 . S PKIEN="" F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:PKIEN=""  D
 .. S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,PKIEN,PLIEN)) Q:PLIEN=""  D
 ... ;
 ... ;Handle specific PIP requests
 ... I $D(PPLST),'$D(PPLST(PLIEN)) Q
 ... ;
 ... ;Skip deletes
 ... S DEL=$$GET1^DIQ(90680.01,PLIEN_",",2.01,"I") Q:DEL]""
 ... ;
 ... ;SNOMED Term
 ... S (SNIEN,SNTRM)=$$GET1^DIQ(90680.01,PLIEN_",",.03,"I") Q:SNTRM=""
 ... S SNTRM=$$GET1^DIQ(90680.02,SNTRM_",",.02,"E") Q:SNTRM=""
 ... ;
 ... ;Provider Text
 ... ;S IPRVT=$$GET1^DIQ(90680.01,PLIEN_",",.05,"I")
 ... S XPRVT=$$GET1^DIQ(90680.01,PLIEN_",",.05,"E")
 ... ;
 ... ;Priority
 ... ;S IPRI=$$GET1^DIQ(90680.01,PLIEN_",",.06,"I")
 ... S XPRI=$$GET1^DIQ(90680.01,PLIEN_",",.06,"E")
 ... ;
 ... ;Scope
 ... ;S ISCO=$$GET1^DIQ(90680.01,PLIEN_",",.07,"I")
 ... S XSCO=$$GET1^DIQ(90680.01,PLIEN_",",.07,"E")
 ... ;
 ... ;Status
 ... ;S ISTS=$$GET1^DIQ(90680.01,PLIEN_",",.08,"I")
 ... S XSTS=$$GET1^DIQ(90680.01,PLIEN_",",.08,"E")
 ... ;
 ... ;Pull the ICD-9
 ... S (ICD,ICDINT)=""
 ... S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,PKIEN,1,ICIEN)) Q:'ICIEN  D
 .... ;
 .... NEW ICD9,ICDTP,DA,IENS,IICD
 .... S DA(1)=PKIEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 .... S IICD=$$GET1^DIQ(90680.21,IENS,.01,"I") Q:IICD=""
 .... S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"E") Q:ICD9=""
 .... S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 .... S ICDINT=ICDINT_$S(ICDINT]"":";",1:"")_IICD
 .... S ICD=ICD_$S(ICD]"":";",1:"")_ICD9
 ... ;
 ... ;Visit POV
 ... S POV="" I $G(VIEN)]"" S POV=$$VPOV^BJPNPUP(VIEN,PLIEN)
 ... ;
 ... ;Definitive EDD
 ... S DEDD=$$FMTE($$GET1^DIQ(90680.01,PLIEN_",",.09,"I"))
 ... ;
 ... ;Last Modified Date
 ... S LMDT=$$FMTE($$GET1^DIQ(90680.01,PLIEN_",",1.03,"I"))
 ... ;
 ... ;Last Modified By
 ... ;S ILMBY=$$GET1^DIQ(90680.01,PLIEN_",",1.04,"I")
 ... S XLMBY=$$FMTE($$GET1^DIQ(90680.01,PLIEN_",",1.04,"E"))
 ... ;
 ... ;PRV fields
 ... S (PRV,XPRV)=""
 ... S PRV=$$PPRV^BJPNPKL(VIEN)
 ... S:PRV]"" XPRV=$$GET1^DIQ(200,PRV_",",.01,"E")
 ... ;
 ... ;Current Note
 ... S NOTE=$$GET1^DIQ(90680.01,PLIEN_",",3,"E")
 ... ;
 ... ;Set up entry
 ... S II=II+1,@DATA@(II)=PLIEN_U_SNIEN_U_SNTRM_U_XPRVT_U_XPRI
 ... S @DATA@(II)=@DATA@(II)_U_XSCO_U_XSTS_U_DEDD_U_LMDT_U_XLMBY
 ... S @DATA@(II)=@DATA@(II)_U_ICD_U_ICDINT_U_POV_U_PRV_U_XPRV_U_NOTE_$C(30)
 ;
XPIP S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
NOTES(DATA,DFN,PR,API) ;EP - BJPN GET PR NOTES
 ;
 ;This RPC returns notes entered for problems on the PIP
 ;
 ;Input:  DFN - Patient IEN
 ;         PR - Problem IEN(s)
 ;        API - 1 if called from an API
 ;
 S DFN=$G(DFN,""),PR=$G(PR,""),API=$G(API)
 ;
 NEW UID,II,PRIEN,SORT,MDT,CNT,PROC,PC,PARY,NEDT,ILMBY
 S UID=$S(API=1:$J,$G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;Assemble Problem List Array
 I $G(PR)]"" F II=1:1:$L(PR,$C(28)) S PC=$P(PR,$C(28),II) I PC]"" S PARY(PC)=""
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010PIPIEN^I00010VFIEN^I00010VNIEN^I00010VIEN^D00030VISIT_DT^T00001NOTE_STATUS"
 S @DATA@(II)=@DATA@(II)_"^D00030LAST_MODIFIED^T00050MODIFIED_BY^T00160NOTE^I00010HIDE_DUZ"_$C(30)
 ;
 ;Verify DFN
 I DFN="" G XNOTES
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.NEDT,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +$G(NEDT)<1 S NEDT=70
 ;
 S PRIEN="" F  S PRIEN=$O(^AUPNVOB("AE",DFN,PRIEN)) Q:PRIEN=""  D
 . ;
 . ;Only include selected problems
 . I $D(PARY),'$D(PARY(PRIEN)) Q
 . ;
 . NEW CNT,MDT
 . S CNT=0
 . S MDT="" F  S MDT=$O(^AUPNVOB("AE",DFN,PRIEN,MDT)) Q:MDT=""  D
 .. ;
 .. NEW IEN
 .. S IEN="" F  S IEN=$O(^AUPNVOB("AE",DFN,PRIEN,MDT,IEN)) Q:IEN=""  D
 ... ;
 ... NEW VISIT,DEDD,BRNG,ERNG,NIEN,X1,X2,X,VDT
 ... ;
 ... ;Quit if already deleted
 ... Q:($$GET1^DIQ(9000010.43,IEN_",",2.01,"I")]"")
 ... ;
 ... ;Check if already processed
 ... Q:$D(PROC(IEN))
 ... S PROC(IEN)=""
 ... ;
 ... ;Pull Visit
 ... S VISIT=$$GET1^DIQ(9000010.43,IEN_",",.03,"I") Q:VISIT=""
 ... S VDT=$$GET1^DIQ(9000010,VISIT_",",.01,"I")
 ... ;
 ... ;Pull Definitive EDD
 ... S DEDD=$$GET1^DIQ(90680.01,PRIEN_",",.09,"I")
 ... S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 ... S X1=DEDD,X2=NEDT D C^%DTC S ERNG=X
 ... ;
 ... S NIEN=0 F  S NIEN=$O(^AUPNVOB(IEN,21,NIEN)) Q:'NIEN  D
 .... NEW DA,IENS,DTTM,NOTE,MDBY,NSTS
 .... S DA(1)=IEN,DA=NIEN,IENS=$$IENS^DILF(.DA)
 .... ;
 .... ;Filter out Deletes
 .... I $$GET1^DIQ(9000010.431,IENS,"2.01","I")]"" Q
 .... ;
 .... S DTTM=$$GET1^DIQ(9000010.431,IENS,".02","I") Q:DTTM=""
 .... S NOTE=$$GET1^DIQ(9000010.431,IENS,".01","E") Q:NOTE=""
 .... S ILMBY=$$GET1^DIQ(9000010.431,IENS,".03","I")
 .... S MDBY=$$GET1^DIQ(9000010.431,IENS,".03","E")
 .... ;
 .... ;Note Status
 .... S NSTS="A"
 .... I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 .... ;
 .... S CNT=CNT+1,SORT(PRIEN,DTTM,CNT)=PRIEN_U_IEN_U_NIEN_U_VISIT_U_$$FMTE(VDT)_U_NSTS_U_$$FMTE(DTTM)_U_MDBY_U_NOTE_U_ILMBY
 ;
 ;Sort - Most recent first
 S PRIEN="" F  S PRIEN=$O(SORT(PRIEN)) Q:PRIEN=""  D
 . S DTTM="" F  S DTTM=$O(SORT(PRIEN,DTTM),-1) Q:DTTM=""  D
 .. S CNT="" F  S CNT=$O(SORT(PRIEN,DTTM,CNT),-1) Q:CNT=""  D
 ... S II=II+1,@DATA@(II)=SORT(PRIEN,DTTM,CNT)_$C(30)
 ;
XNOTES S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ADD(DATA,VIEN,PRIEN,PKLIEN) ;EP - BJPN SET PROB TO PIP
 ;
 ;This RPC adds the prenatal problem to the patient's PIP
 ;
 ;Input:  VIEN - Visit IEN
 ;        PRIEN - Problem IEN
 ;        PKLIEN - Pick List IEN (Master if null)
 ;
 NEW %,UID,II,CONC,DFN,SNO,PRI,SCO,STS,DEDD,OEDT,OEBY,LMDT,LMBY,NOW
 NEW FND,IEN,VFL,PLIEN,RSLT,SNOTRM,TNOTE,DIC,DLAYGO
 ;
 S PKLIEN=$G(PKLIEN)
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00005RESULT^I00010PIPIEN^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^^MISSING VISIT NUMBER"_$C(30) G XADD
 I $G(PRIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PROBLEM IEN"_$C(30) G XADD
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I")
 S VFL("DFN")=DFN
 S VFL("VIEN")=VIEN
 ;
 ;Check for Duplicate Entry
 S FND=0,IEN="" F  S IEN=$O(^BJPNPL("AC",DFN,PRIEN,IEN)) Q:IEN=""  D
 . ;
 . ;Skip Deletes
 . Q:($$GET1^DIQ(90680.01,IEN_",","2.01","I")]"")
 . S FND=1
 I FND=1 S II=II+1,@DATA@(II)="-1^^PATIENT ALREADY HAS PROBLEM IN THEIR PIP"_$C(30) G XADD
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Technical Note
 S VFL("TNOTE")="Added Problem To PIP"
 ;
 ;Concept ID
 S CONC=$$GET1^DIQ(90680.02,PRIEN_",",".01","E")
 S VFL("CONC")=CONC
 ;
 ;Snomed Term
 S SNO=PRIEN
 S VFL("SNO")=SNO
 S VFL("TNOTE",".12")=""
 S SNOTRM=$$GET1^DIQ(90680.02,PRIEN_",",".02","E")
 ;
 ;Priority
 S PRI=""
 S VFL("PRIORITY")=PRI
 ;
 ;Scope
 S SCO="C"
 S VFL("SCOPE")=SCO
 S VFL("TNOTE",".08")=""
 ;
 ;Status
 S STS="A"
 S VFL("STATUS")=STS
 S VFL("TNOTE",".09")=""
 ;
 ;Definitive EDD
 S DEDD=$$GET1^DIQ(9000017,DFN_",",1311,"I")
 S VFL("DEDD")=DEDD
 S VFL("TNOTE",".1")=""
 ;
 ;Original Entered Date/Time
 S OEDT=NOW
 S VFL("OEDT")=OEDT
 S VFL("TNOTE","1216")=""
 ;
 ;Original Entered By
 S OEBY=DUZ
 S VFL("OEBY")=OEBY
 S VFL("TNOTE","1217")=""
 ;
 ;Last Modified Date
 S LMDT=NOW
 S VFL("LMDT")=LMDT
 ;
 ;Last Modified By
 S LMBY=DUZ
 S VFL("LMBY")=LMBY
 ;
 ;Add new entry
 S DIC="^BJPNPL("
 S DLAYGO=90680.01,DIC("P")=DLAYGO,DIC(0)="LOX"
 S X=CONC
 S DIC("DR")=".02////"_DFN_";.03////"_SNO_";.06////"_PRI
 S DIC("DR")=DIC("DR")_";.07////"_SCO_";.08////"_STS_";.09////"_DEDD
 S DIC("DR")=DIC("DR")_";1.01////"_OEDT_";1.02////"_OEBY_";1.03////"_LMDT_";1.04////"_LMBY
 K DO,DD D FILE^DICN
 I Y=-1 S II=II+1,@DATA@(II)="-1^^ADD PROBLEM PROCESS FAILED"_$C(30) G XADD
 S II=II+1,@DATA@(II)="1^"_+Y_"^"_$C(30)
 S PLIEN=+Y
 ;
 ;Log V OB entry
 S RSLT=$$VFILE^BJPNVFIL(PLIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^^V OB SAVE FAILED"
 ;
 ;Update frequency - Pick List
 I $G(PKLIEN)]"" D UFREQ^BJPNPRUT(PRIEN,PKLIEN)
 ;
 ;Update frequency - Master_List
 D UFREQ^BJPNPRUT(PRIEN,"")
 ;
XADD S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
STC(FIL,FLD,VAL) ;EP - Find a value for a set of codes code
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
FMTE(Y) ;EP - Convert Fileman Date/Time to 'MMM DD, CCYY HH:MM:SS' format.
 ;Description
 ;  Receives Date (Y) in FileMan format and returns formatted date.
 ;
 ;Input
 ;  Y - FileMan date/time (i.e. 3051024.123456).
 ;
 ;Output
 ;  Date/Time in External format (i.e. OCT 24,2005 12:34:56).
 ;
 NEW DATM,XX,I,V
 S DATM=$TR($$FMTE^DILIBF(Y,"5U"),"@"," ")
 I DATM["24:00" S DATM=$P(DATM," ",1,2)_" 00:00"
 S XX="" F I=1:1:$L(DATM) S V=$E(DATM,I,I),XX=XX_V I V="," S XX=XX_" "
 S DATM=XX
 Q DATM
 ;
VNOTES(DATA,PIPIEN,VIEN) ;EP - BJPN CHK FOR VST NOTES
 ;
 ;This RPC returns whether the given problem has any notes on file for the
 ;provided visit
 ;
 ;Input:
 ; PIPIEN - Pointer to Prenatal Problem file entry
 ; VIEN - The visit IEN
 ;
 ;Output:
 ; 1 - Notes are present for the problem for the visit
 ; 0 - No notes are present
 ;
 S PIPIEN=$G(PIPIEN,""),VIEN=$G(VIEN,"")
 I PIPIEN="" S BMXSEC="INVALID PIP VALUE" Q
 I VIEN=""  S BMXSEC="INVALID VIEN" Q
 ;
 NEW UID,II,DFN,CNT,FOUND
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;S TMP=$NA(^TMP("BJPNPDET",UID))
 ;K @TMP
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Header
 S @DATA@(II)="T00001NOTES_PRESENT"_$C(30)
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",.02,"I") I DFN="" S BMXSEC="INVALID PIPIEN/DFN" Q
 ;
 D NOTES^BJPNPRL("",DFN,PIPIEN,1)
 ;
 ;Loop through and check each note for visit
 S (FOUND,CNT)=0 F  S CNT=$O(^TMP("BJPNPRL",$J,CNT)) Q:CNT=""  D  Q:FOUND
 . NEW NODE,NVIEN
 . S NODE=^TMP("BJPNPRL",$J,CNT)
 . S NVIEN=$P(NODE,U,4) I VIEN'=NVIEN Q
 . S FOUND=1
 S II=II+1,@DATA@(II)=FOUND_$C(30)
 ;
 ;Cleanup
 K ^TMP("BJPNPRL",$J)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
