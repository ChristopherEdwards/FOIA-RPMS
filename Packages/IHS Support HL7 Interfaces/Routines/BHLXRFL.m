BHLXRFL ; cmi/flag/maw - BHL Read X12 File in and stuff into ^INTHU ; [ 10/10/2002  9:29 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;6;JUL 01, 2001
 ;
 ;
 ;
 ;this routine will grab a file from HFS and stuff it into the ^INTHU
 ;global for processing
 ;
MAIN(XMSG,BHLXDIR,BHLXPRE,BHLXTF) ;-- this is the main routine driver
 D ^%ZISC
 K ^BHLX12($J)
 D READ
 D ^%ZISC
 D EOJ
 Q
 ;
READ ;-- read the file in
 ;cmi/maw we need to set up dynamic directory reads here
 I $G(BHLXTF)="" S BHLXTF="T"
 S BHLXLST=$$LIST^%ZISH(BHLXDIR,BHLXPRE,.BHLXLST)
 S BHLXFDA=0 F  S BHLXFDA=$O(BHLXLST(BHLXFDA)) Q:'BHLXFDA  D
 . D ^%ZISC
 . S BHLXFNM=$G(BHLXLST(BHLXFDA))
 . S Y=$$OPEN^%ZISH(BHLXDIR,BHLXFNM,"R")
 . F I=1:1 U IO R BHLXT:DTIME Q:BHLXT=""  D
 .. I BHLXTF="P" F J=1:1 S BHLXREC=$P(BHLXT,"~",J),^BHLX12($J,J)=$G(BHLXREC) Q:BHLXREC=""  ;real messages
 .. I BHLXTF="T" S BHLXREC=BHLXT,^BHLX12($J,I)=$G(BHLXREC) Q:BHLXREC=""  ;test messages
 . D STUFF
 Q
 ;
STUFF ;-- stuff the information into ^INTHU
 D NOW^%DTC S BHLXDTM=$G(%)
 S BHLXH=$H
 S BHLXDEST=$O(^INRHD("B","X1 IHS "_XMSG_" IN",0))
 S BHLXSTAT="N"
 S BHLXIO="I"
 S BHLXPRIO=1
 K DD,DO
 S DIC="^INTHU(",DIC(0)="L",X=BHLXDTM
 S DIC("DR")=".02////"_BHLXDEST_";.03////"_BHLXSTAT_";.1////"_BHLXIO
 S DIC("DR")=DIC("DR")_";.16///"_BHLXPRIO
 D FILE^DICN
 S BHLXUIF=+Y
 S BHLXDA=0 F  S BHLXDA=$O(^BHLX12($J,BHLXDA)) Q:'BHLXDA  D
 . K DIC,DD,DO
 . S DIC="^INTHU("_BHLXUIF_",3,",DIC(0)="L"
 . S DIC("P")=$P(^DD(4001,3,0),"",2)
 . S DA(1)=BHLXUIF,X=$G(^BHLX12($J,BHLXDA))_"|CR|"
 . Q:X=""
 . D FILE^DICN
 K ^INTHU(BHLXUIF,3,"B")  ;don't need b index on msg multiple
 S ^INLHSCH(BHLXPRIO,BHLXH,BHLXUIF)=""
 Q
 ;
EOJ ;-- kill variables and quit
 K I,J
 D EN^XBVK("BHLX")
 K ^BHLX12($J)
 Q
 ;
