ABMDELOO ; IHS/ASDST/DMJ - Claim Looping Utility ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/LSL 03/20/98 Set ABMPERM("EDITOR") when looping
 ;             through flagged as billable cross-reference to 
 ;             avoid user being kicked out to menu.
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option
 ;
 K ABM,ABMP,ABMPP,DIC,ABMX,ABMV,ABMZ,ABMC,ABMU,ABML,DIROUT,DIRUT,DTOUT,DUOUT
 I $P($G(^ABMDPARM(DUZ(2),1,0)),"^",15)'="Y" D  Q
 .W !!?5,*7,"ACCESS to the CLAIM EDITOR is DENIED until SITE PARAMETERS file",!?5,"has been Reviewed!"
 .S DIR(0)="E" D ^DIR K DIR
 S ABMPERM("EDITOR")=1
 ;
 ;   var def: ABMPP("STATUS") is defined as the status for looping
 ;              where: 0 - looping is active
 ;                     1 - looping is completed
 ;                     2 - looping is terminated
 ;
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
 D ^ABMDESEL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABMPP("STATUS")=0
 S ABMPP("CLM")=0 F  S ABMPP("CLM")=$O(^ABMDCLM(DUZ(2),"AS","O",ABMPP("CLM"))) D  Q:ABMPP("STATUS")
 .I 'ABMPP("CLM") S ABMPP("STATUS")=1 Q
 .S ABMP("HIT")=0,ABM=ABMPP("CLM") D ^ABMDECHK K ABM Q:'ABMP("HIT")
 .W !!,"LOOPING through CLAIMS with a Status of ROLLED-In Edit Mode...."
 .S ABMPERM("EDITOR")=1
 .S ABMP("CDFN")=ABMPP("CLM") D EXT^ABMDE
 .Q:ABMPP("STATUS")=2
 .D ASK
 G XIT:ABMPP("STATUS")'=1
 S ABMPP("STATUS")=0,ABMPP("TIME1")=$P($H,",",2)
 S ABMPP("CLM")=0 F  S ABMPP("CLM")=$O(^ABMDCLM(DUZ(2),"AS","E",ABMPP("CLM"))) D  Q:ABMPP("STATUS")
 .I $D(ABMPP("TIME1")) S ABMPP("TIME2")=$P($H,",",2) I ABMPP("TIME2")-ABMPP("TIME1")>5 D WAIT^DICD S ABMPP("TIME1")=ABMPP("TIME2")
 .I 'ABMPP("CLM") S ABMPP("STATUS")=1 Q
 .S ABMP("HIT")=0,ABM=ABMPP("CLM") D ^ABMDECHK K ABM Q:'ABMP("HIT")
 .K ABMPP("TIME1")
 .W !!,"LOOPING through CLAIMS with a Status of IN EDIT MODE...."
 .S ABMPERM("EDITOR")=1
 .S ABMP("CDFN")=ABMPP("CLM") D EXT^ABMDE
 .Q:ABMPP("STATUS")=2
 .D ASK
 .S ABMPP("TIME1")=$P($H,",",2)
 G XIT:ABMPP("STATUS")'=1
 ;
 S ABMPP("STATUS")=0
 S ABMPP("CLM")=0 F  S ABMPP("CLM")=$O(^ABMDCLM(DUZ(2),"AS","F",ABMPP("CLM"))) D  Q:ABMPP("STATUS")
 .I 'ABMPP("CLM") S ABMPP("STATUS")=1 Q
 .S ABMP("HIT")=0,ABM=ABMPP("CLM") D ^ABMDECHK K ABM Q:'ABMP("HIT")
 .W !!,"LOOPING through CLAIMS with a Status of FLAGGED AS BILLABLE...."
 .S ABMPERM("EDITOR")=1
 .S ABMP("CDFN")=ABMPP("CLM") D EXT^ABMDE
 .Q:ABMPP("STATUS")=2
 .I ABMPP("STATUS") D ASK
TT G XIT
 ;
ASK G LOOP:'$D(^XUSEC("ABMDZ MANAGEMENT",DUZ))!'ABMPP("STATUS")
 K DIR W !! S DIR(0)="SO^1:CONTINUE LOOPING;2:DELETE CLAIM;3:QUIT"
 S DIR("A")="Desired ACTION",DIR("B")=1
 D ^DIR K DIR
 I Y'=2 S ABMPP("STATUS")=$S(Y'=1:2,1:0) Q
 S ABMP("CDFN")=ABMPP("CLM") D ENT^ABMDECAN
 ;
LOOP W ! K DIR S DIR(0)="YO",DIR("A")="Want to Continue LOOPING (Y/N)",DIR("B")="Y" D ^DIR S ABMPP("STATUS")=$S($G(Y):0,1:2)
 Q
 ;
XIT K ABMPP
 Q
