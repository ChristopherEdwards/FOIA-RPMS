BQIFLUPD ;PRXM/HC/ALA-Update Flags ; 14 Dec 2005  5:22 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
UPD(DATA,ADIEN,ALIEN,DFN,AACT) ;EP -- BQI UPDATE FLAGS
 ;Description
 ;  For a user, update the status of a flag for a particular patient. This
 ;  will be used to deactivate a flag or reactivate it.
 ;Input
 ;  ADIEN = Flag Definition internal entry number
 ;  ALIEN = Flag Record internal entry number
 ;  DFN   = Patient internal entry number
 ;  AACT  = Flag Action
 ;
 NEW UID,II,X,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIFLUPD",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIFLUPD D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 NEW DA,IENS
 S DA(3)=DFN,DA(2)=ADIEN,DA(1)=ALIEN,DA=DUZ,IENS=$$IENS^DILF(.DA)
 I AACT="H" D
 . S BQIUPD(90507.5151,IENS,.02)=1
 . S BQIUPD(90507.5151,IENS,.03)=$$NOW^XLFDT()
 I AACT="S" D
 . S BQIUPD(90507.5151,IENS,.02)="@"
 . S BQIUPD(90507.5151,IENS,.03)=$$NOW^XLFDT()
 ;
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 I $D(ERROR) S II=II+1,@DATA@(II)="-1"_$C(30)
 I '$D(ERROR) S II=II+1,@DATA@(II)="1"_$C(30)
 ;
 ; Refresh the flag indicator for this patient
 D FND^BQIFLFLG(DUZ,DFN,ADIEN)
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
