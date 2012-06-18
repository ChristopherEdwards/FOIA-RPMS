ABMDTVIS ; IHS/ASDST/DMJ - Add/Edit 3P Visit Types ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Add prompt for auto-link to do claim splitting
 ;    in claim generator
 ;
START ;START HERE
 K DIC,ABM
 W ! S DIC="^ABMDVTYP(",DIC(0)="QEAML",DIC("A")="Select VISIT TYPE: " D ^DIC
 Q:+Y<1!$D(DTOUT)!$D(DUOUT)
 S ABMVT=+Y
 I $P($G(^ABMDVTYP(+Y,0)),U,3)'="" W "  ","(uneditable) ??",*7 D AUTOLINK G START
 I $P($G(^ABMDVTYP(+Y,0)),U,3)="" D
 .S DR=$S('$P(^ABMDVTYP(+Y,0),U,3):".01;",1:"")_".02;1"
 .S DA=+Y,DIE="^ABMDVTYP(" D ^DIE
 D AUTOLINK
 G XIT
AUTOLINK ; prompt for 8-pages
 W !
 F  D  Q:+ABMY<0!$D(DTOUT)!$D(DUOUT)
 .K DIC
 .S DA(1)=ABMVT
 .S DIC="^ABMDVTYP("_DA(1)_",2,"
 .S DIC(0)="QEAML"
 .S DIC("A")="AUTO-LINK to PCC file:"
 .S DIC("P")=$P(^DD(9002274.8,2,0),U,2)
 .D ^DIC K DIC
 .S ABMY=Y
 .Q:+ABMY<0
 .S DIE="^ABMDVTYP("_DA(1)_",2,"
 .S DA=+Y
 .S DR=".01;.02Delete from original claim?"
 .D ^DIE
 Q
 ;
XIT ;
 K ABM,DIR,DR,DIE,ABMVT,ABMY
 Q
