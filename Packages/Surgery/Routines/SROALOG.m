SROALOG ;B'HAM ISC/MAM - ASSESSMENT LOG ; [ 09/22/98  11:26 AM ]
 ;;3.0; Surgery ;**38,55,62,77,50**;24 Jun 93
 K SRMNA S (SRSOUT,SRFLG,SRSP)=0
START G:SRSOUT END W @IOF,!,"List of Surgery Risk Assessments",!!,"  1. List of Incomplete Assessments",!,"  2. List of Completed Assessments",!,"  3. List of Transmitted Assessments",!,"  4. List of Non-Assessed Major Surgical Cases"
 W !,"  5. List of All Major Surgical Cases",!,"  6. List of All Surgical Cases",!,"  7. List of Completed/Transmitted Assessments Missing Information"
 W !!,"Select the Number of the Report Desired: " R X:DTIME I '$T!("^"[X) S SRSOUT=1 G END
 I X<1!(X>7)!(X\1'=X) D HELP G START
 S SREPORT=X
DATE D DATE^SROUTL(.SRSD,.SRED,.SRSOUT) G:SRSOUT END
 D SEL G:SRSOUT END
 I SREPORT'=7 W @IOF,!,"This report is designed to print to your terminal screen or a printer.  When",!,"using a printer, a 132 column format is used.",!
 K IOP,%ZIS,POP,IO("Q") S %ZIS("A")="Print the List of Assessments to which Device: ",%ZIS="QM" D ^%ZIS I POP S SRSOUT=1 G END
 I $D(IO("Q")) K IO("Q") S ZTRTN="EN^SROALOG",ZTDESC="List of Surgery Risk Assessments",(ZTSAVE("SRSD"),ZTSAVE("SRED"),ZTSAVE("SREPORT"),ZTSAVE("SRASP"),ZTSAVE("SRFLG"),ZTSAVE("SRSP"),ZTSAVE("SRSITE*"))="",ZTREQ="@" D ^%ZTLOAD G END
EN ; entry when queued
 N SRFRTO S Y=SRSD X ^DD("DD") S SRFRTO="FROM: "_Y_"  TO: ",Y=SRED X ^DD("DD") S SRFRTO=SRFRTO_Y
 U IO S SRSD=SRSD-.0001,SRED=SRED_".9999",Y=DT X ^DD("DD") S SRPRINT="DATE PRINTED: "_Y
 S SRINST=SRSITE("SITE"),SRINSTP=SRSITE("DIV")
 I SREPORT=1 D:SRSP ^SROANTS D:'SRSP ^SROANT G END
 I SREPORT=2 D:SRSP ^SROALCS D:'SRSP ^SROALC G END
 I SREPORT=3 D:SRSP ^SROALTS D:'SRSP ^SROALT G END
 I SREPORT=4 S SRMNA=1 D:SRSP ^SROALLS D:'SRSP ^SROALL G END
 I SREPORT=5 D:SRSP ^SROALLS D:'SRSP ^SROALL G END
 I SREPORT=7 D ^SROALM G END
 D:SRSP ^SROALSS D:'SRSP ^SROALST
END I 'SRSOUT,$E(IOST)'="P" W !!,"Press <RET> to continue  " R X:DTIME
 W:$E(IOST)="P" @IOF K ^TMP("SRA",$J) I $D(ZTQUEUED) Q:$G(ZTSTOP)  S ZTREQ="@" Q
 D ^%ZISC K SRTN W @IOF D ^SRSKILL
 Q
HELP W !!,"Select the number corresponding to the type of report you want to print.",!!,"Press <RET> to continue  " R X:DTIME I '$T!(X["^") S SRSOUT=1
 Q
SEL ; select specialty
 W !!,"Print by Surgical Specialty ?  YES// " R X:DTIME S:'$T X="^" I X="^" S SRSOUT=1 Q
 S X=$E(X) I "YyNn"'[X W !!,"Enter <RET> to print the report by surgical specialty, or 'N' to print",!,"the report listing all surgical cases." G SEL
 Q:"Yy"'[X
SEL1 S SRSP=1 W !!,"Print report for ALL specialties ?  YES// " R X:DTIME S:'$T X="^" I X="^" S SRSOUT=1 Q
 S X=$E(X) I "YyNn"'[X W !!,"Enter <RET> to print the report for all surgical specialties, or 'N' to ",!,"print the report for a specific surgical specialty." G SEL1
 I "Yy"'[X W ! S DIC("S")="I '$P(^(0),""^"",3)",DIC("A")="Print the Report for which Surgical Specialty: ",DIC=137.45,DIC(0)="QEAMZ" D ^DIC K DIC I Y>0 S SRASP=+Y,SRFLG=1 Q
 I Y'>0 S SRSOUT=1 Q
 Q
