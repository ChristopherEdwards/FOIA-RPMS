ACHS3PPQ ; IHS/ITSC/TPF/PMF - QUEUE THIRD PARTY PAYMENT REPORT (ALL PATIENTS) ;  
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**16**;JUN 11, 2001
 ;
 K ^TMP("ACHS3PP",$J)
 ;
 S ACHSUSR=$$USR^ACHS          ;GET USER BASED ON VA(200 ENTRY
 ;
 W !!!!,$$C^XBFUNC("****** 3rd PARTY PAYMENT REPORT FOR "_$$LOC^ACHS_" *****",80)
 S ACHSFAC=DUZ(2)
 ;
FISYR ;Select Fiscal Year
 ;
 S ACHSFY=$$FYSEL^ACHS          ;FISCAL YEAR SELECTION
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) D END Q
 ;
SELSER ;Select type of service
 ;
 K DIR,DIC,ACHSSER
 ;
 S DIR("A")="Service Type",DIR(0)="S^1:43 (HOSPITAL);2:57 (DENTAL);3:64 (OUTPATIENT);4:ALL" S DIR("B")="ALL"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) D END Q
 G FISYR:$D(DUOUT)
 S ACHSSER=Y
 ;
SELPAT ;Patient Selection
 K DIR,ACHSPAT
 S DIR(0)="Y",DIR("A")="Include ALL PATIENTS",DIR("B")="YES"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) D END Q
 G SELSER:$D(DUOUT)
 I Y=1 S ACHSPAT(0)="" G REPTYP
 W !
DIR2 ;
 W !
 K DIC
 S DIC="^AUPNPAT(",DIC(0)="AEQM"
 D ^DIC
 I +Y<1,'$D(ACHSPAT) G END
 I +Y<1,$D(ACHSPAT) G REPTYP
 S:+Y>0 ACHSPAT(+Y)=""
 G DIR2
 ;
REPTYP ;
 K DIR
 ;ACHS*3.1*16 IHS.OIT.FCJ ADDED D AND T TO NXT SECTION
 ;S DIR(0)="S^S:SUMMARY;D:DETAILED",DIR("B")="Summary",DIR("A")="     Report Type "
 S DIR(0)="S^S:SUMMARY;D:DETAILED"
 S:$D(ACHSPAT(0)) DIR(0)=DIR(0)_";T:THIRD PARTY;P:THIRD PARTY DETAILED"
 S DIR("B")="Summary",DIR("A")="     Report Type "
 S DIR("?",1)="Enter 'S' or <RETURN> for a 'SUMMARY' report with Totals and Percentages Only."
 S:$D(ACHSPAT(0)) DIR("?",2)="Enter 'D' for a detailed report which contains a list of PO information."
 S:$D(ACHSPAT(0)) DIR("?",3)="Enter 'T' for a Report that contains Totals by Third Party payor."
 S DIR("?")="Enter 'P' for a report that contains PO information by Third Party Payor."
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) D END Q
 G SELPAT:$D(DUOUT)
 S ACHSRTYP=Y
DEVICE ;Device Selection
 W *7,!!?20,"This report may take awhile to compile.",!?9," It is recommended that you QUEUE your output to a PRINTER.",!
 K DIR
 S %=$$PB^ACHS                        ;PRINT OR BROWSE PROMPT
 I %=U!$D(DTOUT)!$D(DUOUT) D END Q
 ;
 ;         DISPLAY PRINTOUT OF RTN? ,  KILL VALM* NAMESPACE VARS
 I %="B" D VIEWR^XBLM("^ACHS3PPC"),EN^XBVK("VALM"),END Q
 ;
 ;
 S %ZIS="PQ"
 D ^%ZIS
 I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED" D HOME^%ZIS G END:'$$DIR^XBDIR("E"),FISYR
 ;
 ;                               ;IF SLAVE COMPILE CHS THIRD PARTY
 ;                               ;PAYMENT (ALL PATIENTS)
 I '$D(IO("Q")) W:'$D(IO("S")) ! D:'$D(IO("S")) WAIT^DICD G ^ACHS3PPC
 ;
ZTLOAD ;Loads Taskman
 S ZTRTN="^ACHS3PPC",ZTIO="",ZTDESC="3RD PARTY PAYMENT REPORT",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL
 F %="ACHSPAT(","ACHSFY","ACHSUSR","ACHSQIO","ACHSSER","ACHSFAC","ACHSCFY","ACHSFYWK","ACHSRTYP" S ZTSAVE(%)=""
 D ^%ZTLOAD
 K IO("Q")
 D HOME^%ZIS
END ;
 K DIC,DIR,DIROUT,DTOUT,DUOUT,ZTSK
 D EN^XBVK("ACHS"),^ACHSVAR,HOME^%ZIS
 Q
 ;
