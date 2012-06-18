LJFVHFIX ;IHS/ANMC/LJF - FIX VHOSP PATIENT POINTERS ; [ 10/21/92  8:21 AM ]
 ;;cleanup rtn for ADT v4.2 patch #
 ;
 W !!,"CLEANUP PATIENT POINTERS IN V HOSPITALIZATION FILE",!!
ASK ;>> ask user if he/she wants to run cleanup     
 K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="Do you wish to begin the cleanup"
 S DIR("A",1)="This program will cleanup any bad patient pointers in "
 S DIR("A",2)="your V HOSPITALIZATION file.  It will check the patient"
 S DIR("A",3)="pointer for the visit and make sure the same patient is"
 S DIR("A",4)="is set in the V HOSPITALIZATION file.  This routine has"
 S DIR("A",5)="been created in conjunction with ADT Patch 4.2*__"
 S DIR("A",6)="  "
 S DIR("A",7)="Please turn on your auxport to get a printout of what"
 S DIR("A",8)="has been fixed."
 S DIR("A",9)="  "
 D ^DIR G END:$D(DIRUT),END:Y=0
 ;
BDATE ;>> ask user for the starting date for this cleanup; oldest discharge
 S %DT="AEP",%DT("A")="Enter beginning discharge date for cleanup:  "
 W !! S X="" D ^%DT G END:Y=-1 S LJFBDT=Y
 ;
EDIT ;>> make vhosp pat field editable    
 W !!,"MAKING PATIENT FIELD IN V HOSPITALIZATION FILE EDITABLE. . .",!!
 S $P(^DD(9000010.02,.02,0),U,2)="RP9000001'"
 ;
LOOP ;>> loop thru ^aupnvinp by date, check pointers, fix if don't match    
 W !!,"LOOKING FOR ENTRIES TO FIX. . .",!
 S LJFDT=LJFBDT-.0001
 F  S LJFDT=$O(^AUPNVINP("B",LJFDT)) Q:LJFDT'=+LJFDT  D
 .S LJFH=0
 .F  S LJFH=$O(^AUPNVINP("B",LJFDT,LJFH)) Q:LJFH=""  D
 ..Q:'$D(^AUPNVINP(LJFH,0))  S LJFHS=^(0)   ;vhosp node
 ..S LJFV=$P(LJFHS,U,3) Q:LJFV=""           ;visit ifn
 ..Q:'$D(^AUPNVSIT(LJFV,0))  S LJFVS=^(0)   ;visit node
 ..Q:$P(LJFHS,U,2)=$P(LJFVS,U,5)    ;pt pointers match
 ..S DIE="^AUPNVINP(",DA=LJFH,DR=".02////"_$P(LJFVS,U,5) D ^DIE  ;fix
 ..S Y=LJFDT X ^DD("DD")
 ..W !,"Fixed entry #",LJFH," for discharge date of ",Y
 ;
UNEDIT ;>> make vhosp pat field uneditable
 W !!,"COMPLETED SEARCH; NOW MAKING PATIENT FIELD UNEDITABLE AGAIN",!!
 S $P(^DD(9000010.02,.02,0),U,2)="RP9000001'I"
 ;
 W !!,"CLEANUP COMPLETE!!",!
END ;>> eoj
 K DIR,LJFBDT,LJFDT,LJFH,LJFHS,LJFV,LJFVS,DIE,DA Q
