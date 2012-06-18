DGVPR ;ALB/MRL - DG PRE-INIT DRIVER ; 05 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 ;
EN ;begin initialization routine
 S XQABT3=$H
 Q:'DGVCUR  ;if installing fresh, skip pre-init
 S DGVFLD=100 D TIME1 ; set start time for DGINIT
 D DD
 D LINE^DGVPP,SAV^DGVPR1("DG")
 D EN^DGV53PR
 D LINE^DGVPP
 S DGVFLD=101 D TIME
ENQ Q
 ;
TIME ; -- stuff start and end times
 ;Q:DGVCUR=DGVNEW&(SDVCUR=DGVNEW)  D H^DGUTL
 D H^DGUTL
TIME1 ; -- DGTIME defined
 S X=DGVREL,DIC="^DG(48,",DIC(0)="M" D ^DIC K DIC
 I Y>0 S DA=+Y,DIE="^DG(48,",DR=DGVFLD_"////"_DGTIME D ^DIE
 K DGVFLD,DE,DQ,DIE,DR
 Q
 ;
DD ;Kill 405.2 with data per fileman problem
 S DIU=405.2,DIU(0)="D" D EN^DIU2
 K DIU
 Q
