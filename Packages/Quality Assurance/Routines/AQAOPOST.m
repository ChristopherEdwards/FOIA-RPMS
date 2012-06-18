AQAOPOST ; IHS/ORDC/LJF - POST INIT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;Main driver for QAI postinits.  This rtn installs sample entries for
 ;some of the QAI tables, then calls ^AQAOPOS1.
 ;
1 ; step 1 - install of sample entries
 W !!,"QAI POST-INIT",!!
 W !,"STEP 1 - INSTALL SAMPLE ENTRIES OF SOME QI FILES",!!
 F AQAOI=1:1:3 S X=$P($T(DATA1+AQAOI),";;",2) I ('$O(@X)) D
 .K DIR S DIR(0)="Y",DIR("B")="YES"
 .S DIR("A")="Would you like me to install sample "_$P($T(DATA1+AQAOI),";;",3)_" entries"
 .D ^DIR Q:Y<1
 .;
 .S AQAOX=0,AQAON=$P($T(DATA1+AQAOI),";;",4)
 .F  S AQAOX=$O(^AQAOX(AQAON,AQAOX)) Q:AQAOX=""  D
 ..S X=$G(^AQAOX(AQAON,AQAOX)) Q:X=""
 ..K DIC,DD,DO S DLAYGO=$P($T(DATA1+AQAOI),";;",5)\1
 ..S DIC("DR")=$G(^AQAOX(AQAON,AQAOX,"DR")) Q:DIC("DR")=""
 ..S DIC=$P($P($T(DATA1+AQAOI),";;",2),",")_",",DIC(0)="L" D FILE^DICN
 ..I Y=-1 W !!,"**ERROR** Can't add ",X," to file."
 ;
 ;
NEXT ; go to next rtn for more install procedures
 D ^AQAOPOS1,MAIL
 W !!,"POST-INIT COMPLETED.  Please see notes file for instructions"
 W !,"on what to do next.",!!
 ;
 ;
EXIT ; eoj
 D KILL^AQAOUTIL Q
 ;
MAIL ; -- SUBRTN to send mail message
 NEW AQAOI,AQAO,XMSUB,XMTEXT,XMY,X
 S XMSUB="QAI ENHANCEMENT #1 INSTALLED",XMTEXT="AQAO("
 F AQAOI=1:1:12 S AQAO(AQAOI)=$P($T(MSG+AQAOI),";;",2)
 S X=0
 F  S X=$O(^XUSEC("AQAOZMENU",X)) Q:X=""  S XMY(X)=""
 D ^XMD
 W !!,"Mail message sent to ALL QAI Users."
 Q
 ;
MSG ;;
 ;;*****************************************************************
 ;;                      Congratulations!
 ;;The QAI version 1.01 has just been installed on your computer
 ;;system. There are 2 main improvements. 1) You can now link CHS
 ;;providers to occurrences and 2) you can link your Clinical
 ;;Indicators to the JCAHO Dimensions of Performance.
 ;;*****************************************************************
 ;;
 ;;For your convenience all the changes are documented on-line for 
 ;;you. Use the option "HELP on Using QAI Package" and select choice
 ;;#3 for ENHANCEMENTS. It will tell you everything you wanted to know
 ;;and more.  Have fun!
 ;
 ;
DATA1 ;; data for step 1
 ;;^AQAO(6,0);;ACTION;;6;;9002168.8
 ;;^AQAO(8,0);;FINDING;;8;;9002168.8
 ;;^AQAO1(3,0);;OUTCOME;;13;;9002169.3
