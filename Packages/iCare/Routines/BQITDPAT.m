BQITDPAT ;PRXM/HC/ALA - Calculate DX Cat for single patient ; 26 Jul 2006  10:35 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
PAT(DATA,DFN) ;EP -- BQI POPULATE DX CAT BY PATIENT
 ;Description
 ;  Recalculate diagnosis categories for a single patient
 ;Input
 ;  DFN - Patient internal entry number
 ;Parameters
 ;  BQORD  - Diagnosis order number
 ;  BQTN   - Diagnosis category IEN
 ;  BQDEF  - Diagnosis category name
 ;  BQEXEC - If special executable code is need for dx cat
 ;  BQPRG  - Dx Cat program
 ;  BQTGLB  - Temporary global reference
 ;  VOK    - If 0 (zero) then patient isn't valid for this dx cat,
 ;           if 1 (one) then patient does meet criteria for this dx cat
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITDPAT",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITDPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW BQTN,BQDEF,BQORD
 S BQORD=""
 F  S BQORD=$O(^BQI(90506.2,"AC",BQORD)) Q:BQORD=""  D
 . S BQTN=""
 . F  S BQTN=$O(^BQI(90506.2,"AC",BQORD,BQTN)) Q:BQTN=""  D
 .. ; If the category is marked as inactive, ignore it
 .. I $$GET1^DIQ(90506.2,BQTN_",",.03,"I") Q
 .. ; If the category is a subdefinition, ignore it
 .. I $$GET1^DIQ(90506.2,BQTN_",",.05,"I")=1 Q
 .. S BQDEF=$$GET1^DIQ(90506.2,BQTN_",",.01,"E")
 .. S BQEXEC=$$GET1^DIQ(90506.2,BQTN_",",1,"E")
 .. S BQPRG=$$GET1^DIQ(90506.2,BQTN_",",.04,"E")
 .. ;
 .. S BQTGLB=$NA(^TMP("BQIPDXC",UID))
 .. K @BQTGLB
 .. ;
 .. ; Call the individual patient dx category code
 .. S PRGM="S VOK=""$$PAT^""_BQPRG_""(BQDEF,.BQTGLB,DFN)"""
 .. X PRGM
 .. ;
 .. ; File the returned data
 .. D CHK(BQTGLB,DFN)
 .. K @BQTGLB
 .. K TAX,VSDT,TIEN,TDXN,PLFLG,N,BQIRY,BQITRY
 .. K BDATE,EDATE,FLAG,GREF,FREF,PLFLG
 .. Q
 ;
 S BQIUPD(90507.5,DFN_",",.06)=$$NOW^XLFDT()
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 I $G(BQTGLB)'="" K @BQTGLB,BQTGLB
 K AGE,BQEXEC,BQDEF,BQPRG,DFN,PRGM,SEX,TXDXCN,TXDXCT,TXT,Y,X,VOK
 S II=II+1,@DATA@(II)="1"_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)="-1"_$C(30)
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CHK(BQTGLB,DFN) ; Check whether met criteria or not
 ;
 ; Yes, met criteria
 I @VOK D FIL^BQITASK(BQTGLB,DFN) Q
 ; No, didn't meet criteria
 D NCR^BQITDUTL(DFN,BQTN)
 ; Remove previous criteria
 NEW DA,DIK
 S DA(2)=DFN,DA(1)=BQTN,DA=0,DIK="^BQIPAT("_DA(2)_",20,"_DA(1)_",1,"
 F  S DA=$O(^BQIPAT(DFN,20,BQTN,1,DA)) Q:'DA  D ^DIK
 Q
 ;
FIL(BQGLB,DFN) ;EP - File diagnosis category
 Q
