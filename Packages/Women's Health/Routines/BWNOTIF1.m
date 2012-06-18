BWNOTIF1 ;IHS/ANMC/MWR - BW ADD/EDIT BW NOTIFICATIONS;15-Feb-2003 22:02;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  STUFFS A NORMAL LETTER FOR THIS PATIENT.  CALLED BY BWNOTIF.
 ;
 ;
NORMALL(BWDFN,BWACCN,BWSPEC,BWSPTX) ;EP
 ;---> STUFF A NORMAP PAP/MAM RESULT LETTER ENTRY IN BW NOTIF FILE.
 ;---> REQUIRED VARIABLES: BWDFN=IEN OF BW PATIENT (FILE 9002086),
 ;--->                     BWACCN=ACCESSION# FOR PROCEDURE.
 ;--->                     BWSPEC=1 FOR PAP, 3,4 OR 5 FOR MAM.
 ;--->                     BWSPTX=TEXT OF THE SPECIAL PROCEDURE.
 N BWPC,BWPURP,X
 ;
 I '$D(BWDFN)!('$D(BWACCN))!('$D(BWSPEC)) D  D NOLETT Q
 .W !!?5,"* Patient DFN or Accession# or Special Procedure Code "
 .W "undefined.",!,"  Contact Site Manager."
 ;
 I '$D(^BWSITE(DUZ(2),0)) D  D NOLETT Q
 .W !!?5,"* Site Parameters for ",$$INSTTX^BWUTL6(DUZ(2))
 .W " have not been set."
 ;
 ;---> FIND PIECE OF ^BWSITE THAT IDENTIFIES PAP/MAM NORMAL LETTER.
 S BWPC=$S(BWSPEC=1:4,BWSPEC=2:8,1:0)
 S BWPURP=$P(^BWSITE(DUZ(2),0),U,BWPC)
 I 'BWPURP D  D NOLETT Q
 .W !!?5,"* The Normal ",BWSPTX," Result Letter is not identified in"
 .W !?7,"the Site Parameter file.  Check the Site Parameter File."
 ;
 I '$O(^BWNOTP(BWPURP,1,0)) D  D NOLETT Q
 .W !!?5,"* In the Site Parameter file, the Normal ",BWSPTX
 .W " Result letter"
 .W !?7,"chosen has no letter text entered.  Check the Notification "
 .W !?7,"Purpose&Letter File."
 ;
 ;---> NOW STUFF A PAP/MAM RESULT NORMAL LETTER WITH ALL FIELDS ENTERED,
 ;---> QUEUED TO BE PRINTED TODAY.
 N DIC,Y
 S X=BWDFN
 K DD,DO S DIC="^BWNOT(",DIC(0)="ML",DLAYGO=9002086
 S DIC("DR")=".02///T;.03///LETTER, FIRST;.04///"_BWPURP
 S DIC("DR")=DIC("DR")_";.05///"_BWSPTX_" NORMAL LETTER SENT;.06///"
 S DIC("DR")=DIC("DR")_BWACCN_";.07////"_DUZ(2)_";.08///T;.11///T"
 S DIC("DR")=DIC("DR")_";.13///T;.14///CLOSED"
 D FILE^DICN
 ;---> IF Y<0, CHECK PERMISSIONS.
 D:Y<0
 .W !!?5,"COULD NOT ADD NOTIFICATION, PERMISSION PROBLEM."
 .W !?5,"CONTACT YOUR SITE MANAGER."  D NOLETT
 Q
 ;
NOLETT ;EP
 W !?5,"* NO LETTER QUEUED!" D DIRZ^BWUTL3
 Q
