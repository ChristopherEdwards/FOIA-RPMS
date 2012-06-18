AMER1B ; IHS/ANMC/GIS -ISC - OVERFLOW FROM AMER1 ;   
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
QA6 ; TRANSFER
 S DIR("B")="NO" I $G(^TMP("AMER",$J,1,6)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was this patient transferred from another facility" D ^DIR K DIR
 D OUT^AMER
 I Y K ^TMP("AMER",$J,1,10) ; ELIMINATE REGULAR TRANSPORT MODES
 I Y!(Y?1."^") Q
 F I=7,8,9 K ^TMP("AMER",$J,1,I) ; KILL OFF ALL DESCENDENTS
 S AMERRUN=9
 Q
 ;
QA7 ; TRANSFERED FROM
 S DIC("A")="*Transferred from: " K DIC("B")
 I $G(^TMP("AMER",$J,1,7)) S %=+^(7),DIC("B")=$P(^AMER(2.1,%,0),U)
 S DIC="^AMER(2.1,",DIC(0)="AEQM"
 D ^DIC K DIC
 D OUT^AMER
 Q
 ;
QA8 ; TRANSFER TRANSPORTATION
 N DIC
 S DIC("A")="*Mode of transport to the ER: " K DIC("B")
 I $G(^TMP("AMER",$J,1,8))>0 S %=+^(8),DIC("B")=$P(^AMER(3,%,0),U)
 E  S DIC("B")="PRIVATE VEHICLE"
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("TRANSFER DETAILS"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER
 I Y=-1!(Y="") Q
 S Z=$P(Y,U,2)
 I Z'["AMBULANCE" F I=10:1:14 K ^TMP("AMER",$J,1,I)
 I Z="PRIVATE VEHICLE" S AMERRIN=9 Q
 Q
 ; 
QA9 ; TRANSFER ATTENDANT
 S DIR("B")="NO" I $G(^TMP("AMER",$J,1,9)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="Medical attendant present during transfer" D ^DIR K DIR
 D OUT^AMER
 S %=$G(^TMP("AMER",$J,1,8)) I $P(%,U,2)="AMBULANCE" S AMERRUN=10,^TMP("AMER",$J,1,10)=^TMP("AMER",$J,1,8) Q
 I X'=U S AMERRUN=98
 Q
