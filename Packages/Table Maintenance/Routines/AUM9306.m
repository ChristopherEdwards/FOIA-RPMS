AUM9306 ; DSD/GTH - STANDARD TABLE UPDATES, 16JUN93 MEMO ; [ 06/22/93  4:07 PM ]
 ;;93.1;TABLE MAINTENANCE;**4**;MARCH 23, 1993
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,INTRO
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the utility to TaskMan"
 S DIR("??")="^D Q2^AUM9306"
 D ^DIR G Q2:$D(DIRUT),START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW" D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED",!!,"Okay...",! D Q2 Q
 S X=+Y D H^%DTC S ZTDTH=%H_","_%T
 S ZTRTN="START^AUM9306",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
START ;EP - From Taskman
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP($J)
 D START^AUM93061,START^AUM93062
 S (XMSUB,XMDUZ)=$P($P($T(+1),";",2)," ",4,99),XMTEXT="^TMP($J,""RSLT"",",XMY(1)="",XMY(DUZ)="" D ^XMD
 K ^TMP($J)
 I $D(ZTQUEUED) S ZTREQ="@"
 E  W !!,"The results are in your MailMan 'IN' basket.",!
 Q
 ;
INTRO ;
 W ! F %=2:1:7 W ?5,$P($T(INTRO+%),";;",2),!
 ;;This patch updates standard tables according to the changes
 ;;specified in the memo dated June 16, 1993.
 ;;Please consult that memo, and the mail message produced by this
 ;;utility.
 ;;This patch also updates the AUM entry in your PACKAGE file to
 ;;accurately reflect the current version (93.1) of AUM.
 Q
Q2 ;EP - From DIR
 W ! F %=2:1:7 W ?5,$P($T(Q2+%),";;",2),!
 ;;Answer "Y" if you want to queue this standard table update to TaskMan.
 ;;Answer "N" if you want to run this update interactively.
 ;;
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message sent to you and user 1.  If you queue
 ;;to TaskMan, please read the mail message for results of this patch.
 Q
