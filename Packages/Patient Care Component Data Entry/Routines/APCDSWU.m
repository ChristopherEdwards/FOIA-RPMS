APCDSWU ; IHS/CMI/LAB - SWITCH TO V FILE ;
 ;;2.0;IHS PCC SUITE;**4,5**;MAY 14, 2009
 ;
 ; APCDSWD=DICTIONARY NUMBER
 ; APCDSWCR=LINKING CROSS REFERENCE
 ; APCDSWV=VISIT DFN
 ;
EP ;
 D EN^XBNEW("EN^APCDSWU","APCDVSIT;APCDMNE")
 Q
EN ;
 NEW APCDSWDA,APCDSWMV,APCDVM01,APCDVM04,APCDSWCT,APCDSWA,APCDSWAN,APCDSWX,APCDSWT,APCDSWI,APCDSWVE
 NEW X,Y,DIR
EN0 ;
 W !!,"Please Note:  You are NOT permitted to modify or delete these"
 W !,APCDMNE("NAME")," entries.  You can only mark them as entered in error."
 ;
 S APCDSWCT=0
 K APCDSWA
 S APCDSWMV=$O(^AUTTCRA("C",APCDMNE("NAME"),0))
 S APCDSWVE=$P(^AUTTCRA(APCDSWMV,0),U,1)
 S APCDSWDA=0 F  S APCDSWDA=$O(^AUPNVRUP("AD",APCDVSIT,APCDSWDA)) Q:APCDSWDA'=+APCDSWDA  D
 .Q:$P($G(^AUPNVRUP(APCDSWDA,2)),U,1)  ;don't display those entered in error
 .S APCDVM01=$$VALI^XBDIQ1(9000010.54,APCDSWDA,.01)
 .;S APCDVM04=$$VAL^XBDIQ1(9000010.04,APCDSWDA,.04)
 .I APCDSWMV]"",APCDVM01'=APCDSWMV Q
 .S APCDSWCT=APCDSWCT+1
 .S APCDSWA(APCDSWCT)=APCDSWDA
 I '$D(APCDSWA) W !!,"There are no '",APCDSWVE,"' clinical review actions documented on this",!,"visit.  The ",APCDMNE("NAME")," mnemonic has not been used on this visit so there is nothing",!,"to modify." Q
 D SELECTM
 Q
 ;
SELECTM ;
 ;select the measurement to edit or delete
 W !,"Please choose which clinical review action you would like to"
 W !,"mark 'Entered in Error', if you do not wish to mark any in error, "
 W !,"simply press 'enter' to bypass."
 S APCDSWX=0,APCDSWT=0 F  S APCDSWX=$O(APCDSWA(APCDSWX)) Q:APCDSWX'=+APCDSWX  D
 .S APCDSWDA=APCDSWA(APCDSWX),APCDSWT=APCDSWX
 .S APCDVM01=$$VAL^XBDIQ1(9000010.54,APCDSWDA,.01)
 .S APCDVM04=$$VAL^XBDIQ1(9000010.54,APCDSWDA,1204)
 .W !?2,APCDSWX,")",?7,APCDVM01,?40,"Provider: ",APCDVM04
 K DIR
 S DIR(0)="NO^1:"_APCDSWT_":0",DIR("A")="Which "_APCDSWVE,DIR("?")="Enter a number from the list above (1-"_APCDSWT_" or 'N' to exit." KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I X="" Q
 I Y="" Q
 I '$D(APCDSWA(X)) W !,"Invalid response.  Please enter a number from 1 to ",APCDSWT," or N." G SELECTM
 S APCDSWI=Y
 S APCDSWDA=APCDSWA(X)
 K DIR
 W !,"You have selected: ",$$VAL^XBDIQ1(9000010.54,APCDSWDA,.01),"   Provider: ",$$VAL^XBDIQ1(9000010.54,APCDSWDA,1204)
 S DIR(0)="Y",DIR("A")="Are you sure you want to mark this item deleted/entered in error",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 Q:'Y
 Q:$D(DIRUT)
 D ENTINERR(APCDSWDA)
 ;if it is a NAM or NAP then also find MLR or PLR for the same date/provider and mark them as entered in error
 I APCDMNE("NAME")="NAM" D REV Q
 I APCDMNE("NAME")="NAP" D REV Q
 I APCDMNE("NAME")="NAA" D REV Q
 Q
ENTINERR(APCDSWDA) ;EP
 I '$D(APCDSWDA) Q
 I '$D(^AUPNVRUP(APCDSWDA,0)) W !!,"invalid v updated/reviewed entry...." Q
 S DA=APCDSWDA,DIE("NO^")=1,DIE="^AUPNVRUP(",DR="[APCD VUR ENTERED IN ERROR" D ^DIE K DA,DR,DIE
 Q
REV ;delete auto-entered MLR/PLR
 ;FIND MLR/PLR with same provider and same date as the NAM/NAP
 NEW APCDP,APCDDAT,A,B,C,APCDV,G,DA,DR,DIE
 S APCDP=$P($G(^AUPNVRUP(APCDSWDA,12)),U,4)
 S APCDDAT=$P($G(^AUPNVRUP(APCDSWDA,12)),U,1)
 S APCDV=$P(^AUPNVRUP(APCDSWDA,0),U,3)
 I APCDMNE("NAME")="NAM" S A=$O(^AUTTCRA("C","MLR",0))
 I APCDMNE("NAME")="NAP" S A=$O(^AUTTCRA("C","PLR",0))
 I APCDMNE("NAME")="NAA" S A=$O(^AUTTCRA("C","ALR",0))
 S G=""
 S B=0 F  S B=$O(^AUPNVRUP("AD",APCDV,B)) Q:B'=+B!(G)  D
 .Q:$P($G(^AUPNVRUP(B,0)),U,1)'=A
 .Q:$P($G(^AUPNVRUP(B,12)),U,4)'=APCDP
 .Q:$P($G(^AUPNVRUP(B,12)),U,1)'=APCDDAT
 .Q:$P($G(^AUPNVRUP(B,2)),U,1)="Y"  ;already marked as entered in error
 .S DA=B,DIE="^AUPNVRUP(",DR="2.01///"_$P($G(^AUPNVRUP(APCDSWDA,2)),U,1)_";2.02///"_$P($G(^AUPNVRUP(APCDSWDA,2)),U,2)_";2.03///"_$P($G(^AUPNVRUP(APCDSWDA,2)),U,3)_";2.04///"_$P($G(^AUPNVRUP(APCDSWDA,2)),U,4)
 .D ^DIE
 .S G=1
 .Q
 Q
