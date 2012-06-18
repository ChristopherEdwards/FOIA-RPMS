XBLMSET ;IHS/ADC/PDW - setup XBLM terminal subtype & XBLM HF DEVICE for XBLM  [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**5,9**;FEB 07, 1997
 ;;
 I '$D(DUZ) D ^XUP
TERM ;SETUP TERMINAL SUBTYPE "P-XBLM"
 K DIC
 S DIC=$$DIC^XBDIQ1(3.2)
 S X="P-XBLM",DIC(0)="XL"
 D ^DIC
 I Y'>0 W !,"ERROR IN SELECTION OF TERMINAL SUBTYPE",! Q
 S DA=+Y
 D TERMDR
 S DIE=DIC D ^DIE
 S XBTERDA=DA
 ;
DEV ; SETUP device
 K DIC
 S DIC=$$DIC^XBDIQ1(3.5)
 S X="XBLM HF DEVICE",DIC(0)="XL" D ^DIC
 I Y'>0 W !,"ERROR IN DEVICE SELECTION" Q
 S DA=+Y
 D DEVDR
 S DIE=$$DIC^XBDIQ1(3.5)
 D ^DIE
 S XBDEVDA=DA
 ;D DIQ^XBLM(3.2,XBTERDA)
 ;D DIQ^XBLM(3.5,XBDEVDA)
 Q
TERMDR ;;EP
 ;;~.02///^S X="NO";~
 ;;~1///^S X=255;~
 ;;~2///^S X="#";~
 ;;~3///3000;~
 ;;~4///^S X="$C(8)";~
 ;;~99///^S X="Host File for XBLM utility"~
 ;;~END~
 S DR=""
 F I=1:1 S X=$P($T(TERMDR+I),"~",2) Q:X["END"  S DR=DR_X
 Q
DEVDR ;;
 ;;~.02///^S X="HOST FILE FOR XBLM";~
 ;;~1///^S X=$S($$VERSION^%ZOSV(1)["Cache for Windows":"C:\Tmp\Tmp.xblm",$$VERSION^%ZOSV(1)["Cache for UNIX":"/Tmp/Tmp.xblm",1:51);~ ; IHS/SET/GTH XB*3*9 10/29/2002 Originally: ;;~1///^S X=51;~
 ;;~1.9///@;~
 ;;~1.95///^S X="NO";~
 ;;~2///^S X="HOST FILE SERVER";~
 ;;~3///^S X="P-XBLM";~
 ;;~4///^S X="NO";~
 ;;~5///^S X="NO";~
 ;;~5.1///^S X="NO";~
 ;;~5.2///^S X="NO";~
 ;;~11.2///^S X="YES";~
 ;;~END~
 S DR=""
 F I=1:1 S X=$P($T(DEVDR+I),"~",2) Q:X["END"  S DR=DR_X
 Q
