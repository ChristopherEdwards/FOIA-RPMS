BZXLREDT ;IHS/PIMC/JLG - EDIT TABLES FOR AZ HEALTH DEPT REPORT [ 07/18/2002  2:22 PM ]
 ;;1.0;Special local routine for reportable diseases
ENTER K DIRUT
 S DIC=1966360
 S DIC(0)="AEQMLZ"
 S DIC("A")="Enter reportable disease test: "
 S DLAYGO=1966360
 D ^DIC
 I Y=-1!$D(DIRUT) D  Q
 .K DIC,DLAYGO,Y,DIROUT,DTOUT,DIRUT
 I $P(Y,U,3)="" D  G ENTER:$G(BZXDELTD)
 .K BZXDELTD
 .S DIR("A")="Would you like to delete the "_Y(0,0)_" entry"
 .S DIR(0)="Y"
 .S DA=+Y
 .N Y
 .D ^DIR
 .Q:Y=0
 .W !,"Deleted!"
 .S BZXDELTD=Y
 .S DIK=DIC
 .D ^DIK
 S BZXTYPE=$P(@(U_$P(^LAB(60,$P(Y,U,2),0),U,12)_"0)"),U,2)
 S DIE=DIC
 S DA=+Y
 K DR
 I $E(BZXTYPE,1)="N" D
 .S DR=".03;.04"
 E  I BZXTYPE="S" D
 .S DR="1"
 E  I $E(BZXTYPE,1)="F" D
 .S DR="4"
 S DR=DR_";2//"_Y(0,0)
 D ^DIE
 G ENTER
 Q
 
