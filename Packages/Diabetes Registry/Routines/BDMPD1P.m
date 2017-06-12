BDMPD1P ; IHS/CMI/LAB - 2003 DIABETES AUDIT PRINT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
 ;
 S BDMQUIT=0,BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 I BDMPREP=2 G CUML
 ;print ind audits first
 S BDMPD=0,BDMGUIC=0 F  S BDMPD=$O(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .I $G(BDMGUI),BDMGUIC W !,"ZZZZZZZ"
 .S BDMGUIC=1
 .W:$D(IOF) @IOF
 .W !,$$CTR("ASSESSMENT PREDIABETES/METABOLIC SYNDROME CARE, FY 2016",80)
 .W !!,"AUDIT DATE: ",$$FMTE^XLFDT(BDMRED),?49,"REVIEWER: ",$$I(14)
 .W !,"FACILITY NAME: ",$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),?49,"AREA: ",$$I(6),"  SU: ",$$I(8),"  FACILITY: ",$$I(10)
 .W !,"# PTS ON PRE-DIABETES REGISTER: ",$$I(12)
 .W !!,"TRIBAL AFFIL: ",$P($$I(120),U,1)," ",$E($P($$I(120),U,2),1,20),"   ","COMMUNITY: ",$P($$I(121),U)," ",$E($P($$I(121),U,2),1,19)
 .W !,"CHART #: ",$$I(16),?21,"DOB: ",$$I(18),?46,"SEX: ",$$I(20)
 .;W !,"PRIMARY CARE PROVIDER:  ",$$I(15)
 .W !,$S($G(BDMPPN):"NAME: "_$P($G(^DPT(BDMPD,0)),U),1:"") S J=$S($G(BDMPPN):$L($P(^DPT(BDMPD,0),U))+10,1:0) W ?J,"PRIMARY CARE PROVIDER: ",$$I(15)
 .W !!,"CLASSIFICATION (all that apply):"
 .W !?1,"1 IFG - ",$$I(200)
 .S X=200 F  S X=$O(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>200.99!(X="")  D
 ..W !?3,^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"2 IGT - ",$$I(210)
 .S X=210 F  S X=$O(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>210.99!(X="")  D
 ..W !?3,^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"3 METABOLIC SYNDROME - ",$$I(220)
 .S X=220 F  S X=$O(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>220.99!(X="")  D
 ..W !?3,^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"OTHER ABNORMAL GLUCOSE - ",$$I(230)
 .S X=230 F  S X=$O(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>230.99!(X="")  D
 ..W !?3,^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"CMS Register DX: ",$$I(22)_" "_$$I(24)
 .I $D(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,25)) W !?1,^(25)
 .I $D(^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,26)) W !?1,^(26)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !!,"Height: ",$$I(30)
 .I $Y>(BDMIOSL-4) D PAGE Q:BDMQUIT
 .W !,"Last 3 Weights (in past year): " S BDMX=$$I(32)
 .W !?3 F BDMY=2:1:4 I $P(BDMX,"|",BDMY)]"" W "   ",$P(BDMX,"|",BDMY)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"Waist Circumference: ",$$I(33),?41,"ACE Inhibitor Use: ",$P($$I(60),"  ",2)
 .I $Y>(BDMIOSL-5) D PAGE Q:BDMQUIT
 .W !!,"Last 3 Blood Pressures:",?41,"Aspirin/Anti-Platelet Therapy: ",$P($$I(62),"  ",2)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";")
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";",2),?41,"Lipid Lowering Agent:  ",$$I(61)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";",3)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"HTN (documented DX): ",$$I(34),?41,"Date of Last EKG: ",$$I(76)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !!,"EDUCATION (in past year)"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"Diet Instruction: ",$$I(44)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"Exercise Instruction: ",$P($$I(46),"  ",2)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"TOBACCO USE: ",$P($$I(27),"  ",2)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"Referred for (or provided)"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"Cessation Counseling: ",$$I(28)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !!,"DM THERAPY" ;,?41,"LABORATORY DATA"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !,"Select all that currently apply"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(51),?4,"1 Unknown/Refused/None"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(54),?4,"2 Metformin "
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(55),?4,"3 Acarbose "
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(56),?4,"4 Glitazones"
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(53),?4,"5 Other: Sulfonylurea, "
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?1,?4,"    Glyburide, glipizide, etc)"
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !!?1,"LABORATORY DATA"
 .W !?1,"Fasting Glucose (most recent):",?40,$$I(90)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"75 gm 2 hour glucose (most recent):",?40,$$I(91)
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !!?1,"MOST RECENT SERUM VALUE IN THE PAST 12 MONTHS"
 .I $Y>(BDMIOSL-2) D PAGE Q:BDMQUIT
 .W !?1,"Total Cholesterol: ",$P($$I(86),U,1),"  ",$P($$I(86),U,2)," ",$P($$I(86),U,3)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"HDL Cholesterol: ",$P($$I(89),U,1),"  ",$P($$I(89),U,2)," ",$P($$I(89),U,3)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"LDL Cholesterol: ",$P($$I(88),U,1),"  ",$P($$I(88),U,2)," ",$P($$I(88),U,3)
 .I $Y>(BDMIOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"Triglycerides: ",$P($$I(190),U,1),"  ",$P($$I(190),U,2)," ",$P($$I(190),U,3)
 .W !,"Local Option question:"
CUML ;
 I BDMPREP=2!(BDMPREP=3) D CUML^BDMPD14
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMPD1",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q ^XTMP("BDMPD1",BDMJOB,BDMBTH,"AUDIT",BDMPD,I)
 ;
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
