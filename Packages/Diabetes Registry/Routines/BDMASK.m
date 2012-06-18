BDMASK ; IHS/CMI/LAB -GET PATIENT OR COHORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;CMI/TUCSON/LAB - patch 3 - 10/26/1998 Y2K fixes
 ;The above line will be changed to be nonparameter as of the
 ;next version of this package.  All callers should enter this
 ;routine at entry point START1^BDMASK(,,,)
 G START2
 ;
START1(BDMDFN,BDMCUML) ;EP
 ;
START2 ;PEP PUBLISHED ENTRY POINT - called to create a report template
 I 'BDMDFN W !,*7,"Report template entry not indicated!" H 2 Q
 I '$D(^BDMRPT(BDMDFN)) W !,*7,"Indicated patient/cohort report template entry does not exist!" H 2 Q
 I '$D(BDMCUML) S BDMCUML=0
 I BDMCUML,'$D(^BDMRPT(BDMCUML)) W !,*7,"Indicated cumulative report entry does not exist!" H 2 Q
 I '$D(DTIME) D ^XBKVAR
GETTIME S BDMSTP=0 D TIME G:BDMSTP X
START K ^TMP("BDMPTS",$J) F  D ASK Q:BDMSTP
 I '$D(^TMP("BDMPTS",$J))!(X["^") D CLEAN K BDMBDT,BDMEDT,BDMDATE,BDMFISC G GETTIME
 S BDMSTP=0
 K DIR S DIR(0)="S^1:Print Both Individual and Cumulative Reports;2:Print Individual Reports Only;3:Print Cumulative Report Only;4:Create EPI INFO file",DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G START
 S BDMPREP=Y
 I BDMPREP=4 D FLAT Q:BDMSTP
 D TASK I $D(IO("Q")) K IO("Q") D QUE G AGIN
 I 'POP S BDMSTP=0 D ZTM
AGIN D CLEAN S BDMSTP=0 G START
X D EOJ
 Q
 ;
TIME ;PEP - CALLED FROM BDM Get fiscal year or time frame
 S Y=DT D DD^%DT S BDMTDTE=Y
 S DIR(0)="SO^1:Fiscal Year;2:Date Range",DIR("A")="Indicate the desired time frame" D ^DIR K DIR
 I '$D(DTOUT),'$D(DIRUT),'$D(DIROUT),Y W ! D @Y I 1
 E  S BDMSTP=1
 Q
 ;
1 ; Fiscal Year
 S DIR(0)="DA",DIR("A")="Enter report fiscal year: " D ^DIR K DIR
 I '$D(DTOUT),'$D(DIRUT),'$D(DIROUT) S BDMFISC=$S($E(Y)=2:19,1:20)_$E(Y,2,3) D
 . ;beginning Y2K CMI/TUCSON/LAB
 . ;I BDMFISC=2000 S BDMBDT=2991001,BDMEDT=2000930 ;Y2000
 . ;E  S BDMBDT=$E(Y,1,3)-1_1001,BDMEDT=$E(Y,1,3)_"0930"
 . S BDMBDT=$E(Y,1,3)-1_1001,BDMEDT=$E(Y,1,3)_"0930" ;Y2000
 . ;end Y2K CMI/TUCSON/LAB
 . S Y=BDMBDT D DD^%DT S BDMBDT=Y
 . S (BDMED,Y)=BDMEDT D DD^%DT S BDMEDT=Y
 . S BDMDATE=";DURING "_BDMBDT_"-"_BDMEDT
 . S BDMFISC="Fiscal Year "_BDMFISC
 E  S BDMSTP=1
X2 Q
 ;
2 ; Date Range
ASKBD S %DT="AEX",%DT("A")="Enter beginning date: " D ^%DT G:X=U X3 S BDMBDT=Y I Y<0 G ASKBD
ASKED S %DT="AEX",%DT("A")="Enter ending date: " D ^%DT G:X=U X3 S BDMEDT=Y I Y<0,X]"" G ASKED
 I BDMBDT>BDMEDT!(BDMEDT>DT) W !,"Beginning and ending dates must be prior to today, and beginning date",!,"must precede ending date.",! G ASKBD
X3 I $G(X)=U!'$D(BDMBDT)!'$D(BDMEDT) S BDMSTP=1
 E  D
 . S Y=BDMBDT D DD^%DT S BDMBDT=Y
 . S (BDMED,Y)=BDMEDT D DD^%DT S BDMEDT=Y
 . S BDMDATE=";DURING "_BDMBDT_"-"_BDMEDT
 Q
 ;
