BQIPTFHE ;VNGT/HS/BEE - Family History Data Entry ; 13 May 2009  10:35 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
REL(DATA,DFN) ; EP - BQI GET FAM HIST RELATIONS
 ;Description
 ;  Retrieves all of the FAMILY HISTORY FAMILY MEMBERS entries for the given DFN
 ;
 ;Input
 ;  DFN - Patient Internal ID
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIPTFHE"))
 ;
 NEW UID,BQII,FHRIEN,BQREL,BQIREL,RDSC,REL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTFHE",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTFHE D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010FHRIEN^T00060FHRREL^T00030FHRDES"_$C(30)
 ;
 I $$VERSION^XPDUTL("BJPC")<2.0 D  G DONE
 . S BMXSEC="RPC Call Failed: IHS PCC SUITE 2.0 must be installed in RPMS" Q
 ;
 ;Verify Patient DFN is populated
 I $G(DFN)="" S BMXSEC="Patient DFN is required" Q
 ;
 S BQREL="" F  S BQREL=$O(^AUPNFHR("AA",DFN,BQREL)) Q:BQREL=""  D
 . S FHRIEN="" F  S FHRIEN=$O(^AUPNFHR("AA",DFN,BQREL,FHRIEN)) Q:FHRIEN=""  D
 .. N BQIREL
 .. D GETS^DIQ(9000014.1,FHRIEN,".01;.03","E","BQIREL")
 .. S REL=$G(BQIREL(9000014.1,FHRIEN_",",".01","E"))
 .. S RDSC=$G(BQIREL(9000014.1,FHRIEN_",",".03","E"))
 .. S BQII=BQII+1,@DATA@(BQII)=FHRIEN_U_REL_U_RDSC_$C(30)
 ;
DONE ;
 ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
COND(DATA,FHRIEN) ; EP - BQI GET FAM HIST CONDITIONS
 ;Description
 ;  Retrieves all of the FAMILY HISTORY entries for the given Relation IEN
 ;
 ;Input
 ;  FHRIEN - Relationship IEN
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIPTFHE"))
 ;
 NEW UID,AGEO,BQII,FHCIEN,COND,DTMD,DTNT,PNAR,PROV,APCDTNQ,DIEN,FHCDX
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTFHE",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTFHE D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010FHCIEN^T00060FHCDX^D00030FHCDTN^T00080FHCNAR^T00050FHCPRV^T00030FHCAAO^D00030FHCDTM^T00100APCDTNQ"_$C(30)
 ;
 I $$VERSION^XPDUTL("BJPC")<2.0 D  G DONE1
 . S BMXSEC="RPC Call Failed: IHS PCC SUITE 2.0 must be installed in RPMS" Q
 ;
 ;Verify that Relation IEN is populated
 I $G(FHRIEN)="" S BMXSEC="FAMILY HISTORY FAMILY MEMBERS IEN IS REQUIRED" Q
 ;
 S FHCIEN="" F  S FHCIEN=$O(^AUPNFH("AE",FHRIEN,FHCIEN)) Q:FHCIEN=""  D
 . N BQICND
 . D GETS^DIQ(9000014,FHCIEN,"**","IE","BQICND")
 . ;
 . ;Date Noted
 . S DTNT=$G(BQICND(9000014,FHCIEN_",",".03","E"))
 . ;
 . ;DX Code (Condition) - With IEN
 . S DIEN=$$GET1^DIQ(9000014,FHCIEN_",",.01,"I") ;Using $$GET1^DIQ as GETS^DIQ sometimes omits .01 entry
 . I DIEN="" Q
 . I $T(ICDDX^ICDCODE)'="" S FHCDX=$$ICD9^BQIUL3(DIEN,DTNT,2)_"-"_$$ICD9^BQIUL3(DIEN,DTNT,4) ; csv
 . I $T(ICDDX^ICDCODE)="" S FHCDX=$$GET1^DIQ(80,DIEN_",",.01,"E")_"-"_$$GET1^DIQ(80,DIEN_",",3,"E")
 . S COND=DIEN_$C(28)_FHCDX S:$P(COND,$C(28))="-" COND=""
 . ;
 . ;Narrative
 . S PNAR=$G(BQICND(9000014,FHCIEN_",",".04","E"))
 . ;
 . ;Narrative - With IEN
 . S APCDTNQ=$G(BQICND(9000014,FHCIEN_",",".04","I"))_$C(28)_PNAR
    . S:$P(APCDTNQ,$C(28))="" APCDTNQ=""
    . ;
 . ;Provider - With IEN
 . S PROV=$G(BQICND(9000014,FHCIEN_",",".08","I"))_$C(28)_$G(BQICND(9000014,FHCIEN_",",".08","E"))
    . S:$P(PROV,$C(28))="" PROV=""
 . ;
    . ;Age at Onset
    . S AGEO=$G(BQICND(9000014,FHCIEN_",",".11","I"))_$C(28)_$G(BQICND(9000014,FHCIEN_",",".11","E"))
    . S:$P(AGEO,$C(28))="" AGEO=""
    . ;
    . ;Date last modified
 . S DTMD=$G(BQICND(9000014,FHCIEN_",",".12","E"))
 . ;
 . S BQII=BQII+1,@DATA@(BQII)=FHCIEN_U_COND_U_DTNT_U_PNAR_U_PROV_U_AGEO_U_DTMD_U_APCDTNQ_$C(30)
 ;
