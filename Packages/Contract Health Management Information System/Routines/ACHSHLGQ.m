ACHSHLGQ ; IHS/ITSC/PMF - QUEUE CHS HOSPITAL LOG SUMMARY ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 Q  ; Under Development
 D ^ACHSVAR Q:'$D(^ACHSF(DUZ(2)))
 K ^TMP($J)
 S ACHSUSR=$$USR^ACHS,ACHSFAC=$$LOC^ACHS
 W !,$$C^XBFUNC("*************************************",80)
 W !,$$C^XBFUNC("* Queue HOSPITAL LOG for "_ACHSFAC_" "_"*",80)
 W !,$$C^XBFUNC("*  Enter '?' at any time for HELP."_"  "_"*",80)
 W !,$$C^XBFUNC("*************************************",80)
SELQBY ;Select method of report.
 K DIR,ACHSQBY,ACHSPAT,ACHSVNDR,ACHSDIAG,ACHSADM
 S DIR("A")="QUEUE HOSPITAL LOG BY",DIR(0)="S^P:PATIENT;S:STATUS TYPE;V:VENDOR;D:DIAGNOSIS",DIR("B")="PATIENT",DIR("?")="^D QBYHELP^ACHSHLPP"
 D ^DIR K DIR
 I $D(DIRUT)!$D(DIROUT) K ACHSQBY G END
 S ACHSQBY=$S("P,S,V,D"[Y:Y,1:"SELQBY")
 I ACHSQBY["S" S ACHSSTAT=""
 G @ACHSQBY
P ;Select individual or all patients
 S DIR("A")="Include ALL PATIENTS",DIR(0)="Y",DIR("B")="YES",DIR("?",1)="Enter 'Y' or <RETURN> to include all patients",DIR("?")="or enter 'N' to select an individual patient."
 W ! D ^DIR K DIR
 I $D(DIRUT) K ACHSPAT G SELQBY
 G END:$D(DIROUT)
 I Y=1 S ACHSPAT(0)="" G S
DICP W !! K DIC S DIC="^AUPNPAT(",DIC(0)="AEQM" D ^DIC K DIC
 I +Y<1,'$D(ACHSPAT) G END
 I +Y<1,$D(ACHSPAT) G S
 S:+Y>0 ACHSPAT(+Y)="" G DICP
V ; Select vendor or all vendors
 S DIR("A")="      S = SPECIFY VENDOR    A = ALL VENDORS",DIR(0)="SB^S:SPECIFIED VENDOR;A:ALL VENDORS",DIR("B")="ALL",DIR("?",1)="Enter 'A' or <RETURN> to include all vendors",DIR("?")="or enter 'S' to select a specific vendor."
 W ! D ^DIR K DIR
 I $D(DIRUT) K ACHSVNDR G SELQBY
 G END:$D(DIROUT)
 I Y="A" S ACHSVNDR(0)="" G S
DICV ; Lookup vendor if single vendor.
 W !!
 K DIC
 S DIC="^AUTTVNDR(",DIC(0)="AEQM"
 D ^DIC
 K DIC
 I +Y<1,'$D(ACHSVNDR) G END
 I +Y<1,$D(ACHSVNDR) G S
 S:+Y>0 ACHSVNDR(+Y)="" G DICV
D ; Select diagnosis or all diagnoses
 S DIR("A")="      S = SPECIFY DIAGNOSIS    A = ALL DIAGNOSES",DIR(0)="SB^S:SPECIFY DIAGNOSIS;A:ALL DIAGNOSIS",DIR("B")="ALL",DIR("?",1)="Enter 'A' or <RETURN> to include all diagnoses",DIR("?")="or enter 'S' to select a specific diagnosis."
 W ! D ^DIR K DIR
 I $D(DIRUT) K ACHSDIAG G SELQBY
 G END:$D(DIROUT)
 I Y="A" S ACHSDIAG(0)="" G S
DICD W !! K DIC S DIC="^ICD9(",DIC(0)="AEQM" D ^DIC K DIC
 I +Y<1,'$D(ACHSDIAG) G END
 I +Y<1,$D(ACHSDIAG) G S
 S:+Y>0 ACHSDIAG(+Y)="" G DICD
S ;Select active/non-active/scheduled/all
 K DIR,ACHSATYP
 S DIR("A")="STATUS TYPE",DIR(0)="S^A:Active (Current Inpatients);N:Non-Active (Discharged Patients);S:Scheduled Admissions (Est. DOS) **NOT USED WITH DIAG**;L:List All (of the above)",DIR("B")="List All"
 S DIR("?",1)="Enter 'A' to include current inpatient data only."
 S DIR("?",2)="Enter 'N' to include discharged patient data only."
 S DIR("?",3)="Enter 'S' to include scheduled admission data only. **NOT USED WITH DIAG**"
 S DIR("?")="Enter 'L' to include data on all of the above."
 W ! D ^DIR K DIR
 G END:$D(DIROUT),SELQBY:$D(DIRUT),END:$D(DTOUT),END:$D(DUOUT)
 I Y="S",$D(ACHSDIAG) W *7,*7,!!?5,"*** Scheduled Admissions is unavailable with the Diagnosis option ***" G S
 S ACHSATYP=Y
SELBEG ;Select beginning date
 S X1=DT,X2=365 D C^%DTC S ACHSMAX=X
 S DIR(0)=$S(ACHSATYP="A":"D^:DT:EX",ACHSATYP="N":"D^:DT:EX",ACHSATYP="S":"D^DT:"_ACHSMAX_":EX",ACHSATYP="L":"D^:DT:EX",1:"??")
 S DIR("A")="Enter the BEGINNING "_$S(ACHSATYP="A":"Active Date",ACHSATYP="N":"Discharge Date",ACHSATYP="S":"Estimated Date of Service",ACHSATYP="L":"date for all status types",1:"")
 W ! D ^DIR K DIR G S:$D(DUOUT),END:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)
 S ACHSBEG=Y,X1=DT,X2=365 D C^%DTC S ACHSMAX=X
SELEND ;Select ending date
 S DIR(0)=$S(ACHSATYP="A":"D^:DT:EX",ACHSATYP="N":"D^:DT:EX",ACHSATYP="S":"D^DT:"_ACHSMAX_":EX",ACHSATYP="L":"D^:DT:EX",1:"??")
 S DIR("A")="Enter the ENDING "_$S(ACHSATYP="A":"Active Date",ACHSATYP="N":"Discharge Date",ACHSATYP="S":"Estimated Date of Service",ACHSATYP="L":"date for all status types",1:"")
 W ! D ^DIR K DIR G SELBEG:$D(DUOUT),END:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)
 S ACHSEND=Y
