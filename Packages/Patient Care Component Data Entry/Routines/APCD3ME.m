APCD3ME ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
EN ;EP - called from input templates
 D EN^XBNEW("EN1^APCD3ME","APCDVSIT;APCDDATE;APCDCAT;APCDPAT;APCDBEEP;AUPN*")
 Q
 ;
EN1 ;EP - called from XBNEW
 D PROCESS
 D XIT
 Q
 ;
XIT ;-- exit the routine
 K APCDX
 K X,Y
 D ^XBFMK
 Q
 ;
PROCESS ;-- lets process 
 S APCDOVRR=1
 K APCD3MER
 I '$G(APCDVSIT) W !!,"Valid visit missing!",! Q
 S DIR(0)="Y",DIR("A")="Are you ready to send the visit information to 3M for coding",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:'Y
 I $D(^APCD3MV("B",APCDVSIT)) W !!,$C(7),$C(7),"This visit has already been sent to 3M and coded.  I will",!,"file the POV's and Procedures now.",! G FILE
 D OUT^APCD3M(APCDVSIT)
 I $D(APCD3MER) W !!,$C(7),$C(7),"Fix error and then come back into this visit and use the 3M mnemonic",!,"  to code the POV's." Q
PASS ;
 W !!,"Visit information has been passed to 3M, switch screens, code the visit and",!,"then press enter below when you are finished coding.",!
 F  S DIR(0)="Y",DIR("A")="Are you done with the coding of the POV's on the 3M coder",DIR("B")="N" KILL DA D ^DIR KILL DIR Q:'$D(DTOUT)  W " Timed out"
 I $D(DIRUT)!('$G(Y)) W !!,"You are exiting without filing the POV's.  You must come back into this",!,"visit and use the 3M mnemonic to code the POV's.",! Q
FILE ;file pov's
 I '$D(^APCD3MV("B",APCDVSIT)) W !!,"The information has not come back from 3M yet.",!! G PASS
 ;file pov's and procedures using fileman templates
 ;
 W !!,"The POV's and Procedures will now be filed into PCC.  You will be prompted to ",!,"complete each entry.",!
 I '$G(BHLIP) D
 . W !,"I can't seem to figure out for 3M Workstation ID !!"
 . S DIR(0)="FO^1:2",DIR("A")="Enter your 3M Workstation ID "
 . KILL DA D ^DIR KILL DIR
 . S BHLIP=$G(X)
 . Q
 S APCDBP=$O(^INTHPC("B","HL IHS 3M SENDER "_BHLIP,0))
 L -^INRHB("RUN",APCDBP)
 F I=1:1:100 K ^INRHB("RUN",APCDBP)
 L -^INRHB("RUN",APCDBP)
 S APCDX=0 F  S APCDX=$O(^APCD3MV(APCDVSIT,11,APCDX)) Q:APCDX'=+APCDX  D FILEPOV
 D ECDCLEAN
 S APCDX=0 F  S APCDX=$O(^APCD3MV(APCDVSIT,12,APCDX)) Q:APCDX'=+APCDX  D FILEPROC
 D CPTCLEAN
 S APCDX=0 F  S APCDX=$O(^APCD3MV(APCDVSIT,13,APCDX)) Q:APCDX'=+APCDX  D FILECPT
 D FILEDRG ;file DRG and HCFA weight if exist
 W !,"All done with 3M coding.",!
 D DELETE ;delete 3m entry from file
 Q
 ;
DELETE ;
 Q:$G(APCD3MER)
 S DA=APCDVSIT,DIK="^APCD3MV(" D ^DIK K DA,DIK
 Q
 ;
FILEDRG ;
 I $P(^AUPNVSIT(APCDVSIT,0),U,7)'="H" Q  ;only hospitalizations
 NEW APCDX,APCDY S APCDX=$P(^APCD3MV(APCDVSIT,0),U,3)
 ;put this in .34 of the visit file
 S DA=APCDVSIT,DR=".34////"_$S(APCDX:"`"_APCDX,1:APCDX),DIE="^AUPNVSIT(" D ^DIE
 I $D(Y) S APCDTERM="Error encountered updating DRG." D ERR
 D ^XBFMK
 K APCDX
 Q
 ;
FILEPOV ;
 NEW APCDICD,APCDICDP
 S APCD3MVM=11
 S X=$P(^APCD3MV(APCDVSIT,11,APCDX,0),U)
 Q:$E(X,1,1)="E"  ;don't file ecodes
 S X=$$CODEN^ICDCODE(X,80)
 S X=+X I X=-1 S X=""
 I 'X S APCDTERM="Can't find ICD Code "_$P(^APCD3MV(APCDVSIT,11,APCDX,0),U)_" in the ICD9 Table.  Notify your supervisor." D ERR Q
 ;W !,"Filing POV (Diagnosis) ",$P(^ICD9(X,0),U)," - ",$P(^APCD3MV(APCDVSIT,11,APCDX,0),U,2)
 W !,"Filing POV (Diagnosis) ",$P($$ICDDX^ICDCODE(X,$$VD^APCLV(APCDVSIT)),U,2)," - ",$P(^APCD3MV(APCDVSIT,11,APCDX,0),U,2)
 S X="`"_X
 S APCDTPCC=""
 X:$D(^DD(9000010.07,.01,12.1)) ^DD(9000010.07,.01,12.1) S DIC="^ICD9(",DIC(0)="Q" D ^DIC K DIC
 I Y=-1 S APCDTERM="ICD9 Lookup failed.  Notify your supervisor." D ERR Q
 S APCDLOOK="`"_+Y  ;,APCDTNAR=$P(^APCD3MV(APCDVSIT,11,APCDX,0),U,2)
 ;S APCDICOD=$P($G(^APCD3MV(APCDVSIT,11,APCDX,0)),U,4) ;injury code
 S DIE="^AUPNVSIT(",DR="[APCD 3MPV (ADD)]",DA=APCDVSIT,DIE("NO^")=1 D ^DIE,^XBFMK
 ;delete entry in multiple
 S DA=APCDX,DA(1)=APCDVSIT,DIK="^APCD3MV("_DA(1)_",11," D ^DIK K DA,DIK
 W !
 D ^XBFMK
 Q
 ;
FILEPROC ;
 NEW APCDICD,APCDICDP
 S APCD3MVM=12
 S X=$P(^APCD3MV(APCDVSIT,12,APCDX,0),U),X=+$$CODEN^ICDCODE(X,80.1) I $P(X,U)=-1 S X=""
 I 'X S APCDTERM="Can't find ICD Code "_$P(^APCD3MV(APCDVSIT,12,APCDX,0),U)_" in the ICD0 Table.  Notify your supervisor." D ERR Q
 W !,"Filing Procedure ",$P($$ICDOP^ICDCODE(X,$$VD^APCLV(APCDVSIT)),U,2)," - ",$P(^APCD3MV(APCDVSIT,12,APCDX,0),U,2)
 S X="`"_X
 S APCDTPCC=""
 X:$D(^DD(9000010.08,.01,12.1)) ^DD(9000010.08,.01,12.1) S DIC="^ICD0(",DIC(0)="Q" D ^DIC K DIC
 I Y=-1 S APCDTERM="ICD0 Lookup failed.  Notify your supervisor." D ERR Q
 S APCDLOOK="`"_+Y  ;,APCDTNAR=$P(^APCD3MV(APCDVSIT,12,APCDX,0),U,2)
 S DIE="^AUPNVSIT(",DR="[APCD 3MOP (ADD)]",DA=APCDVSIT,DIE("NO^")=1 D ^DIE
 S DA(1)=APCDVSIT,DA=APCDX,DIE="^APCD3MV("_APCDVSIT_",12,",DR=".01///@" D ^DIE,^XBFMK
 W !
 D ^XBFMK
 Q
 ;
FILECPT ;-- lets file from the APCD 3MCPE MNEMONIC
 NEW APCDCPT,APCDCPTP
 S APCD3MVM=13
 S X=$P(^APCD3MV(APCDVSIT,13,APCDX,0),U)
 S X=$TR($P(X,"-")," ")
 ;S X=$O(^ICPT("B",X,0))
 S X=$P($$CPT^ICPTCOD(X,$$VD^APCLV(APCDVSIT)),U,1) I X=-1 S X=""
 I 'X S APCDTERM="Can't find CPT Code "_$P(^APCD3MV(APCDVSIT,13,APCDX,0),U)_" in the CPT Table.  Notify your supervisor." D ERR Q
 S APCDCMOD=$P(^APCD3MV(APCDVSIT,13,APCDX,0),U,2)
 ;W !,"Filing CPT ",$P(^ICPT(X,0),U)," - "_$P($G(^ICPT(X,0)),U,2)_"  Modifier: ",$P(^APCD3MV(APCDVSIT,13,APCDX,0),U,2)
 W !,"Filing CPT ",$P($$CPT^ICPTCOD(X,$$VD^APCLV(APCDVSIT)),U,2)," - "_$P($$CPT^ICPTCOD(X,$$VD^APCLV(APCDVSIT)),U,3)_"  Modifier: ",$P(^APCD3MV(APCDVSIT,13,APCDX,0),U,2)
 S X="`"_X
 S APCDTPCC=""
 X:$D(^DD(9000010.18,.01,12.1)) ^DD(9000010.18,.01,12.1) S DIC="^ICPT(",DIC(0)="Q" D ^DIC K DIC
 I Y=-1 S APCDTERM="ICPT Lookup failed.  Notify your supervisor." D ERR Q
 S APCDLOOK="`"_+Y
 S DIE="^AUPNVSIT(",DR="[APCD 3MCPE (ADD)]",DA=APCDVSIT,DIE("NO^")=1 D ^DIE
 S DA(1)=APCDVSIT,DA=APCDX,DIE="^APCD3MV("_APCDVSIT_",13,",DR=".01///@" D ^DIE,^XBFMK
 W !
 D ^XBFMK
 Q
 ;
ECDCLEAN ;-- cleanup ecodes from the dx multiple
 S APCDECDA=0 F  S APCDECDA=$O(^APCD3MV(APCDVSIT,11,APCDECDA)) Q:'APCDECDA  D
 . Q:$E($G(^APCD3MV(APCDVSIT,11,APCDECDA,0)),1,1)'="E"
 . S DA(1)=APCDVSIT,DA=APCDECDA,DIE="^APCD3MV("_APCDVSIT_",11,",DR=".01///@" D ^DIE,^XBFMK
 Q
 ;
CPTCLEAN ;-- cleanup cpt multiple before calling the 3mcpe mneumonic
 S APCDCPDA=0 F  S APCDCPDA=$O(APCDCPTU(APCDCPDA)) Q:'APCDCPDA  D
 . S APCDVSIT=$G(APCDCPTU(APCDCPDA))
 . S DA(1)=APCDVSIT,DA=APCDCPDA,DIE="^APCD3MV("_APCDVSIT_",13,",DR=".01///@" D ^DIE,^XBFMK
 Q
 ;
ERR ;
 S APCD3MER=1 W !!,APCDTERM
 S DA(1)=APCDVSIT,DA=APCDX,DIE="^APCD3MV("_APCDVSIT_",APCD3MVM,",DR=".03///"_$E(APCDTERM,1,50) D ^DIE
 D ^XBFMK
 Q
