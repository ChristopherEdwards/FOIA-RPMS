BDMDA1A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 14 Jan 2013  8:13 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**6**;JUN 14, 2007;Build 6
 ;
 ;
ACE ;
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(110)) W !!,$P(V,U)
 W !?7,"Use in the ",$$C($P(V,U,5))," pts with known hypertension*",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,5),$P(V,U,7))
 W !?7,"Use in the ",$$C($P(V,U,4))," pts with elevated",!?10,"urine albumin**",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,4),$P(V,U,8))
ASPIRIN ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(100)) W !!,$P(V,U)
 W !?7,"In the ",$$C($P(V,U,2))," pts with diagnosed CVD",!?7,"Aspirin or other Antiplatelet Rx use",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"None",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 ;
LIPID ;
 I $Y>(BDMIOSL-13) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(115)) W !!,$P(V,U)
 W !?7,"Single lipid agent",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Two or more lipid agents",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"None",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !!?7,"Of the ",+$P(V,U,13)," pts using one or more lipid agents:"
 W !?9,"Statin (simvastatin/Zocor, others)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,13),$P(V,U,6))
 W !?11,"Statin use in the ",$$C($P(V,U,16))," pts with diagnosed CVD: ",?59,$$P($P(V,U,16),$P(V,U,17)),!?59,"(n=",$$C($P(V,U,17)),")"
 W !?9,"Fibrate (gemfibrozil/Lopid, others)",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,13),$P(V,U,7))
 W !?9,"Niacin (Niaspan, OTC niacin)",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,13),$P(V,U,8))
 W !?9,"Bile Acid Sequestrant (cholestyramine/Questran,",!?11,"others)",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,13),$P(V,U,9))
 W !?9,"Ezetimibe (Zetia)",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,13),$P(V,U,10))
 W !?9,"Fish Oil - Rx or OTC",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,13),$P(V,U,11))
 W !?9,"Lovaza",?53,$$C($P(V,U,12)),?65,$$P($P(V,U,13),$P(V,U,12))
EXAMS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?7,"Foot Exam - Neuro & Vasc",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?7,"Eye Exam - Dilated or Retinal Camera",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Dental Exam",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 ;
EDUC ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?7,"Diet Instruction by any provider",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Diet Instruction by RD",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,2),$P(V,U,10)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Exercise Instruction",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 W !?7,"Other Diabetes Education",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,9))," )"
 W !?7,"Any of above Self-Management Topics",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
IMM ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U),?69,"(% refused)"
 W !?7,"Seasonal Flu Vaccine during audit period",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3)),?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?7,"Pneumovax - ever",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4)),?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?7,"Tetanus/Diptheria within past 10 years",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5)),?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 W !?7,"Hepatitis B 3-dose series complete - ever",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,2),$P(V,U,9)),?71,"( ",$$P($P(V,U,2),$P(V,U,10))," )"
DEP ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(300)) W !!,"DEPRESSION identified as an active dx"
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 S Z=$P(V,U,2)-$P(V,U,3)
 W !?7,"No",?53,$$C(Z),?65,$$P($P(V,U,2),Z)
 ;screening
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(301))
 W !!?7,"Of the ",Z," pts without an active dx"
 W !?7,"of depression, proportion screened"
 W !?7,"for depression in past year:"
 W !?13,"Screened",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?13,"Not Screened",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 ;
CREAT ;
 W !!,"LABORATORY EXAMS"
 ;
GFR ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(175)) S T=$P(V,U,5)
 W !!,"eGFR to assess kidney function obtained",!,"during audit period (Age 18 and above)",?53,$$C($P(V,U,5)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,5))
 W !,?7,">= 60 ml/min",?53,$$C($P(V,U,6)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,6))
 W !,?7,"30-59 ml/min",?53,$$C($P(V,U,7)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,7))
 W !,?7,"15-29 ml/min",?53,$$C($P(V,U,8)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,8))
 W !,?7,"< 15 ml/min",?53,$$C($P(V,U,9)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,9))
 W !,?7,"Not tested or no valid result",?53,$$C($P(V,U,10)),?65,$$P($P(BDMCUML(175),U,2),$P(V,U,10))
TOTAL ;
 ;
NONHDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(185))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"Non-HDL cholesterol obtained during audit period",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"Non-HDL <130 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"Non-HDL 130-159 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Non-HDL 160-190 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"Non-HDL >190 mg/dl",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Not tested or no valid result",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,7))
LDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"LDL Cholesterol obtained during audit period",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"LDL <100 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"LDL 100-129 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"LDL 130-160 mg/dl",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"LDL >160",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Not tested or no valid result",?53,$$C($P(V,U,7)+$P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
HDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(195))
 S T=$P(V,U,2)+$P(V,U,6)  ;TOTAL PTS
 S S=$P(V,U,3)+$P(V,U,4)+$P(V,U,7)+$P(V,U,8)
 W !!,"HDL Cholesterol obtained during audit period",?53,$$C(S),?65,$$P(T,S)
 W !,"Females"
 W !?7,"HDL =<50 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HDL >50 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Not tested or no valid result",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !!,"Males"
 W !?7,"HDL =<40 mg/dl",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,6),$P(V,U,7))
 W !?7,"HDL >40 mg/dl",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,6),$P(V,U,8))
 W !?7,"Not tested or no valid result",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,6),$P(V,U,9))
TRIG ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"Triglycerides obtained during audit period",?53,$$C(T),?65,$$P($P(V,U,2),T)
 W !?7,"TG =<400 mg/dl",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"TG >400 mg/dl",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Not tested or no valid result",?53,$$C($P(V,U,5)+$P(V,U,7)),?65,$$P($P(V,U,2),$P(V,U,5)+$P(V,U,7))
 ;
URIN ;
 I $Y>(BDMIOSL-15) D HEADER Q:BDMQUIT
 ;W !!,"LABORATORY EXAMS",!
 W !
 S V=$G(BDMCUML(145))
 W !,"Urine protein tested during audit period"
 W !?7,"Yes",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !!,"Of the ",$$C($P(V,U,3))," pts tested for urine protein:"
 W !?7,"Urine Albumin:Creatinine Ratio (UACR)",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,3),$P(V,U,6))
 W !?7,"Urine Protein:Creatinine Ratio (UPCR)",?53,$$C($P(V,U,7)),?65,$$P($P(V,U,3),$P(V,U,7))
 W !?7,"24 hr urine protein",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,3),$P(V,U,8))
 W !?7,"Microalbumin:creat strip (e.g. Clinitek)",?53,$$C($P(V,U,9)),?65,$$P($P(V,U,3),$P(V,U,9))
 W !?7,"Microalbumin only (e.g. Micral)",?53,$$C($P(V,U,10)),?65,$$P($P(V,U,3),$P(V,U,10))
 W !?7,"Standard UA dipstick protein",?53,$$C($P(V,U,11)),?65,$$P($P(V,U,3),$P(V,U,11))
 W !!?2,"Of the ",$$C($P(V,U,20))," pts with eGFR =>30, ",!?2,"percent tested with UACR",$$C($P(V,U,21)),?65,$$P($P(V,U,20),$P(V,U,21))
 ;
CVD ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(250)) W !!,$P(V,U)
 W !?7,"Diagnosed CVD",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
TBC ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !?7,"TB test +, untreated/incomplete or tx unknown",?53,$$C($P(V,U,4)),?65,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"TB test +,INH treatment complete",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 W !!?7,"TB test -, placed after DM diagnosis",?53,$$C($P(V,U,5)),?65,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"TB test -, placed before DM diagnosis",?53,$$C($P(V,U,6)),?65,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"TB test -, date of DM Dx or TB test date",!?9,"unknown",?53,$$C($P(V,U,8)),?65,$$P($P(V,U,2),$P(V,U,8))
 S X=$P(V,U,7)  ;+$P(V,U,9)
 W !?7,"TB test status unknown",?53,$$C(X),?65,$$P($P(V,U,2),X)
 ;
COMBINED ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(260)) W !!,$P(V,U)
 W !?7,"Records meeting ALL of the following",!?7,"criteria:  A1c <8.0, LDL <100, ",!?7,"and mean BP <140/90",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(270))
 W !!?7,"Records with both an eGFR and a",!?7,"quantitative urine protein test ",!?7,"(UACR, UPCR, or 24hr urine protein)",?53,$$C($P(V,U,3)),?65,$$P($P(V,U,2),$P(V,U,3))
SDM ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 W !!!,"* Known hypertension: Has hypertension listed as an active problem, or ",!,"diagnosed with hypertension."
 W !,"** Elevated urine albumin: Urine albumin measurement that meets any of the  "
 W !,"following: UACR >=30 mg/g; or UPCR >0.2 g/g; or 24-hr urine protein >300 mg/day; "
 W !,"or microalbumin: creatinine strip (Clinitek) 30-300 mg or above; or "
 W !,"microalbumin only (Micral) >20 mg/dl; or std urine protein dipstick"
 W !,"1+ or greater.",!
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
