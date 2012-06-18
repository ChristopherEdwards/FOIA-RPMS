ACHSPOSM ; IHS/ITSC/PMF - 2.1T2 INSTALLATION MAIL MESSAGE ANNOUNCEMENT ; [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 I $D(ZTQUEUED) G START
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW,INTRO
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the announcement to TaskMan"
 S DIR("??")="^D Q2^ACHSPOSM"
 D ^DIR
 G Q2:$D(DIRUT),START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED",!!,"Okay...",! D Q2 Q
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T,ZTRTN="START^ACHSPOSM(0)",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",!
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START(ERROR) ;EP - From Taskman
 ;
 N XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP($J)
 ;
 D:'ERROR WRITDESC     ;OKAY - NO ERROR
 D:ERROR=1 WRITEOOP    ;ERROR IN INSTALL
 D:ERROR=2 WRITEDD     ;POSSIBLE ERROR IN DD(s)
 D:ERROR=4 BACKUP      ;ERROR IN BACKUPS
 ;
 D GETRECIP
 S (XMSUB,XMDUZ)=$P($P($T(+1),";",2)," ",4,99),XMTEXT="^TMP($J,""ACHSPOSM"",",XMY(1)="",XMY(DUZ)=""
 D ^XMD
 K ^TMP($J)
 Q
 ;
INTRO ;
 W ! F %=2:1:5 W ?5,$P($T(INTRO+%),";;",2),!
 ;;This patch announcement generates a mail message to everyone on your
 ;;local machine that holds a CHS security key.  The mail messages
 ;;inform the users that the patch has been installed, and describes
 ;;any changes in displays or functionality.
 Q
 ;
Q2 ;EP - From DIR
 W ! F %=2:1:8 W ?5,$P($T(Q2+%),";;",2),!
 ;;Answer "Y" if you want to queue this patch announcement to TaskMan.
 ;;Answer "N" if you want to run the announcement immediately.
 ;;
 ;;If you run interactively, a mail message with the description of
 ;;this patch will be delivered to those users holding any CHS security
 ;;key, now. If you que the announcement to TaskMan, the mail message(s)
 ;;will be delivered when TaskMan runs the task.
 Q
 ;
GETRECIP ;
 N X,Y
 S X="ACHS"
 F  S X=$O(^XUSEC(X)) Q:'($E(X,1,4)="ACHS")  D
 .S Y=0
 .F  S Y=$O(^XUSEC(X,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
 ;OKAY NO ERRORS ENCOUNTERED
WRITDESC ;
 F %=3:1 S X=$P($T(WRITDESC+%),";",3) Q:X="###"  S ^TMP($J,"ACHSPOSM",%)=X
 Q
 ;;  
 ;;++++  CHS Contract Health System, v 3.1 announcement     ++++++
 ;;+     This mail message has been delivered to all local         +
 ;;+          users that have access to any CHS menu.              +
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Version 3.1 of CHS CONTRACT HEALTH MGT SYSTEMS has been installed
 ;;on this machine.  You are participating in an Alpha test of this
 ;;module of the CHS software.
 ;;
 ;;Please direct your questions or comments about RPMS software to:
 ;;
 ;;            Your Help Desk
 ;;            
 ;;            
 ;;            
 ;;
 ;;If you experience problems with the CHS Contract Health System
 ;;software installed for this Alpha test, please contact your site
 ;;manager, OR, the developers, Tim Frazier or Paul Friedland,
 ;;via the above number.
 ;;  
 ;;------------------------------------------------------------------
 ;;It is recommended that you exercise the "UHF   Print Help Frames"
 ;;option on the primary Denial/Deferred Services menu, which will
 ;;print out all the on-line help-frames in a manual format.  This
 ;;help frame manual is intended to help users while a user manual
 ;;is being written. If you notice any errors please contact the
 ;;developers.
 ;;
 ;;+++++++++++++++++++++++ end of announcement ++++++++++++++++++++++
 ;;###
 ;
 ;WRITE "OOPS" SOME ERROR HAS OCCURRED DURING INSTALLATION
 ;THIS IS A GENERIC MESSAGE
WRITEOOP ;
 F %=3:1 S X=$P($T(WRITEOOP+%),";",3) Q:X="###"  S ^TMP($J,"ACHSPOSM",%)=X
 Q
 ;;
 ;;It appears that version 3.1 of the CHS Contract Health System has
 ;;already been installed in this UCI! Or it may have been started
 ;;and did not complete properly. Or the proper routine sequence was
 ;;disrupted. Further investigation by ITSC developers will have to be
 ;;done to determine why the installation has failed.
 ;;
 ;;Please call the Help Desk immediately!!
 ;;
 ;;
 ;;###
 ;
 ;AN ERROR OCCURRED DURING THE AUTOMATED BACKUP PROCEDURES
BACKUP ;
 F %=3:1 S X=$P($T(BACKUP+%),";",3) Q:X="###"  S ^TMP($J,"ACHSPOSM",%)=X
 Q
 ;;
 ;;The automated backup procedure does not appear to have finished
 ;;properly! Further investigation by ITSC developers is neccessary
 ;;before continuing.
 ;;
 ;;Please call the Help Desk immediately!!
 ;;
 ;;
 ;;###
 ;
 ;THIS IS A WARNING TO LET US KNOW A DD MAY HAVE NOT IMPORTED
 ;CORRECTLY
WRITEDD ;
 ;
 F %=3:1 S X=$P($T(WRITEDD+%),";",3) Q:X="###"  S ^TMP($J,"ACHSPOSM",%)=X
 Q
 ;;
 ;;It appears that the installation of the data dictionaries of the
 ;;CHS files may not have been completed properly or are incomplete!
 ;;
 ;;Further investigation by developers will have to be made to
 ;;determine why this occurred.
 ;;
 ;;This is only a warning!
 ;;
 ;;Please call the Help Desk immediately!!
 ;;
 ;;
 ;;+++++++++++++++++++++++ end of announcement ++++++++++++++++++++++
 ;;###
