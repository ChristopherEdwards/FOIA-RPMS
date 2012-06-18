BGP8POS ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM 25 Nov 2007 7:41 PM ; 
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("ATX*5.1*10") D SORRY(2)
 ;I '$$INSTALLD("IHS CLINICAL REPORTING 7.0") D SORRY(2)
 I '$$INSTALLD("BGP*7.0*2") D SORRY(2)
 I '$$INSTALLD("BKM*1.0*3") D SORRY(2)
 I '$$INSTALLD("AUPN*99.1*18") D SORRY(2)
 I '$$INSTALLD("APCL*3.0*20") D SORRY(2)
 ;I '$D(^DIC(9.4,"C","LEX")) D SORRY(2)
 ;I '$$INSTALLD("BKM*1.0*2") D SORRY(2)
 Q
 ;
PRE ;EP
 D PRE^BGP8POS2
 Q
POST ;EP - called from kids build
 ;NEW X
 ;S X=$$ADD^XPDMENU("BGPMENU","BGP 08 MENU","CI08",50)
 ;I 'X W "Attempt to add National GPRA report for GPRA year 2008 option failed.." H 3
 S ATXFLG=1
 D EN^XBVK("ATX")
 K ^TMP("ATX",$J)
MT ;MOVE TEMPORARY TAXONOMIES TO ATXAX
 S ATXFLG=1
 S BGPX=0 F  S BGPX=$O(^BGPTAXTE(BGPX)) Q:BGPX'=+BGPX  D
 .S BGPN=$P(^BGPTAXTE(BGPX,0),U)
 .S BGPY=$O(^ATXAX("B",BGPN,0))
 .I BGPY S DA=BGPY,DIK="^ATXAX(" D ^DIK
 .S X=BGPN,DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 .I Y=-1 W !!,"creating taxonomy failed....",BGPN Q
 .S BGPZ=+Y
 .M ^ATXAX(BGPZ)=^BGPTAXTE(BGPX)
 .I $D(^ATXAX(BGPZ,21,0)) S $P(^ATXAX(BGPZ,21,0),U,2)="9002226.02101A"
 .I $D(^ATXAX(BGPZ,41,0)) S $P(^ATXAX(BGPZ,41,0),U,2)="9002226.04101P"
 .S DA=BGPZ,DIK="^ATXAX(" D IX1^DIK
 .Q
 D ^BGP8AX
 D ^BGP8BX
 D ^BGP8CX
 D ^BGP8DX
 D ^BGP8EX
 D ^BGP8FX
 D ^BGP8GX
 D ^BGP8HX
 D ^BGP8IX,^BGP8JX
 D PRVTAX^BGP8POS1
 D CLTAX^BGP8POS1
 D MHTAX^BGP8POS1
 D LAB^BGP8POS1
 D DRUGS^BGP8POS1
 K ATXFLG
 S X=0 F  S X=$O(^ATXAX(X)) Q:X'=+X  I $E($P($G(^ATXAX(X,0)),U,1),1,3)["BGP" S $P(^ATXAX(X,0),U,4)="n"
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  I $E($P($G(^ATXLAB(X,0)),U,1),1,3)["BGP" S $P(^ATXLAB(X,0),U,4)="n"
 D EN^XBVK("BGP")
 ;D SEC
 D SETTAX
 D SETTAXL
 D SETTAXF
 D SEC
 Q
 ;
SETTAXF ;
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  D
 .Q:$P(^ATXLAB(X,0),U,9)]""
 .S $P(^ATXLAB(X,0),U,9)=60
 .Q
 Q
SETTAX ;
 Q:'$D(^DD(9002226,4101,0))  ;taxonomy patch not yet installed
 S BGPTFI="" F  S BGPTFI=$O(^BGPTAXE("B",BGPTFI)) Q:BGPTFI=""  D
 .S BGPTFIEN=$O(^BGPTAXE("B",BGPTFI,0))
 .I 'BGPTFIEN Q
 .Q:'$D(^BGPTAXE(BGPTFIEN))
 .Q:$P(^BGPTAXE(BGPTFIEN,0),U,2)="L"
 .S BGPTDA=$O(^ATXAX("B",BGPTFI,0))
 .Q:'BGPTDA  ;did not find taxonomy
 .S BGPE=$P(^BGPTAXE(BGPTFIEN,0),U,4)
 .I BGPE=0 S $P(^ATXAX(BGPTDA,0),U,22)=1
 .I BGPE=1 S $P(^ATXAX(BGPTDA,0),U,22)=0
 .S $P(^ATXAX(BGPTDA,0),U,4)="n"
 .;set packages in multiple
 .K DIC,DA,DR
 .S BGPPI=$O(^DIC(9.4,"C","BGP",0))
 .Q:BGPPI=""  ;NO PACKAGE
 .Q:$D(^ATXAX(BGPTDA,41,"B",BGPPI))
 .S X="`"_BGPPI,DIC="^ATXAX("_BGPTDA_",41,",DIC(0)="L",DIC("P")=$P(^DD(9002226,4101,0),U,2),DA(1)=BGPTDA
 .D ^DIC
 .I Y=-1 W !,"updating package multiple for ",BGPPP," entry ",$P(^ATXAX(BGPDA,0),U)," failed"
 .K DIC,DA,Y,X
 .Q
 Q
