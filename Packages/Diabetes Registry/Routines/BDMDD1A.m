BDMDD1A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 22 Sep 2015  9:47 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
ACE ;
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(110)) W !!,$P(V,U)
 W !?3,"In patients with known hypertension**",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,5)),?73,$$P($P(V,U,5),$P(V,U,7))
 W !?3,"In patients age 18+ with CKD*",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,4)),?73,$$P($P(V,U,4),$P(V,U,8))  ;,!?10,"urine albumin excretion**"
ASPIRIN ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(100)) W !!,$P(V,U)
 W !?3,"In patients with diagnosed CVD",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 ;
STATIN ;
 I $Y>(BDMIOSL-18) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(115)) W !!,$P(V,U)
 W !?3,"Yes",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,4)),?73,$$P($P(V,U,4),$P(V,U,6))
 W !?3,"Allergy, intolerance, or contraindication",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !!?3,"In patients with diagnosed CVD: "
 W !?6,"Yes",?49,$$C($P(V,U,22)),?61,$$C($P(V,U,21)),?73,$$P($P(V,U,21),$P(V,U,22))
 W !?6,"Allergy, intolerance, or contraindication",?49,$$C($P(V,U,17)),?61,$$C($P(V,U,16)),?73,$$P($P(V,U,16),$P(V,U,17))
 W !!?3,"In patients aged 40-75: "
 W !?6,"Yes",?49,$$C($P(V,U,19)),?61,$$C($P(V,U,8)),?73,$$P($P(V,U,8),$P(V,U,19))
 W !?6,"Allergy, intolerance, or contraindication",?49,$$C($P(V,U,20)),?61,$$C($P(V,U,23)),?73,$$P($P(V,U,23),$P(V,U,20))
 W !!?3,"In patients with diagnosed CVD and/or aged 40-75:"
 W !?6,"Yes",?49,$$C($P(V,U,26)),?61,$$C($P(V,U,25)),?73,$$P($P(V,U,25),$P(V,U,26))
 W !?6,"Allergy, intolerance, or contraindication",?49,$$C($P(V,U,27)),?61,$$C($P(V,U,24)),?73,$$P($P(V,U,24),$P(V,U,27))
EXAMS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?3,"Foot exam - comprehensive",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?3,"Eye exam - dilated or retinal imaging",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?3,"Dental exam",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 ;
EDUC ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?3,"Nutrition - by any provider",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?3,"Nutrition - by RD",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?3,"Physical activity",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 W !?3,"Other",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,9))," )"
 W !?3,"Any of above topics",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
IMM ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U)
 W !?3,"Influenza vaccine during Audit period",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?11,"Refused - Influenza vaccine",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"Pneumococcal vaccine - ever",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?11,"Refused - Pneumococcal",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?3,"Td/Tdap/DT - past 10 years",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?11,"Refused - Td/Tdap/DT",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?3,"Tdap - ever",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,12))
 W !?11,"Refused - Tdap",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,13))
 S C=$P(V,U,2)-$P(V,U,11)
 W !?3,"Hepatitis B 3-dose series complete - ever",?49,$$C($P(V,U,9)),?61,$$C(C),?73,$$P(C,$P(V,U,9))
 W !?11,"Refused - Hepatitis B",?49,$$C($P(V,U,10)),?61,$$C(C),?73,$$P(C,$P(V,U,10))
 W !?11,"Immune - Hepatitis B",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,11))
DEP ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(300)) W !!,"Depression An Active Problem"
 W !?3,"Yes",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 S Z=$P(V,U,2)-$P(V,U,3)
 W !?3,"No",?49,$$C(Z),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),Z)
 ;screening
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(301))
 W !!?3,"In patients without active depression, screened"
 W !?3,"for depression during the audit period:"
 W !?13,"Screened",?49,$$C($P(V,U,3)),?61,$$C(Z),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?13,"Not screened",?49,$$C($P(V,U,4)),?61,$$C(Z),?73,$$P($P(V,U,2),$P(V,U,4))
 ;
LIPID ;
 I $Y>(BDMIOSL-2) D HEADER Q:BDMQUIT
 W !!,"Lipid Evaluation - Note these results are presented as population level CVD"
 W !,"risk markers and should not be considered treatment targets for individual"
 W !,"patients."
 ;
LDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!?3,"LDL cholesterol",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?7,"LDL <100 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"LDL 100-129 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"LDL 130-189 mg/dl",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?7,"LDL >=190",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?7,"Not tested or no valid result",?49,$$C($P(V,U,7)+$P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
HDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(195))
 S T=$P(V,U,2)+$P(V,U,6)  ;TOTAL PTS
 S S=$P(V,U,3)+$P(V,U,4)+$P(V,U,7)+$P(V,U,8)
 W !!?3,"HDL cholesterol",?49,$$C(S),?61,$$C(T),?73,$$P(T,S)
 W !?7,"In females"
 W !?7,"HDL <50 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"HDL >=50 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Not tested or no valid result",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !!?7,"In males"
 W !?7,"HDL <40 mg/dl",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7))
 W !?7,"HDL >=40 mg/dl",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,8))
 W !?7,"Not tested or no valid result",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,9))
TRIG ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,8)
 W !!?3,"Triglycerides***",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?7,"TG <150 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"TG 150-999 mg/dl",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?7,"TG >1000 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?7,"Not tested or no valid result",?49,$$C($P(V,U,5)+$P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)+$P(V,U,7))
 ;
GFR ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(175)) S T=$P(V,U,5)
 W !!,"Kidney Evaluation"
 W !?3,"eGFR to assess kidney function",?49,$$C($P(V,U,5)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,5)),!?3,"(In age 18 and above)"
 W !,?7,"eGFR >= 60 ml/min",?49,$$C($P(V,U,6)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,6))
 W !,?7,"eGFR 30-59 ml/min",?49,$$C($P(V,U,7)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,7))
 W !,?7,"eGFR 15-29 ml/min",?49,$$C($P(V,U,8)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,8))
 W !,?7,"eGFR < 15 ml/min",?49,$$C($P(V,U,9)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,9))
 W !,?7,"eGFR Not tested or no valid result",?49,$$C($P(V,U,10)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,10))
URIN ;
 I $Y>(BDMIOSL-15) D HEADER Q:BDMQUIT
 W !
 S V=$G(BDMCUML(145))
 W !?3,"Urine Albumin:Creatinine Ratio (UACR) to assess kidney damage"
 W !?7,"Yes",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?7,"No",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !!?3,"In patients with UACR:"
 W !?7,"Urine albumin excretion - Normal <30 mg/g",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,12))
 W !?7,"Urine albumin excretion - Increased",!?10,"30-300 mg/g",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,13))
 W !?10,">300 mg/g",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,14))
 W !!?3,"In patients age 18 and above ",!?10,"with eGFR =>30, UACR done",?49,$$C($P(V,U,21)),?61,$$C($P(V,U,20)),?73,$$P($P(V,U,20),$P(V,U,21))
 ;
CVD ;
 ;I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 ;S V=$G(BDMCUML(250)) W !!,$P(V,U)
 ;W !?3,"Diagnosed CVD",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
TBC ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !!?3,"TB Test done (skin or blood)",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?6,"If test done, skin test",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,4))
 W !?6,"If test done, blood test",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,5))
 W !?3,"If TB test done, positive result",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,6))
 W !?3,"If positive TB test, treatment",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7)),!?6,"completed"
 W !?3,"If negative TB test, test done after",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,9)),?73,$$P($P(V,U,9),$P(V,U,8)),!?6,"DM diagnosis"
 ;
COMBINED ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(260)) W !!,$P(V,U)
 W !?3,"Patients age >= 40 meeting ALL of the ",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)),!?3,"following criteria:  A1C <8.0, Statin prescribed, ",!?3,"and mean BP <140/<90"
 ;I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 ;S V=$G(BDMCUML(270))
 ;W !!?3,"In age 18 and above, patients with",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)),!?3,"both an eGFR and a UACR"
SDM ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 W !!!,"* CKD: eGFR <60 or uACR =>30"
 W !,"** Known hypertension: Has hypertension listed as an active problem, or ",!,"three visits with a diagnosis of hypertension ever (prior to the end ",!,"of the Audit period)."
 W !,"*** For triglycerides: >150 is a marker of CVD risk, not a treatment",!,"target; >1000 is a risk marker for pancreatitis."
 w !,"**** Comorbid conditions counted are: active depression, current tobacco use,",!,"severely obese (BMI 40 or higher), diagnosed hypertension, diagnosed CVD,",!,"and CKD (eGFR<60 or uACR=>30).",!
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
 D HEADER^BDMDD14
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - 
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
