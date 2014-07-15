BDMDB1A ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 14 Jan 2014  8:13 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**7**;JUN 14, 2007;Build 24
 ;
 ;
ACE ;
 I $Y>(BDMIOSL-5) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(110)) W !!,$P(V,U)
 W !?5,"In patients with known hypertension*",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,5)),?73,$$P($P(V,U,5),$P(V,U,7))
 W !?5,"In patients with increased",!?10,"urine albumin excretion**",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,4)),?73,$$P($P(V,U,4),$P(V,U,8))
ASPIRIN ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(100)) W !!,$P(V,U)
 W !?5,"In the ",$P(V,U,2)," patients with diagnosed CVD",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 ;W !?5,"None",?49,$$C($P(V,U,4)),?73,$$P($P(V,U,2),$P(V,U,4))
 ;
LIPID ;
 I $Y>(BDMIOSL-13) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(115)) W !!,$P(V,U)
 W !?5,"Single lipid agent",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"Two or more lipid agents",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"None",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !!?5,"In patients prescribed one or more lipid agents:"
 W !?9,"Statin (simvastatin/Zocor, others)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,6))
 W !?11,"Statin prescribed in patients ",!?11,"with diagnosed CVD: ",?49,$$C($P(V,U,17)),?61,$$C($P(V,U,16)),?73,$$P($P(V,U,16),$P(V,U,17)) ;,!?59,"(n=",$$C($P(V,U,17)),")"
 W !?9,"Fibrate (gemfibrozil/Lopid, others)",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,7))
 W !?9,"Niacin (Niaspan, OTC niacin)",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,8))
 W !?9,"Bile Acid Sequestrant (cholestyramine/",!?11,"Questran, others)",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,9))
 W !?9,"Ezetimibe (Zetia)",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,10))
 W !?9,"Fish Oil",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,11))
 W !?9,"Lovaza",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,12))
EXAMS ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(120)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?5,"Foot Exam - Neuro & Vasc",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,6))," )"
 W !?5,"Eye Exam - Dilated or Retinal Camera",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?5,"Dental Exam",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 ;
EDUC ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(130)) W !!,$P(V,U) ;,?69,"(% refused)"
 W !?5,"Nutritional - by any provider",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?5,"Nutritional - by RD",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,7))," )"
 W !?5,"Physical Activity",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,8))," )"
 W !?5,"Other",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)) ;,?71,"( ",$$P($P(V,U,2),$P(V,U,9))," )"
 W !?5,"Any of above topics",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
IMM ;
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(140)) W !!,$P(V,U)
 W !?5,"Flu Vaccine during audit period",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?11,"Refused - Flu Vaccine",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Pneumovax - ever",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?11,"Refused - Pneumovax",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?5,"Tetanus/Diptheria - past 10 years",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?11,"Refused - Tetanus/Diptheria",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?5,"Hepatitis B 3-dose series complete - ever",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9))
 W !?11,"Refused - Hepatitis B",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10))
DEP ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(300)) W !!,"Depression An Active Problem"
 W !?5,"Yes",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 S Z=$P(V,U,2)-$P(V,U,3)
 W !?5,"No",?49,$$C(Z),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),Z)
 ;screening
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(301))
 W !!?5,"In patients without active depression, screened"
 W !?5,"for depression during the audit period:"
 W !?13,"Screened",?49,$$C($P(V,U,3)),?61,$$C(Z),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?13,"Not Screened",?49,$$C($P(V,U,4)),?61,$$C(Z),?73,$$P($P(V,U,2),$P(V,U,4))
 ;
CREAT ;
 W !!,"Laboratory Exams"
 ;
