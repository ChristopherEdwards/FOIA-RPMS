AQAOPC6 ; IHS/ORDC/LJF - TRENDING REPORTS DRIVER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the trending reports main driver where the user can choose
 ;which report to run.  The user is then returned to this menu after
 ;completion of the report.
 ;
MENU ; >>> present user with menu of trending reports available
 W !! K DIR S DIR(0)="NO^1:7",DIR("A")="Select TRENDING REPORT"
 F AQAO=1:1:7 S DIR("A",AQAO)="      "_AQAO_". "_$P($T(RPT+AQAO),";;",2)
 S DIR("A",8)=" "
 D ^DIR G EXIT:$D(DIRUT),MENU:Y=-1 S AQAORTN=$P($T(RPT+Y),";;",3)
 D @AQAORTN G MENU
 ;
EXIT ; >>> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
RPT ;; >>> MENU CHOICES
 ;;ALL Occurrences for a VISIT;;BYVISIT^AQAOPC3
 ;;ALL Occurrences for a PATIENT;;BYPAT^AQAOPC3
 ;;Occurrences by REVIEW CRITERIA;;^AQAOPC1
 ;;Occurrences by DIAGNOSIS/PROCEDURE;;^AQAOPC2
 ;;Occurrences by FINDINGS & ACTIONS;;^AQAOPC4
 ;;Occurrences for SINGLE CRITERION by MONTH;;^AQAOPC7
 ;;Trending Reports with EXTRA SORT CRITERIA;;^AQAOPC9
