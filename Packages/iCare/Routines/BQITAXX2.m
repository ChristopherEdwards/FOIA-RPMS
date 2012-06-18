BQITAXX2 ;PRXM/HC/ALA - Add Taxonomy Item ; 26 May 2006  2:00 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
ADD(DATA,TVALUE,LOW,HIGH) ;EP -- BQI ADD TAXONOMY ITEM
 ;
 ;Input
 ;  TVALUE - Taxonomy pointer
 ;  LOW    - Low value
 ;  HIGH   - High value
 ;
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXADD",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX2 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I '$$KEYCHK^BQIULSC("BQIZTXED",DUZ) S BMXSEC="You do not have the security access to edit a taxonomy."_$C(10)_"Please see your supervisor or program manager." Q
 ;I '$$KEYCHK^BQIULSC("BGPZ TAXONOMY EDIT",DUZ) S BMXSEC="You do not have the security access to edit a taxonomy."_$C(10)_"Please see your supervisor or program manager." Q
 ;
 S TVALUE=$G(TVALUE,""),LOW=$G(LOW,""),HIGH=$G(HIGH,"")
 I TVALUE="" S BMXSEC="No taxonomy identified" Q
 I LOW="" S BMXSEC="No LOW value submitted" Q
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW FILE,SBFILE,DA,DIC,Y,RESULT,BQIUPD,CANON,IEN
 S FILE=$$GREF^BQITAXX(TVALUE),IEN=$P(TVALUE,";",1),CANON=0
 I FILE=9002226 S SBFILE=FILE_".02101",CANON=$$GET1^DIQ(FILE,IEN_",",.13,"I")
 I FILE=9002228 S SBFILE=FILE_".04101"
 I CANON D
 . I LOW["."!($E(LOW,1,1)="0")!($E(LOW,$L(LOW),$L(LOW))=0) S LOW=LOW_" "
 . I HIGH["."!($E(HIGH,1,1)="0")!($E(HIGH,$L(HIGH),$L(HIGH))=0) S HIGH=HIGH_" "
 ;
 S DA(1)=$P(TVALUE,";",1),DIC="^"_$P(TVALUE,";",2)_DA(1)_",21,"
 S DIC(0)="L",X=LOW
 K DO,DD D FILE^DICN
 I Y<1 S RESULT=-1
 I +Y>0 S RESULT=1,DA=+Y D
 . NEW IENS
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(SBFILE,IENS,.02)=$S(HIGH'="":HIGH,1:LOW)
 . I FILE=9002228 D  ; Updated by/date are unique to ^ATXLAB
 .. S BQIUPD(FILE,DA(1)_",",.05)=DUZ
 .. S BQIUPD(FILE,DA(1)_",",.06)=DT
 . D FILE^DIE("","BQIUPD","ERROR")
 . K BQIUPD
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 Q
 ;
LKP(DATA,TVALUE,FNBR,VALUE) ;EP -- BQI LOOKUP TAXONOMY ITEM
 ;
 ;Input
 ;  TVALUE - Taxonomy pointer
 ;  FNBR  - File number to look up value
 ;  VALUE - Value to look up in File number
 ;
 NEW UID,II,X
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXLKP",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX2 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S FNBR=$G(FNBR,""),VALUE=$G(VALUE,""),TVALUE=$G(TVALUE,"")
 I TVALUE="" S BMXSEC="No taxonomy identified" Q
 I VALUE="" S BMXSEC="No value to look up" Q
 ;
 ; if there were no values in the taxonomy before, there may not be
 ; a file number passed so determine it from taxonomy
 I FNBR="" D
 . NEW IEN,FILE,ROOT,FLD
 . S IEN=$P(TVALUE,";",1),FILE=$$GREF^BQITAXX(TVALUE),ROOT=$$ROOT^DILFD(FILE,"",1)
 . I FILE=9002226 S FLD=".15"
 . I FILE=9002228 S FLD=".09"
 . S FNBR=$$GET1^DIQ(FILE,IEN,FLD,"I")
 I FNBR="" S BMXSEC="No file identified to search for value" Q
 ;
 NEW FILE,FIELD,XREF,FLAGS,NUMB,SCREEN,JJ,IEN,TEXT,DESC
 NEW MAP,HDR,MII,NFLD,TYPE,VERSION
 S FILE=FNBR,XREF="",NUMB="*",SCREEN="",VERSION=$$VERSION^XPDUTL("PSS")
 ;S FIELD=".01"
 S FIELD="FID;-WID"
 I FNBR=50,VERSION'="" S FIELD=FIELD_";31"
 I FNBR=50,VERSION="" S FIELD=".01"
 ;S FLAGS=$S(FILE=95.3:"P",1:"MP")
 S FLAGS="MP"
 D FIND^DIC(FILE,"",FIELD,FLAGS,VALUE,"",XREF,SCREEN,"","","ERROR")
 ;
 S MAP=$G(^TMP("DILIST",$J,0,"MAP"))
 I FNBR=50,VERSION="" S MAP="IEN^.01I^100^31"
 I MAP="" S @DATA@(II)="I00010IEN^T00030TEXT^T00120DESCRIPTION"_$C(30)
 I MAP'="" D
 . S HDR=""
 . F MII=1:1:$L(MAP,"^") D
 .. I $P(MAP,"^",MII)="IEN" S HDR=HDR_"I00010IEN^" Q
 .. I $P(MAP,"^",MII)[".01" D CHK(.01) S HDR=HDR_TYPE_"^" Q
 .. S NFLD=$P(MAP,"^",MII)
 .. I NFLD["FID(" S NFLD=$P($P(NFLD,"FID(",2),")",1) D CHK(NFLD) S HDR=HDR_TYPE_"^" Q
 .. D CHK(NFLD) S HDR=HDR_TYPE_"^"
 . S HDR=$$TKO^BQIUL1(HDR,"^")
 . I FNBR=9999999.05 F MII=1:1:$L(HDR,"^") D
 .. I $P(HDR,"^",MII)="T00003CODE" S $P(HDR,"^",MII)="T00003COMM_CODE"
 .. I $P(HDR,"^",MII)="T00030NAME" S $P(HDR,"^",MII)="T00030COMM_NAME"
 . S @DATA@(II)=HDR_$C(30)
 S JJ=0
 F  S JJ=$O(^TMP("DILIST",$J,JJ)) Q:'JJ  D
 . I MAP="" D
 .. S IEN=$P(^TMP("DILIST",$J,JJ,0),U,1)
 .. S TEXT=$P(^TMP("DILIST",$J,JJ,0),U,2)
 .. S DESC=""
 .. S FLD=$S(FNBR=80:3,FNBR=80.1:4,FNBR=81:2,FNBR=9999999.31:.02,1:"")
 .. I FLD'="" S DESC=$$GET1^DIQ(FNBR,IEN,FLD,"E")
 .. S II=II+1,@DATA@(II)=IEN_"^"_TEXT_"^"_DESC_$C(30)
 . I MAP'="" D
 .. S II=II+1,@DATA@(II)=^TMP("DILIST",$J,JJ,0)_$C(30)
 ;
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
CHK(BFLD) ;EP - Check for definition of a field
 NEW DLEN
 D FIELD^DID(FNBR,BFLD,"","TYPE","BQX")
 D FIELD^DID(FNBR,BFLD,"","FIELD LENGTH","BQX")
 D FIELD^DID(FNBR,BFLD,"","LABEL","BQX")
 S TYPE=$S(BQX("TYPE")["DATE":"D",1:"T")
 S DLEN=BQX("FIELD LENGTH")
 S TYPE=TYPE_$E("00000",$L(DLEN)+1,5)_DLEN_BQX("LABEL")
 K BQX
 Q
