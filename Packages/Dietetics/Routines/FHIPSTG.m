FHIPSTG ; HISC/NCA - Adverse Reaction Interface ;1/11/96  10:06
 ;;5.0;Dietetics;**3**;Apr 21, 1996
 I +$$VERSION^XPDUTL("GMRA")'=4 W !,?10,"You do not have version 4 of Adverse Reaction Tracking.",!,?10,"The Protocols will not be installed." Q
 Q:'$D(^ORD(101,0))
 ; Clean up protocols
 S DA(1)=$O(^ORD(101,"B","GMRA SIGN-OFF ON DATA",0))
 S (DA,FHX)=$O(^ORD(101,"B","FH SIGNED REACTION INTERFACE",0))
 I DA S DA=$O(^ORD(101,DA(1),10,"B",DA,0)) I DA S DIK="^ORD(101,DA(1),10," D ^DIK
 I FHX S DA=FHX,DIK="^ORD(101," D ^DIK
 S DA(1)=$O(^ORD(101,"B","GMRA ENTERED IN ERROR",0))
 S (DA,FHX)=$O(^ORD(101,"B","FH SIGNED REACTION CANCEL",0))
 I DA S DA=$O(^ORD(101,DA(1),10,"B",DA,0)) I DA S DIK="^ORD(101,DA(1),10," D ^DIK
 I FHX S DA=FHX,DIK="^ORD(101," D ^DIK K DA,DIK
 W !!,"Add Dietetic protocols..."
 S NAM="FH SIGNED REACTION INTERFACE",TXT="FH Signed Reaction Interface"
 S PKG=$O(^DIC(9.4,"C","FH",0)),ACT="D EN1^FHWGMR"
 W !?2,"Filing protocol ",NAM
 K DIC S DIC="^ORD(101,",DIC(0)="L",DLAYGO=101,DIC("DR")="1///^S X=TXT;4///A;12////^S X=PKG;20////^S X=ACT",X=NAM D ^DIC K DA,DIC,DLAYGO,X
 S NAM="FH SIGNED REACTION CANCEL",TXT="FH Signed Reaction Cancel"
 S PKG=$O(^DIC(9.4,"C","FH",0)),ACT="D CAN^FHWGMR"
 W !?2,"Filing protocol ",NAM
 K DIC S DIC="^ORD(101,",DIC(0)="L",DLAYGO=101,DIC("DR")="1///^S X=TXT;4///A;12////^S X=PKG;20////^S X=ACT",X=NAM D ^DIC K DA,DIC,DLAYGO,X
 W !!,"Add Dietetic protocols to Adverse Reaction Tracking..."
 S X=" ;;GMRA SIGN-OFF ON DATA;FH SIGNED REACTION INTERFACE" D AD1
 S X=" ;;GMRA ENTERED IN ERROR;FH SIGNED REACTION CANCEL" D AD1
KIL K ACT,DA,DIC,DIE,DIK,DLAYGO,DR,FHX,LL,NAM,PKG,TXT,X,Y
 Q
AD1 ; Add Dietetic protocol to Adverse Reaction Tracking
 S DA(1)=$O(^ORD(101,"B",$P(X,";",3),0)) I 'DA(1) K DA Q
 K DIC S:'$D(^ORD(101,DA(1),10,0)) ^(0)="^101.01PA^^"
 S DIC="^ORD(101,"_DA(1)_",10,",DIC(0)="L",DLAYGO=101,X=$P(X,";",4) D ^DIC
 I $P(Y,"^",3) W !?2,X," added as item to ",$P(^ORD(101,DA(1),0),"^",1),"."
 K DA,DIC
 Q
