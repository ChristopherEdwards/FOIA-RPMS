PSN4P26 ;BIR/DMA-fix bad interaction names ;17 Feb 00 / 8:12 AM
 ;;4.0; NATIONAL DRUG FILE;**26**; 30 Oct 98
 ;
 S DA=0 F  S DA=$O(^PS(56,DA)) Q:'DA  S X=^(DA,0) D
 .K PSN,PSNN
 .S NAM=$P(X,"^"),PSN=$P(X,"^",2),PSN=$P(^PS(50.416,PSN,0),"^"),PSNN(PSN)="",PSN=$P(X,"^",3),PSN=$P(^PS(50.416,PSN,0),"^"),PSNN(PSN)=""
 .S NA1="",NA1=$O(PSNN(""))_"/"_$O(PSNN($O(PSNN(""))))
 .I NA1'=NAM W "." S DIE="^PS(56,",DR=".01////"_NA1 D ^DIE
 K DA,DIE,DR,NA1,NAM,PSN,PSNN,X
 Q
