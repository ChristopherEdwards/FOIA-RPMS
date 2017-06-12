BJPNPUTL ;GDIT/HS/BEE-Prenatal Care Module Utility Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**1,2,6,7,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
DPOV(DATA,POVIEN,PRBIEN) ;EP - BJPN DELETE POV
 ;
 ;This RPC removes the V POV entry for the SNOMED problem and the PROBLEM 1401 entry
 ;
 ;Input:
 ; POVIEN - The pointer(s) to the V POV entry or entries - POV_IEN - $C(29) delimiter
 ; PRBIEN - The pointer to the IPL - PRBIEN
 ;
 NEW UID,II,RET,RESULT,PIEN,PPIECE
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
 I $G(POVIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VPOVIEN"_$C(30) G XDPOV
 I $G(PRBIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PRBIEN"_$C(30) G XDPOV
 ;
 ;Make the API call for each IEN
 F PPIECE=1:1:$L(POVIEN,$C(29)) S PIEN=$P(POVIEN,$C(29),PPIECE) I PIEN]"" D  I +$P(RET,U)<0 Q
 . D DEL^BGOVPOV(.RET,PIEN,PRBIEN)
 ;
 ;Set up return string
 I +$P(RET,U)<0 S RESULT="-1^"_$P(RET,U,2)
 E  S RESULT="1^"
 S II=II+1,@DATA@(II)=RESULT_$C(30)
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
 NEW UID,II,DFN,PIPIEN,NOW,%,ERROR,TMP
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
 ;Call EHR API and format results into usable data
 D COMP^BJPNUTIL(DFN,UID,VIEN)
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 ;
 ;Loop through each entry on the PIP
 S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("D",DFN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 . ;
 . NEW BJPNUP,STS,LMDT,LMBY,RSLT,PRBIEN,CSTS,ISTS,BGO,BSCO
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 . ;
 . ;Status
 . S STS="I"
 . S CSTS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 . I CSTS'="I" S BJPNUP(90680.01,PIPIEN_",",.08)=STS
 . ;
 . ;BJPN*2.0*8;Make Scope prior pregnancy
 . S BSCO=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 . I BSCO'="A" S BJPNUP(90680.01,PIPIEN_",",.07)="A"
 . ;
 . ;Last Modified Date
 . S LMDT=NOW
 . S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 . ;
 . ;Last Modified By
 . S LMBY=DUZ
 . S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 . ;
 . ;Clear Definitive EDD
 . S BJPNUP(90680.01,PIPIEN_",",.09)="@"
 . ;
 . ;Update IPL values
 . S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I")
 . I PRBIEN]"" D  I $D(ERROR) G XCLOSE
 .. NEW PIP,IPLUPD
 .. ;
 .. ;Get the current PIP value - If set, need to clear out
 .. S IPLUPD(9000011,PRBIEN_",",.03)=NOW
 .. S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 .. S PIP=$$GET1^DIQ(9000011,PRBIEN_",",.19,"I")
 .. I PIP D
 ... NEW DA,IENS,DIC,DLAYGO,X,Y
 ... S IPLUPD(9000011,PRBIEN_",",.19)="@"  ;Clear the PIP value
 ... ;
 ... ;Add the User/PIP value history entry
 ... ;
 ... S DIC="^BJPNPL("_PIPIEN_",5,"
 ... S DA(1)=PIPIEN
 ... S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 ... S X=NOW
 ... K DO,DD D FILE^DICN
 ... I +Y=-1 S ERROR="Could not add PIP column history" Q
 ... S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 ... S BJPNUP(90680.015,IENS,".02")="0"
 ... S BJPNUP(90680.015,IENS,".03")=DUZ
 .. I '$D(ERROR) D FILE^DIE("","IPLUPD","ERROR")
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1^^PIP CLOSE IPL UPDATE FAILED - PIPIEN:"_PIPIEN_$C(30)
 . ;
 . ;Update PIP entry
 . I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1^^PIP CLOSE FAILED - PIPIEN:"_PIPIEN_$C(30)
 . ;
 . ;For IPL Episodic problems, inactivate care plans/goals
 . Q:PRBIEN=""
 . I $$GET1^DIQ(9000011,PRBIEN_",",.12,"I")'="E" Q
 . ;
 . ;Loop through Care Plans
 . S BGO="" F  S BGO=$O(@TMP@("C",PRBIEN,BGO)) Q:BGO=""  D
 .. ;
 .. NEW APIRES,IEN,RET
 .. ;
 .. S APIRES=$G(@TMP@("C",PRBIEN,BGO,0)) Q:APIRES=""
 .. ;
 .. ;Skip Inactive Care Plans
 .. I $P(APIRES,U,6)'="A" Q
 .. ;
 .. ;Get the pointer to 9000092
 .. S IEN=$P(APIRES,U,2) Q:IEN=""
 .. D UPSTAT^BGOCPLAN(.RET,IEN,PRBIEN,"I","Closed PIP - Inactivated because IPL status is Episodic")
 .. I $P($G(RET),U)="-1" S ERROR=1,II=II+1,@DATA@(II)="-1^^Could not make care plan inactive"_$C(30)
 . I $D(ERROR) Q
 . ;
 . ;Loop through Care Plans
 . S BGO="" F  S BGO=$O(@TMP@("G",PRBIEN,BGO)) Q:BGO=""  D
 .. ;
 .. NEW APIRES,IEN,RET
 .. ;
 .. S APIRES=$G(@TMP@("G",PRBIEN,BGO,0)) Q:APIRES=""
 .. ;
 .. ;Skip Inactive Care Plans
 .. I $P(APIRES,U,6)'="A" Q
 .. ;
 .. ;Get the pointer to 9000092
 .. S IEN=$P(APIRES,U,2) Q:IEN=""
 .. D UPSTAT^BGOCPLAN(.RET,IEN,PRBIEN,"I","Closed PIP - Inactivated because IPL status is Episodic")
 .. I $P($G(RET),U)="-1" S II=II+1,@DATA@(II)="-1^^Could not make goal inactive"_$C(30)
 . I $D(ERROR) Q
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
 NEW UID,II,DFN,PIPIEN,NOW,%,ERROR,PIPCNT
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
 S PIPCNT=0,PIPIEN="" F  S PIPIEN=$O(^BJPNPL("D",DFN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 . ;
 . NEW BJPNUP,STS,LMDT,LMBY,RSLT,IPLUPD,PRBIEN,DIC,DLAYGO,DA,IENS,X,Y
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 . ;
 . ;Mark that we have an entry
 . S PIPCNT=1
 . ;
 . S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I")
 . I PRBIEN="" S II=II+1,@DATA@(II)="-1^Could not find PRBIEN in PIP entry: "_PIPIEN,ERROR=1 Q
 . ;
 . ;Include only 'All Pregnancies'
 . I $$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")'="A" Q
 . ;
 . ;Status
 . S STS="A"
 . S BJPNUP(90680.01,PIPIEN_",",.08)=STS
 . ;
 . ;Last Modified Date
 . S LMDT=NOW
 . S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 . ;
 . ;Last Modified By
 . S LMBY=DUZ
 . S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 . ;
 . S IPLUPD(9000011,PRBIEN_",",.19)=1
 . S IPLUPD(9000011,PRBIEN_",",.03)=LMDT
 . S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 . ;
 . ;Add the IPL PIP flag
 . S DIC="^BJPNPL("_PIPIEN_",5,"
 . S DA(1)=PIPIEN
 . S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 . S X=NOW
 . K DO,DD D FILE^DICN
 . I +Y=-1 S II=II+1,@DATA@(II)="-1^Could not add PIP column history"_$C(30),ERROR=1 Q
 . ;
 . ;Add the User/PIP value
 . S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 . S BJPNUP(90680.015,IENS,".02")=1
 . S BJPNUP(90680.015,IENS,".03")=DUZ
 . ;
 . ;Update entry
 . I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1^PIP OPEN FAILED - PIPIEN:"_PIPIEN_$C(30),ERROR=1 Q
 . ;
 . D FILE^DIE("","IPLUPD","ERROR")
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1^PIP OPEN FAILED - PRBIEN:"_PRBIEN_$C(30),ERROR=1 Q
 ;
 ;Record success
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
 ;Broadcast update
 I $G(PIPCNT)=1 D
 . ;BJPN*2.0*7;Removed PPL
 . ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 . D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
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
 NEW UID,II,DFN,PIPIEN,NOW,%,ERROR,DEDD
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
 S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("D",DFN,PIPIEN)) Q:'PIPIEN  D  Q:$D(ERROR)
 . ;
 . NEW BJPNUP,STS,LMDT,LMBY,RSLT
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 . ;
 . ;DEDD
 . S BJPNUP(90680.01,PIPIEN_",",.09)=DEDD
 . ;
 . ;Last Modified Date
 . S LMDT=NOW
 . S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 . ;
 . ;Last Modified By
 . S LMBY=DUZ
 . S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 . ;
 . ;Update entry
 . I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 . I $D(ERROR) S II=II+1,@DATA@(II)="-1^^UPDATE DEDD FAILED - PIPIEN:"_PIPIEN_$C(30)
 ;
 ;Record success
 I '$D(ERROR) S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XDEDD S II=II+1,@DATA@(II)=$C(31)
 Q
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
 S:PRV="" PRV=DUZ
 S XPRV=$$GET1^DIQ(200,PRV_",",.01,"E")
 ;
 S II=II+1,@DATA@(II)=PRV_U_XPRV_$C(30)
 ;
XPPRV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PTED(N) ;Convert Education Topic to EHR viewable string
 ;
 I $G(N)="" Q ""
 ;
 NEW VEDIEN,TPIEN,TOPIC
 ;
 ;Pull the V PATIENT ED IEN
 S VEDIEN=$P(N,U,6) Q:VEDIEN="" N
 ;
 ;Get the topic IEN
 S TPIEN=$$GET1^DIQ(9000010.16,VEDIEN_",",".01","I") I TPIEN="" Q N
 ;
 ;If no SNOMED return what is there
 I $$GET1^DIQ(9999999.09,TPIEN_",",.12,"I")="" Q N
 ;
 ;Get the unconverted topic
 S TOPIC=$$GET1^DIQ(9999999.09,TPIEN_",",".01","I") I TOPIC="" Q N
 ;
 ;Strip off the SNOMED
 S TOPIC=$P(TOPIC,"-",2) I TOPIC="" Q N
 ;
 ;See if topic can be converted
 S TOPIC=$$CNVTPC(TOPIC)
 S $P(N,U,2)=TOPIC
 Q N
 ;
CNVTPC(T) ;Convert topic for EHR display
 I T="DISEASE PROCESS" S T="Had Disease Process education"
 I T="NUTRITION" S T="Had Nutrition education"
 I T="LIFESTYLE ADAPTATION" S T="Had Lifestyle Adaptation education"
 I T="PREVENTION" S T="Had Prevention education"
 I T="MEDICATIONS" S T="Had Medication education"
 I T="EXERCISE" S T="Had Exercise education"
 Q T
 ;
GETABN(DATA,CONCID) ;EP - BJPN GET ABNORMAL
 ;
 ;This RPC determines whether to prompt for abnormal/normal findings for a concept
 ;
 ;Input:
 ; CONCID - The Concept ID
 ;
 ;Output:
 ; 1 - Prompt for abnormal/normal
 ; 0 - Do not prompt for abnormal/normal
 ;
 NEW UID,II,RESULT
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
 S @DATA@(II)="T00001PROMPT_ABNORMAL"_$C(30)
 ;
 ;Input validation
 I $G(CONCID)="" S II=II+1,@DATA@(II)="-1^MISSING VPOVIEN"_$C(30) G XGETABN
 ;
 S RESULT=$P($$CONC^BSTSAPI(CONCID),U,7)
 ;
 ;Set up return string
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
XGETABN  S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
