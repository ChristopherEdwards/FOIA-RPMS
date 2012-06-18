BNIPOST ; IHS/CMI/LAB - Routine to create bulletin ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 Q
 ;
PRE ;EP
 F DA=1:1:500 S DIK="^BNIGRI(" D ^DIK
 Q
POST ;EP
 S DIK(1)=".01^AE",DIK="^BNIREC(" D ENALL^DIK
 K DIK
 ;move ado schemas to bmx ado schema
 S BNIX=0 F  S BNIX=$O(^BNIADO(BNIX)) Q:BNIX'=+BNIX  D
 .S BNIN=$P(^BNIADO(BNIX,0),U)
 .Q:$D(^BMXADO("B",BNIN))  ;already in file
 .S G=0,X=0 F  S X=$O(^BMXADO(X)) Q:X'=+X!(G)  I $P(^BMXADO(X,0),U)=BNIN S G=1
 .Q:G
 .S X=BNIN,DIC="^BMXADO(",DIADD=1,DLAYGO=90093.99,DIC(0)="AEMQL" K DO,D0,DD D FILE^DICN
 .I Y=-1 W !!,"Failure to add BMX ADO Schema ",BNIN K DIADD,DLAYGO,DIC,DA Q
 .S BNIDA=+Y
 .K DIADD,DLAYGO,DIC,DA D ^XBFMK
 .M ^BMXADO(BNIDA)=^BNIADO(BNIX)
 .S DA=BNIDA,DIK="^BMXADO(" D IX1^DIK K DA,DIK
 Q
