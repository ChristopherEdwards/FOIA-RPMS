BQIVFVAL ;PRXM/HC/ALA-Validate VFILE data ; 10 Apr 2007  12:56 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
VAL(DATA,VDEF,PARMS) ;EP -- BQI VFILE DATA VALIDATION
 ;
 ;Input
 ;  VDEF  - The vdefinition name
 ;  VFILE - The vfile number or name
 ;  PARMS - The parameters being checked for validation
 ;
 NEW UID,II,BQ,LIST,BN,PDATA,NAME,VALUE,HDR,CODN,VALID,VALFLD,BI,VFLD,TYPE,X,RESULT
 NEW VFIEN,MSG,HNDLR,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIVFVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIVFVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S VDEF=$G(VDEF,"") I VDEF="" S BMXSEC="No VDef selected" Q
 S VFIEN=$$FIND1^DIC(90506.3,"","MOX",VDEF,"","","ERROR")
 S VFILE=$P(^BQI(90506.3,VFIEN,0),U,2)
 ;S VFILE=$G(VFILE,"") I VFILE="" S BMXSEC="No Vfile selected" Q
 ;S VFIEN=$$FIND1^DIC(90506.3,"","MO",VFILE,"","","ERROR")
 ;
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER^I00010IEN"_$C(30)
 ; Get list of parameters
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I PARMS="" S II=II+1,@DATA@(II)="1^"_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_$C(30) G DONE
 ; Parse parameters
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . S @NAME=VALUE
 . ; If value is BQIDFN, it exists at the PCC Visit level not individual
 . ; V File level.
 . I VFILE'=9000010&(NAME="BQIDFN"!(NAME="APCDDATE")) Q
 . S CODN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I CODN="" S BMXSEC="Parameter does not exist for this Vfile" Q
 . I $G(VALID)="" S VALID=$P($G(^BQI(90506.3,VFIEN,10,CODN,2)),U,2)
 . I $G(VALFLD)="" S VALFLD=$P($G(^BQI(90506.3,VFIEN,10,CODN,2)),U,1)
 ;
 ; Check that values exist for all fields needed for the validation
 F BI=1:1:$L(VALFLD,";") S VFLD=$P(VALFLD,";",BI) D
 . I VFLD["*" S VFLD=$$STRIP^XLFSTR(VFLD,"*") Q
 . I $G(@VFLD)="" S BMXSEC="Missing validation value for "_VFLD
 I $G(BMXSEC)'="" Q
 ;
 S VALID=$TR(VALID,"~","^"),RESULT=0
 ; Execute the validation tag
 D @VALID
 S II=II+1,@DATA@(II)=RESULT_U_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_$C(30)
 ; Clean up validation variables
 F BI=1:1:$L(VALFLD,";") D
 . S VFLD=$P(VALFLD,";",BI),VFLD=$$STRIP^XLFSTR(VFLD,"*")
 . K @VFLD
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MSR(TYPE,X) ;EP - Measurement validation
 ; Input
 ;   TYPE = Measurement choice (APCDTTYP)
 ;   X    = value of the measurement (APCDTVAL)
 ;
 NEW BQIXTYP,TTYPE
 S TTYPE=TYPE
 I TYPE?.N S TTYPE=$P(^AUTTMSR(TYPE,0),U,1)
 S BQIXTYP=TTYPE_"^AUPNVMSR"
 D @BQIXTYP
 I $G(X)="" S RESULT=-1 Q
 S RESULT=1
 Q
 ;
SKT(RESLT,READ) ;EP - Skin Test
 ;  Input
 ;     RESLT - Result (APCDTRES)
 ;     READ  - Reading (APCDTREA)
 ;  Output
 ;     RESULT=-1 didn't pass validation
 ;     RESULT=1  passed validation
 ;
 ; Only check validation if both values are populated
 I $G(RESLT)=""!($G(READ)="") S RESULT=1 Q
 ;
 ; If result is 'Negative' and result is greater than 10
 I $G(RESLT)="N"&($G(READ)>10) S RESULT=-1 Q
 ;
 I $G(RESLT)'="P"&($G(READ)>10) S RESULT=-1 Q
 ;
 S RESULT=1
 Q
 ;
EXM(EXAM,RESLT) ;EP - Exam result
 ;  Input
 ;    EXAM  - Exam Type
 ;    RESLT - The entered result
 ;
 I EXAM'?.N S EXAM=$$FIND1^DIC(9999999.15,"","B",EXAM,"","","ERROR")
 NEW C
 S C=$P(^AUTTEXAM(EXAM,0),U,2)
 I RESLT="PA",C'=34 S RESULT=-1 Q
 I RESLT="PR",C'=34 S RESULT=-1 Q
 I RESLT="A",C=34 S RESULT=-1 Q
 I RESLT="A",C=35 S RESULT=-1 Q
 I RESLT="A",C=36 S RESULT=-1 Q
 I RESLT="PO",(C'=35&(C'=36)) S RESULT=-1 Q
 S RESULT=1
 Q
 ;
