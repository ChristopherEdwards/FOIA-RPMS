BCH10P9 ;IHS/CMI/LAB - IHS CHR patch 9 [ 02/06/00  10:40 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**9**;OCT 28, 1996
 ;
 ;reindex tribe trigger
 ;delete bad nodes in chr pov global
POV ;
 S BCHX=0 F  S BCHX=$O(^BCHRPROB(BCHX)) Q:BCHX'=+BCHX  D
 .S BCHY=0 F  S BCHY=$O(^BCHRPROB(BCHX,BCHY)) Q:BCHY=""  K ^BCHRPROB(BCHX,BCHY)
 .Q
 ;reindex trigger
 S DIK="^BCHR(",DIK(1)=".04^8" D ENALL^DIK
 K BCHX,BCHY
 Q
