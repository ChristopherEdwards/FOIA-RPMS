ACDDIK ;IHS/ADC/EDE/KML - DELETE A VISIT ENTRY FROM VISIT FILES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;EP for user interaction
 ;//[ACDDIK]
 W @IOF,"Signon Program is          : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Visit Records to Delete are: THOSE NOT EXTRACTED."
 W !,"                             THOSE WITHIN YOUR SIGNIN PROGRAM.",!
 W !,"DELETING CDMIS VISIT RECORDS...",!!
 S DIC("S")="I ^(""BWP"")=DUZ(2),'$P(^(0),U,25)"
 S DIC="^ACDVIS(",DIC(0)="AEQ" D ^DIC G:Y<0 K S ACDVISP=+Y
 ;
AUTO ;EP for time out
 ;
 ;//^ACDDE
 ;//^ACDDIC
 ;//^ACDAUTO1
 ;For partial entries as well
 Q:'$D(ACDVISP)
 ;
 S:'$D(ACD80) $P(ACD80,"=",79)="=" W !!,ACD80
 D YN I 'ACDOK W "   No action taken..." G K
 S DA=ACDVISP,DIK="^ACDVIS(" D ^DIK
 W !,"** INCOMPLETE or INCORRECT ** VISIT LINK deleted from Visit file."
 F ACDDA=0:0 S ACDDA=$O(^ACDIIF("C",ACDVISP,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIK="^ACDIIF(" D ^DIK W !,*7,*7,"** INCOMPLETE or INCORRECT ** VISIT LINK deleted from Init/Info/Fu file."
 F ACDDA=0:0 S ACDDA=$O(^ACDTDC("C",ACDVISP,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIK="^ACDTDC(" D ^DIK W !,*7,*7,"** INCOMPLETE or INCORRECT ** VISIT LINK deleted from Tran/Dis/Close file."
 F ACDDA=0:0 S ACDDA=$O(^ACDCS("C",ACDVISP,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIK="^ACDCS(" D ^DIK W !,*7,*7,"** INCOMPLETE or INCORRECT ** VISIT LINK deleted from Client Service file."
 W !,ACD80
 W !!,"   Visit deletion complete...."
 D PAUSE^ACDDEU
 D K Q
 ;
YN ;
 ;No user interaction if time out so quit
 I $D(DTOUT)!($D(ACDTOUT)) S ACDOK=1 Q
 ;For user interaction i.e. LINE TAG:EN
 S DIR(0)="Y",DIR("A")="Are You Sure You Wish to DELETE This ENTRY",DIR("B")="NO" K DA D ^DIR K DIR
 S ACDOK=Y
 Q
K ;
 K DIK,DIC,%,ACDDA,DA,ACD80,ACDVISP
 Q
