AQAQDEL ;IHS/ANMC/LJF - DELETE ENTRY IN CREDENTIALS FILE; [ 10/01/91  9:46 AM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 W @IOF,!!?20,"DELETE ENTRY FROM CREDENTIALS FILE",!!
 W !?5,"WARNING!!! This option deletes an entry in the Credentials"
 W !?5,"file.  Only providers entered in error should be deleted!"
 W !?5,"Once a provider is no longer associated with your facility,"
 W !?5,"the entry should be inactivated.  To insure this, only entries"
 W !?5,"with no data beyond the provider's name can be deleted.",!!
 ;
PROV ;***>  select provider entry to be deleted
 K DIC S DIC("A")="Select PROVIDER NAME:  ",DIC(0)="AQEMZ",DIC=9002165
 D ^DIC G END:Y=-1 S AQAQPROV=Y
 ;
 ;***>  check for data in credentials files
 K ^UTILITY("DIQ1",$J)
 S (DIC,AQAQFILE)=9002165,DR=".02:.19;.31:4",DIQ(0)="N",DA=+AQAQPROV
 D EN^DIQ1
 I $D(^UTILITY("DIQ1",$J,AQAQFILE,DA)) W !!,*7,?5,"**DATA IN CREDENTIALS FILE FOR THIS PROVIDER!  CANNOT DELETE ENTRY!!**" G END
 I $D(^AQAQML("C",+AQAQPROV)) W !!,*7,?5,"**DATA IN MEDICAL LICENSURE FILE FOR THIS PROVIDER!  CANNOT DELETE ENTRY!!**" G END
 I $D(^AQAQMB("C",+AQAQPROV)) W !!,*7,?5,"**DATA IN BOARD CERTIFICATION FILE FOR THIS PROVIDER!  CANNOT DELETE ENTRY!!**" G END
 ;
 ;***>  ask again if want to delete entry
 K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="OKAY TO DELETE "_$P(^DIC(16,$P(AQAQPROV,U,2),0),U)_" ENTRY"
 D ^DIR G END:Y'=1
 ;
 ;***>  delete entry
 W !!,"DELETING ENTRY.........."
 S DIK="^AQAQC(",DA=+AQAQPROV D ^DIK
 W !!,"DELETION COMPLETED",!!
 ;
 ;***> eoj
END D KILL^AQAQUTIL K ^UTILITY("DIQ1",$J) Q
