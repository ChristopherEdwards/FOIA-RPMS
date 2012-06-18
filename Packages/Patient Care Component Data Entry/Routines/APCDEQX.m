APCDEQX ; IHS/CMI/LAB - QUICK EXIT FROM ADD MODE DATA ENTRY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 I '$D(APCDVSIT("NEW")),$P(^AUPNVSIT(APCDVSIT,0),U,9) D INF1 Q
 W !!,$C(7),$C(7),"This is the 'Quick Exit' from Data Entry Enter Mode.  This visit will",!,"be deleted and you will be returned to the 'VISIT/DATE TIME' prompt.",!
 S DIR(0)="Y",DIR("A")="Do you wish to Proceed with the Deletion",DIR("B")="N" D ^DIR K DIR
 I $D(DIRUT) K APCDEQX Q
 I Y'=1 K APCDEQX D ASK Q
 S $P(^AUPNVSIT(APCDVSIT,22),U)="DATA ENTRY EXITED VISIT/DELETED"
 D UPDLOG^APCDVDEL(APCDVSIT)
 S APCDVDLT=APCDVSIT D ^APCDVDLT K APCDLPAT,APCDLDAT,APCDLVST,APCDODAT
 Q
ASK ;
 S DIR(0)="Y",DIR("A")="Do you still wish to EXIT this Visit",DIR("B")="Y" D ^DIR K DIR
 I $D(DIRUT) K APCDEQX Q
 I Y'=1 K APCDEQX Q
 S APCDEQX=""
 W !!,$C(7),$C(7),"WARNING - You may be leaving an INCOMPLETE VISIT!!"
 ;
 Q
INF1 ;
 W $C(7),$C(7),!!,"This visit was created by another module (Pharm, Lab, Dental, etc.)",!,"and CANNOT be deleted with the XIT mnemonic.",!
 W !,"Use the MOD mnemonic or MODIFY Menu option to make any changes to this visit.",!,"Use the DELETE Menu option to delete the entire visit.",!!
 Q
