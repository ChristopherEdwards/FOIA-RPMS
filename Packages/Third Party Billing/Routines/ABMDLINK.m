ABMDLINK ; IHS/ASDST/DMJ - Routine to Account for PCC Merge ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ; This routine is called by the PCC Visit Merge Utility
 ;
 ;   The following variables are passed from PCC and thus
 ;   should not be killed:
 ;     APCDVMF - Merge from IEN
 ;     APCDVMT - Merge to IEN
 ;
EXT ;PEP - External Package Entry Point
 Q:'$D(APCDVMF)!'$D(APCDVMT)
CLM S DA(1)="" F  S DA(1)=$O(^ABMDCLM(DUZ(2),"AV",APCDVMF,DA(1))) Q:'DA(1)  D
 .S DA=0 S DA=$O(^ABMDCLM(DUZ(2),"AV",APCDVMF,DA(1),DA)) Q:'DA  D
 ..K DIC,DD,DO
 ..S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",11,",DIC(0)="LE",(DINUM,X)=APCDVMT
 ..D FILE^DICN Q:Y<1
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",11,"
 ..D ^DIK
 ;
BILL S DA(1)="" F  S DA(1)=$O(^ABMDBILL(DUZ(2),"AV",APCDVMF,DA(1))) Q:'DA(1)  D
 .S DA=0 S DA=$O(^ABMDBILL(DUZ(2),"AV",APCDVMF,DA(1),DA)) Q:'DA  D
 ..K DIC,DD,DO
 ..S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",11,",DIC(0)="LE",(DINUM,X)=APCDVMT
 ..D FILE^DICN
 ;
XIT Q
