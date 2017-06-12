BMCADDP ;IHS/OIT/FCJ - LINK PCC VISIT/PROBLEM TO NEW REF
 ;;4.0;REFERRED CARE INFO SYSTEM;**8**;JAN 09, 2006;Build 51
 ;ABILITY TO SELECT A PCC VISIT ADD A NEW VISIT AND SELECT FROM THE PROBLEM LIST
 ;BMC*4.0*8 NEW ROUTINE IN PATCH 8
 ;
DSPV ;DISPLAY VISITS FOR DEFINED PATIENT
 ;D ALLV^APCLAPIU(dfn,beg date,end date,array)
 K BMCV S BMCQ=0,BMCQ1=0
 S VCT=30,X1=DT,X2=-VCT D C^%DTC
 S BMCBDT=X,BMCEDT=DT
 ;S VCT=3330 USED FOR TESTING
DSPV2 ;
 D ALLV^APCLAPIU(BMCDFN,BMCBDT,BMCEDT,"BMCV")
 I '$D(BMCV) D  Q:BMCQ=1  G:BMCQ1>0 DSPV2
 .W !
 .S DIR("A")="Patient has not had a visit in the past "_VCT_" days, continue searching"
 .S DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR
 .I $D(DUOUT)!$D(DTOUT)!(+Y'>0) S BMCQ=1 Q
 .I +Y>0 S BMCQ1=+Y,VCT=VCT+30,X1=DT,X2=-VCT,BMCEDT=BMCBDT D C^%DTC S BMCBDT=X
 E  D VDSP I BMCQ1=0 S BMCQ=0,VCT=VCT+30,X1=DT,X2=-VCT,BMCEDT=BMCBDT D C^%DTC S BMCBDT=X K BMCV G DSPV2
 K BMCV,BMCEDT,BMCBDT,BMCQ1,VCT
 Q
 ;
VDSP ;DISPLAY VISTS
 S BMCQ1=0,BMCVCT=0,L=0 F  S L=$O(BMCV(L)) Q:L'?1N.N  S BMCVCT=BMCVCT+1
 W !!,"PATIENT VISITS:"
 F L=1:1:BMCVCT D  Q:BMCQ1
 .S VDFN=$P(BMCV(L),U,5)
 .W !?5,$J(L,5),".  ",$$VDTM^APCLV(VDFN,"E")," ",$$LOCENC^APCLV(VDFN,"E"),?40,$$PRIMPROV^APCLV(VDFN,"N")
 .W !,?13,$$PRIMPOV^APCLV(VDFN,"E")
 .I L#10=0 D
 ..S DIR("A")="Continue displaying visits",DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR
 ..S:+Y<1 BMCQ1=1
 ;
VSEL ;SELECT A VIST
 W !
 S DIR("A")="Select a visit for the referral, Enter 1-"_L,DIR(0)="NO^1:"_L_":0"
 S DIR("?")="Select a visit from the list, if a visit is not selected you will need to add a new PCC Visit for this Patient"
 D ^DIR K DIR
 I +Y>0 S BMCVDFN=$P(BMCV(+Y),U,5),BMCQ1=1 D VUP Q
 I $D(DUOUT)!$D(DTOUT) D VADD Q
 I +Y<1 D
 .S DIR("A")="Continue displaying visits",DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR
 .I +Y<1 S BMCQ1=1 D VADD
 Q
 ;
VADD ;Need to ADD A NEW VISIT
 W !!,"A visit was not selected you will need to select a visit or a New PCC Visit"
 W !!,"will need to be added for this Patient before entering a Referral."
 S BMCQ=1
 ;
 Q
VUP ;UPDATE THE VISIT POINTER IN THE REF
 S DIE="^BMCREF(",DA=BMCRIEN
 S DR="1309////"_BMCVDFN
 D ^DIE
 K DIE
 Q
