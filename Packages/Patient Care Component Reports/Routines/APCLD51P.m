APCLD51P ; IHS/CMI/LAB - 2005 DIABETES AUDIT PRINT ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 S APCLQUIT=0
 I APCLPREP=3 G CUML
 ;print ind audits first
 S APCLPD=0 F  S APCLPD=$O(^XTMP("APCLDM51",APCLJOB,APCLBTH,"AUDIT",APCLPD)) Q:APCLPD'=+APCLPD!(APCLQUIT)  D
 .W:$D(IOF) @IOF
 .W $$CTR("ASSESSMENT OF DIABETES CARE, 2005         DATE AUDIT RUN: "_$$FMTE^XLFDT(APCLRED),80)
 .;W !,$$CTR("DATE AUDIT RUN: "_$$FMTE^XLFDT(DT),80)
 .W !,"AUDIT DATE: ",$$FMTE^XLFDT(APCLRED),?30,"FACILITY NAME: ",$P(^DIC(4,DUZ(2),0),U)
 .W !,"AREA: ",$$I(6),?12,"SU: ",$$I(8),?30,"FACILITY: ",$$I(10),?48,"# PTS ON DM REGISTER: ",$$I(12)
 .I $G(APCLSDPI)]"" W !,"Does you community receive SDPI grant funds?  "_$S(APCLSDPI=1:"Yes",APCLSDPI=2:"No",APCLSDPI=3:"Don't know",1:"")
 .I $G(APCLSDPI)=1 W "   ",APCLSDPG
 .W !!,"TRIBAL AFFIL: ",$P($$I(120),U,1)," ",$E($P($$I(120),U,2),1,20),"   ","COMMUNITY: ",$P($$I(121),U)," ",$E($P($$I(121),U,2),1,19)
 .W !,"REVIEWER: ",$$I(14),?17,"CHART #: ",$$I(16),?38,"DOB: ",$$I(18),?66,"SEX: ",$$I(20)
 .W !,"DESIGNATED PRIMARY CARE PROVIDER:  ",$$I(15)
 .W !!,"DATE OF DIABETES DIAGNOSIS:"
 .W ?40,"Lipid Lowering Agent:  ",$$I(61)
 .W !?1,"CMS Register: ",$$I(22)
 .W !?1,"Problem List: ",$$I(23)
 .W ?40,"IMMUNIZATIONS"
 .W !?1,"1st DX recorded in PCC: ",$$I(21)
 .W ?40,"Flu vaccine (past yr): ",$$I(64)
 .W !,"Diabetes Type: ",$$I(29)
 .W ?40,"Pneumovax Ever: ",$$I(66)
 .W !?1,"CMS Register: ",$$I(24)
 .W ?40,"Td in past 10 yrs: ",$$I(68)
 .W !?1,"Problem List: ",$$I(25)
 .W ?40,"PPD Status: ",$$I(70)
 .W !?1,"PCC POV's:    ",$$I(26)
 .W ?40,"If PPD Pos, INH Tx Complete: "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !
 .W ?42,$P($$I(72),U),"  ",$P($$I(72),U,2)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"TOBACCO USE: ",$$I(27)
 .W ?40,"If PPD Neg, Last PPD date: " W $$FMTE^XLFDT($$I(114))
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,"Referred for (or provided) Cessation"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,"Counseling: ",$$I(28)
 .W ?40,"Date of Last EKG: ",$$I(76)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"VITAL STATISTICS"
 .W ?40,"LABORATORY DATA"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Height: ",$$I(30)
 .W ?40,"HbA1c (most recent): ",$P($$I(78),U,1)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Last Weight: ",$$I(32)
 .W ?41,"Date Obtained: ",$P($$I(78),U,2)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"  BMI: ",$$I(112)
 .W ?40,"HbA1c (next most recent): ",$P($$I(78),U,4)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"HTN (documented DX): ",$$I(34)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Last 3 Blood Pressures (in past yr):"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$P($$I(36),";")
 .W ?40,"MOST RECENT SERUM VALUE (in the"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$P($$I(36),";",2)
 .W ?40,"past 12 months):"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$P($$I(36),";",3)
 .W ?41,"Creatinine: ",$$I(84)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !
 .W ?41,"Total Cholesterol: ",$$I(86)
 .W !,"EXAMINATIONS (in past year)"
 .W ?41,"HDL Cholesterol: ",$$I(89)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Foot exam-complete: "
 .W ?41,"LDL Cholesterol: ",$$I(88)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$$I(38)
 .W ?41,"Triglycerides: ",$$I(90)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Eye exam (dilated/fundus): "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$$I(40)
 .W ?41,"Urinalysis or A/C Ratio: "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Dental exam: "
 .W ?42,$$I(92)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?2,$$I(42)
 .W ?41,"Proteinuria: "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !
 .W ?42,$$I(94)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"EDUCATION (in past year)"
 .W ?41,"Microalbuminuria: "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Diet Instruction: ",$$I(44)
 .W ?42,$$I(96)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Exercise Instruction: ",$$I(46)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"DM Education (Other): ",$$I(48)
 .W ?40,"Self monitoring of blood glucose"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !
 .W ?41,"documented in chart:  ",$$I(98)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"DM THERAPY"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Select all that currently apply"
 .W ?40,"Supplemental Section"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(51),?4,"1 Diet & Exercise Alone"
 .W ?40,"Does pt have depression as an active"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(52),?4,"2 Insulin"
 .W ?41,"problem?  ",$$I(200)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(53),?4,"3 Sulfonylurea "
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(54),?4,"4 Metformin "
 .W ?40,"If 'No', has pt been screened for"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(55),?4,"5 Acarbose "
 .W ?41,"depression in the past year?"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$$I(56),?4,"6 Glitazones"
 .W ?42,$$I(210)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !?1,$P($$I(57),U),?4,"9 Unknown/Refused" I $$I(57)]"" W "  ",$P($$I(57),U,2)
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"ACE Inhibitor/ARB Use: ",$$I(60)
 .W ?41,"Local Option question:"
 .I $Y>(IOSL-1) D PAGE Q:APCLQUIT
 .W !,"Aspirin/Anti-Platelet Therapy: ",$$I(62)
 .D PAGE Q:APCLQUIT
CUML ;
 I APCLPREP=4!(APCLPREP=3) D CUML^APCLD514
DONE ;
 K ^TMP($J)
 K ^XTMP("APCLDM51",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
I(I) ;
 Q ^XTMP("APCLDM51",APCLJOB,APCLBTH,"AUDIT",APCLPD,I)
 ;
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
