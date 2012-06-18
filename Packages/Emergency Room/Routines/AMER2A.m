AMER2A ; IHS/ANMC/GIS -ISC - OVERFLOW FROM AMER2 ;  
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
QD20 ; CLINIC TYPE
 N AMERLINE,%
 I '$D(AMERMAND),'$D(AMEREFLG),'$D(^TMP("AMER",$J,2,20)),'$D(AMERBCH) D
 .S %="",$P(%,"~",80)="",AMERLINE=%
 .W @IOF,"ER ADMISSION FOR ",$P(^DPT(AMERDFN,0),U),"    ^ = back up    ^^ = quit"
 .W !,"Questions preceded by a '*' are MANDATORY.  Enter '??' to see choices."
 .W !,AMERLINE,!
 .Q
QD20A ;
 N AMERPCC,X,AMERLOC,AMERCLN,AMERTYP
 S X=""
 S DIC("A")="*Clinic type (EMERGENCY or URGENT): " K DIC("B")
 ;S DIC("B")="EMERGENCY MEDICINE"
 ;IHS/OIT/SCR 2/20/09 - DEFAULT TO WALK IN CLINIC THAT IS IDENTIFIED IN ERS SITE PREFERENCES FILE
 S AMERLOC=0,AMERLOC=$O(^AMER(2.5,AMERLOC))
 I AMERLOC="" D
 .W !,"SITE PARAMETERS have not been set up in the ERS PARAMETER option"
 .W !,"Please contact your ERS Supervisors to complete this option before using the EMERGENCY ROOM system"
 .S X="^^"
 .Q
 I AMERLOC'="" D
 .S AMERCLN=$G(^AMER(2.5,AMERLOC,"SD"))
 .I AMERCLN="" D
 ..W !,"WALK IN CLINC has not been set up in the ERS PARAMETER option"
 ..W !,"Please contact your ERS Supervisors to identify a CLINIC before using the EMERGENCY ROOM system"
 ..S X="^^"
 ..Q
 .I AMERCLN'="" D
 ..S AMERTYP=$P(^SC(AMERCLN,0),"^",7)  ;THIS STOP CODE NUMBER - POINTER TO STOP CODE FILE (30 OR 60)
 ..S DIC("B")=AMERTYP
 ..S AMERPCC=$$EXISTING^AMERPCC(AMERDFN)
 ..S:AMERPCC>0 DIC("B")=$$GET1^DIQ(9000010,AMERPCC,.08)
 ..I $D(^TMP("AMER",$J,2,20)) S %=+^(20),DIC("B")=$P(^AMER(3,%,0),U)  ;clinic code
 ..S DIC="^AMER(3,"
 ..S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("CLINIC TYPE")
 ..S DIC(0)="AEQ"
 ..D ^DIC K DIC
 ..I X=U,'$D(AMERBCH),'$D(AMEREFLG) S X="^^"
 ..I X=U,$D(AMEREFLG) S AMERTFLG=""
 ..I X=U Q
 ..Q
 .Q
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD21 ; PROVIDER
 ;IHS/OIT/SCR 10/31/08 don't ask if we are in TRIAGE
 ;IHS/OIT/SCR 01/06/09 WHERE OH WHERE DOES THIS Y COME FROM?
 ;Q:$G(AMERTRG)=1
 I $G(AMERTRG)=1 D  Q
 .S Y=-1
 .Q
 ;S DIC("A")="*Admitting physician: " K DIC("B")
 ;IHS/OIT/SCR 01/20/09 - removed asterik since this is no longer considered mandatory
 S DIC("A")="Admitting physician: " K DIC("B")
 S DIC("?")="Only active providers can be selected"
 ;I $D(^TMP("AMER",$J,2,21)) S %=+^(21),DIC("B")=$P(^VA(200,%,0),U)
 I $D(^TMP("AMER",$J,2,21))&&($G(^TMP("AMER",$J,2,21))>1) S %=+^(21),DIC("B")=$P(^VA(200,%,0),U)
 S DIC="^VA(200,",DIC(0)="AEQM"
 ;screening so that only valid PCC providers identified
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 I $G(Y)'>0 K ^TMP("AMER",$J,2,24)
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD22 ; TRIAGE NURSE
 S DIC("A")="*Triage nurse: " K DIC("B")
 I $D(^TMP("AMER",$J,2,22)) S %=+^(22),DIC("B")=$P(^VA(200,%,0),U)
 S DIC("?")="Only active providers can be selected"
 S DIC="^VA(200,",DIC(0)="AEQM"
 ;screening so that only valid PCC providers identified
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 I $G(Y)'>0 K ^TMP("AMER",$J,2,25)
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD23 ; INITIAL TRIAGE
 S DIR("B")=$G(^TMP("AMER",$J,2,23))
 S DIR("?")="Enter a number from 1 to 5"
 S DIR("?",1)="This is a site-specified value that indicates severity of visit"
 S DIR(0)="N^1:5:0",DIR("A")="*Enter initial triage assessment from RN" KILL DA D ^DIR KILL DIR
 D OUT^AMER I X=U Q
 I '$D(^TMP("AMER",$J,2,21)),'$D(^(22)),'$G(^TMP("AMER",$J,1,21)),'$D(AMEREFLG) S AMERSTRT=1,AMERFIN=27,AMERRUN=$S('$D(AMERTRG):1,$D(AMERTRG):30) Q
 I '$D(^TMP("AMER",$J,2,22)),$D(^(21)) S AMERRUN=24 Q
 I '$D(^TMP("AMER",$J,2,22)) S AMERRUN=25
 Q
 ;
QD24 ; TRIAGE TIME
 I $D(^TMP("AMER",$J,2,24)) S Y=^(24) X ^DD("DD") S DIR("B")=Y
 ;IHS/OIT/SCR 01/20/09 field no longer manditory
 ;S DIR(0)="DO^::ER",DIR("A")="What time did the patient see the triage nurse",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 S DIR(0)="D^::ER",DIR("A")="*What time did the patient see the triage nurse",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 I Y,$$TCK($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD24
 I Y,$$TVAL($G(^TMP("AMER",$J,1,2)),Y,2) K Y G QD24
 I Y="" S Y=-1
 D OUT^AMER I X?1."^" Q
 I '$D(^TMP("AMER",$J,2,21)),'$G(^TMP("AMER",$J,1,21)),'$D(AMEREFLG) S AMERFIN=27,AMERSTRT=1,AMERRUN=$S('$D(AMERTRG):1,$D(AMERTRG):30,1:1) Q
 I '$D(^TMP("AMER",$J,2,21)) S AMERRUN=25 Q
 Q
 ;
QD25 ; DOC TIME
 ;IHS/OIT/SCR 10/31/08 DON'T ASK DOC TIME IF WE ARE USING TRIAGE OPTION
 ;Q:$G(AMERTRG)=1
 I $G(AMERTRG)=1 D  Q
 .S Y=-1
 .Q
 ;IHS/OIT/SCR 11/21/08 don't default the doc time in OUT
 ;I $D(^TMP("AMER",$J,2,25)) S Y=^(25) X ^DD("DD") S DIR("B")=Y
 S DIR(0)="D^::ER",DIR("A")="*What time did the patient see the admitting doctor",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 I Y,$$TCK($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD25
 I Y,$$TCK($G(^TMP("AMER",$J,2,24)),Y,1,"triage") K Y G QD25
 I Y,$$TVAL($G(^TMP("AMER",$J,1,2)),Y,4) K Y G QD25
 I Y="" S Y=-1
 Q:Y=-1
 D OUT^AMER I X?1."^" Q
 I '$G(^TMP("AMER",$J,1,21)),'$D(AMEREFLG) S AMERFIN=27,AMERSTRT=1,AMERRUN=$S('$D(AMERTRG):1,$D(AMERTRG):30,1:1) Q
 I '$D(AMERTRG) S AMERRUN=1
 I $D(AMEREFLG) S AMERRUN=30
 Q
 ;
TCK(Z,T,X,A) ; ENTRY POINT FROM AMER2
 ; TIME CHECK WHERE Z=TIME,T=COMPARISON TIME,X=1:AFTER,X=0:BEFORE AND A=NARRATIVE
 N %,Y
 I $G(Z)=""!($G(A)="") Q ""
 S Y=Z X ^DD("DD")
 I X,T'<Z Q 0
 I 'X,T<Z Q 0
 W !!,*7,"Sorry, this time must be ",$S(X:"AFTER",1:"BEFORE")," the time of ",A,": ",Y,!,"Please try again...",! Q 1
 ;
TVAL(Z,T,H) ; ENTRY POINT FROM AMER2 and multiple editing routines
 ; VALIDATE THE TIME WHERE Z=TIME,T=COMPARISON TIME AND H=MAX HOURS ALLOWED
 N A,B,C,D,X,%H,%T,%Y,%,E,F,Y
 S Y=Z X ^DD("DD")
 S X=Z D H^%DTC S A=%H,B=%T
 S X=T D H^%DTC S C=%H,D=%T
 S E=C-A*60*60*24+D
 S F=(E-B)\(3600)
 I F<H Q 0
 S %=2 W !!,*7,"This means a really long delay since the time of admission: ",Y,!,"Are you sure" D YN^DICN W !
 I %=1 Q 0
 Q 1
