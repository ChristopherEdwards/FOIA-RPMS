AUMDODEV ; IHS/OIRM/DSD/JCM,AEF - ICD UPDATE DEVICE SELECTOR ;  [ 12/03/1998   2:35 PM ]
 ;;99.1;ICD UPDATE;;DEC 03, 1998
 W !,"ENTRY NOT PERMITTED HERE (^AUMODDEV)" Q
 ;
EN ; ENTRY POINT FROM PGRMODE+2^AUMDO
 D ^XBKVAR ; GET KERNEL VARIABLES
 W !!,"AUMDO may be run in the foreground or background (TASKMAN).",!!,"If you ""Q"" your output, AUMDO will be run in background (TASKMAN)."
 W !!,"It is strongly recommended to select a printer device",!,?10,"or use an ""AUX"" printer on this terminal.",!
 K IO("Q") S %ZIS="QMP" D ^%ZIS
 I $D(IO("Q")) S ZTIO=ION,ZTRTN="EN^AUMDO",ZTDESC="AUMDO - ICD UPDATE UTILITY",ZTDTH="" D ^%ZTLOAD D ^%ZISC
 K ZTIO,ZTRTN,ZTDESC,ZTDTH,ZTSK
 Q
