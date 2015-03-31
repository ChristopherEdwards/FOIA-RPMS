BDMDB14 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ; 22 Feb 2014  3:43 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**7**;JUN 14, 2007;Build 24
 ;
 ;
DURDM(P,R,EDATE) ;EP
 NEW DATE,EARLY
 S DATE="",EARLY=9999999
 I $G(R) S DATE=$$CMSFDX^BDMDB13(P,R,"ID")
 I DATE S EARLY=DATE  ;Q ($$FMDIFF^XLFDT(EDATE,DATE,1)\365)
 S DATE=$$PLDMDOO^BDMDB13(P,"I")
 I DATE,DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 ;I EARLY>EDATE S EARLY=""
 I EARLY="" Q ""
 I 'EARLY Q ""
 S EARLY=$$DI^BDMDB16(EARLY)
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
 W !,$P(BDMCUML(10),U),!?5,"Male",?49,$$C($P(BDMCUML(10),U,4)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,4))
 W !?5,"Female",?49,$$C($P(BDMCUML(10),U,3)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,3))
 ;W !?5,"Unknown",?49,$$C($P(BDMCUML(10),U,5)),?61,$$C($P(BDMCUML(10),U,2)),?73,$$P($P(BDMCUML(10),U,2),$P(BDMCUML(10),U,5))
 I $Y>(BDMIOSL-7) D HEADER Q:BDMQUIT
 W !!,"Age" S V=$G(BDMCUML(20))
 ;S V="^4567^1234^345^987^12000"
 W !?5,"<15 years",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"15-44 years",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"45-64 years",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"65 years and older",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
TYPE ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(25))
 W !!,$P(V,U)
 W !?5,"Type 1",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"Type 2",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
DMDUR ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(30)) W !!,$P(V,U)
 W !?5,"Less than 1 year",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Less than 10 years",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"10 years or more",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Diagnosis date not recorded",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 ;weight control
WTCNTL ;
 I $Y>(BDMIOSL-6) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(40)) W !!,$P(V,U)
 W !?5,"Normal (BMI<25.0)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Overweight (BMI 25.0-29.9)",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"Obese (BMI 30.0 or above)",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Height or Weight missing",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
BSC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(50)) W !!,$P(V,U)
 W !?5,"HbA1c <7.0",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?5,"HbA1c 7.0-7.9",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"HbA1c 8.0-8.9",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"HbA1c 9.0-9.9",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"HbA1c 10.0-10.9",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?5,"HbA1c 11.0 or higher",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?5,"Not tested or no valid result",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9))
BPC ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(60)) W !!,$P(V,U)
 S T=$P(V,U,5)+$P(V,U,4)+$P(V,U,3)
 W !?5,"<140/<90",?49,$$C(T),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),T)
 W !?5,"140/90 - <160/<95",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"160/95 or higher",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?5,"BP category Undetermined",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
TOB ;
 I $Y>(BDMIOSL-9) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(80)) W !!,$P(V,U)
 W !?5,"Current Tobacco User",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?9,"In current users, counseled?    Yes",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,4))
 W !?9,"                                No",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,3)),?73,$$P($P(V,U,3),$P(V,U,5))
 W !?5,"Not a current tobacco user",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?5,"Tobacco use not documented",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
TX ;
 I $Y>(BDMIOSL-20) D HEADER Q:BDMQUIT
 S V=$G(BDMCUML(90)) W !!,$P(V,U)
 W !?5,"Diet and exercise alone",?49,$$C($P(V,U,3)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,3))
 W !?2,"Diabetes meds currently prescribed, alone or in combination"
 W !?5,"Insulin",?49,$$C($P(V,U,4)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,4))
 W !?5,"Sulfonylurea (glyburide, glipizide,",!?10,"others)",?49,$$C($P(V,U,5)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,5))
 W !?5,"Glinide (Prandin, Starlix)",?49,$$C($P(V,U,6)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,6))
 W !?5,"Metformin (Glucophage, others)",?49,$$C($P(V,U,7)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,7))
 W !?5,"Acarbose (Precose)/Miglitol (Glyset)",?49,$$C($P(V,U,8)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,8))
 W !?5,"Proglitizone (Actos) or rosiglitazone",!?10,"(Avandia)",?49,$$C($P(V,U,9)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,9))
 W !?5,"GLP-1 med (Byetta, Bydureon, Victoza)",?49,$$C($P(V,U,10)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,10))
 W !?5,"DPP4 inhibitor (Januvia, Onglyza, ",!?10,"Tradjenta)",?49,$$C($P(V,U,11)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,11))
 W !?5,"Amylin analog (Symlin)",?49,$$C($P(V,U,12)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,12))
 W !?5,"Bromocriptine (Cycloset)",?49,$$C($P(V,U,14)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,14))
 W !?5,"Colesevelam (Welchol)",?49,$$C($P(V,U,15)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,15))
 W !?5,"SGLT-2 Inhibitor (Invokana)",?49,$$C($P(V,U,16)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,16))
 W !!?2,"Number of diabetes meds currently prescribed"
 W !?5,"One med",?49,$$C($P(V,U,17)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,17))
 W !?5,"Two meds",?49,$$C($P(V,U,18)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,18))
 W !?5,"Three meds",?49,$$C($P(V,U,19)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,19))
 W !?5,"Four or more meds",?49,$$C($P(V,U,20)),?61,$$C($P(V,U,2)),?73,$$P($P(V,U,2),$P(V,U,20))
 D ^BDMDB1A
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
 S BDMDHDR="AUDIT REPORT FOR 2014 (Audit Period "_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"
 W $$CTR(BDMDHDR,80),!
 ;W $$CTR("AUDIT REPORT FOR 2014 (Audit Period "_$$DATE^BDMS9B1(BDMBDAT)_" to "_$$DATE^BDMS9B1(BDMADAT)_")"),!
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
