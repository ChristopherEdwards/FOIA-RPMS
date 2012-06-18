AUM9115 ; IHS/RPMSDBA/GTH - STANDARD TABLE UPDATES, 2000JUL21 ; [ 07/27/2000  10:47 AM ]
 ;;99.1;TABLE MAINTENANCE;**15**;NOV 6,1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,VP,HELP("INTRO")
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the update to TaskMan"
 S DIR("??")="^D HELP^AUM9115(""Q2"")"
 D ^DIR
 KILL DIR
 I $D(DIRUT) D HELP("Q2") Q
 G START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED" D HELP("Q2") G AUM9115
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^AUM9115",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUM9115",$J)
 D START^AUM91151
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUM9115"",$J,",XMY(DUZ)=""
 F %="XUPROGMODE","AG TM MENU","ABMDZ TABLE MAINTENANCE","APCCZMGR" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AUM9115",$J)
 I $D(ZTQUEUED) S ZTREQ="@" G DEL^A9AUM15
 W !!,"The results are in your MailMan 'IN' basket.",!
 I $L($T(DIR^XBDIR)),$$DIR^XBDIR("Y","Want me to delete the routines in this patch","Y") G DEL^A9AUM15
 Q
 ;
INTRO ;EP - To write to mail message, too.
 ;;This updates standard tables according to the changes specified in
 ;;the message from Joe Herrera, with subject "Standard Code Book
 ;;modifications", released on Fri 7/21/00.  Please consult that
 ;;message, and the local RPMS mail message produced by this update.
 ;;  
 ;;Additionally, a domain name is added to the DOMAIN file.
 ;;  
 ;;###;NOTE:  This line indicates the end of the message.
 ;
Q2 ;
 ;;Answer "Y" if you want to queue this standard table update to TaskMan.
 ;;Answer "N" if you want to run this update interactively.
 ;;
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message sent to you and user 1.  If you queue
 ;;to TaskMan, please read the mail message for results of this update.
 ;;###;NOTE:  This line indicates the end of the message.
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
VP ;
 W !?4,"****    AUM Version ",$P($T(+2),";",3)," Patch ",$P($P($T(+2),";",5),"*",3),?65,"****"
 W !?4,"****   ",$P($P($T(+1),";",2),"-",2),?65,"****"
 Q
 ;
GREET ;;EP - To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;Standard tables on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Requests for modifications or additions to RPMS standard tables,
 ;;whether they are or are not reflected in the IHS Standard Code
 ;;Book (SCB), can be submitted to your Area Information System
 ;;Coordinator (ISC).
 ;;  
 ;;Questions about this patch, which is a product of the RPMS/DBA
 ;;Team, can be directed to the Help Desk
 ;;.  Please
 ;;refer to patch "AUM*99.1*15".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
