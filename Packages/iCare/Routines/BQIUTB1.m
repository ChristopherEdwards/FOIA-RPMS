BQIUTB1 ;PRXM/HC/ALA-Table Utilities continued ; 13 Jul 2006  3:47 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
SBRG(DATA,REG) ; EP -- BQI GET SUBREGISTERS
 ;Description
 ;  To return a list of register types for a registry
 ;Input
 ;  REG - Register IEN from the ICARE REGISTER INDEX file (#90507)
 NEW UID,II,FILE,X,FILE,GLBREF,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITABLE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I $G(REG)="" S BMXSEC="No register selected" Q
 S @DATA@(II)="I00010SUBREG_IEN^T00030SUBREG_NAME^I00010REG_IEN"_$C(30)
 S FILE=$$GET1^DIQ(90507,REG_",",.12,"E")
 I FILE="" G DONE
 I '$$VFILE^DILFD(FILE) S BMXSEC="Table doesn't exist in RPMS" Q
 S GLBREF=$$ROOT^DILFD(FILE,"",1)
 ;
 S IEN=0
 F  S IEN=$O(@GLBREF@(IEN)) Q:'IEN  D
 . I $G(@GLBREF@(IEN,0))="" Q
 . I $P(@GLBREF@(IEN,0),U,1)="" Q
 . S II=II+1
 . S @DATA@(II)=IEN_"^"_$P(@GLBREF@(IEN,0),U,1)_"^"_REG_$C(30)
 ;
DONE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
REGSTAT(DATA,REG) ; EP -- BQI GET REGISTER STATUS
 ;
 ;Description:
 ;  Returns the list of statuses associated with the register selected.
 ;  If no register is passed statuses for all registers will be returned.
 ;
 ;RPC:  BQI GET REGISTER STATUS
 ;
 ;Input:
 ;  REG - Optional register IEN from the ICARE REGISTER INDEX file (#90507)
 ;  
 ;Output:
 ;  ^TMP("BQIREG",UID,#) = Register ^ status code=description_$C(28)_status code...
 ;  where UID will be either $J or "Z" plus the Task
 ;
 N UID,X,II
 S II=0
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIREG",UID))
 K @DATA
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S II=II+1,@DATA@(II)="I00010REG_IEN^T00010STATUS_CODE^T00040STATUS_NAME"_$C(30) ;Header
 ;Retrieve set of codes for Status
 S REG=$G(REG)
 I REG D SET(REG) G RDNE
 S REG=0 F  S REG=$O(^BQI(90507,REG)) Q:'REG  D SET(REG)
 ;
RDNE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SET(REG) ;EP
 N FILE,FIELD,SET,I,PC
 S FILE=$$GET1^DIQ(90507,REG_",",.15,"E")
 S FIELD=$$GET1^DIQ(90507,REG_",",.14,"E")
 D FIELD^DID(FILE,.FIELD,,"POINTER","SET")
 Q:'$D(SET("POINTER"))
 F I=1:1:$L(SET("POINTER"),";") S PC=$P(SET("POINTER"),";",I) I PC'="" D
 . S II=II+1,@DATA@(II)=REG_"^"_$TR(PC,":","^")_$C(30)
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
DHLP(DATA,DXCN,COL) ;EP -- BQI GET DX CAT HELP TEXT
 ; 
 ; COL - Width of output (e.g. 132 for 132 character width)
 ; 
 NEW UID,II,DXN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITABLE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIUTB1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S DXCN=$G(DXCN,"")
 S COL=$G(COL,"")
 S @DATA@(II)="T00010DIAG_IEN^T00040DIAG_CAT^T00015DX_CAT^T01024DESC_TEXT"_$C(30)
 ;
 I DXCN'="" D  G DNE
 . I DXCN'?.N S DXN=$O(^BQI(90506.2,"B",DXCN,""))
 . I DXCN?.N S DXN=DXCN,DXCN=$P(^BQI(90506.2,DXN,0),"^",1)
 . D GDATA(DXN,COL)
 ;
 I DXCN="" D
 . F  S DXCN=$O(^BQI(90506.2,"B",DXCN)) Q:DXCN=""  D
 .. S DXN=""
 .. F  S DXN=$O(^BQI(90506.2,"B",DXCN,DXN)) Q:DXN=""  D
 ... I $P(^BQI(90506.2,DXN,0),"^",3)=1 Q
 ... I $P(^BQI(90506.2,DXN,0),"^",5)=1 Q
 ... D GDATA(DXN,COL)
DNE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
GDATA(DXN,COL) ;EP - Get tooltip
 NEW TEXT,LEN,DXCAT,DC,ARR,I
 S DXCAT=$$GET1^DIQ(90506.2,DXN_",",.07,"E")
 S DC=0,TEXT=""
 S II=II+1
 S @DATA@(II)=DXN_"^"_DXCN_"^"_DXCAT_"^"
 I COL D  S II=II+1,@DATA@(II)=$C(30) Q
 .S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC
 .S II=II+1,@DATA@(II)=^BQI(90506.2,DXN,3,DC,0)
 .F  S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC  D
 .. S TEXT=^BQI(90506.2,DXN,3,DC,0)
 .. I TEXT="AND"!(TEXT="OR")!(TEXT?." "1AN1".".E) D UPD Q
 .. I $G(@DATA@(II))="AND"!($G(@DATA@(II))="OR") D UPD Q
 .. I $L($G(@DATA@(II)))+$L($P(TEXT," "))>COL D UPD Q
 .. S LEN=$L(@DATA@(II))+$L(TEXT)
 .. I LEN<COL S @DATA@(II)=@DATA@(II)_" "_TEXT Q
 .. F I=$L(TEXT," "):-1:1 S LEN=$L(@DATA@(II))+$L($P(TEXT," ",1,I)) I LEN<COL D  Q
 ... S @DATA@(II)=@DATA@(II)_" "_$P(TEXT," ",1,I)_$C(10)
 ... S II=II+1,@DATA@(II)=$P(TEXT," ",I+1,99)
 ;
 F  S DC=$O(^BQI(90506.2,DXN,3,DC)) Q:'DC  D
 . S II=II+1,@DATA@(II)=^BQI(90506.2,DXN,3,DC,0)_$C(10)
 S II=II+1,@DATA@(II)=$C(30)
 Q
 ;
UPD ; Update temporary global
 S @DATA@(II)=@DATA@(II)_$C(10)
 S II=II+1,@DATA@(II)=TEXT
 Q
