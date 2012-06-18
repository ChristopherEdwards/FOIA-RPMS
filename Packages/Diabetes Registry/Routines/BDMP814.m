BDMP814 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
DURDM(P,R,EDATE) ;EP
 NEW DATE
 S DATE=""
 I $G(R) S DATE=$$CMSFDX^BDMP813(P,R,"ID")
 I DATE]"" Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 S DATE=$$PLDMDOO^BDMP813(P,"I")
 I DATE]"" Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 Q ""
D(D) ;
 I $G(D)="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"15",1:$E(D,6,7))_"/"_$E(D,2,3)
OB(BDMPD,BMI,D) ;EP obese
 I $G(BMI)="" Q ""
 NEW S S S=$P(^DPT(BDMPD,0),U,2)
 I S="" Q ""
 NEW A S A=$$AGE^AUPNPAT(BDMPD,D)
 NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 I R="" Q ""
 I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 I BMI'<$P(^BDMBMI(R,0),U,5) Q 1
 Q ""
OW(BDMPD,BMI,D) ;EP overweight
 I $G(BMI)="" Q ""
 NEW S S S=$P(^DPT(BDMPD,0),U,2)
 I S="" Q ""
 NEW A S A=$$AGE^AUPNPAT(BDMPD,D)
 NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 I R="" Q ""
 I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 I BMI'<$P(^BDMBMI(R,0),U,4) Q 1
 Q ""
CUML ;EP
 Q:'$D(BDMCUML)
 ;print aggregate audit
 ;
 ;
PRINT ;
 S BDMPG=0
 S BDMQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
 W !!,$P(BDMCUML(10),U),!,?7,"Female",?53,$$C($P(BDMCUML(10),U,3)),?65,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,3))
 W !,?7,"Male",?53,$$C($P(BDMCUML(10),U,4)),?65,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,4))
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 W !?7,"<15 yrs",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"15-44 yrs",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"45-64 yrs",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"65 yrs and older",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
TYPE ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(25))
 W !!,$P(V,U),?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 S V=$G(BDMCUML(30))
 W !!,$P(V,U),?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 S V=$G(BDMCUML(31))
 W !!,$P(V,U),?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 S V=$G(BDMCUML(32))
 W !!,$P(V,U),?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 ;weight control
WTCNTL ;
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?7,"Overweight or Obese (BMI>85%ile)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Obese (BMI>95%ile)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"BMI could not be calculated",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
BPC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 W !?7,"<120/<70",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"120/70 - 130/80",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"---------------------------"
 W !?7,"131/81 - <140/<90",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"140/90 - <160/<95",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"160/95 or higher",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"BP category Undetermined",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TOB ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!,$P(V,U)
 W !?7,"Current Tobacco User",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"Counseled - Yes",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?9,"Counseled - No",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,3),$P(V,U,5))
 W !?7,"Not a current tobacco user",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Tobacco use not documented",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
TX ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?7,"Unknown/Refused/None",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?10,"Metformin",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?10,"Acarbose",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?10,"Glitazone",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?10,"Sulfonylurea",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 D ^BDMP81A
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
 G:'BDMPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
HEADER1 ;
 I $G(BDMGUI) W !,"ZZZZZZZ"
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("***  HEALTH STATUS OF PREDIABETIC/METABOLIC SYNDROME PATIENTS  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BDMBDAT)_" to "_$$FMTE^XLFDT(BDMADAT) W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-")
 W !!,$P(BDMCUML(10),U,2)," patients were reviewed"
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
