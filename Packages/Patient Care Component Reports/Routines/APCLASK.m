APCLASK ; IHS/CMI/LAB -GET PATIENT OR COHORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;CMI/TUCSON/LAB - patch 3 - 10/26/1998 Y2K fixes
 ;The above line will be changed to be nonparameter as of the
 ;next version of this package.  All callers should enter this
 ;routine at entry point START1^APCLASK(,,,)
 G START2
 ;
START1(APCLDFN,APCLCUML) ;EP
 ;
START2 ;PEP PUBLISHED ENTRY POINT - called to create a report template
 I 'APCLDFN W !,*7,"Report template entry not indicated!" H 2 Q
 I '$D(^APCLRPT(APCLDFN)) W !,*7,"Indicated patient/cohort report template entry does not exist!" H 2 Q
 I '$D(APCLCUML) S APCLCUML=0
 I APCLCUML,'$D(^APCLRPT(APCLCUML)) W !,*7,"Indicated cumulative report entry does not exist!" H 2 Q
 I '$D(DTIME) D ^XBKVAR
GETTIME S APCLSTP=0 D TIME G:APCLSTP X
START K ^TMP("APCLPTS",$J) F  D ASK Q:APCLSTP
 I '$D(^TMP("APCLPTS",$J))!(X["^") D CLEAN K APCLBDT,APCLEDT,APCLDATE,APCLFISC G GETTIME
 S APCLSTP=0
 K DIR S DIR(0)="S^1:Print Both Individual and Cumulative Reports;2:Print Individual Reports Only;3:Print Cumulative Report Only;4:Create EPI INFO file",DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G START
 S APCLPREP=Y
 I APCLPREP=4 D FLAT Q:APCLSTP
 D TASK I $D(IO("Q")) K IO("Q") D QUE G AGIN
 I 'POP S APCLSTP=0 D ZTM
AGIN D CLEAN S APCLSTP=0 G START
X D EOJ
 Q
 ;
TIME ;PEP - CALLED FROM BDM Get fiscal year or time frame
 S Y=DT D DD^%DT S APCLTDTE=Y
 S DIR(0)="SO^1:Fiscal Year;2:Date Range",DIR("A")="Indicate the desired time frame" D ^DIR K DIR
 I '$D(DTOUT),'$D(DIRUT),'$D(DIROUT),Y W ! D @Y I 1
 E  S APCLSTP=1
 Q
 ;
1 ; Fiscal Year
 S DIR(0)="DA",DIR("A")="Enter report fiscal year: " D ^DIR K DIR
 I '$D(DTOUT),'$D(DIRUT),'$D(DIROUT) S APCLFISC=$S($E(Y)=2:19,1:20)_$E(Y,2,3) D
 . ;beginning Y2K CMI/TUCSON/LAB
 . ;I APCLFISC=2000 S APCLBDT=2991001,APCLEDT=2000930 ;Y2000
 . ;E  S APCLBDT=$E(Y,1,3)-1_1001,APCLEDT=$E(Y,1,3)_"0930"
 . S APCLBDT=$E(Y,1,3)-1_1001,APCLEDT=$E(Y,1,3)_"0930" ;Y2000
 . ;end Y2K CMI/TUCSON/LAB
 . S Y=APCLBDT D DD^%DT S APCLBDT=Y
 . S (APCLED,Y)=APCLEDT D DD^%DT S APCLEDT=Y
 . S APCLDATE=";DURING "_APCLBDT_"-"_APCLEDT
 . S APCLFISC="Fiscal Year "_APCLFISC
 E  S APCLSTP=1
X2 Q
 ;
2 ; Date Range
ASKBD S %DT="AEX",%DT("A")="Enter beginning date: " D ^%DT G:X=U X3 S APCLBDT=Y I Y<0 G ASKBD
ASKED S %DT="AEX",%DT("A")="Enter ending date: " D ^%DT G:X=U X3 S APCLEDT=Y I Y<0,X]"" G ASKED
 I APCLBDT>APCLEDT!(APCLEDT>DT) W !,"Beginning and ending dates must be prior to today, and beginning date",!,"must precede ending date.",! G ASKBD
X3 I $G(X)=U!'$D(APCLBDT)!'$D(APCLEDT) S APCLSTP=1
 E  D
 . S Y=APCLBDT D DD^%DT S APCLBDT=Y
 . S (APCLED,Y)=APCLEDT D DD^%DT S APCLEDT=Y
 . S APCLDATE=";DURING "_APCLBDT_"-"_APCLEDT
 Q
 ;
