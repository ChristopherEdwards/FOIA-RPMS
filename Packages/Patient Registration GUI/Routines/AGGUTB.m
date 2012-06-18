AGGUTB ;VNGT/HS/ALA-Table utilities ; 08 Apr 2010  3:45 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
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
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGUTB D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
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
 . S II=II+1,@DATA@(II)=IEN_"^"_TXT_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TAB(DATA,TEXT) ;  PEP -- AGG GET TABLE
 ;
 ;Description
 ;  Get the values of a table, including the internal entry
 ;  number and the text
 ;Input
 ;  TEXT - Value from parameter definition
 ;
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGTABLE",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGUTB D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I TEXT="PROV" D USR(.DATA,"P")
 ;
 I TEXT="COMM" D COMM(.DATA,9999999.05,0)
 I TEXT="COMMALL" D COMM(.DATA,9999999.05,1)
 ;
 I TEXT="CLIN" D TBL(.DATA,40.7,"")
 ;
 I TEXT="USER" D USR(.DATA,"")
 ;
 I TEXT="ILOC" D TBL(.DATA,9999999.06,"0;21")
 ;
 ;I TEXT="VFILE" D VFL(.DATA,"V")
 I TEXT="WINDOW" D VFL(.DATA,"C")
 ;
 I TEXT="COMMTX" D COMMTX(.DATA)
 ;
 I TEXT="BEN" D BEN(.DATA)
 ;
 I TEXT="FH9999999.36" D FHREL(.DATA)
 ;
 I TEXT="INS" D INS(.DATA)
 ;
 K TEXT
 Q
 ;
USR(DATA,TYPE) ;EP - Go through the User File
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
 ... I +$P($G(^VA(200,IEN,0)),U,11)'>0,$P(^(0),U,11)'>DT D
 .... S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 ;
 NEW IEN,NAME,PFLAG
 S IEN=.6
 F  S IEN=$O(^VA(200,IEN)) Q:'IEN  D
 . I $G(^VA(200,IEN,0))="" Q
 . I IEN\1'=IEN Q
 . I +$P($G(^VA(200,IEN,0)),U,11)'>0,$P(^(0),U,11)'>DT D
 .. S NAME=$$GET1^DIQ(200,IEN_",",.01,"E")
 .. I NAME="" Q
 .. S PFLAG=$S($D(^VA(200,"AK.PROVIDER",NAME,IEN)):"P",1:"")
 .. S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_PFLAG_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
COMM(DATA,FILE,FLAG) ;EP - Get the Community Table
 NEW CIEN
 S II=0
 S @DATA@(II)="I00010IEN^T00050"_$C(30)
 ;
 S CIEN=0
 F  S CIEN=$O(^AUTTCOM(CIEN)) Q:'CIEN  D
 . I $P(^AUTTCOM(CIEN,0),U,18)'="" Q
 . S II=II+1,@DATA@(II)=CIEN_U_$P(^AUTTCOM(CIEN,0),U,1)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
INS(DATA) ; EP - Get Insurance Table
 NEW IIEN,IENS,II
 S II=0
 S @DATA@(II)="I00010IEN^T00030NAME^T00030STREET^T00015CITY^T00030STATE^T00010ZIP^T00025TYPE^T00013PHONE"_$C(30)
 S IIEN=0
 F  S IIEN=$O(^AUTNINS(IIEN)) Q:'IIEN  D
 . I $P($G(^AUTNINS(IIEN,1)),"^",7)=0 Q
 . S INS=^AUTNINS(IIEN,0)
 . S ST=$P(INS,U,4) I ST'="" S ST=$P(^DIC(5,ST,0),U,1)
 . S II=II+1,@DATA@(II)=IIEN_U_$P(INS,U,1)_U_$P(INS,U,2)_U_$P(INS,U,3)_U_ST_U_$P(INS,U,5)_U_$P($G(^AUTNINS(IIEN,2)),U,1)_U_$P(INS,U,6)_$C(30)
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
VFL(DATA,FTYP) ;EP - Get list of Vfiles
 S II=0
 S @DATA@(II)="I00010IEN^T00030^T00100SORT_ORDER^T00100SORT_DIR^T00001FILTER"_$C(30)
 NEW IEN,IACT,SORT,SN,SIEN,COLMN,SDIR,DIR
 S IEN=0
 F  S IEN=$O(^AGG(9009068.3,"D",FTYP,IEN)) Q:'IEN  D
 . ; If Window entry is flagged 'Do not display or extract', quit
 . I +$$GET1^DIQ(90506.3,IEN_",",.05,"I") Q
 . S II=II+1
 . S IACT=$$GET1^DIQ(90506.3,IEN_",",.03,"I")
 . S NAME=$$GET1^DIQ(90506.3,IEN_",",.01,"E")
 . ; If a sub-definition, do not pull
 . I $$GET1^DIQ(90506.3,IEN_",",.07,"I")=1 Q
 . S FILTER=$S($D(^AGG(9009068.3,IEN,7)):"Y",1:"N")
 . ;
 . ; Get Sort Order
 . S SORT="",SN="",SDIR=""
 . F  S SN=$O(^AGG(9009068.3,IEN,10,"D",SN)) Q:SN=""  D
 .. S SIEN=""
 .. F  S SIEN=$O(^AGG(9009068.3,IEN,10,"D",SN,SIEN)) Q:SIEN=""  D
 ... ; If the field is inactive, quit
 ... I $P(^AGG(9009068.3,IEN,10,SIEN,0),U,11)=1 Q
 ... S COLMN=$P(^AGG(9009068.3,IEN,10,SIEN,0),U,2)
 ... S DIR=$P(^AGG(9009068.3,IEN,10,SIEN,0),U,13)
 ... ; Strip off the size and only keep the name
 ... S COLMN=$E(COLMN,7,$L(COLMN))
 ... S SORT=SORT_COLMN_$C(29)
 ... S SDIR=SDIR_DIR_$C(29)
 . S SORT=$$TKO^AGGUL1(SORT,$C(29))
 . S SDIR=$$TKO^AGGUL1(SDIR,$C(29))
 . S @DATA@(II)=IEN_U_$S(IACT=1:"*",1:"")_NAME_U_SORT_U_SDIR_U_FILTER_$C(30)
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
