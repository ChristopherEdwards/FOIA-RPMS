BMCDXLK ; IHS/PHXAO/TMJ - LOOKUP ICD9 ENTRY ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ; This routine looks up an entry in the ICD DIAGNOSIS file (80).
 ;
START ;
 D EN^XBNEW("EN^BMCICDLK","BMC*") ;  new everthing except BMC*
 Q
 ;
EN ; ENTRY POINT FOR ^XBNEW
 NEW BMCQ
 F  D LOOP Q:BMCQ
 Q
 ;
LOOP ;
 S BMCQ=1
 W:$G(IOF)'="" @IOF
 S DIC=80,DIC(0)="AEMQ" D DIC^BMCFMC
 Q:Y<0
 ; add new rcis diagnosis for dx just looked up
 S BMCLOOK=1
 S DIC="^BMCDX(",DIC(0)="L",DLAYGO=90001.01,DIC("DR")=".02////"_BMCDFN_";.03////"_BMCRIEN,X=+Y
 D FILE^BMCFMC
 K BMCLOOK
 Q:Y<0
 ; add other fields to dx just created
 S DDSFILE=90001.01,DA=+Y,DR="[BMC DIAGNOSIS ADD]",DDSPARM="TW"
 D DDS^BMCFMC
 Q
