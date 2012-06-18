BSDCAR ; IHS/ANMC/LJF - CLINIC AVAILABILITY REPORTS ;
 ;;5.3;PIMS;**1011,1012**;APR 26, 2002
 ;
ASK ; -- ask user to choose report
 NEW BSDA,I,NAME,X,Y,RTN,INTRO,POP,DIRUT
 F I=1:1 S NAME=$P($T(REPORTS+I),";;",2) Q:NAME=""  D
 . S BSDA(I)=$$SP(10)_$J(I,2)_". "_NAME
 S BSDA(I)=""   ;extra line for readability
 S Y=$$READ^BDGF("NO^1:"_(I-1),$$SP(10)_"Select REPORT","","","",.BSDA)
 Q:'Y  I Y=9 S XQH="BSDSM CAR OVERVIEW" D EN^XQH G ASK
 I Y'=2 S BSDTAXYN=1  ;cmi/maw PATCH 1011
 S RTN=$P($T(REPORTS+Y),";;",3),INTRO=$P($T(REPORTS+Y),";;",4)
 D @INTRO,@RTN
 K BSDTAXYN  ;cmi/maw PATCH 1011
 D ^XBCLS,CAR^BSDH02,ASK Q
 ;
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
REPORTS ;;
 ;;Clinic List (Day of Week);;^SDCLDOW;;DOW^BSDH021
 ;;Month-at-a-glance Display;;^BSDMON;;MD^BSDH01
 ;;Clinic Availability Report;;^SDCLAV;;CAV^BSDH021
 ;;Clinic Capacity Report;;^BSDCCR0;;CAP^BSDH021
 ;;Next Available Appointment Report;;^BSDNXAA;;NAA^BSDH021
 ;;Number of Available Appointments;;^BSDNAA;;NUM^BSDH021
 ;;Number of Appts Made & Wait Times;;^BSDDAM;;NAM^BSDH021
 ;;Time of Day Clinic Fills Up;;^BSDTOD;;TOD^BSDH021
 ;;Clinic Abbreviations;;^BSDCLA;;ABB^BSDH021
 ;;On-line Help (Report Descriptions);;
