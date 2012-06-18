ACHSCPTD ; IHS/ITSC/PMF - QUEUE CHS CPT CODE REPORT-BY VENDOR ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 K ^TMP("ACHSCPT",$J)
 S ACHSUSR=$$USR^ACHS
 W !!!!,$$C^XBFUNC("***** CPT Code Summary for "_$$LOC^ACHS_" *****",80)
 S ACHSFAC=DUZ(2)
VENDOR ;
 K ACHSVNDR
 S Y=$$DIR^XBDIR("Y","CPT Code Report for ALL VENDORS","YES","","","",1)
 G END:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 I Y=1 S ACHSVNDR(0)="ALL" G CPTCODE
SELVNDR ;
 S ACHSVEN=+$$DIR^XBDIR("P^AUTTVNDR(:EMQZ","Enter VENDOR","","","","",1)
 G VENDOR:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)
CPTCODE ;
 K ACHSCODE
 S Y=$$DIR^XBDIR("Y","Summary for ALL CPT CODES","YES","","","",1)
 G VENDOR:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)
 I Y=1 S ACHSCODE(0)="ALL" G DOS
HELP ;
 W *7,*7,!!?8,$$REPEAT^XLFSTR("*",20)
 W " SELECTING CPT CODES ",$$REPEAT^XLFSTR("*",20)
 W !!?8,"1. You may enter '??' at any time for a list of valid codes."
 W !?8,"2. You may enter CPT CODES by NAME or NUMBER."
 W !?8,"3. You may enter from 1 to 10 CPT CODES."
 W !?8,"4. Press <RETURN> to terminate the selection process."
 W !?8,"5. Enter '^^' at any prompt to EXIT THIS PROGRAM."
 W *7,*7,!!?8,$$REPEAT^XLFSTR("*",61)
 W !!
 S ACHS=0
 K DIR
ENTCODE ;
 S DIR(0)="PO^ICPT(:EMZQ",DIR("A")="Enter CPT CODE"
 D ^DIR
 G DOS:$D(DIRUT)&$D(ACHSCODE),CPTCODE:$D(DUOUT),END:$D(DTOUT)!$D(DIROUT)
 I ACHS=10 W *7,*7,!!?15,"That's 10!" G DOS
 S ACHS=ACHS+1
 S:+Y>0 ACHSCODE(+Y)=""
 I '$D(ACHSCODE),+Y'>0 W *7,!!?22,"At least one entry is required.",!?10,"Please select a CPT CODE or enter '^^' to exit this program.",! K ACHSCODE
 G ENTCODE
 ;
DOS ;Select Dates of Service
SELBEG ;
 S ACHSBEG=$$DIR^XBDIR("D^:NOW:EX","Enter the BEGINNING DATE OF SERVICE","","","","",1)
 G CPTCODE:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)
SELEND ;
 S ACHSEND=$$DIR^XBDIR("D^:NOW:EX","Enter the ENDING DATE OF SERVICE",$$FMTE^XLFDT(DT),"","","",1)
 G SELBEG:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)
 G:$$EBB^ACHS(ACHSBEG,ACHSEND) SELEND
REPTYP ;
 K DIR
 S DIR(0)="S^S:SUMMARY;D:DETAILED",DIR("B")="Summary",DIR("A")="     Report Type "
 S DIR("?",1)="Enter 'S' or <RETURN> for a 'SUMMARY' report which includes"
 S DIR("?",2)="VENDOR NAME, CPT CODE, TOTALS, and PERCENTAGES ONLY."
 S DIR("?",3)="Enter 'D' for a 'DETAILED' report which also includes"
 S DIR("?")="DATES of SERVICE and WORKLOAD DATA."
 D ^DIR
 G SELBEG:$D(DUOUT),END:$D(DTOUT),END:$D(DIROUT)
 S ACHSRTYP=Y
DEVICE ;Device Selection
 W *7,!!?20,"This report may take awhile to compile.",!?15," It is recommended that you QUEUE to a PRINTER.",!
 K DIR
 S %=$$PB^ACHS
 I %=U!$D(DTOUT)!$D(DUOUT) D END Q
 I %="B" D VIEWR^XBLM($S(ACHSRTYP="S":"^ACHSCPTE",1:"^ACHSCPTG")),EN^XBVK("VALM"),END Q
 S %ZIS="PQ"
 D ^%ZIS
 I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED" S DIR(0)="E" D ^DIR D HOME^%ZIS G END:Y=0,VENDOR:Y=1
 I '$D(IO("Q")) W:'$D(IO("S")) ! D:'$D(IO("S")) WAIT^DICD G ^ACHSCPTE:ACHSRTYP="S",^ACHSCPTG
 I $D(IO("S"))!($E(IOST)'="P") G DEVICE
ZTLOAD ;Loads Taskman
 S ZTRTN=$S(ACHSRTYP="S":"^ACHSCPTE",ACHSRTYP="D":"^ACHSCPTG"),ZTIO="",ZTDESC="COMPILE CPT SUMMARY REPORT",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL
 F %="ACHSFAC","ACHSVNDR(","ACHSVEN","ACHSUSR","ACHSQIO","ACHSSER","ACHSRTYP","ACHSCODE(","ACHSBEG","ACHSEND" S ZTSAVE(%)=""
 D ^%ZTLOAD
 K IO("Q"),ZTSK
 D HOME^%ZIS
END ;
 K I,C,DIR,DIROUT,DIRUT,DTOUT,DUOUT
 D EN^XBVK("ACHS"),^ACHSVAR,HOME^%ZIS
 Q
 ;
