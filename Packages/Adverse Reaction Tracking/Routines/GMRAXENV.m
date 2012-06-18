GMRAXENV ;HIRMFO/RM-ENVIRONMENT CHECK ROUTINE ; 12/6/95
 ;;4.0;Adverse Reaction Tracking;;Mar 29, 1996
 I '$G(DUZ)!'$D(DUZ(0)) D  S XPDQUIT=2 Q
 . W !?5,"DUZ and DUZ(0) must be defined as an active user to initialize"
 . W !?5,"the ADVERSE REACTION TRACKING v",$P($T(+2),";",3)," software."
 . W $C(7)
 . Q
 I DUZ(0)'="@" D  S XPDQUIT=2 Q
 . W !?5,"You must have programmer access, i.e., DUZ(0)=@ to continue."
 . W $C(7)
 . Q
 I +$$VERSION^XPDUTL("GMRP")>0,$T(PN^GMRPART)']"" D
 . W !?5,"You have the Progress Notes package installed, but you are"
 . W !?5,"missing the GMRPART routine. Please make certain that"
 . W !?5,"GMRP*2.5*32 is installed."
 . Q
 I +$$VERSION^XPDUTL("DG")<5.3 D  S XPDQUIT=2 Q
 . W !?5,"You need MAS/PIMS v5.3 or greater to install ADVERSE REACTION"
 . W !?5,"TRACKING v",$P($T(+2),";",3),$C(7)
 . Q
 I +$$VERSION^XPDUTL("PSN")<2 D  S XPDQUIT=2 Q
 . W !?5,"You need NATIONAL DRUG FILE v2.0 or greater to install ADVERSE"
 . W !?5,"REACTION TRACKING v",$P($T(+2),";",3),$C(7)
 . Q
 N GMRAVER S GMRAVER=+$$VERSION^XPDUTL("GMRA")
 I 'GMRAVER,$D(^GMRD(120.84)) D  S XPDQUIT=2 Q
 . W !?5,"Bad entry in VERSION node of Package file, call your IRM"
 . W !?5,"Field Office for assistance."
 . Q
 Q:'GMRAVER  ; quit if this is a virgin install
 I GMRAVER<3 D  Q:$G(XPDQUIT)=2
 . Q:$T(GMRARAD1^GMRARAD1)]""
 . W !?5,"You must have installed ALLERGY TRACKING SYSTEM v3.0 prior to"
 . W !?5,"installing ADVERSE REACTION TRACKING v",$P($T(+2),";",3),$C(7)
 . S XPDQUIT=2
 . Q
 I $T(GMRARAD1^GMRARAD1)']"" D  S XPDQUIT=2 Q
 . W !?5,"You must install patch GMRA*3*13 prior to installing"
 . W !?5,"ADVERSE REACTION TRACKING v",$P($T(+2),";",3),$C(7)
 . Q
 D FIND^DIC(9.4,,,"X","GMRA",,"C",,,"GMRAIEN","GMRAERR")
 I +$G(GMRAERR("DIERR")) D  S XPDQUIT=2 Q
 . W !?5,"Error trying to find ADVERSE REACTION TRACKING Package file"
 . W !?5,"entry, notify your IRM Field Office.",$C(7)
 . Q
 S (DA,SEQ)=0 F  S SEQ=$O(GMRAIEN("DILIST",1,SEQ)) Q:SEQ'>0  D  Q:DA<0
 . S NAME=$G(GMRAIEN("DILIST",1,SEQ)) Q:NAME=""
 . I NAME="ADVERSE REACTION TRACKING" S DA=-1 Q
 . I NAME="GEN. MED. REC. - ALLERGIES" S DA=$G(GMRAIEN("DILIST",2,SEQ)) Q
 . I 'DA S DA=$G(GMRAIEN("DILIST",2,SEQ))
 . Q
 I DA>0 D
 .S GMRAHLD=DA
 .S DIE="^DIC(9.4,"
 .S DR=".01////ADVERSE REACTION TRACKING"
 .S DR=DR_";2///Adverse Reaction Tracking package"
 .D ^DIE K DA,DIE,DR
 .S DIE="^DIC(9.4,"
 .S DA=GMRAHLD
 .S DR="3///This package permits clinical users to track and report patient allergies and adverse reactions. The intended users are physicians, nurses, other clinicians and clerks."
 .D ^DIE K DA,DIE,DR
 .Q
 K GMRAIEN,GMRAERR,NAME,SEQ
 Q:'$D(GMRAHLD)
 D FIND^DIC(9.4,,,"X","GMRA",,"C",,,"GMRAIEN","GMRAERR")
 I +$G(GMRAERR("DIERR")) K GMRAIEN,GMRAERR Q
 S (DA,SEQ)=0
 F  S SEQ=$O(GMRAIEN("DILIST",1,SEQ)) Q:SEQ'>0  D
 . S NAME=$G(GMRAIEN("DILIST",1,SEQ)) Q:NAME=""
 . I NAME="ADVERSE REACTION TRACKING" Q
 . S DA=$G(GMRAIEN("DILIST",2,SEQ))
 . I DA S DIK="^DIC(9.4," D ^DIK
 . Q
 K DA,DIK,GMRAERR,GMRAIEN,GMRAHLD,NAME,SEQ
 Q
