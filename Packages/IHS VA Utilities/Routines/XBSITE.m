XBSITE ; IHS/ADC/GTH - SET "DUZ(2)" ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
L1 ;
 KILL DIC
 G:$D(DUZ)=0!($D(DUZ)=10) ERRMSG
 I ('$D(^DIC(3,DUZ,0))),('$D(^VA(200,DUZ,0))) G ERRMSG
 I ('$D(^DIC(3,DUZ,2,0))),('$D(^VA(200,DUZ,2,0))) G ERRMSG1
 I +DUZ(2)>0 S DIC("B")=$P(^DIC(4,DUZ(2),0),"^",1) G B1
 S DIC("B")="Site set to zero (0) for Universal"
B1 ;
 W !!
 D ASK
 S SITENUM=DUZ(2)
 KILL DIC("A"),DIC("B"),DA,DR,Y
 Q
 ;
ASK ;
 S DIC="^DIC(3,DUZ,2,",DIC("A")="Enter your facility's name: ",DIC(0)="QAEM"
 I $D(^VA(200,DUZ,2,0)) S DIC="^VA(200,DUZ,2,"
 D ^DIC
 G:X["?" ASK
 I X="^",$D(DIC("B")) W !,*7,"The default facility remains ",DIC("B"),!! Q
 S DUZ(2)=+Y
 I DUZ(2)<1 S DUZ(2)=$P(^AUTTSITE(1,0),U,1) W !,*7,"The default facility has been set to ",$P(^DIC(4,DUZ(2),0),"^",1),!!
 S SITENUM=DUZ(2)
 Q
 ;
SET ;PEP - Request Set of DUZ(2) from applications.
 G L1
 ;
ERRMSG ;
 W !!,"USER not set in DUZ - use KERNEL!"
 Q
 ;
ERRMSG1 ;
 W !!,"No Divisions (facilities) set in USER file!"
 Q
 ;
ERRMSG2 ;
 W !!,"That facility is not included in your Divisions field in the USER file!"
 Q
 ;
