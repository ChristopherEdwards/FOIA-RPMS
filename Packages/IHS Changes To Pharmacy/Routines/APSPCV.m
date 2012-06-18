APSPCV ; IHS/DSD/ENM - CREATE PRIMARY CARE VISIT FROM OPTION ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;----------------------------------------------------------
START ;
 S APSPCV("NEW")=0
 D DIC
 D:$D(DA) DIE
END D EOJ
 Q
 ;----------------------------------------------------------
DIC ;
 S DIC("A")="Enter Primary Care Visit Date : "
 S DIC(0)="QEAMLW",DIC="^APSPQA(32.6,"
 D ^DIC K DIC,D0,X,DA
 I Y'=-1 S DA=+Y S:$P(Y,U,3)=1 APSPCV("NEW")="1"
 Q
 ;
DIE ;
 S DIE="^APSPQA(32.6,"
 I APSPCV("NEW") S DR=".02;.03////^S X=DUZ;.04",DIE("NO^")="N"
 I 'APSPCV("NEW") S DR=".01:04"
 I $P(%APSITE,U,15)'="Y" S DR=DR_";1100"
 D ^DIE
 K DIE("NO^")
 Q
 ;
EOJ ;
 K DIE,DA,DIC,APSPCV,DR,DIE("NO^"),X,Y
 Q
