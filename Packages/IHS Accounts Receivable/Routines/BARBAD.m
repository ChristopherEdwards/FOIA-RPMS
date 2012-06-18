BARBAD ; IHS/SD/AR - POST STATUS CHANGE APR 12, 2010 ; 04/12/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ; 
 ; *********************************************************************
 ;
EN ;
 S BARESIG=""
 I '$G(BARESIG) D SIG^XUSESIG Q:X1=""  ;elec signature test
 S BARESIG=1
 I '$D(BARUSR) D INIT^BARUTL
 W !!
 ;
ENTRY ;
 N BARPASS
 S BARPASS=""
 S BARPASS=$$EN^BARBAD1()
 Q:BARPASS=0
 S BARCNT=$$EN^BARBAD2(BARPASS)
 I +BARCNT=0 W *7,!!,"No bills in this date range!" W !! Q
 D EN^BARBAD3
 G ENTRY
 Q
