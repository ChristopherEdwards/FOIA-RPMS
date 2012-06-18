BDMD91A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2,3**;JUN 14, 2007
 ;
 ;
ASPIRIN ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(100)) W !!,$P(V,U)
 W !?7,"Aspirin or Antiplatelet Rx",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"None",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Refused or Adverse reaction",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
ACE ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(110)) W !!,$P(V,U)
 W !?7,"Use in pts with overt proteinuria",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,4),$P(V,U,8))
 W !?7,"Use in pts with known hypertension",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,5),$P(V,U,7))
LIPID ;
 I $Y>(BDMIOSL-11) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(115)) W !!,$P(V,U)
 W !?7,"Use in pts with total chol >=240",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?7,"Use in pts with LDL chol > 100",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,5),$P(V,U,6))
 W !!?7,"Of the ",$P(V,U,7)," pts taking a lipid agent:"
 W !?9,"Statin drug prescribed",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,7),$P(V,U,8))
 W !?9,"Non-statin drug prescribed",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,7),$P(V,U,9))
 W !?9,"Statin AND non-statin prescribed",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,7),$P(V,U,10))
 W !!?7,"Refused or Adverse Reaction ",?53,$$C($P(V,U,11))
EXAMS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U),?69,"(% refused)"
 W !?7,"Foot Exam - Neuro & Vasc",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?7,"Eye Exam - Dilated",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)),?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Dental Exam",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)),?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 ;W !?7,"Pap Smear (Females Only)",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,9),$P(V,U,10)),?71,"( ",$$P($P(V,U,9),$P(V,U,11))," )"
IMM ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U),?69,"(% refused)"
 W !?7,"Flu Vaccine - yearly",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?7,"Pneumovax - once",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)),?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Tetanus/Diptheria (q 10 yrs)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)),?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
URIN ;
 I $Y>(BDMIOSL-14) D HEADER Q:BDMQUIT
 W !!,"LABORATORY EXAMS",!
 S V=$G(BDMCUML(145))
 W !,"Was urine protein testing performed"
 W !,"during audit period?"
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Refused",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !!,"Of the ",$$C($P(V,U,3))," pts tested:"
 W !?7,"Quantitative Alb:Creat Ratio",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,3),$P(V,U,6))
 W !?7,"Semi-quantitative Alb:Creat Ratio",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,3),$P(V,U,7))
 W !?7,"Protein:Creat Ratio",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,3),$P(V,U,8))
 W !?7,"Other quantitative test",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,3),$P(V,U,9))
 W !?7,"1+ protein or more on standard dipstick",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,3),$P(V,U,10))
 W !?7,"Other non-quantitative test",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,3),$P(V,U,11))
 W !!,"Of the ",($$C(($P(V,U,6)+$P(V,U,7)+$P(V,U,10))))," pts tested with an A:C ratio or"
 W !,"with 1+ protein or more on std UA dipstick:"
 S S=$P(V,U,6)+$P(V,U,7)+$P(V,U,10)
 W !?7,"Normal urine albumin",?53,$$C($P(V,U,12)),?65,$$P(S,$P(V,U,12))
 W !?7,"Microalbuminuria",?53,$$C($P(V,U,13)),?65,$$P(S,$P(V,U,13))
 W !?7,"Overt proteinuria",?53,$$C($P(V,U,14)),?65,$$P(S,$P(V,U,14))
CREAT ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(170)) S T=$P(V,U,3)+$P(V,U,4)
 W !!,"Creatinine obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Creatinine >= 2.0 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Creatinine < 2.0 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 ;W !?7,"Unable to determine result",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Creatinine not tested/unknown",?53,$$C($P(V,U,5)+$P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,5)+$P(V,U,6))
 ;
GFR ;cmi/maw 12/26/2007 DM2009
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(175)) S T=$P(V,U,5)
 W !!,"Estimated GFR documented during audit period",?53,$$C(T),?65,$$P($P(BDMCUML(175),U,2),T)
 ;
TOTAL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(180))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)
 W !!,"Total Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Desirable    (<200 mg/dl)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Borderline   (200-239 mg/dl)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"High         (240 mg/dl or more)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 ;W !?7,"Unable to determine result",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Not tested/unknown",?53,$$C($P(V,U,6)+$P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,6)+$P(V,U,7))
LDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"LDL Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"LDL <100 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"LDL 100-129 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"LDL 130-160 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"LDL >160",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 ;W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested/unknown",?53,$$C($P(V,U,7)+$P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
HDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(195))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"HDL Cholesterol obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"HDL <35 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HDL 35-45 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"HDL 46-55 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"HDL >55",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 ;W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested/unknown",?53,$$C($P(V,U,7)+$P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
TRIG ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"Triglycerides obtained in the past 12 months",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"TG <150 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"TG 150-199 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"TG 200-400 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"TG >400 mg/dl",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 ;W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Not tested/unknown",?53,$$C($P(V,U,7)+$P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
 ;
EKG ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(150)) W !!,$P(V,U)
 W !?7,"Performed in past 3 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Performed in past 5 years",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Ever performed",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
TBC ;
 I $Y>(BDMIOSL-11) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !?7,"PPD +,INH treatment complete",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"PPD +, untreated/incomplete or tx unknown",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"PPD -, placed since DM dx",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"PPD -, placed before DM dx",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 ;W !?7,"Date of DM DX Unknown",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"PPD status unknown",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"PPD -, date of Dx or PPD date unknown",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"PPD Refused",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
EDUC ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U),?69,"(% refused)"
 W !?7,"Diet Instruction by any provider",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Diet Instruction by RD",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,2),$P(V,U,10)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Exercise Instruction",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)),?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 W !?7,"Other Diabetes Education",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)),?71,"( ",$$P($P(V,U,2),$P(V,U,9))," )"
 W !?7,"Any of above Self-Management Topics",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
DEP ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(300)) W !!,"DEPRESSION identified as an active dx"
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 S Z=$P(V,U,2)-$P(V,U,3)
 W !?7,"No",?53,$$C(Z),?65,$$P($P(V,U,2),Z)
 ;screening
 I $Y>(BDMIOSL-13) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(301))
 W !!?7,"Of the ",Z," pts without an active dx"
 W !?7,"of depression, proportion screened"
 W !?7,"for depression in past year:"
 W !?13,"Screened",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?13,"Not Screened",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?13,"Refused Screening",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
SDM ;
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
 G:'BDMPG HEADER1
 W !
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI) W !,"ZZZZZZZ"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("***  HEALTH STATUS OF DIABETIC PATIENTS  ***",80),!
 W $$CTR($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U)),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BDMBDAT)_" to "_$$FMTE^XLFDT(BDMADAT) W $$CTR(X,80),!
 W !,$TR($J("",80)," ","-")
 W !!,$P(BDMCUML(10),U,2)," patients were reviewed"
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