LAB(TEST,RESLT) ;EP - Lab Result
 ;  Input
 ;    TEST  - Lab Test IEN
 ;    RESLT - The entered result
 ;
 ; Take out validation for a lab result for historical entry
 ; Allow them to enter anything they please
 S RESULT=1
 Q
 NEW WHERE,LDATA,X
 S WHERE=$P(^LAB(60,TEST,0),U,12)
 I WHERE="" S RESULT=1 Q
 S LDATA=U_WHERE_"0)"
 S EXEC=$P(@LDATA,U,5,99)
 S X=RESLT X EXEC
 I $G(X)="" S RESULT=-1 Q
 S RESULT=1
 Q
 ;
LOC(LOC) ; EP - Location
 ; Input
 ;   Location IEN
 S RESULT=1
 I $E($$GET1^DIQ(4,LOC_",",.01,"E"),1,5)="OTHER" D
 . I $P($G(^APCDSITE(DUZ(2),0)),U,16)'="Y" S RESULT=-1,MSG="Your site parameters file does not indicate outside location can be entered!" Q
 Q
 ;
VDT(VDAT,DFN) ; EP - Visit Date
 ; Input
 ;   VDAT - Visit date from APCDDATE
 ;   DFN  - Patient IEN
 S RESULT=1
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I")
 S DOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 S VDAT=$$DATE^BQIUL1(VDAT)
 ;
 I VDAT\1>DT S RESULT=-1,MSG="Future dates not valid" Q
 I VDAT\1<DOB S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^BQIUL1(DOB)_")" Q
 I DOD'="" D
 . I VDAT\1>DOD S RESULT=-1,MSG="Date cannot be after Date of Death ("_$$FMTE^BQIUL1(DOD)_")" Q
 Q
 ;
PDT(PDAT,VDAT,DFN) ; EP - Procedure Date
 ; Input
 ;   PDAT - Procedure date
 ;   VDAT - Visit date from APCDDATE
 ;   DFN  - Patient IEN
 S RESULT=1
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I")
 S DOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 S VDAT=$$DATE^BQIUL1(VDAT)
 S PDAT=$$DATE^BQIUL1(PDAT)
 ;
 I PDAT<(VDAT\1) S RESULT=-1,MSG="Procedure date cannot be before Visit date" Q
 I PDAT\1>DT S RESULT=-1,MSG="Future dates not valid" Q
 I PDAT\1<DOB S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^BQIUL1(DOB)_")" Q
 I DOD'="" D
 . I PDAT\1>DOD S RESULT=-1,MSG="Date cannot be after Date of Death ("_$$FMTE^BQIUL1(DOD)_")" Q
 Q
 ;
EPRV(APCDTPRO) ; EP - Education Provider
 S RESULT=1
 I $P($G(^VA(200,APCDTPRO,"PS")),U,4)'="" S RESULT=-1,MSG="The provider you selected is not an authorized provider for Patient Education entries."
 Q
 ;
HIVDT(DFN,BKMDXDT,BKMAIDT) ; EP - Initial HIV DX Date
 NEW X,AIDSDT,DOB,BKMIEN,BKMREG,BKMIENS,DA
 S RESULT=1
 I BKMDXDT="",BKMAIDT="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S AIDSDT=$$DATE^BQIUL1($G(BKMAIDT))
 ; $$GET1^DIQ(90451.01,BKMIENS,5.5,"I"))
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S X=$$DATE^BQIUL1(BKMDXDT)
 I DOB>X S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^BQIUL1(DOB)_")" Q
 I X>DT S RESULT=-1,MSG="Future dates not valid" Q
 I AIDSDT'="",X>AIDSDT S RESULT=-1,MSG="Initial HIV DX Date cannot be later than Initial AIDS DX Date" Q
 Q
 ;
