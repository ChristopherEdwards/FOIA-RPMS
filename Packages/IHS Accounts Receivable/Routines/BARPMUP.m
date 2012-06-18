BARPMUP ; IHS/SD/LSL - MANUAL UPLOAD PROCESS JAN 15,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 06/09/03 - V1.7 Patch 1
 ;      Modified to set BAR("OPT") to menu option to disquinish
 ;      Single bill upload during AR Bill creation
 ;
 ; ********************************************************************
 ;** Manual upload process
 ;
EN ;
 D ^BARVKL0
 S BARESIG=""
 ;
ENTRY ;
 I '$G(BARESIG) D SIG^XUSESIG Q:X1=""  ;elec signature test
 S BARESIG=1
 I '$D(BARUSR) D INIT^BARUTL
 S BAROPT="Upload 1 bill"
 ;
LOOP ;
 F  D  Q:Y<0
 .W !!
 .D ONE^BARPMUP1
 ;
EXIT ;
 D EOP^BARUTL(1)
 D ^BARVKL0
 Q
