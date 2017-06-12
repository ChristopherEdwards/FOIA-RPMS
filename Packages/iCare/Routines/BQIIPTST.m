BQIIPTST ;GDIT/HS/ALA-IPC Routine for Testing ; 29 Nov 2011  2:23 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
 ;
EN ;EP
 NEW PROD,DIRUT,DUOUT
 S PROD=$$PROD^XUPROD()
 I PROD D  Q
 . D EN^DDIOL("This is a PRODUCTION account.  You cannot run this program.","","!!?8")
 NEW DIR,X,Y,DATE,BQDT
 S DIR("A")="Enter Month and Year"
 S DIR("A",1)="Remember that the CRS measures will only aggregate based on what their"
 S DIR("A",2)="current values are since the Nightly or Weekly job has run."
 S DIR(0)="D^3130100:"_$E(DT,1,5)_"00"_":EM"
 D ^DIR
 I $G(DIRUT)="^"!($G(DUOUT)="^")!(Y="^") Q
 S DATE=Y,BQDT=Y(0)
 D EN^DDIOL("Running . . . for "_BQDT,"","!!?12")
 D EN^BQIIPMON(DATE)
 D EN^DDIOL("Done . . .","","!!?12")
 Q
 ;
BEG ;EP
 NEW ZTDESC,%ZIS,ZTIO,ZTSK
 S ZTDESC="MISMATCHED PROVIDER REPORT",ZTRTN="RPT^BQIIPTST"
 S %ZIS="QM" D ^%ZIS Q:POP
 I '$D(IO("Q")) K ZTDESC G @ZTRTN
 S ZTIO=ION,ZTSAVE("*")=""
 D ^%ZTLOAD
 Q
 ;
RPT ;EP - Report
 NEW BQIRUN,P,L,ABORT,CT,DFN,DSPM,DPCP
 S BQIRUN=$$HTE^XLFDT($H,1)
 S (P,L,ABORT,CT)=0
 U IO D HDR I $G(ABORT)=1 Q
 S DFN=0
 F  S DFN=$O(^AUPNPAT(DFN)) Q:'DFN  D  Q:$G(ABORT)=1
 . S DSPM=$$DPCP^BQIULPT(DFN)
 . I $G(^AUPNPAT(DFN,0))="" Q
 . S DPCP=$P(^AUPNPAT(DFN,0),U,14)
 . I $P(DSPM,U,1)=DPCP Q
 . I L+4>IOSL D HDR Q:$G(ABORT)=1
 . W !,$P($G(^DPT(DFN,0)),U,1),?40,$$HRNL^BQIULPT(DFN) S L=L+1
 . W !,?10,$S(DPCP'="":$P($G(^VA(200,DPCP,0)),U,1),1:""),?40,$S($P(DSPM,U,1)'="":$P(DSPM,U,2),1:"")
 . S L=L+1
 . I L+4>IOSL D HDR Q:$G(ABORT)=1
 ;
 I '$G(ABORT) W !,"<End of Report>" I $E(IOST,1,2)="C-" S DIR(0)="E" D ^DIR
 D ^%ZISC
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
HDR ; Header
 I $E(IOST,1,2)="C-",P S DIR(0)="E" D ^DIR I $G(DIRUT) S ABORT=1 Q
 I $E(IOST,1,2)="C-"!P W @IOF
 S P=P+1,L=5
 W "MISMATCHED PRIMARY CARE PROVIDERS",?90,"Run Date: ",BQIRUN,?124,"Page ",$J(P,3)
 W !,"Patient Name",?30,"HRNs"
 W !,?10,"Primary Care Provider",?40,"Designated PCP"
 W !,$TR($J(" ",IOM)," ","-"),!
 Q
 ;
FM ;EP - FileMan Report
 NEW DIC,FLDS,BY,FR,TO
 S DIC="^AUPNPAT("
 S FLDS="!.14"
 S BY="+.14",FR="",TO=""
 D EN1^DIP
 Q
