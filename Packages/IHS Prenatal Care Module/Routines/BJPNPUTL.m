BJPNPUTL ;GDIT/HS/BEE-Prenatal Care Module Utility Calls ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
DPOV(DATA,VIEN,PIPIEN,DNOTE) ;EP - BJPN DELETE POV
 ;
 ;This RPC removes the V POV entry for the SNOMED problem
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ; PIPIEN - Pointer to Prenatal Problem file entry
 ; DNOTE - 1 - Do not delete notes (SNOMED code change)
 ;
 NEW UID,II,POV,PKIEN,ICIEN,ICD,CD,NOW,%,DFN,VFL,CONC,SNO,BJPNUPD,ERROR
 NEW PTEXT,RSLT
 S DNOTE=$G(DNOTE,"")
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XDPOV
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PIPIEN"_$C(30) G XDPOV
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I")
 S VFL("DFN")=DFN
 S VFL("VIEN")=VIEN
 ;
 ;Pull Pick List entry
 S PKIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I") I PKIEN="" S II=II+1,@DATA@(II)="-1^INVALID PKIEN"_$C(30) G XDPOV
 ;
 ;Pointer to 90680.02
 S CONC=$$GET1^DIQ(90680.02,PKIEN_",",".01","E")
 S VFL("CONC")=CONC
 ;
 ;Snomed Term
 S SNO=PKIEN
 S VFL("SNO")=SNO
 ;
 ;Priority
 S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I")
 ;
 ;Scope
 S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 ;
 ;Status
 S VFL("STATUS")=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 ;
 ;Definitive EDD
 S VFL("DEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 ;
 ;Original Entered Date/Time
 S VFL("OEDT")=$$GET1^DIQ(90680.01,PIPIEN_",",1.01,"I")
 ;
 ;Original Entered By
 S VFL("OEBY")=$$GET1^DIQ(90680.01,PIPIEN_",",1.02,"I")
 ;
 ;Last Modified Date
 S LMDT=NOW
 S VFL("LMDT")=LMDT
 S VFL("TNOTE",1218)=""
 S BJPNUPD(90680.01,PIPIEN_",",1.03)=LMDT
 ;
 ;Last Modified By
 S LMBY=DUZ
 S VFL("LMBY")=LMBY
 S VFL("TNOTE",1219)=""
 S BJPNUPD(90680.01,PIPIEN_",",1.04)=LMBY
 ;
 ;Set as POV
 S VFL("POV")=1
 S VFL("TNOTE",.05)=""
 ;
 ;Technical Note
 S VFL("TNOTE")="Removed Problem As POV For Visit"
 ;
 ;Pull the ICD-9(s)
 S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,PKIEN,1,ICIEN)) Q:'ICIEN  D
 . ;
 . NEW ICD9,ICDTP,DA,IENS
 . S DA(1)=PKIEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 . S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"I") Q:ICD9=""
 . S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 . S ICD(ICD9)=$$GET1^DIQ(90680.21,IENS,.01,"E")
 ;
 ;Check for .9999
 I '$D(ICD) D
 . NEW DIC,X,Y
 . S DIC="^ICD9(",DIC(0)="XMO",X=".9999" D ^DIC I +Y<0 Q
 . S ICD(+Y)=".9999"
 ;
 S POV=""
 S ICIEN="" F  S ICIEN=$O(^AUPNVPOV("AD",VIEN,ICIEN)) Q:ICIEN=""  D
 . NEW ICDCD,VPNARR,SNOMED
 . S VPNARR=$P($$GET1^DIQ(9000010.07,ICIEN_",",.04,"E"),"|")
 . S SNOMED=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I") Q:SNOMED=""
 . S SNOMED=$$GET1^DIQ(90680.02,SNOMED_",",.02,"E") Q:SNOMED=""
 . ;
 . ;Check for normal code match
 . S ICDCD=$$GET1^DIQ(9000010.07,ICIEN_",",.01,"I") Q:ICDCD=""
 . I $D(ICD(ICDCD)),SNOMED=VPNARR S POV=POV_$S(POV]"":";",1:"")_ICIEN Q
 . ;
 . Q
 ;
 F CD=1:1:$L(POV,";") I $P(POV,";",CD)]"" D
 . D DEL^BGOVPOV(.RET,$P(POV,";",CD))
 . I +$G(RET)<0 S II=II+1,@DATA@(II)="-1^"_$P($G(RET),U,2)_$C(30) Q
 . S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
 ;Provider Text
 S PTEXT=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I")
 S VFL("PTEXT")=PTEXT
 ;
 ;Update fields
 I $D(BJPNUPD) D FILE^DIE("","BJPNUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^REMOVE AS POV PROCESS FAILED"_$C(30) G XDPOV
 ;
 ;Log V OB entry
 S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^V OB SAVE FAILED"
 ;
 ;Remove associated notes (for non-SNOMED Code change)
 NEW VFIEN
 I '$G(DNOTE) S VFIEN="" F  S VFIEN=$O(^AUPNVOB("AD",VIEN,VFIEN)) Q:VFIEN=""  D
 . NEW VNIEN,PIEN
 . ;
 . ;Delete only notes for that PIPIEN
 . S PIEN=$$GET1^DIQ(9000010.43,VFIEN_",",.01,"I")
 . I PIPIEN'=PIEN Q
 . ;
 . ;Locate notes
 . S VNIEN=0 F  S VNIEN=$O(^AUPNVOB(VFIEN,21,VNIEN)) Q:'VNIEN  D
 .. NEW DCODE,DRSN,DA,IENS
 .. S DA(1)=VFIEN,DA=VNIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Skip already deleted notes
 .. I $$GET1^DIQ(9000010.431,IENS,"2.01","I")]"" Q
 .. ;
 .. S DCODE="O",DRSN="Removed Problem as POV"
 .. N DATA ;Needed as RPC uses DATA
 .. D DEL^BJPNPUP("",VIEN,VFIEN,VNIEN,DCODE,DRSN)
 ;
