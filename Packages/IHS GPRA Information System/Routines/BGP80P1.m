BGP80P1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM 25 Nov 2007 7:41 PM ; 
 ;;8.0;IHS CLINICAL REPORTING;**1**;MAR 12, 2008
 ;
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BGP")'="8.0" D SORRY(2)
 Q
 ;
PRE ;EP
 S BGPX=0 F  S BGPX=$O(^BGPCTRL(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPCTRL(" D ^DIK
 S BGPX=0 F  S BGPX=$O(^BGPINDE(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPINDE(" D ^DIK
 S BGPX=0 F  S BGPX=$O(^BGPELIE(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPELIE(" D ^DIK
 Q
 ;
POST ;EP - called from kids build
 I '$O(^BMXADO("B","CMI VIEW HOSPITAL LOCATION",0)) D
 .N BGPIENS,BGPFDA,BGPERR
 .S BGPIENS=""
 .S BGPFDA(90093.99,"+1,",.01)="CMI VIEW HOSPITAL LOCATION"
 .S BGPFDA(90093.99,"+1,",.02)=44
 .S BGPFDA(90093.991,"+2,+1,",.01)=.01
 .S BGPFDA(90093.991,"+2,+1,",.02)="T"
 .S BGPFDA(90093.991,"+2,+1,",.03)=30
 .S BGPFDA(90093.991,"+2,+1,",.04)="Clinic"
 .D UPDATE^DIE("","BGPFDA","BGPIENS","BGPERR(1)")
 .I $D(BGPERR) W !,"Error install BMX ADO SCHEMA, CMI VIEW HOSPITAL LOCATION" Q
 ;
 S DA=$O(^DIC(19,"B","BGP 08 PTS W SCHED APPT",0))
 I DA S DIE="^DIC(19,",DR="3///BGPZ PATIENT LISTS" D ^DIE K DIE,DA
 S DA=$O(^DIC(19,"B","BGP 08 OTHER NATIONAL LISTS",0))
 I DA S DIE="^DIC(19,",DR="3///BGPZ PATIENT LISTS" D ^DIE K DIE,DA
 S ATXFLG=1
 D EN^XBVK("ATX")
 K ^TMP("ATX",$J)
 D ^BGP80TX
 K ATXFLG
 S X=0 F  S X=$O(^ATXAX(X)) Q:X'=+X  I $E($P($G(^ATXAX(X,0)),U,1),1,3)["BGP" S $P(^ATXAX(X,0),U,4)="n"
 S X=0 F  S X=$O(^ATXLAB(X)) Q:X'=+X  I $E($P($G(^ATXLAB(X,0)),U,1),1,3)["BGP" S $P(^ATXLAB(X,0),U,4)="n"
 D EN^XBVK("BGP")
 D SETTAX
 D SETTAXL
 D SEC
 Q
 ;
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
