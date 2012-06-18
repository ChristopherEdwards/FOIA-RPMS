BARBLOS0 ; IHS/SD/LSL - IG REPORT ON OUTSTANDING BILLS BY APPROVE DATE 16:11 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ;;IHS/ADC/KML P*3
 ;
 ; IHS/SD/LSL - 12/23/2002 - V1.7 - NOIS PJB-0902-90072
 ;       Modified to resolve <UNDEF> TRAN+1^BARBLOS0
 ;
 ; *********************************************************************
 ;
ASK ;EP ask user questions
 S BARAREA=0
 I ^%ZOSF("OS")'["UNIX" Q
 K DIR S DIR(0)="Y",DIR("A")="Send an electronic copy to the area office  " D ^DIR
 S BARAREA=+Y
 I '+Y Q
 S BARSUFAC=$$VAL^XBDIQ1(9999999.06,DUZ(2),.12)
 W !!," The file IG",BARSUFAC," will be sent to the area office.",!!
 Q
TRAN ;EP send to area office if BARAREA=1
 I 'BARAREA Q
 S BARDEST=$$VAL^XBDIQ1(9999999.39,1,.14)
 S BARSUFAC=$$VAL^XBDIQ1(9999999.06,DUZ(2),.12)
 S BARDIR="/usr/spool/uucppublic",BARFN="IG"_BARSUFAC
 S Y=$$OPEN^%ZISH(BARDIR,BARFN,"W")
 D PRINT^BARBLOS1
 D ^%ZISC
 S Y=$$SEND^%ZISH(BARDIR,BARFN,BARDEST)
 Q
SET ;EP set menu 
 ; remove previous menu name
 K DIC S DIC=$$DIC^XBDIQ1(19),X="BAR IG 9/30/96 REPORT",DIC(0)="XM",BARX=X D ^DIC
 I Y>0 K DA,DIK S DIK=$$DIC^XBDIQ1(19),DA=+Y D ^DIK
SET2 ;
 K DIC S DIC=$$DIC^XBDIQ1(19),X="BAR IG REPORT",DIC(0)="XM",BARX=X D ^DIC
 I Y>0 G END ; already in file
 ;
 K DIC S DIC=$$DIC^XBDIQ1(19),X="BAR IG REPORT",DIC(0)="XML",BARX=X D ^DIC
 ;
 S DA=+Y
 S BARDA=+Y
 D DR1
 S DIE=$$DIC^XBDIQ1(19) D ^DIE
 K DIC S DIC=19,X="BAR MANAGER",DIC(0)="XM" D ^DIC
 S DA(1)=+Y
 K DIC S DIC=$$DIC^XBDIQ1(19.01),X=BARX,DIC(0)="XML" D ^DIC
 S DA=+Y
 D DR2 S DIE=DIC D ^DIE
 G END
 Q
END ;;EP
 W !,"A mail message has been sent to the A/R Users ",!
 D ^BARNEWS3
 Q
DR1 ;;build dr for option
 ;;~1///^S X="IG REPORT";~
 ;;~4////^S X="R";~
 ;;~12///^S X="BAR";~
 ;;~15///^S X="D ^BARVKL0";~
 ;;~20///^S X="D INIT^BARUTL";~
 ;;~25///^S X="BARBLOS";~
 ;;~26///^S X="D ^BARBAN";~
 ;;~END~
 K DR S DR="" F I=1:1 S X=$P($T(DR1+I^BARBLOS0),"~",2) Q:X="END"  S DR=DR_X
 Q
DR2 ;; build dr for menu item
 ;;~2///^S X="IG";~
 ;;~3///20;~
 ;;~END~
 K DR S DR="" F I=1:1 S X=$P($T(DR2+I^BARBLOS0),"~",2) Q:X="END"  S DR=DR_X
 Q
