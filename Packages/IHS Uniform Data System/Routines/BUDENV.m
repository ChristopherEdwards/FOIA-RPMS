BUDENV ; IHS/CMI/LAB - environmental check ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
ENV ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
 ;
PRE ;
 F DA=1:1:50 S DIK="^BUDCNTL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDIL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDTFIVE(" D ^DIK
 F DA=1:1:50 S DIK="^BUDTTA(" D ^DIK
 Q
POST ;
 NEW X
 S X=$$ADD^XPDMENU("BUD MANAGER UTILITIES","APCL TAXONOMY SETUP","TAX",99)
 I 'X W "Attempt to add taxonomy setup option failed.." H 3
 D ^BUDTX
LAB ;
 S BGPX="BGP PAP SMEAR TAX" D LAB1
 S BGPX="BGP HIV TEST TAX" D LAB1
 Q
LAB1 ;
 W !,"Creating ",BGPX," Taxonomy..."
 S BGPDA=$O(^ATXLAB("B",BGPX,0))
 Q:BGPDA  ;taxonomy already exisits
 S X=BGPX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",BGPX," TAX" Q
 S BGPTX=+Y,$P(^ATXLAB(BGPTX,0),U,2)=BGPX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(BGPTX,21,0)="^9002228.02101PA^0^0"
 S DA=BGPTX,DIK="^ATXAX(" D IX1^DIK
 Q
