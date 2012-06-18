APCDALI ; IHS/CMI/LAB - prompt for line item value ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
VALUE ;EP - called from input template to get value of line item
 I '$D(DA) S APCDTERR=1 Q
 I 'DA S APCDTERR=1 Q
 S APCDTF=$P(^AUPNVLI(DA,0),U)
 I 'APCDTF S APCDTERR=1 D EOJ Q
 S DIC("A")="  Enter the "_$P(^DIC(APCDTF,0),U)_" value:",DIC=APCDTF,DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"Invalid entry.  Try again." G VALUE
 S APCDTLII=+Y
EOJ ;
 K Y
 Q
