AMEREDTE ; IHS/OIT/SCR - SUB-ROUTINE FOR ER VISIT EDIT of ER CONSULTANTS
 ;;3.0;ER VISIT SYSTEM;**1**;FEB 23, 2009
 ;
 ; VARIABLES: The following variables are passed to multiple editing routines
 ;  AMERDA  : the IEN of the ER VISIT that is selected for editing
 ;  AMERAIEN: The IEN of the ER AUDIT that is created when user begins editing a record
 ;  AMEREDNO: An integer representing the number of multiple fields that have been edited
 ;            for uniqueness in multiple field number in audit file
 ;
 ; Edit Auditing VARIABLES newed and used throughout edit routines:
 ;      AMEROLD : original value of edited field
 ;      AMERNEW : new value of edited field
 ;      AMERSTRG : A ";" deliminated string of edit information for a field   
 ;
EDTCNSLT(AMERDA,AMEREDNO,AMERAIEN) ;EP from AMEREDIT 
 ; Called when "er consultants" is selected for editing
 ; INPUT:
 ;   AMERDA : the IEN of the ER VISIT that is selected for editing
 ; AMEREDNO : an incremented number used for uniqueness in audit file
 ; AMERAIEN : The IEN of the ER AUDIT that is created when user begins editing a record
 ; 
 I '$D(^XUSEC("AMERZ9999",DUZ)) D EN^DDIOL("You are not authorized to use this option","","!!") Q 1  ;PROGRAMATICALLY LOCKING this option to holders of the coding key
 N AMERCSLT,AMERCNO,AMERCTM,AMERDOC,AMERTIME,AMERNEW,AMEROLD,AMEREDTS,AMERSTRG
 N AMERSKIP,AMERTIME,AMERNAME,AMERQUIT
 N DIC,DIE,Y,Y1,DR,DIR
 S (AMERNEW,AMEROLD,AMEREDTS,AMERSTRG,DR,AMERCSLT,AMERDOC,AMERTIME)=""
 S AMERQUIT=0
 I $P($G(^AMERVSIT(AMERDA,19,0)),U,4)'="" D
 .Q:$P($G(^AMERVSIT(AMERDA,19,0)),U,4)=0
 .S AMERCSLT=$O(^AMERVSIT(AMERDA,19,"B",0))
 .I AMERCSLT'="" D
 ..S AMERDOC=$G(^AMER(2.9,AMERCSLT,0))
 ..D EN^DDIOL("The following ER CONSULTANT types and times have been entered","","!")
 ..D DSPCONS(AMERDA)
 ..Q
 .Q
 I $P($G(^AMERVSIT(AMERDA,19,0)),U,4)=""  D
 .D EN^DDIOL("There are currently no ER CONSULTANTS associated to this visit","","!!")
 .S DIR(0)="Y",DIR("A")="Do you want to add an ER CONSUTLANT",DIR("B")="NO"
 .D ^DIR K DIR
 .I Y=0 D
 ..I $P($G(^AMERVSIT(AMERDA,0)),U,22)=1 D SYNCH ;BUT first be sure flag is correct
 ..S AMERQUIT=1
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 Q:AMERQUIT 1 ;if user answered "NO", leave
 D EN^DDIOL("","","!")
 F  Q:AMERQUIT=1  D
 .K DIC("B")
 .S DIC="^AMER(2.9,",DIC(0)="AMEQ",Y=""
 .S DIC("S")="I $P(^(0),U,2)="""""
 .;S DIC("A")="Edit/Enter "_$S(AMERDOC'="":"another ",1:"")_"ER CONSULTANT TYPE: "
 .S DIC("A")="Edit/Enter ER CONSULTANT TYPE: "
 .D ^DIC K DIC
 .I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1 Q
 .S AMERCSLT=$P($G(Y),U,1)
 .I AMERCSLT>0 D
 ..S AMEREDNO=AMEREDNO+1
 ..;First look to see if that ER CONSULTANT has already been entered
 ..;if it has, we give the user a chance to delete it or edit it
 ..I '$$EDTCONS(AMERDA,AMERAIEN,AMERCSLT) D
 ...;returns 1 if record was found and either edited or deleted
 ...S AMERNEW=AMERCSLT
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("19-01"_"."_AMEREDNO,"",$$EDDISPL^AMEREDAU(AMERNEW,"E"),"ER CONSULTANTS")
 ...I AMERSTRG="^" S AMERQUIT=1 Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S DA(1)=AMERDA,DIC="^AMERVSIT(DA(1),19,",DIC(0)="L"
 ...S X="`"_AMERCSLT
 ...D ^DIC
 ...S DIE=DIC,DA(1)=AMERDA,DA=+Y
 ...S AMERCNO=+Y  ;IHS/OIT/SCR 5/11/09
 ...K DIC
 ...K DIR("B")
 ...;IHS/OIT/SCR 11/21/08 - date should be optional
 ...;IHS/OIT/SCR 5/11/09  - date should NOT be optional
 ...;S DIR(0)="DO^::ER",DIR("A")="Date and time of ER CONSULTANT"
 ...S DIR(0)="D^::ET",DIR("A")="Date and time of ER CONSULTANT"
 ...S DIR("?")="Enter date and time in the usual Fileman format (e.g. 1/1/2000@1PM)"
 ...D ^DIR K DIR
 ...I $D(DUOUT)!$D(DTOUT) D  Q
 ....S AMERQUIT=1
 ....D EN^DDIOL("No time identified","","!!")
 ....I $$DELETE(AMERDA,AMERCNO)
 ....D EN^DDIOL("Not adding consultant record","","!!")
 ....Q
 ...S AMERTIME=Y
 ...I AMERTIME'="" S DR=$S(DR'="":DR_";",1:""),DR=DR_".02////"_AMERTIME
 ...S DIC="^VA(200,",DIC(0)="AEQ",DIC("A")="ER CONSULTANT Name: "
 ...;screening so that only valid PCC providers identified
 ...S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 ...D ^DIC
 ...I Y>0 S DR=$S(DR'="":DR_";",1:""),DR=DR_".03////"_+Y
 ...;IHS/OIT/SCR 05/11/09 - DELETE RECORD if no consultant is identified
 ...I +Y<0 D  Q
 ....S DR=""
 ....D EN^DDIOL("No provider identified.","","!")
 ....I $$DELETE(AMERDA,AMERCNO)
 ....D EN^DDIOL("Not adding consultant record","","!!")
 ....Q
 ...;IHS/OIT/SCR 05/11/09 - DELETE RECORD if no consultant is identified
 ...I DR'="" D
 ....D MULTDIE^AMEREDIT(DIE,DA,DA(1),DR)
 ....Q
 ...D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)  ;only populate edit log with original record
 ...Q
 ..I AMERQUIT S (DR,AMEREDTS)="",AMERQUIT=0 Q
 ..Q
 .E  S AMERQUIT=1
 .Q
 D SYNCH  ;be sure ER CONSULT flag is in synch with modifications
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 K AMERCSLT,AMERCNO,AMERCTM,AMERDOC,AMERTIME,AMERNEW,AMEROLD,AMEREDTS,AMERSTRG
 Q 1
 ;
DSPCONS(AMERDA)  ; EP from AMERTIME
 ; DISPLAYS the ER CONSULTANT data for an ER VIST
 N AMERCNO,AMERTIME,AMERNAME,Y,Y1
 S AMERCNO=0
 F  S AMERCNO=$O(^AMERVSIT(AMERDA,19,AMERCNO)) Q:AMERCNO="B"  D
 .S Y=$G(^AMERVSIT(AMERDA,19,AMERCNO,0)),Y1=$G(^AMER(2.9,$P(Y,U,1),0)) ;Y is the IEN, Y1 is the description
 .S AMERTIME=$P(Y,U,2)
 .S AMERNAME=$P(Y,U,3)
 .S:AMERNAME'="" AMERNAME=$P($G(^VA(200,AMERNAME,0)),U,1)
 .S Y=AMERTIME
 .D DD^%DT
 .D EN^DDIOL(Y1_"  @  "_Y_"  "_AMERNAME,"","!!")
 .Q
 Q
 ; 
EDTCONS(AMERDA,AMERAIEN,AMERCSLT)  ;
 ;RETURNS 1 IF CONSULTANT RECORD HAS BEEN EDITED OR DELETED
 ;        0 OTHERWISE
 N AMERCNO,AMEROLD,AMERNEW,AMERNAME,AMERTIME,AMERSTRG,AMEREDTS,AMERQUIT,AMERFND
 N DR
 S (AMEREDTS,DR)=""
 S (AMERCNO,AMERQUIT,AMERFND)=0,AMEROLD=AMERCSLT
 F  S AMERCNO=$O(^AMERVSIT(AMERDA,19,AMERCNO)) Q:AMERCNO="B"!(AMERCNO="")  I $P($G(^AMERVSIT(AMERDA,19,AMERCNO,0)),U,1)=AMERCSLT D
 .S AMERFND=1
 .S Y=$P($G(^AMERVSIT(AMERDA,19,AMERCNO,0)),U,2)
 .S AMERTIME=Y ; Keep time in original format for default
 .D DD^%DT
 .S AMERNAME=$P($G(^AMERVSIT(AMERDA,19,AMERCNO,0)),U,3)
 .S:AMERNAME'="" AMERNAME=$P($G(^VA(200,AMERNAME)),U,1)
 .D EN^DDIOL("CONSULTANT TYPE : "_$G(^AMER(2.9,AMERCSLT,0))_"  "_Y_"  "_AMERNAME,"","!!")
 .I $$DELCONS(AMERDA,AMERCNO) D  ;ER CONSULTANT RECORD HAS BEEN DELETED
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("19-01"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMEROLD,"E"),"","ER CONSULTANTS")
 ..I AMERSTRG="^" S AMERQUIT=1 Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..Q
 .E  D  ;ER CONSULTANT record has NOT been deleted
 ..;TIME or PERSON can be edited
 ..;IHS/OIT/SCR 11/21/08 time is not mandatory
 ..;S DIR(0)="D^::ER",DIR("A")="Date and time of ER CONSULTANT"
 ..S DIR(0)="DO^::ER",DIR("A")="Date and time of ER CONSULTANT"
 ..;IHS/OIT/SCR 5/11/09 time is  mandatory
 ..S DIR(0)="D^::ER",DIR("A")="Date and time of ER CONSULTANT"
 ..S AMEROLD=AMERTIME
 ..I AMERTIME'="" S Y=AMERTIME D DD^%DT S DIR("B")=Y
 ..S DIR("?")="Enter date and time in the usual Fileman format (e.g. 1/1/2000@1PM)"
 ..D ^DIR K DIR
 ..;I $D(DUOUT)!$D(DTOUT) S AMERQUIT=1 Q
 ..I $D(DUOUT)!$D(DTOUT) D  Q
 ...S AMERQUIT=1
 ...S DR=""
 ...D EN^DDIOL("No time identified","","!!")
 ...I $$DELETE(AMERDA,AMERCNO)
 ...D EN^DDIOL("REMOVING consultant record","","!!")
 ...Q
 ..S (AMERTIME,AMERNEW)=Y
 ..I AMEROLD'=AMERNEW D
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("19-02"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMEROLD,"D"),$$EDDISPL^AMEREDAU(AMERNEW,"D"),"ER CONSULTANT TIME")
 ...I AMERSTRG="^" S AMERQUIT=1 Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S DR=$S(DR'="":DR_";",1:""),DR=DR_".02////"_AMERNEW
 ...Q
 ..;Now allow editing of NEW PERSON identified
 ..S DIC="^VA(200,",DIC(0)="AEQ",DIC("A")="ER CONSULTANT Name: "
 ..;screening so that only valid PCC providers identified
 ..S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 ..S AMERNAME=$P($G(^AMERVSIT(AMERDA,19,AMERCNO,0)),U,3)
 ..I AMERNAME'="" S (AMEROLD,DIC("B"))=AMERNAME
 ..E  S AMEROLD=""
 ..D ^DIC
 ..I $D(DUOUT)!$D(DTOUT) S Y="^" Q
 ..I +Y>0 S (AMERNAME,AMERNEW)=+Y
 ..;IHS/OIT/SCR 05/11/09 - DELETE RECORD if no consultant is identified
 ..;E  S AMERNEW=""
 ..I +Y<0 D  Q
 ...S DR=""
 ...D EN^DDIOL("No provider identified.","","!")
 ...I $$DELETE(AMERDA,AMERCNO)
 ...D EN^DDIOL("Deleting Consultant record","","!!")
 ...Q
 ..;IHS/OIT/SCR 05/11/09 - DELETE RECORD if no consultant is identified
 ..I AMEROLD'=AMERNEW D
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("19-03"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMEROLD,"N"),$$EDDISPL^AMEREDAU(AMERNEW,"N"),"ER CONSULTANT NAME")
 ...I AMERSTRG="^" S AMERQUIT=1 Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S DR=$S(DR'="":DR_";",1:""),DR=DR_".03////"_+Y
 ...Q
 ..Q
 .S DIE="^AMERVSIT(DA(1),19,",DA(1)=AMERDA,DA=AMERCNO
 .I DR'="" D
 ..D MULTDIE^AMEREDIT(DIE,DA,DA(1),DR)
 ..Q
 .D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)  ;only populate edit log with original record
 .S (DR,AMEREDTS)=""
 .Q
 Q AMERFND
 ;
DELCONS(IEN,SUBIEN)  ;
 N DIR,DIK
 S DIR(0)="Y",DIR("A")="Do you want to delete this ER CONSULTANT",DIR("B")="NO"
 D ^DIR K DIR
 I $G(Y)>0 D
 .S DA(1)=IEN,DA=SUBIEN
 .S DIK="^AMERVSIT(DA(1),19,"
 .D ^DIK,EN^DIK  ;Delete identified entry
 .K DIK
 .Q
 E  Q 0
 Q 1
 ;
SYNCH ;
 ;SYNCH "ER CONSULTANT NOTIFIED" WITH ER CONSULTANT MULTIPLE FIELD
 I $P($G(^AMERVSIT(AMERDA,19,0)),U,4)>0 S DR=".22///1"
 E  S DR="22.///0"
 D DIE^AMEREDIT(AMERDA,DR)
 Q
DELETE(IEN,SUBIEN)  ;
 S DA(1)=IEN,DA=SUBIEN
 S DIK="^AMERVSIT(DA(1),19,"
 D ^DIK,EN^DIK  ;Delete identified entry
 K DIK
 Q 1
