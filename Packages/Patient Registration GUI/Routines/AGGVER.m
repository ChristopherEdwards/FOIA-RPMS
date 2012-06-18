AGGVER ;VNGT/HS/DLS - Get AGG Version Info ; 12 Apr 2010  12:24 PM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;;
 ;
 Q
 ;
EN(DATA,PKG) ; EP -- AGG VERSION INFO
 ;Description
 ; Get the package version number and the distribution date.
 ; 
 ;Input
 ; PKG - Namespace
 ;
 ;Output
 ; DATA - Name of global in which data is stored(^TMP(PROCNM,UID))
 ;
 N UID,II,DA,X,IENS,PROCNM,GVER,RVER
 N PKGIEN,MAJVER,MAJDT,MAJIEN,PATCH,PTCHDT,PTCHIEN,FIND
 ;
 S PROCNM=$G(PKG)_"VER"
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP(PROCNM,UID))
 K @DATA
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGVER D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I PKG="" G DONE
 D HDR
 ;
GETDATA  ;
 D FIND^DIC(9.4,"","","",PKG,"","C","","","FIND")
 S PKGIEN=$G(FIND("DILIST",2,1))
 I PKGIEN="" G DONE
 S MAJVER=$G(^DIC(9.4,PKGIEN,"VERSION"))
 S MAJIEN=$O(^DIC(9.4,PKGIEN,22,"B",MAJVER,""))
 S DA(1)=PKGIEN,DA=MAJIEN,IENS=$$IENS^DILF(.DA)
 S MAJDT=$$GET1^DIQ(9.49,IENS,1,"I")
 ;
 ; Minor version information commented.
 ; Not sure if this will be necessary.
 S PTCHIEN=""
 I MAJIEN'="" S PTCHIEN=$O(^DIC(9.4,PKGIEN,22,MAJIEN,"PAH","A"),-1)
 I PTCHIEN'="" D
 . S PATCH=$P(^DIC(9.4,PKGIEN,22,MAJIEN,"PAH",PTCHIEN,0),"^",1)
 . S PTCHDT=$P(^DIC(9.4,PKGIEN,22,MAJIEN,"PAH",PTCHIEN,0),"^",2)
 ;
 ;S GVER=$P($G(^AGG(90508,1,0)),U,8),RVER=$P($G(^AGG(90508,1,0)),U,9)
 S GVER="1.0.0.45",RVER="1.0.0.45"
 S II=II+1,@DATA@(II)=PKG_"^"_$G(MAJVER)_"^"_$G(MAJDT)_"^"_$G(PATCH)_"^"_$G(PTCHDT)_"^"_GVER_"^"_RVER_$C(30)
 ;
 ;Drop down to DONE
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ;
 S II=II+1,@DATA@(II)="T00010PKG^T00010MAJ_VER^D00015MAJ_DT^T00010PATCH_LAST^D00015PATCH_DT^T00006GUI_TEST_VERSION^T00006RPMS_TEST_VERSION"_$C(30)
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
REG(DATA,FAKE) ;EP -- AGG CHECK DIVISION
 NEW UID,II
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGDUZK",UID))
 K @DATA
 ;
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGVER D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T01024MSG"_$C(30)
 S RESULT=1,MSG=""
 I $G(^AGFAC(DUZ(2),0))="" D
 . S RESULT=-1,MSG="The REGISTRATION PARAMETERS file has not been completed for this facility. Please contact your system support person."
 F AG=2:1:26 I $P($G(^AGFAC(DUZ(2),0)),U,AG)="" D
 . S RESULT=-1,MSG="The REGISTRATION PARAMETERS file has not been completed for this facility. Please contact your system support person."
 S II=II+1,@DATA@(II)=RESULT_U_MSG_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
