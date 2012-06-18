BDMD014 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 22 Feb 2010  3:43 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3**;JUN 14, 2007
 ;
 ;
DURDM(P,R,EDATE) ;EP
 NEW DATE,EARLY
 S DATE="",EARLY=9999999
 I $G(R) S DATE=$$CMSFDX^BDMD013(P,R,"ID")
 I DATE S EARLY=DATE  ;Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 S DATE=$$PLDMDOO^BDMD013(P,"I")
 I DATE,DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 ;I EARLY>EDATE S EARLY=""
 I EARLY="" Q ""
 I 'EARLY Q ""
 S EARLY=$$DI^BDMD016(EARLY)
 ;W !,$$HRN^AUPNPAT(P,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),"^",EARLY,"^",$$D(EARLY),"^",($$FMDIFF^XLFDT(EDATE,EARLY,1)\365)
 Q ($$FMDIFF^XLFDT(EDATE,EARLY,1)\365.25)
D(D) ;EP
 I $G(D)="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"01",1:$E(D,6,7))_"/"_$E(D,2,3)
DI(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,1,3)_$S($E(D,4,5)="00":"07",1:$E(D,4,5))_$S($E(D,6,7)="00":"01",1:$E(D,6,7))
 ;
OB(BDMPD,BMI,D) ;EP obese
 I $G(BMI)="" Q ""
 I BMI'<30 Q 1
 Q 0
 ;NEW S S S=$P(^DPT(BDMPD,0),U,2)
 ;I S="" Q ""
 ;NEW A S A=$$AGE^AUPNPAT(BDMPD,D)
 ;NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 ;I R="" Q ""
 ;I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 ;I BMI'<$P(^BDMBMI(R,0),U,5) Q 1
 Q ""
OW(BDMPD,BMI,D) ;EP overweight
 I $G(BMI)="" Q ""
 I $G(BMI)<25 Q ""
 I BMI<30 Q 1
 Q ""
 ;NEW S S S=$P(^DPT(BDMPD,0),U,2)
 ;I S="" Q ""
 ;NEW A S A=$$AGE^AUPNPAT(BDMPD,D)
 ;NEW R S R=$O(^BDMBMI("H",S,A)) I R S R=$O(^BDMBMI("H",S,R,""))
 ;I R="" Q ""
 ;I BMI>$P(^BDMBMI(R,0),U,7)!(BMI<$P(^BDMBMI(R,0),U,6)) Q ""
 ;I BMI'<$P(^BDMBMI(R,0),U,4),BMI<$P(^BDMBMI(R,0),U,5) Q 1
 Q ""
CUML ;EP
 Q:'$D(BDMCUML)
 ;print aggregate audit
 ;
 ;
PRINT ;
 ;S BDMPG=0
 S BDMQUIT=0
 D HEADER
 D PRINT1 ;print each indicator
 D EXIT
 Q
 ;
PRINT1 ;
 I BDMNOGO D
 .W !!,"*** Please NOTE:  ",BDMNOGO," Patients were not included in this cumulative audit",!,"because their date of onset was after the audit date.",!
 W !!,$P(BDMCUML(10),U),!,?7,"Female",?53,$$C($P(BDMCUML(10),U,3)),?65,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,3))
 W !,?7,"Male",?53,$$C($P(BDMCUML(10),U,4)),?65,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,4))
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 W !?7,"<15 yrs",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"15-44 yrs",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"45-64 yrs",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"65 yrs and older",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
TYPE ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(25))
 W !!,$P(V,U)
 W !?7,"Type 1",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Type 2",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 ;W !?7,"Unknown",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
DMDUR ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(30)) W !!,$P(V,U)
 W !?7,"Less than 1 year",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Less than 10 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"10 years or more",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Diagnosis date not recorded",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 ;weight control
WTCNTL ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?7,"Normal (BMI<25.0)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Overweight (BMI 25.0-29.9)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Obese (BMI 30.0 or above)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Height or Weight missing",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
BSC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(50)) W !!,$P(V,U)
 W !?7,"HbA1c <7.0",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HbA1c 7.0-7.9",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"HbA1c 8.0-8.9",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"HbA1c 9.0-9.9",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"HbA1c 10.0-10.9",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"HbA1c 11.0 or higher",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Undocumented",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
BPC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 W !?7,"<120/<70",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"120/70 - <130/<80",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"---------------------------"
 W !?7,"130/80 - <140/<90",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"140/90 - <160/<95",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"160/95 or higher",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"BP category Undetermined",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TOB ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!,$P(V,U)
 W !?7,"Current Tobacco User",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"Counseled - Yes",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?9,"Counseled - No",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,3),$P(V,U,5))
 W !?9,"Counseled - Refused",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,3),$P(V,U,6))  ;cmi/maw 12/26/2007 DM2010
 W !?7,"Not a current tobacco user",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Tobacco use not documented",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TX ;
 I $Y>(BDMIOSL-14) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?7,"Diet and Exercise Alone",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Insulin",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Sulfonylurea",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Sulfonylurea-like (Prandin, Starlix)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Metformin",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Acarbose/Miglitol",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Glitizone",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
 W !?7,"Incretin mimetics (Byetta)",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,2),$P(V,U,10))  ;cmi/maw 12/26/2007 DM2010
 W !?7,"DPP4 inhibitors (Januvia, Onglyza)",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,2),$P(V,U,11))
 W !?7,"Amylin analogues (Symlin)",?53,$$C($P(V,U,12)),?65,$$P($P(V,U,2),$P(V,U,12))
 W !!?7,"Any Oral med combination",?53,$$C($P(V,U,14)),?65,$$P($P(V,U,2),$P(V,U,14))
 W !?7,"Any Insulin + other med combination",?53,$$C($P(V,U,15)),?65,$$P($P(V,U,2),$P(V,U,15))
 W !!?7,"Refused or Undetermined",?53,$$C($P(V,U,13)),?65,$$P($P(V,U,2),$P(V,U,13))
 D ^BDMD01A
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
 W !
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("***  HEALTH STATUS OF DIABETIC PATIENTS (2010 AUDIT)  ***",80),!
 W $$CTR($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U)),!
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
