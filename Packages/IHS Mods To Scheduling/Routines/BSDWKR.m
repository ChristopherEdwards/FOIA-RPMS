BSDWKR ; IHS/ANMC/LJF - WORKLOAD/STATS REPORTS ;  [ 08/20/2004  11:58 AM ]
 ;;5.3;PIMS;**1001,1005,1007,1011,1012,1013**;MAY 28, 2004
 ;IHS/ITSC/WAR 05/03/2004 PATCH 1001 added back in v5.0 report
 ;IHS/OIT/LJF  04/12/2006 PATCH 1005 changed intro call to v5.3 routine
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.24 added new report for Turn Around Time (TAT)
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.25 added new report to show # of chart requests and RS printed by month
 ;cmi/flag/maw 6/02/2010 PATCH 1012 RQMT147 Advanced Access Report
 ;
ASK ; -- ask user to choose report
 NEW BSDA,I,NAME,X,Y,RTN,INTRO,POP,DIRUT
 F I=1:1 S NAME=$P($T(REPORTS+I),";;",2) Q:NAME=""  D
 . S BSDA(I)=$$SP(10)_$J(I,2)_". "_NAME
 S BSDA(I)=""   ;extra line for readability
 S Y=$$READ^BDGF("NO^1:"_(I-1),$$SP(10)_"Select REPORT","","","",.BSDA)
 ;IHS/ITSC/WAR 5/3/2004 PATCH #1001 allowed for another entry, see line tag REPORTS
 ;Q:'Y  I Y=5 S XQH="BSDSM WSR OVERVIEW" D EN^XQH G ASK
 Q:'Y  I Y=9 S XQH="BSDSM WSR OVERVIEW" D EN^XQH G ASK
 S BSDTAXYN=1  ;cmi/maw PATCH 1011
 S RTN=$P($T(REPORTS+Y),";;",3),INTRO=$P($T(REPORTS+Y),";;",4)
 D @INTRO,@RTN
 K BSDTAXYN
 D ^XBCLS,WSR^BSDH02,ASK Q
 ;
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;IHS/ITSC/WAR 5/3/2004 P #1001 Added 'Clinic Workload Report'
 ;IHS/OIT/LJF 04/12/2006 PATCH 1005 changed WR^ASDH02 to WK5^BSDH021
 ;cmi/anch/maw 2/27/2007 PATCH 1007 added Turn Around Time Report and Routing Slip/Chart Request Report
REPORTS ;;
 ;;Statistics by Type of Appointment;;^BSDWKR1;;WK1^BSDH021
 ;;Scheduled vs. Patients Seen;;^BSDWKR4;;WK4^BSDH021
 ;;Detailed Appointment Listing;;^BSDWKR2;;WK2^BSDH021
 ;;Monthly Workload Comparisons;;^BSDWKR3;;WK3^BSDH021
 ;;Clinic Workload Report;;^SDCWL;;WK5^BSDH021
 ;;Turn Around Time Report;;^BSDWKR6;;WK6^BSDH021
 ;;Routing Slip/Chart Request Report;;^BSDWKR7;;WK7^BSDH021
 ;;Advanced Access Report;;^BSDWKR8;;WK8^BSDH021
 ;;On-line Help (Report Descriptions);;
