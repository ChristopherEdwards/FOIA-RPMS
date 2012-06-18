BMCBMRG ;IHS/ITSC/FCJ - MERGE BULLETIN MESSAGES SENT 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 W:$D(IOF) @IOF
 W !,"This option will merge data from the RCIS Messages File.  This file"
 W !,"holds the date and group(s) messages were sent for a specific Referral.",!
 W !,"This will not remove the message from the Mail box."
 ;Find earliest date....
 S Y=0 S Y=$O(^BMCMSG("B",Y)),Y=$P(Y,".") D DD^%DT S BMCBDT=Y
BDT ;ENTER DATE RANGE
 S DIR(0)="D",DIR("B")=BMCBDT
 S DIR("A")="Enter the beginning date for purging messages, earliest date"
 D ^DIR G:$D(DIRUT) EXT
 S BMCBDT=Y,BMCBDTD=Y(0)
 K DIR("B")
EDT S DIR("A")="Enter the ending date for purging messages"
 D ^DIR G:$D(DIRUT) EXT
 K DIR
 I BMCBDT>Y W !,"Beginning date is greater then Ending Date" G EDT
 S BMCEDT=Y,BMCEDTD=Y(0)
 W !!,"Message will be purged beginning with ",BMCBDTD," THRU ",BMCEDTD,".",!
 S DIR("B")="N"
 S DIR(0)="Y",DIR("A")="Enter Yes to continue, No to exit"
 D ^DIR
 G:'Y EXT
REM ;REMOVE ENTRIES FROM RCIS MESSAGES
 W !,"REMOVING ENTRIES"
 S BMCDT=BMCBDT,BMCT=0
 F  S BMCDT=$O(^BMCMSG("B",BMCDT)) Q:(BMCDT="")!(BMCDT>BMCEDT)  D
 .S BMCMIEN=0
 .F  S BMCMIEN=$O(^BMCMSG("B",BMCDT,BMCMIEN)) Q:BMCMIEN'?1N.N  D
 ..S DIK="^BMCMSG(",DA=BMCMIEN D ^DIK
 ..W "." S BMCT=BMCT+1
 W !,"TOTAL REMOVED = ",BMCT
EXT ;
 K BMCMIEN,BMCT,BMCDT,BMCEDT,BMCEDTD,BMCBDT,BMCBDTD
 K DIR,DIC,DIK,DA,Y,X
 Q
