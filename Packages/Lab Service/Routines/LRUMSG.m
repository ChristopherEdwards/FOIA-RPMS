LRUMSG ; IHS/DIR/FJE - SEND SPECIAL MESSAGE 12/14/88 09:16 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 K XMY,XMDUZ,XMSUB,XMTEXT S XMDUZ=DUZ F A=0:0 S A=$O(^XUSEC(LR("KEY"),A)) Q:'A  S XMY(A)=""
 Q:'$D(XMY)
 S XMSUB=LR("SUB"),XMTEXT="LR(""TXT""," D ^XMD K XMY,LR("TXT"),LR("SUB"),XMSUB,XMDUZ,LR("KEY") Q
 ;XMY= local array of users's DUZ's
 ;XMDUZ= sender's DUZ
 ;XMSUB=subject of message ;LR("TXT") variable passed from a routine
 ;XMTEXT= name of message array for mailman
