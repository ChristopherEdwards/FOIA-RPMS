INHOM(UIF) ;JSH;08:58 AM  17 Oct 1997;Interface - send to MailMan ; 07 Oct 91   6:43 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;UIF = entry # in Universal Interface File
 ;
 S X="ERR^INHOM",@^%ZOSF("TRAP")
 K (UIF,XUAUDIT,XUTIMP,XUTIMT,XUTIMH,INBPN,INHSRVR)
 X $G(^INTHOS(1,2)) K ^INLHSCH("GO")
 D SETENV^INHUT7
 I '$D(^INTHU(+$G(UIF),0)) D ERROR^INHOS("Missing UIF entry #"_$G(UIF),"M") G Q
 N DEST S DEST=+$P(^INTHU(UIF,0),U,2)
 I '$D(^INRHD(DEST,0)) D ERROR^INHOS("Missing DESTINATION entry #"_$G(UIF),"M") G Q
 S X=$P($G(^INRHSITE(1,0)),U,6) X:X ^%ZOSF("PRIORITY")
 K XMY,INMESS,XMZ,INHER
 S REC=$P(^INRHD(DEST,0),U,4) I REC="" D ERROR^INHOS("Missing mail recipient for DESTINATION '"_$P(^INRHD(DEST,0),U)_"'","M") G Q
 ;Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(UIF,"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"MAIL")
 D
 . I $E(REC,1,2)="G."!($E(REC,1,2)="g.") S X=REC,XMDUZ=0 D WHO^XMA21 Q
 . S XMY(REC)=""
 S I=0 F  S I=$O(^INTHU(UIF,3,I)) Q:'I  S INMESS(I,0)=^(I,0),L=$L(INMESS(I,0)) S:$E(INMESS(I,0),L-3,L)="|CR|" INMESS(I,0)=$E(INMESS(I,0),1,L-4)
 S XMDUZ=.5,XMTEXT="INMESS("
 S XMSUB=$P(^INRHD(DEST,0),U,7) S:XMSUB="" XMSUB="GIS Transaction"
 K INHERR N ZTSK S ZTSK="" D ^XMD S ER=0
 S:'$G(XMZ) ER=2,INHERR(1)="GIS Transaction rejected by MailMan"
 ;Stop transaction audit with "complete" code.
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 K INTT D DONE^INHOS
Q Q
 ;
ERR ;Process and error
 ;Stop transaction audit with error code.
 D:$D(XUAUDIT) TTSTP^XUSAUD(1)
 D ENT^INHE(UIF,DEST,$$ERRMSG^INHU1) X ^INTHOS(1,3) G Q
 ;
