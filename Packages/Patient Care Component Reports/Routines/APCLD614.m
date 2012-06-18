APCLD614 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
DURDM(P,R,EDATE) ;EP
 NEW DATE,EARLY
 S DATE="",EARLY=9999999
 I $G(R) S DATE=$$CMSFDX^APCLD613(P,R,"ID")
 I DATE S EARLY=DATE  ;Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 S DATE=$$PLDMDOO^APCLD613(P,"I")
 I DATE,DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 I EARLY>EDATE S EARLY=""
 I EARLY="" Q ""
 I 'EARLY Q ""
 S EARLY=$$DI^APCLD616(EARLY)
 ;W !,$$HRN^AUPNPAT(P,DUZ(2)),"^",EARLY,"^",$$D(EARLY),"^",($$FMDIFF^XLFDT(EDATE,EARLY,1)\365)
 Q ($$FMDIFF^XLFDT(EDATE,EARLY,1)\365)
 ;S DATE=$$FRSTDMDX^APCLD613(P,"I")
 ;I DATE]"" Q $S(F="I":DATE,1:$$D(DATE))
 Q ""
D(D) ;EP
 I $G(D)="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"01",1:$E(D,6,7))_"/"_$E(D,2,3)
DI(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,1,3)_$S($E(D,4,5)="00":"07",1:$E(D,4,5))_$S($E(D,6,7)="00":"01",1:$E(D,6,7))
 ;
OB(APCLPD,BMI,D) ;EP obese
 I $G(BMI)="" Q ""
 I BMI'<30 Q 1
 Q 0
 ;NEW S S S=$P(^DPT(APCLPD,0),U,2)
 ;I S="" Q ""
 ;NEW A S A=$$AGE^AUPNPAT(APCLPD,D)
 ;NEW R S R=$O(^APCLBMI("H",S,A)) I R S R=$O(^APCLBMI("H",S,R,""))
 ;I R="" Q ""
 ;I BMI>$P(^APCLBMI(R,0),U,7)!(BMI<$P(^APCLBMI(R,0),U,6)) Q ""
 ;I BMI'<$P(^APCLBMI(R,0),U,5) Q 1
 Q ""
OW(APCLPD,BMI,D) ;EP overweight
 I $G(BMI)="" Q ""
 I BMI>24.99999,BMI<29.999999 Q 1
 Q 0
 ;NEW S S S=$P(^DPT(APCLPD,0),U,2)
 ;I S="" Q ""
 ;NEW A S A=$$AGE^AUPNPAT(APCLPD,D)
 ;NEW R S R=$O(^APCLBMI("H",S,A)) I R S R=$O(^APCLBMI("H",S,R,""))
 ;I R="" Q ""
 ;I BMI>$P(^APCLBMI(R,0),U,7)!(BMI<$P(^APCLBMI(R,0),U,6)) Q ""
 ;I BMI'<$P(^APCLBMI(R,0),U,4),BMI<$P(^APCLBMI(R,0),U,5) Q 1
 Q ""
CUML ;EP
 Q:'$D(APCLCUML)
 ;print aggregate audit
 ;
 ;
PRINT ;
 ;S APCLPG=0
 S APCLQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
 W !!,$P(APCLCUML(10),U),!,?7,"Female",?53,$$C($P(APCLCUML(10),U,3)),?65,$$P($P(APCLCUML(10),U,2),$P(APCLCUML(10),U,3))
 W !,?7,"Male",?53,$$C($P(APCLCUML(10),U,4)),?65,$$P($P(APCLCUML(10),U,2),$P(APCLCUML(10),U,4))
 I $Y>(APCLIOSL-7) D HEADER Q:APCLQUIT
 W !!,"Age" S V=$G(APCLCUML(20))
 W !?7,"<15 yrs",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"15-44 yrs",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"45-64 yrs",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"65 yrs and older",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
TYPE ;
 I $Y>(APCLIOSL-6) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(25))
 W !!,$P(V,U)
 W !?7,"Type 1",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Type 2",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Unknown",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
DMDUR ;
 I $Y>(APCLIOSL-6) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(30)) W !!,$P(V,U)
 W !?7,"Less than 10 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"10 years or more",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Diagnosis date not recorded",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 ;weight control
WTCNTL ;
 I $Y>(APCLIOSL-7) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(40)) W !!,$P(V,U)
 W !?7,"Normal (BMI<25.0)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Overweight (BMI 25.0-29.9)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Obese (BMI 30.0 or above)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Height or Weight missing",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
BSC ;
 I $Y>(APCLIOSL-9) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(50)) W !!,$P(V,U)
 W !?7,"HbA1c <7.0",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HbA1c 7.0-7.9",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"HbA1c 8.0-8.9",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"HbA1c 9.0-9.9",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"HbA1c 10.0-10.9",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"HbA1c 11.0 or higher",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Undocumented",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
BPC ;
 I $Y>(APCLIOSL-9) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(60)) W !!,$P(V,U)
 W !?7,"<120/<70",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"120/70 - <130/<80",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"---------------------------"
 W !?7,"130/80 - <140/<90",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"140/90 - <160/<95",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"160/95 or higher",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"BP category Undetermined",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TOB ;
 I $Y>(APCLIOSL-7) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(80)) W !!,$P(V,U)
 W !?7,"Current Tobacco User",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"Counseled - Yes",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?9,"Counseled - No",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,3),$P(V,U,5))
 W !?7,"Not a current tobacco user",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Tobacco use not documented",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
TX ;
 I $Y>(APCLIOSL-13) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(90)) W !!,$P(V,U)
 W !?7,"Diet and Exercise Alone",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Insulin (monotherapy)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Oral Med (monotherapy)"
 W !?10,"Sulfonylurea",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?10,"Metformin",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?10,"Acarbose",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?10,"Glitazone",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Combination of Oral Meds",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
 W !?7,"Combination of Oral Meds+Insulin",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,2),$P(V,U,10))
 W !?7,"Unknown/Refused",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,2),$P(V,U,11))
 D ^APCLD61A
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0) Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
P(D,N) ;return %
 I 'D Q ""
 I 'N Q "  0%"
 NEW X S X=N/D,X=X*100,X=$J(X,3,0)
 Q X_"%"
C(X,X2,X3) ;
 I '$G(X2) S X2=0
 I '$G(X3) S X3=6
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 I $G(APCLGUI),APCLPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  HEALTH STATUS OF DIABETIC PATIENTS  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 S X="Reporting Period: "_$$FMTE^XLFDT(APCLBDAT)_" to "_$$FMTE^XLFDT(APCLADAT) W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-")
 W !!,$P(APCLCUML(10),U,2)," patients were reviewed"
 W ?55," n",?63,"Percent"
 Q
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
