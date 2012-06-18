BLRMPRL ; cmi/anch/maw - BLR Map Reference Lab Codes to Lab Test File ;
 ;;5.2;LR;**1021,1022**;September 20, 2007
 ;;
 ;;1.0;BLR REFERENCE LAB;;MAR 14, 2005
 ;
 ;this routine will allow a user to map reference lab tests to file
 ;60 lab tests
 ;
MAIN ;PEP - main routine driver
 D ASK
 Q:+$G(Y)<0  ; cmi/anch/maw 7/10/2006 mod for error reported by KM -- Lab Patch 1022
 D ORR(BLRRL)
 D EOJ
 Q
 ;
ASK ;-- ask which reference lab to map
 S DIC="^BLRRL(",DIC(0)="AEMQZ"
 S DIC("A")="Select Which Reference Lab to Map Codes for: "
 D ^DIC
 Q:Y<0
 S BLRRL=+Y
 K DIC
 Q
 ;
ORR(RL) ;EP - ask and map for reference lab test
OR S DIC="^BLRRL("_BLRRL_",1,",DA(1)=RL,DIC(0)="AELMQZ"
 S DIC("A")="Map which Reference Lab Test: "
 D ^DIC
 S BLROR=+Y
 Q:Y<0
 S DIE=DIC,DA=BLROR,DR=".01:10"  ;added edit of .01 at DKR request 2/3/2006 3/24/2006 added field 10
 D ^DIE
 G OR
 ;
EOJ ;-- kill variables and quit
 K BLRRL,RL,DIC,DIE,DR,BLROR
 Q
 ;
