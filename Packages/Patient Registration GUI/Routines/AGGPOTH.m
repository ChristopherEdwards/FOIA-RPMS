AGGPOTH ;VNGT/HS/BEE-Other Patient Data Field Handling ; 02 May 2010  9:08 AM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 Q
 ;
UMIG(AGPATDFN,NSTS,NTYP) ;PEP - Update Migrant Worker Information
 ;
 ;Input:
 ; AGPATDFN - Patient IEN
 ; NSTS - New Migrant Status (Y/N)
 ; NTYP - New Migrant Worker Type (M/S)
 ;
 ;Output:
 ;Returns -1^Error Message - on Failure
 ;        "" - on Success
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 Q:AGPATDFN="" "-1^Missing Patient IEN"
 ;
 N AGG,DA,DIC,DLAYGO,ERROR,X,Y
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",84,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.84",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,84,0)) S ^AUPNPAT(AGPATDFN,84,0)="^9000001.84D^^"
 K DO,DD D FILE^DICN
 ;
 S DA=+Y,DA(1)=AGPATDFN
 S AGG(9000001.84,DA_","_DA(1)_",",".02")=$S(NSTS'="":NSTS,1:"@")
 S AGG(9000001.84,DA_","_DA(1)_",",".03")=$S(((NSTS="")!(NSTS="N")):"@",1:NTYP)
 D FILE^DIE("","AGG","ERROR")
 ;
 I $D(ERROR) Q "-1^"_$G(ERROR)
 ;
 ;Successful Save
 Q ""
 ;
RMIG(AGPATDFN) ;Return the patients most recent Migrant information
 ;
 N MDT,MDTX,MIEN,MSTS,MSTSX,MTYP,MTYPX,Y
 ;
 S (MDT,MDTX,MIEN,MSTS,MSTSX,MTYP,MTYPX)=""
 S MDT=$O(^AUPNPAT(AGPATDFN,84,"B",""),-1)
 I MDT]"" S MIEN=$O(^AUPNPAT(AGPATDFN,84,"B",MDT,""),-1)
 S Y=MDT X ^DD("DD") S MDTX=Y
 I MIEN]"" S MSTS=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".02","I")
 I MIEN]"" S MTYP=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","I")
 I MIEN]"" S MSTSX=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".02","E")
 I MIEN]"" S MTYPX=$$GET1^DIQ(9000001.84,MIEN_","_AGPATDFN_",",".03","E")
 ;
 Q MIEN_U_MDT_":"_MDTX_U_MSTS_":"_MSTSX_U_MTYP_":"_MTYPX
 ;
 ;
UHOM(AGPATDFN,NSTS,NTYP) ;PEP - Update Homeless Information
 ;
 ;Input:
 ; AGPATDFN - Patient IEN
 ; NSTS - New Homeless Status (Y/N)
 ; NTYP - New Homeless Type (H/T/D/S/U)
 ;
 ;Output:
 ;Returns -1^Error Message - on Failure
 ;        "" - on Success
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 Q:AGPATDFN="" "-1^Missing Patient IEN"
 ;
 N AGG,DA,DIC,DLAYGO,ERROR,X,Y
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",85,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.85",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,85,0)) S ^AUPNPAT(AGPATDFN,85,0)="^9000001.85D^^"
 K DO,DD D FILE^DICN
 ;
 S DA=+Y,DA(1)=AGPATDFN
 S AGG(9000001.85,DA_","_DA(1)_",",".02")=$S(NSTS'="":NSTS,1:"@")
 S AGG(9000001.85,DA_","_DA(1)_",",".03")=$S(((NSTS="")!(NSTS="N")):"@",1:NTYP)
 D FILE^DIE("","AGG","ERROR")
 ;
 I $D(ERROR) Q "-1^"_$G(ERROR)
 ;
 ;Successful Save
 Q ""
 ;
RHOM(AGPATDFN) ;Return the patients most recent Homeless information
 ;
 N HDT,HDTX,HIEN,HSTS,HSTSX,HTYP,HTYPX,Y
 ;
 S (HDT,HDTX,HIEN,HSTS,HSTSX,HTYP,HTYPX)=""
 S HDT=$O(^AUPNPAT(AGPATDFN,85,"B",""),-1)
 I HDT]"" S HIEN=$O(^AUPNPAT(AGPATDFN,85,"B",HDT,""),-1)
 S Y=HDT X ^DD("DD") S HDTX=Y
 I HIEN]"" S HSTS=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".02","I")
 I HIEN]"" S HTYP=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","I")
 I HIEN]"" S HSTSX=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".02","E")
 I HIEN]"" S HTYPX=$$GET1^DIQ(9000001.85,HIEN_","_AGPATDFN_",",".03","E")
 ;
 Q HIEN_U_HDT_":"_HDTX_U_HSTS_":"_HSTSX_U_HTYP_":"_HTYPX
 ;
 ;
