BDMD994 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
DURDM(P,R,EDATE,F) ;EP
 I $G(F)="" S F="E"
 NEW DATE
 S DATE=""
 I $G(R) S DATE=$$CMSFDX^BDMD997(P,R,"ID")
 I DATE]"" Q $S(F="I":DATE,1:$$D(DATE))
 S DATE=$$PLDMDOO^BDMD997(P,"I")
 I DATE]"" Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 ;S DATE=$$FRSTDMDX^BDMD997(P,"I")
 ;I DATE]"" Q $S(F="I":DATE,1:$$D(DATE))
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
 I $Y>(IOSL-4) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 W !?7,"<15 yrs",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"15-44 yrs",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"45-64 yrs",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"65 yrs and older",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
DMDUR ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(30)) W !!,$P(V,U)
 W !?7,"Less than 10 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"10 years or more",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Diagnosis date not recorded",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 ;weight control
WTCNTL ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?7,"Overweight (BMI>85%ile)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Obese (BMI>95%ile)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"BMI could not be calculated",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
BSC ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(50)) W !!,$P(V,U)
 W !?7,"HbA1c <7.0",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HbA1c 7.0-7.9",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"HbA1c 8.0-8.9",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"HbA1c 9.0-9.9",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"HbA1c 10.0-10.9",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"HbA1c 11.0 or higher",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Undocumented",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
BPC ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 W !?7,"Ideal BP Control (<120/<80)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Target   (120/80-<130/<85)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Adequate   (130/85-<140/,90)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Inadequate  (140/90-<160/<95)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Markedly Poor   (160/95 or higher)",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"BP Control Undetermined",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TBC ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !?7,"PPD +,INH treatment complete",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"PPD +, untreated/incomplete or tx unknown",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"PPD -, placed since DM dx",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"PPD -, placed before DM dx",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Date of DM DX Unknown",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"PPD status unknown",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TOB ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!,$P(V,U)
 W !?7,"Uses Tobacco",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"Counseled - Yes",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,3),$P(V,U,4))
 W !?9,"Counseled - No",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,3),$P(V,U,5))
 W !?7,"Does not Use tobacco",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Used tobacco in past",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Tobacco use not documented",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TX ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?7,"Diet and Exercise Alone",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Insulin",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Oral Med (monotherapy)"
 W !?10,"Sulfonylurea",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?10,"Metformin",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?10,"Acarbose",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?10,"Glitazone",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"Combination of Oral Meds",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9))
 W !?7,"Combination of Oral Meds+Insulin",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,2),$P(V,U,10))
 W !?10,"Refused or Undetermined",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,2),$P(V,U,11))
ASPIRIN ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(100)) W !!,$P(V,U)
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Undetermined",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
EXAMS ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U),?68,"(% refused)"
 W !?7,"Foot Exam - Neuro & Vasc",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?70,"(",$$P($P(V,U,2),$P(V,U,6)),")"
 W !?7,"Eye Exam - Dilated",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Dental Exam",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
EDUC ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U)
 W !?7,"Diet Instruction",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Exercise Instruction",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Other Diabetes Education",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
IMM ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U)
 W !?7,"Flu Vaccine - yearly",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Pneumovax - once",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Tetanus/Diptheria (1 10 years)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
EKG ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(150)) W !!,$P(V,U)
 W !?7,"Performed in past 3 years",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Performed in past 5 years",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Ever performed",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
CREAT ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(170)) W !!,$P(V,U)
 W !?7,"Creatinine >= 2.0 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Creatinine < 2.0 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Creatinine not tested/unknown",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
TOTAL ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(180)) W !!,$P(V,U)
 W !?7,"Desirable    (<200 mg/dl)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Borderline   (200-239 mg/dl)",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"High         (240 mg/dl or more)",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Not tested",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
LDL ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190)) W !!,$P(V,U)
 W !?7,"LDL <100 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"LDL 100-129 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"LDL 130-160 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"LDL >160",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
TRIG ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200)) W !!,$P(V,U)
 W !?7,"TG <150 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"TG 150-199 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"TG 200-400 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"TG >400 mg/dl",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Not tested",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
 W !?7,"Unable to determine result",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
SELF ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(210)) W !!,$P(V,U)
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Refused",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
SDM ;
 I $Y>(IOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(220)) W !!,$P(V,U)
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Undetermined",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
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
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("***  HEALTH STATUS OF DIABETIC PATIENTS  ***",80),!
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
