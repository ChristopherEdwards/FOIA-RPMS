APCDECC ; IHS/CMI/LAB - DATA ENTRY CHECK CHART LOCATIONS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 Q:'$D(^APCDSITE(DUZ(2),11,APCDLOC))
 Q:$D(^AUPNPAT(APCDPAT,41,APCDLOC))
 W !!,$C(7),$C(7),"This patient, ",$P(^DPT(APCDPAT,0),U),", does NOT have a CHART",!,"at the Location of Visit that you specified.  The site parameter indicates",!,"that he/she should have a chart at that location."
 W ! S DIR(0)="Y",DIR("A")="Do you want to continue with this VISIT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT)!(Y=0) S APCDPAT="" Q
 Q