GFR ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(175)) S T=$P(V,U,5)
 W !!,"eGFR to assess kidney function",!,"(In age 18 and above)",?49,$$C($P(V,U,5)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,5))
 W !,?7,"eGFR >= 60 ml/min",?49,$$C($P(V,U,6)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,6))
 W !,?7,"eGFR 30-59 ml/min",?49,$$C($P(V,U,7)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,7))
 W !,?7,"eGFR 15-29 ml/min",?49,$$C($P(V,U,8)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,8))
 W !,?7,"eGFR < 15 ml/min",?49,$$C($P(V,U,9)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,9))
 W !,?7,"eGFR Not tested or no valid result",?49,$$C($P(V,U,10)),?61,$$C($P(BDMCUML(175),U,2)),?73,$$P($P(BDMCUML(175),U,2),$P(V,U,10))
TOTAL ;
 ;
NONHDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(185))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"Non-HDL cholesterol",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?5,"Non-HDL <130 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"Non-HDL 130-159 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Non-HDL 160-190 mg/dl",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"Non-HDL >190 mg/dl",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
LDL ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(190))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"LDL cholesterol",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?5,"LDL <100 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"LDL 100-129 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"LDL 130-160 mg/dl",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"LDL >160",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,7)+$P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7)+$P(V,U,8))
HDL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(195))
 S T=$P(V,U,2)+$P(V,U,6)  ;TOTAL PTS
 S S=$P(V,U,3)+$P(V,U,4)+$P(V,U,7)+$P(V,U,8)
 W !!,"HDL cholesterol",?49,$$C(S),?61,$$C(T),?73,$$P(T,S)
 W !?3,"In females"
 W !?5,"HDL =<50 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"HDL >50 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !!?3,"In males"
 W !?5,"HDL =<40 mg/dl",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7))
 W !?5,"HDL >40 mg/dl",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,8))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,9))
TRIG ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(200))
 S T=$P(V,U,3)+$P(V,U,4)+$P(V,U,5)+$P(V,U,6)
 W !!,"Triglycerides",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?5,"TG =<400 mg/dl",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"TG >400 mg/dl",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,5)+$P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)+$P(V,U,7))
 ;
URIN ;
 I $Y>(BDMIOSL-15) D HEADER Q:BDMQUIT
 ;W !!,"LABORATORY EXAMS",!
 W !
 S V=$G(BDMCUML(145))
 W !,"Urine Albumin:Creatinine Ratio (UACR)"
 W !?5,"Yes",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"No",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !!,"In ",$P(V,U,3)," patients with UACR:"
 W !?5,"Urine albumin excretion - Normal <30 mg/g",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,12))
 W !?5,"Urine albumin excretion - Increased",!?9,"30-300 mg/g",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,13))
 W !?9,">300 mg/g",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,14))
 W !!?2,"In patients age 18 and above ",!?11,"with eGFR =>30, UACR done",?49,$$C($P(V,U,21)),?61,$$C($P(V,U,20)),?73,$$P($P(V,U,20),$P(V,U,21))
 ;
CVD ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(250)) W !!,$P(V,U)
 W !?5,"Diagnosed CVD",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
TBC ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(70)) W !!,$P(V,U)
 W !?5,"TB test +, untreated or tx unknown",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"TB test +,INH treatment complete",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !!?5,"TB test -, placed after DM diagnosis",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"TB test -, placed before DM diagnosis",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"TB test -, date of DM Dx or TB test date",!?9,"unknown",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 S X=$P(V,U,7)  ;+$P(V,U,9)
 W !?5,"TB test status unknown",?49,$$C(X),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),X)
 ;
COMBINED ;
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(260)) W !!,$P(V,U)
 W !?5,"Records meeting ALL of the following",!?5,"criteria:  A1c <8.0, LDL <100, ",!?5,"and mean BP <140/<90",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 I $Y>(BDMIOSL-4) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(270))
 W !!?5,"In age 18 and above, records with",!?5,"both an eGFR and a UACR",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
SDM ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 W !!!,"* Known hypertension: Has hypertension listed as an active problem, or ",!,"three visits with a diagnosis of hypertension ever (prior to the end ",!,"of the Audit period)."
 W !,"** Increased urine albumin excretion: UACR =>30 mg/g."
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
 D HEADER^BDMDB14
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - 
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
