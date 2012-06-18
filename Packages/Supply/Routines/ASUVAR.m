ASUVAR ; IHS/ITSC/LMH -UTIL SET PACKAGE VARIABLES ;    [ 06/30/2000  3:54 PM ]
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This is the SAMS package wide variable setting routine.
 I $G(U)']"" D ^XBKVAR
 I $G(ASUC("TR"))]"" D
 .I ASUC("TR")'["." S ASUC("TR")=ASUC("TR")_".0"
 I '$D(ASUL(1)) D SETAREA^ASULARST
 D ASKDATE^ASUUDATE
 D:($D(ASUK("DT"))#10)=0 ^ASUUDATE
EN2 ;EP ;
 I $D(ASUL(1,"AR","AP")) I ASUL(1,"AR","AP")=U W !?15,"*",?25," NO AREA CODE AVAILABLE",?59,"*" S ASUL(1,"AR","AP")="",DUOUT=1 G END
 I '$D(ASUL(2,"STA")) D
 .S DIC("A")="ENTER STATION CODE " S DIC(0)="MEA",DIC="^ASUL(2," D ^DIC
 .I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) Q
 .I Y>0  D
 ..D STA^ASULARST(+Y)
 .E  D
 ..I $G(ASUL(1,"AR","STA1"))]"" D  Q:'Y  ;DFM P1 9/3/98 Whole subroutine
 ...D STA^ASULARST(ASUL(1,"AR","STA1"))
 ...W !,ASUL(2,"STA","NM")," Will be default Station" N DIR S DIR(0)="Y" D ^DIR
 ...I 'Y K ASUL(2)
 I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) D  Q
 .S XQUIT=1
 .W @(IOF)
 .W !!!!,*7,*7,?20," * * * * W A R N I N G * * * * *",!!!!!?13," S T A T I O N   N O T   S E L E C T E D!!",!!!?5," A C C E S S   T O   S A M S   N O T   A L L O W E D",!!!!?5,"W I T H O U T   S T A T I O N   S E L E C T I O N  !!!",!!!!
 I $G(ASUL(2,"STA","CD"))']"" D
 .W !,*7,"STATION CODE MUST BE SELECTED!!" G EN2 ;DFM P1 9/3/98
 ;REM 3/3/99 WAR->S ASUL("ARNM")=ASUL(1,"AR","NM"),ASUL("AR")=ASUL(1,"AR","AP"),ASUL("ST")=$G(ASUL(2,"STA","CD")),ASUL("STNM")=$G(ASUL(2,"STA","NM")),ASUL("ST#")=$G(ASUL(2,"STA","E#"))
 S ASUL("ST#")=$G(ASUL(2,"STA","E#"))
 S Z=$L(ASUL(1,"AR","NM"))+27,Z=(80-Z)/2
END ;
 Q
