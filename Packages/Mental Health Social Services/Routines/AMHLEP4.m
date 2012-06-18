AMHLEP4 ; IHS/CMI/LAB - ADD NEW CHR ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
INTAKE ;EP
 W:$D(IOF) @IOF
 S DA=AMHR,DDSFILE=9002011,DR="[AMHVT ADD RECORD]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG D DEL^AMHLEP2 Q
 D CHECK I AMHOKAY W !!,"Incomplete record.  Deleting record." D DEL^AMHLEP2 K AMHOKAY Q
 K AMHOKAY
I1 ;
 I '$D(^AMHRPRO("AD",AMHR)) W !!,"At least one POV IS REQUIRED." D  G:$G(Y)="G" INTAKE D DEL^AMHLEP2 Q
 .S DIR(0)="S^G:GO BACK AND ADD A POV;E:EXIT AND DELETE RECORD",DIR("A")="A POV must be entered, select action",DIR("B")="G" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="" Q
 .Q
 D EP1^AMHLEI(AMHPAT,AMHR) ;INTAKE DATA COLLECTION
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 ;D CDST^AMHLEP2
 D REGULAR^AMHLEP2
 ;remove auto opening of case per Denise patch 4 12-13-04
 ;I '$$CASE(DFN,AMHR,AMHPTYPE) D
 ;.W !!,"Opening Case for ",$P(^DPT(AMHPAT,0),U,1)
 ;.W !,"Creating new case..." K DD,D0,DO,DINUM,DIC,DA,DR S X=AMHDATE,DIC(0)="EL",DIC="^AMHPCASE(",DLAYGO=9002011.58,DIADD=1
 ;.S DIC("DR")=".02////"_DFN_";.11///^S X=DT;.03////^S X=$G(AMHPTYPE);.08////^S X=$$PPINT^AMHUTIL(AMHR)"
 ;.D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 ;.I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Case Record failed !!  Deleting Record.",! D PAUSE^AMHLEA Q
 ;S AMHPC=+Y
 S DIR(0)="Y",DIR("A")="Do you wish to update/review the BH Problem List",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP
 I 'Y G TP
 D MHPL^AMHLE2
TP ;remove this prompt per Denise 12-13-04 patch 4
 ;S DIR(0)="Y",DIR("A")="Do you wish to update/review the Patient's Treatment Plan",DIR("B")="N" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G OTH
 ;I 'Y G OTH
 ;D EP1^AMHLETP(AMHPAT)
 ;
OTH ;
 D OTHER^AMHLEP2
 D PCCLINK^AMHLEP2
 Q
CASE(P,R,T) ;return 1 if case already opened
 S U="^"
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW X,H S (X,H)=0 F  S X=$O(^AMHPCASE("AA",P,9999999-$P($P(^AMHREC(R,0),U),"."),X)) Q:X'=+X   I $P(^AMHPCASE(X,0),U,2)=T,$P(^AMHPCASE(X,0),U,8)=$$PPINT^AMHUTIL(R) S H=1
 Q H
CHECK ;
 S AMHOKAY=""
 S AMHREC=^AMHREC(AMHR,0)
 I $P(AMHREC,U,4)="" W !,"Location of Encounter Missing!" S AMHOKAY=1
 I $P(AMHREC,U,5)="" W !,"Community of Service Missing!" S AMHOKAY=1
 I $P(AMHREC,U,6)="" W !,"Activity Type Missing!" S AMHOKAY=1
 I $P(AMHREC,U,7)="" W !,"Type of Contact Missing!" S AMHOKAY=1
 S (X,Y)=0 F  S X=$O(^AMHRPROV("AD",AMHR,X)) Q:X'=+X  I $P(^AMHRPROV(X,0),U,4)="P" S Y=Y+1
 I Y=0 W !,"No primary Provider!",$C(7),$C(7) S AMHOKAY=1
 ;IF PAT ACTIVITY AND PATIENT MISSING - ERROR
 I $P(AMHREC,U,12)="" W !," WARNING:  Activity Time Missing!" W $C(7) S AMHOKAY=1
 Q
