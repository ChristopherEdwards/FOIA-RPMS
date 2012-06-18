AUM6102 ; IHS/ADC/GTH - STANDARD TABLE UPDATES, 06DEC95 BANYAN ; [ 12/11/95  4:16 PM ]
 ;;96.1;TABLE MAINTENANCE;**2**;OCT 26,1995
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,HELP("INTRO")
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the update to TaskMan"
 S DIR("??")="^D HELP^AUM6102(""Q2"")"
 D ^DIR
 I $D(DIRUT) D HELP("Q2") Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" D Q2 G AUM6102
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^AUM6102",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("AUM SCB",$J)
 D START^AUM61021,START^AUM61022
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AUM SCB"",$J,",XMY(1)="",XMY(DUZ)=""
 D ^XMD
 K ^TMP("AUM SCB",$J)
 I $D(ZTQUEUED) S ZTREQ="@" Q
 W !!,"The results are in your MailMan 'IN' basket.",!
 I $L($T(DIR^XBDIR)),$$DIR^XBDIR("Y","Want me to delete the routines in this patch","Y") G INTERACT^A9AUM1
 Q
 ;
INTRO ;
 ;;This updates standard tables according to the changes specified in
 ;;the Banyan message time stamped 06Dec95@10:57:44 MST. Please consult
 ;;that message, and the mail message produced by this update.
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
