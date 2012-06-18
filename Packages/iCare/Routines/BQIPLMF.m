BQIPLMF ;PRXM/HC/DB-BQI Manual Patients Exist by Panel  ; 23 Aug 2006  3:52 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN(DATA,OWNR,PLIEN) ; EP -- BQI MANUAL PATS EXIST BY PANEL
 ;
 ;Description
 ;  Does panel have manually added or removed patients?
 ;
 ;Input
 ;  OWNR  - owner of the panel
 ;  PLIEN - panel internal entry number
 ;Output
 ;  DATA  - name of global (passed by reference) in which the data
 ;          is stored: 0=no manuals; 1=manual(s) included
 ;
 NEW UID,II,DFN,X,STAT,MAN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPLMF",UID))
 K @DATA
 ;
 S II=0,MAN=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPLMF D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S DFN=0
 F  S DFN=$O(^BQICARE(OWNR,1,PLIEN,40,DFN)) Q:'DFN  D  Q:MAN
 . NEW DA,IENS
 . S DA(2)=OWNR,DA(1)=PLIEN,DA=DFN,IENS=$$IENS^DILF(.DA)
 . S STAT=$$GET1^DIQ(90505.04,IENS,.02,"I"),MAN=STAT]""
 ;
DONE ;
 S II=II+1,@DATA@(II)="I00001RESULT"_$C(30)
 S II=II+1,@DATA@(II)=MAN_$C(30)
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
