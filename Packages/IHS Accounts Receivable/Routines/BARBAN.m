BARBAN ; IHS/SD/LSL - Accounts Receivable Banner FEB 4,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4**;OCT 26, 2005
 ;
 ;
BEG ;
 G XIT:'$D(DUZ(2))
 G XIT:(DUZ(2)'>0)
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),"^",1)
 I '$D(IOF)!'$D(IO) D
 . S IOP="HOME"
 . D ^%ZIS
 W $$EN^BARVDF("IOF")
 W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 W !?11,"|"
 S BAR("VER")=$O(^DIC(9.4,"C","BAR",""))
 I BAR("VER")]"",$D(^DIC(9.4,BAR("VER"),"VERSION"))
 S BAR("VER")=$S('$T:"VERSION 1.0",1:"VERSION "_^DIC(9.4,BAR("VER"),"VERSION"))
 S BAR("TITL")="ACCOUNTS RECEIVABLE SYSTEM - VER "_$P(BAR("VER")," ",2)
 W ?80-$L(BAR("TITL"))\2,BAR("TITL"),?69,"|"
 S:'$D(BAR("SCRNTITL")) BAR("SCRNTITL")="??????"
 W !,?11,"+",?80-$L($P($G(XQY0),U,2))\2,$P($G(XQY0),U,2),?69,"+"
 W !?11,"|"
 W ?80-$L(BAR("SITE"))\2,BAR("SITE")
 W ?69,"|"
 ;UFMS BAR*1.8*3
 ;I $D(UFMSESID) D
 I $G(UFMSESID) D   ;IHS/SD/TPF BAR*1.8*4 IM26184
 .S CASHMSG="** LOGGED INTO CASHIERING MODE **"
 .W !?11,"|"
 .W ?80-$L(CASHMSG)\2,CASHMSG
 .W ?69,"|"
 ;END UFMS BAR*1.8*3
 ;
END ;
 W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 I $D(^VA(200,DUZ,0)) D
 .W !,?5,"User: ",$P(^VA(200,DUZ,0),U)
 .W ?35,$$VAL^XBDIQ1(200,DUZ,29)
 .D NOW^%DTC
 .W ?55,$$MDT^BARDUTL(%)
 ;
XIT ;
 K BAR
 Q
