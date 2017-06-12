BDMDD1P ; IHS/CMI/LAB - 2016 DIABETES AUDIT PRINT ; 22 Sep 2015  7:20 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
 S BDMQUIT=0,BDMPG=0,BDMIOSL=$S($G(BDMGUI):57,1:IOSL)
 I BDMPREP=3 G CUML
 I BDMPREP=5 G CUML
 I BDMPREP=6 G CUML
 ;print ind audits first
 S BDMPD=0,BDMGUIC=0 F  S BDMPD=$O(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .I $G(BDMGUI),BDMGUIC W !,"ZZZZZZZ",!  ;maw
 .S BDMGUIC=1
 .W:$D(IOF) @IOF
 .S BDMPG=BDMPG+1 W:$G(BDMGUI) !! W $$CTR("ASSESSMENT OF DIABETES CARE, 2016       DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
 .W !!,"Audit Period Ending Date: ",$$FMTE^XLFDT(BDMRED),?40,"Facility Name: ",$E($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),1,24)
 .W !,"REVIEWER initials: ",$$I(14),?40,"Community: ",$$I(122)
 .W !,"STATE of Residence: ",$P($$I(121),U)
 .W !,$S($G(BDMPPN):"NAME: "_$P($G(^DPT(BDMPD,0)),U),1:"") S J=$S($G(BDMPPN):$L($P(^DPT(BDMPD,0),U))+10,1:0)
 .W ?J,"CHART #: ",$$I(16),"    DOB: ",$$I(18),"    SEX: ",$$I(20)
 .W !,"PRIMARY CARE PROVIDER:  ",$$I(15)
 .W !!,"DATE of Diabetes Diagnosis:"
 .W !?2,"DM Reg: ",$S($$I(22)]"":$$I(22),1:"<not documented>"),"  Problem List: ",$S($$I(23)]"":$$I(23),1:"<not documented>"),"  1st PCC DX: ",$$I(21)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I $$I(26.5)]"" W !,$$I(26.5),!,$$I(26.6)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"DM TYPE: ",$$I(29)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DM Register: ",$S($$I(24)]"":$$I(24),1:"<not documented>"),"  Problem List: ",$S($$I(25)]"":$$I(25),1:"<not documented>"),"  PCC POV's: ",$$I(26)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Screened for tobacco use during Audit period: " S %=$$I(215) W $S($P(%,U,1)=3:"2  No",1:"1  Yes") ;_" "_$P($P(%,U,2),"  ",2,999)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Tobacco Use Status: ",$P($$I(27),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Cessation Counseling received?  " W $$I(28)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S X=$$I(30)
 .W !!,"HEIGHT (last ever): ",X  ;$J($P(X," "),2,0)_" "_$P(X," ",2,99)  ;ROUND HT KS 1208 2 DECIMALS THROUGHOUT 2016 PER K SHEFF
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S %=$P($$I(32)," ",1) I %]"" S %=$$STRIP^XLFSTR($J(%,4,0)," ")
 .W !,"Last WEIGHT in audit period: ",%," ",$P($$I(32)," ",2,99),"     BMI: ",$$I(112)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"HTN (documented diagnosis): ",$$I(34)
 .I $Y>(BDMIOSL-3) D PAGE Q:BDMQUIT
 .W !,"Last 3 BLOOD PRESSURES during audit period:",?45,$P($$I(36),";",1)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?45,$P($$I(36),";",2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?45,$P($$I(36),";",3)
 .I $Y>(BDMIOSL-5) D PAGE Q:BDMQUIT
 .W !!,"Examinations during audit period"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"FOOT EXAM-comprehensive: ",?34,$$I(38)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"EYE EXAM (dilated or retinal imaging): " W:$E($$I(40))'=2 ! W ?5,$$I(40)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DENTAL EXAM: ",?34,$$I(42)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Education during audit period"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"NUTRITION INSTRUCTION: ",?36,$P($$I(44),U) I $P($$I(44),U,2)]"" W !?10,$P($$I(44),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"PHYSICAL ACTIVITY INSTRUCTION: ",?36,$$I(46)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DM Education (Other): ",?36,$$I(48)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Mental Health"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Depression an active problem?  ",$$I(200)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?2,"If 'No', Screened for depression during audit period:"
 .W !?7,$$I(210)
 .I $Y>(BDMIOSL-14) D PAGE Q:BDMQUIT
 .W !!,"DM THERAPY     Select all prescribed, as of the end of the audit period:"
 .W !?3,$$I(51),?6,"1 Diet & Exercise Alone"
 .W !?3,$$I(52),?6,"2 Insulin"
 .W !?3,$$I(53),?6,"3 Sulfonylurea (glyburide, glipizide, others)"
 .W !?3,$$I(98),?6,"4 Glinide (Prandin, Starlix)"
 .W !?3,$$I(54),?6,"5 Metformin (Glucophage, others)"
 .W !?3,$$I(55),?6,"6 Acarbose (Precose) or miglitol (Glyset)"
 .W !?3,$$I(56),?6,"7 Pioglitazone (Actos) or rosiglitazone (Avandia)"
 .W !?3,$$I(100),?6,"8 GLP-1 med (Byetta, Bydureon, Victoza, Tanzeum, Trulicity)"
 .W !?3,$$I(59),?6,"9 DPP4 inhibitors (Januvia, Onglyza, Tradjenta, Nesina)"
 .W !?3,$P($$I(99),U),?6,"10 Amylin Analog (Symlin)"
 .W !?3,$P($$I(101),U),?6,"11 Bromocriptine (Cycloset)"
 .W !?3,$P($$I(102),U),?6,"12 Colesevelam (Welchol)"
 .W !?3,$P($$I(103),U),?6,"13 SGLT-2 inhibitor (Invokana, Farxiga, Jardiance)"
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !!,"ACE Inhibitor/ARB  Prescribed, as of the end of the audit period: ",!?10,$$I(60)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !,"Aspirin/Antiplatelet/Anticoagulant Therapy  Prescribed, as of the end of the audit period: ",!?10,$$I(62)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !,"Statin Therapy  Prescribed, as of the end of the Audit period:",!?10,$$I(300)
 .I $Y>(BDMIOSL-6) D PAGE Q:BDMQUIT
 .W !!,"TB Testing"
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !,"TB test done: ",$P($$I(70),"||",1)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !,"TB test result: ",$P($$I(70),"||",2)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?4,"If test Pos, INH Tx Complete: ",?33,$P($$I(72),U),"  ",$P($$I(72),U,2)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?4,"If test Neg, Last test: ",?33,$$DATE^BDMS9B1($$I(114))
 .W !!,"CVD: Cardiovascular disease diagnosed: ",?40,$$I(116)
 .I $Y>(BDMIOSL-6) D PAGE Q:BDMQUIT
 .W !!,"Immunizations"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Influenza vaccine during audit period: ",?35,$$I(64)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Pneumococcal vaccine - ever: ",?35,$$I(66)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Td or Tdap in past 10 yrs: ",?35,$$I(68)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Tdap ever: ",?35,$$I(216)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"HEP B 3 dose series complete - ever: ",?33,$$I(115)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"LABORATORY DATA - most recent result during audit period"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"A1C: ",?28,$P($$I(78),U,2),?43,$$DATE^BDMS9B1($P($$I(78),U,1)),?60,$E($$VAL^XBDIQ1(9000010.09,+$P($$I(78),U,4),.01),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Serum Creatinine: ",?28,$P($$I(84),U,1),?43,$P($$I(84),U,2),?60,$E($P($$I(84),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"eGFR value: ",?28,$P($$I(79),U,2),?43,$P($$I(79),U,3),?60,$P($$I(79),U,4)
 .W !?2,"Total Cholesterol: ",?28,$P($$I(86),U,1),?43,$P($$I(86),U,2),?60,$E($P($$I(86),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"HDL Cholesterol: ",?28,$P($$I(89),U,1),?43,$P($$I(89),U,2),?60,$E($P($$I(89),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"LDL Cholesterol: ",?28,$P($$I(88),U,1),?43,$P($$I(88),U,2),?60,$E($P($$I(88),U,3),1,19)
 .;I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .;W !?2,"Non-HDL Cholesterol: ",?28,$P($$I(117),U,1),?43,$P($$I(117),U,2),?60,$E($P($$I(117),U,3),1,19) ;,?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,"Triglycerides: ",?28,$P($$I(90),U,1),?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .I $Y>(BDMIOSL-5) D PAGE Q:BDMQUIT
 .W !!,"Urine Protein Testing during audit period"
 .S BDMUTT=$P($$I(92),U,5)
 .W !!,"Quantitative Urine Albumin:Creatinine Ratio (UACR) performed? ",$S(BDMUTT=1:"Yes",1:"No")  ;ihs/cmi/maw TODO not sure if this is the correct logic
 .I $Y>(BDMIOSL-10) D PAGE Q:BDMQUIT
 .W !?7,"UACR value:  " I BDMUTT=1 W ?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"COMBINED:  Meets ALL: A1C <8.0, statin prescribed, mean BP <140/<90"
 .I $$AGE^AUPNPAT(BDMPD,BDMADAT)<39 W !?5,"This is only calculated for patients 40 years of age and older." I 1
 .E  W !?5,$P($$I(118),U,1) ;,?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .G:$$AGE^AUPNPAT(BDMPD,BDMADAT)<18 N1
 .W !!,"Has e-GFR and UACR:  ",$P($$I(119),U,1)
 .I '$G(BDMGUI) I $Y>(BDMIOSL-6) D PAGE Q:BDMQUIT
N1 .W !!,"Local Option question:  ",$$LOCN^BDMDD10(BDMPD,BDMDMRG)
 .W !!,"Extended Local Option question:  ",$$LOCT^BDMDD10(BDMPD,BDMDMRG)
 .W ! ;!!,?10,"*UACR is the preferred test.",!?10,"See Audit 2016 Instructions for more information."
 .I $E(IOST,1,2)'="P-" W !! S DIR(0)="E" D ^DIR K DIR
CUML ;
 I BDMPREP=4!(BDMPREP=3) D CUML^BDMDD14
 I BDMPREP=5 D SDPI^BDMDD1Q
 I BDMPREP=6 D SDPI16^BDMDD1U
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 K ^XTMP("BDMDM16",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q $G(^XTMP("BDMDM16",BDMJOB,BDMBTH,"AUDIT",BDMPD,I))
 ;
PAGE ;
 Q:$G(BDMDSP)
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 I BDMPG W:$D(IOF) @IOF
 I $G(BDMGUI),BDMGUIC,'$G(BDMDSP) W !,"ZZZZZZZ",!  ;maw
 I $G(BDMGUI) W !!
 S BDMPG=BDMPG+1
 W $$CTR("ASSESSMENT OF DIABETES CARE, 2016         DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
 W !,"Audit Period Ending Date: ",$$FMTE^XLFDT(BDMRED)
 W !,$S($G(BDMPPN):"NAME: "_$P($G(^DPT(BDMPD,0)),U),1:"") S J=$S($G(BDMPPN):$L($P(^DPT(BDMPD,0),U))+10,1:0)
 W ?J,"CHART #: ",$$I(16),"    DOB: ",$$I(18),"    SEX: ",$$I(20)
 W !,$$REPEAT^XLFSTR("-",79)
 Q
 ;
ACPCOQ() ;-- return none if no UACR, UPCR, Quant
 I $P($$I(91),U)="X" Q ""
 I $P($$I(93),U)="X" Q ""
 I $P($$I(95),U)="X" Q ""
 Q "X"
 ;
ACPCRES() ;-- return result from UACR UPCR
 I $P($$I(91),U)="X" Q $P($$I(91),U,2)
 I $P($$I(93),U)="X" Q $P($$I(93),U,2)
 Q ""
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
QUANCHK() ;--check quantitative
 I $P($$I(91),U)]"" Q ""
 I $P($$I(93),U)]"" Q ""
 Q $$I(95)
 ;
