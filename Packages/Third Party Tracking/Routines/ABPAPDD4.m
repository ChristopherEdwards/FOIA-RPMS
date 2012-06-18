ABPAPDD4 ;DELETE PAYMENT ENTRY; [ 07/09/91  7:55 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
A0 K DIR S DIR(0)="YO",DIR("B")="YES"
 S DIR("A")="DELETE THE CURRENT TRANSACTIONS - ARE YOUR SURE "
 S DIR("A")=DIR("A")_"(Y/N)" W *7 D ^DIR I 'Y D  G ^ABPAPDD1
 .K ABPAMESS S ABPAMESS="Nothing deleted!"
 .S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
A0A W !,"The '",ABPABDT,"' transactions for ",ABPAPAT," are being deleted "
 ;--------------------------------------------------------------------
A1 ;PROCEDURE TO RESET CLAIM FLAGS AND WRITE-OFF FIELDS
 K DIC,DIE,DA,DR,DIK,ABPA("QF"),ABPADOS
 S ABPADOS=0 F ABPA("I")=0:0 D  Q:$D(ABPA("QF"))=1
 .S ABPADOS=$O(^ABPVAO(ABPATDFN,"P",ABPADDFN,"D",ABPADOS))
 .I +ABPADOS=0 S ABPA("QF")="" Q
 .S DA=$P(^ABPVAO(ABPATDFN,"P",ABPADDFN,"D",ABPADOS,0),"^",2)
 .Q:(+DA<1)!($D(^ABPVAO(ABPATDFN,1,DA,0))'=1)
 .S ZDA=0 F ABPAPCNT=0:1 D  I +ZDA=0 K ZDA Q
 ..S ZDA=$O(^ABPVAO("PD",ABPATDFN,DA,ZDA))
 .I +ABPAPCNT<2 D
 ..K DIE,DR S DA(1)=ABPATDFN,DIE="^ABPVAO("_DA(1)_",1,",DR=".18///O"
 ..D ^DIE W "."
 .I +ABPAPCNT>1 D
 ..K DIE,DR S DA(1)=ABPATDFN,DIE="^ABPVAO("_DA(1)_",1,"
 ..S DR=".18///"_$P(^ABPVAO(DA(1),1,DA,0),"^",17)
 ..D ^DIE W "."
 .K DIE,DR S DA(1)=ABPATDFN,DIE="^ABPVAO("_DA(1)_",1,",DR=".03///@"
 .D ^DIE
 .Q
 ;--------------------------------------------------------------------
A2 ;PROCEDURE TO DELETE THE INSURER PAYMENT NODE
 K DIC,DIE,DA,DR,DIK,ABPA("I"),ABPA("QF")
 S DA(1)=ABPATDFN,DA=ABPADDFN,DIK="^ABPVAO("_DA(1)_",""P"","
 D ^DIK W "."
 ;--------------------------------------------------------------------
A3 ;PROCEDURE TO ADJUST CHECK BALANCES
 I ABPACHK]"" F I=0:0 D  Q:GOTCHECK
 .S (RESTRICT,GOTCHECK)=0,ABPASCR=""
 .D LOOK^ABPACKLK,CLEAR^ABPACKLK I 'GOTCHECK D  Q
 ..W *7,!?5,"<<< PLEASE SELECT THE APPROPRIATE CHECK >>>"
 .K DIE,DA,DR S DA(2)=$O(ABPACHK("")),DA(1)=$O(ABPACHK(DA(2),""))
 .S DA=$O(ABPACHK(DA(2),DA(1),""))
 .S DIE="^ABPACHKS("_DA(2)_",""I"","_DA(1)_",""C"","
 .S ABPACHK("RAMT")=ABPACHK("RAMT")+ABPA("STDAMT")
 .S ABPACHK("PAMT")=ABPACHK("AMT")-ABPACHK("RAMT")
 .S DR="6///"_$S(ABPACHK("PAMT")=0:"N",1:"P")
 .S DR=DR_";7///"_ABPACHK("PAMT")_";8///"_ABPACHK("RAMT")
 .S DR=DR_";9///"_DUZ_";10///NOW" D ^DIE
 .K DIK S DIK=DIE D IX^DIK Q
 ;--------------------------------------------------------------------
 L ^ABPVAO(ABPATDFN)
 K GOTCHECK,ABPAMESS S ABPAMESS="Deletion Complete!"
 S ABPAMESS(2)="... Press any key to continue ... " D PAUSE^ABPAMAIN
 G ^ABPAPDD1