DONE1 ;
 ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
UPDR(DATA,DFN,TYPE,FHRIEN,PARMS) ; EP - BQI UPDATE FAM HIST RELATIONS
 ;Input
 ;  DFN    - Patient internal entry number
 ;  TYPE   - 'A' to add/edit or 'D' to delete (Delete currently deactivated)
 ;  FHRIEN - FAMILY HISTORY FAMILY MEMBERS IEN (Required for Edit/Delete)
 ;  PARMS  - Data values
 ;
 NEW UID,BQ,BQIDATA,BQII,BQITMP,ERROR,FILE,MSG,RESULT,VFIEN
 NEW FHRREL,FHRDES,FHRSTS,FHRAAD,FHRCOD,FHRMB,FHRMBT,FHRDTU,FHRDTA
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTFHE",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTFHE D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010RESULT^T01024MSG^I00010FHRIEN"_$C(30)
 ;
 S VFIEN=$O(^BQI(90506.3,"B","Family History Relations",""))
 I VFIEN="" S BMXSEC="RPC Call Failed: Family History Relations Definition does not exist." Q
 S FILE=$P(^BQI(90506.3,VFIEN,0),U,2) I FILE="" S BMXSEC="RPC Call Failed: Family History Relations Definition FILE NUMBER is null." Q
 ;
 S DFN=$G(DFN,""),TYPE=$G(TYPE,""),FHRIEN=$G(FHRIEN,"")
 I TYPE'="A",TYPE'="D" S BMXSEC="TYPE value is required (A-Add/Edit, D-Delete)" Q
 I TYPE="A",DFN="" S BMXSEC="Patient DFN value is required" Q
 I TYPE="D",FHRIEN="" S BMXSEC="Pointer to FAMILY HISTORY FAMILY MEMBERS is required for deletes" Q
 ;
 ;Handle Deletes
 I TYPE="D" D  G DONER
 . S RESULT=$$DELR(FHRIEN)
 . S BQII=BQII+1,@DATA@(BQII)=RESULT_$C(30)
 ;
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Pull Parameter Data
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . N CHIEN,FIELD,NAME,PDATA,PFIEN,PTYP,VALUE
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1) I NAME="" Q
 . S VALUE=$P(PDATA,"=",2,99)
 . S PFIEN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I PFIEN="" S BMXSEC=NAME_" not a valid parameter for this update" Q
 . S FIELD=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,3)),U,1)
 . I VALUE="",FIELD'=".001" S VALUE="@"
 . S PTYP=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,1)),U,1)
 . I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 . I PTYP="C" D
 .. S CHIEN=$O(^BQI(90506.3,VFIEN,10,PFIEN,5,"B",VALUE,"")) I CHIEN="" Q
 .. S VALUE=$P(^BQI(90506.3,VFIEN,10,PFIEN,5,CHIEN,0),U,2)
 . S @NAME=VALUE
 . I FIELD'=".001",FIELD]"" S BQITMP(FIELD)=VALUE
 ;
 ;Handle Adds
 I FHRIEN="" D NEWFR Q:$G(BMXSEC)'=""
 ;
 ;Update Date Updated
 S BQITMP(".09")=DT
 ;
 ;File Record Data
 M BQIDATA(FILE,FHRIEN_",")=BQITMP
 I $D(BQIDATA)>0 D FILE^DIE("","BQIDATA","ERROR")
 S RESULT=1_U_U_FHRIEN
 I $D(ERROR)>0 S RESULT=-1_U_$G(ERROR("DIERR",1,"TEXT",1))
 S BQII=BQII+1,@DATA@(BQII)=RESULT_$C(30)
 ;
