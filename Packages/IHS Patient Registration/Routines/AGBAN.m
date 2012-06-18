AGBAN ; IHS/ASDS/EFG - 3P Billing Banner MODIFIED FOR AG ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 S AGM(0)=$S($D(Y(0)):$P(Y(0),U,2),$D(XQU0):$P(ZQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 D SET^XBSITE:'$D(DUZ(2)) I $D(DUZ(2)) S AGM("SITE")=$P(^DIC(4,DUZ(2),0),"^",1) I 1
 E  G XIT
 I '$D(IOF)!'$D(IO) S IOP=ION D ^%ZIS
 W $$S^AGVDF("IOF")
ENT W !!
 W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 W !?11,"|"
 S AGM("VER")=$O(^DIC(9.4,"C","AG","")) I AGM("VER")]"",$D(^DIC(9.4,AGM("VER"),"VERSION"))
 S AGM("VER")=$S('$T:"VERSION 4.4",1:"VERSION "_^DIC(9.4,AGM("VER"),"VERSION"))
 I '$D(AGM("PACKAGE")) S AGM("TITL")="PATIENT REGISTRATION SYSTEM - VER "_$P(AGM("VER")," ",2) W ?80-$L(AGM("TITL"))\2,AGM("TITL"),?69,"|"
 E  S AGM("TITL")="PATIENT REGISTRATION SYSTEM" W ?80-$L(AGM("TITL"))\2,AGM("TITL"),?69,"|"
 W !,?11,"+"
 I $D(AGM("PACKAGE")) W ?80-$L(AGM("VER"))\2,AGM("VER"),?69,"+"
 E  W ?80-$L($P(AGM(0),U,2))\2,$P(AGM(0),U,2),?69,"+"
 W !?11,"|"
 W ?80-$L(AGM("SITE"))\2,AGM("SITE")
 W ?69,"|"
END W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 W !
XIT K AGM
 Q
