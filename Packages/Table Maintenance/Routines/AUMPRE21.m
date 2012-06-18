AUMPRE21 ;IHS/SD/SDR - Data removal from ICD Expanded field ; [ 08/18/2003  11:02 AM ]
 ;;9.1;TABLE MAINTENANCE;**2**;FEB 4,2009
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at START as the pre-init
 ; for AUM*9.1*2.
 ;
START ;EP
 K AUMFLG
 S AUMI=0
 W !!,"Removing data from ICD EXPANDED field of ICD DX file..."
 F  S AUMI=$O(^ICD9(AUMI)) Q:'AUMI  D
 .I $P($G(^ICD9(AUMI,0)),U,8)=1 D
 ..W !?3,$P($G(^ICD9(AUMI,0)),U),?13,$P($G(^ICD9(AUMI,0)),U,8)
 ..K DIC,DIE,DIR,X,Y,DA,DR
 ..S DIE="^ICD9("
 ..S DA=AUMI
 ..S DR="8////@"
 ..D ^DIE
 ..S AUMFLG=1
 I +$G(AUMFLG)'=1 W !?3,"No data found"
 ;
 K AUMFLG
 S AUMI=0
 W !!,"Removing data from ICD EXPANDED field of ICD PX file..."
 F  S AUMI=$O(^ICD0(AUMI)) Q:'AUMI  D
 .I $P($G(^ICD0(AUMI,0)),U,8)=1 D
 ..W !?3,$P($G(^ICD0(AUMI,0)),U),?13,$P($G(^ICD0(AUMI,0)),U,8)
 ..K DIC,DIE,DIR,X,Y,DA,DR
 ..S DIE="^ICD0("
 ..S DA=AUMI
 ..S DR="8////@"
 ..D ^DIE
 ..S AUMFLG=1
 I +$G(AUMFLG)'=1 W !?3,"No data found"
 Q