DONER ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
NEWFR ;Create FAMILY HISTORY FAMILY MEMBERS record
 NEW DIC,DA,DR,X,Y
 I $G(FHRREL)="" S BMXSEC="RELATIONSHIP value is required" Q
 S DIC="^AUPNFHR(",DIC(0)="L",X=FHRREL,DIC("DR")=".02////"_DFN_";.11////^S X=DT;.09////^S X=DT"
 K DO,DD D FILE^DICN
 S FHRIEN=+Y
 I 'FHRIEN S BMXSEC="Unable to create new FAMILY HISTORY FAMILY MEMBERS RECORD"
 Q
 ;
UPDC(DATA,DFN,TYPE,FHRIEN,FHCIEN,PARMS) ; EP - BQI UPDATE FAM HIST CONDITIONS
 ;Input
 ;  DFN    - Patient internal entry number
 ;  TYPE   - 'A' to add/edit or 'D' to delete ('E' gets converted to 'A')
 ;  FHRIEN - FAMILY HISTORY FAMILY MEMBER IEN (Required for Add/Edit)
 ;  FHCIEN - FAMILY HISTORY IEN (Required for Edit/Delete)
 ;  PARMS  - Data values
 ;
 NEW UID,BQ,BQIDATA,BQII,BQITMP,ERROR,FILE,MSG,RESULT,VFIEN
 NEW FHCDX,FHCNAR,FHCPRV,FHCAAO,FHCDTN,APCDTNQ
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTFHE",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTFHE D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="I00010RESULT^T01024MSG^I00010FHCIEN"_$C(30)
 ;
 S VFIEN=$O(^BQI(90506.3,"B","Family History Conditions",""))
 I VFIEN="" S BMXSEC="RPC Call Failed: Family History Conditions Definition does not exist." Q
 S FILE=$P(^BQI(90506.3,VFIEN,0),U,2) I FILE="" S BMXSEC="RPC Call Failed: Family History Conditions Definition FILE NUMBER is null." Q
 ;
 S DFN=$G(DFN,""),TYPE=$G(TYPE,""),FHRIEN=$G(FHRIEN,""),FHCIEN=$G(FHCIEN,"")
 I DFN="" S BMXSEC="Patient DFN value is required" Q
 ;
 ;Convert TYPE 'E' to 'A'
 S:TYPE="E" TYPE="A"
 ;
 I TYPE'="A",TYPE'="D" S BMXSEC="TYPE value is required (A-Add/Edit, D-Delete)" Q
 I TYPE="A",DFN="" S BMXSEC="Patient DFN value is required" Q
 I TYPE="A",FHRIEN="" S BMXSEC="Pointer to FAMILY HISTORY FAMILY MEMBERS is required" Q
 I TYPE="D",FHCIEN="" S BMXSEC="Pointer to FAMILY HISTORY is required for deletes"
 ;
 ;Handle Deletes
 I TYPE="D" D  G DONEC
 . S RESULT=$$DELC(FHCIEN)
 . S BQII=BQII+1,@DATA@(BQII)=RESULT_$C(30)
 ;
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Pull Parameter Data
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . N CHIEN,FIELD,NAME,PDATA,PFIEN,PTYP,VALUE
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1) I NAME="" Q
 . S VALUE=$P(PDATA,"=",2,99)
 . S PFIEN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I PFIEN="" S BMXSEC=NAME_" not a valid parameter for this update" Q
 . S FIELD=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,3)),U,1)
 . I VALUE="",FIELD'=".001" S VALUE="@"
 . S PTYP=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,1)),U,1)
 . I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 . I PTYP="C" D
 .. S CHIEN=$O(^BQI(90506.3,VFIEN,10,PFIEN,5,"B",VALUE,"")) I CHIEN="" Q
 .. S VALUE=$P(^BQI(90506.3,VFIEN,10,PFIEN,5,CHIEN,0),U,2)
 . S @NAME=VALUE
 . I FIELD'=".001",FIELD]"" S BQITMP(FIELD)=VALUE
 ;
 ;Handle Adds
 I FHCIEN="" D NEWFC Q:$G(BMXSEC)'=""
 ;
 ;Special code to fill in Diagnosis Narrative (if blank)
 I $G(BQITMP(".04"))="",$G(BQITMP(".01"))]"" D
 . N TEXT
 . S TEXT=$P($$ICDDX^ICDCODE(BQITMP(".01"),DT),U,4)
 . I TEXT]"" D
 .. N DIC,DLAYGO,X,Y,IEN
 .. S DIC(0)="LX",DIC="^AUTNPOV(",DLAYGO=9999999.27,X=TEXT
 .. D ^DIC
 .. S IEN=+Y
 .. I IEN=-1 K DO,DD D FILE^DICN S TEXT=+Y
 . S BQITMP(".04")=TEXT ;Adapted from COND^APCDFH (APCD FAMILY HISTORY ADD/EDIT option)
 ;
 ;Update Relation IEN (Needed For Cases When Condition Gets Moved)
 S BQITMP(".09")=$G(FHRIEN)
 ;
 ;Update Date Last Modified
 S BQITMP(".12")=DT
 ;
 ;File Record Data
 M BQIDATA(FILE,FHCIEN_",")=BQITMP
 I $D(BQIDATA)>0 D FILE^DIE("","BQIDATA","ERROR")
 S RESULT=1_U_U_FHCIEN
 I $D(ERROR)>0 S RESULT=-1_U_$G(ERROR("DIERR",1,"TEXT",1))
 S BQII=BQII+1,@DATA@(BQII)=RESULT_$C(30)
 ;
