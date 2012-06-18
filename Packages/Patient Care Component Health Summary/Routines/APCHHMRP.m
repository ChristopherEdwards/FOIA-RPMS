APCHHMRP ; IHS/CMI/LAB - DISPLAY HEALTH MAINTENANCE REMINDER ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;; ;
EP ;EP - called from option to select and display a hmr
 W !!,"This option will display or print the description/logic of all Health",!,"Summary Maintenance Reminders.",!!
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="PROCESS^APCHHMRP",XBRP="PRINT^APCHHMRP",XBRX="XIT^APCHHMRP",XBNS="APCH"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 K J,K,X,Z,Y
 D EN^XBVK("APCH")
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCHHMRP"")"
 S XBNS="APCH",XBRC="PROCESS^APCHHMRP",XBRX="XIT^APCHHMRP",XBIOP=0 D ^XBDBQUE
 Q
 ;
PROCESS ; -- init variables and list array
 S APCHJ=$J,APCHH=$H
 S ^XTMP("APCHHMRP",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC DATA ENTRY LAB REPORT"
 K ^XTMP("APCHHMRP",APCHJ,APCHH)
 S ^XTMP("APCHHMRP",APCHJ,APCHH,0)=0
 S APCHN="",APCHHMR=0 F  S APCHN=$O(^APCHSURV("B",APCHN)) Q:APCHN=""  S APCHHMR=0 F  S APCHHMR=$O(^APCHSURV("B",APCHN,APCHHMR)) Q:APCHHMR'=+APCHHMR  D PROCESS1
 K ^XTMP("APCHHMRP",APCHJ,APCHH,0)
 Q
PROCESS1 ;
 Q:$P(^APCHSURV(APCHHMR,0),U,3)="D"
 Q:$P(^APCHSURV(APCHHMR,0),U,7)'="R"
 ;gather up reminder for display
 S X="",X="Reminder:",$E(X,20)=$P(^APCHSURV(APCHHMR,0),U) D S(X,1)
 ;S X="",X="Status:",$E(X,20)=$$VAL^XBDIQ1(9001018,APCHHMR,.03) D S(X)
 S X="",X="Category:",$E(X,20)=$$VAL^XBDIQ1(9001018,APCHHMR,.05) D S(X)
 S X="Description:" D S(X,1)
 S Y=0 F  S Y=$O(^APCHSURV(APCHHMR,1,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHHMR,1,Y,0) D S(X)
 ;S X="Currently Defined Criteria in Use at this Facility:" D S(X,1)
 ;S Y=0 F  S Y=$O(^APCHSURV(APCHHMR,11,Y)) Q:Y'=+Y  D
 ;.S Z="",$E(Z,5)="Sex:  "_$S($P(^APCHSURV(APCHHMR,11,Y,0),U)="F":"FEMALE",$P(^APCHSURV(APCHHMR,11,Y,0),U)="M":"MALE",$P(^APCHSURV(APCHHMR,11,Y,0),U)="B":"BOTH",1:"")
 ;.S J=0 F  S J=$O(^APCHSURV(APCHHMR,11,Y,11,J)) Q:J'=+J  D
 ;..S X=Z,$E(X,21)="Mininum Age: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U),$E(X,40)="Maximum Age: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U,2),$E(X,60)="Frequency: "_$P(^APCHSURV(APCHHMR,11,Y,11,J,0),U,3) D S(X)
 ;..Q
 ;S X="Currently defined on the following summary types:" D S(X,1)
 ;S J=0 F  S J=$O(^APCHSCTL(J)) Q:J'=+J  D
 ;.S K=0 F  S K=$O(^APCHSCTL(J,5,K)) Q:K'=+K  I $P(^APCHSCTL(J,5,K,0),U,2)=APCHHMR S X="",$E(X,15)=$P(^APCHSCTL(J,0),U) D S(X)
 ;.Q
 S X=$TR($J("",80)," ","*") D S(X,2)
 Q
 ;
 ;
PRINT ;EP - called from xbdbque
 S APCHPG=0,APCHQ=0 D HEAD
 S APCHX=0 F  S APCHX=$O(^XTMP("APCHHMRP",APCHJ,APCHH,APCHX)) Q:APCHX'=+APCHX!(APCHQ)  D
 .I $Y>(IOSL-3) D HEAD Q:APCHQ
 .W !,^XTMP("APCHHMRP",APCHJ,APCHH,APCHX)
 .Q
 K ^XTMP("APCHHMRP",APCHJ,APCHH),APCHJ,APCHH
 Q
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
 S %=$P(^XTMP("APCHHMRP",APCHJ,APCHH,0),U)+1,$P(^XTMP("APCHHMRP",APCHJ,APCHH,0),U)=%
 S ^XTMP("APCHHMRP",APCHJ,APCHH,%)=X
 Q
HEAD I 'APCHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ=1 Q
HEAD1 ;
 W:$D(IOF) @IOF S APCHPG=APCHPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",APCHPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("HEALTH SUMMARY HEALTH MAINTENANCE REMINDERS",80),!
 W !,$TR($J("",80)," ","-")
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