UINT(AGPATDFN,AGGINTNT,OTHPARM) ;PEP - Update Internet Access Information
 ;
 ;Input:
 ; AGPATDFN - Patient IEN
 ; AGGINTNT - (1-YES/0-NO)
 ; OTHPARM - OTHER_PARMS return value
 ;
 ;Output:
 ;Returns -1^Error Message - on Failure
 ;        "" - on Success
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 Q:AGPATDFN="" "-1^Missing Patient IEN"
 ;
 N AGG,DA,DIC,DLAYGO,ERROR,X,Y,LIEN,LDT
 ;
 ;Pull existing entry IEN
 S LIEN="",LDT=$O(^AUPNPAT(AGPATDFN,81,"B",""),-1)
 I LDT]"" S LIEN=$O(^AUPNPAT(AGPATDFN,81,"B",LDT,""),-1)
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",81,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.81",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,81,0)) S ^AUPNPAT(AGPATDFN,81,0)="^9000001.81D^^"
 K DO,DD D FILE^DICN
 ;
 S DA=+Y,DA(1)=AGPATDFN
 S OTHPARM=$G(OTHPARM)_$S($G(OTHPARM)'="":$C(28),1:"")_"AGGINT="_+Y
 S AGG(9000001.81,DA_","_DA(1)_",",".02")=$S(AGGINTNT=0:0,AGGINTNT=1:1,1:"@")
 D FILE^DIE("","AGG","ERROR")
 ;
 I LIEN]"" M ^AUPNPAT(AGPATDFN,81,DA,1)=^AUPNPAT(AGPATDFN,81,LIEN,1)
 ;
 I $D(ERROR) Q "-1^"_$G(ERROR)
 ;
 ;Successful Save
 Q ""
 ;
 ;
ULNG(AGPATDFN,NPRM,NINT,NEPR,NPRF,OTHPARM) ;PEP - Update Language Information
 ;
 ;Input:
 ; AGPATDFN - Patient IEN
 ; NPRM - Primary Patient Language IEN
 ; NINT - Interpreter Required (Y/N/U)
 ; NEPR - English Proficiency (VW/W/NW/NA)
 ; NPRF - Preferred Patient Language IEN
 ; OTHPARM - OTHER_PARMS return value
 ;
 ;Output:
 ;Returns -1^Error Message - on Failure
 ;        "" - on Success
 ;        OTHPARM - Delimited parameter containing IEN of new language multiple
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 Q:AGPATDFN="" "-1^Missing Patient IEN"
 ;
 N AGG,DA,DIC,DLAYGO,ERROR,X,Y,LDT,LIEN
 ;
 ;Pull existing entry IEN
 S LIEN="",LDT=$O(^AUPNPAT(AGPATDFN,86,"B",""),-1)
 I LDT]"" S LIEN=$O(^AUPNPAT(AGPATDFN,86,"B",LDT,""),-1)
 ;
 ;Define new entry and save
 S DIC="^AUPNPAT("_AGPATDFN_",86,",DA(1)=AGPATDFN
 S DIC(0)="L"
 S X=DT
 S DLAYGO="9000001.86",DIC("P")=DLAYGO
 I '$D(^AUPNPAT(AGPATDFN,86,0)) S ^AUPNPAT(AGPATDFN,86,0)="^9000001.86D^^"
 K DO,DD D FILE^DICN
 ;
 S DA=+Y,DA(1)=AGPATDFN
 S OTHPARM=$G(OTHPARM)_$S($G(OTHPARM)'="":$C(28),1:"")_"AGGLNG="_+Y
 I $G(NPRM)]"" S AGG(9000001.86,DA_","_DA(1)_",",".02")=NPRM
 I $G(NINT)]"" S AGG(9000001.86,DA_","_DA(1)_",",".03")=NINT
 I $G(NPRF)]"" S AGG(9000001.86,DA_","_DA(1)_",",".04")=NPRF
 I $G(NEPR)]"" S AGG(9000001.86,DA_","_DA(1)_",",".06")=NEPR
 I $D(AGG) D FILE^DIE("","AGG","ERROR")
 ;
 I LIEN]"" M ^AUPNPAT(AGPATDFN,86,DA,5)=^AUPNPAT(AGPATDFN,86,LIEN,5)  ;Save Existing Other Spoken Languages
 ;
 I $D(ERROR) Q "-1^"_$G(ERROR)_U_$G(OTHPARM)
 ;
 ;Successful Save
 Q ""
 ;
