AMHLEPRC ; IHS/CMI/LAB - LOOKUP ICD9 ENTRY ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ; This routine looks up an entry in the ICD DIAGNOSIS file (80).
 ;
START ;
 D EN^XBNEW("EN^AMHLEPRC","AMH*") ;  new everthing except AMH*
 Q
 ;
EN ; ENTRY POINT FOR ^XBNEW
 NEW AMHQ
 F  D LOOP Q:AMHQ
 Q
 ;
LOOP ;
 S AMHQ=1
 W:$G(IOF)'="" @IOF
 W !!!?20,"*******   ENTER CPT PROCEDURES  *******",!!
 W !,"[Press ENTER when finished]",!
 I $D(^AMHRPROC("AD",AMHR)) W "CPT procedure codes currently recorded for this visit:" S AMHX=0 F  S AMHX=$O(^AMHRPROC("AD",AMHR,AMHX)) Q:AMHX'=+AMHX  D
 .W !,$$VAL^XBDIQ1(9002011.04,AMHX,.01),"  ",$$VAL^XBDIQ1(9002011.04,AMHX,.019)
 W ! S DIC=81,DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 ; add new mh/ss procedure
 S AMHLOOK=1
 S DIC="^AMHRPROC(",DIC(0)="L",DLAYGO=9002011.04,DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR,X=+Y
 K DD,D0,DO D FILE^DICN D ^XBFMK K DLAYGO,DIADD
 K AMHLOOK
 S AMHQ=0
 Q