SETTAXL ;
 Q:'$D(^DD(9002228,4101,0))  ;taxonomy patch not yet installed
  S BGPTFI="" F  S BGPTFI=$O(^BGPTAXE("B",BGPTFI)) Q:BGPTFI=""  D
 .S BGPTFIEN=$O(^BGPTAXE("B",BGPTFI,0))
 .I 'BGPTFIEN Q
 .Q:'$D(^BGPTAXE(BGPTFIEN))
 .Q:$P(^BGPTAXE(BGPTFIEN,0),U,2)='"L"
 .S BGPTDA=$O(^ATXLAB("B",BGPTFI,0))
 .Q:'BGPTDA  ;did not find taxonomy
 .S BGPE=$P(^BGPTAXE(BGPTFIEN,0),U,4)
 .I BGPE=0 S $P(^ATXLAB(BGPTDA,0),U,22)=1
 .I BGPE=1 S $P(^ATXLAB(BGPTDA,0),U,22)=0
 .S $P(^ATXLAB(BGPTDA,0),U,4)="n"
 .;set packages in multiple
 .K DIC,DA,DR
 .S BGPPI=$O(^DIC(9.4,"C","BGP",0))
 .Q:BGPPI=""  ;NO PACKAGE
 .Q:$D(^ATXLAB(BGPTDA,41,"B",BGPPI))
 .S X="`"_BGPPI,DIC="^ATXLAB("_BGPTDA_",41,",DIC(0)="L",DIC("P")=$P(^DD(9002228,4101,0),U,2),DA(1)=BGPTDA
 .D ^DIC
 .I Y=-1 W !,"updating package multiple for ",BGPPP," entry ",$P(^ATXAX(BGPDA,0),U)," failed"
 .K DIC,DA,Y,X
 .Q
 Q
INSTALLD(BGPSTAL) ;EP - Determine if patch BGPSTAL was installed, where
 ; BGPSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BGPY,DIC,X,Y
 S X=$P(BGPSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BGPSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BGPSTAL,"*",3)
 D ^DIC
 S BGPY=Y
 D IMES
 Q $S(BGPY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BGPSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
CLINICS ;
 ;;01
 ;;06
 ;;13
 ;;20
 ;;24
 ;;28
 ;;
PRVS ;
 ;;00
 ;;11
 ;;16
 ;;17
 ;;18
 ;;21
 ;;25
 ;;33
 ;;41
 ;;44
 ;;45
 ;;49
 ;;64
 ;;68
 ;;69
 ;;70
 ;;71
 ;;72
 ;;73
 ;;74
 ;;75
 ;;76
 ;;77
 ;;78
 ;;79
 ;;80
 ;;81
 ;;82
 ;;83
 ;;84
 ;;85
 ;;86
 ;;A1
 ;;
PREPROV ;;
 ;;00
 ;;08
 ;;11
 ;;16
 ;;17
 ;;18
 ;;21
 ;;24
 ;;25
 ;;30
 ;;33
 ;;41
 ;;44
 ;;45
 ;;47
 ;;49
 ;;64
 ;;67
 ;;68
 ;;70
 ;;71
 ;;72
 ;;73
 ;;74
 ;;75
 ;;76
 ;;77
 ;;78
 ;;79
 ;;80
 ;;81
 ;;82
 ;;83
 ;;85
 ;;86
 ;;A1
 ;;A9
 ;;B1
 ;;B2
 ;;B3
 ;;B4
 ;;B5
 ;;B6
 ;;
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
 ;;90371.04;;AUDIT;;@
 ;;90371.04;;DD;;@
 ;;90371.04;;DEL;;@
 ;;90371.04;;LAYGO;;M
 ;;90371.04;;RD;;M
 ;;90371.04;;WR;;M
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
 ;;90533.12;;AUDIT;;@
 ;;90533.12;;DD;;@
 ;;90533.12;;DEL;;@
 ;;90533.12;;LAYGO;;M
 ;;90533.12;;RD;;M
 ;;90533.12;;WR;;M
 ;;90533.13;;AUDIT;;@
 ;;90533.13;;DD;;@
 ;;90533.13;;DEL;;M
 ;;90533.13;;LAYGO;;M
 ;;90533.13;;RD;;M
 ;;90533.13;;WR;;M
 ;;90533.14;;AUDIT;;@
 ;;90533.14;;DD;;@
 ;;90533.14;;DEL;;M
 ;;90533.14;;LAYGO;;M
 ;;90533.14;;RD;;M
 ;;90533.14;;WR;;M
 ;;end
 Q
