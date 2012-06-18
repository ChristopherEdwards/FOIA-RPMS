AUT98P14 ;IHS/SET/DMJ - AUT 98.1 PATCH 14 ; [ 02/05/2004  4:33 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**14**;MAR 04, 1998
 ;
 ; IHS/SET/DMJ AUT*98.1*14 02/02/2004
 ;
 D KILL
 D K2
 D S60
 Q
KILL ;kill off bad dental dd
 K ^DD(9999999.31,500)
 K ^DD(9999999.31,"B","RVU (Relative Value Unit)",500)
 Q
K2 ;delete revenue codes to be re-loaded
 S DIK="^AUTTREVN("
 F DA=184,185,341,342 D
 .D ^DIK
 Q
S60 ;set file to 60 if 0
 F AUTRF="LAB","PAP SMEAR" D
 .S DA=$O(^AUTTREFT("B",AUTRF,0))
 .Q:'DA
 .Q:$P(^AUTTREFT(DA,0),"^",2)=60
 .S $P(^AUTTREFT(DA,0),"^",2)=60
 K AUTRF
 Q
