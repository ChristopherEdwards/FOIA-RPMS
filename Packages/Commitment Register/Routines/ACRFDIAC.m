ACRFDIAC ;IHS/OIRM/DSD/THL,AEF - UTILITY TO CLEAN THE AUDIT FILE OF ARMS ENTRIES; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;UTILITY TO CLEAN THE AUDIT FILE OF ARMS ENTRIES
 ;;
EN D EN1
EXIT K ACR,ACR94
 Q
EN1 S IOP="HOME"
 D ^%ZIS
 D ^XBKVAR
 D HOME^ACRFMENU
 W @IOF
 W !!,"The AUDIT file will now be cleaned of all records greater than"
 W !,"90 days old."
 S DIR(0)="YO"
 S DIR("A")="Continue with this operations"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 S ACR94=$O(^DIC(9.4,"C","ACR",0))
 I 'ACR94 D  Q
 .W *7,*7
 .W !!,"The ARMS namespaced package was not found on this system."
 .W !,"NO Audit update will be done."
 .D PAUSE^ACRFWARN
 Q:$G(Y)'=1
 S X1=DT
 S X2=-90
 D C^%DTC
 S ACRDT=X
 S ACRFILE=0
 F  S ACRFILE=$O(^DIC(9.4,ACR94,4,"B",ACRFILE)) Q:'ACRFILE  D
 .W !,"File ",ACRFILE," being cheched."
 .S ACR=0
 .F  S ACR=$O(^DIA(ACRFILE,ACR)) Q:'ACR  D
 ..I $P(^DIA(ACRFILE,ACR,0),U,2)<ACRDT D
 ...S DA(1)=ACRFILE
 ...S DA=ACR
 ...S DIK="^DIA("_DA(1)_","
 ...D DIK^ACRFDIC
 ...W "."
 Q
