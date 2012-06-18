AMER2 ; IHS/ANMC/GIS - ER DISCHARGE DATA COLLECTION ;   
 ;;3.0;ER VISIT SYSTEM;**1,2**;FEB 23, 2009
 ;
QD1 ; NAME
 I $D(AMERDNA) W !,?5,"*****  PROCESS PATIENT WHO LEFT BEFORE VISIT WAS COMPLETED  *****",!!,*7
 D PICK K ^TMP("AMER TEMP",$J) I $D(AMERQUIT) Q
 D UTL^AMER0(AMERDFN) S (X,Y)=AMERDFN
 I $D(AMERDNA) S AMERRUN=12 Q
 S AMERRUN=19
 Q
 ;
QD2 ; INJURY
 S DIR("B")="NO" I $G(^TMP("AMER",$J,2,2)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was this ER visit caused by an injury" D ^DIR K DIR
 D OUT^AMER I Y=U,'$D(AMEREFLG) S AMERFIN=27
 I 'Y,'$G(^TMP("AMER",$J,2,2)),$D(AMEREFLG) S AMERRUN=98 Q
 I Y S AMERRUN=29,AMERFIN=71 Q
 F I=32:1:35,41:1:46,51:1:57,61:1:64,70 K ^TMP("AMER",$J,2,I) ; KILL OFF ALL DESCENDENTS
 S AMERRUN=4
 Q
 ;
QD5 ; WORK RELATED
 S DIR("B")="NO" I $G(^TMP("AMER",$J,2,5)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was this ER visit WORK-RELATED" D ^DIR K DIR
 D OUT^AMER I X=U,'$D(AMEREFLG) S AMERFIN=27
 Q
QD6  ; ER CONSULTANT NOTIFIED
 N DIR
 S DIR("B")="NO" I $G(^TMP("AMER",$J,2,6)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was an ER CONSULTANT notified" D ^DIR K DIR
 D OUT^AMER I X?1."^" Q
 I 'Y K ^TMP("AMER",$J,2,7) S ^TMP("AMER",$J,2,6)=0,AMERRUN=9
 I 'Y,$D(AMEREFLG) S AMERRUN=98
 I 'Y Q
 S ^TMP("AMER",$J,2,6)=1
 Q
 ;
QD7 ; ER CONSULTANT TYPE
 S AMERRUN=9
 N AMERSNO,AMERO,AMERDEL,AMERREM,AMERSTOP,DIC,DIR
 S AMERSNO=1,AMERO=0,AMERREM=0,AMERSTOP=""
 F  S AMERO=$O(^TMP("AMER",$J,2,7,AMERO)) Q:'AMERO  S AMERSNO=AMERSNO+1
 F  Q:AMERSTOP="^"  D
 .S AMERREM=0
 .S DIC="^AMER(2.9,",DIC(0)="AMEQ",Y="",DIC("S")="I $P(^(0),U,2)="""""
 .S AMEROPT="",DIC("A")="*CONSULTANT SERVICE: "
 .S DIC("B")=$P($G(^TMP("AMER",$J,2,7,1)),U,2)
 .D ^DIC
 .I X="",AMERSNO=1 D
 ..S AMERO=0
 ..S AMERO=$O(^TMP("AMER",$J,2,7,AMERO))
 ..I AMERO="" K ^TMP("AMER",$J,2,7) D EN^DDIOL("No ER CONSULTANT notified","","!!")
 ..S AMERSTOP="^"
 ..Q
 .I X?2."^" S DIROUT="",AMERSTOP="^"
 .I "^"[$E(X) S AMERSTOP="^",AMERRUN=9 Q
 .S ^TMP("AMER",$J,2,7,AMERSNO)=Y
 .S ^TMP("AMER",$J,2,7,AMERSNO,.01)=+Y
 .S AMERO=0
 .F  S AMERO=$O(^TMP("AMER",$J,2,7,AMERO)) Q:'AMERO  D
 ..I AMERO'=AMERSNO&($P($G(^TMP("AMER",$J,2,7,AMERO)),U,1)=+Y)  D  ;DUPLICATE ENTRY
 ...K ^TMP("AMER",$J,2,7,AMERSNO)  ;WE JUST ADDED A DUPLICATE TO THE TEMP GLOBAL AND WE WANT IT GONE
 ...S AMERREM=$$REM()
 ...K:AMERREM ^TMP("AMER",$J,2,7,AMERO) ;IF USER ANSWERS YES, DELETE THE ORIGINAL ENTRY
 ...Q
 ..Q
 .Q:AMERREM=1
 .I $E(X)=U S AMERQUIT="",AMERRUN=9 Q
 .D QD8 ;to set time
 .;Get name
 .I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT S AMERSTOP="^" Q
 .K DIC("B")
 .I $G(^TMP("AMER",$J,2,7,AMERSNO,.03)) S DIC("B")=^TMP("AMER",$J,2,7,AMERSNO,.03)
 .S DIC("A")="*CONSULTANT NAME: "
 .S DIC="^VA(200,",DIC(0)="AEQ"
 .S DIC("?")="Only active providers can be selected"
 .;screening so that only valid PCC providers identified
 .S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 .D ^DIC K DIC
 .;IHS/OIT/SCR 5/11/09 - REQUIRE CONSULTANT TIME AND NAME OR REMOVE ENTRY
 .;I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT S AMERSTOP="^" Q
 .I $D(DUOUT)!$D(DTOUT)!(Y<0) D  Q
 ..K DUOUT,DTOUT S AMERSTOP="^"
 ..K ^TMP("AMER",$J,2,7,AMERSNO)
 ..D EN^DDIOL("No Provider Identified!","","!!")
 ..D EN^DDIOL("Consultant Entry not saved","","!")
 ..Q
 .S:Y>0 ^TMP("AMER",$J,2,7,AMERSNO,.03)=+Y,^TMP("AMER",$J,2,7,AMERSNO)=$G(^TMP("AMER",$J,2,7,AMERSNO))_"^"_Y
 .S DIR("A")="*Was another CONSULTANT notified"
 .S DIR(0)="Y",DIR("B")="NO"
 .D ^DIR
 .I Y=1 D
 ..S AMERSNO=AMERSNO+1,AMEROPT="",AMERSTOP=""
 ..F  S AMERO=$O(^TMP("AMER",$J,2,7,AMERO)) Q:'AMERO  S AMERSNO=AMERSNO+1
 ..Q
 .E  S AMERSTOP="^"
 .Q
 ;if there are no ER CONSUTANTS entered, make sure ER CONSULTANT notified field is NO
 K AMERSNO,AMERO,AMERDEL,AMERREM,AMERSTOP,DIC,DIR
 Q
 ;
QD8 ; ER CONSULTANT TIME
 N Y,DIR
 I $G(^TMP("AMER",$J,2,7,AMERSNO,.02)) S Y=^TMP("AMER",$J,2,7,AMERSNO,.02) X ^DD("DD") S DIR("B")=Y
 ;S DIR(0)="DO^::ER",DIR("A")="*What time did the patient see this CONSULTANT"
 S DIR(0)="D^::ER",DIR("A")="*What time did the patient see this CONSULTANT"   ;IHS/OIT/SCR 050509 Patch 1
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)"
 D ^DIR K DIR
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD8
 I Y,$$TVAL^AMER2A($G(^TMP("AMER",$J,1,2)),Y,4) K Y G QD8
 E  D
 .S ^TMP("AMER",$J,2,7,AMERSNO,.02)=Y
 .S ^TMP("AMER",$J,2,7,AMERSNO)=$G(^TMP("AMER",$J,2,7,AMERSNO))_"^"_Y
 Q
 ;
REM(AMERO)  ;
 S DIR("A")="This consultant type has already been identified. Do you want to remove it"
 S DIR(0)="Y",DIR("B")="NO"
 D ^DIR
 I Y=1 Q 1
 Q 0
 ;
TCK(Z,T,X,A) ; TIME CHECK WHERE Z=TIME,T=COMPARISON TIME,X=1:AFTER,X=0:BEFORE AND A=NARRATIVE
 N %,Y
 I $G(Z)=""!($G(A)="") Q ""
 S Y=Z X ^DD("DD")
 I X,T>Z Q 0
 I 'X,T<Z Q 0
 W !!,*7,"Sorry, this time must be ",$S(X:"AFTER",1:"BEFORE")," the time of ",A,": ",Y,!,"Please try again...",! Q 1
 ;
PREV W !,"You have already selected =>",!
 F %=0:0 S %=$O(^TMP("AMER",$J,2,4,%)) Q:'%  W ?3,$P(^(%),U,2),!
 Q
 ;
PICK ;
 D CHECK^AMER1A I '$D(^AMERADM("B")) S AMERQUIT="" Q
 Q:$D(AMERQUIT)  ;IHS/OIT/SCR 10/14/09 patch 2 beta1
PQ S B="" I I=1 S B=1
 ;PQ S B=""  ;IHS/OIT/SCR patch 2
 S DIR(0)="N",DIR("A")="Select ER patient" S:B DIR("B")=B
 D ^DIR I $D(DTOUT)!$D(DUOUT) S X=U E  S X=Y
 K DIR,Y,DTOUT,DUOUT
 I $E(X)=U S AMERQUIT="" Q
 I X?1."?" S X="??"
 I X="",B'="" S X=1
 I X=+X,$D(^TMP("AMER TEMP",$J,X)) S %=$O(^(X,"")) I % S X="`"_% W "  ",$P($G(^DPT(%,0)),U)
 S DIC="^DPT(",DIC(0)="EQS",DIC("S")="I $D(^AMERADM(Y))"
 S AMERI=I D ^DIC S I=AMERI D OUT^AMER
 K AMERI,DIC,D,B,X,%
 I $D(AMERQUIT) Q
 I Y=-1 G PQ
 S AMERDFN=+Y
 Q
