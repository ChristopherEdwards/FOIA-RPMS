ACHSAUDD ; IHS/ITSC/PMF - TPF ACHS AUTO AUDIT PURGE ; [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;;
 ;;
 ;PURGE ALL DATA AUDIT ENTRIES FO ALL ACHS FILES
START ;
 ;LETS SET UP THE FROM TO DATES
 S (FROMTXT,X)="T-30" D ^%DT S FROM=Y-1,FROM=FROM_".99999"
 S (TOTXT,X)="T" D ^%DT S TO=Y
 ;
 ;LETS GO THRU ALL CHS DATA NAMES
 ;
 S U="^"
 S ACHSFNAM="CHS "
 F  S ACHSFNAM=$O(^DIC("B",ACHSFNAM)) Q:ACHSFNAM=""!($E(ACHSFNAM,1,3)'="CHS")  D
 .S ACHSFNUM=$O(^DIC("B",ACHSFNAM,""))
 .Q:ACHSFNUM=""
 .W !,ACHSFNAM
 .D PURGE
 Q
PURGE ;
 S DPP=1
 S DPP(1)=ACHSFNUM_U_"DATE/TIME RECORDED"_UUUUUUU1
 S DPP(1,"F")=FROM_U_FROMTXT_U
 S DPP(1,"T")=TO_U_TOTXT_U
 Q