BQIRGASP ;VNGT/HS/ALA-Asthma Patient ; 06 Mar 2009  3:58 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
EN(DATA,DFN,SOURCE) ;EP - BQI REFRESH PATIENT CARE MGT
 ; Input
 ;   DFN    - Patient internal entry number
 ;   SOURCE - The Care Managment Source Type (full name e.g. Asthma)
 ;
 NEW UID,II,BQDFN,SRCN,SRC,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGASP",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRMPAT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T00050MSG"_$C(30)
 S BQDFN=$G(DFN,""),SOURCE=$G(SOURCE,"")
 I BQDFN="" S RESULT=-1_U_"No patient selected" G DONE
 I SOURCE="" S RESULT=-1_U_"No Care Management type selected" G DONE
 S SRCN=$O(^BQI(90506.5,"B",SOURCE,"")) I SRCN="" S RESULT=-1_U_"No Source found." G DONE
 S SRC=$P(^BQI(90506.5,SRCN,0),U,2)
 ;
 D PAT(BQDFN,SRC)
 S RESULT=1_U
 ;
DONE ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PAT(BQDFN,SRC) ;EP - Get all Asthma data for a patient
 ;
 NEW DA,IENS,DIC,PSRIEN,SRIEN,CDRIEN,X,Y,CODE,DLAYGO,DIC,HDR,IEN,ORD
 NEW BQIUPD,VALUE,VISIT,OTHER,STVW,VAL,VSDTM,CT,ASN
 S SRIEN=$O(^BQI(90506.5,"C",SRC,"")) I SRIEN="" Q
 ; Check for bad records
 I $O(^BQIPAT(BQDFN,60,"B",SRIEN,""))="" D
 . S ASN=$O(^BQIPAT(BQDFN,60,0)) I ASN="" Q
 . I $G(^BQIPAT(BQDFN,60,ASN,0))'="",$P($G(^BQIPAT(BQDFN,60,ASN,0)),U,1)'=SRIEN Q
 . K ^BQIPAT(BQDFN,60,ASN)
 ;
 S DA(1)=BQDFN,X=$P(^BQI(90506.5,SRIEN,0),U,1),DIC(0)="L",DLAYGO=90507.56
 S DIC="^BQIPAT("_DA(1)_",60,"
 I $G(^BQIPAT(BQDFN,60,0))="" S ^BQIPAT(BQDFN,60,0)="^90507.56P^^"
 D ^DIC
 S (PSRIEN,DA)=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.56,IENS,.02)=$$NOW^XLFDT()
 ;
 ; Check for Alternate display order first
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AF",SRC,ORD)) Q:ORD=""  D
 . S AIEN=""
 . F  S AIEN=$O(^BQI(90506.1,"AF",SRC,ORD,AIEN)) Q:AIEN=""  D UPD(AIEN)
 ;
 ; Check for normal display order
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD",SRC,ORD)) Q:ORD=""  D
 . S AIEN=""
 . F  S AIEN=$O(^BQI(90506.1,"AD",SRC,ORD,AIEN)) Q:AIEN=""  D UPD(AIEN)
 Q
 ;
UPD(AIEN) ; EP - Update values
 I $$GET1^DIQ(90506.1,AIEN_",",.1,"I")=1 Q
 S STVW=AIEN,VAL="",VISIT="",OTHER=""
 D CVAL(BQDFN)
 S CODE=$P(^BQI(90506.1,AIEN,0),U,1)
 S DA(2)=BQDFN,DA(1)=PSRIEN,X=CODE,DIC(0)="L",DLAYGO=90507.561
 S DIC="^BQIPAT("_DA(2)_",60,"_DA(1)_",1,"
 D ^DIC
 S (CDRIEN,DA)=+Y
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.561,IENS,.02)=$G(VAL)
 S BQIUPD(90507.561,IENS,.04)=$G(VISIT)
 S BQIUPD(90507.561,IENS,.05)=$G(OTHER)
 K VAL,OTHER
 I $D(BQIUPD)>0 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
CVAL(DFN) ; Get demographic values
 ;Parameters
 ;  FIL  = FileMan file number
 ;  FLD  = FileMan field number
 ;  EXEC = If an executable is needed to determine value
 ;  HDR  = Header value
 ;the executable expects the value to be returned in variable VAL
 NEW FIL,FLD,EXEC,RCODE,RGIEN,RIEN,RHDR,MVALUE,CODE
 S FIL=$$GET1^DIQ(90506.1,STVW_",",.05,"E")
 S FLD=$$GET1^DIQ(90506.1,STVW_",",.06,"E")
 S EXEC=$$GET1^DIQ(90506.1,STVW_",",5,"E")
 S HDR=$$GET1^DIQ(90506.1,STVW_",",.08,"E")
 I $G(DFN)="" S VAL="" Q
 ;
 I $G(EXEC)'="" X EXEC Q
 ;
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
 Q
