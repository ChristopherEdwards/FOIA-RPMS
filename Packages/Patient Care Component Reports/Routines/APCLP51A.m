APCLP51A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
ASPIRIN ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(100)) W !!,$P(V,U)
 W !?7,"Aspirin",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Other Anti-platelet Rx",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Both ASA & Other Rx",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"None",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Refused",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
ACE ;
 I $Y>(IOSL-6) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(110)) W !!,$P(V,U)
LIPID ;
 I $Y>(IOSL-9) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(115)) W !!,$P(V,U)
 W !?7,"Use in pts with total chol >=240",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?7,"Use in pts with LDL chol > 100",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,5),$P(V,U,6))
 W !!?7,"Of the ",$P(V,U,7)," pts taking a lipid agent:"
 W !?9,"Statin drug prescribed:",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,7),$P(V,U,8))
 W !?9,"Non-statin drug prescribed:",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,7),$P(V,U,9))
 W !?9,"Statin AND non-statin prescribed:",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,7),$P(V,U,10))
EDUC ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(130)) W !!,$P(V,U),?69,"(% refused)"
 W !?7,"Diet Instruction",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Exercise Instruction",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)),?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
FAST ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(600))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)+$P(V,U,8)
 W !!,$P(V,U),?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
G75 ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(610))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)+$P(V,U,8)
 W !!,$P(V,U),?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
TOTAL ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(180))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,7)
 W !!,"Total Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Desirable    (<200 mg/dl)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Borderline   (200-239 mg/dl)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"High         (240 mg/dl or more)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Not tested",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
LDL ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)+$P(V,U,8)
 W !!,"LDL Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"LDL <100 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"LDL 100-129 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"LDL 130-160 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"LDL >160",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
HDL ;
 I $Y>(IOSL-8) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(195))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)+$P(V,U,8)
 W !!,"HDL Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"HDL <35 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HDL 35-45 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"HDL 46-55 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"HDL >55",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
TRIG ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)+$P(V,U,8)
 W !!,"Triglycerides obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"TG <150 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"TG 150-199 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"TG 200-400 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"TG >400 mg/dl",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 ;
EKG ;
 I $Y>(IOSL-5) D HEADER Q:APCLQUIT
 S V=$G(APCLCUML(150)) W !!,$P(V,U)
 W !?7,"Performed in past 3 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Performed in past 5 years",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Ever performed",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 Q
EXIT ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO",DIR("A")="End of report.  Press ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALC(N,O) ;ENTRY POINT
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
USR() ;EP - 
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
