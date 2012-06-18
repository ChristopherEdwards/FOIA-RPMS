APSPOST ;IHS/DSD/ENM - POST INIT UTILITY ROUTINE [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
EP ; This program calls 2 rtns to remove old opts and merge new ones
 D ^APSPOST8,^APSPOST9
 S ZTRTN="APSPOST1",ZTIO="",ZTDTH=$H,ZTDESC="Move IHS Site Parameters to APSP CTRL file" D ^%ZTLOAD K ZTSK
 W !,"IHS Site Parameters have been moved to the APSP CONTROL file!!",!!
 W !,"Please continue with the next phase of the installation! ",!
 Q
