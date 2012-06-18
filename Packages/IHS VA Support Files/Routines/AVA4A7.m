AVA4A7 ; IHS/ORDC/LJF - GIVE PROVIDER KEY,CALLED BY XREF ; 27-MAY-1993
 ;;93.2;VA SUPPORT FILES;;JUL 01, 1993
 ;
 ;
 Q
F6S ;EP;Give provider the key.
 ;called by mumps xref on PROVIDER CLASS in file 200
 N AVAX,AVAY,X
 S X=$G(^VA(200,DA,"I")) I X,X<DT Q  ;see if inactive
 S AVAY=DA
 S AVAX=$O(^DIC(19.1,"B","PROVIDER",0)) I 'AVAX Q  ;get index
 I $D(^VA(200,AVAY,51,AVAX,0)) Q  ;already have it.
 N DD,DO,DIC,DS,DA
 S DIC="^VA(200,DA(1),51,",DIC(0)="NML",(X,DINUM)=AVAX
 S DA(1)=AVAY,DIC("P")=$P($G(^DD(200,51,0)),U,2) D FILE^DICN ;give it
 ;
 S AVAX=$P(^DIC(3,AVAY,0),U,16) Q:'AVAX
 ;stuff new person fields into provider file entry
 I $D(^DIC(6,AVAX,0))#2 S DIK="^VA(200,",DA=AVAY D IX1^DIK
 Q
 ;
 ;
F6K ;EP;Remove provider key if provider class has been deleted
 ;called by mumps xref on PROVIDER CLASS in file 200
 N AVAX,AVAY,X
 S X=$G(^VA(200,DA,"I")) I X,X<DT Q  ;see if inactive
 S AVAY=DA Q:$P($G(^VA(200,AVAY,"PS")),U,5)]""
 S AVAX=$O(^DIC(19.1,"B","PROVIDER",0)) I 'AVAX Q  ;get index
 I '$D(^VA(200,AVAY,51,AVAX)) Q  ;doesn't have key
 N DD,DO,DIK,DS,DA,DIC
 S DA(1)=AVAY,DIK="^VA(200,"_DA(1)_",51,",DA=AVAX D ^DIK
 Q
