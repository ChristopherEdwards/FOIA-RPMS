BQIRGLST ;VNGT/HS/ALA - Get register view ; 18 May 2007  2:25 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
GET(DATA,REG) ;EP -- BQI GET REGISTER LIST
 NEW UID,II,BQILOC,LII,BI
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGLST",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S REG=$G(REG,"")
 D EN^BQIMSLST(.BQILOC,"D")
 S LII=$O(@BQILOC@(""),-1)
 F II=0:1:LII-1 S @DATA@(II)=@BQILOC@(II)
 ;
 ; If want to get all view fields for a specified register
 I REG'="" D
 . NEW RN
 . S RN=$O(^BQI(90506.5,"B",REG,"")) I RN="" Q
 . S RTYP=$P(^BQI(90506.5,RN,0),U,2) I RTYP="" Q
 . ;S SRC=$P(^DD(90506.1,2.01,0),"^",3)
 . ;F BI=1:1:$L(SRC,";") I $P($P(SRC,";",BI),":",2)=REG S RTYP=$P($P(SRC,";",BI),":",1)
 . D EN^BQIMSLST(.BQILOC,RTYP)
 . S LII=$O(@BQILOC@(""),-1)
 . F BI=1:1:LII-1 S II=II+1,@DATA@(II)=@BQILOC@(BI)
 ;
 ; If want to get all view fields for all registers
 I REG="" D
 . NEW IEN,REG
 . S IEN=0
 . F  S IEN=$O(^BQI(90507,IEN)) Q:'IEN  D
 .. ; If the register is not active, quit
 .. I $$GET1^DIQ(90507,IEN_",",.08,"I") Q
 .. S REG=$$GET1^DIQ(90507,IEN_",",.01,"E"),RTYP=""
 .. S RN=$O(^BQI(90506.5,"D",IEN,"")) I RN="" Q
 .. S RTYP=$P(^BQI(90506.5,RN,0),U,2)
 .. ;S SRC=$P(^DD(90506.1,2.01,0),"^",3)
 .. ;F BI=1:1:$L(SRC,";") I $P($P(SRC,";",BI),":",2)=REG S RTYP=$P($P(SRC,";",BI),":",1)
 .. I RTYP="" Q
 .. I RTYP="D"!(RTYP="G")!(RTYP="R") Q
 .. D EN^BQIMSLST(.BQILOC,RTYP)
 .. S LII=$O(@BQILOC@(""),-1)
 .. F BI=1:1:LII-1 S II=II+1,@DATA@(II)=@BQILOC@(BI)
 .. K @BQILOC,REG,RTYP
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 K @BQILOC
 Q
