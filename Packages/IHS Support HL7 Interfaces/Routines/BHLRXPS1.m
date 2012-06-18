BHLRXPS1 ; IHS/TUCSON/DCP - HL7 - POST-INIT FOR COTS PHARMACY INSTALLATION - 2 ;
 ;;1.0;IHS SUPPORT FOR HL7 INTERFACES;;JUL 7, 1997
 ;
 ; This routine creates the BHLBPS and VIKRX entries in the
 ; HL7 APPLICATION PARAMETER file. It is a continuation of BHLRXPST and
 ; is not independently callable.
 ;
START ; ENTRY POINT from BHLRXPST
 Q:'$D(^HL(771))
 S BHLFAC=$P(^AUTTLOC($P($G(^AUTTSITE(1,0)),U,1),0),U,10)
 I 'BHLFAC W !,"Unable to determine facility ASUFAC 6-digit number." Q
 S BHLCODE=$O(^HL(779.004,"B","USA",""))
 I 'BHLCODE W !,"Unable to determine Country Code." Q
 ;
SETVAR ; set up variables for DIC call
 S DIC="^HL(771,",DIC(0)="L",DLAYGO=771
 S DIC("DR")="2////a;3////"_BHLFAC_";4////"_BHLMGRP_";7////"_BHLCODE_";100////|"
 ;
ADD ; add application parameter entries
 F X="BHLBPS","VIKRX" D
 .  I $D(^HL(771,"B",X)) W !,"....exists:  ",X Q
 .  K DD,DO D FILE^DICN
 .  S ^HL(771,D0,"EC")="^~\&" ;                      encoding characters
 .  I Y<0 W !,"Entry was unsuccessful:  ",X Q
 .  W !,"....adding:  ",X
 .  Q
 ;
EOJ ; clean up and leave
 K DIC,X,Y,DD,DO,D0,DA,DDH,DI,DIE,DR,DLAYGO
 Q
