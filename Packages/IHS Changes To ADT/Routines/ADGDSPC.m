ADGDSPC ; IHS/ADC/PDW/ENM - PRINT DAY SURGERY VISITS W/ ICD CODES ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> get date range
 W @IOF,!!!?28,"DAY SURGERY VISITS WITH ICD CODES",!!
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S APCLBD=Y,APCLSD=APCLBD-1
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S APCLED=Y
 ;
SETVAR ;***> set variables for ^APCLYV3
 S APCLLOC=DUZ(2),APCLPROV=""
 K DIC S DIC=40.7,DIC(0)="M",X=44 D ^DIC
 I Y=-1 W !!,*7,"DAY SURGERY CODE 44 NOT IN CLINIC STOP FILE!",!! G END
 S APCLCL=+Y,APCLICD=1,(APCLBICD,APCLEICD)=""
 ;
 ;***> get print device
DEVICE S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q"))
 U IO G APCLYV3^ADGCALLS
QUE K IO("Q") S ZTRTN="APCLYV3^ADGCALLS",ZTDESC="CLINIC VISITS"
 F DGX="APCLED","APCLBD","APCLCL","APCLICD","APCLBICD","APCLEICD","APCLLOC","APCLPROV" S ZTSAVE(DGX)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K APCLBD,APCLED,APCLCL,APCLICD,APCLBICD,APCLEICD,APCLPROV,APCLLOC,DGX
 D HOME^%ZIS Q