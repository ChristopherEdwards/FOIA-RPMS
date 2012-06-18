BTPWPWRK ;VNGT/HS/ALA-CMET Worksheet Update ; 16 Dec 2009  5:45 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
EN(DATA,BTPWDEF,BTPWTYP,CMIEN,PARMS) ; EP - BTPW UPDATE CMET WORKSHEET
 ; Input parameters
 ;   BTPWDEF - Register or sub-register name
 ;   BTPWTYP - What is to happen to the record (A=Add, E=Edit, D=Delete)
 ;   PARMS  - Parameters and their values
 ;   CMIEN  - Tracked Record IEN
 ;
 NEW UID,II,DTTM,ERROR,BTWP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPWRK",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPWRK D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T01024MSG^I00010HIDE_CMET_IEN"_$C(30)
 ;
 ;Pull current date/time
 S DTTM=$$NOW^XLFDT()
 ;
 S CMIEN=$G(CMIEN,""),IENS=""
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I $G(PARMS)="",BTPWTYP'="D" Q
 I BTPWDEF="" S BMXSEC="RPC Call Failed: VDEF Type not passed in." Q
 S VFIEN=$O(^BQI(90506.3,"B",BTPWDEF,""))
 I VFIEN="" S BMXSEC="RPC Call Failed: "_BTPWDEF_" does not exist." Q
 S FILE=$P(^BQI(90506.3,VFIEN,0),U,2)
 I CMIEN'="",CMIEN'["," S IENS=CMIEN_","
 ;
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . I VALUE="" S VALUE="@"
 . ;I VALUE="" Q
 . S PFIEN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I PFIEN="" S BMXSEC=NAME_" not a valid parameter for this update" Q
 . S PTYP=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,1)),U,1)
 . I PTYP="D" S VALUE=$$DATE^BQIUL1(VALUE)
 . I PTYP="C" D
 .. S CHIEN=$O(^BQI(90506.3,VFIEN,10,PFIEN,5,"B",VALUE,"")) I CHIEN="" Q
 .. S VALUE=$P(^BQI(90506.3,VFIEN,10,PFIEN,5,CHIEN,0),U,2)
 . S @NAME=VALUE
 ;
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1)
 . S PFIEN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I PFIEN="" S BMXSEC=NAME_" not a valid parameter for this update" Q
 . S FIELD=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,3)),U,1),PTYP=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,1)),U,1)
 . ;Word Processing Field
 . I PTYP="W" D  Q
 .. N FIELD,LN,I,P
 .. S FIELD=$P($G(^BQI(90506.3,VFIEN,10,PFIEN,3)),U,1) Q:FIELD=""
 .. I @NAME="@" S BTPWDTA(FILE,IENS,FIELD)="@" Q
 .. F LN=1:1:$L(@NAME,$C(10)) S P=$P(@NAME,$C(10),LN) S BTWP(FILE,FIELD,LN)=P
 . S EXEC=$G(^BQI(90506.3,VFIEN,10,PFIEN,7))
 . I EXEC'="" X EXEC Q
 . I FIELD="" Q
 . I IENS'="" S BTPWDTA(FILE,IENS,FIELD)=@NAME
 ;
 I BTPWTYP="E" D  G DONE
 . ;
 . ;Log History Entry
 . I $D(BTPWDTA)>0 D RLOG^BTPWHIST(.BTPWDTA,DUZ,DTTM,"Worksheet Update")
 . ;
 . ;File the Information
 . S BTPWDTA(90620,CMIEN_",",1.09)=$$NOW^XLFDT(),BTPWDTA(90620,CMIEN_",",1.1)=DUZ
 . D FILE^DIE("","BTPWDTA","ERROR")
 . ;
 . ;Save comments
 . I $D(BTWP(FILE)) D
 .. S FIELD="" F  S FIELD=$O(BTWP(FILE,FIELD)) Q:FIELD=""  D
 ... N CMTVAR,COM S CMTVAR="BTWP("_FILE_","_FIELD_")"
 ... M COM=BTWP(FILE,FIELD)
 ... ;
 ... ;Log History Entry
 ... D WLOG^BTPWHIST(.COM,FILE_":"_FIELD,CMIEN_",",DUZ,DTTM,"Worksheet Update")
 ... ; 
 ... ;Save Comments
 ... D WP^DIE(90620,CMIEN_",",FIELD,"",CMTVAR)
 ;
DONE ;
 S RESULT=1_U
 I $D(ERROR)>0 S RESULT=-1_U_$G(ERROR("DIERR",1,"TEXT",1))_U
 I $P(RESULT,U,1)'=-1 S RESULT=1_U_U_$G(CMIEN)
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
