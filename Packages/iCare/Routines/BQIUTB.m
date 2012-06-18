BQIUTB ;PRXM/HC/ALA-Table utilities ; 02 Nov 2005  2:52 PM
 ;;2.2;ICARE MANAGEMENT SYSTEM;;Jul 28, 2011;Build 37
 ;
 Q
 ;
TBL(DATA,FILE,INAC) ;EP - Generic table retrieve function
 ;
 ;Description
 ;  Return the values in a table
 ;Input
 ;  FILE - FileMan file number where table resides
 ;  INAC - If file has an inactive field to check, contains
 ;         the node and piece in 'NODE;PIECE' format
 ;  
 NEW GLBREF,IEN,LENGTH,TEST1,DLEN,PEC,NODE,X,TXT
 S INAC=$G(INAC,"")
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I '$$VFILE^DILFD(FILE) S BMXSEC="Table doesn't exist in RPMS" Q
 ;
 S GLBREF=$$ROOT^DILFD(FILE,"",1)
 S LENGTH=$$GET1^DID(FILE,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_$C(30)
 ;
 I INAC'="" S NODE=$P(INAC,";",1),PEC=$P(INAC,";",2)
 S IEN=0
 F  S IEN=$O(@GLBREF@(IEN)) Q:'IEN  D
 . I $G(@GLBREF@(IEN,0))="" Q
 . I INAC'="",$P($G(@GLBREF@(IEN,NODE)),"^",PEC)'="" Q
 . S TXT=$$GET1^DIQ(FILE,IEN_",",.01,"E")
 . I FILE=90360.3 D
 .. S TXT=$$LOWER^VALM1(TXT)
 .. I $P(TXT," ",1)="Hiv" D
 ... S TXT="HIV "_$P(TXT," ",2,99)
 .. I $P(TXT," ",1)="Ob" D
 ... S TXT="OB "_$P(TXT," ",2,99)
 . S II=II+1,@DATA@(II)=IEN_"^"_TXT_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TAB(DATA,TEXT) ;  PEP -- BQI GET TABLE
 ;
 ;Description
 ;  Get the values of a table, including the internal entry
 ;  number and the text
 ;Input
 ;  TEXT - Value from parameter definition
 ;
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITABLE",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I TEXT="PROV" D USR(.DATA,"P")
 I TEXT="MPROV" D PRCL(.DATA)
 ;
 I TEXT="COMM" D COMM(.DATA,9999999.05,0)
 I TEXT="COMMALL" D COMM(.DATA,9999999.05,1)
 ;
 I TEXT="CLIN" D TBL(.DATA,40.7,"")
 ;
 I TEXT="SPEC" D TBL(.DATA,90360.3,"")
 ;
 I TEXT="HLOC" D LOC(.DATA,1)
 I TEXT="HLOCALL" D LOC(.DATA,1)
 ;
 I TEXT="USER" D USR(.DATA,"")
 ;
 I TEXT="REG" D REG(.DATA)
 ;
 I TEXT="ILOC" D TBL(.DATA,9999999.06,"0;21")
 ;
 I TEXT="CMT" D CMT(.DATA)
 ;
 I TEXT="TSTAT" D TSTA(.DATA)
 ;
 I TEXT="DIAG" D TBL(.DATA,80,"0;11")
 ;
 I TEXT="MED" D TBL(.DATA,50,"I;1")
 ;
 I TEXT="PCAT" D TBL(.DATA,90360.3,"")
 ;
 I TEXT="VIEW" D VW(.DATA)
 ;
 I TEXT="DXCAT" D DCT(.DATA)
 ;
 I TEXT="VFILE" D VFL^BQIUTB2(.DATA,"V")
 ;
 I TEXT="VOTHER" D VFL^BQIUTB2(.DATA,"O")
 ;
 I TEXT="APSTAT" D APST^BQIUTB2(.DATA)
 ;
 I TEXT="COMMTX" D COMMTX(.DATA)
 ;
 I TEXT="TABS" D TBS(.DATA)
 ;
 I TEXT="BEN" D BEN(.DATA)
 ;
 I TEXT="CARE" D CRM(.DATA)
 ;
 I TEXT="PERS" D EPLIST^BQIUTB2(.DATA)
 ;
 I TEXT="FILTER" D FLTR^BQIUTB2(.DATA)
 ;
 I TEXT="ALLERGIES" D ALG^BQIUTB3(.DATA)
 ;
 I TEXT="UCLASS" D UCL^BQIUTB2(.DATA)
 ;
 I TEXT="FH80" D FH80(.DATA)
 ;
 I TEXT="FH9999999.36" D FHREL(.DATA)
 ;
 K TEXT
 Q
 ;
USR(DATA,TYPE,FLAG) ;EP - Go through the User File
 ;
 ;Input
 ;  TYPE - "P" is for provider, otherwise it's a regular user
 ;
 S II=0
 S LENGTH=$$GET1^DID(200,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00001PROVIDER"_$C(30)
 ;
 I TYPE="P" D  G DONE
 . NEW NAME,IEN
 . S NAME=""
 . F  S NAME=$O(^VA(200,"AK.PROVIDER",NAME)) Q:NAME=""  D
 .. S IEN=""
 .. F  S IEN=$O(^VA(200,"AK.PROVIDER",NAME,IEN)) Q:IEN=""  D
 ... I $G(^VA(200,IEN,0))="" Q
 ... I IEN\1'=IEN Q
 ... I $P($G(^VA(200,IEN,"PS")),U,4)'="",DT'>$P(^("PS"),U,4) Q
 ... I +$P($G(^VA(200,IEN,0)),U,11)'=0,$P(^(0),U,11)'>DT Q
 ... I $G(FLAG)=1 S NAME=NAME_" ("_$$CLS(IEN)_")"
 ... S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 ;
 NEW IEN,NAME,PFLAG
 S IEN=.6
 F  S IEN=$O(^VA(200,IEN)) Q:'IEN  D
 . I $G(^VA(200,IEN,0))="" Q
 . I IEN\1'=IEN Q
 . I +$P($G(^VA(200,IEN,0)),U,11)'=0,$P(^(0),U,11)'>DT Q
 . S NAME=$$GET1^DIQ(200,IEN_",",.01,"E")
 . I NAME="" Q
 . S PFLAG=$S($D(^VA(200,"AK.PROVIDER",NAME,IEN)):"P",1:"")
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_PFLAG_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PRCL(DATA) ;EP - Get providers with class
 D USR(.DATA,"P",1)
 Q
 ;
CLS(PR) ; Get user classification
 S USN="",TYPE=""
 F  S USN=$O(^USR(8930.3,"B",PR,USN),-1) Q:USN=""  D
 . I '$$CURRENT^USRLM(USN) Q
 . S TYPE=$P(^USR(8930.3,USN,0),U,2)
 . I TYPE'="" S TYPE=$S($P($G(^USR(8930,TYPE,0)),U,4)'="":$P($G(^USR(8930,TYPE,0)),U,4),1:$P($G(^USR(8930,TYPE,0)),U,1))
 Q TYPE
 ;
LOC(DATA,FLAG) ;EP - Get table of hospital locations
 S II=0
 S LENGTH=$$GET1^DID(44,.01,"","FIELD LENGTH","TEST1","ERR")
 S DLEN=$E("00000",$L(LENGTH)+1,5)_LENGTH
 S @DATA@(II)="I00010IEN^T"_DLEN_"^T00002CLIN_CODE"_$C(30)
 S IEN=0
 F  S IEN=$O(^SC(IEN)) Q:'IEN  D
 . I $G(^SC(IEN,0))="" Q
 . ; If the clinic is inactive, show it with a '*'
 . I FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" S II=II+1,@DATA@(II)=IEN_"^"_$$GET1^DIQ(44,IEN_",",.01,"E")_" *"_$C(30) Q
 . I 'FLAG,$P($G(^SC(IEN,"I")),U,1)'="",$P($G(^SC(IEN,"I")),U,1)'>DT,$P($G(^SC(IEN,"I")),U,2)="" Q
 . S II=II+1,@DATA@(II)=IEN_"^"_$$GET1^DIQ(44,IEN_",",.01,"E")_"^"_$$PTR^BQIUL2(44,8,$$GET1^DIQ(44,IEN_",",8,"I"),1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CMT(DATA) ;EP - Get the table of comments that users can select from
 NEW FLAG
 S II=0
 S @DATA@(II)="I00010IEN^T00030^T00001FLAG^T00010ASSOC_STATUS^T00001DISPLAY_ORDER"_$C(30)
 S IEN=0
 F  S IEN=$O(^BQI(90509.1,IEN)) Q:'IEN  D
 . I $P(^BQI(90509.1,IEN,0),U,2)=1 Q
 . S FLAG=$S($P(^BQI(90509.1,IEN,0),U,3)=1:"Y",1:"N")
 . S II=II+1,@DATA@(II)=IEN_"^"_$$GET1^DIQ(90509.1,IEN_",",.01,"E")_"^"_FLAG_"^"_$$GET1^DIQ(90509.1,IEN_",",.04,"E")_"^"_$$GET1^DIQ(90509.1,IEN_",",.05,"E")_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TSTA(DATA) ;EP - Get the table of tag statuses
 NEW FLAG,VALUE,BJ,CODE,TEXT
 S II=0
 S @DATA@(II)="T00001CODE^T00030^T00001FLAG"_$C(30)
 S VALUE=$P(^DD(90509,.03,0),U,3)
 F BJ=1:1:$L(VALUE,";") D
 . S CODE=$P(VALUE,";",BJ) Q:CODE=""
 . S TEXT=$P(CODE,":",2)
 . S II=II+1,@DATA@(II)=$P(CODE,":",1)_"^"_TEXT_"^"_$S(BJ<4:"Y",1:"N")_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TBS(DATA) ;EP - Get a list of GUI tabs
 NEW ORD,IEN
 S II=0
 S @DATA@(II)="I00010IEN^T00030TAB_NAME^T00030TAB_KEY^T00015TAB_TYPE"_$C(30)
 S ORD=""
 F  S ORD=$O(^BQI(90506.4,"AC",ORD)) Q:ORD=""  D
 . S IEN=$O(^BQI(90506.4,"AC",ORD,"")) Q:'$D(^BQI(90506.4,IEN,0))
 . I $P(^BQI(90506.4,IEN,0),U,4)=1 Q
 . S II=II+1,@DATA@(II)=IEN_U_$P(^BQI(90506.4,IEN,0),U,1)_U_$P(^(0),U,2)_U_$$GET1^DIQ(90506.4,IEN_",",.03,"E")_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
VW(DATA) ;EP - Get the table of customized views
 NEW BQILOC,LII
 D EN^BQIMSLST(.BQILOC,"D")
 S LII=$O(@BQILOC@(""),-1)
 F II=0:1:LII-1 S @DATA@(II)=@BQILOC@(II)
 S II=II+1,@DATA@(II)=$C(31)
 K @BQILOC
 Q
 ;
DCT(DATA) ;EP - Get the table of diagnoses categories
 S II=0
 S @DATA@(II)="I00010IEN^T00031^I00010FILE_DEFN_IEN"_$C(30)
 NEW IEN,IACT,REG,REGFL,REGIEN
 S IEN=0
 F  S IEN=$O(^BQI(90506.2,IEN)) Q:'IEN  D
 . I $$GET1^DIQ(90506.2,IEN_",",.05,"I") Q
 . S II=II+1,REGIEN=""
 . S IACT=$$GET1^DIQ(90506.2,IEN_",",.03,"I")
 . S NAME=$$GET1^DIQ(90506.2,IEN_",",.01,"E")
 . ; Return ien for file 90506.3 based on associated register ien
 . S REG=$$GET1^DIQ(90506.2,IEN_",",.08,"I")
 . I REG'="" D
 .. S REGFL=$$GET1^DIQ(90507,REG_",",.02,"I")
 .. I REGFL'="" S REGIEN=$O(^BQI(90506.3,"C",REGFL,""))
 . S @DATA@(II)=IEN_"^"_$S(IACT=1:"*",1:"")_NAME_"^"_REGIEN_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
REG(DATA) ;EP - Get the table of registers
 NEW II,IEN,NAME,SREG,RLTD,STAT
 S II=0
 S @DATA@(II)="I00010REG_IEN^T00030REG_NAME^T00001SUB_REG^T00030RELATED_TO^T00001STATUS"_$C(30)
 S IEN=0
 F  S IEN=$O(^BQI(90507,IEN)) Q:'IEN  D
 . ; If the register is not active, quit
 . I $$GET1^DIQ(90507,IEN_",",.08,"I") Q
 . S NAME=$$GET1^DIQ(90507,IEN_",",.01,"E")
 . S SREG=$$GET1^DIQ(90507,IEN_",",.11,"I")
 . S RLTD=$$GET1^DIQ(90507,IEN_",",.17,"I")
 . S STAT=$$GET1^DIQ(90507,IEN_",",.14,"E")
 . S STAT=$S(STAT="":"N",1:"Y")
 . S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_SREG_"^"_RLTD_"^"_STAT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
COMM(DATA,FILE,FLAG) ;EP - Get the Community Table
 NEW CIEN
 S II=0
 S @DATA@(II)="I00010IEN^T00050^T00005COUNT"_$C(30)
 ;
 I $O(^XTMP("BQICOMM",0))="" D COMM^BQINIGH1
 S CIEN=0
 F  S CIEN=$O(^XTMP("BQICOMM",CIEN)) Q:'CIEN  D
 . I 'FLAG,$P(^XTMP("BQICOMM",CIEN),U,3)=0 Q
 . S II=II+1,@DATA@(II)=^XTMP("BQICOMM",CIEN)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FH80(DATA) ;EP - Get the Family History Version Subset of File 80
 NEW IEN,II
 S II=0
 S @DATA@(II)="I00010IEN^T00127"_$C(30)
 ;
 I $O(^XTMP("BQIFHDX",0))="" D FHDX^BQINIGH1
 S IEN=0
 F  S IEN=$O(^XTMP("BQIFHDX",IEN)) Q:'IEN  D
 . S II=II+1,@DATA@(II)=^XTMP("BQIFHDX",IEN)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FHREL(DATA) ;EP - Get the Family History Version Subset of File 9999999.36
 ;
 NEW IEN,II,REL
 ;
 S II=0
 ;
 S @DATA@(II)="I00010IEN^T00070"_$C(30)
 ;
 S REL="" F  S REL=$O(^AUTTRLSH("B",REL)) Q:REL=""  S IEN="" F  S IEN=$O(^AUTTRLSH("B",REL,IEN)) Q:'IEN  D
 . N N,PCC
 . S N=$G(^AUTTRLSH(IEN,0))
 . I $P(N,U,6)=1 Q  ; Quit if inactive
 . S PCC=$P($G(^AUTTRLSH(IEN,21)),U) Q:PCC'=1  ;Filter on USE FOR PCC FAMILY HISTORY field
 . S II=II+1,@DATA@(II)=IEN_U_$P(N,U)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
COMMTX(DATA) ;EP - Get list of Community Taxonomies
 N TAXIEN,TYPE,COM,ITEM,OK,COMTXNM
 S TAXIEN=0
 S @DATA@(II)="I00010IEN^T00050COMM_TAX_NAME"_$C(30)
 F  S TAXIEN=$O(^ATXAX(TAXIEN)) Q:'TAXIEN  D
 . S TYPE=$P($G(^ATXAX(TAXIEN,0)),"^",15) Q:TYPE'=9999999.05
 . S ITEM=0,OK=0
 . F  S ITEM=$O(^ATXAX(TAXIEN,21,ITEM)) Q:'ITEM  D  Q:OK
 .. S COM=$P(^ATXAX(TAXIEN,21,ITEM,0),U) Q:COM=""
 .. I '$D(^AUTTCOM("B",COM)) Q
 .. S COMTXNM=$$GET1^DIQ(9002226,TAXIEN,.01,"I"),OK=1
 .. S II=II+1,@DATA@(II)=TAXIEN_"^"_COMTXNM_$C(30)
 .. D UPD^BQITAXX4(COMTXNM,"","CM",7)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
BEN(DATA) ;EP - Get list of Beneficiary Codes
 N BENIEN,NAME,CODE
 S BENIEN=0
 S @DATA@(II)="I00010IEN^T00050"_$C(30)
 F  S BENIEN=$O(^AUTTBEN(BENIEN)) Q:'BENIEN  D
 . I '$D(^AUTTBEN(BENIEN,0)) Q
 . S NAME=$P(^AUTTBEN(BENIEN,0),"^")
 . S II=II+1,@DATA@(II)=BENIEN_"^"_NAME_$C(30) ;_"^"_CODE_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CRM(DATA) ;EP - Care Management Layout Sources
 NEW CIEN,TGIEN,RGIEN,REG,TAG,FMIEN,FORM,VIEW,REM,REPORT
 S @DATA@(II)="I00010IEN^T00030LAYOUT^T00030FORM^T00030TAG^I00010TAG_IEN^T00030REGISTER^T00001PAT_VIEW^T00001REMINDERS^T00030REPORT"_$C(30)
 S CIEN=0
 F  S CIEN=$O(^BQI(90506.5,CIEN)) Q:'CIEN  D
 . I $P(^BQI(90506.5,CIEN,0),U,4)'=1 Q
 . S RGIEN=$P(^BQI(90506.5,CIEN,0),U,3)
 . I RGIEN'="" S REG=$$GET1^DIQ(90507,RGIEN_",",.01,"E")
 . I RGIEN'="" S TGIEN=$O(^BQI(90506.2,"AD",RGIEN,""))
 . I $G(TGIEN)'="" S TAG=$$GET1^DIQ(90506.2,TGIEN_",",.01,"E")
 . S FMIEN=$O(^BQI(90506.3,"AC",CIEN,""))
 . I FMIEN'="",$P(^BQI(90506.3,FMIEN,0),U,3)'=1 S FORM=$$GET1^DIQ(90506.3,FMIEN_",",.01,"E")
 . ;S VIEW=$S($P(^BQI(90506.5,CIEN,0),U,7)'="":"Y",1:"N")
 . S REM=$S($P(^BQI(90506.5,CIEN,0),U,5)'="":"Y",1:"N")
 . S REPORT=$P(^BQI(90506.5,CIEN,0),U,8)
 . S VIEW=$S($G(FORM)'="":"F",$G(REPORT)'="":"R",1:"")
 . S II=II+1,@DATA@(II)=CIEN_U_$P(^BQI(90506.5,CIEN,0),U,1)_U_$G(FORM)_U_$G(TAG)_U_$G(TGIEN)_U_$G(REG)_U_$G(VIEW)_U_$G(REM)_U_$G(REPORT)_$C(30)
 . K REG,TGIEN,TAG,FMIEN,FORM,VIEW,RGIEN
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
