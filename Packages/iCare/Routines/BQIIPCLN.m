BQIIPCLN ;GDIT/HS/ALA-IPC Primary Clinics ; 07 Nov 2011  12:36 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
EN(DATA,FAKE) ; EP -- BQI GET IPC CLINICS
 NEW UID,II,EM
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIIPCLN",UID))
 K @DATA
 S II=0,TYPE=$G(TYPE,"")
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPCLN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="I00010IEN^T00050"
 S @DATA@(II)=HDR_$C(30)
 S CL=0
 F  S CL=$O(^BQI(90508,1,23,CL)) Q:'CL  D
 . S CLN=$P(^BQI(90508,1,23,CL,0),U,1)
 . S II=II+1,@DATA@(II)=CLN_U_$P($G(^DIC(40.7,CLN,0)),U,1)_$C(30)
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
UPD(DATA,PLIST) ; EP -- BQI UPDATE IPC CLINICS
 ;
 NEW RESULT,ERROR,LIST,BN,BQ,PDATA,NAME,VALUE,BI,BQIUPD,CLN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIUIPCL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIIPCLN D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S @DATA@(II)="I00010RESULT^T01024ERROR"_$C(30)
 ;
 NEW DA,DIK
 S DA(1)=1,DIK="^BQI(90508,"_DA(1)_",23,",DA=0
 F  S DA=$O(^BQI(90508,DA(1),23,DA)) Q:'DA  D ^DIK
 ;
 S PLIST=$G(PLIST,"")
 I PLIST="" D
 . S LIST="",BN=""
 . F  S BN=$O(PLIST(BN)) Q:BN=""  S LIST=LIST_PLIST(BN)
 . K PLIST
 . S PLIST=LIST
 . K LIST
 ;
 S RESULT=1
 F BQ=1:1:$L(PLIST,$C(29)) D  Q:$G(BMXSEC)'=""
 . S CLN=$P(PLIST,$C(29),BQ) Q:CLN=""
 . S DA=$O(^BQI(90508,0))
 . I $G(^BQI(90508,DA,23,0))="" S ^BQI(90508,DA,23,0)="^90508.023P^^"
 . S DA(1)=DA,DIC(0)="LNZ",DLAYGO=90508.023,DIC="^BQI(90508,"_DA(1)_",23,"
 . S X=CLN I X="" Q
 . K DO,DD D FILE^DICN
 . I Y=-1 S RESULT=-1
 ;
 S II=II+1,@DATA@(II)=RESULT_U_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q