ACMMCR ;cmi/anch/maw - ACM Modify Register Creator 8/29/2007 8:37:43 AM
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;**7**;AUG 27, 2007
 ;
 ;this routine will allow the user to edit the register creator
 ;
MAIN ;-- main routine driver
 D ASK
 Q:'$G(ACMREG)
 D DISP(ACMREG)
 D EDIT(ACMREG)
 D EOJ
 Q
 ;
ASK ;-- display the register data
 S DIC(0)="AEMQZ",DIC="^ACM(41.1,",DIC("A")="Select Register: "
 D ^DIC
 Q:'Y
 S ACMREG=+Y
 Q
 ;
DISP(REG) ;-- display the register
 S DIC="^ACM(41.1,",DA=REG
 D EN^DIQ
 Q
 ;
EDIT(REG) ;-- edit the creator
 N ACMKEY
 S ACMKEY=$O(^DIC(19.1,"B","ACMZ MANAGER",0))
 I '$D(^VA(200,DUZ,51,"B",ACMKEY)) D  Q
 . W !,"You do not hold the key ACMZ EDIT required to edit the register creator" H 2
 W !
 S DIE="^ACM(41.1,",DA=ACMREG,DR="3.5"
 D ^DIE
 Q
 ;
EOJ ;-- kill variables and quit
 K ACMREG
 K DIC,DIE,DR,DA
 Q
 ;
