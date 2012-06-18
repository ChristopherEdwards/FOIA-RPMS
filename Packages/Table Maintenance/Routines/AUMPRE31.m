AUMPRE31 ;IHS/OIT/CLS - AUM 9.1 patch 3 PRE & POST INSTALL [ 02/22/2006  4:11 PM ]
 ;;9.1;AUM - SCB UPDATE;**3**;NOV 11, 2008
 ;
QUIT ; This routine should not be called at the top.  It is only to be called
 ; at START and POST by KIDS as the pre and post inits for AUM*9.1*3.
 ;
START ;IHS/OIT/CLS
 D CLEANALL^AUMPRE32  ;clean up all resident control characters
 D START^AUMPRE33     ;reset .01 nodes of entries with semicolons
 D DEL,2005,INA,KILL
 Q
DEL ;delete all major topics
 S DIK="^AUTTEDMT("
 S DA=0
 F  S DA=$O(^AUTTEDMT(DA)) Q:'DA  D
 .D ^DIK
 Q
2005 ;append 2005 to inactive codes
 S DIE="^AUTTEDT("
 S DA=0
 F  S DA=$O(^AUTTEDT(DA)) Q:'DA  I $P(^AUTTEDT(DA,0),"^",3)'="" D
 .S AUMN=$P(^AUTTEDT(DA,0),"^")_" 2005"
 .S DR=".01////"_AUMN
 .D ^DIE
 .I '(DA#100) W "."
 Q
INA ;inactivate and append 2006 to the remaining codes
 S DIE="^AUTTEDT("
 S DA=0
 F  S DA=$O(^AUTTEDT(DA)) Q:'DA  I $P(^AUTTEDT(DA,0),"^",3)="" D
 .S AUMN=$P(^AUTTEDT(DA,0),"^")_" 2006"
  .S DR=".01////"_AUMN_";.03///1"
  .D ^DIE
 .I '(DA#100) W "."
 Q
KILL ;kill "B" and "C" cross-references
 K ^AUTTEDT("B")
 K ^AUTTEDT("C")
 Q
 ;
POST ;call to ENALL^DIK for .01 and 1
 S DIK="^AUTTEDT("
 S DIK(1)=".01^B"
 D ENALL^DIK
 S DIK(1)="1^C"
 D ENALL^DIK
 Q
 ;
 ;end of routine AUMPRE31
