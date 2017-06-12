BMCAERR ; IHS/PHXAO/TMJ - add/edit routine referral definition ;
 ;;4.0;REFERRED CARE INFO SYSTEM;**8**;JAN 09, 2006;Build 51
 ;
 ;
EN ;EP - called from option
 W:$D(IOF) @IOF
 W !!,"This option is used to add or edit a routine referral definition.  The user",!,"can enter all default values to be used when the routine referral is",!,"selected by the provider.",!!
LOOKUP ;get referral to edit or add new one
 S DIC="^BMCRTNRF(",DIC(0)="AEMQL",DIC("A")="Enter NAME of Routine Referral: " D DIC^BMCFMC
 I Y=-1 W !!,"No referral selected.  Bye.",! Q
 S BMCRREF=+Y
 ;
SM ;call screenman to edit
 S BMCSCOD="",BMCSTRM=""   ;BMC*4.0*8
 S BMCMODE="R",BMCSCOD=$P($G(^BMCRTNRF(BMCRREF,13)),U,3) S:BMCSCOD BMCSTRM=$P($$CONC^BSTSAPI(BMCSCOD_"^^^1"),U,2)  ;BMC*4.0*8
 S DDSFILE=90001.32,DA=BMCRREF,DR="[BMC ADD/EDIT ROUTINE REF DEF]",DDSPARM="C"
 D DDS^BMCFMC
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN - NOTIFY PROGRAMMER!" D EOJ Q
 ;
 D VREF
ICD ;prompt for ICD/CPT codes, using DIE and input template
 W !!
 S DA=BMCRREF,DR="[BMC ADD/EDIT RTN REF DX/CPT]",DIE="^BMCRTNRF(" D DIE^BMCFMC
EOJ ;
 K BMCRREF
 D ^XBFMK
 Q
VREF ;EP FR BMCADD3 ;BMC*4.0*8 NEW SECTION TO SET V REF SNOMED CODE
 S DIE="^BMCRTNRF(",DA=BMCRREF
 S DR="1303////"_BMCSCOD
 D ^DIE
 Q
