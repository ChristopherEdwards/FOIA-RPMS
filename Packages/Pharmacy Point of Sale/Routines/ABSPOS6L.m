ABSPOS6L ; IHS/FCS/DRS - Cancel a claim ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
CANCEL(RXI) ; option  to cancel claim would come here
 ; now done from a protocol on the data entry screen
 ;
 ; We merely flag the claim for cancellation.
 ; Let the transmit program handle the details.
 ; And if we got here too late, the results reporting takes care of it.
 ; If we really get fancy, we can have the result processing initiate
 ; a claim reversal.
 ;
 I $D(RXI) G CANC5
 W !,"Enter the prescription number whose claim you wish to cancel.",!
 N RXI,ABSBRXI S (ABSBRXI,RXI)=$$GETRX^ABSPOSIV Q:RXI<1
CANC5 ;EP - from ABSPOS6D ; Given RXI=pointer to 9002313.59
 Q:'$$LOCKPOS^ABSPOSUD
 N DIE,DA,DR S DIE=9002313.59,DA=RXI
 S DR="301////"_DUZ_";302///@;7///NOW" D ^DIE
 D ULOCKPOS^ABSPOSUD
 N INS S INS=$P(^ABSPT(RXI,1),U,6)
 I $G(^ABSPEI(INS,101)) D
 . N X S X=^ABSPEI(INS,101)
 . I $P(X,U,6)=RXI S $P(^ABSPEI(INS,101),U,6)="" ; release Sleep Prober ownership
 . I $D(^ABSPT("AD",31)) D TASK^ABSPOSQ1 ; poke other 31s 
 . D TASK^ABSPOSQ1 ; another 31, if any, will take over
 Q