ASK ; Get patient name or cohort
 ;
 K BDMPT
 R:'$D(BDMPTS) !,"Enter patient or [search template name: ",X:DTIME
 R:$D(BDMPTS) !,"Enter ANOTHER patient or [search template name: ",X:DTIME
 ;R !,"Enter patient or [search template name: ",X:DTIME
 I "^"[X S BDMSTP=1 G X1
 I $E(X)'="[" S BDMPT=""
 E  S X=$E(X,2,99)
 I '$D(BDMPT) S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)"
 S DIC=$S($D(BDMPT):"^DPT(",1:"^DIBT("),DIC(0)="EQM" D ^DIC K DIC
 I Y=-1 G ASK
 I $D(BDMPT) S ^TMP("BDMPTS",$J,+Y)="",BDMPTS=1
 E  F BDMPD=0:0 S BDMPD=$O(^DIBT(+Y,1,BDMPD)) Q:'BDMPD  S ^TMP("BDMPTS",$J,BDMPD)=""
 K BDMPT
X1 Q
 ;
ZTM ;PEP - CALLED FROM BDM - ENTRY POINT - for taskman
 U IO
 S (BDMSTP,BDMEPIN)=0
 S BDMASK="" ; Lets ^BDMPRT know that it is called by this routine
 K ^TMP("BDM",$J),^TMP("BDMCUML",$J),^TMP("BDMEPI",$J)
 S BDMROOT="^TMP(""BDM"",$J)"
 F BDMPD=0:0 S BDMPD=$O(^TMP("BDMPTS",$J,BDMPD)) Q:'BDMPD!BDMSTP  D  K ^TMP("BDM",$J)
 .I $P(^BDMRPT(BDMDFN,0),U,3)]"" D @("^"_$P(^(0),U,3))
 .I BDMPREP'=3,BDMPREP'=4 D EN^BDMPRT(BDMDFN,BDMROOT,BDMPD)
 .I BDMPREP=4 D EPIREC
 I BDMPREP'=2,BDMPREP'=4,BDMCUML,$D(^BDMRPT(BDMCUML)),$D(^TMP("BDMCUML",$J)),'BDMSTP D:$P(^BDMRPT(BDMCUML,0),U,3)]"" @("^"_$P(^(0),U,3)) S BDMROOT="^TMP(""BDMCUML"",$J)" D EN^BDMPRT(BDMCUML,BDMROOT)
 I BDMPREP=4 D WRITEF^BDMDM
 K ^TMP("BDMCUML",$J),^TMP("BDMPTS",$J),^TMP("BDMEPI",$J)
 I $D(ZTQUEUED) S ZTREQ="@" D EOJ
 I '$D(ZTQUEUED) D ^%ZISC
 Q
 ;
TASK ; Task?
 K IOP,%ZIS S %ZIS="PQM" D ^%ZIS I POP S IO=IO(0)
 Q
 ;
QUE K ZTSAVE,ZTSK
 NEW % F %="BDMSTP","BDMDMRG","BDMPREP","BDMPD","BDMPT","BDMBDT","BDMEDT","BDMDATE","BDMFISC","BDMTDTE","BDMDFN","BDMCUML","BDMFILE","BDMED","^TMP(""BDMPTS"",$J,","DUZ(" S ZTSAVE(%)=""
 S ZTRTN="ZTM^BDMASK",ZTDESC=$P(^BDMRPT(BDMDFN,0),U)_" REPORT",ZTIO=ION,ZTDTH="" S:$D(IOCPU) ZTCPU=IOCPU
 D ^%ZTLOAD
 D HOME^%ZIS
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTSK,ZTCPU
 I $D(IOF) W @IOF
 E  W !
 Q
 ;
EPIREC ;create epi info record in ^TMP("BDMEPI",$J,n)
 S X=$$REC^BDMDM(BDMPD,"DM AUDIT EPI INFO REC 1"),BDMEPIN=BDMEPIN+1,^TMP("BDMEPI",$J,BDMEPIN)=X
 S X=$$REC^BDMDM(BDMPD,"DM AUDIT EPI INFO REC 2"),BDMEPIN=BDMEPIN+1,^TMP("BDMEPI",$J,BDMEPIN)=X
 S X=$$REC^BDMDM(BDMPD,"DM AUDIT EPI INFO REC 3"),BDMEPIN=BDMEPIN+1,^TMP("BDMEPI",$J,BDMEPIN)=X
 Q
FLAT ;
 S BDMFILE=""
 S DIR(0)="F^3:8",DIR("A")="Enter the name of the FILE to be Created (3-8 characters)" K DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I X'?1.8AN W !!,"Invalid format, must be letters and numbers",! G FLAT
 S BDMFILE=$$LOW^XLFSTR(Y)_".rec"
 W !!,"I am going to create a file called ",BDMFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",BDMFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"The records that are generated and placed in file ",BDMFILE
 W !,"are in a format readable by EPI INFO.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I 'Y S BDMSTP=1 Q
 Q
CLEAN ;
 K BDMPD,BDMPT,^TMP("BDMPTS",$J),BDMPREP,BDMPTS,BDMEPIN
 Q
 ;
EOJ ;
 I IO'=IO(0) D ^%ZISC
 K BDMFISC,BDMPD,BDMPT,BDMDATE,BDMSTP,BDMDTE,BDMEDT,BDMBDT,BDMTDTE,BDMDFN,BDMROOT,^TMP("BDMPTS",$J),BDMASK,AUPNSEX,AUPNPAT,AUPNDAYS,AUPNSEX,AUPNDOD,AUPNDOB,BDMPREP,BDMEPIN,BDMED,BDMMAM,BDMED,BDMBD,BDMUED,ZTCPU
 K BDMHTKI,BDMRXC1
 Q
 ;
