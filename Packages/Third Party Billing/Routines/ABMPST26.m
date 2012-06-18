ABMPST26 ; IHS/SD/SDR - 3P BILLING 2.6 PRE/POST INIT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
POST ;
 D ERRCODES  ;new error codes in 3P Error Codes file
 Q
ERRCODES ;
 ;233 - CPT CODE REQUIRES LAB TEST RESULT TO BE ENTERED
 K DIC,X
 S DIC="^ABMDERR("
 S DIC(0)="LM"
 S DINUM=233
 S X="CPT code requires lab test result to be entered"
 S DIC("DR")=".02///Enter lab test result for CPT"
 S DIC("DR")=DIC("DR")_";.03///E"
 K DD,DO
 D FILE^DICN
 D SITE(233)
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
 .S DIC("DR")=".03////"_$S((DA(1)=231):"W",1:"E")
 .D ^DIC
 .K DA,DIC,DINUM
 S DUZ(2)=DUZHOLD
 K DUZHOLD,DLAYGO,ABMX
 Q