UPD(DATA,DEF,AGPATDFN,MIEN,PROC,PARMS) ; EP - AGG UPDATE SPECIAL MULTIPLES
 ; Input
 ;   DEF   - Definition Name 'Other Languages'
 ;   AGPATDFN - Patient DFN
 ;   MIEN  - Multiple Level IEN value
 ;   PROC  - 'A' to add, 'D' to delete
 ;   PARMS - Parameters
 ;
 NEW UID,II,LIST,BN,AGGLGOTH,VFIEN,BQ,PDATA,NAME,VALUE,PFIEN,PTYP,CHIEN,RESULT,AGGINAM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGPOTH",UID))
 S MIEN=$G(MIEN,"") S:MIEN=0 MIEN=""
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T01024ERROR"_$C(30)
 ;
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 S AGGLGOTH="",AGGINAM=""
 S VFIEN=$O(^AGG(9009068.3,"B",DEF,""))
 I VFIEN="" S BMXSEC="RPC Call Failed: "_DEF_" Definition does not exist." Q
 ;
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . S PFIEN=$O(^AGG(9009068.3,VFIEN,10,"AC",NAME,""))
 . I PFIEN="" S BMXSEC=NAME_" not a valid parameter for this update" Q
 . S PTYP=$P($G(^AGG(9009068.3,VFIEN,10,PFIEN,1)),U,1)
 . I PTYP="D" S VALUE=$$DATE^AGGUL1(VALUE)
 . I PTYP="C" D
 .. I VALUE="" Q
 .. S CHIEN=$O(^AGG(9009068.3,VFIEN,10,PFIEN,5,"B",VALUE,"")) I CHIEN="" Q
 .. S VALUE=$P(^AGG(9009068.3,VFIEN,10,PFIEN,5,CHIEN,0),U,2)
 . S @NAME=VALUE
 ;
 S RESULT="-1^Unable to save multiple entry "_AGGLGOTH
 ;
 ;Process 'Other Languages' entries
 I DEF="Other Languages" D
 . ;
 . ;Set up for Adds
 . I $G(PROC)="A",$G(AGGLGOTH)]"" D  Q
 .. N FDAIEN,FDA,ERROR
 .. S FDAIEN(1)=AGGLGOTH
 .. S FDA(1,9000001.8605,"+1,"_MIEN_","_AGPATDFN_",",.01)=AGGLGOTH
 .. D UPDATE^DIE("","FDA(1)","FDAIEN","ERROR")
 .. I $D(ERROR) S RESULT="-1^"_$G(ERROR("DIERR",1,"TEXT",1)) Q
 .. S RESULT="1^"
 .. ;
 . ;Handle Deletes
 . I $G(PROC)="D" D  Q
 .. N DA,AGG,ERROR
 .. S DA=+AGGLGOTH,DA(1)=MIEN,DA(2)=AGPATDFN
 .. S AGG(9000001.8605,DA_","_DA(1)_","_DA(2)_",",.01)="@"
 .. D FILE^DIE("","AGG","ERROR")
 .. I $D(ERROR) S RESULT="-1^"_$G(ERROR("DIERR",1,"TEXT",1)) Q
 .. S RESULT="1^"
 ;
 ;Process 'Internet Access Method' entries
 I DEF="Internet Access Method" D
 . ;
 . ;Set up for Adds
 . I $G(PROC)="A",$G(AGGINAM)]"" D  Q
 .. N FDA,ERROR
 .. S FDA(1,9000001.811,"+1,"_MIEN_","_AGPATDFN_",",.01)=AGGINAM
 .. D UPDATE^DIE("","FDA(1)","","ERROR")
 .. I $D(ERROR) S RESULT="-1^"_$G(ERROR("DIERR",1,"TEXT",1)) Q
 .. S RESULT="1^"
 . ;
 . ;Handle Deletes
 . I $G(PROC)="D" D  Q
 .. N DA,AGG,ERROR
 .. S DA=$O(^AUPNPAT(AGPATDFN,81,MIEN,1,"B",AGGINAM,"")) Q:DA=""
 .. S DA(1)=MIEN,DA(2)=AGPATDFN
 .. S AGG(9000001.811,DA_","_DA(1)_","_DA(2)_",",.01)="@"
 .. D FILE^DIE("","AGG","ERROR")
 .. I $D(ERROR) S RESULT="-1^"_$G(ERROR("DIERR",1,"TEXT",1)) Q
 .. S RESULT="1^"
 ;