DONEC ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
NEWFC ;Create FAMILY HISTORY record
 NEW DIC,DA,DR,X,Y
 I $G(FHCDX)="" S BMXSEC="CONDITION value is required" Q
 S DIC="^AUPNFH(",DIC(0)="L",X=FHCDX,DIC("DR")=".02////"_DFN_";.03////^S X=DT;.09////"_$G(FHRIEN)_";.12////^S X=DT"
 K DO,DD D FILE^DICN
 S FHCIEN=+Y
 I 'FHCIEN S BMXSEC="Unable to create new FAMILY HISTORY RECORD"
 Q
 ;
DELR(FHRIEN) ;Delete a FAMILY HISTORY FAMILY MEMBERS record as well as any linked FAMILY HISTORY records
 ;
 NEW DIK,DA,RESULT
 ;
 I FHRIEN="" S RESULT=-1_U_"No FAMILY HISTORY FAMILY MEMBERS record passed in to delete" Q RESULT
 ;
 ;Verify that there are no linked conditions - If yes, cannot delete entry
 I $O(^AUPNFH("AE",FHRIEN,""))]"" S RESULT=-1_U_"This relation has conditions linked to it and cannot be deleted" Q RESULT
 ;
 ;Delete FAMILY HISTORY FAMILY MEMBERS record
 S RESULT=1_U
 S DIK="^AUPNFHR(",DA=FHRIEN D ^DIK
 Q RESULT
 ;
DELC(FHCIEN) ;Delete a FAMILY HISTORY record
 ;
 NEW DIK,DA,RESULT
 ;
 I FHCIEN="" S RESULT=-1_U_"No FAMILY HISTORY record passed in to delete" Q RESULT
 ;
 S RESULT=1_U
 S DIK="^AUPNFH(",DA=FHCIEN D ^DIK
 Q RESULT
