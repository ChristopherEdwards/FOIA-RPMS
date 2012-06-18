ACDWQ ;IHS/ADC/EDE/KML - Q-LOG FOR 5 DRIVER SET REPORTS; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;******************************************************
 ;//^ACDWDRV*
 ;Needs ASA* all variables
 ;**************************************************************
DEBUG D DBQUE Q
 W !!,"You should queue all reports to a printer.",!
 S ACDNOQUE=1
 K IO("Q"),%ZIS,IOP,ZTDTH,ZTSAVE,ZTSK S ACDJBN=$J
 S %ZIS="PQ",%ZIS("B")=""
 D ^%ZIS
 Q:POP
XXX I $E(IOST,1,2)'="P-" W !,"YOU MUST ROUTE THE OUTPUT OF THIS REPORT TO A PRINTER",! D ^%ZISC S POP=1 D PAUSE^ACDDEU Q
 ;I IO=IO(0) D HUH I 'Y S POP=1 Q
 Q:'$D(IO("Q"))
 S ZTIO=ION,ACDZTIO=ION S:$G(IOCPU) ZTCPU=IOCPU S ZTSAVE("ACD*")="",ZTSAVE("DUZ(")=""
 S ZTRTN=$S($D(ACDWSTAF(1)):"L^ACDWSTAF",$D(ACDWDRV(1)):"L^ACDWDRV1",$D(ACDWDRV(2)):"L^ACDWDRV2",$D(ACDWDRV(3)):"L^ACDWDRV3",$D(ACDWDRV(4)):"L^ACDWDRV4",1:"L^ACDWDRV5")
 D ^%ZTLOAD
 W !,"Report Queued.."
 D ^ACDWK
 Q
 ;
HUH ; SEE IF USER REALLY WANT TO GO TO HOME DEVICE
 K DIR
 W !,"You have selected your terminal for the ouput of this report."
 W !,"If you hat out at the end of a page you will be logged off the system."
 W !,"Do you want to continue?",!
 S DIR(0)="YO",DIR("B")="N" K DA D ^DIR K DIR
 Q
NOTE ;************************************************************
 ;To convert to double queue
 ;ACDJBN=JOB#
 ;ACDZTIO=ION
 ;ZTIO="" (wake up from first queue in background -no device)
 ;ZTCPU is passed to %ZTLOAD incase device selected is on a
 ;      different CPU (No need to ZTSAVE("^TMP(""ASA"",$J,") anymore.
 ;Wake up from first queue and compile.
 ;Queue again setting ZTIO=ACDZTIO this time.
 ;Use ACDJBN when oedering through print utility because $J changed
DBQUE ;
 D INIT
 D XBQUE
 Q
 ;
INIT ;
 S ACDJOB=$J
 F  D  Q:ACDBT]""
 . S ACDBT=$H
 . LOCK +^TMP("ACD",ACDJOB,ACDBT):1
 . E  S ACDBT=""
 . Q
 K ^TMP("ACD",ACDJOB,ACDBT)
 Q
 ;
XBQUE ;call to XBDBQUE
 K ACDOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S ACDQUIT=1 Q
 S ACDOPT=Y
 S XBRC=$S($D(ACDWSTAF(1)):"L^ACDWSTAF",$D(ACDWDRV(1)):"L^ACDWDRV1",$D(ACDWDRV(2)):"L^ACDWDRV2",$D(ACDWDRV(3)):"L^ACDWDRV3",$D(ACDWDRV(4)):"L^ACDWDRV4",1:"L^ACDWDRV5")
 S XBRX=$S($D(ACDWSTAF(1)):"EOJ^ACDWSTAF",$D(ACDWDRV(1)):"EOJ^ACDWDRV1",$D(ACDWDRV(2)):"EOJ^ACDWDRV2",$D(ACDWDRV(3)):"EOJ^ACDWDRV3",$D(ACDWDRV(4)):"EOJ^ACDWDRV4",1:"EOJ^ACDWDRV5")
 S XBRP=$S($D(ACDWSTAF(1)):"P^ACDWSTAF",$D(ACDWDRV(1)):"P^ACDWDRV1",$D(ACDWDRV(2)):"P^ACDWDRV2",$D(ACDWDRV(3)):"P^ACDWDRV3",$D(ACDWDRV(4)):"P^ACDWDRV4",1:"P^ACDWDRV5")
 S XBNS="ACD"
 I $G(ACDOPT)="B" S XBIOP=0,XBRP="VIEWR^XBLM("""_XBRP_""")"
 D ^XBDBQUE
 Q