DONE     ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 ;
 ; Set last date updated and updated by
 I $P(RESULT,U,1)=1 D
 . S AGGDATAI(9000001,AGPATDFN_",",.03)=DT,AGGDATAI(9000001,AGPATDFN_",",.12)=DUZ
 . D FILE^DIE("I","AGGDATAI","ERROR")
 . D EDIT^AGGEXPRT(AGPATDFN)
 Q
 ;
INTAM(DATA,DFN) ; EP - AGG PATIENT INT ACCESS METH
 ;
 NEW UID,II,AGIEN,ERROR,FILE,HEADR,DA,IDA,IEN,IENS
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGPOTH",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPOTH D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S AGIEN=$$FIND1^DIC(9009068.3,"","BX","Internet Access Method","","","ERROR")
 I AGIEN=0 S BMXSEC="RPC Failed: Passed in window name "_DEF_" not found" Q
 ;
 S FILE=$P(^AGG(9009068.3,AGIEN,0),U,2),SECFILE=$P(^AGG(9009068.3,AGIEN,0),U,14)
 ;
 S DA(1)=DFN,IDA=$O(^AUPNPAT(DFN,81,"B"),-1) I IDA="" D  G XINTAM
 . N HEADR
 . S HEADR="T00050AGGINAM"
 . S @DATA@(II)=HEADR_$C(30)
 ;
 I $O(^AUPNPAT(DFN,81,IDA,1,0))="" D  G XINTAM
 . N HEADR
 . S HEADR="T00050AGGINAM"
 . S @DATA@(II)=HEADR_$C(30)
 ;
 S IEN=0 F  S IEN=$O(^AUPNPAT(DFN,81,IDA,1,IEN)) Q:'IEN  D
 . S DA(2)=DFN,DA(1)=IDA,DA=IEN
 . S IENS=$$IENS^DILF(.DA)
 . D REC(IENS,FILE,SECFILE)
 ;
XINTAM ;
 S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
