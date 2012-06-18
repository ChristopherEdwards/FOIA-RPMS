APCLRTC ; IHS/CMI/LAB - TAXONOMY CREATION ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
EN2 ; - ENTRY POINT - Generation of taxonomy by end user
 S DIR("?")="Select the number or name of an attribute from the list for which a taxonomy is to be created"
 S DIR(0)="S^1:DIAGNOSIS;2:ADA CODE;3:RX;4:PROCEDURE (MEDICAL);5:PATIENT ED TOPIC;6:HEALTH FACTORS;7:PROBLEM LIST DIAGNOSIS;8:LABORATORY TEST"
 D ^DIR K DIR
 I '$D(Y(0)) G X1
 S X=$O(^AMQQ(5,"B",Y(0),"")) I X="" W !,"A taxonomy can not be created for this attribute" G X1
 S AMQQATNM=Y(0)
 D EN1^AMQQTX
 K ^UTILITY("AMQQ TAX",$J),AMQQTDFN,AMQQTAX,AMQQURGN,AMQQTAX,AMQQATNM
X1 Q
