APCHHMRD ; IHS/CMI/LAB - DISPLAY HEALTH MAINTENANCE REMINDER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP ;EP - called from option to select and display a hmr
 W:$D(IOF) @IOF
 W !!,"This option will allow a site to inactivate or activate a health maintenance",!,"reminder.",!!
EP1 ;
 D ^XBFMK
 S DIC="^APCHSURV(",DIC("A")="Select HEALTH REMINDER to Activate/Inactivate: ",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,3)'=""D"",$P(^(0),U,7)=""R""" D ^DIC
 I Y=-1 D EXIT Q
 S APCHHMR=+Y
INIT ; -- init variables and list array
 K ^TMP("APCHHMRD",$J)
 S ^TMP("APCHHMRD",$J,0)=0
 ;gather up reminder for display
 S C=0,X="",X="Reminder:",$E(X,20)=$P(^APCHSURV(APCHHMR,0),U) D S(X)
 S X="",X="Status:",$E(X,20)=$$VAL^XBDIQ1(9001018,APCHHMR,.03) D S(X)
 S X="Description:" D S(X,1)
 S Y=0 F  S Y=$O(^APCHSURV(APCHHMR,1,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHHMR,1,Y,0) D S(X)
 S X="Currently Defined Criteria in Use at this Facility" D S(X,1)
 I '$O(^APCHSURV(APCHHMR,11,0)) S X="<<< No local criteria defined. >>>" D S(X)
 S Y=0 F  S Y=$O(^APCHSURV(APCHHMR,11,Y)) Q:Y'=+Y  D
 .S Z="",$E(Z,5)="Sex:  "_$S($P(^APCHSURV(APCHHMR,11,Y,0),U)="F":"FEMALE",$P(^APCHSURV(APCHHMR,11,Y,0),U)="M":"MALE",$P(^APCHSURV(APCHHMR,11,Y,0),U)="B":"BOTH",1:"")
 .S J=0 F  S J=$O(^APCHSURV(APCHHMR,11,Y,11,J)) Q:J'=+J  D
 ..S X=Z,$E(X,21)="Mininum Age: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U),$E(X,40)="Maximum Age: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U,2),$E(X,60)="Frequency: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U,3) D S(X)
 ..Q
 .Q
 ;S X="Standard IHS Default Criteria" D S(X,2)
 ;S Y=0 F  S Y=$O(^APCHSURV(APCHHMR,81,Y)) Q:Y'=+Y  D
 ;.S Z="",$E(Z,5)="Sex:  "_$S($P(^APCHSURV(APCHHMR,81,Y,0),U)="F":"FEMALE",$P(^APCHSURV(APCHHMR,81,Y,0),U)="M":"MALE",$P(^APCHSURV(APCHHMR,81,Y,0),U)="B":"BOTH",1:"")
 ;.S J=0 F  S J=$O(^APCHSURV(APCHHMR,81,Y,11,J)) Q:J'=+J  D
 ;..S X=Z,$E(X,21)="Mininum Age: "_$P(^APCHSURV(APCHHMR,81,Y,11,J,0),U),$E(X,40)="Maximum Age: "_$P(^APCHSURV(APCHHMR,81,Y,11,J,0),U,2),$E(X,60)="Frequency: "_$P(^APCHSURV(APCHHMR,81,Y,11,J,0),U,3) D S(X)
 ;..Q
 ;.Q
 S APCHX=0 F  S APCHX=$O(^TMP("APCHHMRD",$J,APCHX)) Q:APCHX'=+APCHX  D
 .I $Y>(IOSL-4) K DIR S DIR(0)="E",DIR("A")="Press return to continue" D ^DIR K DIR W:$D(IOF) @IOF
 .W !,^TMP("APCHHMRD",$J,APCHX,0)
EDIT ;
 D ^XBFMK
 W ! S DIE="^APCHSURV(",DA=APCHHMR,DR=".03" D ^DIE
 W !! K DIR S DIR(0)="E",DIR("A")="Press return..." D ^DIR K DIR
 D EXIT
 Q
 ;
EXIT ; -- exit code
 D EN^XBVK("APCH")
 Q
 ;
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHHMRD",$J,0),U)+1,$P(^TMP("APCHHMRD",$J,0),U)=%
 S ^TMP("APCHHMRD",$J,%,0)=X
 Q
