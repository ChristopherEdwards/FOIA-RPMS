AZXEINSF ;NEW PROGRAM [ 03/31/92  3:58 PM ]
 ;
 S DA=0,DIE="^AUTNINS(",DUZ(0)="@"
 F  S DA=$O(^AUTNINS(DA)) Q:'DA  I $P(^(DA,0),U,6)]"",$P(^(0),U,6)[")-" S DR=".06////"_$P($P(^(0),U,6),")-",1)_")"_$P($P(^(0),U,6),")-",2) W "." D ^DIE
 Q
