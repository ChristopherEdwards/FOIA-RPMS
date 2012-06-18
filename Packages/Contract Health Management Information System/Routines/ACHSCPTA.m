ACHSCPTA ; IHS/ITSC/PMF - QUEUE CHS CPT CODE REPORT-SUMMARY ONLY ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 K ^TMP("ACHSCPT",$J)
 S ACHSUSR=$$USR^ACHS,ACHSFAC=DUZ(2)
 W !!!?15,"***** CPT Code Summary for ",$P($G(^DIC(4,ACHSFAC,0)),U)," *****",!
CPTCODE ;
 K ACHSCODE
 S Y=$$DIR^XBDIR("Y","Summary for ALL CPT CODES","YES","","","",1)
 I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) D END Q
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
 S ACHSEND=$$DIR^XBDIR("D^:NOW:EX","Enter the ENDING DATE OF SERVICE",$$FMTE^XLFDT(DT),"","",1)
 G SELBEG:$D(DUOUT),END:$D(DIROUT)!$D(DTOUT)
 G:$$EBB^ACHS(ACHSBEG,ACHSEND) SELEND
DEVICE ;Device Selection
 W *7,!!?20,"This report may take awhile to compile.",!?15," It is recommended that you QUEUE to a PRINTER.",!
 K DIR
 S %=$$PB^ACHS
 I %=U!$D(DTOUT)!$D(DUOUT) D END Q
 I %="B" D VIEWR^XBLM("^ACHSCPTB"),EN^XBVK("VALM"),END Q
 S %ZIS="PQ"
 D ^%ZIS
 I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED" S DIR(0)="E" D ^DIR D HOME^%ZIS G END:Y=0,CPTCODE:Y=1
 I '$D(IO("Q")) W:'$D(IO("S")) ! D:'$D(IO("S")) WAIT^DICD G ^ACHSCPTB
ZTLOAD ;Loads Taskman
 S ZTRTN="^ACHSCPTB",ZTIO="",ZTDESC="CPT SUMMARY REPORT",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL
 F %="ACHSFAC","ACHSUSR","ACHSQIO","ACHSCODE(","ACHSBEG","ACHSEND" S ZTSAVE(%)=""
 D ^%ZTLOAD
 K IO("Q"),ZTSK
 D HOME^%ZIS
END ;
 K DIR,DIROUT,DTOUT,DUOUT,Y,C,I
 D EN^XBVK("ACHS"),^ACHSVAR,HOME^%ZIS
 Q
 ;
