BDGBULL ; IHS/ANMC/LJF - POST A&D BULLETIN ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
ADS ;EP; --  manually post bulletin when A&D sheet checked to be okay
 NEW DIC,X,Y,XMB,XMT,XMDT
 D ^XBCLS W !!?12,"MANUALLY POST BULLETIN THAT A&D SHEET IS READY",!!
 ;
 ; find bulletin and display text
 S X="BDG A&D READY",DIC(0)="QMZ",DIC="^XMB(3.6," D ^DIC
 ;
 I Y<1 D  Q
 . W !!,"Bulletin not found; check with your computer support staff."
 . D PAUSE^BDGF
 ;
 W !,"Fill in the date for the message below:",!
 S XMB=$P(Y(0),U,1),XMJ=0
 F I=1:1 S XMJ=$O(^XMB(3.6,+Y,1,XMJ)) Q:XMJ=""  W !,^(XMJ,0)
 ;
 ; ask user for date and if okay to proceed
 S Y=$$READ^BDGF("FO","Enter A&D Sheet Date") Q:Y=""  Q:Y=U  S XMB(1)=Y
 S Y=$$READ^BDGF("YO","Okay to Post Bulletin Now")
 I Y S XMT=0 D ^XMB
END Q
