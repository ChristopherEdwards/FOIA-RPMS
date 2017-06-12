BDMDD14 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 14 Oct 2014  9:54 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
DURDM(P,R,EDATE) ;EP
 NEW DATE,EARLY
 S DATE="",EARLY=9999999
 I $G(R) S DATE=$$CMSFDX^BDMDD13(P,R,"ID")
 I DATE S EARLY=DATE  ;Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 S DATE=$$PLDMDOO^BDMDD13(P,"I")
 I DATE,DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 ;I EARLY>EDATE S EARLY=""
 I EARLY="" Q ""
 I 'EARLY Q ""
 S EARLY=$$DI^BDMDD16(EARLY)
 ;W !,$$HRN^AUPNPAT(P,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),"^",EARLY,"^",$$D(EARLY),"^",($$FMDIFF^XLFDT(EDATE,EARLY,1)\365)
 Q ($$FMDIFF^XLFDT(EDATE,EARLY,1)\365)
D(D) ;EP
 I $G(D)="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"01",1:$E(D,6,7))_"/"_$E(D,2,3)
DI(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,1,3)_$S($E(D,4,5)="00":"07",1:$E(D,4,5))_$S($E(D,6,7)="00":"01",1:$E(D,6,7))
 ;
SOB(BDMPD,BMI,D) ;EP severly obese
 I $G(BMI)="" Q ""
 I +BMI'<40 Q 1
 Q 0
OB(BDMPD,BMI,D) ;EP obese
 I $G(BMI)="" Q ""
 I +BMI'<30 Q 1
 Q 0
OW(BDMPD,BMI,D) ;EP overweight
 I $G(BMI)="" Q ""
 I $G(BMI)<25 Q ""
 I BMI<30 Q 1
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
 W !,$P(BDMCUML(10),U),!?3,"Male",?49,$$C($P(BDMCUML(10),U,4)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,4))
 W !?3,"Female",?49,$$C($P(BDMCUML(10),U,3)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,3))
 ;W !?3,"Unknown",?49,$$C($P(BDMCUML(10),U,5)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,5))
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 ;S V="^4567^1234^345^987^12000"
 W !?3,"<20 years",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"20-44 years",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"45-64 years",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"65 years and older",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
TYPE ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(25))
 W !!,$P(V,U)
 W !?3,"Type 1",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Type 2",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
DMDUR ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(30)) W !!,$P(V,U)
 W !?3,"Less than 1 year",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"Less than 10 years",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"10 years or more",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Diagnosis date not recorded",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 ;weight control
WTCNTL ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?3,"Normal (BMI<25.0)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"Overweight (BMI 25.0-29.9)",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Obese (BMI 30.0 or above)",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Height or Weight missing",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"----------------------------------"
 W !?3,"Severely Obese (BMI 40.0 or above)",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
BSC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(50)) W !!,$P(V,U)
 W !?3,"A1C <7.0",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"A1C 7.0-7.9",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"A1C 8.0-8.9",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"A1C 9.0-9.9",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"A1C 10.0-10.9",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?3,"A1C 11.0 or higher",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?3,"Not tested or no valid result",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9))
BPC ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 S T=$P(V,U,5)+$P(V,U,4)+$P(V,U,3)
 W !?3,"<140/<90",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?3,"140/90 - <160/<95",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?3,"160/95 or higher",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?3,"BP category Undetermined",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
COMOR ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 S V=BDMCUML(400) W !!,$P(BDMCUML(400),U,1)
 W !?3,"Active Depression",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?3,"Current tobacco user",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?3,"Severely obese (BMI 40.0 or above)",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?3,"Diagnosed hypertension",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?6,"Diagnosed hypertension & mean BP <140/<90",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,6)),?73,$$P($P(V,U,6),$P(V,U,7))
COCVD ;
 I $Y>(BDMIOSL-8) D HEADER Q:BDMQUIT
 W !!?3,"Diagnosed CVD",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?6,"Diagnosed CVD & mean BP <140/<90",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,8)),?73,$$P($P(V,U,8),$P(V,U,9))
 W !?6,"Diagnosed CVD & not current tobacco user",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,8)),?73,$$P($P(V,U,8),$P(V,U,10))
 W !?6,"Diagnosed CVD & statin prescribed",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,8)),?73,$$P($P(V,U,8),$P(V,U,11))
 W !?6,"Diagnosed CVD & aspirin or other",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,8)),?73,$$P($P(V,U,8),$P(V,U,12)),!?9,"antiplatelet/anticoagulant therapy prescribed"
CKD ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 W !!?3,"In age 18+ chronic kidney disease (CKD)*",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,14))
 W !?6,"CKD* & mean BP <140/<90",?49,$$C($P(V,U,15)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,15))
 W !?6,"CKD* & ACE Inhibitor or ARB prescribed",?49,$$C($P(V,U,16)),?61,$$C($P(V,U,14)),?73,$$P($P(V,U,14),$P(V,U,16))