XDPOV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PRV(DATA,VIEN,PRVIEN,PRMSEC) ;EP - BJPN SET PROVIDER
 ;
 ;This RPC sets a V PROVIDER entry for the visit
 ;and also possibly changes the primary provider
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ; PRVIEN - Provider IEN
 ; PRMSEC - Primary/Secondary Provider (P/S)
 ;
 NEW UID,II,IN,DFN,RET
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 S PRMSEC=$G(PRMSEC,"")
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ; Set primary provider
 ;  INP = Visit IEN [1] ^ Patient IEN [2] ^ Provider IEN [3] ^ Primary/Secondary (P/S) [4] ^
    ;        Force Conversion to Primary (Y/N) [5]
 ;
 ;Input verification
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XPRV
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 I DFN="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XPRV
 I $$GET1^DIQ(200,PRVIEN_",",.01,"I")="" S II=II+1,@DATA@(II)="-1^INVALID PROVIDER"_$C(30) G XPRV
 ;
 ;Make call to API
 S IN=VIEN_U_DFN_U_PRVIEN_U_PRMSEC
 D SETVPRV^BGOVPRV(.RET,IN)
 ;
 ;Override primary if necessary
 I +RET<0,PRMSEC="P" D
 . S IN=IN_U_1
 . D SETVPRV^BGOVPRV(.RET,IN)
 ;
 I +RET<0 S II=II+1,@DATA@(II)="-1^PRV SAVE UNSUCCESSFUL"_$C(30) G XPRV
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XPRV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CLOSE(DATA,VIEN) ;EP - BJPN CLOSE PIP
 ;
 ;This RPC makes each problem on the patient's PIP inactive
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ;
 NEW UID,II,DFN,PKIEN,PIPIEN,NOW,%,ERROR
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input verification
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XPRV
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 I DFN="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XPRV
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Loop through each entry on the PIP
 S PKIEN="" F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:'PKIEN  D
 . S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("AC",DFN,PKIEN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 .. ;
 .. NEW VFL,BJPNUP,STS,TNOTE,LMDT,LMBY,RSLT
 .. ;
 .. ;Skip deletes
 .. I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 .. ;
 .. ;Status
 .. S STS="I"
 .. S VFL("STATUS")=STS
 .. S BJPNUP(90680.01,PIPIEN_",",.08)=STS
 .. ;
 .. ;Last Modified Date
 .. S LMDT=NOW
 .. S VFL("LMDT")=LMDT
 .. S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 .. ;
 .. ;Last Modified By
 .. S LMBY=DUZ
 .. S VFL("LMBY")=LMBY
 .. S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 .. ;
 .. ;Update entry
 .. I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 .. I $D(ERROR) S II=II+1,@DATA@(II)="-1^^PIP CLOSE FAILED - PIPIEN:"_PIPIEN_$C(30)
 .. ;
 .. ;Create V OB entry to record the close
 .. S VFL("DFN")=DFN
 .. S VFL("VIEN")=VIEN
 .. S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I") ;Priority
 .. S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I") ;Scope
 .. S VFL("PTEXT")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I") ;Provider Text
 .. S VFL("DEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I") ;Definitive EDD
 .. S VFL("OEDT")=$$GET1^DIQ(90680.01,PIPIEN_",",1.01,"I") ;OEDT
 .. S VFL("OEBY")=$$GET1^DIQ(90680.01,PIPIEN_",",1.02,"I") ;OEBY
 .. S VFL("LMDT")=NOW
 .. S VFL("LMBY")=DUZ
 .. ;
 .. ;2200 Technical Comment
 .. S VFL("TNOTE")="PIP Closed - Status Set to Inactive"
 .. ;
 .. ;Log V OB entry
 .. S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^PIP CLOSE FAILED - V OB SAVE FAILED - PIPIE:"_PIPIEN_$C(30),ERROR=1
 ;
 ;Record success
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XCLOSE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
OPEN(DATA,VIEN) ;EP - BJPN OPEN PIP
 ;
 ;This RPC makes each 'All Pregnancies' problems on the patient's PIP active
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ;
 NEW UID,II,DFN,PKIEN,PIPIEN,NOW,%,ERROR
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input verification
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XPRV
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 I DFN="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XPRV
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Loop through each entry on the PIP
 S PKIEN="" F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:'PKIEN  D
 . S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("AC",DFN,PKIEN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 .. ;
 .. NEW VFL,BJPNUP,STS,TNOTE,LMDT,LMBY,RSLT
 .. ;
 .. ;Skip deletes
 .. I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 .. ;
 .. ;Include only 'All Pregnancies'
 .. I $$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")'="A" Q
 .. ;
 .. ;Status
 .. S STS="A"
 .. S VFL("STATUS")=STS
 .. S BJPNUP(90680.01,PIPIEN_",",.08)=STS
 .. ;
 .. ;Last Modified Date
 .. S LMDT=NOW
 .. S VFL("LMDT")=LMDT
 .. S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 .. ;
 .. ;Last Modified By
 .. S LMBY=DUZ
 .. S VFL("LMBY")=LMBY
 .. S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 .. ;
 .. ;Update entry
 .. I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 .. I $D(ERROR) S II=II+1,@DATA@(II)="-1^^PIP OPEN FAILED - PIPIEN:"_PIPIEN_$C(30)
 .. ;
 .. ;Create V OB entry to record the open
 .. S VFL("DFN")=DFN
 .. S VFL("VIEN")=VIEN
 .. S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I") ;Priority
 .. S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I") ;Scope
 .. S VFL("PTEXT")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I") ;Provider Text
 .. S VFL("DEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I") ;Definitive EDD
 .. S VFL("OEDT")=NOW
 .. S VFL("OEBY")=DUZ
 .. S VFL("LMDT")=NOW
 .. S VFL("LMBY")=DUZ
 .. ;
 .. ;2200 Technical Comment
 .. S VFL("TNOTE")="PIP Opened - Status set to Active"
 .. ;
 .. ;Log V OB entry
 .. S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^PIP CLOSE FAILED - V OB SAVE FAILED - PIPIE:"_PIPIEN_$C(30),ERROR=1
 ;
 ;Record success
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XOPEN S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEDD(DATA,VIEN) ;EP - BJPN SET DEDD
 ;
 ;This RPC updates the definitive EDD for each problem
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ;
 NEW UID,II,DFN,PKIEN,PIPIEN,NOW,%,ERROR,DEDD
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input verification
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XPRV
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 I DFN="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XPRV
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Pull DEDD
 S DEDD=$$GET1^DIQ(9000017,DFN_",",1311,"I") S:DEDD="" DEDD="@"
 ;
 ;Loop through each entry on the PIP
 S PKIEN="" F  S PKIEN=$O(^BJPNPL("AC",DFN,PKIEN)) Q:'PKIEN  D
 . S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("AC",DFN,PKIEN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 .. ;
 .. NEW VFL,BJPNUP,STS,TNOTE,LMDT,LMBY,RSLT
 .. ;
 .. ;Skip deletes
 .. I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 .. ;
 .. ;DEDD
 .. S VFL("TNOTE")="Definitive EDD Updated"
 .. S VFL("DEDD")=DEDD
 .. S VFL("TNOTE",.1)=""
 .. S BJPNUP(90680.01,PIPIEN_",",.09)=DEDD
 .. ;
 .. ;Last Modified Date
 .. S LMDT=NOW
 .. S VFL("LMDT")=LMDT
 .. S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 .. ;
 .. ;Last Modified By
 .. S LMBY=DUZ
 .. S VFL("LMBY")=LMBY
 .. S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 .. ;
 .. ;Update entry
 .. I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 .. I $D(ERROR) S II=II+1,@DATA@(II)="-1^^UPDATE DEDD FAILED - PIPIEN:"_PIPIEN_$C(30)
 .. ;
 .. ;Create V OB entry to record the close
 .. S VFL("DFN")=DFN
 .. S VFL("VIEN")=VIEN
 .. S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I") ;Priority
 .. S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I") ;Scope
 .. S VFL("PTEXT")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I") ;Provider Text
 .. S VFL("OEDT")=$$GET1^DIQ(90680.01,PIPIEN_",",1.01,"I") ;OEDT
 .. S VFL("OEBY")=$$GET1^DIQ(90680.01,PIPIEN_",",1.02,"I") ;OEBY
 .. S VFL("LMDT")=NOW
 .. S VFL("LMBY")=DUZ
 .. ;
 .. ;Log V OB entry
 .. S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^DEDD UPDATE FAILED - V OB SAVE FAILED - PIPIE:"_PIPIEN_$C(30),ERROR=1
 ;
 ;Record success
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XDEDD S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;
PPRV(DATA,VIEN) ;EP - BJPN GET PRIMARY PROVIDER
 ;
 ;This RPC returns the primary provider for a visit
 ;
 ;Input:
 ; VIEN - Visit Pointer
 ;
 NEW UID,II,IN,PRV,XPRV
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPUTL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPUTL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="I00010HIDE_PRV^T00035PROVIDER"_$C(30)
 ;
 ;Input verification
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VIEN"_$C(30) G XPRV
 ;
 ;PRV fields
 S (PRV,XPRV)=""
 S PRV=$$PPRV^BJPNPKL(VIEN)
 S:PRV]"" XPRV=$$GET1^DIQ(200,PRV_",",.01,"E")
 ;
 S II=II+1,@DATA@(II)=PRV_U_XPRV_$C(30)
 ;
XPPRV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
