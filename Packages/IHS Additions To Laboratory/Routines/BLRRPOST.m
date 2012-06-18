BLRRPOST ; cmi/anch/maw - BLR Reference Lab Post Init ; [ 03/13/06 ]
 ;;5.2;LR;**1021**;Jul 27, 2006
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;
 ;this routine will set up the necessary site parameters and compile
 ;the scripts for the Reference Lab software
 ;
MAIN ;PEP - Main Routine Driver
 D SETLA7
 D SITE
 D CUSER
 D UPIN
 D EOJ
 Q
 ;
SITE ;EP - setup the site parameters in BLR MASTER CONTROL
 ;and BLR REFERENCE LAB
 X ^%ZOSF("EON")
 W !,"Now setting up reference lab parameters.."
 S DIC="^BLRRL(",DIC(0)="AEMQZ"
 S DIC("A")="Setup Parameters for which Reference Lab: "
 D ^DIC
 S BLRRL=+Y
 Q:'BLRRL
 S BLRRLE=$P($G(^BLRRL(BLRRL,0)),U)
 S DIE=DIC,DA=BLRRL,DR=".02:.07;.09;.16;1:7;20"
 D ^DIE
 K DIE,DR,DIC,DA
 W !!,"Now setting up GIS HL7 Message Parameters.."
 S BLRMSG=$O(^INTHL7M("B","HL IHS LAB O01 "_BLRRLE,0))
 Q:'BLRMSG
 S BLRMSGI=$O(^INTHL7M("B","HL IHS LAB O01 "_BLRRLE_" IN",0))
 Q:'BLRMSGI
 S DIE="^INTHL7M(",DA=BLRMSG,DR="7.01:7.04;.08///N"
 D ^DIE
 S DA=BLRMSGI,DR=".08///N"
 D ^DIE
 K DIE,DR,DA
 S DIC="^BLRSITE(",DIC(0)="AEMQZ"
 S DIC("A")="Add this Reference Lab to which Site: "
 D ^DIC
 Q:Y<0
 S DIE=DIC,DA=+Y,DR="3001////"_BLRRL
 D ^DIE
 K DIC,DIE,DR,DA
 W !!,"Now setting up Lab HL7 Message Parameter File.."
 I $O(^LAHM(62.48,"B",BLRRLE,0)) D
 . K DD,DO,DIC
 . S BLRHM=$O(^LAHM(62.48,"B",BLRRLE,0))
 . I 'BLRHM W !!,"Error creating entry in LAHM(62.48" Q
 . S DA(1)=BLRHM
 . S DIC="^LAHM(62.48,"_DA(1)_",90,",DIC(0)="L"
 . S DIC("P")=$P(^DD(62.48,90,0),U,2)
 . S BLRRID=$P($G(^INTHL7M(BLRMSG,7)),U,4)_$P($G(^INTHL7M(BLRMSG,7)),U,2)
 . S X=BLRRID
 . D FILE^DICN
 . I '+$G(Y) W !!,"Error creating entry in LAHM(62.48" Q
 . S DIE="^LAHM(62.48,",DA=BLRHM,DR="2///A"
 . D ^DIE
 W !!,"Now activating Reference Lab Interface.."
 F BLRY=BLRMSG,BLRMSGI D COMPILE^BHLU(BLRY)
 Q
 ;
SETLA7 ;-- setup the LA7 Message Parameter File
 S BLRDA=0 F  S BLRDA=$O(^BLRRL(BLRDA)) Q:'BLRDA  D
 . K DD,DO,DIC
 . S BLRRF=$P($G(^BLRRL(BLRDA,0)),U)
 . S BLRPIN="D QUE^BLR"_$E(BLRRF,1)_"IIN"
 . Q:$O(^LAHM(62.48,"B",BLRRF,0))
 . S DIC="^LAHM(62.48,",DIC(0)="L"
 . S X=BLRRF
 . S DIC("DR")="1///HL7;2///I;4///Y;5///"_$G(BLRPIN)
 . D FILE^DICN
 Q
 ;
CUSER ;-- create a lab technician user for the interface
 W !,"Now creating TECHNICIAN,LAB for filing data..."
 Q:$O(^VA(200,"B","TECHNICIAN,LAB",0))
 K DD,DO
 S DIC="^VA(200,",DIC(0)="L",X="TECHNICIAN,LAB"
 S DIC("DR")="1///LT"
 D FILE^DICN
 K DIC
 Q
 ;
UPIN ;-- create UPIN cross reference
 Q
 ;
EOJ ;-- kill variables and quit     
 X ^%ZOSF("EOFF")
 D EN^XBVK("BLR")
 Q
 ;
