ZU ;SF/GFT - For MSM, TIE ALL TERMINALS EXCEPT CONSOLE TO THIS ROUTINE!! ;08/24/98  11:26
 ;;8.0;KERNEL;**1005**;FEB 24, 1999
 ;;8.0;KERNEL;**13,42,49,94**;Jul 10, 1995
 ;FOR MSM-DOS and MSM-UNIX
EN S $ZT="ERR^ZU",ZUGUI2=$$GUI()
 D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$LOGIN$")
 ;The next line keeps sign-on users from taking the last slot
 ;It can be commented out if not needed.
JOBCHK X ^%ZOSF("AVJ") I Y<3 W $C(7),!!,"** TROUBLE ** - ** CALL IRM NOW! **" G HALT
 ;Bump up the partition size
 D GETENV^%ZOSV S Y=$P(Y,"^",4),%=$O(^%ZIS(14.7,"B",Y,0)),Y=$G(^%ZIS(14.7,+%,0)),%K=$P(Y,"^",5) I %K>0 D INT^%PARTSIZ
 G ^XUSG:$G(ZUGUI1),^XUS
 ;
G ;Entry point for GUI device.
 S ZUGUI1=1 G EN
 ;
ERR S $ZT="HALT^ZU" L  ;Come here on error.
 B 0 ;Turn off break
 S %ZTERLGR=$ZR,%ZT("^XUTL(""XQ"",$J)")="" D ^%ZTER
 I $G(IO)]"",$D(IO(1,IO)),$E($G(IOST))="P" U IO W @$S($D(IOF):IOF,1:"#")
 I $G(IO(0))]"" U IO(0) W !!,"RECORDING THAT AN ERROR OCCURRED ---",!!?15,"Sorry 'bout that",!,*7,!?10,"$ZERROR=",$ZERROR
 X ^%ZOSF("PROGMODE") Q:Y  S $ZT="HALT^ZU"
 I $ZE'["<INRPT>" S XUERF="" G ^XUSCLEAN
CTRLC I $D(IO)=11 U IO(0) W !,"--Interrupt Acknowledged",!
 D KILL1^XUSCLEAN ;Clean up symbol table
 ;
CTRLC2 G:$G(^XUTL("XQ",$J,"T"))<2 ^XUSCLEAN
 S ^XUTL("XQ",$J,"T")=1,XQY=^(1),XQY0=$P(XQY,"^",2,99)
 G:$P(XQY0,"^",4)'="M" CTRLC2
 S XQPSM=$P(XQY,"^",1),XQY=+XQPSM,XQPSM=$P(XQPSM,XQY,2,3)
 G:'XQY ^XUSCLEAN
 S $ZT="ERR^ZU" G M1^XQ
 ;
HALT S $ZT="" I $D(^XUTL("XQ",$J)) D BYE^XUSCLEAN
 D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$LOGOUT$")
 HALT
 ;
GUI() ;Test if under GUI
 Q "" ;Just say No.
 S $ZT="GUIX",X="" G:$PD'=1 GUIX
 S X=$G(^$DI($PD,"PLATFORM"))
GUIX Q X