REC(IENS,FILE,SECFILE) ;EP
 N AGCN,HEADR,HDATA,HDR,TXT
 S HEADR="",HDATA=""
 S AGCN=0
 F  S AGCN=$O(^AGG(9009068.3,AGIEN,10,AGCN)) Q:'AGCN  D
 . N AGDATA,FLD,TYPE,SECFLD,CODE,DEXEC,VAL,DQTY,FLD,VALUE
 . I $P(^AGG(9009068.3,AGIEN,10,AGCN,0),U,11)'="" Q
 . S AGDATA=$G(^AGG(9009068.3,AGIEN,10,AGCN,0))
 . S FLD=$P($G(^AGG(9009068.3,AGIEN,10,AGCN,3)),U,1),SECFLD=$P($G(^AGG(9009068.3,AGIEN,10,AGCN,3)),U,7)
 . S TYPE=$P($G(^AGG(9009068.3,AGIEN,10,AGCN,1)),U,1)
 . S CODE=$P(AGDATA,U,7),HDR=$P(AGDATA,U,2)
 . S DEXEC=$G(^AGG(9009068.3,AGIEN,10,AGCN,8))
 . I TYPE="M" S VALUE=""
 . I TYPE="T"!(TYPE="C")!(TYPE="K") D
 .. I DEXEC'="" D  Q
 ... S VAL=""
 ... I DEXEC'["DQTY" X DEXEC Q
 ... S DQTY="I" X DEXEC S VAL=VALUE_$C(28)
 ... S DQTY="E" X DEXEC S VALUE=VAL_VALUE
 .. I FLD'="" S VALUE=$$GET1^DIQ(FILE,IENS,FLD,"I")_$C(28)_$$GET1^DIQ(FILE,IENS,FLD,"E") Q
 .. S VALUE=$$GET1^DIQ(SECFILE,IENS,SECFLD,"I")_$C(28)_$$GET1^DIQ(SECFILE,IENS,SECFLD,"E")
 . I TYPE="X"!(TYPE="N") D
 .. NEW TYPE
 .. I DEXEC'="" X DEXEC Q
 .. I FLD=.001 S VALUE=IEN Q
 .. I FLD'="" S VALUE=$$GET1^DIQ(FILE,IENS,FLD,"E") Q
 .. S VALUE=$$GET1^DIQ(SECFILE,IENS,SECFLD,"E")
 . I TYPE="D" D
 .. I DEXEC'="" X DEXEC Q
 .. I FLD'="" S VALUE=$$GET1^DIQ(FILE,IENS,FLD,"I"),VALUE=$$FMTE^AGGUL1(VALUE) Q
 .. S VALUE=$$GET1^DIQ(SECFILE,IENS,SECFLD,"I"),VALUE=$$FMTE^AGGUL1(VALUE)
 . I TYPE="W" D
 .. NEW FL,FD,AN
 .. K ARRAY S VALUE=""
 .. I DEXEC'="" X DEXEC
 .. I DEXEC="" D
 ... I FLD'="" D GETS^DIQ(FILE,DFN_",",FLD,"E","ARRAY") Q
 ... D GETS^DIQ(SECFILE,DFN_",",SECFLD,"E","ARRAY")
 .. S FL=$O(ARRAY("")) I FL="" Q
 .. S FD=$O(ARRAY(FL,DFN_",","")) I FD="" Q
 .. S AN=0,TXT=ARRAY(FL,DFN_",",FD,"E") I TXT="" Q
 .. K @TXT@("E")
 .. F  S AN=$O(@TXT@(AN)) Q:AN=""  S VALUE=VALUE_@TXT@(AN)_$C(10)
 . S HEADR=HEADR_HDR_"^"
 . S HDATA=HDATA_$G(VALUE)_"^",VALUE=""
 S HEADR=$$TKO^AGGUL1(HEADR,"^"),HDATA=$$TKO^AGGUL1(HDATA,"^")
 I II=0 S @DATA@(II)=HEADR_$C(30)
 S II=II+1,@DATA@(II)=HDATA_$C(30)
 ;
 Q
 ;
DOTH(AGPATDFN) ;EP - Return the list of Other Languages Spoken
 ;
 N OTHL,LIEN,LDT,LNG,VAR
 ;
 I AGPATDFN="" Q ""  ;Missing patient DFN
 ;
 S OTHL=""
 ;
 ;Pull existing entry IEN
 S LIEN="",LDT=$O(^AUPNPAT(AGPATDFN,86,"B",""),-1)
 I LDT]"" S LIEN=$O(^AUPNPAT(AGPATDFN,86,"B",LDT,""),-1)
 ;
 I LIEN="" Q ""  ;No Language Information on File
 ;
 ;Pull Other Languages
 D GETS^DIQ(9000001.86,LIEN_","_AGPATDFN_",",".05*","E","VAR")
 ;
 S IEN="" F  S IEN=$O(VAR(9000001.8605,IEN)) Q:IEN=""  S LNG=$G(VAR(9000001.8605,IEN,".01","E")) I LNG]"" S OTHL=OTHL_$S(OTHL="":"",1:", ")_LNG I OTHL[", " S OTHL="MORE THAN ONE LANGUAGE" Q
 Q OTHL
 ;
DINTW(AGPATDFN) ;EP - Return the list of Internet WHERE values
 ;
 N INTW,LIEN,LDT,WHERE,VAR,IEN
 ;
 I AGPATDFN="" Q ""  ;Missing patient DFN
 ;
 S INTW=""
 ;
 ;Pull existing entry IEN
 S LIEN="",LDT=$O(^AUPNPAT(AGPATDFN,81,"B",""),-1)
 I LDT]"" S LIEN=$O(^AUPNPAT(AGPATDFN,81,"B",LDT,""),-1)
 ;
 I LIEN="" Q ""  ;No Internet Information on File
 ;
 ;Pull Internet WHERE values
 D GETS^DIQ(9000001.81,LIEN_","_AGPATDFN_",",".04*","I","VAR")
 ;
 S IEN="" F  S IEN=$O(VAR(9000001.811,IEN)) Q:IEN=""  S WHERE=$G(VAR(9000001.811,IEN,".01","I")) I WHERE]"" S INTW=INTW_$S(INTW="":"",1:", ")_WHERE
 Q INTW
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
