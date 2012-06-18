BQIPLLAY ;VNGT/HS/ALA-Panel Layouts ; 20 Jul 2009  10:41 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
GET(DATA,OWNR,PLIEN) ; EP - BQI GET PANEL LAYOUTS
 NEW UID,II,IENS,DA,YEAR,GIEN,DISPLAY,SORT,SDIR,SD,SR,GVALUE,STVCD,SVALUE,DVALUE
 NEW RIEN,CARE,CRN,DEF,TIEN,TYP,TEMPL
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLLAY",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLAY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010TEMPL_IEN^T00040TEMPLATE_NAME^T00001DEFAULT^T00001TYPE^T00120DISPLAY_ORDER^T00120SORT_ORDER^T00120SORT_DIRECTION^D00030LAST_EDIT"_$C(30)
 ;
 S OWNR=$G(OWNR,$G(DUZ)),PLIEN=$G(PLIEN,"") ; If no owner supplied use DUZ
 ;
PT ; for Patient view
 D
 . ; If there is a template
 . I $$TMPL^BQIPLVWC() Q
 . ; If there is a customized view
 . I $$CVW^BQIPLVWC() D  Q
 .. S @DATA@(II)=$TR(@DATA@(II),$C(30))
 .. S $P(@DATA@(II),U,8)=""
 .. I $E(@DATA@(II),$L(@DATA@(II)))'=$C(30) S @DATA@(II)=@DATA@(II)_$C(30)
 . ; Get default
 . S TIEN="",TEMPL="",DEF="",TYP="D"
 . S DISPLAY=$$DFNC^BQIPLVW()
 . S SORT=$$SFNC^BQIPLVW()
 . S SDIR="A",TEMPL="System Default"
 . S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_$C(30)
 ;
GP ; for Natl measures
 D
 . ; If there is a template
 . I $$TMPL^BQIGPVW() Q
 . ; If there is a customized view
 . I $$CVW^BQIGPVW() D  Q
 .. S @DATA@(II)=$TR(@DATA@(II),$C(30))
 .. S $P(@DATA@(II),U,8)=""
 .. I $E(@DATA@(II),$L(@DATA@(II)))'=$C(30) S @DATA@(II)=@DATA@(II)_$C(30)
 . ; Get default
 . S TIEN="",TEMPL="",DEF="",TYP="G"
 . S DISPLAY=$$DFNC^BQIGPVW()_$C(29)_$$GDEF^BQIGPVW()
 . S SORT=$$SFNC^BQIGPVW()
 . S SDIR="A",TEMPL="System Default"
 . S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_$C(30)
 ;
RM ; for Reminders
 D
 . ; If there is a template
 . I $$TMPL^BQIPLRVW() Q
 . ; If there is a customized view
 . I $$CVW^BQIPLRVW() D  Q
 .. S @DATA@(II)=$TR(@DATA@(II),$C(30))
 .. S $P(@DATA@(II),U,8)=""
 .. I $E(@DATA@(II),$L(@DATA@(II)))'=$C(30) S @DATA@(II)=@DATA@(II)_$C(30)
 . ;
 . S TIEN="",TEMPL="",DEF="",TYP="R"
 . S DISPLAY=$$DFNC^BQIGPVW()_$C(29)_$$RDEF^BQIRMPL()
 . S SORT=$$SFNC^BQIGPVW()
 . S SDIR="A",TEMPL="System Default"
 . S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_$C(30)
 ;