REPTYP ;Choose Report Type
 S DIR(0)="S^S:SUMMARY;D:DETAILED",DIR("B")="Summary",DIR("A")="     Report Type ",DIR("B")="SUMMARY",DIR("?")="^D RPTHELP^ACHSHLPP"
 D ^DIR K DIR
 G SELBEG:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)!$D(DIRUT)
 S ACHSRTYP=Y
DEVICE ;Device Selection
 W *7,!!?20,"This report may take awhile to compile.",!?9," It is recommended that you QUEUE your output to a PRINTER.",!
 S %ZIS="PQ" D ^%ZIS
 I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED" S DIR(0)="E" D ^DIR K DIR
 D HOME^%ZIS G END:Y=0,SELQBY:Y=1
 I '$D(IO("Q")) W:'$D(IO("S")) ! D:'$D(IO("S")) WAIT^DICD G ^ACHSHLGC
 I $D(IO("S"))!($E(IOST)'="P") G DEVICE
ZTLOAD ; Load Taskman
 S ZTRTN="^ACHSHLGC",ZTIO="",ZTDESC="HOSPITAL LOG REPORT",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL
 F %="ACHSUSR","ACHSQIO","ACHSFAC(","ACHSSRCH","ACHSBEG","ACHSEND" S ZTSAVE(%)=""
 D ^%ZTLOAD K IO("Q"),ZTSK D HOME^%ZIS
END ; Kill vars, quit.
 K ACHSFAC,ACHSMAX,ACHSQIO,ACHSATYP,ACHSUSR,ACHSBEG,ACHSEND,ACHSSTAT
 K DIR,DIROUT,DIRUT,DTOUT,DUOUT
 Q
