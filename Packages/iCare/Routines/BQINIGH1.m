BQINIGH1 ;VNGT/HS/ALA - iCare Nightly Job continued ; 11 Jun 2008  11:22 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
MEAS ;EP - Check for new Measurement Types in File #9999999.07
 NEW VFIEN,DSIEN,MSIEN,NAME,CODE,CHIEN,TEXT,BTAG,BQIXTYP,BIL,XCLLFH
 S VFIEN=$O(^BQI(90506.3,"B","Measurement","")) Q:VFIEN=""
 S DSIEN=$O(^BQI(90506.3,VFIEN,10,"B","Measurement","")) Q:DSIEN=""
 NEW DA,DIK
 S DA(2)=VFIEN,DA(1)=DSIEN,DA=0,DIK="^BQI(90506.3,"_DA(2)_",10,"_DA(1)_",5,"
 F  S DA=$O(^BQI(90506.3,VFIEN,10,DSIEN,5,DA)) Q:'DA  D ^DIK
 S MSIEN=0
 F  S MSIEN=$O(^AUTTMSR(MSIEN)) Q:'MSIEN  D
 . S NAME=$P(^AUTTMSR(MSIEN,0),U,2),CODE=$P(^AUTTMSR(MSIEN,0),U,1)
 . S CHIEN=$O(^BQI(90506.3,VFIEN,10,DSIEN,5,"B",NAME,""))
 . I CHIEN'="" Q
 . NEW DA,DIC,X
 . S DA(2)=VFIEN,DA(1)=DSIEN,X=NAME
 . S DIC="^BQI(90506.3,"_DA(2)_",10,"_DA(1)_",5,",DIC(0)="L"
 . K DO,DD D FILE^DICN
 . S DA=+Y
 . NEW IENS
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90506.315,IENS,.02)=CODE,BQIUPD(90506.315,IENS,.03)="Y"
 . S BQIUPD(90506.315,IENS,.04)="APCDTVAL"
 . I $E(CODE,1,3)="ASQ"!($E(NAME,1,3)="ASQ") S BQIUPD(90506.315,IENS,.05)=1
 . D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . S BQIXTYP="H"_CODE_"^AUPNVMS2"
 . I $T(@BQIXTYP)'="" D
 .. S BTAG="H"_CODE
 .. F BI=1:1 S BIL=$T(@(BTAG)+BI^AUPNVMS2) Q:BIL=""!($P(BIL,";;",1)'=" ")  S TEXT(BI)=$P(BIL,";;",2)
 .. I $D(TEXT)>0 D WP^DIE(90506.315,IENS,1,"","TEXT","ERROR")
 .. K TEXT,BI
 ;
DSPM ; EP - Find the official IHS provider categories
 NEW DSN,ABBRV,CODE,NSOURCE,NCAT,NCLIN,HDR,TEXT
 S DSN=0
 F  S DSN=$O(^BDPTCAT(DSN)) Q:'DSN  D
 . ;I $P(^BDPTCAT(DSN,0),U,7)'=1 Q
 . S ABBRV=$P(^BDPTCAT(DSN,0),U,2),CODE="BDP"_ABBRV
 . S NSOURCE="Patient",NCLIN="Specialty Providers",NCAT="Other Patient Data"
 . S HDR="T00030"_CODE
 . S TEXT=$P(^BDPTCAT(DSN,0),U,1)
 . I TEXT="DESIGNATED PRIMARY PROVIDER" Q
 . S TEXT=$$LOWER^VALM1(TEXT)
 . I $P(TEXT," ",1)="Hiv" D
 .. S TEXT="HIV "_$P(TEXT," ",2,99)
 . I $P(TEXT," ",1)="Ob" D
 .. S TEXT="OB "_$P(TEXT," ",2,99)
 . NEW DA,X,DIC,DLAYGO
 . S DIC="^BQI(90506.1,",DIC(0)="L",X=CODE
 . S DA=$O(^BQI(90506.1,"B",CODE,""))
 . I DA="" D  Q:$G(ERROR)=1
 .. K DO,DD D FILE^DICN
 .. S DA=+Y I DA=-1 S ERROR=1
 . S BQIUPD(90506.1,DA_",",.03)=TEXT
 . S BQIUPD(90506.1,DA_",",.08)=HDR
 . S BQIUPD(90506.1,DA_",",.15)=120
 . D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . S BQIUPD(90506.1,DA_",",3.01)=NSOURCE
 . S BQIUPD(90506.1,DA_",",3.02)=NCLIN
 . S BQIUPD(90506.1,DA_",",3.03)=NCAT
 . S BQIUPD(90506.1,DA_",",3.04)="Optional"
 . S BQIUPD(90506.1,DA_",",1)="S VAL=$P($$BPD^BQIULPT(DFN,STVW),U,2)"
 . D FILE^DIE("E","BQIUPD","ERROR")
 K BQIUPD
 ;
TMPL ; Set list for templates with |V | data objects
 K ^XTMP("BQITEMPL")
 S ^XTMP("BQITEMPL",0)=$$FMADD^XLFDT(DT,7)_U_DT_U_"Templates containing |V | data objects"
 NEW TMPN,BLN
 S TMPN=0
 F  S TMPN=$O(^TIU(8927,TMPN)) Q:'TMPN  D
 . S BLN=0
 . F  S BLN=$O(^TIU(8927,TMPN,2,BLN)) Q:'BLN  D
 .. I ^TIU(8927,TMPN,2,BLN,0)["|V " S ^XTMP("BQITEMPL",TMPN)=""
 ;
TRG ;Check for new Asthma Health Factor Triggers
 NEW ASCIEN,ASIEN,TEXT,CODE,ORD
 S ASCIEN=$O(^AUTTHF("B","ASTHMA TRIGGERS",0))
 I ASCIEN'="" D
 . S ASIEN=""
 . F  S ASIEN=$O(^AUTTHF("AC",ASCIEN,ASIEN)) Q:ASIEN=""  D
 .. I ASIEN=ASCIEN Q
 .. S TEXT=$P(^AUTTHF(ASIEN,0),U,1),CODE="AST_"_ASIEN
 .. S HDR="T00030"_CODE,NSOURCE="Asthma",NCLIN="",NCAT=""
 .. I TEXT["-" S TEXT=$$LOWER^VALM1($P(TEXT,"-",1))_"-"_$$LOWER^VALM1($P(TEXT,"-",2))
 .. I TEXT'["-" S TEXT=$$LOWER^VALM1(TEXT)
 .. NEW DA,X,DIC,DLAYGO
 .. S DIC="^BQI(90506.1,",DIC(0)="L",X=CODE
 .. S DA=$O(^BQI(90506.1,"B",CODE,""))
 .. ;I DA'="" S ORD=$P($G(^BQI(90506.1,DA,3)),U,5)
 .. I DA'="" S ORD=$O(^BQI(90506.1,"AD","A",""),-1)+1
 .. I DA="" D  Q:$G(ERROR)=1
 ... K DO,DD D FILE^DICN
 ... S DA=+Y I DA=-1 S ERROR=1
 ... S ORD=$O(^BQI(90506.1,"AD","A",""),-1)+1
 .. S BQIUPD(90506.1,DA_",",.03)=TEXT
 .. S BQIUPD(90506.1,DA_",",.08)=HDR
 .. S BQIUPD(90506.1,DA_",",.15)=120
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. ;
 .. S BQIUPD(90506.1,DA_",",3.01)=NSOURCE
 .. S BQIUPD(90506.1,DA_",",3.02)=NCLIN
 .. S BQIUPD(90506.1,DA_",",3.03)=NCAT
 .. S BQIUPD(90506.1,DA_",",3.04)="Optional"
 .. S BQIUPD(90506.1,DA_",",3.05)=ORD
 .. S BQIUPD(90506.1,DA_",",1)="S VAL=$$DSP^BQIRGASU(DFN,STVW)"
 .. S BQIUPD(90506.1,DA_",",5)="S HF=$P($P(^BQI(90506.1,STVW,0),U,1),""_"",2),VAL=$$HF^BQIDCUTL(DFN,HF),VISIT=$P(VAL,U,2),VAL=$$FMTE^BQIUL1($P(VAL,U,1))"
 .. D FILE^DIE("E","BQIUPD","ERROR")
 .. K BQIUPD
 .. S HELP(1)=TEXT_": Date of most recent Asthma Trigger (Health Factor)."
 .. D WP^DIE(90506.1,DA_",",4,"","HELP","ERROR")
 .. K HELP
 ;
 ;Set Flag To Track Whether External Tag Call Or Not
 S XCLLFH=1
 ;
FHDX ;EP - Sep up list of Family History Allowed DX codes
 ;
 N DATA,DSC,DUP,DX,FILE,IEN,II,SRT,TXT,Y
 ;
 S FILE=80
 S II=0,DATA=$NA(^XTMP("BQIFHDX"))
 S @DATA@(II)=$$FMADD^XLFDT(DT,7)_U_DT_U_"List of Family History Allowed DX Codes"
 K @DATA
 S DX=0 F  S DX=$O(^ICD9("AB",DX)) Q:DX=""  S IEN=0 F  S IEN=$O(^ICD9("AB",DX,IEN)) Q:'IEN  D
 . N FLG
 . I $G(^ICD9(IEN,0))="" Q
 . I $P($G(^ICD9(IEN,0)),"^",9) Q
 . S Y=IEN
 . D FHCHK^AUPNSICD I  S FLG=0
 . E  S FLG=1
 . Q:FLG
 . ;
 . ;Screen Out Duplicates
 . Q:$D(DUP(IEN))
 . S DUP(IEN)=""
 . ;
 . S TXT=$$GET1^DIQ(FILE,IEN_",",.01,"E") Q:TXT=""
 . S DSC=$$GET1^DIQ(FILE,IEN_",",3,"E")
 . S SRT(TXT)=IEN_"^"_TXT_"-"_DSC
 ;
 S TXT="" F  S TXT=$O(SRT(TXT)) Q:TXT=""  D
 . S II=II+1,@DATA@(II)=SRT(TXT)
 ;
 K DATA,DSC,DUP,DX,FILE,IEN,II,SRT,TXT,Y
 ;
 ;If Flag Isn't Set Tag Was Called Externally
 Q:'$G(XCLLFH)
 ;
COMM ;EP - Set up communities
 NEW CNME,CIEN,CSTE,CNTY,STCOCOMM,CCNT,IEN,DA,FILE,DATA
 NEW SCHK,SMULT,CCHK,CMULT,CSCMULT,CSTR,SGLOB
 S FILE=9999999.05
 S II=0,SGLOB=$NA(^XTMP("BQICOMMZ")),DATA=$NA(^XTMP("BQICOMM"))
 K @SGLOB,@DATA
 S @DATA@(II)=$$FMADD^XLFDT(DT,7)_U_DT_U_"Community Table List plus count of patients"
 S CIEN=0
 F  S CIEN=$O(^AUTTCOM(CIEN)) Q:'CIEN  D
 . S DA=CIEN,IEN=$$IENS^DILF(.DA)
 . ; Exclude Inactive Communities
 . I $P($G(^AUTTCOM(CIEN,88)),U,2)'="",$P($G(^(88)),U,2)'>DT Q
 . S CNME=$$GET1^DIQ(FILE,IEN,.01,"I")
 . S CNTY=$$GET1^DIQ(FILE,IEN,.02,"E")
 . S CSTE=$$GET1^DIQ(FILE,IEN,.03,"E")
 . S STCOCOMM=$$GET1^DIQ(FILE,IEN,.08,"E")
 . ; Set data into a 'sort' global.
 . S @SGLOB@(CNME,CSTE)=CIEN
 . S @SGLOB@(CNME,CSTE,CNTY,CIEN)=STCOCOMM
 . NEW CCIEN,CNT
 . S CCIEN="",CNT=0
 . F  S CCIEN=$O(^AUPNPAT("AC",CNME,CCIEN)) Q:CCIEN=""  D
 .. ;Exclude patients with no active HRNs
 .. I '$$HRN^BQIUL1(CCIEN) Q
 .. I $P($G(^AUPNPAT(CCIEN,11)),U,17)=CIEN  S CNT=CNT+1
 . S @SGLOB@("ZZCOUNT",CIEN)=CNT
 . Q
 ; Read through temporary TMP and create final TMP.
 S (CNME,CSTE,CNTY,CIEN)=""
 F  S CNME=$O(@SGLOB@(CNME)) Q:CNME=""  D
 . S (SCHK,SMULT)=0
 . F  S CSTE=$O(@SGLOB@(CNME,CSTE)) Q:CSTE=""  D
 .. ; Check for more than one state with same community name and flag it.
 .. I 'SCHK S SCHK=1 I $O(@SGLOB@(CNME,CSTE))'="" S SMULT=1
 .. ; If only one state for this Comm, set ^TMP and return to loop.
 .. I 'SMULT D  Q
 ... S CIEN=@SGLOB@(CNME,CSTE)
 ... S II=II+1,@DATA@(II)=CIEN_"^"_CNME_"^"_$G(@SGLOB@("ZZCOUNT",CIEN))
 ... ; More than one state for Comm, now loop thru and check for multiple counties.
 .. S (CCHK,CMULT)=0
 .. F  S CNTY=$O(@SGLOB@(CNME,CSTE,CNTY)) Q:CNTY=""  D
 ... I 'CCHK S CCHK=1 I $O(@SGLOB@(CNME,CSTE,CNTY))'=""  S CMULT=1
 ... ; Include county name with Comm and State only if more than 1 entry for Comm AND State.
 ... S CSTR=CNME_" ("_CSTE_$S(CMULT:"  "_CNTY,1:"")_")"
 ... ; Double check to make sure there are no multiple occurrances of Comm, State, AND County.
 ... S CSCMULT=""
 ... S CIEN=$O(@SGLOB@(CNME,CSTE,CNTY,""))
 ... I CIEN S CIEN=$O(@SGLOB@(CNME,CSTE,CNTY,CIEN)) S:CIEN CSCMULT=1
 ... S CIEN=""
 ... F  S CIEN=$O(@SGLOB@(CNME,CSTE,CNTY,CIEN)) Q:'CIEN  D
 .... S STCOCOMM=@SGLOB@(CNME,CSTE,CNTY,CIEN)
 .... S II=II+1,@DATA@(II)=CIEN_U_$S(CSCMULT:$P(CSTR,")")_$S('CMULT:"  "_CNTY,1:"")_"  "_STCOCOMM_")",1:CSTR)_U_@SGLOB@("ZZCOUNT",CIEN)
 K @SGLOB
 Q
 ;
AST ; Update all patients with any asthma data
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 I $G(DT)="" D DT^DICRW
 ;  Set the NIGHTLY ASTHMA STARTED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.22)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.24)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 NEW TAG,TGIEN,REG,SRIEN,SRC,RIEN,STAT,DFN,SRCIEN
 S TAG="Asthma",TGIEN=$$GDXN^BQITUTL(TAG)
 S REG=$P(^BQI(90506.2,TGIEN,0),U,8) I REG="" Q
 ; Get the source
 S SRIEN=$O(^BQI(90506.5,"D",REG,"")) I SRIEN="" Q
 S SRC=$P(^BQI(90506.5,SRIEN,0),U,2)
 S DFN=0
 F  S DFN=$O(^XTMP("BQINIGHT",DFN)) Q:'DFN  D
 . I $G(^BQIPAT(DFN,0))="" D NPT^BQITASK(DFN)
 . S SRCIEN=$O(^BQIPAT(DFN,60,"B",SRIEN,""))
 . I SRCIEN'="" D
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=SRCIEN
 .. S DIK="^BQIPAT("_DA(1)_",60,"
 .. D ^DIK
 . ; If patient is deceased, don't calculate
 . I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 . ; If patient has no active HRNs, quit
 . I '$$HRN^BQIUL1(DFN) Q
 . ; If patient has no visit in last 3 years, quit
 . I '$$VTHR^BQIUL1(DFN) Q
 . D PAT^BQIRGASP(DFN,SRC)
 ;
 ;  Set the NIGHTLY ASTHMA STOPPED field
 NEW DA
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.23)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.24)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
