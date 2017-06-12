BSTSUPD ;GDIT/HS/ALA-Update parameters ; 19 Nov 2012  9:54 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;;Sep 10, 2014;Build 101
 Q
 ;
WEB ;EP - Update Web Services
 ; Add a new service and update the associated fields
 ; Edit an existing service's associated fields
 NEW DA,DIC,DIE,DR,Y,DLAYGO
 S DIC="^BSTS(9002318.2,",DIC(0)="AELMNZ",DIE=DIC,DR="[BSTS ADD/EDIT WEB SERVICE]"
 S DLAYGO=9002318.2 D ^DIC S DA=+Y
 I DA=-1 Q
 D ^DIE
 Q
 ;
SIT ;EP - Update Site parameters
 ; Update the web services for a site
 NEW DA,DIC,DIE,DR,Y,DLAYGO
 S DIC="^BSTS(9002318,",DIC(0)="AEMNZ",DIE=DIC,DR="[BSTS EDIT SITE PARAMETERS]"
 S DLAYGO=9002318 D ^DIC S DA=+Y
 I DA=-1 Q
 D ^DIE
 Q
