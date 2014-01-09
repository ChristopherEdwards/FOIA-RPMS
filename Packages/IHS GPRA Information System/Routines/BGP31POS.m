BGP31POS ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 08 Dec 2010 3:10 PM ;
 ;;13.0;IHS CLINICAL REPORTING;;NOV 20, 2012;Build 81
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $E($$VERSION^XPDUTL("BGP"),1,3)<"12.0" D MES^XPDUTL($$CJ^XLFSTR("Version 12.0 of BGP is required.  Not installed.",80)) D SORRY(2) I 1
 ;I '$$INSTALLD("BGP*11.1*1") D SORRY(2)
 ;I '$$INSTALLD("BKM*2.1*2") D SORRY(2)
 Q
 ;
PRE ;EP
 ;D PRE^BGP3POS2
 Q
POST ;EP - called from kids build
 ;D ^BGP21
 ;D ^BGP22
 ;D ^BGP23
 ;D ^BGP24
 ;D ^BGP25
 ;D ^BGP26
 ;D ^BGP27
 ;D ^BGP28
 ;D ^BGP29
 ;D ^BGP20
 ;D ^BGP3Y
 ;D ^BGP3W
 ;D ^BGP3V
 ;D ^BGP3T
 ;D DRUGS^BGP3POS1
 ;D ADA
 ;D SETTAXF
 ;D SETTAX
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
ADA ;
 S ATXFLG=1
 S BGPDA=0 S BGPDA=$O(^ATXAX("B","BGP DENTAL EXAM ADA CODES",BGPDA))
 I BGPDA S DIK="^ATXAX(",DA=BGPDA D ^DIK  ;get rid of existing one
 W !,"Creating/Updating DENTAL EXAM ADA Codes Taxonomy..."
 S X="BGP DENTAL EXAM ADA CODES",DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING DENTAL EXAM ADA CODES TAX" Q
 S BGPTX=+Y,$P(^ATXAX(BGPTX,0),U,2)="BGP DENTAL EXAM ADA CODES",$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=174,$P(^(0),U,13)=0,$P(^(0),U,15)=9999999.31,^ATXAX(BGPTX,21,0)="^9002226.02101A^0^0"
 S BGPX=0
 F X="0120","0150","0145",9990 S DIC="^AUTTADA(",DIC(0)="M" D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DQ,DI,D1,D0 I $P(Y,U)>0 D
 .S BGPX=BGPX+1
 .S ^ATXAX(BGPTX,21,BGPX,0)=+Y,$P(^ATXAX(BGPTX,21,0),U,3)=BGPX,$P(^(0),U,4)=BGPX,^ATXAX(BGPTX,21,"AA",+Y,BGPX)=""
 .Q
 S DA=BGPTX,DIK="^ATXAX(" D IX1^DIK
 Q
SETTAXF ;
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  D
 .Q:$P(^ATXLAB(X,0),U,9)]""
 .S $P(^ATXLAB(X,0),U,9)=60
 .Q
 Q
SETTAX ;
 S BGPTFI="" F  S BGPTFI=$O(^ATXAX("B",BGPTFI)) Q:BGPTFI=""  D
 .S BGPTDA=$O(^ATXAX("B",BGPTFI,0))
 .Q:'BGPTDA  ;did not find taxonomy
 .Q:'$$NS(BGPTFI)
 .S $P(^ATXAX(BGPTDA,0),U,4)="n"
 .S F=$P(^ATXAX(BGPTDA,0),U,15)
 .I $$RO(F) S $P(^ATXAX(BGPTDA,0),U,22)=1  ;SET READ ONLY
 .I BGPTFI[" NDC" S $P(^ATXAX(BGPTDA,0),U,22)=1  ;SET READY ONLY FOR NDC TAXONOMIES
SETP .;set packages in multiple
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
RO(T) ;
 I T=81 Q 1
 I T=80 Q 1
 I T=80.1 Q 1
 I T=9999999.31 Q 1
 I T=9999999.64 Q 1
 I T=95.3 Q 1
 Q 0
NS(T,L) ;
 I $E(T,1,3)="BGP" Q 1
 I $E(T,1,7)="SURVEIL" Q 1
 Q 0