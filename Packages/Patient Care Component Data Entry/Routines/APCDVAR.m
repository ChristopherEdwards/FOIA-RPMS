APCDVAR ; IHS/CMI/LAB - SET UP SITE PARAMETER VARS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 I '$D(^APCDSITE(DUZ(2),0)) W !!,"The DATA ENTRY Site Parameters have not been",!,"established for this facility.  PLEASE NOTIFY YOUR SUPERVISOR!",$C(7),$C(7) D DEFAULT,CURRENT,XIT Q
 S APCDPARM=^APCDSITE(DUZ(2),0)
 I $P(APCDPARM,U,2)="U" S AUPNLK("ALL")=""
 I $P(APCDPARM,U,6)="Y" D SETDEF
 ;
CURRENT D HOME^%ZIS
 S APCDNRV="",APCDX="APCDNRV"
 I $D(IOST(0)) S APCDTRM=$S($D(^%ZIS(2,IOST(0),5)):^(5),1:""),APCDRVON=$S($P(APCDTRM,U,4)]"":$P(APCDTRM,U,4),1:APCDX),APCDRVOF=$S($P(APCDTRM,U,5)]"":$P(APCDTRM,U,5),1:APCDX)
 S:'$D(APCDRVON) (APCDRVON,APCDRVOF)=""
DUZ ;
 I '$G(DUZ) W !!,"WARNING:  User NOT set in DUZ  - Use Kernel!!",$C(7),$C(7)
 E  K APCDMFI
XIT ;
 K APCDX,APCDTRM
 Q
DEFAULT ;EP
 W !!,"Defaulting Site Parameters to the Following: ",!
 W "1) Site Specific Lookup  2) Do Not ask 'Yes' on Visit Creation",!,"3) Display Problem Lists and Historical Data  4) FORMS Tracking OFF  ",!,"5) NO Default Values Used",!
 S APCDPARM="^S^N^Y^N^N^Y^Y^"
 Q
 ;
SETDEF ;
 S APCDDEFL=$P(^APCDSITE(DUZ(2),0),U,9),APCDDEFT=$P(^(0),U,11),APCDDEFS=$P(^(0),U,12),APCDDEFC=$P(^(0),U,13)
 Q
ERR ;
 W !,$C(7),"Default Values Missing!!  Notify your PCC Manager!",! S $P(APCDPARM,U,6)="N"
 Q
