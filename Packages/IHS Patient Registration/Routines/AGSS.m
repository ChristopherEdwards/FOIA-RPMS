AGSS ; IHS/ASDS/EFG - PROCESS NPIRS/SSA SUBMITTALS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
S ;start
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Process Site: ",DIC("B")=$P(^DIC(4,DUZ(2),0),"^",1) D ^DIC K DIC Q:Y<0  S AGSSITE=+Y
 I $D(^AGSSTEMP(AGSSITE)) D  Q:'Y
 .S DIR(0)="Y"
 .S DIR("A")="Scratch global ^AGSSTEMP exists for this site. Kill"
 .S DIR("B")="N"
 .D ^DIR K DIR
 .Q:'Y
 .K ^AGSSTEMP(AGSSITE)
 S AGSSUFAC=$P(^AUTTLOC(AGSSITE,0),"^",10)
 S AGSSHFL="ss"_AGSSUFAC_".ssn"
 W !!,"Processing Host File: ",AGSSHFL,!
 S DIR(0)="F"
 S DIR("A")="Enter Directory Containing Above Host File"
 S DIR("B")="/usr/spool/uucppublic"
 D ^DIR S AGSSPATH=Y
 I "\/"'[$E(AGSSPATH) D
 .S:^%ZOSF("OS")["UNIX" AGSSPATH="/"_AGSSPATH Q
 .S AGSSPATH="\"_AGSSPATH
 I "\/"'[$E(AGSSPATH,$L(AGSSPATH)) D
 .S:^%ZOSF("OS")["UNIX" AGSSPATH=AGSSPATH_"/" Q
 .S AGSSPATH=AGSSPATH_"\"
 I $D(AGSS("NORUN")) W !!,"NO RUN HAS BEEN SET",!!
 S DIR(0)="Y",DIR("A")="Queue",DIR("B")="NO" D ^DIR K DIR
 S AGSSQ=Y
 I AGSSQ D  Q
 .D QUE
 .D HOME^%ZIS
 .K AGSSHFL,AGSSITE,AGSSQ
 D PROC^AGSS0
 D ^%ZISC
 D PRINT^AGSS0
 K AGSSHFL,AGSSITE,AGSSQ
 Q
QUE ;que to taskman
 S ZTRTN="PROC^AGSS0"
 S ZTDESC="SSN Matching"
 S ZTIO=""
 S ZTSAVE("AGSSUFAC")=""
 S ZTSAVE("AGSSHFL")=""
 S ZTSAVE("AGSSITE")=""
 S ZTSAVE("AGSSPATH")=""
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task #",ZTSK," queued.",!
 W !,"You may monitor progress with the 'Monitor Facility Processing' option.",!
 S DIR(0)="E" D ^DIR K DIR
 Q
