ASURO76D ; IHS/ITSC/LMH -RPT 76 ANALYSIS OF ISSUES BY USER ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides two entry points to print Report 76
 ;entering at the top deletes the related extracts and rebuilds them
 ;entering at PRINT prints the report from existing sorted extracts
 K ^XTMP("ASUR","R76")
 S ^XTMP("ASUR","R76",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 D ^ASURO760
PRINT ;EP; PRINT FROM KERNEL OPTION
 D ^ASURO76P
 Q
