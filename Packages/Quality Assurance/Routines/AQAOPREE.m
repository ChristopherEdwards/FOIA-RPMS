AQAOPREE ; IHS/ORDC/LJF - ENVIRONMENT CHECK PRE-INIT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the main driver for QAI pre-inits.  It check for the
 ;presence of required software before allowing installation of the
 ;QAI package.  Then is calls the standard IHS pre-init ^AQAOPREI.
 ;
 W !!!!,"Checking environment . . .",!!
 F I=1:1:6 S AQAONS=$P($T(PKG+I),";;",2) Q:AQAONS=""  D
 .S X=0
 .F  S X=$O(^DIC(9.4,"C",AQAONS,X)) Q:X=""  D
 ..S V=$G(^DIC(9.4,X,"VERSION"))
 ..I V<$P($T(PKG+I),";;",3),'$O(^DIC(9.4,"C",AQAONS,X)) K DIFQ D
 ...W !!,"VERSION ",$P($T(PKG+I),";;",3)," of ",$P($T(PKG+I),";;",4)
 ...W " has NOT been installed!"
 ;
 I '$D(DIFQ) W !!,*7,"CANNOT CONTINUE.  INSTALLATION STOPPED." Q
 ;
PKDEL ; delete pkg options, templates
 S XBPKNSP="AQAO" K XBPKEY D ^XBPKDEL I '$D(DIFQ) Q
 ;
PREI ; call standard IHS pre-init
 D ^AQAOPREI
 ;
END K I,X,V
 Q
 ;
 ;
PKG ;;
 ;;XU;;7;;KERNEL
 ;;APCD;;1.6;;PCC DATA ENTRY
 ;;AUT;;93.2;;IHS DICTIONARIES (POINTERS)
 ;;AUPN;;93.1;;IHS DICTIONARIES (PATIENT)
 ;;AVA;;93.2;;IHS VA SUPPORT FILES
 ;;AMQQ;;2;;Q-MAN
 ;;ATS;;2.5;;SEARCH TEMPLATE SYSTEM
