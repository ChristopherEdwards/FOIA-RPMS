LRIPOSXM ;DALISC/PAC - SEND MAIL MESSAGE TO LAB DEVELOPERS ;7/10/92  12:35
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
EN ;
 Q:'$D(DIFQ)  S LRVR0=$P($T(+2),";",3)
 S LRTXT(2)="@"_$P($G(^DIC(4.2,$P(^XMB(1,1,0),U),0)),U)_"."
 ;The distributing ISC should edit the following line to the correct
 ;Domain and mail group
 S XMDUZ=DUZ,XMSUB="LAB PKG V"_LRVR0_" INSTALL"_LRTXT(2),XMTEXT="LRTXT(",XMY("G.LAB@DOMAIN.NAME")=""
 S LRTXT(1)="The Laboratory package V"_LRVR0_" has been installed " D ^XMD
EXIT K XMDUZ,XMSUB,XMTEXT,LRTXT Q  ;D ^LRINITY Q
