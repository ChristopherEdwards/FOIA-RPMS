APSPERRY ;IHS/DSD/PR - Copy drug file for each selected division; [ 09/09/97   8:45 AM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;
EN(PSOMAKE) ;EP 
 ;D EN^PSOPERRY(SITE)      ;user will NOT be asked site.
 ;             (.SITE)     ;User will NOT be asked site.
 ;             ()          ;user will be asked site.
 ;
 I $D(PSOMAKE) D  Q
 .I '$O(PSOMAKE(0)) S PSOMAKE(PSOMAKE)=""
 .D Q
 ;
 ;
 K PSOMAKE,PSOQUIT
 F  S DIC=59,DIC(0)="AEQM",DIC("A")="Select Division(s): " D ^DIC S:Y>0 PSOMAKE(+Y)="" I Y'>0 Q
 I '$O(PSOMAKE(0)) S PSOQUIT=1
 I $D(PSOQUIT) D K Q
 ;
 W !!!,"OK, I will Copy the existing drug file for divisions: " F PSODA=0:0 S PSODA=$O(PSOMAKE(PSODA)) Q:'PSODA  W !,$P(^PS(59,PSODA,0),U)
 ;
 ;Verify user wants to continue
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 ;
 ;
Q ;EP
 K IO("Q"),%ZIS,IOP,ZTDTH,ZTSAVE,ZTSK,ZTQUEUED
 S %ZIS="QM" D ^%ZIS I POP D K Q
 I $D(IO("Q")) S ZTIO=ION,ZTSAVE("PSO*")="",ZTSAVE("DUZ(")="",ZTRTN="EN2^PSOPERRY",ZTDTH=$H D ^%ZTLOAD W !,"JOB QUEUED." D ^%ZISC D K Q
 ;
EN2 ;EP Tman entry
 ;Create new duplicate drug entry here.
 ;Stuff 'PSOSITE' (internal DA to 59) into the new division field.
 ;
 U IO W @IOF,"Drug file copy in progress."
 F PSOSITE=0:0 S PSOSITE=$O(PSOMAKE(PSOSITE)) Q:'PSOSITE  I $D(^PS(59,PSOSITE,0)) W !!!!,"Copying new drug file for site: ",$P(^(0),U) D AUTO
 I IO'=IO(0) W !!,"FINISHED." W @IOF D ^%ZISC
 D K Q
 ;
 ;
AUTO ;Auto duplicate drug data with new division.
 ;
 ;Check that first site in site file has been established
 S PSOBASE=$O(^PS(59,0)) I '$D(^PSDRUG("ZDIV",PSOBASE)) W !,"Unable to continue, no base to operate from." Q
 ;
 ;Check division and be sure it has not already been set up with
 ;the drug file.
 I $D(^PSDRUG("ZDIV",PSOSITE)) W !,"Site ",$P(^PS(59,PSOSITE,0),U)," has already been assigned the drug file. " Q
 ;
 ;Get the entry from the drug file to duplicate
 F PSODA=0:0 S PSODA=$O(^PSDRUG("ZDIV",PSOBASE,PSODA)) Q:'PSODA  I $D(^PSDRUG(PSODA,0)) D
 .S X=$P(^PSDRUG(PSODA,0),U)
 .S DIC="^PSDRUG("
 .S DIC(0)="L"
 .D FILE^DICN S PSONEW=+Y
 .S %X="^PSDRUG("_PSODA_","
 .S %Y="^PSDRUG("_PSONEW_","
 .D %XY^%RCR
 .S DIE="^PSDRUG(",DA=PSONEW,DR="9999999.03////^S X=PSOSITE" D ^DIE
 .S DIK="^PSDRUG(",DA=PSONEW D IX1^DIK
 .W "."
K ;
