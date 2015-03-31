BDMDB1P ; IHS/CMI/LAB - 2014 DIABETES AUDIT PRINT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**7**;JUN 14, 2007;Build 24
 ;
 ;
 S BDMQUIT=0,BDMPG=0,BDMIOSL=$S($G(BDMGUI):57,1:IOSL)
 I BDMPREP=3 G CUML
 ;print ind audits first
 S BDMPD=0,BDMGUIC=0 F  S BDMPD=$O(^XTMP("BDMDM14",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .I $G(BDMGUI),BDMGUIC W !,"ZZZZZZZ",!  ;maw
 .S BDMGUIC=1
 .W:$D(IOF) @IOF
 .S BDMPG=BDMPG+1 W:$G(BDMGUI) !! W $$CTR("ASSESSMENT OF DIABETES CARE, 2014       DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
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
 .W !!,"TOBACCO USE: ",$P($$I(27),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Cessation Counseling received?  " W $$I(28)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"HEIGHT (last ever): ",$$I(30)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S %=$P($$I(32)," ",1) I %]"" S %=$$STRIP^XLFSTR($J(%,6,2)," ")
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
 .W !?2,"FOOT EXAM-complete: ",?34,$$I(38)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"EYE EXAM (dilated or retinal camera): " W:$E($$I(40))'=2 ! W ?5,$$I(40)
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
 .W !?3,$$I(100),?6,"8 GLP-1 med (Byetta, Bydureon, Victoza)"
 .W !?3,$$I(59),?6,"9 DPP4 inhibitors (Januvia, Onglyza, Tradjenta)"
 .W !?3,$P($$I(99),U),?6,"10 Amylin Analog (Symlin)"
 .W !?3,$P($$I(101),U),?6,"11 Bromocriptine (Cycloset)"
 .W !?3,$P($$I(102),U),?6,"12 Colesevelam (Welchol)"
 .W !?3,$P($$I(102),U),?6,"13 SGLT-2 inhibitor (Invokana)"  ;ihs/cmi/maw 08/03/2013 p7 need logic
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"ACE Inhibitor/ARB  Prescribed, as of the end of the audit period: ",!?10,$$I(60)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"Aspirin/Antiplatelet Therapy  Prescribed, as of the end of the audit period: ",!?10,$$I(62)
 .I $Y>(BDMIOSL-12) D PAGE Q:BDMQUIT
 .W !,"Lipid Lowering Agent  Select all prescribed, as of the end of the ",!,"audit period:"
 .W !!?3,$$I(300),?6,"1 Statin (simvastatin/Zocor, others)"
 .W !?3,$$I(301),?6,"2 Fibrate (gemfibroil/Lopid, others)"
 .W !?3,$$I(302),?6,"3 Niacin (Niaspan, OTC niacin)"
 .W !?3,$$I(303),?6,"4 Bile Acid Sequestrant (cholestyraminie/Questran, others)"
 .W !?3,$$I(304),?6,"5 Ezetimibe (Zetia)"
 .W !?3,$$I(305),?6,"6 Fish Oil"
 .W !?3,$$I(306),?6,"7 Lovaza"
 .W !?3,$P($$I(307),U,1),?6,"8 None"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"TB Testing"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"TB test done: ",$P($$I(70),"||",1)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"TB test result: ",$P($$I(70),"||",2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?4,"If PPD Pos, INH Tx Complete: ",?33,$P($$I(72),U),"  ",$P($$I(72),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?4,"If PPD Neg, Last PPD: ",?33,$$FMTE^XLFDT($$I(114))
 .W !!,"CVD: Cardiovascular disease diagnosed: ",?40,$$I(116)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Immunizations"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"FLU VACCINE during audit period: ",?33,$$I(64)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"PNEUMOVAX - ever: ",?33,$$I(66)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Td or Tdap in past 10 yrs: ",?33,$$I(68)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"HEP B 3 dose series complete - ever: ",?33,$$I(115)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"LABORATORY DATA - most recent result during audit period"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"HbA1c: ",?28,$P($$I(78),U,2),?43,$$FMTE^XLFDT($P($$I(78),U,1)),?60,$E($$VAL^XBDIQ1(9000010.09,+$P($$I(78),U,4),.01),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Serum Creatinine: ",?28,$P($$I(84),U,1),?43,$P($$I(84),U,2),?60,$E($P($$I(84),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"eGFR value: ",?28,$P($$I(79),U,2),?43,$P($$I(79),U,3),?60,$P($$I(79),U,4)
 .W !?2,"Total Cholesterol: ",?28,$P($$I(86),U,1),?43,$P($$I(86),U,2),?60,$E($P($$I(86),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"HDL Cholesterol: ",?28,$P($$I(89),U,1),?43,$P($$I(89),U,2),?60,$E($P($$I(89),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"LDL Cholesterol: ",?28,$P($$I(88),U,1),?43,$P($$I(88),U,2),?60,$E($P($$I(88),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Non-HDL Cholesterol: ",?28,$P($$I(117),U,1),?43,$P($$I(117),U,2),?60,$E($P($$I(117),U,3),1,19) ;,?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Triglycerides: ",?28,$P($$I(90),U,1),?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Urine Protein Testing during audit period"
 .S BDMUTT=$P($$I(92),U,5)
 .W !!,"Urine Albumin:Creatinine Ratio (UACR) performed? ",$S(BDMUTT=1:"Yes",1:"No")  ;ihs/cmi/maw TODO not sure if this is the correct logic
 .I $Y>(BDMIOSL-10) D PAGE Q:BDMQUIT
 .;ihs/cmi/maw 08/05/2013 patch 7 commented the following 7 lines
 .;W !,"URINE TESTED FOR PROTEIN: ",?28,$P($$I(92),U,1),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .;W !!,"SPECIFIC TESTING DONE*:"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;S BDMUTT=$P($$I(92),U,5)
 .;W !?2,$S(BDMUTT=1:"X",1:""),?5,"1 Urine Albumin:Creatinine Ratio (UACR)"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?7,"UACR value:  " I BDMUTT=1 W ?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;ihs/cmi/maw 08/05/2013 patch 7 commented the following 20 lines
 .;W !?2,$S(BDMUTT=2:"X",1:""),?5,"2 Urine Protein:Creatinine Ratio"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;I BDMUTT=2 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;W !?2,$S(BDMUTT=3:"X",1:""),?5,"3 24 hr urine collection for protein"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;I BDMUTT=3 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;W !?2,$S(BDMUTT=4:"X",1:""),?5,"4 Microalbumin:creatinine strips (e.g., Clinitek)"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;I BDMUTT=4 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;W !?2,$S(BDMUTT=5:"X",1:""),?5,"5 Microalbumin only (e.g. Micral)"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;I BDMUTT=5 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;W !?2,$S(BDMUTT=6:"X",1:""),?5,"6 UA dipstick"
 .;I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .;I BDMUTT=7 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .;I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"COMBINED:  Meets ALL: A1C <8.0, LDL <100, mean BP <140/<90",!?5,$P($$I(118),U,1) ;,?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .G:$$AGE^AUPNPAT(BDMPD,BDMBDAT,BDMADAT)<18 N1
 .W !!,"Has e-GFR and UACR:  ",$P($$I(119),U,1)
 .I '$G(BDMGUI) I $Y>(BDMIOSL-6) D PAGE Q:BDMQUIT
N1 .W !!,"Local Option question:  ",$$LOCN^BDMDB10(BDMPD,BDMDMRG)
 .W !!,"Extended Local Option question:  ",$$LOCT^BDMDB10(BDMPD,BDMDMRG)
 .W ! ;!!,?10,"*UACR is the preferred test.",!?10,"See Audit 2014 Instructions for more information."
 .I $E(IOST,1,2)'="P-" W !! S DIR(0)="E" D ^DIR K DIR
CUML ;
 I BDMPREP=4!(BDMPREP=3) D CUML^BDMDB14
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMDM14",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q $G(^XTMP("BDMDM14",BDMJOB,BDMBTH,"AUDIT",BDMPD,I))
 ;
PAGE ;
 Q:$G(BDMDSP)
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 I BDMPG W:$D(IOF) @IOF
 I $G(BDMGUI),BDMGUIC,'$G(BDMDSP) W !,"ZZZZZZZ",!  ;maw
 I $G(BDMGUI) W !!
 S BDMPG=BDMPG+1
 W $$CTR("ASSESSMENT OF DIABETES CARE, 2014         DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
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
