BQIUTB5 ;GDIT/HS/ALA-Table utilities ; 17 Dec 2014  9:14 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;;May 24, 2016;Build 27
 ;
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
 ... I NAME'=$P(^VA(200,IEN,0),U,1) Q
 ... I IEN\1'=IEN Q
 ... I $P($G(^VA(200,IEN,"PS")),U,4)'="",DT'>$P(^("PS"),U,4) Q
 ... ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0&$P(^(0),U,11)'>DT)!(+$P($G(^VA(200,IEN,0)),U,11)>0&$P(^(0),U,11)>DT) D
 ... I (+$P($G(^VA(200,IEN,0)),U,11)'>0)!(+$P($G(^VA(200,IEN,0)),U,11)'<DT) D
 .... I $G(FLAG)=1 S NAME=NAME_" ("_$$CLS(IEN)_")"
 .... S II=II+1,@DATA@(II)=IEN_"^"_NAME_$C(30)
 ;
 NEW IEN,NAME,PFLAG
 S IEN=.6
 F  S IEN=$O(^VA(200,IEN)) Q:'IEN  D
 . I $G(^VA(200,IEN,0))="" Q
 . I IEN\1'=IEN Q
 . ;I (+$P($G(^VA(200,IEN,0)),U,11)'>0&$P(^(0),U,11)'>DT)!(+$P($G(^VA(200,IEN,0)),U,11)>0&$P(^(0),U,11)>DT) D
 . I (+$P($G(^VA(200,IEN,0)),U,11)'>0)!(+$P($G(^VA(200,IEN,0)),U,11)'<DT) D
 .. S NAME=$$GET1^DIQ(200,IEN_",",.01,"E")
 .. I NAME="" Q
 .. S PFLAG=$S($D(^VA(200,"AK.PROVIDER",NAME,IEN)):"P",1:"")
 .. I $G(FLAG)=1 S NAME=NAME_" ("_$$CLS(IEN)_")"
 .. S II=II+1,@DATA@(II)=IEN_"^"_NAME_"^"_PFLAG_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PRCL(DATA) ;EP - Get providers with class
 D USR(.DATA,"P",1)
 Q
 ;
USCL(DATA) ;EP - Get users with class
 D USR(.DATA,"",1)
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
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
