BJPNPRL ;GDIT/HS/BEE-Prenatal Care Module Problem List ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**3,7,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
HDR(DATA,DFN) ;EP - BJPN GET PRLIST HDR
 ;
 ;This RPC returns header information pertaining to the prenatal problem list
 ;
 ;Input:  DFN - Patient IEN
 ;
 NEW UID,II,PSTS,RFEDD,PREDD,PRBIEN,PENT,HPIP
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
 S @DATA@(II)="T00001PREGNANCY_STATUS^D00015DEFINITIVE_EDD^D00015PRLIST_EDD^T00010PIP_ENTRIES^T00001HAS_PIP"_$C(30)
 ;
 ;Currenty Pregnant?
 S PSTS=$$GET1^DIQ(9000017,DFN_",",1101,"I")
 ;
 ;Definitive EDD
 S RFEDD=$$FMTE($$GET1^DIQ(9000017,DFN_",",1311,"I"))
 ;
 ;Problem List EDD - Pull from first non-deleted entry
 S PREDD="",PENT=0,HPIP=""
 S PRBIEN="" F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D  Q:PREDD]""
 . NEW BPIEN
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D  Q:PREDD]""
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") Q:DEL]""
 .. ;
 .. ;Has PIP Entry
 .. S HPIP="Y"
 .. ;
 .. ;Definitive EDD
 .. S PREDD=$$FMTE($$GET1^DIQ(90680.01,BPIEN_",",.09,"I"))
 .. Q:PREDD=""
 .. S PENT=1
 ;
 S II=II+1,@DATA@(II)=PSTS_U_RFEDD_U_PREDD_U_PENT_U_HPIP_$C(30)
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
 NEW UID,II,LOCK,ITYPE
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
 S @DATA@(II)="I00001VISIT_LOCKED^T00001INPATIENT"_$C(30)
 ;
 ;Check for visit lock
 S LOCK=$$ISLOCKED^BEHOENCX(VIEN)
 S LOCK=$S(LOCK:1,1:0)
 ;
 ;Get the visit type
 S ITYPE=$$GET1^DIQ(9000010,VIEN_",",.07,"I")
 S ITYPE=$S(ITYPE="H":"Y",1:"")
 ;
 S II=II+1,@DATA@(II)=LOCK_U_ITYPE_$C(30)
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
TST ;
 D ADD("",2087425,6257016,"",28,"272741003|24028007")
 Q
 ;
