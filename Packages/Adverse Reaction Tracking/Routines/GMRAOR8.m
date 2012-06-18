GMRAOR8 ;HIRMFO/WAA-OERR HL7 UTILITY ;18-Mar-2011 11:45;DU
 ;;4.0;Adverse Reaction Tracking;**4,1002**;Mar 29, 1996;Build 32
 ;IHS/MSC/MGH Added inassessibility subroutines
COMM(GMRAPA,GMRAL) ;Add comments
 ;INPUT
 ;  GMRAPA = The entry in file 120.8 that is being modified
 ;   GMRAL = The entry in the GMRAL array that is being added
 ;
 N GMRASN,GMRASNN
E S GMRASN=0 F  S GMRASN=$O(GMRAL(GMRAL,"N",GMRASN)) D  Q:GMRASN<1
 .I GMRASN<1 S GMRASN=$O(GMRAL(GMRAL,"N",""),-1),^GMR(120.8,GMRAPA,26,0)=U_"120.826D"_U_GMRASN_U_GMRASN S GMRASN="" Q
 .N GMRALN
 .S ^GMR(120.8,GMRAPA,26,GMRASN,0)=$P(GMRAL(GMRAL),U,5)_U_$P(GMRAL(GMRAL),U,7)_U_"O"
 .I $G(GMRAL(GMRAL,"N",GMRASN,1))'="" S GMRASNN="" F  S GMRASNN=$O(GMRAL(GMRAL,"N",GMRASN,GMRASNN)) D  Q:GMRASNN<1
 ..I GMRASNN<1 S GMRASNN=$O(GMRAL(GMRAL,"N",GMRASN,""),-1),^GMR(120.8,GMRAPA,26,GMRASN,2,0)=U_U_GMRASNN_U_GMRASNN S GMRASNN="" Q
 ..S ^GMR(120.8,GMRAPA,26,GMRASN,2,GMRASNN,0)=GMRAL(GMRAL,"N",GMRASN,GMRASNN)
 ..Q
 .Q
 Q
UNASS ;EP Add an entry that the patient cannot be assessed for allergies
 N GMRAOUT,GMRA,DFN
 S GMRAOUT=0
 W @IOF D PAT^GMRAPAT ; Select A Patient
 D:'GMRAOUT ASSESS G:'GMRAOUT UNASS
 K DFN,DIC,GMRAOUT,GMRARET,GMA,GMRAUSER
 D EN1^GMRAKILL
 Q
ASSESS ;
 D REACT^GMRAPAT(DFN)
 N DIR,DIR
 S DIR("A")="Do you want to mark this patient as being unable to assess for allergies?"
 S DIR(0)="Y",DIR("B")="NO",DIR("?")="Enter Y to mark this pt as unassessable, otherwise enter NO"
 D ^DIR I Y=1 D SET(DFN)
 Q
SET(DFN) ;Set the field and mark as unassessable
 N VAL,REASON,DATA,COMMENT
 S (COMMENT,REASON)=""
 D REA
 I REASON'="" D
 .I $P(REASON,U,2)="OTHER" D RCOM
 .S VAL("GMRAACC")=$$NOW^XLFDT
 .S VAL("GMRAACRE")=$P(REASON,U,1)
 .I COMMENT'="" S $P(VAL("GMRAACRE"),U,4)=COMMENT
 .S VAL("GMRAACCBY")=DUZ
 .D ASSESS^BEHOARMU(.DATA,"",DFN,.VAL)
 .I +DATA W !,"Patient has been marked unasessable" D HANGT^GMRAPEH0 G UNASS
 E  W !,"You must enter a reason pt is unassessable" D HANGT^GMRAPEH0 G UNASS
 Q
REA ;GET THE REASON
 N DA,DIC,DR,Y
 S DIC=90460.05
 S DIC(0)="AEMQ"
 S DIC("S")="I $P(^(0),U,2)=""A"""
 S DIC("A")="Select reason: "
 D ^DIC
 I $D(DUOUT) K DUOUT Q
 I Y<1 G REA
 S REASON=Y
 Q
RCOM ;GET THE COMMENT
 N Y,DIR
 S DIR(0)="F^3:30"
 S DIR("A")="Enter Other Reason: "
 D ^DIR I $D(DIRUT) K DIRUT G RCOM
 S COMMENT=Y
 Q
