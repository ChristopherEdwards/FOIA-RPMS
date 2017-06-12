ABMP2619 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 19 POST INIT ;  
 ;;2.6;IHS Third Party Billing;**19**;NOV 12, 2009;Build 300
 Q
POST ;
 D CCREASON  ;new cancelled claim reason for ticket HEAT155799
 D ERRCODE  ;new 3P Error Code for HEAT109144
 D ERRORUPD  ;update description on warning 191 to be more descript HEAT109144
 ;
 Q
 ;
CCREASON ;
 K DIC,X,DINUM,DR,DLAYGO
 S DIC="^ABMCCLMR("
 S DIC(0)="LM"
 S X="CANCELLED DUE TO MERGED CLAIM"
 D ^DIC
 Q
 ;
ERRCODE ;EP
 ;255 - DOS within 72 hours
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=255
 S X="DOS within 72 hours"
 S DIC("DR")=".02///Wait until after 72 hours from DOS to bill"
 S DIC("DR")=DIC("DR")_";.03///W"
 K DD,DO
 D FILE^DICN
 D SITE(255)
 Q
SITE(ABMX) ;Add SITE multiple
 S DUZHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDCLM(DUZ(2))) Q:'+DUZ(2)  D
 .S DIC(0)="LX"
 .S DA(1)=ABMX
 .S DIC="^ABMDERR("_DA(1)_",31,"
 .S DIC("P")=$P(^DD(9002274.04,31,0),U,2)
 .S DINUM=DUZ(2)
 .S X=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DIC("DR")=".03////W"
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
ERRORUPD ;EP
 K DIC,DR,DIE,X,DIR
 S DIE="^ABMDERR("
 S DA=191
 S DR=".01///OP VISIT(S) WITHIN 72 HOURS OF ADMISSION OR DISCHARGE"
 D ^DIE
 Q
