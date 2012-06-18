APCLADX0 ; IHS/CMI/LAB - cont. apcladx ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
SEX S DIR(0)="YO",DIR("A")="Want to limit search by PATIENT SEX",DIR("B")="NO",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 G:Y=0 FAC
 S DIR(0)="2,.02",DIR("A")="Select sex" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 I X="" G FAC
 S APCLSEX=Y,APCLSEXP=Y(0)
FAC ;
 S DIR(0)="YO",DIR("A")="Want to limit search by FACILITY",DIR("B")="NO",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 G:Y=0 PROV
 S DIC="^AUTTLOC(",DIC(0)="AEQM",DIC("A")="Facility: "
 I $D(DUZ(2)) S DIC("B")=$P(^DIC(4,DUZ(2),0),U)
 D ^DIC K DIC
 I Y=-1 S APCLQUIT=1 Q
 S APCLFAC=+Y,APCLFACP=$P(^DIC(4,+Y,0),U)
PROV S DIR(0)="YO",DIR("A")="Want to limit the search by PRIMARY PROVIDER",DIR("B")="NO",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 G:Y=0 CLN
 I $P(^DD(9000010.06,.01,0),U,2)[200 S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D MIX^DIC1 K DIC,D
 I $P(^DD(9000010.06,.01,0),U,2)[6 S DIC="^DIC(6,",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER (Lastname,Firstname): " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) S APCLQUIT=1 Q
 S APCLPROV=+Y,APCLPRVP=$S($P(^DD(9000010.06,.01,0),U,2)[200:$P(^VA(200,+Y,0),U),1:$P(^DIC(16,+Y,0),U))
CLN S DIR(0)="YO",DIR("A")="Want to limit search by CLINIC TYPE",DIR("B")="NO",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 G:Y=0 SC
 S DIC="^DIC(40.7,",DIC(0)="AEQM",DIC("A")="Clinic: "
 D ^DIC K DIC
 I Y=-1 S APCLQUIT=1 Q
 S APCLCLN=+Y,APCLCLNP=$P(Y,U,2)
SC ;
 K DIR
 S DIR(0)="YO",DIR("B")="NO",DIR("A")="Want to limit search by SERVICE CATEGORY",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 G:Y=0 TYPE
 S DIR(0)="9000010,.07",DIR("A")="Which Service Category" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 S APCLSC=Y,APCLSCP=Y(0)
TYPE ;
 K DIR
 S DIR(0)="YO",DIR("B")="NO",DIR("A")="Want to limit search by VISIT TYPE",DIR("?")="" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 Q:Y=0
 S DIR(0)="9000010,.03",DIR("A")="Which Visit Type" D ^DIR S:$D(DUOUT) DIRUT=1 K DIR
 Q:$D(DIRUT)
 S APCLTYPE=Y,APCLTYPP=Y(0)
 Q
 ;