ADD(DATA,VIEN,DESCID,PRBIEN,PKIEN,LAT,PIPIEN) ;EP - BJPN SET PROB TO PIP
 ;
 ;This RPC adds the prenatal problem to the patient's PIP
 ;
 ;Input:  VIEN - Visit IEN
 ;        DESCID - The Description Id of the Concept to Add
 ;        PRBIEN - The Pointer to IPL - null if new IPL entry
 ;         PKIEN - Pointer to 90362.34 entry
 ;           LAT - Internal attribute|laterality value
 ;        PIPIEN - The PIPIEN - if there override current problem and do not save new PIP entry
 ;
 NEW %,UID,II,CONCID,SMDDATA,ICD,P,B,C9,C8,PTEXT,ONSDT,ISTS,CLASS,NEXT,IPRI
 NEW A,Q,XARRAY,IPOV,RESULT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S C9=$C(29)
 S C8=$C(28)
 ;
 S @DATA@(II)="T00005RESULT^I00010PIPIEN^T00150ERROR_MESSAGE^I00010PRBIEN"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^^MISSING VISIT NUMBER"_$C(30) G XADD
 I $G(DESCID)="" S II=II+1,@DATA@(II)="-1^MISSING DESCRIPTION ID"_$C(30) G XADD
 S PRBIEN=$G(PRBIEN) S:PRBIEN=0 PRBIEN=""
 S PIPIEN=$G(PIPIEN) S:PIPIEN=0 PIPIEN=""
 S LAT=$G(LAT)
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I")
 ;
 ;Get current date/time
 D NOW^%DTC
 ;
 ;Concept ID
 S SMDDATA=$$DESC^BSTSAPI(DESCID_"^^1")
 S CONCID=$P(SMDDATA,U)
 S ICD=$P(SMDDATA,U,3)
 ;
 ;Get current IPL problem info (if not new)
 ;Array(n)="P" [1] ^ Problem Ien [2] ^ SNOMED CONCEPT ID [3] ^ SNOMED DESC ID[4] ^Number code [5] ^ Status [6]^
 ;             Onset [7] ^ Prov Narrative [8] ^ ICD [9] ^ Priority [10] ^ Class [11] ^ PIP [12] ^ Additional ICD [13] ^
 ;             inpt DX [14] ^Outpt DX ^^^^^Laterality [20]
 ;Array(n)="A" [1] ^ Classification [2] ^ Control [3] ^ V asthma IEN [4]
 ;Array(n)= "Q" [1] ^ TYPE [2] ^ IEN [3] ^ SNOMED [4] ^ Text [5]
 ;
 ;Set fields to default values
 S (A,PTEXT,ONSDT,CLASS,IPRI,IPOV)="",ISTS="Episodic"
 ;
 ;BJPN*2.0*3;CR#03192;Honor Pick List Status
 I +$G(PKIEN)>0,+$G(CONCID)>0 D
 . NEW PKEN,STS
 . S PKEN=$O(^BGOSNOPR(PKIEN,1,"B",CONCID,"")) Q:PKEN=""
 . ;Cannot use FileMan to retrieve the information because of a bug in the code in the EHR Pick List
 . ;save logic that is saving the values incorrectly
 . S STS=$P($G(^BGOSNOPR(PKIEN,1,PKEN,0)),U,6) Q:STS=""
 . I STS="P" S CLASS="P"
 . ;
 . ;Custom code to account for EHR bug
 . S ISTS=$S(STS="A":"Chronic",STS="Sub-acute":"Sub-acute",STS="I":"Inactive",STS="E":"Episodic",STS="O":"Social/Environmental",STS="P":"Inactive",STS="R":"Admin",1:ISTS)
 ;
 ;Next problem number
 D
 . NEW RET
 . D NEXTID^BGOPROB(.RET,DFN)
 . S NEXT=+$P(RET,"-",2)
 ;
 ;If already on IPL, pull information from IPL entry and possibly override what came in
 I +PRBIEN D
 . NEW BGO,API,XDESC,XCONC,PNARR,XICD,XSTS,XCLASS,XNEXT,TMP
 . D COMP^BJPNUTIL(DFN,UID,VIEN,PRBIEN)
 . S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 . ;
 . ;
 . ;Retrieve the entry from the API results
 . S BGO=$O(@TMP@("P",PRBIEN,"")) I BGO="" Q
 . S API=$G(@TMP@("P",PRBIEN,BGO)) I API="" Q
 . ;
 . ;DESC ID - Override what came in
 . I PIPIEN="" D  I (XCONC="")!(XDESC="") Q
 .. S XDESC=$P(API,U,4) Q:XDESC=""
 .. S XCONC=$P(API,U,3) Q:XCONC=""
 .. S DESCID=XDESC,CONCID=XCONC
 .. ;
 .. ;Laterality
 .. S LAT=$P(API,U,20)
 . ;
 . ;Provider Text
 . S PNARR=$P(API,U,8)
 . S PTEXT=$P(PNARR," | ",2)
 . ;
 . ;Mapped ICD
 . S XICD=$P(API,U,9) S:XICD]"" ICD=XICD
 . ;
 . ;Get Onset Date
 . S ONSDT=$P(API,U,7) S:ONSDT]"" ONSDT=$$DATE^BJPNPRUT($P(ONSDT," "))
 . ;
 . ;Get IPL Status
 . S XSTS=$P(API,U,6),XSTS=$S(XSTS="CHRONIC":"Chronic",XSTS="INACTIVE":"Inactive",XSTS="DELETED":"Deleted",XSTS="SUB-ACUTE":"Sub-acute",XSTS="SOCIAL":"Social/Environmental",XSTS="EPISODIC":"Episodic",XSTS="ROUTINE/ADMIN":"Routine/Admin",1:"")
 . S:XSTS]"" ISTS=XSTS
 . ;
 . ;Get Class
 . S XCLASS=$P(API,U,11) S:XCLASS]"" CLASS=XCLASS
 . ;
 . ;Get number code
 . S XNEXT=$P($P(API,U,5),"-",2) S:XNEXT]"" NEXT=XNEXT
 . ;
 . ;IPL Priority
 . S IPRI=$P(API,U,10)
 . ;
 . ;Inpatient POV
 . S IPOV=$P(API,U,14)
 . ;
 . ;Now get the Asthma Information
 . ;
 . ;Retrieve the entry from the API results
 . S BGO=$O(@TMP@("A",PRBIEN,""))
 . I BGO]"" S API=$G(@TMP@("A",PRBIEN,BGO,0)) I API]"" S A=$TR(API,"^",C9)
 . ;
 . ;Now get the qualifiers
 . S BGO="" F  S BGO=$O(@TMP@("Q",PRBIEN,BGO)) Q:BGO=""  D
 .. S API=$G(@TMP@("Q",PRBIEN,BGO,0)) Q:API=""
 .. S Q(BGO)="Q"_C9_$P(API,U,2)_C9_$P(API,U,3)_C9_$P(API,U,4)_C9_C9_C9_"0"
 ;
 ;Input parameters:
 ;     DFN - Patient IEN
 ;  PRBIEN - IEN of IPL, null if new
 ;  PIPIEN - IEN of PIP, null if new
 ;    VIEN - Visit IEN
 ;  IARRAY - Array of problem information - Records delimited by $c(28), fields by $c(29)
 ;                                        - (R) Required, (O) Optional
 ;Problem (IPL) entry (Required):
 ;?P? [1] 29 Concept Id (R) [2] 29 Description Id (R) [3] 29 Provider Text (O) [4] 29 
 ;Mapped ICD (R) [5] 29 Location (null for new) [6] 29 Date of Onset [7] 29
 ;IPL Status (R) [8] 29 Class [9] 29 Problem # [10] 29 
 ;Priority [11] 29 Inpatient_POV value (O) [12] Attribute|Laterality
 ;
 ;Asthma
 ;"A"[1] 29 Classification [2] 29 Control (pass through value) [3] 29 V asthma IEN (pass through value) [4]
 ;
 ;Prenatal (PIP) entry (Required):
 ;?B? [1] 29 PIP Status (R) [2] 29 PIP Scope (R) [3] 29 PIP Priority (O) [4] 29 Definitive EDD (O) [5]
 ;
 ;Qualifier Entry or Entries (Optional):
 ;?Q? [1] 29 TYPE (S/C) (R) [2] 29 IEN (present for edits, null for new) (O) [3] 29 Concept Id of Entry (R) [4] 29
 ;User (null for new) [5] 29 Date/time (null for new) [6] 29 Delete flag (1 ? Delete, otherwise ? 0) (R) [7]
 ;
 ;Assemble the IPL entry
 S P="P"_C9_CONCID_C9_DESCID_C9_PTEXT_C9_ICD_C9_C9_ONSDT_C9_ISTS_C9_CLASS_C9_NEXT_C9_IPRI_C9_IPOV_C9_LAT
 ;
 ;Set up the 'B' PIP entry
 S B="B"_C9_"A"_C9_"C"_C9_C9_$$GET1^DIQ(9000017,DFN_",",1311,"I")
 ;
 ;Assemble the array
 ;
 ;IPL and PIP sections
 S XARRAY=P_C8_B
 ;
 ;Asthma
 S:A]"" XARRAY=XARRAY_C8_A
 ;
 ;Qualifiers
 S Q="" F  S Q=$O(Q(Q)) Q:Q=""  S XARRAY=XARRAY_C8_Q(Q)
 ;
 ;Add the problem
 D SET^BJPNPSET("",DFN,PRBIEN,PIPIEN,VIEN,XARRAY)
 ;
 ;Get the result
 S RESULT=$P($G(^TMP("BJPNPSET",UID,1)),$C(30))
 ;
 ;Log the result
 S II=II+1,@DATA@(II)=$P(RESULT,U)_U_$P(RESULT,U,3)_U_$P(RESULT,U,4)_U_$P(RESULT,U,2)_$C(30)
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
FMTE(Y,FORMAT) ;EP - Convert Fileman Date/Time to 'MMM DD, CCYY HH:MM:SS' format.
 ;Description
 ;  Receives Date (Y) in FileMan format and returns formatted date.
 ;
 ;Input
 ;  Y - FileMan date/time (i.e. 3051024.123456).
 ;
 ;Output
 ;  Date/Time in External format (i.e. OCT 24,2005 12:34:56).
 ;
 NEW DATM,XX,I,V,X
 I $G(FORMAT)="" D
 .S DATM=$TR($$FMTE^DILIBF(Y,"5U"),"@"," ")
 .I DATM["24:00" S DATM=$P(DATM," ",1,2)_" 00:00"
 .S XX="" F I=1:1:$L(DATM) S V=$E(DATM,I,I),XX=XX_V I V="," S XX=XX_" "
 .S DATM=XX
 ;
 I $G(FORMAT)]"" D
 .S DATM=$$FMTE^XLFDT(Y,FORMAT)
 ;
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
 ;D NOTES^BJPNPRL("",DFN,PIPIEN,1)
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
 ;
NOTES(DATA,DFN,PR,API) ;EP - BJPN GET PR NOTES
 ;Tag no longer used
 Q
