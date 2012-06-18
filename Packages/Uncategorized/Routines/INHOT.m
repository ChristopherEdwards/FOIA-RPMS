INHOT(UIF,MODE,INDEV) ;FRW,JSH; 20 Oct 97 12:34; Program to handle output to a Transceiver program ; 07 Oct 91   6:43 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INPUT:
 ;  UIF    - entry # in Interface file
 ;  MODE   - mode of operaton (0=multi-thread, 1=single thread)
 ;  INDEV  - (optional) device name
 ;
 S X="ERR^INHOT",@^%ZOSF("TRAP")
 K (INBPN,INHSRVR,INPNAME,XUAUDIT,XUTIMP,XUTIMT,XUTIMH,UIF,MODE,INDEV) S INDEV=$G(INDEV)
 X $G(^INTHOS(1,2))
 D SETENV^INHUT7
 S X=$P($G(^INRHSITE(1,0)),U,6) X:X ^%ZOSF("PRIORITY")
 I $L(INDEV) K %ZIS S %ZIS="0",IOP=INDEV D ^%ZIS I POP D ERROR^INHOS("Device: "_INDEV_" not available","T") G Q
 I '$D(^INTHU(+$G(UIF),0)) D ERROR^INHOS("UIF file entry missing: "_+$G(UIF),"T") G Q
 N DEST S DEST=+$P(^INTHU(UIF,0),U,2)
 I '$D(^INRHD(DEST,0)) D ERROR^INHOS("Missing DESTINATION number or entry: "_+$G(DEST),"T") G Q
 U:IO]"" IO S ^INLHSCH("ACT",DEST,$J)=""
EN1 ;Restart with a new UIF entry
 I '$D(^INTHU(+$G(UIF),0)) D ERROR^INHOS("UIF file entry missing: "_+$G(UIF),"T") G Q
 S ROU=$P(^INRHD(DEST,0),U,3) I ROU="" D ERROR^INHOS("Destination: "_$P(^INRHD(DEST,0),U)_" is missing a routine name.","T") G Q
 S:ROU'["^" ROU="^"_ROU
 ;Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(UIF,"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"OUTPUT")
 K INHERR S Z="N MODE,DEST S ER=$$"_ROU_"("_UIF_",.INHERR)" X Z
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
RET K INTT D:ER>-1 DONE^INHOS
 ;S UIF=$$CHK G:UIF EN1
 ;
Q ;Quit tag
 D:$L(INDEV) ^%ZISC K ^INLHSCH("ACT",DEST,$J)
 Q
 ;
ERR ;Handle an error
 X ^INTHOS(1,3)
 D ENT^INHE(UIF,$G(DEST),$$ERRMSG^INHU1) K ZTERROR
 S ER=2 G RET
 ;
CHK() ;Look for another entry with this destination
 ;8/31/94--not using this functionality for now, though may
 ;want to revise for some future use -- dgh
 Q:'$D(^INRHB("RUN",1)) ""
 L +^INLHSCH
 N H,DA,PRIO
 S DA=0,PRIO="" F  S PRIO=$O(^INLHSCH("DEST",DEST,PRIO)) Q:PRIO=""  D  Q:DA
 . S DA=0 F  S DA=$O(^INLHSCH("DEST",DEST,PRIO,DA)) Q:'DA  S H=^(DA) I '$D(^INLHSCH(PRIO,H,DA)) Q:$H>+H!(+$H=+H&($P($H,",",2)>$P(H,",",2)))
 K:DA ^INLHSCH("DEST",DEST,PRIO,DA)
 L -^INLHSCH Q DA
 ;
