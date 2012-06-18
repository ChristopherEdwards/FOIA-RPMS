ACMPOST1 ; IHS/TUCSON/TMJ - POST INIT #2 ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;
 ;RECALL DATE CONVERSION ROUTINE - CALLED FROM ACMPOST
 ;
START ;EP - CALLED FROM ACMPOST
 I $P(^ACM(40,DUZ(2),0),U,4) W !,"RECALL CONVERSION DONE PREVIOUSLY-NO ACTION TAKEN ON RECALL CONVERSION",!! Q
 ;
 W "It appears the Conversion is NOT done..I will now begin the Recall Date Conversion Process",!
 ;
 D ORGAN,SERVICE,RECALL1,APPTSTAT,RECLDIE,EXIT
 Q
 ;
 ;
ORGAN ;Converts Resource DFN's Text value to the new Organization field (ORGAN1) 
 ;
 ;Q
 W !!,"Setting the old Resource Ptr TEXT value into Organization Field",!
 S ACMDFN=0 F  S ACMDFN=$O(^ACM(49,ACMDFN)) Q:ACMDFN'=+ACMDFN  I $D(^ACM(49,ACMDFN,0)) D 
 . ;Convert the Old Resource Pointer Text Value to Organization Text
 .W !,"Now Converting the Resource Pointer DFN  to Organization Text...",!
 .S ACMOLDN=$P(^ACM(49,ACMDFN,0),U,1)
 .Q:'ACMOLDN
 .S ACMNEWN=$P($G(^ACM(50,ACMOLDN,0)),U,1)
 .I ACMNEWN="" S ACMNEWN="UNKNOWN"
 .S DA=ACMDFN,DIE="^ACM(49,",DR="3////"_ACMNEWN D ^DIE K DIE
 K ACMDFN,ACMOLDN,ACMNEWN Q
 ;
SERVICE ;Convert Service DFN in new Purpose Field #11 to Actual Text value in CMS Service List Entry File
 ;
 ;Q
 W !!,"Setting the Old Service Pointer TEXT value in Purpose Field",!!
 S ACMDFN=0 F  S ACMDFN=$O(^ACM(49,ACMDFN)) Q:ACMDFN'=+ACMDFN  I $D(^ACM(49,ACMDFN,0)) D 
 . ;Convert to Service Pointer to Purpose Free Text
 .W !,"Now Converting the Service Pointer to Purpose...",!
 .S ACMOLDN=$P(^ACM(49,ACMDFN,"DT"),U,5)
 .Q:'ACMOLDN
 .S ACMNEWN=$P($G(^ACM(47.1,ACMOLDN,0)),U,1)
 .I ACMNEWN="" S ACMNEWN="UNKNOWN"
 .S DA=ACMDFN,DIE="^ACM(49,",DR="11////"_ACMNEWN D ^DIE K DIE
 K ACMDFN,ACMOLDN,ACMNEWN Q
RECALL1 ;Converts Old .01 Resource to Recall Date (Next Appoint Fld #1 value) 
 ;
 ;Q
 W !!,"Now Converting the old Resource value to new Recall Date...",!!
 S ACMDFN=0 F  S ACMDFN=$O(^ACM(49,ACMDFN)) Q:ACMDFN'=+ACMDFN  I $D(^ACM(49,ACMDFN,"DT")) D 
 . ;Convert the Resource .01 to Next Appointment Date
 .S ACMNEWN=$P($G(^ACM(49,ACMDFN,"DT")),U,1)
 .I 'ACMNEWN S ACMNEWN=DT
 .S DA=ACMDFN,DIE="^ACM(49,",DR=".01////"_ACMNEWN D ^DIE K DIE
 K ACMDFN,ACMNEWN Q
 ;
APPTSTAT ;Convert Date Last Seen to Appointment Status=Open
 ;
 W !!,"Converting Date Last Seen Fld to Appointment Status=OPEN...",!!
 S ACMDFN=0 F  S ACMDFN=$O(^ACM(49,ACMDFN)) Q:ACMDFN'=+ACMDFN  I $D(^ACM(49,ACMDFN,"DT")) D
 .S ACMNEWN=$S($P(^ACM(49,ACMDFN,"DT"),U,2)'="":"O",$P(^ACM(49,ACMDFN,"DT"),U,2)="":"")
 .S DA=ACMDFN,DIE="^ACM(49,",DR="2////"_ACMNEWN D ^DIE K DIE
 ;
 K ACMDFN,ACMNEWN Q
 ;
RECLDIE ;SET FLAG IN CMS PARAMETERS FILE TO INDICATE RECALL DATE CONVERSION HAS BEEN COMPLETED
 ;
 W !!,"I will now set the CMS Parameters Flag to Indicate the Recall Date Conversion process has been completed",!!
 S DIE="^ACM(40,",DA=DUZ(2),DR="3.5///1" D ^DIE K DIE,DR,DA,DIC
 Q
EXIT ;
 W !!,?10,"Conversion Complete ",!
 Q
