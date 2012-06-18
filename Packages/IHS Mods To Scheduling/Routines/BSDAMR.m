BSDAMR ; IHS/ANMC/LJF - APPT MGT REPORTS ;
 ;;5.3;PIMS;**1007,1011**;APR 26, 2002
 ;
 ;cmi/anch/maw 2/6/2007 PATCH 1007 items 1007.18, 1007.19 added report selection and modified help number
 ;cmi/anch/maw 2/6/2007 PATCH 1007 item 1007.18, this report is in BSDAMR3 with help at AM4^BSDH021
 ;cmi/anch/maw 2/6/2007 PATCH 1007 item 1007.19, this report is in BSDAMR4 with help at AM5^BSDH021
 ;cmi/anch/maw 2/6/2007 PATCH 1007 item 1007.18 added CHKKEY for security key check
 ;cmi/flag/maw 10/29/2009 PATCH 1011 add ask of taxonomy
 ;
ASK ; -- ask user to choose report
 NEW BSDA,I,NAME,X,Y,RTN,INTRO,POP,DIRUT
 F I=1:1 S NAME=$P($T(REPORTS+I),";;",2) Q:NAME=""  D
 . S BSDA(I)=$$SP(10)_$J(I,2)_". "_NAME
 S BSDA(I)=""   ;extra line for readability
 S Y=$$READ^BDGF("NO^1:"_(I-1),$$SP(10)_"Select REPORT","","","",.BSDA)
 ;cmi/anch/maw 2/6/2007 PATCH 1007 item 1007.18, modified following line to change help to 6
 ;Q:'Y  I Y=4 S XQH="BSDSM AMR OVERVIEW" D EN^XQH G ASK  ;cmi/anch/maw 2/6/2007 orig line
 Q:'Y
 I Y=6 S XQH="BSDSM AMR OVERVIEW" D EN^XQH G ASK
 I Y=4,'$$CHKKEY(DUZ,"SDZ ELIG REPORT") W !,"You do not hold the security key SDZ ELIG REPORT key" G ASK  ;cmi/anch/maw 2/6/2007 added patch 1007 item 1007.18
 S RTN=$P($T(REPORTS+Y),";;",3),INTRO=$P($T(REPORTS+Y),";;",4)
 S BSDTAXYN=1  ;cmi/maw 10/29/2009 PATCH 1011 for asking taxonomy
 D @INTRO,@RTN
 K BSDTAXYN  ;cmi/maw 10/29/2009 PATCH 1011 remove ask of taxonomy
 D ^XBCLS,AMR^BSDH02,ASK Q
 ;
CHKKEY(USR,KEY) ;-- check to see if the user holds a security key
 ;cmi/anch/maw 2/6/2007 added to check for holder of key PATCH 1007 item 1007.18
 N KEYI
 S KEYI=$O(^DIC(19.1,"B",KEY,0))
 I 'KEYI Q 0
 I '$O(^VA(200,DUZ,51,"B",KEYI,0)) Q 0
 Q 1
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
REPORTS ;;
 ;;Appointment Management Statistics;;EN^SDAMO;;AM1^BSDH021
 ;;Appointments Requiring Action;;^BSDAMR2;;AM2^BSDH021
 ;;Uncoded Checked-in Appointments;;^APCDDVL1;;AM3^BSDH021
 ;;Eligibility Appointment List;;^BSDAMR3;;AM4^BSDH021
 ;;Cancelled Appointment Listing;;^BSDAMR4;;AM5^BSDH021
 ;;On-line Help (Report Descriptions);;
