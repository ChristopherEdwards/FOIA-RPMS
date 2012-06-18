ASDPOST ; IHS/ADC/PDW/ENM - IHS POST-INITS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 D ^SDONIT,^ASDL,XREF,KEYS,ADD,ADD2,DIV,FIX202 Q
 ;
XREF ; -- run new cross-references
 W !!,"RUNNING NEW CROSS-REFERENCES. . .",!
 S DIK="^SC(",DIK(1)=1916 D ENALL^DIK ; x-ref princ clinic
 S DIK="^SC(",DIK(1)=2501 D ENALL^DIK ; x-ref priv user
 S DIK="^SC(",DIK(1)=9999999.01 D ENALL^DIK ; x-ref ob user
 Q
 ;
KEYS ; -- gives SDZSUP1 key to holders of SDZSUP key
 S ASDK=$O(^DIC(19.1,"B","SDZSUP1",0)) Q:ASDK=""
 W !!,"ASSIGNING NEW SUPERVISOR KEY TO USERS WITH OLD KEY. . .",!
 S ASDU=0
 F  S ASDU=$O(^XUSEC("SDZSUP",ASDU)) Q:ASDU=""  D
 . Q:$D(^XUSEC("SDZSUP1",ASDU))  ;already has new key
 . K DIC,DD,DO S DIC(0)="NMQ",DIC("P")="200.051PA"
 . S DIC="^VA(200,"_ASDU_",51,",DA(1)=ASDU,X=ASDK,DINUM=X
 . D FILE^DICN W "."
 K DIC,DINUM,DA,ASDU,ASDK
 ;
 ; -- give SDZMENU key to all current holders of SDZUSER
 S ASDK=$O(^DIC(19.1,"B","SDZMENU",0)) Q:ASDK=""
 W !!,"ASSIGNING NEW SCHEDULING KEY TO USERS WITH OLD KEY. . .",!
 S ASDU=0
 F  S ASDU=$O(^XUSEC("SDZUSER",ASDU)) Q:ASDU=""  D
 . Q:$D(^XUSEC("SDZMENU",ASDU))  ;already has new key
 . K DIC,DD,DO S DIC(0)="NMQ",DIC("P")="200.051PA"
 . S DIC="^VA(200,"_ASDU_",51,",DA(1)=ASDU,X=ASDK,DINUM=X
 . D FILE^DICN W "."
 K DIC,DINUM,DA,ASDU,ASDK
 Q
 ;
ADD ; -- add MAS Parameter entry if none
 Q:$D(^DG(43,1,0))
 K DIC S DIC(0)="L",DLAYGO=43,DIC=43,X=1 D ^DIC
 Q
 ;
ADD2 ; -- make sure at least one entry for med cneter division
 Q:$O(^DG(40.8,0))
 K DIC S DIC=40.8,DLAYGO=40,DIC(0)="L",X=$P($G(^DIC(4,DUZ(2),0)),U)
 Q:X=""  D ^DIC Q:Y<1
 S DIE=40.8,DA=+Y,DR="1///"_DUZ(2) D ^DIE
 Q
 ;
DIV ; -- stuff division into clinics without an entry
 Q:'$D(^DG(40.8,"C",DUZ(2)))
 W !!,"UPDATING DIVISION FIELD IN CLINICS. . .",!
 S ASDIV=$O(^DG(40.8,"C",DUZ(2))) Q:ASDIV=""
 S ASDC=0 F  S ASDC=$O(^SC(ASDC)) Q:'ASDC  D
 . Q:'$D(^SC(ASDC,0))
 . Q:$P(^SC(ASDC,0),U,15)]""
 . S DIE="^SC(",DA=ASDC,DR="3.5////ASDIV" D ^DIE
 K ASDIV,ASDC,DIE,DA,DR
 Q
 ;
FIX202 ; -- cleans out 202.1 node of file 200
 NEW X
 S X=0 F  S X=$O(^VA(200,X)) Q:'X  D
 . I $G(^VA(200,X,202.1))]"" S ^VA(200,X,202.1)=""
 Q
