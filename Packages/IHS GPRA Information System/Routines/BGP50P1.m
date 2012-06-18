BGP50P1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 20 Dec 2004 9:23 AM ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;EP
 F BGPX=1:1:2000 S DA=BGPX,DIK="^BGPINDVC(" D ^DIK
 F BGPX=1:1:50 S DA=BGPX,DIK="^BGPINDV(" D ^DIK
 F BGPX=1:1:250 S DA=BGPX,DIK="^BGPVNPL(" D ^DIK
 F BGPX=1:1:10 S DA=BGPX,DIK="^BGPCTRL(" D ^DIK
 S DIU=90371.04,DIU(0)="" D EN^DIU2
 S DIU=90371.03,DIU(0)="" D EN^DIU2
 S DIU=90371.05,DIU(0)="" D EN^DIU2
 Q
POST ;EP - called from kids build
 D SEC
 D BULL
 D ^BGPTXH
 Q
SEC ;set security on selected dd's
LP ;EP - loop through file entries
 F I=1:1 D  Q:BGPTXT["end"
 .S BGPTXT=$T(TXT+I)
 .Q:BGPTXT["end"
 .F J=2:1:4 S BGP(J)=$P(BGPTXT,";;",J)
 .S BGP(3)=""""_BGP(3)_""""
 .S BGPREF="^DIC("_BGP(2)_",0,"_BGP(3)_")"
 .S @BGPREF=BGP(4)
 Q
TXT ;file entries start here
 ;;90244.01;;AUDIT;;@
 ;;90244.01;;DD;;@
 ;;90244.01;;DEL;;@
 ;;90244.01;;LAYGO;;@
 ;;90244.01;;RD;;M
 ;;90244.01;;WR;;@
 ;;90244.02;;AUDIT;;@
 ;;90244.02;;DD;;@
 ;;90244.02;;DEL;;@
 ;;90244.02;;LAYGO;;@
 ;;90244.02;;RD;;M
 ;;90244.02;;WR;;@
 ;;90371.03;;AUDIT;;@
 ;;90371.03;;DD;;@
 ;;90371.03;;DEL;;@
 ;;90371.03;;LAYGO;;M
 ;;90371.03;;RD;;M
 ;;90371.03;;WR;;M
 ;;90371.04;;AUDIT;;@
 ;;90371.04;;DD;;@
 ;;90371.04;;DEL;;@
 ;;90371.04;;LAYGO;;M
 ;;90371.04;;RD;;M
 ;;90371.04;;WR;;M
 ;;90371.05;;AUDIT;;@
 ;;90371.05;;DD;;@
 ;;90371.05;;DEL;;@
 ;;90371.05;;LAYGO;;M
 ;;90371.05;;RD;;M
 ;;90371.05;;WR;;M
 ;;90372.03;;AUDIT;;@
 ;;90372.03;;DD;;@
 ;;90372.03;;DEL;;M
 ;;90372.03;;LAYGO;;M
 ;;90372.03;;RD;;M
 ;;90372.03;;WR;;M
 ;;90372.05;;AUDIT;;@
 ;;90372.05;;DD;;@
 ;;90372.05;;DEL;;M
 ;;90372.05;;LAYGO;;M
 ;;90372.05;;RD;;M
 ;;90372.05;;WR;;M
 ;;end
 Q
BULL ;bulletin wth updates
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"BGPBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""BGPBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_BGPKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"BGPBUL"),BGPKEY
 Q
 ;
WRITEMSG ;
 S BGPIEN=$O(^BGPCTRL("B","2005",0))
 I BGPIEN="" W !!,"couldn't find bulletin text" Q
 S Y=0,%=0 F  S Y=$O(^BGPCTRL(BGPIEN,98,1,11,Y)) Q:Y'=+Y  S X=$G(^BGPCTRL(BGPIEN,98,1,11,Y,0)) S %=%+1,^TMP($J,"BGPBUL",%)=X
 Q
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,BGPKEY="BGPZMENU"
 F  S CTR=$O(^XUSEC(BGPKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
