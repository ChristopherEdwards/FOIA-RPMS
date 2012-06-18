APSPCVRX ; IHS/DSD/ENM - CREATE APSP PRIMARY CARE VISIT ENTRY ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
 ;------------------------------------------------------------------
START ;
 D ASK ; Ask if a Primary Care Visit
 D:%=1 DIE ; If answer yes, make entry in file
END D EOJ ; Clean up of variables
 Q
 ;------------------------------------------------------------------
 ;
ASK ; Ask if primary care visit     
 S %=2
 W !,"Is this a Primary Care Visit"
 D YN^DICN
 I %=0 W !!,"Enter a 'Y' if you are acting as the primary care provider and using independentjudgement in dealing with the patient.",! G ASK
 Q
 ;
DIE ; Make entry in APSP PRIMARY CARE VISIT file
 S DIC(0)="QEML",DIC="^APSPQA(32.6,",X=DT
 D FILE^DICN
 I Y="-1" G DIEX
 S DA=+Y,DIE=DIC K DIC,X,Y
 S DR=".02////"_AUPNPAT_";.03////"_DUZ_";.04"
 I $P(%APSITE,U,15)'="Y" S DR=DR_";1100"
 D ^DIE
DIEX ;
 Q
 ;
EOJ ; Clean up variables
 K DIE,DIC,DR,X,Y,%,%Y,DA
 Q
