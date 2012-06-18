BCHPOS1 ; IHS/TUCSON/LAB - POST INIT - 2 ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ; - This routine finds or creates the CHR MANAGER mail group
 ; - adds the CHR MANAGER mail group to the following bulletins:
 ;       BCH CHR TRANSMISSION ERROR
 ;       BCH PCC PACKAGE LINK FAIL
 ; - creates the BCH entry in the HL7 APPLICATION PARAMETER file
 ; - adds the 1-99 CHRPC## entries to the HL7 APPLICATION PARAMETER file
 ;
 ;
START ;start of routine
 Q:'$D(^HL(771))
 S BCHFAC=$P(^AUTTLOC($P($G(^AUTTSITE(1,0)),U,1),0),U,10)
 I 'BCHFAC W !,"Unable to determine facility ASUFAC 6-digit number." Q
 S BCHCODE=$O(^HL(779.004,"B","USA",""))
 I 'BCHCODE W !,"Unable to determine Country Code." Q
 D SETVAR ;                  set up DIC variables
 D BCHENTRY ;                create the BCH entry
 D ADD99 ;                   populate the file with 99 entries
 ;
EOJ ;
 K DIC,X,Y,DD,DO,D0,DA,DDH,DI,DIE,DR,DLAYGO
 K BCHN,BCHFAC,BCHCODE,BCHMGRP
 Q
 ;end of routine
 ;----------------------------------
SETVAR ;set up variables for DIC call
 S DIC="^HL(771,",DIC(0)="L",DLAYGO=771
 S DIC("DR")="2////a;3////"_BCHFAC_";4////"_BCHMGRP_";7////"_BCHCODE_";101////~|\&"
 Q
 ;
BCHENTRY ;create the BCH entry
 K DD,DO
 S X="BCH"
 I $D(^HL(771,"B","BCH")) W !,"....exists:  ",X K X Q
 D FILE^DICN K DIC
 I Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 W !,"....adding:  ",X
 K Y,X
 Q
 ;
ADD99 ;populate the file with 99 entries
 ;
 F BCHN=1:1:99 S:BCHN<10 BCHN=0_BCHN D  Q:BCHN>99
 .  K DD,D0 D SETVAR
 .  S X="CHRPC"_BCHN
 .  I $D(^HL(771,"B",X)) W !,"....exists:  ",X Q
 .  D FILE^DICN
 .  I Y<0 W !,"Entry was unsuccessful:  ",X K X Q
 .  W !,"....adding:  ",X
 .  K X
 .  Q
 K DIC,X,Y
 Q
