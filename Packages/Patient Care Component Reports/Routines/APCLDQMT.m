APCLDQMT ; IHS/CMI/LAB - fix to QMAN DICT OF TERMS - AKA ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
DEL ;delete "P O V" AKA multiple from the DIAGNOSIS entry
 N DIC,REC
 S DIC="^AMQQ(5,",DIC(0)="OZ",X="DIAGNOSIS"
 D ^DIC K DIC
 S REC=+Y
 S DIC="^AMQQ(5,"_REC_",1,",DIC(0)="OZ",X="P O V"
 D ^DIC K DIC
 I Y=-1 D NONE G QUIT
 S DA(1)=REC
 S DIK="^AMQQ(5,"_REC_",1,",DA=+Y
 D ^DIK K DIK
 W !!,"......deleting the ""P O V"" AKA multiple from the DIAGNOSIS term entry.",!!
QUIT K REC
 Q
NONE ;no "P O V" found
 W !?5,"No ""P O V"" entry found.....nothing deleted",!
 Q
