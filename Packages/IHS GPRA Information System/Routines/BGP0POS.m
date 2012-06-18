BGP0POS ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM 25 Nov 2008 7:41 PM ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BGP*9.0*1") D SORRY(2)
 I $E($$VERSION^XPDUTL("BMX"),1,3)<"4.0" D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of BMX is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires BMX v4.0....Present.",80))
 Q
 ;
PRE ;EP
 D PRE^BGP0POS2
 Q
POST ;EP - called from kids build
 D SCHEMA
 D ^BGP0TX  ;install all taxonomies
 D LAB^BGP0POS1
 D DRUGS^BGP0POS1
 D DMADA
 K ATXFLG
 S X=0 F  S X=$O(^ATXAX(X)) Q:X'=+X  I $E($P($G(^ATXAX(X,0)),U,1),1,3)["BGP" S $P(^ATXAX(X,0),U,4)="n"
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  I $E($P($G(^ATXLAB(X,0)),U,1),1,3)["BGP" S $P(^ATXLAB(X,0),U,4)="n"
 D SETTAX
 D SETTAXL
 D SETTAXF
 D SEC
 D EN^XBVK("ATX")
 D EN^XBVK("BGP")
 Q
SCHEMA ;
 S DA=$O(^BMXADO("B","BGP 06 HEDIS INDICATORS",0))
 I 'DA D
 . D ^XBFMK
 . S X="BGP 06 HEDIS INDICATORS"
 . S DIC="^BMXADO(",DIC(0)="L",DIADD=1,DLAYGO=90093.99
 . K DD,D0,DO
 . S DIC("DR")=".02///90375.01"
 . D FILE^DICN
 . I Y=-1 W !!,"Creating schema failed!! " Q
 . S Y=+Y
 . S ^BMXADO(Y,1,0)="^90093.991^1^1"
 . S ^BMXADO(Y,1,1,0)=".05^T^80^Indicator"
 . S ^BMXADO(Y,1,"B",.05,1)=""
 . S DA=Y,DIK="^BMXADO(" D IX1^DIK
 . Q
 S DA=$O(^BMXADO("B","BGP 07 HEDIS INDICATORS",0))
 I 'DA D
 . D ^XBFMK
 . S X="BGP 07 HEDIS INDICATORS"
 . S DIC="^BMXADO(",DIC(0)="L",DIADD=1,DLAYGO=90093.99
 . K DD,D0,DO
 . S DIC("DR")=".02///90531.01"
 . D FILE^DICN
 . I Y=-1 W !!,"Creating schema failed!! " Q
 . S Y=+Y
 . S ^BMXADO(Y,1,0)="^90093.991^1^1"
 . S ^BMXADO(Y,1,1,0)=".05^T^80^Indicator"
 . S ^BMXADO(Y,1,"B",.05,1)=""
 . S DA=Y,DIK="^BMXADO(" D IX1^DIK
 . Q
 S DA=$O(^BMXADO("B","BGP 08 HEDIS INDICATORS",0))
 I 'DA D
 . D ^XBFMK
 . S X="BGP 08 HEDIS INDICATORS"
 . S DIC="^BMXADO(",DIC(0)="L",DIADD=1,DLAYGO=90093.99
 . K DD,D0,DO
 . S DIC("DR")=".02///90534.01"
 . D FILE^DICN
 . I Y=-1 W !!,"Creating schema failed!! " Q
 . S Y=+Y
 . S ^BMXADO(Y,1,0)="^90093.991^1^1"
 . S ^BMXADO(Y,1,1,0)=".05^T^80^Indicator"
 . S ^BMXADO(Y,1,"B",.05,1)=""
 . S DA=Y,DIK="^BMXADO(" D IX1^DIK
 . Q
 S DA=$O(^BMXADO("B","BGP 09 HEDIS INDICATORS",0))
 I 'DA D
 . D ^XBFMK
 . S X="BGP 09 HEDIS INDICATORS"
 . S DIC="^BMXADO(",DIC(0)="L",DIADD=1,DLAYGO=90093.99
 . K DD,D0,DO
 . S DIC("DR")=".02///90537.01"
 . D FILE^DICN
 . I Y=-1 W !!,"Creating schema failed!! " Q
 . S Y=+Y
 . S ^BMXADO(Y,1,0)="^90093.991^1^1"
 . S ^BMXADO(Y,1,1,0)=".05^T^80^Indicator"
 . S ^BMXADO(Y,1,"B",.05,1)=""
 . S DA=Y,DIK="^BMXADO(" D IX1^DIK
 . Q
 S DA=$O(^BMXADO("B","BGP 10 HEDIS INDICATORS",0))
 I 'DA D
 . D ^XBFMK
 . S X="BGP 10 HEDIS INDICATORS"
 . S DIC="^BMXADO(",DIC(0)="L",DIADD=1,DLAYGO=90093.99
 . K DD,D0,DO
 . S DIC("DR")=".02///90378.01"
 . D FILE^DICN
 . I Y=-1 W !!,"Creating schema failed!! " Q
 . S Y=+Y
 . S ^BMXADO(Y,1,0)="^90093.991^1^1"
 . S ^BMXADO(Y,1,1,0)=".05^T^80^Indicator"
 . S ^BMXADO(Y,1,"B",.05,1)=""
 . S DA=Y,DIK="^BMXADO(" D IX1^DIK
 . Q
 Q
DMADA ;
 S ATXFLG=1
 S BGPDA=0 S BGPDA=$O(^ATXAX("B","BGP TOPICAL FLUORIDE ADA CODES",BGPDA))
 I BGPDA S DIK="^ATXAX(",DA=BGPDA D ^DIK  ;get rid of existing one
 W !,"Creating/Updating Topical Fluoride ADA Codes Taxonomy..."
 S X="BGP TOPICAL FLUORIDE ADA CODES",DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING TOPICAL FLUORIDE ADA CODES TAX" Q
 S BGPTX=+Y,$P(^ATXAX(BGPTX,0),U,2)="BGP TOPICAL FLUORIDE ADA CODES",$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=174,$P(^(0),U,13)=0,$P(^(0),U,15)=9999999.31,^ATXAX(BGPTX,21,0)="^9002226.02101A^0^0"
 S BGPX=0
 F X=1201,1203,1204,1205,1206,5986 S DIC="^AUTTADA(",DIC(0)="M" D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DQ,DI,D1,D0 I $P(Y,U)>0 D
 .S BGPX=BGPX+1
 .S ^ATXAX(BGPTX,21,BGPX,0)=+Y,$P(^ATXAX(BGPTX,21,0),U,3)=BGPX,$P(^(0),U,4)=BGPX,^ATXAX(BGPTX,21,"AA",+Y,BGPX)=""
 .Q
 S DA=BGPTX,DIK="^ATXAX(" D IX1^DIK
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
 S BGPTFI="" F  S BGPTFI=$O(^BGPTAXT("B",BGPTFI)) Q:BGPTFI=""  D
 .S BGPTFIEN=$O(^BGPTAXT("B",BGPTFI,0))
 .I 'BGPTFIEN Q
 .Q:'$D(^BGPTAXT(BGPTFIEN))
 .Q:$P(^BGPTAXT(BGPTFIEN,0),U,2)="L"
 .S BGPTDA=$O(^ATXAX("B",BGPTFI,0))
 .Q:'BGPTDA  ;did not find taxonomy
 .S BGPE=$P(^BGPTAXT(BGPTFIEN,0),U,4)
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
  S BGPTFI="" F  S BGPTFI=$O(^BGPTAXT("B",BGPTFI)) Q:BGPTFI=""  D
 .S BGPTFIEN=$O(^BGPTAXT("B",BGPTFI,0))
 .I 'BGPTFIEN Q
 .Q:'$D(^BGPTAXT(BGPTFIEN))
 .Q:$P(^BGPTAXT(BGPTFIEN,0),U,2)='"L"
 .S BGPTDA=$O(^ATXLAB("B",BGPTFI,0))
 .Q:'BGPTDA  ;did not find taxonomy
 .S BGPE=$P(^BGPTAXT(BGPTFIEN,0),U,4)
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
 ;;90377.12;;AUDIT;;@
 ;;90377.12;;DD;;@
 ;;90377.12;;DEL;;@
 ;;90377.12;;LAYGO;;M
 ;;90377.12;;RD;;M
 ;;90377.12;;WR;;M
 ;;90377.13;;AUDIT;;@
 ;;90377.13;;DD;;@
 ;;90377.13;;DEL;;M
 ;;90377.13;;LAYGO;;M
 ;;90377.13;;RD;;M
 ;;90377.13;;WR;;M
 ;;90377.14;;AUDIT;;@
 ;;90377.14;;DD;;@
 ;;90377.14;;DEL;;M
 ;;90377.14;;LAYGO;;M
 ;;90377.14;;RD;;M
 ;;90377.14;;WR;;M
 ;;end
 Q
