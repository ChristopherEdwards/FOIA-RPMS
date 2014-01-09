ABMNARRQ ; IHS/SD/SDR - Require Narrative by insurer ;  
 ;;2.6;IHS Third Party Billing;**9**;NOV 12, 2009
EN ;EP
 W !!?5,"An insurer and a list of CPT/HCPCS codes will be prompted for."
 W !?5,"Any codes entered for that insurer will send a NARRATIVE of "
 W !?5,"""NOT OTHERWISE CLASSIFIED"" in the 5010 Professional/Institutional"
 W !?5,"export.  If no narrative is entered, an error will display in the claim"
 W !?5,"editor.",!!
 ;
SELINS ;select insurer
 K DIC,DIE,DIR,X,Y,DA
 S DIC="^AUTNINS("
 S DIC(0)="AEQM"
 S DIC("A")="Select INSURER: "
 D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)
 I +Y<0 G SELINS
 S ABMP("INS")=+Y
 ;
 ;For selected insurer, display list of CPTs (if any) entered w/status
 W !!?2,"Current Codes",?18,"Req'd?"
 S ABMCPT=0
 F  S ABMCPT=$O(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT)) Q:+ABMCPT=0  D
 .S ABMCNT=+$G(ABMCNT)+1
 .W !?2,$P($$CPT^ABMCVAPI($P($G(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT,0)),U),DT),U,2),?18,$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT,0)),U,2)="Y":"YES",1:"NO")
 W !
 I +$G(ABMCNT)=0 W !?3,"No entries at this time"
 W !
 ;
 ;prompt for new codes
 F  D  Q:+$G(Y)<0
 .K DIC,DIE,DIR,X,Y,DA
 .S DA(1)=ABMP("INS")
 .S DIC(0)="AEQLM"
 .S DIC="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 .S DIC("A")="Enter CPT/HCPCS codes: "
 .S DIC("P")=$P(^DD(9002274.09,5,0),U,2)
 .S DIC("DR")=".02"
 .D ^DIC
 .Q:Y<0
 .S ABMIEN=Y
 .I $P(ABMIEN,U,3)'=1 D
 ..K DIC,DIE,DIR,X,Y,DA
 ..S DA(1)=ABMP("INS")
 ..S DA=+ABMIEN
 ..S DIE="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 ..S DR=".01//;.02//"
 ..D ^DIE
 Q
