AMQQLXR ; IHS/CMI/THL - SETS AQ1 XREF ON BLOOD QUANTUM FLD IN PT FILE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
REINDEX ;
 S U="^"
 I $P(^AUTTSITE(1,0),U,19)'="Y" D  Q
 .W *7,!,"""AQ"" indices for Q-MAN not currently set up."
 .W !,"Use Q-MAN site manager option to create these indices."
 K ^AUPNPAT("AQ1")
 F DA=0:0 S DA=$O(^AUPNPAT(DA)) Q:'DA  S X=$P($G(^(DA,11)),U,10) K AMQQQXR D QXR I $D(AMQQQXR) S ^AUPNPAT("AQ1",AMQQQXR,DA)=""
 K ^AUPNPAT("AQ2")
 F DA=0:0 S DA=$O(^AUPNPAT(DA)) Q:'DA  S X=$P($G(^(DA,11)),U,9) K AMQQQXR D QXR I $D(AMQQQXR) S ^AUPNPAT("AQ2",AMQQQXR,DA)=""
 Q
 ;
QXR ; ENTRY POINT
 I X="" Q
 N %
 S %=X
 N X
 I %["/" S %=(+%/$S($P(%,"/",2):$P(%,"/",2),1:1)) S:$E(%)="." %=0_%,AMQQQXR=$E(%,1,8)+1 S:'$D(AMQQQXR) AMQQQXR=%+1 Q
 S %=$S($E(%)="F":2,$E(%)="N":1,$E(%,1,3)="UNK":2.1,$E(%,1,3)="UNS":2.2,1:"")
 I %'="" S AMQQQXR=%
 Q
 ;
