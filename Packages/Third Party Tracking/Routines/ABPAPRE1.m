ABPAPRE1 ;PRE-PRE-INITIALIZATION TASKS; [ 08/07/91  8:26 AM ]
 ;;1.4;AO PVT-INS TRACKING;*1*;IHS-OKC/KJR;AUGUST 7,1991
 ;;PATCH 1: 'AREA' PROCEDURE MODIFIED TO ALLOW INSTALLATION ON SYSTEMS                      OTHER THAN THE AREA OFFICE;IHS-OKC/KJR;07AUG91
 ;---------------------------------------------------------------------
PREFACE D CRT^ABPAVAR S CONTINUE=1,ABPA("CONVERT")=0 K ABPA("VR")
 I $D(^DD(9002270.02))'=0 S ABPA("VR")="1.0"
 I $D(^DD(9002270.02,0,"VR"))=1 S ABPA("VR")=+^("VR")
 I $D(ABPA("VR"))=1 I ABPA("VR")<1.4 D
 .W !! S X="***** NOTE *****          " F J=1:1:3 W X
 .W !!,"You appear to be upgrading from Version ",ABPA("VR")," of "
 .W "this package. I suggest",!,"you consider running this installa"
 .W "tion either at nighttime or some other",!,"off period as this "
 .W "upgrade is going to convert your existing payment data",!
 .W "to a new format as well as re-index the entire file.  Depending"
 .W " on the",!,"size of your file this may take some time (hours to "
 .W "be exact).",!! W:$D(ABPAROFF) @ABPARON W "I STRONGLY SUGGEST THAT"
 .W " YOU BACKUP THE ^ABPVAO GLOBAL FIRST!" W:$D(ABPAROFF) @ABPAROFF
 .K DIR S DIR(0)="YO",DIR("A")="Do you wish to continue (Y/N)"
 .S CONTINUE=0 W !,*7 D ^DIR S CONTINUE=+Y,ABPA("CONVERT")=CONTINUE
 I 'CONTINUE W !!,"Good-bye!  " H 2 H
 ;---------------------------------------------------------------------
AREA D DT^DICRW K DIC S DIC="^AUTTLOC(",DIC(0)="AEQZ"
 S DIC("A")="Select SITE NAME for this installation: " D ^DIC
 I +Y'>0 D  W !!,"Good-bye!  " H 2 H
 .W !?5,*7,"<<< No selection made - installation aborted >>>"
 I +$E($P(Y(0),"^",10),3,6)'=0 D  I Y'=1 W ! G AREA
 .K DIR S DIR(0)="YO",DIR("A",1)="This is not an Area Office!" W *7
 .S DIR("A")="Are you sure you want to do this",DIR("B")="NO" D ^DIR
 S ABPASITE=+Y
 ;---------------------------------------------------------------------
ACTIONS ;PROCEDURE TO REMOVE CURRENT OPTION ENTRY & EXIT ACTIONS
 W !!,"Preparing the current options for updating..."
 S ABPAR="ABPA" F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIC(19,"B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIC(19,"B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..K ^DIC(19,ABPARR,15),^DIC(19,ABPARR,20)
 W "done!"
 ;---------------------------------------------------------------------
INPUT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE INPUT TEMPLATES
 W !,"Deleting the current input templates..."
 S ABPAR="ABPA" F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIE("B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIE("B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..K DIK,DA S DIK="^DIE(",DA=ABPARR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
SORT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE SORT TEMPLATES
 W !,"Deleting the current sort templates..."
 S ABPAR="ABPA" F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIBT("B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIBT("B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..K DIK,DA S DIK="^DIBT(",DA=ABPARR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
PRINT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE PRINT TEMPLATES
 W !,"Deleting the current print templates..."
 S ABPAR="ABPA" F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIPT("B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIPT("B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..K DIK,DA S DIK="^DIPT(",DA=ABPARR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
 D ^ABPAPREI
 Q