CM ; for Care Management
 NEW TDATA
 D TAB^BQIUTB(.TDATA,"CARE")
 F CN=1:1 S CARE=$P(@TDATA@(CN),U,2) Q:CARE=""  D
 . ;
 . N TIEN,TEMPL,DEF,CRN,TYP,DISPLAY,SORT,SDIR
 . ;
 . ;Check for a template
 . I $$TMPL^BQICMVW(CARE) Q
 . ;
 . ;Check for a customized view
 . I $$CVW^BQICMVW(CARE) D  Q
 .. S @DATA@(II)=$TR(@DATA@(II),$C(30))
 .. S $P(@DATA@(II),U,8)=""
 .. I $E(@DATA@(II),$L(@DATA@(II)))'=$C(30) S @DATA@(II)=@DATA@(II)_$C(30)
 . ;
 . ;System Default
 . S TIEN="",TEMPL="",DEF=""
 . S CRN=$O(^BQI(90506.5,"B",CARE,"")),TYP=$P(^BQI(90506.5,CRN,0),U,2)
 . S DISPLAY=$$DFNC^BQICMVW()_$C(29)_$$CDEF^BQICMVW()
 . S SORT=$$SFNC^BQICMVW()
 . S SDIR="A",TEMPL="System Default"
 . S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_$C(30)
 ;
 K @TDATA
 ;
CE ; for Care Event (CMET)
 N CARE
 F CARE="Events","Tracked Events","Followup Events" D
 . ;
 . N TIEN,TEMPL,DEF,CRN,TYP,DISPLAY,SORT,SDIR
 . ;
 . ;Check for a template
 . I $$TMPL^BQICEVW(CARE) Q
 . ;
 . ;Check for a customized view
 . I $$CVW^BQICEVW(CARE) D  Q
 .. S @DATA@(II)=$TR(@DATA@(II),$C(30))
 .. S $P(@DATA@(II),U,8)=""
 .. I $E(@DATA@(II),$L(@DATA@(II)))'=$C(30) S @DATA@(II)=@DATA@(II)_$C(30)
 . ;
 . ;System Default
 . S TIEN="",TEMPL="",DEF=""
 . S CRN=$O(^BQI(90506.5,"B",CARE,"")),TYP=$P(^BQI(90506.5,CRN,0),U,2)
 . S DISPLAY=$$DFNC^BQICEVW()_$C(29)_$$CDEF^BQICEVW()
 . S SORT=$$SFNC^BQICEVW(CRN,TYP)
 . I CARE="Followup Events" S SDIR="A"_$C(29)_"A"_$C(29)_"A",TEMPL="System Default"
 . E  S SDIR="A"_$C(29)_"D"_$C(29)_"A",TEMPL="System Default"
 . S II=II+1,@DATA@(II)=TIEN_U_TEMPL_U_DEF_U_TYP_U_DISPLAY_U_SORT_U_SDIR_U_$C(30)
 K CARE
 ;
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
UPD(DATA,OWNR,PLIEN,TYPE,TEMPL,SOR,SDIR,DOR) ; EP - BQI SET PANEL LAYOUTS
 ;
 NEW UID,II,IEN,LIST,BN
 K ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLYUP",UID))
 K @DATA
 S II=0
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLLAY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TEMPL=$G(TEMPL,""),SOR=$G(SOR,""),SDIR=$G(SDIR,""),DOR=$G(DOR,"")
 I DOR="" D
 . S LIST="",BN=""
 . F  S BN=$O(DOR(BN)) Q:BN=""  S LIST=LIST_DOR(BN)
 . K DOR
 . S DOR=LIST
 . K LIST
 ;
 I TYPE="D" D FIL^BQIPLVWC(OWNR,PLIEN,$G(TEMPL),SOR,SDIR,DOR) G FIN
 I TYPE="G" D FIL^BQIGPVW(OWNR,PLIEN,$G(YEAR),$G(TEMPL),SOR,SDIR,DOR) G FIN
 I TYPE="R" D FIL^BQIPLRVW(OWNR,PLIEN,$G(TEMPL),SOR,SDIR,DOR) G FIN
 S CRN=$O(^BQI(90506.5,"C",TYPE,""))
 I CRN'="" D
 . S CARE=$P(^BQI(90506.5,CRN,0),"^",1)
 . D FIL^BQICMVW(OWNR,PLIEN,CARE,$G(TEMPL),SOR,SDIR,DOR)
 ;
FIN ; Finish up
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
 K ERROR
 S II=II+1,@DATA@(II)=$C(31)
 Q
