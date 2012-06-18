BDMD91P ; IHS/CMI/LAB - 2009 DIABETES AUDIT PRINT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2,3**;JUN 14, 2007
 ;
 ;
 S BDMQUIT=0,BDMPG=0,BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 I BDMPREP=3 G CUML
 ;print ind audits first
 S BDMPD=0,BDMGUIC=0 F  S BDMPD=$O(^XTMP("BDMDM91",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .I $G(BDMGUI),BDMGUIC W !,"ZZZZZZZ",!  ;maw
 .S BDMGUIC=1
 .W:$D(IOF) @IOF
 .S BDMPG=BDMPG+1 W $$CTR("ASSESSMENT OF DIABETES CARE, 2009       DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
 .W !!,"Audit Period Ending Date: ",$$FMTE^XLFDT(BDMRED)
 .W !,"Facility Name: ",$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),?46,"Area: ",$$I(6),?55,"SU: ",$$I(8),?62,"FACILITY: ",$$I(10)
 .W !,"# of ACTIVE Pts in Registry: ",$$I(12)
 .I $G(BDMSDPI)]"" W !,"Does your community receive SDPI grant funds?  "_$S(BDMSDPI=1:"Yes",BDMSDPI=2:"No",BDMSDPI=3:"Don't know",1:"")
 .I $G(BDMSDPI)=1 W "   ",BDMSDPG
 .W !,"REVIEWER: ",$$I(14),?35,"Community: ",$$I(122)
 .W !,"TRIBAL AFFIL: ",$P($$I(120),U,1)," ",$E($P($$I(120),U,2),1,25),"   STATE of Residence: ",$P($$I(121),U)  ;cmi/maw 12/17/2007 DM2009
 .W !,$S($G(BDMPPN):"NAME: "_$P($G(^DPT(BDMPD,0)),U),1:"") S J=$S($G(BDMPPN):$L($P(^DPT(BDMPD,0),U))+10,1:0)
 .W ?J,"CHART #: ",$$I(16),"    DOB: ",$$I(18),"    SEX: ",$$I(20)
 .W !,"PRIMARY CARE PROVIDER:  ",$$I(15)
 .W !,"DATE OF DIABETES DIAGNOSIS:"
 .W !?2,"DM Reg: ",$$I(22),"  Problem List: ",$$I(23),"  1st PCC DX: ",$$I(21)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I $$I(26.5)]"" W !,$$I(26.5),!,$$I(26.6)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"Diabetes Type: ",$$I(29)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DM Register: ",$$I(24),"  Problem List: ",$$I(25),"  PCC POV's: ",$$I(26)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"TOBACCO USE: ",$$I(27)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Referred for (or provided) Cessation Counseling: "
 .I $$I(28)]"" W !?4,$$I(28)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"HEIGHT: ",$$I(30)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S %=$P($$I(32)," ",1) I %]"" S %=$$STRIP^XLFSTR($J(%,6,2)," ")
 .W !,"Last WEIGHT: ",%," ",$P($$I(32)," ",2,99),"     BMI: ",$$I(112)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"HTN (documented DX): ",$$I(34)
 .I $Y>(BDMIOSL-3) D PAGE Q:BDMQUIT
 .W !,"Last 3 BLOOD PRESSURES:   ",?26,$P($$I(36),";",1)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?26,$P($$I(36),";",2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?26,$P($$I(36),";",3)
 .I $Y>(BDMIOSL-5) D PAGE Q:BDMQUIT
 .W !!,"EXAMINATIONS (during audit period)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"FOOT EXAM-complete: ",?34,$$I(38)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"EYE EXAM (dilated/fundus): ",?34,$$I(40)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DENTAL EXAM: ",?34,$$I(42)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"EDUCATION (in past year)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Diet Instruction: ",?26,$$I(44)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Exercise Instruction: ",?26,$$I(46)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"DM Education (Other): ",?26,$$I(48)
 .I $Y>(BDMIOSL-14) D PAGE Q:BDMQUIT
 .W !!,"DM THERAPY     Select all that currently apply:"
 .W !?3,$$I(51),?6,"1 Diet & Exercise Alone"
 .W !?3,$$I(52),?6,"2 Insulin"
 .W !?3,$$I(53),?6,"3 Sulfonylurea (glyburide, glipizide, repaglinide, nateglinide, others"
 .W !?3,$$I(54),?6,"4 Metformin "
 .W !?3,$$I(55),?6,"5 Acarbose "
 .W !?3,$$I(56),?6,"6 Glitazones"
 .W !?3,$$I(58),?6,"7 Incretin Mimetics"  ;cmi/maw 12/18/2007 DM2009
 .W !?3,$$I(59),?6,"8 DPP4 inhibitors"  ;cmi/maw 12/18/2007 DM2009
 .W !?3,$P($$I(99),U),?6,"9 Amylin Analogues"
 .W !?3,$P($$I(57),U),?6,"10 Refused/Unknown" I $$I(57)]"" W "  ",$P($$I(57),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"ACE Inhibitor/ARB Use: ",$$I(60)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"Aspirin/Antiplatelet Therapy: ",$$I(62)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"Lipid Lowering Agent:         ",$$I(61)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"IMMUNIZATIONS"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Flu vaccine (past yr): ",?33,$$I(64)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Pneumococcal Ever: ",?33,$$I(66)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Td in past 10 yrs: ",?33,$$I(68)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"PPD Status: ",?33,$$I(70)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?4,"If PPD Pos, INH Tx Complete: ",?33,$P($$I(72),U),"  ",$P($$I(72),U,2)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?4,"If PPD Neg, Last PPD: ",?33,$$FMTE^XLFDT($$I(114))
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Date of Last ECG: ",?33,$$I(76)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"LABORATORY DATA   (most recent values obtained during 12 mo audit period)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!?2,"HbA1c: ",?28,$P($$I(78),U,2),?43,$$FMTE^XLFDT($P($$I(78),U,1)),?60,$E($$VAL^XBDIQ1(9000010.09,+$P($$I(78),U,4),.01),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Creatinine: ",?28,$P($$I(84),U,1),?43,$P($$I(84),U,2),?60,$E($P($$I(84),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"  Estimated GFR: ",?28,$P($$I(79),U,1),?43,$P($$I(79),U,3),?60,$E($P($$I(79),U,4),1,19)
 .I $E($$I(79))="1" W !?28,"eGFR value: ",$P($$I(79),U,2)  ;documented in the"  ;cmi/maw 12/18/2007 DM2009
 .W !?2,"Cholesterol: ",?28,$P($$I(86),U,1),?43,$P($$I(86),U,2),?60,$E($P($$I(86),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"HDL Cholesterol: ",?28,$P($$I(89),U,1),?43,$P($$I(89),U,2),?60,$E($P($$I(89),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"LDL Cholesterol: ",?28,$P($$I(88),U,1),?43,$P($$I(88),U,2),?60,$E($P($$I(88),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Triglycerides: ",?28,$P($$I(90),U,1),?43,$P($$I(90),U,2),?60,$E($P($$I(90),U,3),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"Most recent urine protein testing during 12 month audit period:"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"URINE TESTED FOR PROTEIN: ",?28,$P($$I(92),U,1),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"SPECIFIC TESTING DONE:"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .S BDMUTT=$P($$I(92),U,5)
 .W !?2,$S(BDMUTT=1:"X",1:""),?5,"1 Quantitative Albumin:Creatinine Ratio (UACR)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?7,"UACR value:  " I BDMUTT=1 W ?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,$S(BDMUTT=2:"X",1:""),?5,"2 Semi-quantitative UACR"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I BDMUTT=2 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,$S(BDMUTT=3:"X",1:""),?5,"3 Protein:Creatinine Ratio (UPCR)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I BDMUTT=3 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,$S(BDMUTT=4:"X",1:""),?5,"4 Other Quantitative test (e.g. 24 hr urine albumin)"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I BDMUTT=4 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,$S(BDMUTT=5:"X",1:""),?5,"5 Found to have 1+ protein or more on standard UA dipstick"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I BDMUTT=5 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,$S(BDMUTT=6:"X",1:""),?5,"6 Other non-quantitative test"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .I BDMUTT=6 W !?28,$P($$I(92),U,2),?43,$P($$I(92),U,3),?60,$E($P($$I(92),U,4),1,19)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !!,"MENTAL HEALTH"
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"Does pt have depression as an active problem?  "
 .W !?7,$$I(200)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !?2,"If 'No', has pt been screened for depression in the past year?"
 .W !?7,$$I(210)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"Local Option question:",!
 .I $E(IOST,1,2)'="P-" W !! S DIR(0)="E" D ^DIR K DIR ;CMI/GRL 1/18/07
CUML ;
 I BDMPREP=4!(BDMPREP=3) D CUML^BDMD914
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMDM91",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q $G(^XTMP("BDMDM91",BDMJOB,BDMBTH,"AUDIT",BDMPD,I))
 ;
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 W:$D(IOF) @IOF
 S BDMPG=BDMPG+1
 W $$CTR("ASSESSMENT OF DIABETES CARE, 2009         DATE AUDIT RUN: "_$$FMTE^XLFDT(DT)_"  Page: "_BDMPG,80)
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
