BSDNSR ; IHS/ANMC/LJF - NO-SHOW REPORTS ;
 ;;5.3;PIMS;**1011**;APR 26, 2002
 ;
ASK ; -- ask user to choose report
 NEW BSDA,I,NAME,X,Y,RTN,INTRO,POP,DIRUT
 F I=1:1 S NAME=$P($T(REPORTS+I),";;",2) Q:NAME=""  D
 . S BSDA(I)=$$SP(10)_$J(I,2)_". "_NAME
 S BSDA(I)=""   ;extra line for readability
 S Y=$$READ^BDGF("NO^1:"_(I-1),$$SP(10)_"Select REPORT","","","",.BSDA)
 Q:'Y  I Y=3 S XQH="BSDSM NSR OVERVIEW" D EN^XQH G ASK
 S RTN=$P($T(REPORTS+Y),";;",3),INTRO=$P($T(REPORTS+Y),";;",4)
 S BSDTAXYN=1  ;cmi/maw PATCH 1011
 D @INTRO,@RTN
 K BSDTAXYN  ;cmi/maw PATCH 1011
 D ^XBCLS,NSR^BSDH02,ASK Q
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
 ;;No-Show Report;;^SDNOS;;NS1^BSDH021
 ;;Frequent No-Shows;;^BSDNS2;;NS2^BSDH021
 ;;On-line Help (Report Descriptions);;
