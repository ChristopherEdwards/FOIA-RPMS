XUS911 ;SF/STAFF -  REPORT OF USERS SIGNED ON ;1/22/93  14:26 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;7.1;KERNEL;;May 11, 1993
 ;THIS ROUTINE CONTAINS IHS MODIFICATIONS BY IHS/ANMC/MWR; IHS/ANMC/CLS
 ;;IHS/ANMC/MWR LOOKUP FOR A SINGLE USER
 ;
 S U="^",XUSUCI="" I $D(^%ZOSF("UCI")) X ^%ZOSF("UCI") S XUSUCI=Y
 ;
BEGIN ; -- begin ihs mods  ;IHS/ANMC/MWR
 F  D LOOKUP Q:Y=-1
 D END
 Q
 ;
LOOKUP ;
 W !!
 S DIC=200,DIC(0)="QEMA"
 S DIC("A")="Select the user you wish to check on: "
 D ^DIC
 Q:Y=-1
 S MWRUSR=$P(Y,U,2)
 D CODES
 Q
 ;
CODES ;
 S:'$D(DTIME) DTIME=300
 ; -- end ihs mods  ;IHS/ANMC/MWR
 ;
 S XQHDR="    USER STATUS REPORT      "_XUSUCI
 S %H=$H D YMD^%DTC S DT=X
 W !,"Lookup pass " K ^TMP($J) S XQJN=0
 F I=0:0 S XQJN=$O(^XUTL("XQ",XQJN)) Q:XQJN'>0  S X=XQJN X ^%ZOSF("JOBPARAM") S XQK=$P(Y,U,1) D:(XUSUCI=XQK)!(XQK="UNKNOWN") PASS1
 S IOP="" D ^%ZIS K IOP S XQPG=0,XQUI=0 D NEWPG
PRINT S XQUN=-1 F I=0:0 S XQUN=$O(^TMP($J,XQUN)) Q:(XQUN="")!XQUI  S XQJN=0 F J=0:0 S XQJN=$O(^TMP($J,XQUN,XQJN)) Q:(XQJN="")!XQUI  S XQV=^(XQJN) D LIST
 ;G END
 Q  ;IHS/ANMC/MWR
 ;
PASS1 ;
 W "." S XQUN="UNKNOWN" I $D(^XUTL("XQ",XQJN,"DUZ")) S XQUN=^("DUZ"),XQUN=$S($D(^VA(200,XQUN,0)):$P(^(0),U,1),1:"UNKNOWN")
 S XQV="UNKNOWN" I $D(^XUTL("XQ",XQJN,0)) S XQV=$P(^(0),".",2)_"00",XQV=$E(XQV,1,2)_":"_$E(XQV,3,4)
 S XQV=XQV_U_$S('$D(^XUTL("XQ",XQJN,"IO")):"UNKNOWN",1:^("IO"))
 S XQK="UNKNOWN" I $D(^XUTL("XQ",XQJN,"T")),^("T") S XQK=^("T") I $D(^(XQK)) S XQK=$E($P(^(XQK),U,3),1,29)
 I XQK="UNKNOWN",$D(^XUTL("XQ",XQJN,"ZTSK")) S XQJ=^("ZTSK") S:$D(^("XQM")) XQJ=$P(^DIC(19,^("XQM"),0),U,2) S XQK=$E(XQJ,1,19)_" *Tasked"
 S ^TMP($J,XQUN,XQJN)=XQV_U_XQK
 Q
LIST ;
 ;D:$Y>19 NEWPG Q:XQUI  S (X,Y)=XQJN,X1=16 I X>127 D CNV^XTBASE ;IHS/ANMC/CLS commented out
 D:$Y>19 NEWPG Q:XQUI    S (X,Y)=XQJN,X1=16;;IHS/ANMC/CLS 11/4/94 per Floyd Dennis so job # > 127 doesn't print in hex
 Q:MWRUSR'=XQUN  ;IHS/ANMC/MWR
 W !,Y,?12,$E(XQUN,1,19),?33,$P(XQV,U,1),?42,$P(XQV,U,2),?50,$P(XQV,U,3,99)
 Q
NEWPG ;
 I XQPG,$E(IOST,1)="C" D CON S XQUI=(X="^") Q:XQUI
 D HDR Q
CON ;
 W !!,"Press return to continue or '^' to escape " R X:DTIME S:'$T X=U
 Q
HDR ;
 W @IOF S XQPG=XQPG+1
 S Y=$P($H,",",2)\60,Y=(Y#60/100+(Y\60)/100+DT) D DT^DIO2
 W ?22,XQHDR,?71,"PAGE ",XQPG
 W !!,"JOB NUMBER  USER NAME            TIME ON  DEVICE  CURRENT MENU OPTION"
 W !,"----------  -------------------  -------  ------  ------------------------------"
 Q
END ;
 K MWRUSR  ;IHS/ANMC/MWR
 K XQI,XQJN,XQUN,XUSUCI,ZJ,XQJ,XQK,XQUI,XQPG,XQHDR,XQV,D,J,X,XQM,XQT,Y,Z,^TMP($J)
 Q
 Q
TESTM ;
 W !!,"This option will allow you to simulate signing on as another user to test their",!,"menus and keys.  You can step through menus, but cannot execute options.",!,"Return to your own identity by entering a '*'.",!
 S DIC=200,DIC(0)="AEQMZ" D ^DIC Q:Y<0
 I $S('$D(^VA(200,+Y,201)):1,($P(^VA(200,+Y,201),U,1)=""):1,1:0) W !!,*7,"This user has no primary menu." Q
 S XQY=^VA(200,+Y,201),DUZ("SAV")=DUZ_U_DUZ(0),DUZ=+Y,DUZ(0)=$P(Y(0),U,4),%=$P(^VA(200,+Y,0),U,1),DUZ("SAV")=DUZ("SAV")_U_$P(%,",",2)_" "_$P(%,",",1) G ^XQ
 Q
TESTN ;
 S DUZ=+DUZ("SAV"),DUZ(0)=$P(DUZ("SAV"),U,2),XQY=+^VA(200,DUZ,201) K DUZ("SAV"),XQUR,XMDUZ
 W !!,"OK...  Returning to your own identity."
 G ^XQ
