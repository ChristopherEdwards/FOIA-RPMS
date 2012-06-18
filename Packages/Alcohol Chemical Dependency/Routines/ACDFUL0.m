ACDFUL0 ;IHS/ADC/EDE/KML - IHS-SMBD/MLQ PRINT FU DUE REPORT;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 S %DT="AEF"
 S %DT("A")="Select Month/Year for Follow Up Due Report: "
 D ^%DT Q:Y<0  S ACDBEGDT=Y
 S ACDBEGDT=$E(ACDBEGDT,1,5)_"00"
 S Y=ACDBEGDT X ^DD("DD") S ACDBGMDY=Y
 S L=0,DIC="^ACDWORK(",FLDS="[ACD-FUL]",BY="[ACD-FUL]"
 S DHD="FOLLOW UPS DUE FOR "_ACDBGMDY
 S DIOBEG="D ^ACDFUL1"
 N DIOEND ;    moved from below, only thing that makes sense
 S DIOEND="K ACDBGMDY,IOP"
 D EN1^DIP
 ;N DIOEND
 ; What does the previous statement do? .. ede ..
 D PAUSE^ACDDEU
 Q
