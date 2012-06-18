ATXBULL2 ; IHS/OHPRD/TMJ -  AND DELETE BULLETINS FOR A TAXONOMY ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
ENTER ; ENTRY POINT - Taxonomy updated with bulletin to be triggered for a taxonomy; new bulletin for each taxonomy will be created
 S ATXFLG=""
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,5)=DUZ,$P(^(0),U,8)" D ^DIC K DR,DA,DIC K DIC I Y<1 G X1
 S ATXDFN=+Y
 I $P(^ATXAX(+Y,0),U,7) S ATXEXIST=1 W !,"If you want to change the mail group designated for this taxonomy's bulletin,",!,"delete the bulletin for this taxonomy and then recreate the bulletin and enter",!,"a new mail group."
 E  D CREATE I '$D(ATXBULL) W !,$C(7),"Bulletin could not be created!" G X1
 I '$D(ATXDEL) D
 . S DIE="^ATXAX(",DA=ATXDFN,DR=$S('$D(ATXEXIST):".03;.07////"_ATXBULL_";.11//B;.17;.19;.21",1:".03;.11;.17;.19;.21") D ^DIE K DIE,DA,ATXBULL
 . I '$D(ATXEXIST) W !!,"Okay, a bulletin has been created for this taxonomy."
X1 K ATXEXIST,ATXBULL,ATXDFN,ATXFLG,ATXDEL Q
 ;
DELETE ; ENTRY POINT - Delete a bulletin from a taxonomy
 S ATXFLG=""
 S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,5)=DUZ,$P(^(0),U,8)" D ^DIC K DIC I Y<1 G X2
 I '$P(^ATXAX(+Y,0),U,7) W !,"A bulletin does not exist for this taxonomy." G X2
 S ATXDFN=+Y,ATXDFN("BULL")=$P(^ATXAX(+Y,0),U,7)
 S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure you want to no longer have a bulletin issued for this taxonomy" D ^DIR K DIR
 I Y=1 S DA=ATXDFN,DR=".03///@;.07///@;.11///@",DIE="^ATXAX(" D ^DIE K DA,DIE W !,"Okay, the bulletin has been deleted for this taxonomy."
X2 K ATXDFN,ATXBULL,ATXFLG Q
 ;
CREATE ; Create copy of ATX BULLETIN for this taxonomy
 S X="ATX "_$P(^ATXAX(ATXDFN,0),U),DIC="^XMB(3.6,",DIC("DR")="2///PATIENT SEEN FOR AN ENTRY WITHIN A TAXONOMY",DIC(0)="L",DIADD=1,DLAYGO=3.6 S:$L(X)>30 X=$E(X,1,30) D ^DIC K DIC,DR,DA,DIADD,DLAYGO I Y<0 G X3
 S ATXBULL=+Y
 S ATXCOPY=$O(^XMB(3.6,"B","ATX BULLETIN",""))
 S %X="^XMB(3.6,ATXCOPY,1,",%Y="^XMB(3.6,ATXBULL,1," D %XY^%RCR
 S $P(^XMB(3.6,ATXBULL,1,0),U,5)=DT
 S DIC="^XMB(3.6,ATXBULL,2,",DA(1)=ATXBULL,DIC(0)="AEMQL",DIC("P")=$P(^DD(3.6,4,0),U,2) D ^DIC K DIC,DA,DR I Y>0 S ATXGRP=+^XMB(3.6,ATXBULL,2,+Y,0) D
A . S DIC="^XMB(3.8,ATXGRP,1,",DA(1)=ATXGRP,DIC(0)="AEMQL",DIC("P")=$P(^DD(3.8,2,0),U,2) D ^DIC K DIC,DA,DR G:"^"'[X A
 I '$D(ATXGRP) W !,"Mail group not indicated, bulletin being removed for this taxonomy." S DA=ATXBULL,DIK="^XMB(3.6," D ^DIK K DA,DIK S ATXDEL=""
X3 K ATXCOPY,ATXGRP,ATXSUB Q
 ;
