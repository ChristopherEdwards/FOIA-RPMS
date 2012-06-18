BDMP51P ; IHS/CMI/LAB - 2003 DIABETES AUDIT PRINT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
 S BDMQUIT=0
 I BDMPREP=2 G CUML
 ;print ind audits first
 S BDMPD=0 F  S BDMPD=$O(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD)) Q:BDMPD'=+BDMPD!(BDMQUIT)  D
 .W:$D(IOF) @IOF
 .W !,$$CTR("ASSESSMENT PREDIABETES/METABOLIC SYNDROME CARE, FY 2005",80)
 .W !!,"AUDIT DATE: ",$$FMTE^XLFDT(BDMRED),?49,"REVIEWER: ",$$I(14)
 .W !,"FACILITY NAME: ",$P(^DIC(4,DUZ(2),0),U),?49,"AREA: ",$$I(6),"  SU: ",$$I(8),"  FACILITY: ",$$I(10)
 .W !,"# PTS ON PRE-DIABETES REGISTER: ",$$I(12)
 .W !!,"TRIBAL AFFIL: ",$P($$I(120),U,1)," ",$E($P($$I(120),U,2),1,20),"   ","COMMUNITY: ",$P($$I(121),U)," ",$E($P($$I(121),U,2),1,19)
 .W !,"CHART #: ",$$I(16),?21,"DOB: ",$$I(18),?46,"SEX: ",$$I(20)
 .W !,"PRIMARY CARE PROVIDER:  ",$$I(15)
 .W !!,"CLASSIFICATION (all that apply):"
 .W !?1,"1 IFG - ",$$I(200)
 .S X=200 F  S X=$O(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>200.99!(X="")  D
 ..W !?3,^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"2 IGT - ",$$I(210)
 .S X=210 F  S X=$O(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>210.99!(X="")  D
 ..W !?3,^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"3 METABOLIC SYNDROME - ",$$I(220)
 .S X=220 F  S X=$O(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>220.99!(X="")  D
 ..W !?3,^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"OTHER ABNORMAL GLUCOSE (790.29) - ",$$I(230)
 .S X=230 F  S X=$O(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)) Q:X>230.99!(X="")  D
 ..W !?3,^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,X)
 .W !?1,"CMS Register DX: ",$$I(22)_" "_$$I(24)
 .I $D(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,25)) W !?1,^(25)
 .I $D(^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,26)) W !?1,^(26)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !!,"Height: ",$$I(30)
 .I $Y>(IOSL-4) D PAGE Q:BDMQUIT
 .W !,"Last 3 Weights: " S BDMX=$$I(32)
 .F BDMY=2:1:4 I $P(BDMX,"|",BDMY)]"" W !?3,$P(BDMX,"|",BDMY)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"Waist Circumference: ",$$I(33),?41,"ACE Inhibitor Use: ",$$I(60)
 .I $Y>(IOSL-5) D PAGE Q:BDMQUIT
 .W !!,"Last 3 Blood Pressures:",?41,"Aspirin/Anti-Platelet Therapy: ",$$I(62)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";")
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";",2),?41,"Lipid Lowering Agent:  ",$$I(61)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?2,$P($$I(36),";",3)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"HTN (documented DX): ",$$I(34),?41,"Date of Last EKG: ",$$I(76)
 .I $Y>(IOSL-2) D PAGE Q:BDMQUIT
 .W !!,"EDUCATION (in past year)"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"Diet Instruction: ",$$I(44)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"Exercise Instruction: ",$$I(46),?41,"LABORATORY DATA"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?41,"Fasting Glucose (most recent):"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"TOBACCO USE: ",$$I(27),?45,$$I(90)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"Referred for (or provided)",?41,"75 gm 2 hour glucose (most recent):"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,"Cessation Counseling: ",$$I(28),?45,$$I(91)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"DM THERAPY"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !,"Select all that currently apply",?41,"MOST RECENT SERUM VALUE IN THE PAST"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(51),?4,"1 Unknown/Refused/None",?41," 12 MONTHS"
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(54),?4,"2 Metformin ",?41,"Total Cholesterol: ",$$I(86)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(55),?4,"3 Acarbose ",?41,"HDL Cholesterol: ",$$I(89)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(56),?4,"4 Glitazones",?41,"LDL Cholesterol: ",$$I(88)
 .I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?1,$$I(53),?4,"5 Other: Sulfonylurea, ",?41,"Triglycerides: ",$$I(90)
 .I $Y>(IOSL-2) D PAGE Q:BDMQUIT
 .W !?1,?4,"    Glyburide, glipizide, etc)"
 .;I $Y>(IOSL-1) D PAGE Q:BDMQUIT
 .W !?41,"Local Option question:"
CUML ;
 I BDMPREP=2!(BDMPREP=3) D CUML^BDMP514
DONE ;
 K ^TMP($J)
 K ^XTMP("BDMP51",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
I(I) ;
 Q ^XTMP("BDMP51",BDMJOB,BDMBTH,"AUDIT",BDMPD,I)
 ;
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT=1 Q
 W:$D(IOF) @IOF
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