AIDDT(DFN,BKMAIDT,BKMDXDT) ; EP - Initial AIDS DX Date
 NEW X,HIVDT,DOB,BKMIEN,BKMREG,BKMIENS,DA
 S RESULT=1
 I BKMAIDT="",BKMDXDT="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S HIVDT=$$DATE^BQIUL1($G(BKMDXDT))
 ;$$GET1^DIQ(90451.01,BKMIENS,5,"I")
 S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 S X=$$DATE^BQIUL1(BKMAIDT)
 I DOB>X S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^BQIUL1(DOB)_")" Q
 I X>DT S RESULT=-1,MSG="Future dates not valid" Q
 I HIVDT'="",X<HIVDT S RESULT=-1,MSG="Initial AIDS DX Date cannot be before the Initial HIV DX Date"
 Q
 ;
RDT(SKRDT) ; EP - Skin Test Reading Date
 S SKRDT=$$DATE^BQIUL1($G(SKRDT))
 I SKRDT\1>DT S RESULT=-1,MSG="Future dates not valid" Q
 S RESULT=1
 Q
 ;
BDT(VDAT,DFN) ; EP - Problem Date of Onset
 ; Input
 ;   VDAT - Visit date from APCDDATE
 ;   DFN  - Patient IEN
 S RESULT=1
 I VDAT="" Q
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I")
 S DOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 S VDAT=$$DATE^BQIUL1(VDAT)
 ;
 I VDAT\1>DT S RESULT=-1,MSG="Future dates not valid" Q
 I VDAT\1<DOB S RESULT=-1,MSG="Date cannot be before Date of Birth ("_$$FMTE^BQIUL1(DOB)_")" Q
 I DOD'="" D
 . I VDAT\1>DOD S RESULT=-1,MSG="Date cannot be after Date of Death ("_$$FMTE^BQIUL1(DOD)_")" Q
 Q
 ;
CLAS(DX,CLS) ; EP - Classification validation
 I $$VERSION^XPDUTL("BJPC")<2.0 S RESULT=1 Q
 NEW X,BQA,TX,LW,HG
 I CLS="" S RESULT=1 Q
 S X=CLS
 S BQA=0 F  S BQA=$O(^APCDPLCL(BQA)) Q:BQA'=+BQA!('$D(X))  D
 . S TX=$P(^APCDPLCL(BQA,0),U,2)
 . Q:TX=""
 . Q:'$D(^ATXAX(TX))
 . Q:'$$ICD^ATXCHK(DX,TX,9)  ;not in this taxonomy
 . S LW=$P(^APCDPLCL(BQA,0),U,3)
 . S HG=$P(^APCDPLCL(BQA,0),U,4)
 . I X<LW!(X>HG) K X
 . Q
 I $G(X)="" S RESULT=-1,MSG="Invalid selection" Q
 S RESULT=1
 Q
 ;
TXNM(AMQQTNAR) ; EP - Taxonomy name validation
 NEW AMQN
 S RESULT=1
 I AMQQTNAR="" S RESULT=-1,MSG="No name provided" Q
 I $D(^ATXAX("B",AMQQTNAR))>0 D  Q
 . S AMQN=$O(^ATXAX("B",AMQQTNAR,""))
 . I DUZ'=$P(^ATXAX(AMQN,0),U,5) S RESULT=-1,MSG="Name already exists and cannot be overwritten except by its creator." Q
 . S RESULT=-1,MSG="Replace existing taxonomy with this one?",HNDLR="O" Q
 Q
 ;
CPT(VDAT,NCPT) ; EP - CPT Code validation
 S RESULT=1
 S VDAT=$$DATE^BQIUL1(VDAT)
 I NCPT="" S RESULT=-1,MSG="No CPT code provided" Q
 I $P($$CPT^ICPTCOD(NCPT,VDAT),U,7)=0 S RESULT=-1,MSG="CPT Code not valid for this visit date" Q
 Q
 ;
IMP(VALUE) ; EP - Imprecise date validation
 S RESULT=1
 S VALUE=$$DATE^BQIUL1(VALUE)
 I VALUE="" S RESULT=-1,MSG="Invalid date" Q
 Q
