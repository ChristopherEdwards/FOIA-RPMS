A9ACHS3 ; DSD/GTH - CHS V 2.0 PATCH 3 ANNOUNCEMENT ; [ 01/25/95  7:27 PM ]
 ;;2.0;CONTRACT HEALTH MGMT SYSTEM;**3**;NOV 01, 1994
 ;
 I $D(ZTQUEUED) G START
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,INTRO
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the announcement to TaskMan"
 S DIR("??")="^D Q2^A9ACHS3"
 D ^DIR G Q2:$D(DIRUT),START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW" D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED",!!,"Okay...",! D Q2 Q
 S X=+Y D H^%DTC S ZTDTH=%H_","_%T
 S ZTRTN="START^A9ACHS3",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
START ;EP - From Taskman
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP($J)
 D WRITDESC^ACHSP3,GETRECIP
 S (XMSUB,XMDUZ)=$P($P($T(+1),";",2)," ",4,99),XMTEXT="^TMP($J,""A9ACHS3"",",XMY(1)="",XMY(DUZ)=""
 D ^XMD
 K ^TMP($J)
 I $D(ZTQUEUED) S ZTREQ="@"
 E  W !!,"You're done.  Thank you.  You may delete this routine.",!
 Q
 ;
INTRO ;
 W ! F %=2:1:5 W ?5,$P($T(INTRO+%),";;",2),!
 ;;This patch announcement generates a mail message to everyone on your
 ;;local machine that holds a CHS security key.  The mail messages
 ;;inform the users that the patch has been installed, and describes
 ;;any changes in displays or functionality.
 Q
Q2 ;EP - From DIR
 W ! F %=2:1:8 W ?5,$P($T(Q2+%),";;",2),!
 ;;Answer "Y" if you want to queue this patch announcement to TaskMan.
 ;;Answer "N" if you want to run the announcement immediately.
 ;;
 ;;If you run interactively, a mail message with the description of
 ;;this patch will be delivered to those users holding any CHS security
 ;;key, now.  If you q the announcement to TaskMan, the mail message(s)
 ;;will be delivered when TaskMan runs the task.
 Q
 ;
GETRECIP ;
 NEW X,Y
 S X="ACHS"
 F  S X=$O(^XUSEC(X)) Q:'($E(X,1,4)="ACHS")  S Y=0 F  S Y=$O(^XUSEC(X,Y)) Q:'Y  S XMY(Y)=""
 Q