ASK ; Get patient name or cohort
 ;
 K APCLPT
 R:'$D(APCLPTS) !,"Enter patient or [search template name: ",X:DTIME
 R:$D(APCLPTS) !,"Enter ANOTHER patient or [search template name: ",X:DTIME
 ;R !,"Enter patient or [search template name: ",X:DTIME
 I "^"[X S APCLSTP=1 G X1
 I $E(X)'="[" S APCLPT=""
 E  S X=$E(X,2,99)
 I '$D(APCLPT) S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)"
 S DIC=$S($D(APCLPT):"^DPT(",1:"^DIBT("),DIC(0)="EQM" D ^DIC K DIC
 I Y=-1 G ASK
 I $D(APCLPT) S ^TMP("APCLPTS",$J,+Y)="",APCLPTS=1
 E  F APCLPD=0:0 S APCLPD=$O(^DIBT(+Y,1,APCLPD)) Q:'APCLPD  S ^TMP("APCLPTS",$J,APCLPD)=""
 K APCLPT
X1 Q
 ;
ZTM ;PEP - CALLED FROM BDM - ENTRY POINT - for taskman
 U IO
 S (APCLSTP,APCLEPIN)=0
 S APCLASK="" ; Lets ^APCLPRT know that it is called by this routine
 K ^TMP("APCL",$J),^TMP("APCLCUML",$J),^TMP("APCLEPI",$J)
 S APCLROOT="^TMP(""APCL"",$J)"
 F APCLPD=0:0 S APCLPD=$O(^TMP("APCLPTS",$J,APCLPD)) Q:'APCLPD!APCLSTP  D  K ^TMP("APCL",$J)
 .I $P(^APCLRPT(APCLDFN,0),U,3)]"" D @("^"_$P(^(0),U,3))
 .I APCLPREP'=3,APCLPREP'=4 D EN^APCLPRT(APCLDFN,APCLROOT,APCLPD)
 .I APCLPREP=4 D EPIREC
 I APCLPREP'=2,APCLPREP'=4,APCLCUML,$D(^APCLRPT(APCLCUML)),$D(^TMP("APCLCUML",$J)),'APCLSTP D:$P(^APCLRPT(APCLCUML,0),U,3)]"" @("^"_$P(^(0),U,3)) S APCLROOT="^TMP(""APCLCUML"",$J)" D EN^APCLPRT(APCLCUML,APCLROOT)
 I APCLPREP=4 D WRITEF^APCLDM
 K ^TMP("APCLCUML",$J),^TMP("APCLPTS",$J),^TMP("APCLEPI",$J)
 I $D(ZTQUEUED) S ZTREQ="@" D EOJ
 I '$D(ZTQUEUED) D ^%ZISC
 Q
 ;
TASK ; Task?
 K IOP,%ZIS S %ZIS="PQM" D ^%ZIS I POP S IO=IO(0)
 Q
 ;
QUE K ZTSAVE,ZTSK
 NEW % F %="APCLSTP","APCLDMRG","APCLPREP","APCLPD","APCLPT","APCLBDT","APCLEDT","APCLDATE","APCLFISC","APCLTDTE","APCLDFN","APCLCUML","APCLFILE","APCLED","^TMP(""APCLPTS"",$J,","DUZ(" S ZTSAVE(%)=""
 S ZTRTN="ZTM^APCLASK",ZTDESC=$P(^APCLRPT(APCLDFN,0),U)_" REPORT",ZTIO=ION,ZTDTH="" S:$D(IOCPU) ZTCPU=IOCPU
 D ^%ZTLOAD
 D HOME^%ZIS
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK,ZTCPU
 I $D(IOF) W @IOF
 E  W !
 Q
 ;
EPIREC ;create epi info record in ^TMP("APCLEPI",$J,n)
 S X=$$REC^APCLDM(APCLPD,"DM AUDIT EPI INFO REC 1"),APCLEPIN=APCLEPIN+1,^TMP("APCLEPI",$J,APCLEPIN)=X
 S X=$$REC^APCLDM(APCLPD,"DM AUDIT EPI INFO REC 2"),APCLEPIN=APCLEPIN+1,^TMP("APCLEPI",$J,APCLEPIN)=X
 S X=$$REC^APCLDM(APCLPD,"DM AUDIT EPI INFO REC 3"),APCLEPIN=APCLEPIN+1,^TMP("APCLEPI",$J,APCLEPIN)=X
 Q
FLAT ;
 S APCLFILE=""
 S DIR(0)="F^3:8",DIR("A")="Enter the name of the FILE to be Created (3-8 characters)" K DA D ^DIR K DIR
 I $D(DIRUT) S APCLSTP=1 Q
 I X'?1.8AN W !!,"Invalid format, must be letters and numbers",! G FLAT
 S APCLFILE=$$LOW^XLFSTR(Y)_".rec"
 W !!,"I am going to create a file called ",APCLFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",APCLFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"The records that are generated and placed in file ",APCLFILE
 W !,"are in a format readable by EPI INFO.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S APCLSTP=1 Q
 I 'Y S APCLSTP=1 Q
 Q
CLEAN ;
 K APCLPD,APCLPT,^TMP("APCLPTS",$J),APCLPREP,APCLPTS,APCLEPIN
 Q
 ;
EOJ ;
 I IO'=IO(0) D ^%ZISC
 K APCLFISC,APCLPD,APCLPT,APCLDATE,APCLSTP,APCLDTE,APCLEDT,APCLBDT,APCLTDTE,APCLDFN,APCLROOT,^TMP("APCLPTS",$J),APCLASK,AUPNSEX,AUPNPAT,AUPNDAYS,AUPNSEX,AUPNDOD,AUPNDOB,APCLPREP,APCLEPIN,APCLED,APCLMAM,APCLED,APCLBD,APCLUED,ZTCPU
 K APCLHTKI,APCLRXC1
 Q
 ;
