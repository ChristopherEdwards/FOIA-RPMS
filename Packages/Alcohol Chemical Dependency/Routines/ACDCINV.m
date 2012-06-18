ACDCINV ;IHS/ADC/EDE/KML - DATA ENTER/EDIT FOR INTERVENTION;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*****************************************************************
 ;The CDMIS program file walks to ^ACDINTV via a backward program
 ;pointer field inintervention file. This is the screen when selecting
 ;visits. FM only displays visits matching this pointer to the program
 ;i.e any user can only see what is in their signon facility
 ;
 ;Note, the intervention data in ^ACDINTV is purged with
 ;the purge option at the facility level. The data, however,
 ;is not deleted at the area or hq level with the Delete option.
 ;This is because the delete option is only used to prep a system
 ;for a re-import and intervention data is not exportedZS (EXTRACTED)
 ;********************************************************************
 ;
EN ;EP Input for Interventions
 ;//[ACD INTERVENTION ADD]
 S ACDDUZZ=DUZ(2)
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Records that may be added are: THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"ADDING CDMIS INTERVENTION RECORDS...",!!
 D ^ACDCINV2
 Q
 ;
EN1 ;EP Edit for CDMIS interventions
 ;//[ACD INTERVENTION EDIT]
 S ACDDUZ(2)=DUZ(2)
 W @IOF,"Signon Program is   : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Editable Records are: THOSE NOT EXTRACTED."
 W !,"                      THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"EDITING CDMIS INTERVENTION RECORDS...",!!
 S DIE="^ACDF5PI(",DA=DUZ(2),DR="[ACD INTERVENTION EDIT]" D ^DIE S DUZ(2)=ACDDUZ(2)
 ; Above template shifts to CDMIS INTERVENTIONS.  Incremental lock
 ; and unlock done in template.
 Q
 ;
EN3 ;EP Delete a intervention entry - interactive
 ;//[ACD INTERVENTION DELETE]
 W @IOF,"Signon Program is               : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Prevention records to Delete are: THOSE NOT EXTRACTED."
 W !,"                                  THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"DELETING CDMIS INTERVENTION RECORDS...",!!
 S DIC("S")="I $P(^(0),U,17)=DUZ(2)"
 S:'$D(ACDH(1)) $P(ACDH(1),"=",79)="=" S DIC(0)="AEQ",DIC="^ACDINTV(" D ^DIC G:Y<0 K S ACDVISP=+Y
 S:'$D(ACD80) $P(ACD80,"=",79)="=" W !,ACD80
 F  S %=2 W !,"Are You Sure You wish to DELETE this ENTRY" D YN^DICN W:%=0 " Answer Yes or No" Q:%=2!(%=-1)  I %=1 D DEL G K
 W " No action taken...."
 Q
DEL ;Delete incomplete/incorrect entries
 Q:'$D(ACDVISP)
 S:'$D(ACDH(1)) $P(ACDH(1),"=",79)="=" W !!!,ACDH(1)
 S DA=+ACDVISP,DIK="^ACDINTV(" D ^DIK W !,"** INCOMPLETE or INCORRECT INTERVENTION deleted. **",!,ACDH(1)
 W !!?4,"Intervention Deletion Complete...."
 Q
 ;
K ;
 K DIC,DIE,DA,ACDTOUT,ACDCOMC,ACDDA,ACDDFNP,DR,ACDDR,ACDIO,ACDX,ACDDOV,ACD80,ACDRPC,ACDOK,ACDN0,ACDAGE,ACDDUZZ,ACDLINE,ACDHS,ACDAGE,ACDCAGE,ACDSEX,ACDVET,ACDTRB,ACDTRBN,ACDTRBNM,ACDTRBCD,ACDSTA,ACDATSN,ACDSTANM,ACDSTACD
