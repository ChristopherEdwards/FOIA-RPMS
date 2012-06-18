XBKVAR ; IHS/ADC/GTH - SET MINIMUM KERNEL VARIABLES ; [ 11/04/97  10:26 AM ]
 ;;3.0;IHS/VA UTILITIES;**5**;FEB 07, 1997
 ; XB*3*5 IHS/ADC/GTH 10-31-97 Correct the setting of DUZ("AG").
 ;
START ;
 S U="^"
 I '$D(DUZ(2)),$D(^AUTTSITE(1,0)) S DUZ(2)=+^(0)
 I '$D(DUZ(2)),$D(^AUTTLOC("SITE")) S DUZ(2)=+^("SITE")
 ; I '$D(DUZ("AG")) S DUZ("AG")=$S($P($G(^XMB(1,0)),"^",8)]"":$P(^XMB(1,0),"^",8),1:"I") ; XB*3*5 IHS/ADC/GTH 10-31-97 Correct the setting of DUZ("AG").
 I '$D(DUZ("AG")) S DUZ("AG")=$S($P($G(^XMB(1,1,0)),"^",8)]"":$P(^XMB(1,1,0),"^",8),1:"I") ; XB*3*5 IHS/ADC/GTH 10-31-97 Correct the setting of DUZ("AG").
 S:'($D(DUZ)#2) DUZ=0
 S:'($D(DUZ(0))#2) DUZ(0)=""
 S:'($D(DUZ(2))#2) DUZ(2)=0
 I '$D(DT) S DT=($$HTFM^XLFDT($H)\1)
 S:'$D(DTIME) DTIME=999
 KILL %,%H,%I
 Q
 ;
