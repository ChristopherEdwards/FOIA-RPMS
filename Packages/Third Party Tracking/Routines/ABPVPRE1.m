ABPVPRE1 ;PRE-PRE-INITIALIZATION TASKS; [ 05/31/91  12:15 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 ;---------------------------------------------------------------------
ACTIONS ;PROCEDURE TO REMOVE CURRENT OPTION ENTRY & EXIT ACTIONS
 W !!,"Preparing the current options for updating..."
 S ABPVR="ABPV" F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIC(19,"B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIC(19,"B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..K ^DIC(19,ABPVRR,15),^DIC(19,ABPVRR,20)
 W "done!"
 ;---------------------------------------------------------------------
INPUT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE INPUT TEMPLATES
 W !,"Deleting the current input templates..."
 S ABPVR="ABPV" F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIE("B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIE("B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..K DIK,DA S DIK="^DIE(",DA=ABPVRR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
SORT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE SORT TEMPLATES
 W !,"Deleting the current sort templates..."
 S ABPVR="ABPV" F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIBT("B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIBT("B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..K DIK,DA S DIK="^DIBT(",DA=ABPVRR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
PRINT ;PROCEDURE TO DELETE ALL CURRENT PACKAGE PRINT TEMPLATES
 W !,"Deleting the current print templates..."
 S ABPVR="ABPV" F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIPT("B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIPT("B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..K DIK,DA S DIK="^DIPT(",DA=ABPVRR D ^DIK W "."
 W "done!"
 ;---------------------------------------------------------------------
 D ^ABPVPREI
 Q
