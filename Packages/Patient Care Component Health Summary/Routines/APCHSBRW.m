APCHSBRW ; IHS/CMI/LAB - Browse Health Summary ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This routine allows the user to display a HS using the
 ;  browse feature.
 ;
BROWSE ;EP - called from option BROWSE HEALTH SUMMARY
 ;
 I $T(VIEWR^XBLM)="" W !!!?5,"*** Browser Utility not available!! ***" Q
 D GETTYP
 I '$D(APCHSTYP) G END
 D SELPT
 G:'$D(APCHSPAT) END
 ;QUIT IF NO PATIENT
 S DFN=APCHSPAT
 S APCHHDR="PCC Health Summary for "_$P(^DPT(DFN,0),U)
 D VIEWR^XBLM("EN^APCHS",APCHHDR)
 D END
 Q
 ;
GETTYP ; EP - get health summary TYPE
 K APCHSTYP
 K DIC S DIC=9001015,DIC("A")="Select health summary type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC I Y>0 S APCHSTYP=+Y
 K DIE,DA,DR,DD
 Q
SELPT ;select patient
 K APCHSPAT
 K DIC S DIC=9000001,DIC("A")="Select patient: ",DIC(0)="AEQM" D ^DIC
 K DIC
 Q:$D(DUOUT)
 I Y="" G SELPT
 I Y>0 S APCHSPAT=+Y
 Q:Y<0
 Q:$D(DUOUT)
 W:$D(^AUPNPAT(APCHSPAT,41,DUZ(2),0)) !,"Patient's chart number is ",$P(^(0),U,2),!
 Q
 ;
END K APCHSTYP,APCHSPAT,POP,X,Y
 D EOJ^APCHS
 K DA,D0,DFN,APCHHDR
 K APCHSCCL,APCHSDCL,APCHSQT
 D KILL^AUPNPAT
 K DIC,DUOUT
 Q
