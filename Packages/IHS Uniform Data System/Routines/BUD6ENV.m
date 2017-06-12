BUD6ENV ; IHS/CMI/LAB - environmental check ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
ENV ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("AICD*3.51*7") D SORRY(2)
 I '$D(^DIC(9.4,"C","LEX")) D SORRY(2)
 Q
 ;
 ;
PRE ;
 F DA=1:1:50 S DIK="^BUDVCNTL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDVIL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDVFIV(" D ^DIK
 F DA=1:1:50 S DIK="^BUDVTTA(" D ^DIK
 F DA=1:1:50 S DIK="^BUDSCNTL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDSIL(" D ^DIK
 F DA=1:1:50 S DIK="^BUDSFIV(" D ^DIK
 F DA=1:1:50 S DIK="^BUDSTTA(" D ^DIK
 Q
POST ;
 ;move site parameters from 04 to 05 on first time install only
 I '$O(^BUDSSITE(0)) D
 .S BUDX=0 F  S BUDX=$O(^BUDVSITE(BUDX)) Q:BUDX'=+BUDX   D
 ..M ^BUDSSITE(BUDX)=^BUDVSITE(BUDX)
 ..S DA=BUDX,DIK="^BUDSSITE(" D IX1^DIK
 D ^BUD6TX
LAB ;
 S BUDX="BGP PAP SMEAR TAX" D LAB1
 S BUDX="BGP HIV TEST TAX" D LAB1
 D SETTAX
 D SETTAXL
 Q
LAB1 ;
 W !,"Creating ",BUDX," Taxonomy..."
 S BUDDA=$O(^ATXLAB("B",BUDX,0))
 Q:BUDDA  ;taxonomy already exisits
 S X=BUDX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",BUDX," TAX" Q
 S BUDTX=+Y,$P(^ATXLAB(BUDTX,0),U,2)=BUDX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(BUDTX,21,0)="^9002228.02101PA^0^0"
 S DA=BUDTX,DIK="^ATXAX(" D IX1^DIK
 Q
SETTAX ;
 Q:'$D(^DD(9002226,4101,0))  ;taxonomy patch not yet installed
 S BUDTEXT="TAX" F BUDX=1:1 S BUDDATA=$P($T(@BUDTEXT+BUDX),";;",2) Q:BUDDATA=""  D
 .S BUDDA=$O(^ATXAX("B",$P(BUDDATA,"|"),0))
 .Q:BUDDA=""
 .S $P(^ATXAX(BUDDA,0),U,4)="n" W !,$P(BUDDATA,"|")  ;SET NO DELETE
 .S $P(^ATXAX(BUDDA,0),U,22)=$P(BUDDATA,"|",2) ;set read only
 .;set packages in multiple
 .K DIC,DA,DR
 .S BUDP=$P(BUDDATA,"|",3)
 .F BUDN=1:1 S BUDPP=$P(BUDP,"*",BUDN) Q:BUDPP=""  D
 ..S BUDPI=$O(^DIC(9.4,"C",BUDPP,0))
 ..Q:BUDPI=""  ;NO PACKAGE
 ..S X="`"_BUDPI,DIC="^ATXAX("_BUDDA_",41,",DIC(0)="L",DIC("P")=$P(^DD(9002226,4101,0),U,2),DA(1)=BUDDA
 ..D ^DIC
 ..I Y=-1 W !,"updating package multiple for ",BUDPP," entry ",$P(^ATXAX(BUDDA,0),U)," failed"
 ..K DIC,DA,Y,X
 .Q
 Q
SETTAXL ;
 Q:'$D(^DD(9002228,4101,0))  ;taxonomy patch not yet installed
 S BUDTEXT="LABTAX" F BUDX=1:1 S BUDDATA=$P($T(@BUDTEXT+BUDX),";;",2) Q:BUDDATA=""  D
 .S BUDDA=$O(^ATXLAB("B",$P(BUDDATA,"|"),0))
 .Q:BUDDA=""
 .S $P(^ATXLAB(BUDDA,0),U,4)="n" W !,$P(BUDDATA,"|")  ;SET NO DELETE
 .S $P(^ATXLAB(BUDDA,0),U,22)=$P(BUDDATA,"|",2) ;set read only
 .;set packages in multiple
 .K DIC,DA,DR
 .S BUDP=$P(BUDDATA,"|",3)
 .F BUDN=1:1 S BUDPP=$P(BUDP,"*",BUDN) Q:BUDPP=""  D
 ..S BUDPI=$O(^DIC(9.4,"C",BUDPP,0))
 ..Q:BUDPI=""  ;NO PACKAGE
 ..S X="`"_BUDPI,DIC="^ATXLAB("_BUDDA_",41,",DIC(0)="L",DIC("P")=$P(^DD(9002228,4101,0),U,2),DA(1)=BUDDA
 ..D ^DIC
 ..I Y=-1 W !,"updating package multiple for ",BUDPP," entry ",$P(^ATXLAB(BUDDA,0),U)," failed"
 ..K DIC,DA,Y,X
 .Q
 Q
INSTALLD(BUDSTAL) ;EP - Determine if patch BUDSTAL was installed, where
 ; BUDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BUDY,DIC,X,Y
 S X=$P(BUDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BUDSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BUDSTAL,"*",3)
 D ^DIC
 S BUDY=Y
 D IMES
 Q $S(BUDY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BUDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
LABTAX ;
 ;;BGP HIV TEST TAX|0|BUD
 ;;BGP PAP SMEAR TAX|0|BUD
 ;;
TAX ; 
 ;;BUD CPT HIV TESTS|1|BUD
 ;;BUD CPT PAP 05|1|BUD
 ;;BGP HIV TEST LOINC CODES|1|BUD
 ;;BGP PAP LOINC CODES|1|BUD
 ;;BUD IMM CPTS|1|BUD
 ;;BUD L26 CPTS|1|BUD
 ;;
