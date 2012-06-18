AUM9101 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, ICD 99.1 SUPPORT ; [ 11/03/1998   4:37 PM ]
 ;;99.1;TABLE MAINTENANCE;**1**;NOV 6,1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,HELP("INTRO")
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the update to TaskMan"
 S DIR("??")="^D HELP^AUM9101(""Q2"")"
 D ^DIR
 I $D(DIRUT) D HELP("Q2") Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" D Q2 G AUM9101
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^AUM9101",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUM9101",$J)
 D START^AUM91011
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUM9101"",$J,",XMY(1)="",XMY(DUZ)=""
 D ^XMD
 KILL ^TMP("AUM9101",$J)
 I $D(ZTQUEUED) S ZTREQ="@" Q
 W !!,"The results are in your MailMan 'IN' basket.",!
 Q
 ;
INTRO ;
 ;;This updates standard tables according to the changes specified in
 ;;the ICD 99.1 update, affecting recode tables
 ;;           RECODE ICD/APC.
 ;;
 ;;###
 ;
Q2 ;
 ;;Answer "Y" if you want to queue this standard table update to TaskMan.
 ;;Answer "N" if you want to run this update interactively.
 ;;
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message sent to you and user 1.  If you queue
 ;;to TaskMan, please read the mail message for results of this update.
 ;;###
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
