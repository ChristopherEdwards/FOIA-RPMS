ACDDIC ;IHS/ADC/EDE/KML - DATA ENTER/EDIT FOR CDMIS FORMS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*****************************************************************
 ;The CDMIS program file walks across to ^ACDVIS vis a backward program
 ;pointer field in the visit file. This is the screen when selecting
 ;visits. FM only displays visits matching this pointer to the program
 ;i.e any user can only see what is in their signon facility
 ;********************************************************************
EN ;EP Input for CDMIS forms 1
 ;//[ACD VISIT DATA ADD]
 Q  ;************************
 S ACDDUZZ=DUZ(2)
 S DIC("DR")=""
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Records that may be added are: THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"ADDING CDMIS VISIT RECORDS...",!!
 ;K DTOUT S DIE="^ACDF5PI(",DA=DUZ(2),DR="[ACD VISIT DATA ADD]",DIE("NO^")="BACK" D ^DIE S DUZ(2)=ACDDUZZ I $D(DTOUT) D AUTO^ACDDIK,K Q
 D CHK K ACDVISP D K Q
EN2 ;EP Edit for CDMIS forms 1
 ;//[ACD VISIT DATA EDIT]
 Q  ;************************
 S ACDDUZZ=DUZ(2)
 W @IOF,"Signon Program is   : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Editable Records are: THOSE NOT EXTRACTED."
 W !,"                      THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"EDITING CDMIS VISIT RECORDS...",!!
 ;S DIE="^ACDF5PI(",DA=DUZ(2),DR="[ACD VISIT DATA EDIT]" D ^DIE S DUZ(2)=ACDDUZZ
 I DUZ(2)=0 S DUZ(2)=ACDDUZ(2)
 D CHK,^ACDDIFF D ^ACDWK K ACDVISP D K Q
 ;
EN3 ;EP Add additional Client Service
 ;//[ACD 1CSADD]
 Q  ;*************************
 W @IOF,"Signon Program is   : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Editable Records are: THOSE NOT EXTRACTED."
 W !,"                      THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"ADDING CLIENT SERVICE DAYS TO EXISTING RECORDS...",!!
 ;S DIE="^ACDF5PI(",DA=DUZ(2),DIE("NO^")="BACK",DR="[ACD 1 (ACS)]" D ^DIE
 D CHK K ACDVISP D K Q
CHK ;
 Q  ;********************************
 Q:'$D(ACDVISP)
 K ACDTOUT
 I $O(^ACDIIF("C",ACDVISP,0)) D K Q
 ;
 ;If the visit was a 'TDC' ask user to duplicate with an
 ;initial or re-open visit
 I $O(^ACDTDC("C",ACDVISP,0)) D EN^ACDAUTO,K Q
 ;
 ;If the visit was a client service (new visit) then ask
 ;the user to exactly duplicate it for other patients.
 I $O(^ACDCS("C",ACDVISP,0)) D EN^ACDAUTO1,K Q
 ;
 S ACDTOUT=1 D AUTO^ACDDIK
 Q
K ;
 K DIC,DIE,DA,ACDTOUT,ACDCOMC,ACDDA,ACDDFNP,DR,ACDDR,ACDIO,ACDX,ACDDOV,ACD80,ACDRPC,ACDOK,ACDN0,ACDAGE,ACDDUZZ,ACDLINE,ACDHS,ACDAGE,ACDCAGE,ACDSEX,ACDVET,ACDTRB,ACDTRBN,ACDTRBCD,ACDTRBNM,ACDSTA,ACDSTACD,ACDSTANM
