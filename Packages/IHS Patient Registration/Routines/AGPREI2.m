AGPREI2 ; IHS/ASDS/EFG - PRE INIT ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 D T^AG W *7,"  - Fix Mail List data dd reference nodes",!!
 D ^AGADFIX ;FIX mail list data dd reference nodes
 D T^AG W *7,"  - Perform SSN Matching installation",!!
 D ^AGSSINST ;perform SSN / Matching install
 D T^AG W *7,"  -  BEGINNING MENU AND KEY NAME CHANGES",!!
KEYS ;RENAME KEYS AND MAIN MENU
 N AGMKDD
 I $P(^DD(19,.01,0),"^",2)["I" S $P(^DD(19,.01,0),"^",2)="RFX",AGMKDD(19)=$P(^DD(19,.01,0),"^",2)
 I $P(^DD(19.1,.01,0),"^",2)["I" S $P(^DD(19.1,.01,0),"^",2)="RFX",AGMKDD(19.1)=$P(^DD(19.1,.01,0),"^",2)
 S DA=$O(^DIC(19,"B","AGMASTER",0)) I DA D
 .S DIE="^DIC(19,",DR=".01///AGMENU" D ^DIE
 S $P(^DD(19.1,.01,0),"^",2)="RFX"
 N I F I="AGZUSR","AGSS MANAGER" D
 .S AG("NEWNAME")=$S(I="AGZUSR":"AGZMENU",1:"AGZSS MANAGER")
 .S DA=0 F  S DA=$O(^XUSEC(I,DA)) Q:'DA  D
 ..S ^XUSEC(AG("NEWNAME"),DA)=""
 .S DA=$O(^DIC(19.1,"B",I,0)) I DA D
 ..S DIE="^DIC(19.1,",DR=".01///"_AG("NEWNAME") D ^DIE
 I $D(AGMKDD(19)) S $P(^DD(19,.01,0),"^",2)=AGMKDD(19)
 I $D(AGMKDD(19.1)) S $P(^DD(19.1,.01,0),"^",2)=AGMKDD(19.1)
 D T^AG W *7,"  -  MENU AND KEY NAME CHANGES COMPLETE.",!!
 K DIC S X="AGFILESCAN",DIC=19,DIC(0)="QM" D ^DIC
 I '+Y W !,"Could not find the menu AGFILESCAN to Change its lock",! G OUT
 K DIE S DA=+Y,DIE=19,DR="3///AGZMENU" D ^DIE
 W !,"LOCK on menu AGFILESCAN changed to AGZUSR",!
OUT Q