GU ;
 I $Y>(BDMIOSL-12) D HEADER Q:BDMQUIT
 W !!?3,"In age 18+",?49,$$C($P(V,U,13)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,13))
 W !?6,"Chronic Kidney Disease Stage"
 W !?6,"Normal: eGFR =>60 ml/min",?49,$$C($P(V,U,18)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,18)),!?9,"& UACR <30 mg/g"
 W !?6,"Stage 1/2: eGFR =>60 ml/min",?49,$$C($P(V,U,19)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,19)),!?9,"& UACR =>30 mg/g"
 W !?6,"Stage 3: eGFR 30-59 ml/min",?49,$$C($P(V,U,20)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,20))
 W !?6,"Stage 4: eGFR 15-29 ml/min",?49,$$C($P(V,U,21)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,21))
 W !?6,"Stage 5: eGFR <15 ml/min",?49,$$C($P(V,U,22)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,22))
 W !?6,"In age 18+ Chronic Kidney",?49,$$C($P(V,U,23)),?61,$$C($P(V,U,13)),?73,$$P($P(V,U,13),$P(V,U,23)),!?9,"Disease Stage undetermined"
COM ;
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 W !!?3,"Number of comorbid conditions****"
 W !?6,"Diabetes only",?49,$$C($P(V,U,25)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,25))
 W !?6,"One",?49,$$C($P(V,U,26)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,26))
 W !?6,"Two",?49,$$C($P(V,U,27)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,27))
 W !?6,"Three",?49,$$C($P(V,U,28)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,28))
 W !?6,"Four",?49,$$C($P(V,U,29)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,29))
 W !?6,"Five",?49,$$C($P(V,U,30)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,30))
 W !?6,"Six",?49,$$C($P(V,U,31)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,31))
TOBSCR ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(65)) W !!,"Tobacco Use",!?3,$P(V,U)
 W !?6,"Screened",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?6,"Not screened",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
TOB ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!?3,$P(V,U)
 W !?6,"Current tobacco user",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"In current tobacco users, counseled?"
 W !?12,"Yes",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,4))
 W !?12,"No",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,5))
 W !?6,"Not a current tobacco user",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?6,"Tobacco use not documented",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
TX ;
 I $Y>(BDMIOSL-30) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?3,"Diet and exercise alone",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !!?2,"Diabetes meds currently prescribed, alone or in combination"
 W !!?3,"Insulin",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !!?3,"Sulfonylurea (glyburide, glipizide,",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5)),!?10,"others)"
 W !!?3,"Glinide (Prandin, Starlix)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !!?3,"Metformin (Glucophage, others)",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !!?3,"Acarbose (Precose)/Miglitol (Glyset)",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !!?3,"Pioglitizone (Actos) or rosiglitazone",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9)),!?10,"(Avandia)"
 W !!?3,"GLP-1 med (Byetta, Bydureon, Victoza,",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10)),!?10,"Tanzeum, Trulicity)"
 W !!?3,"DPP4 inhibitor (Januvia, Onglyza, ",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,11)),!?10,"Tradjenta, Nesina)"
 W !!?3,"Amylin analog (Symlin)",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,12))
 W !!?3,"Bromocriptine (Cycloset)",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,14))
 W !!?3,"Colesevelam (Welchol)",?49,$$C($P(V,U,15)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,15))
 W !!?3,"SGLT-2 Inhibitor (Invokana, Farxiga,",?49,$$C($P(V,U,16)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,16)),!?10,"Jardiance)"
 I $Y>(BDMIOSL-10) D HEADER Q:BDMQUIT
 W !!?2,"Number of diabetes meds currently prescribed"
 W !?3,"One med",?49,$$C($P(V,U,17)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,17))
 W !?3,"Two meds",?49,$$C($P(V,U,18)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,18))
 W !?3,"Three meds",?49,$$C($P(V,U,19)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,19))
 W !?3,"Four or more meds",?49,$$C($P(V,U,20)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,20))
 D ^BDMDD1A
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
 I $G(BDMGUI) W !!
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BDMPG,!
 W !,$$CTR("IHS DIABETES CARE AND OUTCOMES AUDIT REPORT - RPMS AUDIT",80),!
 N BDMDHDR
 S BDMDHDR="AUDIT REPORT FOR 2016 (Audit Period "_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"
 W $$CTR(BDMDHDR,80),!
 ;W $$CTR("AUDIT REPORT FOR 2016 (Audit Period "_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"),!
 S X="for "_$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U) W $$CTR(X,80),!
 S X=$P(BDMCUML(10),U,2)_" patients were audited" W $$CTR(X),!
 W $TR($J("",80)," ","-"),!
 W ?45,"# of ",?57,"#",?70,"Percent",!
 W ?45,"Patients",?57,"Considered",!
 W ?45,"(Numerator)",?57,"(Denominator)",!
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
