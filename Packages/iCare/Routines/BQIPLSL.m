BQIPLSL ;PRXM/HC/DLS - Panel Share List ; 22 Nov 2005  9:18 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,PLOWN,PLIEN) ; EP -- BQI GET SHARE LIST BY PANEL
 ;
 ;Description
 ;  Given a panel owner and a panel IEN, generates a list of users sharing a panel.
 ;
 ;Input
 ;  PLOWN - Panel Owner IEN
 ;  PLIEN - IEN of the panel within the Owner's file.
 ;
 ;Output
 ;  DATA - Name of global in which data is stored(^TMP("BQIPLSL"))
 ;
 N UID,X,BQII,DA,IENS
 N SHDUZ,NAME,ACC,STRT,END,SHARE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLSL",UID))
 K @DATA
 ;
 S BQII=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLSL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 D HDR
 ; If no PLIEN is supplied just pass header
 I $G(PLIEN)="" G DONE
 ;
 S SHDUZ=0,DA(2)=PLOWN,DA(1)=PLIEN
 F  S SHDUZ=$O(^BQICARE(PLOWN,1,PLIEN,30,SHDUZ)) Q:'SHDUZ  D
 . S DA=SHDUZ,IENS=$$IENS^DILF(.DA)
 . S NAME=$$GET1^DIQ(200,SHDUZ_",",.01,"E")
 . S ACC=$$GET1^DIQ(90505.03,IENS,.02,"I")
 . S STRT=$$GET1^DIQ(90505.03,IENS,.03,"I") I STRT S STRT=$$FMTE^BQIUL1(STRT)
 . S END=$$GET1^DIQ(90505.03,IENS,.04,"I") I END S END=$$FMTE^BQIUL1(END)
 . S SHARE=$$GET1^DIQ(90505.03,IENS,.05,"I") S SHARE=$S(SHARE=1:"Y",1:"N")
 . S BQII=BQII+1
 . ;
 . S @DATA@(BQII)=SHDUZ_"^"_NAME_"^"_ACC_"^"_STRT_"^"_END_"^"_SHARE_$C(30)
 ;
 ; Drop down to DONE...
 ;
DONE ; -- exit code
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
HDR ; -- header code
 S @DATA@(BQII)="I00004SHARE_DUZ^T00050SHARE_USER_NAME^T00002SHARE_ACCESS^D00015SHARE_START_DT^D00015SHARE_END_DT^T00003SHARE_LAYOUTS"_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
